import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../config/language_registry.dart';
import '../data/word_data.dart' as word_data;
import '../data/word_reviews.dart';
import '../models/word.dart';
import '../services/adult_gate_service.dart';
import '../services/subscription_service.dart';
import '../services/language_service.dart';
import '../theme/app_colors.dart';
import 'conversation_screen.dart';
import 'paywall_screen.dart';

/// Generic course picker. Displays a fixed set of courses (defaults to
/// 1..6) regardless of whether the pool actually has items for each —
/// empty courses still appear so the user sees the full curriculum
/// structure. Course 6 is filtered out unless the adult gate is
/// unlocked in 내 정보.
class CourseSelectScreen extends StatelessWidget {
  final String title;
  final List<Word> allPool;

  /// Whether premium gating applies to this mode. False for keyboard.
  final bool gated;

  /// Callback when the user picks an accessible course.
  final void Function(int course) onPicked;

  /// Which course numbers this picker offers, regardless of pool contents.
  /// Standard 단어외우기 / 회화공부 → 1..5 (L6 성인은 메인 메뉴의
  /// 성인 콘텐츠 카드 → AdultHubScreen 으로만 진입).
  /// Keyboard → [1, 2] only (basics + messenger-chat typing practice).
  final List<int> courseRange;

  /// 회화 공부 전용 — true면 각 카드에 "이 과정의 단어 학습률"을
  /// 퍼센트로 보여주고, 70% 미만이면 "단어공부 더 필요" 안내를 추가.
  final bool showWordCompletion;

  /// true면 현재 주 언어에 부록(appendix)이 있을 때 별도 카드 노출.
  /// 회화 공부 진입에만 적용 (단어외우기·키보드 연습에선 false).
  final bool showAppendices;

  const CourseSelectScreen({
    super.key,
    required this.title,
    required this.allPool,
    required this.onPicked,
    this.gated = true,
    this.courseRange = const [1, 2, 3, 4, 5],
    this.showWordCompletion = false,
    this.showAppendices = false,
  });

  /// 달성 기준: "알아요"를 3회 이상 눌러 +1주 간격까지 도달한 단어.
  /// 이 정도면 회화 연습에 투입해도 문장 구성이 따라가리라는 heuristic.
  static const int _masteredStageFloor = 3;
  static const double _readyThreshold = 0.7;

  (int total, int mastered) _wordStatsForCourse(int course) {
    final reviews = WordReviews();
    // flashcardPoolAll 은 현재 선택된 tier 로 이미 필터됨.
    final words = word_data.flashcardPoolAll().where(
      (w) => w.type == ItemType.word && w.course == course,
    );
    var total = 0;
    var mastered = 0;
    for (final w in words) {
      total++;
      if (reviews.stageOf(w.id) >= _masteredStageFloor) mastered++;
    }
    return (total, mastered);
  }

  @override
  Widget build(BuildContext context) {
    final adultUnlocked = AdultGateService.instance.unlocked.value;

    // Seed count=0 for every course in courseRange (minus adult-gated
    // ones when the user hasn't unlocked them) so empty courses still
    // render as placeholders.
    final courses = <int, int>{
      for (final c in courseRange)
        if (!AppConfig.adultGatedCourses.contains(c) || adultUnlocked) c: 0,
    };
    for (final w in allPool) {
      if (!courses.containsKey(w.course)) continue;
      courses[w.course] = courses[w.course]! + 1;
    }
    final sortedCourses = courses.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(title,
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: SubscriptionService.instance.isPremiumListenable,
        builder: (context, isPremium, _) {
          final cards = sortedCourses.map((course) {
            final locked = gated && course > 1 && !isPremium;
            final (wordTotal, wordMastered) = showWordCompletion
                ? _wordStatsForCourse(course)
                : (0, 0);
            final ratio = wordTotal == 0 ? 0.0 : wordMastered / wordTotal;
            final ready = ratio >= _readyThreshold;
            return _CourseCard(
              course: course,
              count: courses[course]!,
              locked: locked,
              onTap: () async {
                if (locked) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaywallScreen()),
                  );
                  return;
                }
                onPicked(course);
              },
              wordCompletion:
                  showWordCompletion && wordTotal > 0 ? ratio : null,
              ready: ready,
            );
          }).toList();

          // 부록 언어 카드 — 현재 주 언어에 부록이 있고 데이터가 있을 때만.
          final appendixCards = <Widget>[];
          if (showAppendices) {
            final mainLang = LanguageService.instance.code.value;
            for (final appLang in LanguageRegistry.appendicesFor(mainLang)) {
              final appPool = word_data.appendixPool(appLang);
              if (appPool.isEmpty) continue; // 데이터 없으면 숨김
              final profile = LanguageRegistry.forCode(appLang);
              appendixCards.add(_AppendixCard(
                flag: profile.flagEmoji,
                nameKo: profile.nameKo,
                count: appPool.length,
                color: profile.brandColorOverride ?? AppConfig.brandColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(langCode: appLang),
                    ),
                  );
                },
              ));
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('과정을 선택하세요',
                    style: GoogleFonts.notoSans(
                        fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  children: cards,
                ),
                if (appendixCards.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('📎 부록',
                      style: GoogleFonts.notoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  ...appendixCards,
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final int course;
  final int count;
  final bool locked;
  final VoidCallback onTap;

  /// Null = don't show the completion ring. Non-null = 0.0..1.0.
  final double? wordCompletion;
  final bool ready;

  const _CourseCard({
    required this.course,
    required this.count,
    required this.locked,
    required this.onTap,
    this.wordCompletion,
    this.ready = false,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = AppConfig.courseEmoji(course);
    final name = AppConfig.courseDisplayName(course);
    final accent = locked ? AppColors.textMuted : AppConfig.brandColor;
    // Pastel green wash for "ready" courses.
    final highlightBg = wordCompletion == null
        ? Colors.white
        : ready
            ? const Color(0xFFE8F5E9)
            : Colors.white;
    final highlightBorder = locked
        ? AppColors.cardBorder
        : wordCompletion == null
            ? accent.withValues(alpha: 0.4)
            : ready
                ? const Color(0xFF66BB6A)
                : accent.withValues(alpha: 0.4);
    final completionLabel = wordCompletion != null
        ? '학습 ${(wordCompletion! * 100).round()}%'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlightBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: highlightBorder, width: locked ? 1 : 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: locked
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
                if (locked) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.lock_outline,
                      size: 14, color: AppColors.textMuted),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text('$count개 항목',
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: AppColors.textSecondary)),
            if (completionLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                completionLabel,
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ready
                      ? const Color(0xFF2E7D32)
                      : AppColors.dangerDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 부록 언어 카드 — id→ms, th→lo, es→pt 등. 와이드 레이아웃.
class _AppendixCard extends StatelessWidget {
  final String flag;
  final String nameKo;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _AppendixCard({
    required this.flag,
    required this.nameKo,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$nameKo 부록',
                    style: GoogleFonts.notoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count개 항목 — 주 언어 학습자용 보너스',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
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
