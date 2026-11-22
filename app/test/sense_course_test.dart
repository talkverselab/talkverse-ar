import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arabic_universe/screens/sense_course_screen.dart';

void main() {
  test('언어감각 원고 — 10급, 급마다 외울 대화 10줄 + 참고, 표시 번호가 양쪽 같음', () {
    final d = json.decode(File('assets/data/grammar/sense_course.json').readAsStringSync()) as Map<String, dynamic>;
    final levels = (d['levels'] as List).cast<Map<String, dynamic>>();
    expect(levels.length, 10);
    final mark = RegExp(r'\{([^|}]+)\|(\d+)\}');
    for (final lv in levels) {
      final ls = (lv['lessons'] as List).cast<Map<String, dynamic>>();
      expect(ls.map((l) => l['kind']), ['memorize', 'ref']);
      final ss = (ls[0]['sentences'] as List).cast<Map<String, dynamic>>();
      expect(ss.length, 10);
      for (final s in ss) {
        expect({for (final m in mark.allMatches(s['ar'] as String)) m.group(2)}, {for (final m in mark.allMatches(s['ko'] as String)) m.group(2)});
        expect(plainMarked(s['ar'] as String).contains('{'), isFalse);
        expect((s['rd'] as String).isNotEmpty, isTrue);
      }
    }
  });

  testWidgets('색 표시 — 같은 번호는 같은 색', (t) async {
    final a = markedSpans('فين {شنطتك|2}؟', const TextStyle()), b = markedSpans('{네 가방|2} 어딨어?', const TextStyle());
    expect((a[1] as TextSpan).style!.color, (b[0] as TextSpan).style!.color);
  });

  for (final w in [390.0, 300.0]) {
    testWidgets('외울 대화 화면 — 폭 $w 에서 넘침 없음', (t) async {
      t.view.physicalSize = Size(w, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: SenseLessonScreen(index: 0)));
      for (var i = 0; i < 20; i++) {
        await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
        await t.pump();
      }
      expect(find.textContaining('شنطة', findRichText: true), findsWidgets);
      expect(t.takeException(), isNull);
    });
  }
}
