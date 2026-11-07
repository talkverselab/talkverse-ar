// 아이패드 두 화면 + 만화책 읽기형 회화 확인용 스크린샷 흐름 — 2026-11-02(일본어앱 dialogue_pane_test 를 옮김).
// 실행: python3 tools/pane_shots.py <아이패드 UDID> <출력폴더> integration_test/dialogue_pane_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arabic_universe/core/l10n.dart';
import 'package:arabic_universe/data/db/app_database.dart';
import 'package:arabic_universe/data/db/seed_loader.dart';
import 'package:arabic_universe/main.dart';
import 'package:arabic_universe/services/achievement_service.dart';
import 'package:arabic_universe/services/ko_reading.dart';
import 'package:arabic_universe/services/learner_prefs.dart';
import 'package:arabic_universe/widgets/glyph_sheet.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> wait(WidgetTester t, int ms) async {
    final end = DateTime.now().add(Duration(milliseconds: ms));
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 100));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester t, String name) async {
    await wait(t, 2000);
    // ignore: avoid_print
    print('SHOT:$name');
    await wait(t, 3000);
  }

  Finder rail(String label) => find.descendant(of: find.byType(NavigationRail), matching: find.text(label));

  testWidgets('dialogue pane', timeout: const Timeout(Duration(minutes: 10)), (t) async {
    appDb = AppDatabase();
    await SeedLoader(appDb).seedIfNeeded();
    await KoReadingPrefs.load();
    await AppLangPrefs.load();
    await LearnerPrefs.load();
    await AchievementService.instance.load();
    await t.pumpWidget(const GermanUniverseApp());
    await wait(t, 1500);
    await shot(t, '01_home_wide');

    await t.ensureVisible(find.text('주제별 회화').first);
    await wait(t, 500);
    await t.tap(find.text('주제별 회화').first);
    await wait(t, 2500);
    await shot(t, '02_dialogue_home_right');

    await t.tap(find.text('생활').first);
    await wait(t, 1200);
    await shot(t, '03_topic_list');

    await t.tap(find.text('카페').first);
    await wait(t, 1500);
    await shot(t, '04_reader');

    // 글자 시트(UX 시안 AR-01 ①): 캡션의 아랍어 줄 낱말 탭
    // RTL 이라 첫 낱말은 오른쪽 끝 — 가운데를 누르면 낱말 사이 빈칸에 걸릴 수 있다
    final firstWord = t.getTopRight(find.byType(TappableArabicText).first).translate(-14, 14);
    await t.longPressAt(firstWord);
    await wait(t, 1500);
    await shot(t, '04b_glyph_sheet');
    Navigator.of(t.element(find.byType(GlyphSheet))).pop();
    await wait(t, 1000);

    // 낱말 탭 = 단어창(단어장에 없으면 글자 시트)
    await t.tapAt(firstWord);
    await wait(t, 1500);
    await shot(t, '04c_word_sheet');
    Navigator.of(t.element(find.byType(BottomSheet))).pop();
    await wait(t, 1000);

    await t.tap(find.text('재생').first);
    await wait(t, 6000);
    await shot(t, '05_reader_playing');

    await t.tap(find.byTooltip('그림 카드(글자 없이)'));
    await wait(t, 1500);
    await shot(t, '06_card_front');
    await t.tap(find.text('탭해서 확인'));
    await wait(t, 800);
    await shot(t, '07_card_back');
    await t.pageBack();
    await wait(t, 1200);

    await t.tap(rail('진행'));
    await wait(t, 1500);
    await shot(t, '08_progress_achievements');

    await t.tap(rail('프로필'));
    await wait(t, 1500);
    await shot(t, '09_profile');

    await t.tap(rail('배우기'));
    await wait(t, 1500);
    await t.ensureVisible(find.text('절벽 단어 R1~R5').first);
    await wait(t, 500);
    await shot(t, '10_menu_sections');
    await t.tap(find.text('절벽 단어 R1~R5').first);
    await wait(t, 3000);
    await shot(t, '11_cliff_words');
    await t.tap(find.textContaining('회화 단어 포함').first);
    await wait(t, 800);
    await t.tap(find.text('회화').last);
    await wait(t, 1200);
    await shot(t, '12_conv_words');
    await t.tap(find.byTooltip('독음 표시').first);
    await wait(t, 800);
    await shot(t, '13_reading_on');
    await t.tap(find.byTooltip('독음 숨기기').first);
    await wait(t, 500);

    await t.tap(rail('앱 소개'));
    await wait(t, 1500);
    await shot(t, '14_about');
  });
}
