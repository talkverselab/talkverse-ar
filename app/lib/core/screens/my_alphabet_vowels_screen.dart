import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/my_alphabet_data.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// 미얀마 모음 화면 — medial signs 12 + independent vowels 7.
///
/// 두 탭 (부호 / 독립). 자음 화면과 동일한 레이아웃 패턴.
/// Pali only 글자 회색 톤다운.
class MyAlphabetVowelsScreen extends StatefulWidget {
  const MyAlphabetVowelsScreen({super.key});

  @override
  State<MyAlphabetVowelsScreen> createState() => _MyAlphabetVowelsScreenState();
}

class _MyAlphabetVowelsScreenState extends State<MyAlphabetVowelsScreen>
    with SingleTickerProviderStateMixin {
  static const _myBrand = Color(0xFF5E35B1);
  static const _paliColor = Color(0xFF9E9E9E);

  MyVowels? _vowels;
  late TabController _tab;
  int _medialIndex = 0;
  int _indepIndex = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await MyAlphabetData.loadVowels();
    if (!mounted) return;
    setState(() => _vowels = data);
  }

  void _speak(String text) {
    TtsService.instance.speak(text, delay: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    final v = _vowels;
    if (v == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🔡 모음'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tab,
          labelColor: _myBrand,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: _myBrand,
          tabs: const [
            Tab(text: '부호 (12)'),
            Tab(text: '독립 (7)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildMedialView(v),
          _buildIndependentView(v),
        ],
      ),
    );
  }

  // ---------- medial signs (12) ----------
  Widget _buildMedialView(MyVowels v) {
    final m = v.medialSigns[_medialIndex];
    return Column(
      children: [
        _buildBar(
          itemCount: v.medialSigns.length,
          selectedIndex: _medialIndex,
          letterFor: (i) => v.medialSigns[i].sign,
          isPaliFor: (i) => v.medialSigns[i].isPaliOnly,
          onTap: (i) {
            setState(() => _medialIndex = i);
            _speak(v.medialSigns[i].exampleWithKa);
          },
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            children: [
              _buildHeader(
                title: '${m.sign} · ${m.nameKo}',
                sub: '${m.nameMy} · /${m.roman}/ · 위치: ${m.position}',
                isPali: m.isPaliOnly,
                onPlay: () => _speak(m.exampleWithKa),
              ),
              const SizedBox(height: 14),
              _buildBigCell(m.exampleWithKa, m.isPaliOnly,
                  caption: 'က + ${m.sign} = ${m.exampleWithKa}'),
              const SizedBox(height: 12),
              _Card(
                icon: Icons.record_voice_over_outlined,
                title: '한국어 음가',
                isPali: m.isPaliOnly,
                child: Text(m.koreanSound,
                    style: GoogleFonts.notoSans(fontSize: 14, height: 1.5)),
              ),
              const SizedBox(height: 10),
              _Card(
                icon: Icons.menu_book_outlined,
                title: '예시 단어',
                isPali: m.isPaliOnly,
                child: GestureDetector(
                  onTap: () => _speak(m.exampleWord.word),
                  child: Row(
                    children: [
                      Text(m.exampleWord.word,
                          style: GoogleFonts.notoSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: m.isPaliOnly ? _paliColor : _myBrand)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(m.exampleWord.ko,
                              style: GoogleFonts.notoSans(fontSize: 13))),
                      const Icon(Icons.volume_up_rounded,
                          size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _Card(
                icon: Icons.lightbulb_outline,
                title: '암기 팁',
                isPali: m.isPaliOnly,
                child: Text(m.mnemonicForKorean,
                    style: GoogleFonts.notoSans(fontSize: 13, height: 1.5)),
              ),
            ],
          ),
        ),
        _buildDisclaimer(),
      ],
    );
  }

  // ---------- independent vowels (7) ----------
  Widget _buildIndependentView(MyVowels v) {
    final iv = v.independentVowels[_indepIndex];
    return Column(
      children: [
        _buildBar(
          itemCount: v.independentVowels.length,
          selectedIndex: _indepIndex,
          letterFor: (i) => v.independentVowels[i].letter,
          isPaliFor: (i) => v.independentVowels[i].isPaliOnly,
          onTap: (i) {
            setState(() => _indepIndex = i);
            if (!v.independentVowels[i].isPaliOnly) {
              _speak(v.independentVowels[i].letter);
            }
          },
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            children: [
              _buildHeader(
                title: '${iv.letter} · ${iv.nameKo}',
                sub: '${iv.nameMy} · /${iv.roman}/',
                isPali: iv.isPaliOnly,
                onPlay: iv.isPaliOnly ? null : () => _speak(iv.letter),
              ),
              const SizedBox(height: 14),
              _buildBigCell(iv.letter, iv.isPaliOnly),
              const SizedBox(height: 12),
              _Card(
                icon: Icons.record_voice_over_outlined,
                title: '한국어 음가',
                isPali: iv.isPaliOnly,
                child: Text(iv.koreanSound,
                    style: GoogleFonts.notoSans(fontSize: 14, height: 1.5)),
              ),
              if (iv.isPaliOnly) ...[
                const SizedBox(height: 10),
                _buildPaliCard(iv.paliNote),
              ],
              if (iv.commonWords.isNotEmpty) ...[
                const SizedBox(height: 10),
                _Card(
                  icon: Icons.menu_book_outlined,
                  title: '일상 단어',
                  isPali: iv.isPaliOnly,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: iv.commonWords
                        .map((w) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(w.word,
                                      style: GoogleFonts.notoSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: iv.isPaliOnly
                                              ? _paliColor
                                              : _myBrand)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(w.ko,
                                          style: GoogleFonts.notoSans(
                                              fontSize: 13))),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
        _buildDisclaimer(),
      ],
    );
  }

  // ---------- 공통 위젯 ----------
  Widget _buildBar({
    required int itemCount,
    required int selectedIndex,
    required String Function(int) letterFor,
    required bool Function(int) isPaliFor,
    required ValueChanged<int> onTap,
  }) {
    return Container(
      height: 84,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final isSel = i == selectedIndex;
          final isPali = isPaliFor(i);
          final letterColor =
              isSel ? Colors.white : (isPali ? _paliColor : _myBrand);
          final bgColor = isSel ? (isPali ? _paliColor : _myBrand) : Colors.white;
          final borderColor = isPali ? _paliColor : _myBrand;
          return GestureDetector(
            onTap: () => onTap(i),
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
                letterFor(i),
                style: GoogleFonts.notoSans(
                  fontSize: 28,
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

  Widget _buildHeader({
    required String title,
    required String sub,
    required bool isPali,
    VoidCallback? onPlay,
  }) {
    final color = isPali ? _paliColor : _myBrand;
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
                Text(title,
                    style: GoogleFonts.notoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 2),
                Text(sub,
                    style: GoogleFonts.robotoMono(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded),
            color: color,
            tooltip: '발음 듣기',
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }

  Widget _buildBigCell(String text, bool isPali, {String? caption}) {
    final color = isPali ? _paliColor : _myBrand;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(text,
                style: GoogleFonts.notoSans(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: isPali ? _paliColor : AppColors.textPrimary)),
          ),
          if (caption != null)
            Positioned(
              bottom: 8,
              left: 12,
              child: Text(caption,
                  style: GoogleFonts.robotoMono(
                      fontSize: 11, color: AppColors.textSecondary)),
            ),
        ],
      ),
    );
  }

  Widget _buildPaliCard(String note) {
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
                Text('Pali 전용 모음',
                    style: GoogleFonts.notoSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: _paliColor)),
                const SizedBox(height: 4),
                Text(note,
                    style:
                        GoogleFonts.notoSans(fontSize: 12.5, height: 1.5)),
              ],
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
        '⚠ 회색 글자는 Pali (격식) 전용. 외우지 마세요.',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(
            fontSize: 11.5, color: _paliColor, fontWeight: FontWeight.w600),
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
    final accent = isPali ? const Color(0xFF9E9E9E) : const Color(0xFF5E35B1);
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
              Text(title,
                  style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: accent)),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
