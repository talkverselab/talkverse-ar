import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabic_universe/screens/curriculum_screen.dart';

void main() {
  testWidgets('커리큘럼: 레벨 고르기 → 코스 만들기 → 추천으로 채우기', (t) async {
    SharedPreferences.setMockInitialValues({});
    await t.pumpWidget(const MaterialApp(home: CurriculumScreen()));
    await t.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    await t.pumpAndSettle();
    expect(find.text('레벨 고르기'), findsOneWidget);
    await t.tap(find.textContaining('R0 ·'));
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
    await t.pumpAndSettle();
    expect(find.text('코스 만들기'), findsOneWidget);
    await t.tap(find.text('추천으로 채우기'));
    await t.pumpAndSettle();
    expect(find.textContaining('코스 시작 ('), findsOneWidget);
  });
}
