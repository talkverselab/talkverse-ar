import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/favorite_words.dart';
import '../data/grammar_progress.dart';
import '../data/user_stats.dart';
import '../config/language_registry.dart';
import '../data/word_data.dart';
import '../data/word_reviews.dart';
import '../models/word.dart';
import '../services/adult_gate_service.dart';
import '../services/language_service.dart';
import '../services/subscription_service.dart';
import '../services/tier_service.dart';
import '../theme/app_colors.dart';
import '../widgets/language_hero_image.dart';
import 'admin_screen.dart';
import 'adult_hub_screen.dart';
import 'ar_affix_game_screen.dart';
import 'ar_alphabet_screen.dart';
import 'conversation_screen.dart';
import 'favorites_screen.dart';
import 'flashcard_screen.dart';
import 'grammar_screen.dart';
import 'profile_screen.dart';
import 'hanzi_list_screen.dart';
import 'keyboard_screen.dart';
import 'package:talkverse/flavors/th/screens/lao_bonus_screen.dart';
import 'my_alphabet_screen.dart';
import 'course_select_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _goTo(Widget screen) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  /// 미드나잇 라운지 아래 부록 언어 진입 wide 카드들. 데이터 있을 때만 노출.
  /// 현재 등록: th → lo (라오어 보너스).
  List<Widget> _buildAppendixBonusCards() {
    final mainLang = LanguageService.instance.code.value;
    final cards = <Widget>[];
    for (final appLang in LanguageRegistry.appendicesFor(mainLang)) {
      final pool = appendixPool(appLang);
      if (pool.isEmpty) continue;
      final profile = LanguageRegistry.forCode(appLang);
      cards.add(Padding(
        padding: const EdgeInsets.only(top: 12),
        child: _WideMenuCard(
          icon: Icons.public,
          title: '${profile.flagEmoji} ${profile.nameKo} 보너스',
          subtitle: '${pool.length}개 항목',
          color: const Color(0xFF1B4F8C), // 라오 네이비 (Decision 32)
          onTap: () => _goTo(LaoBonusScreen(appendixLang: appLang)),
        ),
      ));
    }
    return cards;
  }

  /// 키보드 연습 picker — "course × type" 4개를 다른 메뉴와 동일한 2×2 그리드로.
  /// 부록 언어는 별도 진입 (홈 미드나잇 아래 LaoBonusScreen).
  Future<void> _showKeyboardPicker(BuildContext context) async {
    final mainLang = LanguageService.instance.code.value;
    final options = <({String emoji, String label, int course, ItemType type})>[
      (emoji: '🌱', label: 'L1 단어 (필수)', course: 1, type: ItemType.word),
      (emoji: '🌱', label: 'L1 회화 (필수)', course: 1, type: ItemType.sentence),
      (emoji: '💬', label: 'L2 단어 (채팅)', course: 2, type: ItemType.word),
      (emoji: '💬', label: 'L2 회화 (채팅)', course: 2, type: ItemType.sentence),
    ];
    final pool = keyboardPool();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('⌨️ 키보드 연습',
                  style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              // count 0 카드는 숨김 — 빈 항목 노출 안 함.
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: options
                    .map((o) => (
                          opt: o,
                          count: pool
                              .where((w) =>
                                  w.course == o.course &&
                                  w.type == o.type &&
                                  w.id.startsWith('$mainLang:'))
                              .length,
                        ))
                    .where((entry) => entry.count > 0)
                    .map((entry) {
                  final o = entry.opt;
                  final count = entry.count;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _goTo(KeyboardScreen(
                          course: o.course, itemType: o.type));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppConfig.brandColor.withValues(alpha: 0.35),
                            width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(o.emoji,
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(o.label,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('$count개 항목',
                              style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final due = WordReviews().reviewDueCount(flashcardPool());
    final favs = FavoriteWords().count;
    final reviewTotal = due + favs;

    final squareCards = <Widget>[
      _SquareMenuCard(
        icon: Icons.menu_book_rounded,
        title: '문법',
        subtitle: '읽기만 하세요',
        color: AppColors.purpleDark,
        onTap: () => _goTo(const GrammarScreen()),
      ),
      _SquareMenuCard(
        icon: Icons.menu_book_outlined,
        title: '단어 외우기',
        subtitle: '플래시카드 암기',
        color: AppConfig.brandColor,
        onTap: () => _goTo(CourseSelectScreen(
          title: '📚 단어 외우기',
          allPool: flashcardPoolAll(),
          onPicked: (course) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FlashCardScreen(course: course)),
            );
          },
        )),
      ),
      if (AppConfig.hasHanjaSupport)
        _SquareMenuCard(
          icon: Icons.translate_outlined,
          title: AppConfig.hanjaMenuTitle.replaceFirst('🀄 ', ''),
          subtitle: '부수 중심',
          color: const Color(0xFFB8860B), // 다크 골드 — warning 보다 전문성 ↑
          onTap: () => _goTo(const HanziListScreen()),
        ),
      if (AppConfig.hasArabicAlphabetMenu)
        _SquareMenuCard(
          icon: Icons.abc_outlined,
          title: '아라비아 알파벳',
          subtitle: '사알투무니하 10자',
          color: AppColors.brandAr,
          onTap: () => _goTo(const ArAlphabetScreen()),
        ),
      if (AppConfig.hasArabicAffixGameMenu)
        _SquareMenuCard(
          icon: Icons.extension_outlined,
          title: '접사 게임',
          subtitle: '명사 파생 5 패턴',
          color: AppColors.brandAr,
          onTap: () => _goTo(const ArAffixGameScreen()),
        ),
      if (AppConfig.hasMyanmarAlphabetMenu)
        _SquareMenuCard(
          icon: Icons.abc_outlined,
          title: '미얀마 알파벳',
          subtitle: '자음·모음·톤·결합',
          color: AppColors.brandMy,
          onTap: () => _goTo(const MyAlphabetScreen()),
        ),
      _SquareMenuCard(
        icon: Icons.keyboard_outlined,
        title: '키보드 연습',
        subtitle: AppConfig.keyboardMenuSubtitle,
        color: AppColors.successDark,
        onTap: () => _showKeyboardPicker(context),
      ),
      _SquareMenuCard(
        icon: Icons.chat_bubble_outline_rounded,
        title: '회화 공부',
        subtitle: '상황별 회화',
        color: AppColors.purpleDark,
        onTap: () => _goTo(CourseSelectScreen(
          title: '💬 회화 공부',
          allPool: conversationPoolAll(),
          showWordCompletion: true,
          showAppendices: true, // id → ms, th → lo 등 부록 카드 노출
          onPicked: (course) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ConversationScreen(course: course)),
            );
          },
        )),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 우측 아이콘 바 (즐겨찾기 / 통계 / 내 정보)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.favorite_border,
                            color: AppColors.textSecondary),
                        if (FavoriteWords().count > 0)
                          Positioned(
                            right: -4,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${FavoriteWords().count}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                    tooltip: '다시 외우기',
                    onPressed: () => _goTo(const FavoritesScreen()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bar_chart,
                        color: AppColors.textSecondary),
                    tooltip: '통계',
                    onPressed: () => _goTo(const StatsScreen()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline,
                        color: AppColors.textSecondary),
                    tooltip: '내 정보',
                    onPressed: () => _goTo(const ProfileScreen()),
                  ),
                ],
              ),
              // 히어로 (작게) + 학습목표 같은 행에 배치
              const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LanguageHeroImage(size: 140),
                    SizedBox(width: 12),
                    Expanded(child: _StreakGoalCard()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // 언어별 region 토글. 현재 활성 언어가 vi/es일 때만 한 줄 표시.
              const _VietnameseRegionToggle(),
              const _VietnameseScenarioPicker(),
              const _SpanishRegionToggle(),
              const SizedBox(height: 8),
              // 난이도 선택 — 모든 메뉴(단어/회화/키보드/Midnight) 의 콘텐츠를
              // 이 tier 로 필터링. 변경 시 즉시 반영.
              const _TierSelector(),
              const SizedBox(height: 12),
              // 복습 — 미드나잇라운지와 동일한 wide 카드. tier 아래 위치.
              _WideMenuCard(
                icon: Icons.refresh_rounded,
                title: '🔁 복습',
                subtitle:
                    reviewTotal > 0 ? '$reviewTotal개 대기' : '학습하면 여기에',
                color: AppColors.dangerDark,
                onTap: () =>
                    _goTo(const FlashCardScreen(reviewMode: true)),
              ),
              const SizedBox(height: 12),
              // 2열 메뉴 그리드 (문법/단어외우기/키보드/회화). 약간 가로로 더 길게(1.15)
              // — 정사각형보다 살짝 짧아져 화면 밀도 증가.
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: squareCards,
              ),
              // 성인 콘텐츠
              ValueListenableBuilder<bool>(
                valueListenable: AdultGateService.instance.unlocked,
                builder: (context, unlocked, _) {
                  if (!unlocked) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _WideMenuCard(
                      icon: Icons.wine_bar,
                      title: '🍷 Midnight Lounge',
                      subtitle: '19+ · 친밀·경계·어른의 뉘앙스',
                      color: AppColors.midnightBurgundy,
                      onTap: () => _goTo(const AdultHubScreen()),
                    ),
                  );
                },
              ),
              // 부록 언어 보너스 카드 — 미드나잇 라운지 아래 (Decision 41)
              // 메콩권 패턴: TH 앱 → LO 라오어 보너스 챕터.
              // 데이터가 있을 때만 노출. 진입 시 별도 LaoBonusScreen 으로 전환.
              ..._buildAppendixBonusCards(),
              // 관리자 전용 (풀너비 — 사용자 명시 예외)
              ValueListenableBuilder<bool>(
                valueListenable:
                    SubscriptionService.instance.isAdminListenable,
                builder: (context, isAdmin, _) {
                  if (!isAdmin) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _WideMenuCard(
                      icon: Icons.admin_panel_settings_outlined,
                      title: '개발자 메뉴',
                      subtitle: '커리큘럼 편집 (관리자 전용)',
                      color: AppColors.textPrimary,
                      onTap: () => _goTo(const AdminScreen()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakGoalCard extends StatelessWidget {
  const _StreakGoalCard();

  @override
  Widget build(BuildContext context) {
    final stats = UserStats();
    final streak = stats.currentStreak;
    final today = stats.todayCount;
    final goal = stats.dailyGoal;
    final progress = stats.todayProgress;
    final reached = stats.goalReached;

    return AnimatedBuilder(
      animation: GrammarProgress.instance,
      builder: (context, _) {
        final lang = AppConfig.languageCode;
        final gDay =
            GrammarProgress.instance.accumulatedCompletedDay(lang);
        final gFrac =
            GrammarProgress.instance.progressFraction(lang);
        final gTotal = GrammarProgress.instance.totalDaysFor(lang);

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    streak > 0 ? '🔥' : '💤',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      streak > 0 ? '$streak일 연속' : '오늘 시작해요',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 문법 읽기 달성률 (누적 Day)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📖 문법 읽기',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                  Text(
                    gDay >= gTotal
                        ? '✅ $gDay/$gTotal'
                        : '$gDay / $gTotal',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: gDay >= gTotal
                          ? AppColors.successDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: gFrac,
                  minHeight: 6,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      gDay >= gTotal
                          ? AppColors.success
                          : AppColors.purpleDark),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '오늘 목표',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                  Text(
                    reached ? '✅ $today/$goal' : '$today / $goal',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: reached
                          ? AppColors.successDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      reached ? AppColors.success : AppConfig.brandColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 2열 그리드용 정사각형 메뉴 카드. 아웃라인 스타일:
///   * 배경 = 순백
///   * 테두리 = 포인트 컬러 (1.5px)
///   * 아이콘·제목 = 포인트 컬러
///   * 부제 = 서브 텍스트 회색
///
/// 색 구분은 선·글자·아이콘 색으로만 일관되게.
class _SquareMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SquareMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 풀너비 가로 카드 — 개발자 메뉴·성인 콘텐츠용. 아웃라인 스타일.
class _WideMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _WideMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}

/// 베트남어 전용 — 북부/남부 방언 토글.
/// 다른 언어에서는 SizedBox.shrink (보이지 않음).
class _VietnameseRegionToggle extends StatelessWidget {
  const _VietnameseRegionToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.instance.code,
      builder: (context, langCode, _) {
        if (langCode != 'vi') return const SizedBox.shrink();
        return ValueListenableBuilder<String>(
          valueListenable: LanguageService.instance.viRegion,
          builder: (context, region, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RegionPill(
                    label: '🇻🇳 북부 (하노이)',
                    selected: region == 'north',
                    onTap: () =>
                        LanguageService.instance.setViRegion('north'),
                  ),
                  const SizedBox(width: 4),
                  _RegionPill(
                    label: '🇻🇳 남부 (호치민)',
                    selected: region == 'south',
                    onTap: () =>
                        LanguageService.instance.setViRegion('south'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// 베트남어 전용 — 호칭 시나리오 (1~5) 선택 dropdown.
/// `{{self}}/{{other}}` placeholder 가 박힌 row 의 호칭 치환에 사용됨.
/// 다른 언어에서는 SizedBox.shrink (보이지 않음).
class _VietnameseScenarioPicker extends StatelessWidget {
  const _VietnameseScenarioPicker();

  static const List<({int id, String label})> _options = [
    (id: 1, label: '여 연하 → 남 연상 (em → anh)'),
    (id: 2, label: '여 연하 → 여 연상 (em → chị)'),
    (id: 3, label: '남 연하 → 남 연상 (em → anh)'),
    (id: 4, label: '남 연하 → 여 연상 (em → chị)'),
    (id: 5, label: '동년배 친구 (tớ → cậu)'),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.instance.code,
      builder: (context, langCode, _) {
        if (langCode != 'vi') return const SizedBox.shrink();
        return ValueListenableBuilder<int>(
          valueListenable: LanguageService.instance.viScenario,
          builder: (context, scenario, _) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const Text('🗣️ 호칭 ', style: TextStyle(fontSize: 13)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: scenario,
                        isDense: true,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textPrimary),
                        items: _options
                            .map((o) => DropdownMenuItem(
                                  value: o.id,
                                  child: Text('${o.id}. ${o.label}'),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            LanguageService.instance.setViScenario(v);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// 스페인어 전용 — 라틴(멕시코) / 스페인(이베리아) 발음·어휘 토글.
/// 다른 언어에서는 SizedBox.shrink (보이지 않음).
class _SpanishRegionToggle extends StatelessWidget {
  const _SpanishRegionToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.instance.code,
      builder: (context, langCode, _) {
        if (langCode != 'es') return const SizedBox.shrink();
        return ValueListenableBuilder<String>(
          valueListenable: LanguageService.instance.esRegion,
          builder: (context, region, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RegionPill(
                    label: '🇲🇽 남미 발음',
                    selected: region == 'latam',
                    onTap: () =>
                        LanguageService.instance.setEsRegion('latam'),
                  ),
                  const SizedBox(width: 4),
                  _RegionPill(
                    label: '🇪🇸 스페인 발음',
                    selected: region == 'spain',
                    onTap: () =>
                        LanguageService.instance.setEsRegion('spain'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _RegionPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RegionPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppConfig.brandColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// 홈 상단 난이도 selector. 3 버튼 (초/중/고). 선택 즉시 TierService 갱신 →
/// 모든 메뉴(단어외우기/회화공부/키보드/Midnight) 의 pool 함수가 새 tier 로 필터.
/// VLB 가 selector 자체만 rebuild — 다운스트림 화면은 next-tap 시 fresh pool.
class _TierSelector extends StatelessWidget {
  const _TierSelector();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WordTier>(
      valueListenable: TierService.instance.tier,
      builder: (context, selected, _) {
        return Row(
          children: WordTier.values.map((t) {
            final isActive = t == selected;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => TierService.instance.setTier(t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive ? AppConfig.brandColor : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? AppConfig.brandColor
                            : AppColors.cardBorder,
                        width: 1.5,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppConfig.brandColor
                                    .withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.emoji,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          t.label,
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

