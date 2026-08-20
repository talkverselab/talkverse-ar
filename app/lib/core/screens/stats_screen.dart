import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/user_progress.dart';
import '../data/user_stats.dart';
import '../data/word_data.dart';
import '../data/word_reviews.dart';
import '../models/word.dart';
import '../services/subscription_service.dart';
import '../theme/app_colors.dart';
import 'paywall_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    final stats = UserStats();
    final progress = UserProgress();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('📊 통계',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: '🔥',
                  label: '현재 연속',
                  value: '${stats.currentStreak}일',
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: '🏆',
                  label: '최장 연속',
                  value: '${stats.longestStreak}일',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: '📚',
                  label: '배운 항목',
                  value: '${progress.knownCount}',
                  color: AppConfig.brandColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: '🎯',
                  label: '오늘 문장',
                  value: '${stats.todayCount}',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('최근 7일',
              style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: _WeeklyChart(data: stats.last7Days(), goal: stats.dailyGoal),
          ),
          const SizedBox(height: 24),
          Text('학습 현황',
              style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          const _LearningGrid(),
          const SizedBox(height: 24),
          _PremiumCard(onChanged: () => setState(() {})),
          const SizedBox(height: 24),
          Text('설정',
              style: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('일일 목표',
                          style: GoogleFonts.notoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text('하루에 외울 문장 수',
                          style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final next = await _pickGoal(context, stats.dailyGoal);
                    if (next != null) {
                      await stats.setDailyGoal(next);
                      if (mounted) setState(() {});
                    }
                  },
                  child: Text('${stats.dailyGoal}개 →',
                      style: GoogleFonts.notoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.brandColor)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DevPremiumToggle(onChanged: () => setState(() {})),
        ],
      ),
    );
  }

  Future<int?> _pickGoal(BuildContext context, int current) {
    const options = [5, 10, 15, 20, 30, 50];
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text('일일 목표 선택',
                style: GoogleFonts.notoSans(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...options.map((n) => ListTile(
                  title: Text('$n개',
                      style: GoogleFonts.notoSans(
                          fontSize: 15,
                          fontWeight:
                              n == current ? FontWeight.bold : FontWeight.normal,
                          color: n == current
                              ? AppConfig.brandColor
                              : AppColors.textPrimary)),
                  trailing: n == current
                      ? Icon(Icons.check, color: AppConfig.brandColor)
                      : null,
                  onTap: () => Navigator.pop(ctx, n),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.notoSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<({DateTime date, int count})> data;
  final int goal;

  const _WeeklyChart({required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    final maxCount = data.fold<int>(0, (a, b) => b.count > a ? b.count : a);
    final scale = (maxCount > goal ? maxCount : goal).clamp(1, 9999).toDouble();
    const labels = ['월', '화', '수', '목', '금', '토', '일'];

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((d) {
          final ratio = (d.count / scale).clamp(0.0, 1.0);
          final hitGoal = d.count >= goal && goal > 0;
          final weekday = (d.date.weekday - 1) % 7;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(d.count > 0 ? '${d.count}' : '',
                      style: GoogleFonts.notoSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6)),
                    child: Container(
                      height: 90 * ratio,
                      width: double.infinity,
                      color: hitGoal
                          ? AppColors.success
                          : AppConfig.brandColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(labels[weekday],
                      style: GoogleFonts.notoSans(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Mode × course learning grid.
///
/// Rows: 단어 외우기 / 키보드 연습 / 회화 공부
/// Cols: L1 L2 L3 L4 L5 (L6 shown when adult-unlocked)
/// Cell: % of items in that (mode, course) pool where the user has
///       already hit stage 3 (+1 week review) or higher — a "solid
///       retention" mark. "-" if the pool is empty for that combo.
class _LearningGrid extends StatelessWidget {
  const _LearningGrid();

  static const int _masteryFloor = 3;
  static const List<int> _courses = [1, 2, 3, 4, 5];

  List<Word> _poolFor(String modeKey, int course) {
    switch (modeKey) {
      case 'flashcard':
        // Words only — flashcard mode focuses on vocabulary.
        return allItems
            .where((w) => w.course == course && w.type == ItemType.word)
            .toList();
      case 'keyboard':
        // Words only, keyboard practice length-capped at 6 chars.
        return allItems
            .where((w) =>
                w.course == course &&
                w.type == ItemType.word &&
                w.targetPlain.length <= 6)
            .toList();
      case 'conversation':
        return allItems
            .where((w) => w.course == course && w.type != ItemType.word)
            .toList();
      default:
        return const [];
    }
  }

  (int total, int mastered) _stats(List<Word> pool) {
    final reviews = WordReviews();
    var total = 0;
    var mastered = 0;
    for (final w in pool) {
      total++;
      if (reviews.stageOf(w.id) >= _masteryFloor) mastered++;
    }
    return (total, mastered);
  }

  @override
  Widget build(BuildContext context) {
    final modes = [
      (key: 'flashcard',    label: '📚 단어 외우기'),
      (key: 'keyboard',     label: '⌨️ 키보드 연습'),
      (key: 'conversation', label: '💬 회화 공부'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Row(
              children: [
                const SizedBox(width: 110),
                for (final c in _courses)
                  Expanded(
                    child: Center(
                      child: Text('L$c',
                          style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          for (final m in modes) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(m.label,
                        style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600)),
                  ),
                  for (final c in _courses)
                    Expanded(
                      child: _GridCell(stats: _stats(_poolFor(m.key, c))),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final (int total, int mastered) stats;
  const _GridCell({required this.stats});

  @override
  Widget build(BuildContext context) {
    final (total, mastered) = stats;
    if (total == 0) {
      return Center(
        child: Text('-',
            style: GoogleFonts.notoSans(
                fontSize: 12, color: AppColors.textMuted)),
      );
    }
    final percent = (mastered * 100 / total).round();
    final color = percent >= 70
        ? AppColors.successDark
        : percent >= 30
            ? AppConfig.brandColor
            : AppColors.textSecondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$percent%',
            style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color)),
        Text('$mastered/$total',
            style: GoogleFonts.notoSans(
                fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final VoidCallback onChanged;
  const _PremiumCard({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SubscriptionService.instance.isPremiumListenable,
      builder: (context, isPremium, _) {
        final bg = isPremium
            ? AppColors.warning.withValues(alpha: 0.12)
            : AppConfig.brandColor.withValues(alpha: 0.08);
        final border = isPremium
            ? AppColors.warning
            : AppConfig.brandColor.withValues(alpha: 0.4);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1.2),
          ),
          child: Row(
            children: [
              Text(isPremium ? '👑' : '💎',
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isPremium ? '프리미엄 이용 중' : '프리미엄으로 업그레이드',
                        style: GoogleFonts.notoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(
                        isPremium
                            ? '모든 콘텐츠에 접근할 수 있어요'
                            : '전체 단어와 회화를 해제하세요',
                        style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (!isPremium)
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PaywallScreen()),
                    );
                    onChanged();
                  },
                  child: Text('업그레이드 →',
                      style: GoogleFonts.notoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.brandColor)),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DevPremiumToggle extends StatelessWidget {
  final VoidCallback onChanged;
  const _DevPremiumToggle({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SubscriptionService.instance.isPremiumListenable,
      builder: (context, isPremium, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.cardBorder,
                style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              const Icon(Icons.bug_report_outlined,
                  color: AppColors.textMuted, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text('개발자 모드: 프리미엄',
                    style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppColors.textSecondary)),
              ),
              Switch(
                value: isPremium,
                onChanged: (v) async {
                  await SubscriptionService.instance.setPremium(v);
                  onChanged();
                },
                activeThumbColor: AppConfig.brandColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
