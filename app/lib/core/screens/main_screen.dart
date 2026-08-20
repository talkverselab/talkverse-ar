import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../data/favorite_words.dart';
import '../data/user_stats.dart';
import '../data/word_data.dart';
import '../data/word_reviews.dart';
import '../models/word.dart';
import '../services/adult_gate_service.dart';
import '../services/language_service.dart';
import '../services/subscription_service.dart';
import '../services/tier_service.dart';
import '../theme/app_colors.dart';
import '../theme/ar_theme.dart';
import '../widgets/arabic_decor.dart';
import 'admin_screen.dart';
import 'adult_hub_screen.dart';
import 'ar_affix_game_screen.dart';
import 'ar_alphabet_screen.dart';
import 'conversation_screen.dart';
import 'course_select_screen.dart';
import 'favorites_screen.dart';
import 'flashcard_screen.dart';
import 'grammar_screen.dart';
import 'keyboard_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';

/// 앱 루트 — zh 앱과 동일한 4탭 구조 (홈 / 학습 / 진행 / 프로필).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const List<NavigationDestination> _tabs = [
    NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: '홈'),
    NavigationDestination(
        icon: Icon(Icons.menu_book_outlined),
        selectedIcon: Icon(Icons.menu_book),
        label: '학습'),
    NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart),
        label: '진행'),
    NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: '프로필'),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const HomeTab(),
      const LearnTab(),
      const ProgressScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _tabs,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
// 공용 헬퍼 — 코스별 단어 숙달 통계 / 키보드 picker
// ────────────────────────────────────────────────────────────────────────

/// "알아요" 3회 이상(+1주 간격 도달) 단어를 숙달로 간주 — CourseSelectScreen 과 동일 기준.
const int kMasteredStageFloor = 3;

({int total, int mastered}) courseWordStats(int course) {
  final reviews = WordReviews();
  var total = 0;
  var mastered = 0;
  for (final w in flashcardPoolAll()) {
    if (w.type != ItemType.word || w.course != course) continue;
    total++;
    if (reviews.stageOf(w.id) >= kMasteredStageFloor) mastered++;
  }
  return (total: total, mastered: mastered);
}

/// ⌨️ 키보드 연습 picker — 기존 버전의 "course × type" 4개 메뉴를 그대로 유지.
/// (L1 단어 / L1 회화 / L2 단어 / L2 회화, 항목 0개인 카드는 숨김)
Future<void> showKeyboardPicker(BuildContext context) async {
  final mainLang = LanguageService.instance.code.value;
  final options = <({String seal, String label, int course, ItemType type})>[
    (seal: '١', label: 'L1 단어 (필수)', course: 1, type: ItemType.word),
    (seal: '١', label: 'L1 회화 (필수)', course: 1, type: ItemType.sentence),
    (seal: '٢', label: 'L2 단어 (채팅)', course: 2, type: ItemType.word),
    (seal: '٢', label: 'L2 회화 (채팅)', course: 2, type: ItemType.sentence),
  ];
  final pool = keyboardPool();
  final entries = options
      .map((o) => (
            opt: o,
            count: pool
                .where((w) =>
                    w.course == o.course &&
                    w.type == o.type &&
                    w.id.startsWith('$mainLang:'))
                .length,
          ))
      .where((e) => e.count > 0)
      .toList();

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.arIvory,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const ArabicSeal(text: 'كتب', size: 28),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '⌨️ 키보드 연습',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.arInk,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  AppConfig.keyboardMenuSubtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.arInkLight),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const ArchDivider(height: 10),
            const SizedBox(height: 10),
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('연습할 항목이 없습니다',
                      style: TextStyle(color: AppColors.arInkLight)),
                ),
              )
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.25,
                children: entries.map((e) {
                  final o = e.opt;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KeyboardScreen(
                              course: o.course, itemType: o.type),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.arIvory,
                        border: Border.all(
                            color: AppColors.arGold.withValues(alpha: 0.6)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.arInk.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ArabicSeal(
                            text: o.seal,
                            size: 36,
                            color: o.type == ItemType.word
                                ? AppColors.arGreen
                                : AppColors.arTerracotta,
                          ),
                          const SizedBox(height: 8),
                          Text(o.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.arInk)),
                          const SizedBox(height: 2),
                          Text('${e.count}개 항목',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.arInkLight)),
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

// ────────────────────────────────────────────────────────────────────────
// 홈 탭
// ────────────────────────────────────────────────────────────────────────

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<void> _goTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final streak = UserStats().currentStreak;
    return Scaffold(
      backgroundColor: AppColors.arIvory,
      body: Stack(
        children: [
          const Positioned.fill(child: GeometricPattern(opacity: 0.07)),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // ── 헤더: 인사 + 스트릭 + 프로필
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // 아랍어 인사 — RTL 로 렌더 (글자 결합 유지)
                              const ArabicText('مرحباً!',
                                  fontSize: 28,
                                  color: AppColors.arGreen,
                                  textAlign: TextAlign.left),
                              const SizedBox(width: 6),
                              const Text('👋', style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '마르하반! 오늘도 아랍어 한 걸음',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.arInkLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreakChip(days: streak),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _goTo(const FavoritesScreen()),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.arIvory,
                          border: Border.all(color: AppColors.arGold),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.favorite_border,
                                color: AppColors.arTerracotta, size: 18),
                            if (FavoriteWords().count > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.arTerracotta,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('${FavoriteWords().count}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // ── 오늘의 학습
                const Text(
                  '오늘의 학습',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.arInk,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _TodayMission(onReturn: () => setState(() {})),
                const SizedBox(height: 14),

                // ── 난이도 (모든 메뉴 pool 필터)
                const _TierChips(),
                const SizedBox(height: 22),

                // ── 메인 메뉴
                const SectionTitle(seal: 'ع', label: '메인 메뉴'),
                const SizedBox(height: 10),
                _MenuGrid(goTo: _goTo),
                const SizedBox(height: 12),

                // ── 복습 wide 카드
                _ReviewCard(onTap: () => _goTo(const FlashCardScreen(reviewMode: true))),

                // ── 19+ / 관리자
                ValueListenableBuilder<bool>(
                  valueListenable: AdultGateService.instance.unlocked,
                  builder: (context, unlocked, _) {
                    if (!unlocked) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ArabicCard(
                        title: '🍷 Midnight Lounge',
                        sealText: 'ليل',
                        accent: AppColors.midnightBurgundy,
                        onTap: () => _goTo(const AdultHubScreen()),
                        child: const Text('19+ · 친밀·경계·어른의 뉘앙스',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.arInkLight)),
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      SubscriptionService.instance.isAdminListenable,
                  builder: (context, isAdmin, _) {
                    if (!isAdmin) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ArabicCard(
                        title: '개발자 메뉴',
                        sealText: 'أ',
                        accent: AppColors.arInk,
                        onTap: () => _goTo(const AdminScreen()),
                        child: const Text('커리큘럼 편집 (관리자 전용)',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.arInkLight)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),
                const CalligraphyDivider(),
                const SizedBox(height: 12),
                const Center(
                  child: ArabicText('العلم نور',
                      fontSize: 18,
                      color: AppColors.arGoldDeep,
                      textAlign: TextAlign.center),
                ),
                const Center(
                  child: Text(
                    '지식은 빛이다 · 아랍어유니버스 2026',
                    style: TextStyle(
                      color: AppColors.arInkLight,
                      fontSize: 11,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 홈 '오늘의 학습' — 첫 미완료 코스(L1~L5)와 단어 숙달률 연결.
class _TodayMission extends StatelessWidget {
  final VoidCallback onReturn;
  const _TodayMission({required this.onReturn});

  @override
  Widget build(BuildContext context) {
    int course = 1;
    var stats = courseWordStats(1);
    for (final c in [1, 2, 3, 4, 5]) {
      final s = courseWordStats(c);
      if (s.total == 0) continue;
      course = c;
      stats = s;
      if (s.mastered < s.total) break;
    }
    return TodayMissionCard(
      level: 'LEVEL $course · ${TierService.instance.tier.value.label}',
      lessonTitle:
          '${AppConfig.courseEmoji(course)} ${AppConfig.courseDisplayName(course)} 단어',
      lessonSubtitle: '플래시카드로 숙달까지 · 아랍어 ${AppConfig.ttsLocale}',
      progress: stats.mastered,
      total: stats.total,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FlashCardScreen(course: course)),
        );
        onReturn();
      },
    );
  }
}

/// 난이도 칩 (초/중/고) — 선택 즉시 TierService 갱신.
class _TierChips extends StatelessWidget {
  const _TierChips();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WordTier>(
      valueListenable: TierService.instance.tier,
      builder: (context, selected, _) {
        return Row(
          children: [
            const Text('난이도',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.arInkLight,
                    letterSpacing: 1)),
            const SizedBox(width: 10),
            ...WordTier.values.map((t) {
              final on = t == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => TierService.instance.setTier(t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: on ? AppColors.arGreen : AppColors.arIvory,
                      border: Border.all(
                        color: on
                            ? AppColors.arGreen
                            : AppColors.arGold.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      '${t.emoji} ${t.label}',
                      style: TextStyle(
                        color: on ? AppColors.arIvory : AppColors.arInk,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ReviewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final due = WordReviews().reviewDueCount(flashcardPool());
    final favs = FavoriteWords().count;
    final total = due + favs;
    return ArabicCard(
      title: '🔁 복습',
      sealText: 'عد',
      accent: AppColors.arTerracotta,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              total > 0 ? '$total개 대기 중 (복습 $due · 즐겨찾기 $favs)' : '학습하면 여기에 쌓여요',
              style: const TextStyle(fontSize: 12, color: AppColors.arInkLight),
            ),
          ),
          const ArabicText('راجع', fontSize: 18, color: AppColors.arTerracotta),
        ],
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  final Future<void> Function(Widget) goTo;
  const _MenuGrid({required this.goTo});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(
        label: '회화',
        sub: 'Conversation',
        seal: 'حوار',
        color: AppColors.arGreen,
        onTap: () => goTo(CourseSelectScreen(
          title: '💬 회화 공부',
          allPool: conversationPoolAll(),
          showWordCompletion: true,
          showAppendices: true,
          onPicked: (course) => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ConversationScreen(course: course)),
          ),
        )),
      ),
      _MenuItem(
        label: '문법',
        sub: '읽기만 하세요',
        seal: 'نحو',
        color: AppColors.arIndigo,
        onTap: () => goTo(const GrammarScreen()),
      ),
      _MenuItem(
        label: '단어',
        sub: 'Flashcard',
        seal: 'كلمة',
        color: AppColors.arGreenLight,
        onTap: () => goTo(CourseSelectScreen(
          title: '📚 단어 외우기',
          allPool: flashcardPoolAll(),
          onPicked: (course) => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FlashCardScreen(course: course)),
          ),
        )),
      ),
      if (AppConfig.hasArabicAlphabetMenu)
        _MenuItem(
          label: '알파벳',
          sub: '사알투무니하 10자',
          seal: 'أبجد',
          color: AppColors.arTurquoise,
          onTap: () => goTo(const ArAlphabetScreen()),
        ),
      if (AppConfig.hasArabicAffixGameMenu)
        _MenuItem(
          label: '접사 게임',
          sub: '명사 파생 5 패턴',
          seal: 'وزن',
          color: AppColors.arTerracotta,
          onTap: () => goTo(const ArAffixGameScreen()),
        ),
      // ⌨️ 키보드 연습 — 기존 picker(course × type) 그대로 유지
      _MenuItem(
        label: '키보드 연습',
        sub: AppConfig.keyboardMenuSubtitle,
        seal: 'كتب',
        color: AppColors.arGoldDeep,
        onTap: () => showKeyboardPicker(context),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _MenuTile(item: items[i]),
    );
  }
}

class _MenuItem {
  final String label;
  final String sub;
  final String seal;
  final Color color;
  final VoidCallback onTap;
  _MenuItem({
    required this.label,
    required this.sub,
    required this.seal,
    required this.color,
    required this.onTap,
  });
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.arIvory,
          border: Border.all(color: AppColors.arGold.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.arInk.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ArabicSeal(text: item.seal, size: 44, color: item.color),
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.arInk,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.sub,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.arInkLight,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
// 학습 탭 — 코스(L1~L5) × 모드(단어/회화/키보드) 리스트
// ────────────────────────────────────────────────────────────────────────

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

enum _Mode { word, talk, keyboard }

class _LearnTabState extends State<LearnTab> {
  String _filter = '전체';
  static const _filters = ['전체', '단어', '회화', '키보드'];

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();
    return Scaffold(
      backgroundColor: AppColors.arIvory,
      appBar: AppBar(
        backgroundColor: AppColors.arIvory,
        foregroundColor: AppColors.arInk,
        elevation: 0,
        title: const Text('학습',
            style: TextStyle(color: AppColors.arInk, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: '키보드 연습',
            icon: const Icon(Icons.keyboard_outlined, color: AppColors.arInk),
            onPressed: () => showKeyboardPicker(context),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final f = _filters[i];
                final on = f == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: on ? AppColors.arGreen : AppColors.arIvory,
                      border: Border.all(
                        color: on
                            ? AppColors.arGreen
                            : AppColors.arGold.withValues(alpha: 0.6),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      f,
                      style: TextStyle(
                        color: on ? AppColors.arIvory : AppColors.arInk,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const ArchDivider(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: rows.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) =>
                  _LessonRow(row: rows[i], onReturn: () => setState(() {})),
            ),
          ),
        ],
      ),
    );
  }

  List<_LessonRowData> _buildRows() {
    final rows = <_LessonRowData>[];
    final modes = switch (_filter) {
      '단어' => [_Mode.word],
      '회화' => [_Mode.talk],
      '키보드' => [_Mode.keyboard],
      _ => _Mode.values,
    };
    final lang = LanguageService.instance.code.value;
    final adult = AdultGateService.instance.unlocked.value;
    for (final m in modes) {
      final courses = switch (m) {
        _Mode.word => [1, 2, 3, 4, 5, if (adult) 6],
        _Mode.talk => [1, 2, 3, 4, 5, if (adult) 6],
        _Mode.keyboard => [1, 2],
      };
      final header = switch (m) {
        _Mode.word => ('كلمة', '단어 외우기'),
        _Mode.talk => ('حوار', '회화 공부'),
        _Mode.keyboard => ('كتب', '키보드 연습'),
      };
      rows.add(_LessonRowData.header(header.$1, header.$2, courses.length));
      var currentAssigned = false;
      for (final c in courses) {
        int total;
        int learned;
        switch (m) {
          case _Mode.word:
            final s = courseWordStats(c);
            total = s.total;
            learned = s.mastered;
          case _Mode.talk:
            final pool = conversationPoolAll()
                .where((w) => w.course == c && w.type == ItemType.sentence);
            total = pool.length;
            learned = pool
                .where((w) => WordReviews().stageOf(w.id) >= kMasteredStageFloor)
                .length;
          case _Mode.keyboard:
            total = keyboardPool()
                .where((w) => w.course == c && w.id.startsWith('$lang:'))
                .length;
            learned = 0;
        }
        final done = total > 0 && learned >= total;
        _LessonState st;
        if (done) {
          st = _LessonState.done;
        } else if (!currentAssigned && total > 0) {
          st = _LessonState.current;
          currentAssigned = true;
        } else {
          st = _LessonState.normal;
        }
        rows.add(_LessonRowData(
          id: 'L$c',
          title: '${AppConfig.courseEmoji(c)} ${AppConfig.courseDisplayName(c)}',
          state: total == 0 ? _LessonState.empty : st,
          learned: learned,
          total: total,
          mode: m,
          course: c,
        ));
      }
    }
    return rows;
  }
}

enum _LessonState { done, current, normal, empty }

class _LessonRowData {
  final String id;
  final String title;
  final _LessonState state;
  final int learned;
  final int total;
  final _Mode? mode;
  final int course;
  final bool isHeader;
  final String seal;

  _LessonRowData({
    required this.id,
    required this.title,
    required this.state,
    required this.learned,
    required this.total,
    required this.mode,
    required this.course,
  })  : isHeader = false,
        seal = '';

  _LessonRowData.header(this.seal, this.title, int count)
      : id = '',
        state = _LessonState.normal,
        learned = 0,
        total = count,
        mode = null,
        course = 0,
        isHeader = true;
}

class _LessonRow extends StatelessWidget {
  final _LessonRowData row;
  final VoidCallback onReturn;
  const _LessonRow({required this.row, required this.onReturn});

  Future<void> _open(BuildContext context) async {
    final nav = Navigator.of(context);
    Widget screen;
    switch (row.mode!) {
      case _Mode.word:
        screen = FlashCardScreen(course: row.course);
      case _Mode.talk:
        screen = ConversationScreen(course: row.course);
      case _Mode.keyboard:
        // 키보드는 단어/회화 type 선택이 필요 → 기존 picker 로 위임.
        await showKeyboardPicker(context);
        onReturn();
        return;
    }
    await nav.push(MaterialPageRoute(builder: (_) => screen));
    onReturn();
  }

  @override
  Widget build(BuildContext context) {
    if (row.isHeader) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 14, 2, 2),
        child: SectionTitle(
          seal: row.seal,
          label: row.title,
          trailing: Text('${row.total}과정',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.arGreen)),
        ),
      );
    }
    Color bg;
    Color border;
    Color text;
    Widget trailing;
    switch (row.state) {
      case _LessonState.done:
        bg = AppColors.arIvory;
        border = AppColors.arGreenLight;
        text = AppColors.arInk;
        trailing = const Icon(Icons.check_circle, color: AppColors.arGreenLight);
      case _LessonState.current:
        bg = AppColors.arGreen;
        border = AppColors.arGreenDeep;
        text = AppColors.arIvory;
        trailing = const Icon(Icons.arrow_forward, color: AppColors.arIvory);
      case _LessonState.normal:
        bg = AppColors.arIvory;
        border = AppColors.arGold.withValues(alpha: 0.5);
        text = AppColors.arInk;
        trailing = const Icon(Icons.chevron_right, color: AppColors.arGoldDeep);
      case _LessonState.empty:
        bg = AppColors.arIvoryDeep;
        border = AppColors.arGold.withValues(alpha: 0.3);
        text = AppColors.arInkLight;
        trailing = const Icon(Icons.lock, color: AppColors.arInkLight, size: 18);
    }
    return InkWell(
      onTap: row.state == _LessonState.empty ? null : () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
              color: border,
              width: row.state == _LessonState.current ? 1.5 : 0.8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(row.id,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: text.withValues(alpha: 0.75))),
            ),
            Expanded(
              child: Text(row.title,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: text)),
            ),
            if (row.total > 0)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  row.mode == _Mode.keyboard
                      ? '${row.total}개'
                      : '${row.learned}/${row.total}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: text.withValues(alpha: 0.8)),
                ),
              ),
            trailing,
          ],
        ),
      ),
    );
  }
}
