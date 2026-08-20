import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../data/favorite_words.dart';
import '../data/grammar_progress.dart';
import '../data/user_stats.dart';
import '../data/word_data.dart';
import '../data/word_reviews.dart';
import '../models/word.dart';
import '../theme/app_colors.dart';
import '../theme/ar_theme.dart';
import '../widgets/arabic_decor.dart';
import 'favorites_screen.dart';
import 'flashcard_screen.dart';
import 'grammar_screen.dart';
import 'main_screen.dart' show courseWordStats, kMasteredStageFloor;
import 'stats_screen.dart';

/// 진행 탭 — 스트릭·오늘 목표·문법 읽기·코스별 단어 숙달률·복습 대기.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Future<void> _goTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stats = UserStats();
    final lang = AppConfig.languageCode;
    final gDay = GrammarProgress.instance.accumulatedCompletedDay(lang);
    final gTotal = GrammarProgress.instance.totalDaysFor(lang);
    final gFrac = GrammarProgress.instance.progressFraction(lang);
    final due = WordReviews().reviewDueCount(flashcardPool());
    final favs = FavoriteWords().count;

    final totalWords =
        flashcardPoolAll().where((w) => w.type == ItemType.word).length;
    final masteredWords = flashcardPoolAll()
        .where((w) =>
            w.type == ItemType.word &&
            WordReviews().stageOf(w.id) >= kMasteredStageFloor)
        .length;

    return Scaffold(
      backgroundColor: AppColors.arIvory,
      appBar: AppBar(
        title: const Text('진행'),
        actions: [
          IconButton(
            tooltip: '상세 통계',
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => _goTo(const StatsScreen()),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: GeometricPattern(opacity: 0.05)),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── 요약 타일 4개
              Row(
                children: [
                  Expanded(
                      child: _StatTile(
                          seal: 'نار',
                          label: '현재 연속',
                          value: '${stats.currentStreak}일',
                          color: AppColors.arTerracotta)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _StatTile(
                          seal: 'ذروة',
                          label: '최장 연속',
                          value: '${stats.longestStreak}일',
                          color: AppColors.arGoldDeep)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _StatTile(
                          seal: 'يوم',
                          label: '오늘 학습',
                          value: '${stats.todayCount} / ${stats.dailyGoal}',
                          color: AppColors.arGreen)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _StatTile(
                          seal: 'كل',
                          label: '숙달 단어',
                          value: '$masteredWords / $totalWords',
                          color: AppColors.arTurquoise)),
                ],
              ),
              const SizedBox(height: 18),

              // ── 오늘 목표
              ArabicCard(
                title: '오늘 목표',
                sealText: 'هدف',
                child: _Bar(
                  label: stats.goalReached ? '✅ 목표 달성!' : '오늘 ${stats.todayCount}개 학습',
                  value: stats.todayProgress,
                  color: stats.goalReached ? AppColors.arGreenLight : AppColors.arGreen,
                  trailing: '${stats.todayCount}/${stats.dailyGoal}',
                ),
              ),
              const SizedBox(height: 12),

              // ── 문법 읽기
              ArabicCard(
                title: '📖 문법 읽기',
                sealText: 'نحو',
                accent: AppColors.arIndigo,
                onTap: () => _goTo(const GrammarScreen()),
                child: _Bar(
                  label: gDay >= gTotal ? '✅ 전 과정 완독' : 'Day $gDay 까지 완료',
                  value: gFrac,
                  color: AppColors.arIndigo,
                  trailing: '$gDay/$gTotal',
                ),
              ),
              const SizedBox(height: 12),

              // ── 코스별 단어 숙달
              ArabicCard(
                title: '코스별 단어 숙달',
                sealText: 'كلمة',
                accent: AppColors.arGreenLight,
                child: Column(
                  children: [
                    for (final c in [1, 2, 3, 4, 5]) ...[
                      Builder(builder: (context) {
                        final s = courseWordStats(c);
                        if (s.total == 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () => _goTo(FlashCardScreen(course: c)),
                            child: _Bar(
                              label:
                                  'L$c ${AppConfig.courseEmoji(c)} ${AppConfig.courseDisplayName(c)}',
                              value: s.mastered / s.total,
                              color: AppColors.arGreen,
                              trailing: '${s.mastered}/${s.total}',
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── 복습 대기
              Row(
                children: [
                  Expanded(
                    child: ArabicCard(
                      title: '🔁 복습 대기',
                      sealText: 'عد',
                      accent: AppColors.arTerracotta,
                      onTap: () => _goTo(const FlashCardScreen(reviewMode: true)),
                      child: Text('$due개',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.arInk)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ArabicCard(
                      title: '♥ 즐겨찾기',
                      sealText: 'حب',
                      accent: AppColors.arGoldDeep,
                      onTap: () => _goTo(const FavoritesScreen()),
                      child: Text('$favs개',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.arInk)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const CalligraphyDivider(),
              const SizedBox(height: 10),
              const Center(
                child: ArabicText('من جدّ وجد',
                    fontSize: 18,
                    color: AppColors.arGoldDeep,
                    textAlign: TextAlign.center),
              ),
              const Center(
                child: Text('노력하는 자는 얻는다',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.arInkLight,
                        letterSpacing: 3)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String seal;
  final String label;
  final String value;
  final Color color;
  const _StatTile(
      {required this.seal,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.arIvory,
        border: Border.all(color: AppColors.arGold.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          ArabicSeal(text: seal, size: 40, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.arInkLight)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.arInk)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String trailing;
  const _Bar(
      {required this.label,
      required this.value,
      required this.color,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.arInk)),
            ),
            Text(trailing,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.arIvoryDeep,
                border: Border.all(color: AppColors.arGold, width: 0.6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(height: 8, color: color),
            ),
          ],
        ),
      ],
    );
  }
}
