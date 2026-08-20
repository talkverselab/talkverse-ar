import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/my_alphabet_data.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// 미얀마 톤 화면 — 4성조 (low / high / creaky / checked).
///
/// 톤 4개를 vertical list 로 배치 + 같은 음절 (ka 계열) minimal pair 비교.
class MyAlphabetTonesScreen extends StatefulWidget {
  const MyAlphabetTonesScreen({super.key});

  @override
  State<MyAlphabetTonesScreen> createState() => _MyAlphabetTonesScreenState();
}

class _MyAlphabetTonesScreenState extends State<MyAlphabetTonesScreen> {
  static const _myBrand = Color(0xFF5E35B1);

  MyTones? _tones;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await MyAlphabetData.loadTones();
    if (!mounted) return;
    setState(() => _tones = data);
  }

  void _speak(String text) {
    TtsService.instance.speak(text, delay: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    final t = _tones;
    if (t == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final selected = t.tones[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('🎵 톤 (${t.toneCount}성조)'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTonePicker(t.tones),
            const SizedBox(height: 14),
            _buildToneDetail(selected),
            const SizedBox(height: 16),
            _buildExamples(selected),
            const SizedBox(height: 16),
            _buildMinimalPairs(t),
            const SizedBox(height: 16),
            _buildCriticalNote(t.koreanLearnerCriticalNote),
          ],
        ),
      ),
    );
  }

  Widget _buildTonePicker(List<MyTone> tones) {
    return Row(
      children: List.generate(tones.length, (i) {
        final isSel = i == _selectedIndex;
        final t = tones[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == tones.length - 1 ? 0 : 6),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSel ? _myBrand : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _myBrand.withValues(alpha: isSel ? 1 : 0.3),
                    width: isSel ? 2 : 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      t.markMy == '(없음)' ? '∅' : t.markMy,
                      style: GoogleFonts.notoSans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.white : _myBrand,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.id,
                      style: GoogleFonts.robotoMono(
                        fontSize: 9.5,
                        color: isSel ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildToneDetail(MyTone t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _myBrand.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _myBrand.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.nameKo,
            style: GoogleFonts.notoSans(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _myBrand),
          ),
          const SizedBox(height: 4),
          Text(
            'IPA: ${t.ipaTone} · 길이: ~${t.durationMsApprox}ms · 표기: ${t.markPosition}',
            style: GoogleFonts.robotoMono(
                fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 16, color: _myBrand),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.koreanAnalogy,
                    style: GoogleFonts.notoSans(
                        fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamples(MyTone t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.25),
            width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 16, color: _myBrand),
              const SizedBox(width: 6),
              Text(
                '예시 단어',
                style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _myBrand),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...t.examples.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: GestureDetector(
                  onTap: () => _speak(e.word),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          e.word,
                          style: GoogleFonts.notoSans(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _myBrand),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.ko,
                                style: GoogleFonts.notoSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            Text(
                                '${e.ipa} · ${e.audioHint}',
                                style: GoogleFonts.robotoMono(
                                    fontSize: 10.5,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.volume_up_rounded,
                          size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMinimalPairs(MyTones t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.25),
            width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows,
                  size: 16, color: _myBrand),
              const SizedBox(width: 6),
              Text(
                '톤 비교 (minimal pairs)',
                style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _myBrand),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '같은 음절 + 톤만 다름 → 의미 변화',
            style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          ..._buildMinimalPairCards(),
        ],
      ),
    );
  }

  List<Widget> _buildMinimalPairCards() {
    // minimal_pairs JSON 은 데이터 클래스에서 별도 처리하지 않았으므로
    // 직접 임베드된 형태로 렌더링 — 향후 데이터 클래스에 추가 가능.
    final pairs = [
      ('ka', [
        ('ကာ', '보호하다', 'low'),
        ('ကား', '차', 'high'),
        ('က့', '예시', 'creaky'),
        ('ကောက်', '줍다 (다른 모음)', 'checked'),
      ]),
      ('la', [
        ('လာ', '오다', 'low'),
        ('လား', '의문 어미', 'high'),
        ('လ့', '예시', 'creaky'),
        ('လုပ်', '하다 (다른 모음)', 'checked'),
      ]),
    ];
    return pairs.map((p) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              p.$1,
              style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...p.$2.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: GestureDetector(
                    onTap: () => _speak(e.$1),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(e.$1,
                              style: GoogleFonts.notoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _myBrand)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _myBrand.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(e.$3,
                              style: GoogleFonts.robotoMono(
                                  fontSize: 9, color: _myBrand)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(e.$2,
                                style:
                                    GoogleFonts.notoSans(fontSize: 12.5))),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCriticalNote(String note) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.amber.withValues(alpha: 0.5), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: GoogleFonts.notoSans(fontSize: 12.5, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
