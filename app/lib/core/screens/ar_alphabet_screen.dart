import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/ar_alphabet_data.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// AR 알파벳 메뉴 — 사알투무니하 (10 자) 학습 화면.
///
/// UI 스펙 (사용자 결정):
///   - 상단: 10 자 가로 스크롤 선택 바 (탭 → TTS 발음 + 선택)
///   - 본문: 선택된 글자의 [문두 / 문중 / 문미] 3 셀 + 그 아래 [원형] 1 셀
///           (4 셀 모두 같은 높이)
///   - 본문 헤더에 🔊 버튼 (선택된 글자 발음)
///   - 하단: 주요 용법 + disclaimer (이중 역할 글자)
///   - 전체 RTL (한국어도 메뉴에서는 RTL 흐름)
class ArAlphabetScreen extends StatefulWidget {
  const ArAlphabetScreen({super.key});

  @override
  State<ArAlphabetScreen> createState() => _ArAlphabetScreenState();
}

class _ArAlphabetScreenState extends State<ArAlphabetScreen> {
  int _selectedIndex = 0;

  ArAffixLetter get _letter => ArAlphabetData.saal[_selectedIndex];

  void _onSelect(int i) {
    setState(() => _selectedIndex = i);
    _speak(ArAlphabetData.saal[i].letter);
  }

  void _speak(String text) {
    TtsService.instance.speak(text, delay: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('🔤 사알투무니하'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 가로 스크롤 letter bar
              _buildLetterBar(),
              const Divider(height: 1),
              // 2. 본문 (스크롤 가능)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildFourCells(),
                    const SizedBox(height: 16),
                    _buildUsageCard(),
                  ],
                ),
              ),
              // 3. 하단 disclaimer
              _buildDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- letter bar ----------
  Widget _buildLetterBar() {
    return Container(
      height: 84,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: ArAlphabetData.saal.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSel = i == _selectedIndex;
          final l = ArAlphabetData.saal[i];
          return GestureDetector(
            onTap: () => _onSelect(i),
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: isSel ? AppColors.brandAr : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.brandAr.withValues(alpha: isSel ? 1 : 0.35),
                  width: isSel ? 2 : 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                l.letter,
                style: GoogleFonts.notoSansArabic(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isSel ? Colors.white : AppColors.brandAr,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- 헤더 ----------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.brandAr.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandAr.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_letter.letter} · ${_letter.name}',
                  style: GoogleFonts.notoSans(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandAr,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'roman · ${_letter.roman}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded),
            color: AppColors.brandAr,
            tooltip: '발음 듣기',
            onPressed: () => _speak(_letter.letter),
          ),
        ],
      ),
    );
  }

  // ---------- 4 셀 ----------
  Widget _buildFourCells() {
    const cellH = 108.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 위 row — 문두 / 문중 / 문미
        Row(
          children: [
            Expanded(
                child: _formCell('문두', _letter.initial, cellH, accent: false)),
            const SizedBox(width: 8),
            Expanded(
                child: _formCell('문중', _letter.medial, cellH, accent: false)),
            const SizedBox(width: 8),
            Expanded(
                child:
                    _formCell('문미', _letter.finalForm, cellH, accent: false)),
          ],
        ),
        const SizedBox(height: 8),
        // 아래 row — 원형 (full width, 같은 높이)
        _formCell('원형', _letter.letter, cellH, accent: true),
      ],
    );
  }

  Widget _formCell(String label, String form, double height,
      {bool accent = false}) {
    final color = accent ? AppColors.brandAr : AppColors.textSecondary;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: accent ? 0.6 : 0.3),
          width: accent ? 2 : 1.2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 8,
            child: Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Center(
            child: Text(
              form,
              style: GoogleFonts.notoSansArabic(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- 용법 카드 ----------
  Widget _buildUsageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.brandAr.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  size: 16, color: AppColors.brandAr),
              const SizedBox(width: 6),
              Text(
                '주요 용법 (접사 모드)',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandAr,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._letter.usages.map(
            (u) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      u,
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- disclaimer ----------
  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.dangerDark.withValues(alpha: 0.08),
      child: Text(
        '⚠ 이 10 자는 어근 (단어 뼈대) 으로도 쓰인다. 본 강의는 접사 모드만 학습.',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(
          fontSize: 11.5,
          color: AppColors.dangerDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
