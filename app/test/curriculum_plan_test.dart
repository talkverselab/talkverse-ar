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
    expect(await CurriculumPlan.fetchNewer(5, fetch: (_) async => newer, cache: cache), isNull);
    final got = await CurriculumPlan.fetchNewer(1, fetch: (_) async => newer, cache: cache);
    expect(got!.stages.length, 1);
    final local = await CurriculumPlan.loadLocal(bundled: bundled, cache: cache);
    expect(local!.rev, 2);
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
}
