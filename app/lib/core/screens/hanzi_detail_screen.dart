import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/hanzi_study.dart';
import '../data/user_stats.dart';
import '../db/app_database.dart' hide UserStats;
import '../services/tts_service.dart';
import '../theme/app_colors.dart';
import 'package:talkverse/flavors/zh/widgets/hanzi_diagram.dart';

/// Diagram view for a single hanzi study: center radical + related chars.
/// Tap any node to hear the character and read its details below.
class HanziDetailScreen extends StatefulWidget {
  final String studyId;
  const HanziDetailScreen({super.key, required this.studyId});

  @override
  State<HanziDetailScreen> createState() => _HanziDetailScreenState();
}

class _HanziDetailScreenState extends State<HanziDetailScreen> {
  late Future<HanziStudyBundle?> _future;
  HanziRelatedZhRow? _selectedRelated;
  bool _activityRecorded = false;

  @override
  void initState() {
    super.initState();
    _future = HanziStudyRepo().load(widget.studyId);
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  void _onNodeTap(HanziStudyZhRow center, HanziRelatedZhRow? node) {
    setState(() => _selectedRelated = node);
    final text = node?.character ?? center.radical;
    TtsService.instance.speak(text);
    if (!_activityRecorded) {
      UserStats().recordActivity();
      _activityRecorded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          '한자 공부',
          style: GoogleFonts.notoSans(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<HanziStudyBundle?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final bundle = snap.data;
          if (bundle == null) {
            return const Center(child: Text('자료를 불러올 수 없어요.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(study: bundle.study),
                const SizedBox(height: 12),
                const _Legend(),
                const SizedBox(height: 16),
                Center(
                  child: HanziDiagram(
                    center: bundle.study,
                    related: bundle.related,
                    onNodeTap: (node) => _onNodeTap(bundle.study, node),
                  ),
                ),
                const SizedBox(height: 16),
                _SelectionCard(
                  study: bundle.study,
                  selected: _selectedRelated,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final HanziStudyZhRow study;
  const _Header({required this.study});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(
            study.radical,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  study.meaningKo,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (study.pinyin.isNotEmpty)
                  Text(
                    study.pinyin,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                if (study.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    study.description,
                    style: GoogleFonts.notoSans(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendChip(
          color: Color(0xFFDCEEFB),
          border: Color(0xFF7FB3D5),
          label: '뜻을 가져옴',
        ),
        SizedBox(width: 10),
        _LegendChip(
          color: Color(0xFFFDEBE4),
          border: Color(0xFFE6A098),
          label: '음을 가져옴',
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final Color border;
  final String label;
  const _LegendChip({
    required this.color,
    required this.border,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSans(
          fontSize: 11.5,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final HanziStudyZhRow study;
  final HanziRelatedZhRow? selected;
  const _SelectionCard({required this.study, required this.selected});

  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          '한자를 탭하면 발음과 설명이 표시됩니다.',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }
    final isPhonetic = selected!.relationType == 'phonetic';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPhonetic
            ? const Color(0xFFFDEBE4)
            : const Color(0xFFDCEEFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPhonetic
              ? const Color(0xFFE6A098)
              : const Color(0xFF7FB3D5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selected!.character,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected!.meaningKo,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (selected!.pinyin.isNotEmpty)
                      Text(
                        selected!.pinyin,
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      isPhonetic
                          ? '${study.radical}의 소리를 이어받은 한자'
                          : '${study.radical}의 뜻을 이어받은 한자',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selected!.note.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              selected!.note,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
