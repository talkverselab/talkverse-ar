import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/grammar_content.dart';
import '../data/grammar_progress.dart';
import '../services/grammar_loader.dart';
import '../theme/app_colors.dart';
import 'grammar_day_screen.dart';

/// 문법 메뉴 화면 — Day 1~N 리스트.
///
/// 접근 규칙:
///   - Day 1은 항상 열림.
///   - Day N(N≥2)은 Day N-1을 "읽기 완료"해야 열림 (sequential).
///   - "누적 달성"은 별도 표시 (Day 1..N 모두 완료여야 achievement 인정).
class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    // 현재 언어 grammar 미로드 시 lazy load. 이미 로드됐으면 즉시 완료.
    _loadFuture = GrammarRepository.ensureLoaded(AppConfig.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(
                '📖 문법 — 읽기만 하세요',
                style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return _buildContent();
      },
    );
  }

  Widget _buildContent() {
    final lang = AppConfig.languageCode;
    final days = grammarDays(lang);
    final progress = GrammarProgress.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '📖 문법 — 읽기만 하세요',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: progress,
        builder: (context, _) {
          final accDay = progress.accumulatedCompletedDay(lang);
          final totalDays = progress.totalDaysFor(lang);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(accumulatedDay: accDay, totalDays: totalDays),
                const SizedBox(height: 16),
                for (final info in days)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _DayTile(info: info, lang: lang),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final int accumulatedDay;
  final int totalDays;
  const _HeaderCard({required this.accumulatedDay, required this.totalDays});

  @override
  Widget build(BuildContext context) {
    final pct = totalDays == 0
        ? 0
        : (accumulatedDay / totalDays * 100).round();
    final totalMinutes = totalDays * 30;
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
          Text(
            '하루 30분 × $totalDays일 = $totalMinutes분',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '읽기만 하세요. 외우지 않습니다.',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '문법 읽기 달성률',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$accumulatedDay / $totalDays ($pct%)',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalDays == 0 ? 0 : accumulatedDay / totalDays,
              minHeight: 8,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(AppConfig.brandColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final GrammarDayInfo info;
  final String lang;
  const _DayTile({required this.info, required this.lang});

  @override
  Widget build(BuildContext context) {
    final progress = GrammarProgress.instance;
    final read = progress.isDayRead(lang, info.day);
    final achieved = progress.isDayAchieved(lang, info.day);

    final Color accent;
    final IconData leading;
    final String trailing;

    if (achieved) {
      accent = AppColors.successDark;
      leading = Icons.check_circle;
      trailing = '누적 달성';
    } else if (read) {
      accent = AppConfig.brandColor;
      leading = Icons.check_circle_outline;
      trailing = '읽음';
    } else {
      accent = AppColors.textPrimary;
      leading = Icons.play_circle_outline;
      trailing = '읽기';
    }

    return Opacity(
      opacity: 1.0,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GrammarDayScreen(day: info.day),
          ),
        ),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.45)),
          ),
          child: Row(
            children: [
              Icon(leading, color: accent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info.shortSubtitle,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                trailing,
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
