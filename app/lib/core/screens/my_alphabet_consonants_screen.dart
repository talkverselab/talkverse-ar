import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/my_alphabet_data.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// 미얀마 자음 33자 학습 화면.
///
/// AR 알파벳 화면 (`ArAlphabetScreen`) 구조 참고 + LTR.
/// Pali only 글자 (ဈ ဋ ဌ ဍ ဎ ဏ ဠ) 는 회색 톤다운 + 안내문.
class MyAlphabetConsonantsScreen extends StatefulWidget {
  const MyAlphabetConsonantsScreen({super.key});

  @override
  State<MyAlphabetConsonantsScreen> createState() =>
      _MyAlphabetConsonantsScreenState();
}

class _MyAlphabetConsonantsScreenState
    extends State<MyAlphabetConsonantsScreen> {
  static const _myBrand = Color(0xFF5E35B1);
  static const _paliColor = Color(0xFF9E9E9E);

  List<MyConsonant>? _consonants;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await MyAlphabetData.loadConsonants();
    if (!mounted) return;
    setState(() => _consonants = data);
  }

  void _onSelect(int i) {
    setState(() => _selectedIndex = i);
    final c = _consonants![i];
    if (!c.isPaliOnly) _speak(c.letter);
  }

  void _speak(String text) {
    TtsService.instance.speak(text, delay: Duration.zero);
  }

  Color _colorFor(MyConsonant c) =>
      c.isPaliOnly ? _paliColor : AppColors.textPrimary;

  @override
  Widget build(BuildContext context) {
    final consonants = _consonants;
    if (consonants == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final selected = consonants[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🔤 자음 (33)'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLetterBar(consonants),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                children: [
                  _buildHeader(selected),
                  const SizedBox(height: 14),
                  _buildBigLetterCell(selected),
                  const SizedBox(height: 12),
                  _buildSoundCard(selected),
                  const SizedBox(height: 10),
                  if (selected.isPaliOnly) _buildPaliCard(selected),
                  if (selected.commonWords.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _buildCommonWordsCard(selected),
                  ],
                  const SizedBox(height: 10),
                  _buildMnemonicCard(selected),
                  const SizedBox(height: 10),
                  _buildStackedFormCard(selected),
                ],
              ),
            ),
            _buildDisclaimer(),
          ],
        ),
      ),
    );
  }

  // ---------- letter bar ----------
  Widget _buildLetterBar(List<MyConsonant> consonants) {
    return Container(
      height: 84,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: consonants.length,
        separatorBuilder: (_, i) {
          // group divider — row_position 마지막에서 다음으로 넘어갈 때
          final cur = consonants[i];
          final next = consonants[i + 1];
          if (cur.rowGroup != next.rowGroup) {
            return Container(
              width: 1.5,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            );
          }
          return const SizedBox(width: 6);
        },
        itemBuilder: (context, i) {
          final isSel = i == _selectedIndex;
          final c = consonants[i];
          final letterColor =
              isSel ? Colors.white : (c.isPaliOnly ? _paliColor : _myBrand);
          final bgColor = isSel
              ? (c.isPaliOnly ? _paliColor : _myBrand)
              : Colors.white;
          final borderColor = c.isPaliOnly ? _paliColor : _myBrand;
          return GestureDetector(
            onTap: () => _onSelect(i),
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor.withValues(alpha: isSel ? 1 : 0.35),
                  width: isSel ? 2 : 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                c.letter,
                style: GoogleFonts.notoSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: letterColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- 헤더 ----------
  Widget _buildHeader(MyConsonant c) {
    final color = c.isPaliOnly ? _paliColor : _myBrand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${c.letter} · ${c.nameKo}',
                  style: GoogleFonts.notoSans(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${c.nameMy} · /${c.roman}/ · ${c.ipa}',
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
            color: color,
            tooltip: '발음 듣기',
            onPressed: c.isPaliOnly ? null : () => _speak(c.letter),
          ),
        ],
      ),
    );
  }

  Widget _buildBigLetterCell(MyConsonant c) {
    final color = c.isPaliOnly ? _paliColor : _myBrand;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        c.letter,
        style: GoogleFonts.notoSans(
          fontSize: 96,
          fontWeight: FontWeight.bold,
          color: _colorFor(c),
        ),
      ),
    );
  }

  Widget _buildSoundCard(MyConsonant c) {
    return _Card(
      icon: Icons.record_voice_over_outlined,
      title: '한국어 발음',
      isPali: c.isPaliOnly,
      child: Text(
        c.koreanSoundHint,
        style: GoogleFonts.notoSans(
          fontSize: 13.5,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPaliCard(MyConsonant c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paliColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _paliColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: _paliColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pali 전용 글자',
                  style: GoogleFonts.notoSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: _paliColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  c.paliNote,
                  style: GoogleFonts.notoSans(
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonWordsCard(MyConsonant c) {
    return _Card(
      icon: Icons.menu_book_outlined,
      title: '일상 단어',
      isPali: c.isPaliOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: c.commonWords.map((w) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _speak(w.word),
                  child: Text(
                    w.word,
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: c.isPaliOnly ? _paliColor : _myBrand,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    w.ko,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (!c.isPaliOnly)
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: AppColors.textSecondary,
                    onPressed: () => _speak(w.word),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMnemonicCard(MyConsonant c) {
    return _Card(
      icon: Icons.lightbulb_outline,
      title: '암기 팁',
      isPali: c.isPaliOnly,
      child: Text(
        c.mnemonicForKorean,
        style: GoogleFonts.notoSans(
          fontSize: 13,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStackedFormCard(MyConsonant c) {
    return _Card(
      icon: Icons.layers_outlined,
      title: '결합 (stacking) 예시',
      isPali: c.isPaliOnly,
      child: Row(
        children: [
          Text(
            c.stackedFormExample,
            style: GoogleFonts.notoSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _colorFor(c),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '자음 + virama (◌်) + 자음 결합. Pali·외래어에 자주 등장.',
              style: GoogleFonts.notoSans(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: _paliColor.withValues(alpha: 0.12),
      child: Text(
        '⚠ 회색 글자는 Pali (불교 경전·법률) 전용. 외우지 마세요.',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(
          fontSize: 11.5,
          color: _paliColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool isPali;

  const _Card({
    required this.icon,
    required this.title,
    required this.child,
    this.isPali = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isPali
        ? const Color(0xFF9E9E9E)
        : const Color(0xFF5E35B1);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
