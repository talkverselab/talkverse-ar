import 'package:arabic_universe/screens/about_screen.dart';
import 'package:arabic_universe/screens/profile_screen.dart';
import 'package:arabic_universe/screens/word_freq_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 2026-11-07 개편 화면이 폰·아이패드 칸 너비에서 넘치지 않는지(넘치면 레이아웃 오류로 실패한다).
void main() {
  const sizes = {'폰': Size(360, 740), '아이패드 오른쪽 칸': Size(560, 1000), '아이패드 전체': Size(1180, 820)};

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    rootBundle.clear(); // 앞 테스트의 영역에 묶인 캐시 Future 는 다음 테스트에서 끝나지 않는다
  });

  Future<void> show(WidgetTester t, Size size, Widget home, {Finder? ready}) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(home: home));
    for (var i = 0; i < 40; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 250)));
      await t.pump();
      if (ready == null || ready.evaluate().isNotEmpty) break;
    }
  }

  for (final e in sizes.entries) {
    testWidgets('절벽 단어 · ${e.key}', (t) async {
      await show(t, e.value, const WordFreqScreen(), ready: find.text('1단원'));
      expect(find.text('1단원'), findsOneWidget);
      expect(find.textContaining('회화 단어 포함'), findsOneWidget);
      await t.tap(find.textContaining('회화 단어 포함'));
      await t.pump();
      expect(find.text('1단원'), findsOneWidget);
    });

    testWidgets('앱 소개 · ${e.key}', (t) async {
      await show(t, e.value, const AboutScreen());
      expect(find.text('1. 단어 기준'), findsOneWidget);
      expect(find.text('513-2000'), findsOneWidget);
    });

    testWidgets('프로필 · ${e.key}', (t) async {
      await show(t, e.value, const ProfileScreen());
      expect(find.text('앱 업데이트'), findsNothing);
      expect(find.text('계정'), findsWidgets);
    });
  }
}
