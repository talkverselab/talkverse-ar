import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/grammar_content.dart';
import '../data/grammar_progress.dart';
import '../theme/app_colors.dart';

/// 개별 Day 콘텐츠 뷰어.
///
/// 하단 버튼 구성:
///   - Day 1: "읽기 완료" 1개
///   - Day 2+: "Day N-1 다시읽기" + "Day N 완료" 2개
class GrammarDayScreen extends StatefulWidget {
  final int day;
  const GrammarDayScreen({super.key, required this.day});

  @override
  State<GrammarDayScreen> createState() => _GrammarDayScreenState();
}

class _GrammarDayScreenState extends State<GrammarDayScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = AppConfig.languageCode;
    final info = grammarDays(lang).firstWhere((d) => d.day == widget.day);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          info.title,
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: info.blocks.map(_renderBlock).toList(),
        ),
      ),
      bottomNavigationBar: _BottomActions(
        day: widget.day,
        lang: lang,
        onComplete: _onComplete,
      ),
    );
  }

  Future<void> _onComplete() async {
    final lang = AppConfig.languageCode;
    final messenger = ScaffoldMessenger.of(context);
    final newAchievedDay =
        await GrammarProgress.instance.markDayRead(lang, widget.day);

    if (!mounted) return;

    if (GrammarProgress.shouldCelebrate(lang, newAchievedDay)) {
      await showDialog(
        context: context,
        builder: (ctx) => _CelebrationDialog(day: newAchievedDay, lang: lang),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              'Day ${widget.day.toString().padLeft(2, '0')} 읽기 완료!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Widget _renderBlock(GrammarBlock b) {
    switch (b.type) {
      case GrammarBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            b.text ?? '',
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        );
      case GrammarBlockType.subheading:
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            b.text ?? '',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppConfig.brandColor,
            ),
          ),
        );
      case GrammarBlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            b.text ?? '',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        );
      case GrammarBlockType.note:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConfig.brandColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(color: AppConfig.brandColor, width: 3),
            ),
          ),
          child: Text(
            b.text ?? '',
            style: GoogleFonts.notoSans(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
        );
      case GrammarBlockType.divider:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1),
        );
      case GrammarBlockType.example:
        final lines = b.lines ?? const [];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lines.isNotEmpty)
                Text(lines[0],
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    )),
              if (lines.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(lines[1],
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      )),
                ),
              if (lines.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(lines[2],
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppConfig.brandColor,
                        fontWeight: FontWeight.w600,
                      )),
                ),
            ],
          ),
        );
      case GrammarBlockType.table:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _TableBlock(headers: b.headers ?? [], rows: b.rows ?? []),
        );
      case GrammarBlockType.placeholder:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.textSecondary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.edit_note,
                  size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(
                b.text ?? '내용은 추후기재',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _TableBlock extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  const _TableBlock({required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 14,
        headingRowHeight: 36,
        dataRowMinHeight: 32,
        dataRowMaxHeight: 40,
        headingTextStyle: GoogleFonts.notoSans(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        dataTextStyle: GoogleFonts.notoSans(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        columns: [
          for (final h in headers) DataColumn(label: Text(h)),
        ],
        rows: [
          for (final r in rows)
            DataRow(cells: [
              for (final c in r) DataCell(Text(c)),
            ]),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final int day;
  final String lang;
  final Future<void> Function() onComplete;
  const _BottomActions({
    required this.day,
    required this.lang,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDay1 = day == 1;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Row(
          children: [
            if (!isDay1)
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: Text(
                      'Day ${(day - 1).toString().padLeft(2, '0')} 다시읽기'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrammarDayScreen(day: day - 1),
                      ),
                    );
                  },
                ),
              ),
            if (!isDay1) const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: Text(isDay1
                    ? '읽기 완료'
                    : 'Day ${day.toString().padLeft(2, '0')} 완료'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppConfig.brandColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: onComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CelebrationDialog extends StatelessWidget {
  final int day;
  final String lang;
  const _CelebrationDialog({required this.day, required this.lang});

  /// 진행률 기준 동적 축하 메시지. 언어별 하드코딩 제거.
  /// - [_pct] 는 Day / 총 Day 수.
  double get _pct {
    final total = grammarTotalDaysFor(lang);
    if (total <= 0) return 0;
    return day / total;
  }

  String get _headline {
    final p = _pct;
    if (p >= 0.95) return '👑 완주!';
    if (p >= 0.75) return '🔥 ${(p * 100).round()}% 달성!';
    if (p >= 0.50) return '🎉 절반 돌파!';
    return '🎉 ${(p * 100).round()}% 달성!';
  }

  String get _body {
    final langName = AppConfig.targetLanguageName;
    final p = _pct;
    if (p >= 0.95) {
      return '🎓 $langName 문법 전 과정 완주!\n\n이제 L2 회화부터 본격적으로 시작하세요. 가장 어려운 언덕은 뒤로 한 것입니다.';
    }
    if (p >= 0.75) {
      return '당신은 $langName 문법의 ${(p * 100).round()}%를 달성했습니다.\n\n마지막 직선 코스 — 지금까지 쌓은 것을 한 번에 엮는 단계입니다. 완주까지 Day ${(grammarTotalDaysFor(lang) - day).toString().padLeft(2, '0')}일 남았습니다.';
    }
    if (p >= 0.50) {
      return '$langName 문법의 절반을 지났습니다.\n\n가장 힘든 언덕을 넘었고 나머지는 기존 개념의 변형·확장입니다. 페이스 유지가 핵심.';
    }
    return '$langName 문법의 핵심을 밟았습니다.\n\n지금 속도 유지하면 L2 회화까지 막힘 없이 갈 수 있습니다.';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_headline,
          style: GoogleFonts.notoSans(fontWeight: FontWeight.w800)),
      content: Text(_body,
          style: GoogleFonts.notoSans(fontSize: 14, height: 1.5)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('계속하기'),
        ),
      ],
    );
  }
}
