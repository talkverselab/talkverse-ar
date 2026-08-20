import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

import '../data/my_alphabet_data.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// 미얀마 결합 규칙 화면 — 4 medials + stacking_rules + position_misconception.
class MyAlphabetCombinationsScreen extends StatefulWidget {
  const MyAlphabetCombinationsScreen({super.key});

  @override
  State<MyAlphabetCombinationsScreen> createState() =>
      _MyAlphabetCombinationsScreenState();
}

class _MyAlphabetCombinationsScreenState
    extends State<MyAlphabetCombinationsScreen> {
  static const _myBrand = Color(0xFF5E35B1);

  List<MyMedial>? _medials;
  Map<String, dynamic>? _extra; // stacking_rules + position_misconception
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final medials = await MyAlphabetData.loadMedials();
    final raw = await rootBundle
        .loadString('assets/alphabet/my_combinations.json');
    final j = jsonDecode(raw) as Map<String, dynamic>;
    if (!mounted) return;
    setState(() {
      _medials = medials;
      _extra = {
        'stacking': j['stacking_rules'],
        'misconception': j['position_misconception'],
      };
    });
  }

  void _speak(String text) {
    TtsService.instance.speak(text, delay: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    final medials = _medials;
    final extra = _extra;
    if (medials == null || extra == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final selected = medials[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🔗 결합 규칙'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildMedialPicker(medials),
            const SizedBox(height: 14),
            _buildMedialDetail(selected),
            const SizedBox(height: 12),
            _buildExampleChain(selected),
            const SizedBox(height: 10),
            if (selected.commonWords.isNotEmpty) _buildCommonWords(selected),
            const SizedBox(height: 10),
            _buildLearnerNote(selected),
            const SizedBox(height: 20),
            _buildStackingRules(extra['stacking'] as Map<String, dynamic>),
            const SizedBox(height: 12),
            _buildMisconception(
                extra['misconception'] as Map<String, dynamic>),
          ],
        ),
      ),
    );
  }

  Widget _buildMedialPicker(List<MyMedial> medials) {
    return Row(
      children: List.generate(medials.length, (i) {
        final isSel = i == _selectedIndex;
        final m = medials[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == medials.length - 1 ? 0 : 6),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
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
                      m.sign,
                      style: GoogleFonts.notoSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.white : _myBrand,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m.nameKo,
                      style: GoogleFonts.notoSans(
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

  Widget _buildMedialDetail(MyMedial m) {
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
          Text('${m.sign} · ${m.nameKo}',
              style: GoogleFonts.notoSans(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _myBrand)),
          const SizedBox(height: 4),
          Text(m.nameMy,
              style: GoogleFonts.robotoMono(
                  fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('기능: ${m.functionKo}',
              style: GoogleFonts.notoSans(fontSize: 13, height: 1.5)),
          const SizedBox(height: 4),
          Text('위치: ${m.visualPosition}',
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildExampleChain(MyMedial m) {
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
              const Icon(Icons.merge_type, size: 16, color: _myBrand),
              const SizedBox(width: 6),
              Text('결합 예시 (자음 + ${m.sign})',
                  style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _myBrand)),
            ],
          ),
          const SizedBox(height: 10),
          ...m.exampleChain.map((c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () => _speak(c.withMedial),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(c.base,
                            style: GoogleFonts.notoSans(
                                fontSize: 22,
                                color: AppColors.textSecondary)),
                      ),
                      const Icon(Icons.add, size: 14, color: AppColors.textSecondary),
                      SizedBox(
                        width: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(m.sign,
                              style: GoogleFonts.notoSans(
                                  fontSize: 22,
                                  color: AppColors.textSecondary)),
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                          size: 14, color: AppColors.textSecondary),
                      SizedBox(
                        width: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(c.withMedial,
                              style: GoogleFonts.notoSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: _myBrand)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${c.rom} · ${c.koreanSound}',
                                style: GoogleFonts.notoSans(fontSize: 12)),
                            Text(c.ipa,
                                style: GoogleFonts.robotoMono(
                                    fontSize: 10.5,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.volume_up_rounded,
                          size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCommonWords(MyMedial m) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 16, color: _myBrand),
              const SizedBox(width: 6),
              Text('일상 단어',
                  style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _myBrand)),
            ],
          ),
          const SizedBox(height: 8),
          ...m.commonWords.map((w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: () => _speak(w.word),
                  child: Row(
                    children: [
                      Text(w.word,
                          style: GoogleFonts.notoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _myBrand)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(w.ko,
                              style: GoogleFonts.notoSans(fontSize: 13))),
                      if (w.rom != null)
                        Text(w.rom!,
                            style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLearnerNote(MyMedial m) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline,
              size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(m.koreanLearnerNote,
                style: GoogleFonts.notoSans(fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildStackingRules(Map<String, dynamic> stacking) {
    final desc = stacking['description_ko'] as String;
    final examples = stacking['examples'] as List;
    final note = stacking['korean_learner_note'] as String;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: _myBrand.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.layers_outlined,
                  size: 16, color: _myBrand),
              const SizedBox(width: 6),
              Text('Stacking 규칙 (자음 + virama + 자음)',
                  style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _myBrand)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc,
              style: GoogleFonts.notoSans(fontSize: 12, height: 1.5)),
          const SizedBox(height: 10),
          ...examples.map((e) {
            final m = e as Map<String, dynamic>;
            final chain = m['chain'] as String;
            final result = m['result'] as String;
            final rom = m['rom'] as String;
            final word = m['common_word'] as Map<String, dynamic>?;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(chain,
                        style: GoogleFonts.notoSans(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ),
                  const Icon(Icons.arrow_forward,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(result,
                      style: GoogleFonts.notoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _myBrand)),
                  const SizedBox(width: 8),
                  Text('/$rom/',
                      style: GoogleFonts.robotoMono(fontSize: 11)),
                  if (word != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${word['word']} (${word['ko']})',
                        style: GoogleFonts.notoSans(
                            fontSize: 11.5,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(note,
                style: GoogleFonts.notoSans(fontSize: 11.5, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildMisconception(Map<String, dynamic> m) {
    final title = m['title_ko'] as String;
    final body = m['body_ko'] as String;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline,
                  size: 16, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(title,
                  style: GoogleFonts.notoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body,
              style: GoogleFonts.notoSans(fontSize: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}
