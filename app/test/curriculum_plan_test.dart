import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabic_universe/services/curriculum_service.dart';
import 'package:arabic_universe/services/dialogue_service.dart';

/// 커리큘럼 §12 — 단계 1~5 를 JSON(묶음 → 서버 rev 높으면 그것)에서, 편 0개 단계 숨김, 앱에 없는 편 건너뜀, 옛 R 값 → 단계.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('cur_plan'));
  tearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  final bundled = File('assets/curriculum_ar.json').readAsStringSync();

  test('묶음 JSON — 5단계, 편 id 가 모두 앱 편', () {
    final p = CurriculumPlan.parse(bundled)!;
    expect(p.stages.map((s) => s.key), ['1', '2', '3', '4', '5']);
    expect(p.prep, isEmpty); // ar 은 JLPT/HSK 칸 없음
    final ids = <String>{
      for (final f in Directory('assets/data/dialogues').listSync(recursive: true).whereType<File>())
        if (RegExp(r'/R\d/').hasMatch(f.path)) (json.decode(f.readAsStringSync()) as Map)['id'] as String,
    };
    for (final s in p.stages) {
      expect(ids.containsAll(s.dialogueIds), isTrue, reason: s.key);
    }
  });

  test('서버 rev 가 높으면 받아 두고 다음부터 그것, 낮거나 404 면 그대로', () async {
    final cache = File('${dir.path}/c.json');
    final d = json.decode(bundled) as Map<String, dynamic>;
    final newer = json.encode({...d, 'rev': (d['rev'] as int) + 1, 'stages': [(d['stages'] as List).first]});
    expect(await CurriculumPlan.fetchNewer(1, fetch: (_) async => null, cache: cache), isNull);
    expect(await CurriculumPlan.fetchNewer(99, fetch: (_) async => newer, cache: cache), isNull);
    final got = await CurriculumPlan.fetchNewer(d['rev'] as int, fetch: (_) async => newer, cache: cache);
    expect(got!.stages.length, 1);
    final local = await CurriculumPlan.loadLocal(bundled: bundled, cache: cache);
    expect(local!.rev, (d['rev'] as int) + 1);
    expect(await CurriculumPlan.loadLocal(bundled: 'broken', cache: File('${dir.path}/none.json')), isNull);
  });

  test('앱에 없는 편은 건너뛰고, 편이 0개인 단계는 숨김 · 옛 R 값은 단계로', () async {
    SharedPreferences.setMockInitialValues({});
    final svc = CurriculumService.instance;
    await svc.ensureLoaded();
    final real = DialogueService.instance.list().first.id;
    svc.plan = CurriculumPlan(9, [
      CurStage('1', '1단계', '', [real, 'no_such_ep']),
      CurStage('2', '2단계', '', ['no_such_ep']),
    ], const []);
    expect(svc.levels, ['1']);
    expect(svc.levelList('1').map((d) => d.id), [real]);
    expect(svc.nextLevel('1'), isNull);
    svc.plan = null; // JSON 실패 → 회화 레벨 기본 대응
    expect(svc.levels, isNotEmpty);
    expect(svc.levels.every((k) => ['1', '2', '3', '4', '5'].contains(k)), isTrue);
    expect(CurriculumState.fromJson({'level': 'R0'}).level, '1');
    expect(CurriculumState.fromJson({'level': 'R3'}).level, '3');
    expect(CurriculumState.fromJson({'level': 2}).level, '2');
  });

  test('§12 덧붙임 — pick·pass·daily 를 JSON 에서, 없으면 3·5·10 / 80 / 1·2·3', () async {
    final p = CurriculumPlan.parse(json.encode({
      'rev': 3,
      'stages': [
        {'n': 1, 'title': '첫 단계', 'desc': 'd', 'dialogueIds': ['a'], 'pick': [2, 4], 'pass': 70, 'daily': {'light': 2, 'normal': 3, 'focus': 5}},
        {'n': 2, 'dialogueIds': ['b']},
      ],
    }))!;
    expect(p.stages[0].pick, [2, 4]);
    expect(p.stages[0].pass, 70);
    expect(p.stages[0].daily, [2, 3, 5]);
    expect(p.stages[0].title, '첫 단계');
    expect(p.stages[1].pick, [3, 5, 10]);
    expect(p.stages[1].pass, 80);
    expect(p.stages[1].daily, [1, 2, 3]);
    expect(p.stages[1].title, '2단계');

    SharedPreferences.setMockInitialValues({});
    final svc = CurriculumService.instance;
    await svc.ensureLoaded();
    final real = DialogueService.instance.list().first.id;
    svc.plan = CurriculumPlan(9, [CurStage('1', 't', '', [real], pick: const [2, 4], pass: 70, daily: const [2, 3, 5])], const []);
    svc.state = CurriculumState(level: '1', dailyGoal: 3, course: Course('c', [real]));
    svc.applyStage();
    expect(svc.passPercent(), 70);
    expect(svc.pickCounts(), [2, 4]);
    expect(svc.state.newLeft('2026-11-23'), 5);
    expect(svc.state.recordExam(7, 10, {}, '2026-11-23', pass: svc.passPercent()), isTrue); // 70% 통과
    expect(isPass(7, 10), isFalse); // 기본 80
  });
}
