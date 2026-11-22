import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arabic_universe/screens/grammar_lesson_screen.dart';
import 'package:arabic_universe/screens/sense_course_screen.dart';
import 'package:arabic_universe/services/script_sync.dart';

String sha(String s) => sha1.convert(utf8.encode(s)).toString().substring(0, 12);

/// 문법 스텝 · 내용은 서버 원고(사용자 지시 2026-11-23 「DB 업데이트로 스텝이 늘어날 수도 줄어들 수도」). 서버 못 받으면 묶음 목록.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('grammar_steps'));
  tearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  final lesson1 = File('assets/data/grammar/lesson1.json').readAsStringSync();
  final sense = File('assets/data/grammar/sense_course.json').readAsStringSync();
  Map<String, dynamic> base() => {
        'rev': 2,
        'files': {'grammar/lesson1.json': sha(lesson1), 'grammar/sense_course.json': sha(sense)},
      };

  ScriptSync server(Map<String, String> files) {
    Future<String?> fetch(String url) async {
      if (url.endsWith('/index.json')) return json.encode({'rev': 3, 'files': {for (final e in files.entries) e.key: sha(e.value)}});
      for (final e in files.entries) {
        if (url.contains(e.key)) return e.value;
      }
      return null;
    }

    return ScriptSync.forTest(dir: dir, fetch: fetch, baseline: base());
  }

  test('서버가 없으면 앱 안 것 — 문법 강의 1 · 언어감각 10스텝', () async {
    final s = ScriptSync.forTest(dir: dir, fetch: (_) async => null, baseline: base());
    await s.refresh();
    expect((await GrammarLesson.loadAll(sync: s)).map((l) => l.number), [1]);
    expect(((await SenseCourse.load(sync: s))['levels'] as List).length, 10);
  });

  test('서버에만 있는 스텝은 나타나고, 서버 것이 앱 안 것을 덮는다', () async {
    final l17 = json.encode({'lesson': 17, 'title': '새 스텝', 'patterns': [{'id': 'p', 'examples': []}]});
    final l4empty = json.encode({'lesson': 4, 'title': '빈 스텝', 'patterns': []});
    final d = json.decode(sense) as Map<String, dynamic>;
    (d['levels'] as List).first['title'] = '서버 제목';
    final newSense = json.encode(d);
    final s = server({'grammar/lesson1.json': lesson1, 'grammar/lesson17.json': l17, 'grammar/lesson4.json': l4empty, 'grammar/sense_course.json': newSense});
    expect(await s.refresh(), isTrue);
    final ls = await GrammarLesson.loadAll(sync: s);
    expect(ls.map((l) => l.number), [1, 17]); // 빈 스텝 4 는 숨김, 15 를 넘어도 나타남
    expect(ls.last.title, '새 스텝');
    expect(((await SenseCourse.load(sync: s))['levels'] as List).first['title'], '서버 제목');
  });

  test('서버 목록에서 뺀 스텝은 숨는다', () async {
    final s = server({'grammar/sense_course.json': sense});
    await s.refresh();
    expect(await GrammarLesson.loadAll(sync: s), isEmpty);
  });

  test('언어감각 — 내용 없는 스텝·회차는 숨기고, 개수는 데이터 그대로(상한 없음)', () {
    final d = {
      'levels': [
        {'id': 'L1', 'title': 'a', 'lessons': [{'id': 'L1-talk', 'kind': 'memorize', 'sentences': [{'ar': 'x', 'ko': 'y'}]}, {'id': 'L1-ref', 'kind': 'ref', 'points': []}]},
        {'id': 'L2', 'title': '빈 스텝', 'lessons': [{'id': 'L2-talk', 'kind': 'memorize', 'sentences': []}]},
        {'id': 'L3', 'title': '참고만', 'lessons': [{'id': 'L3-ref', 'kind': 'ref', 'points': [{'head': 'h'}]}]},
        for (var i = 4; i <= 14; i++)
          {'id': 'L$i', 'title': '$i', 'lessons': [{'id': 'L$i-talk', 'kind': 'memorize', 'sentences': [{'ar': 'x', 'ko': 'y'}]}]},
      ],
    };
    final v = SenseCourse.visibleLevels(d);
    expect(v.first['id'], 'L1');
    expect((v.first['lessons'] as List).length, 1); // 빈 참고 회차 숨김
    expect(v.map((l) => l['id']), isNot(contains('L2')));
    expect(v.map((l) => l['id']), isNot(contains('L3')));
    expect(v.length, 12); // L1 + L4~L14
  });
}
