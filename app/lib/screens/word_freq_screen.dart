import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../core/cliff.dart';
import '../core/l10n.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/learner_prefs.dart';
import '../services/tts_service.dart';
import '../widgets/reading_toggle.dart';
import '../widgets/spanish_decor.dart';
import '../widgets/word_art_thumb.dart';

/// 절벽 단어 — 이집트 구어 빈도 1~2,000위를 절벽구간(R1~R5)별 **20어 단원**으로, 단어는 **네모 타일**로 보여 준다(사용자 지시 2026-11-07, 일본어앱과 같은 구조).
/// 위 버튼 「절벽구간 단어만 / 회화 단어 포함」 — 포함이면 회화에 나오지만 2,000위 밖인 단어(conv_words_ar.json)가 「회화」 구간으로 뒤에 붙는다.
/// 검토에서 뺀 표제어(조각·사람 이름)는 표에 없고, 순위 번호는 절벽 값과 맞도록 원래대로 둔다.
class WordFreqScreen extends StatefulWidget {
  const WordFreqScreen({super.key});

  @override
  State<WordFreqScreen> createState() => _WordFreqScreenState();
}

class _WordFreqScreenState extends State<WordFreqScreen> {
  List<CliffWord> _words = [];
  List<CliffWord> _conv = [];
  bool _loading = true;
  bool _withConv = false;
  String _filter = 'ALL';

  static Map<String, _Region> get _regions {
    final c = kWordCliffs;
    return {
      'ALL': _Region(tr('전체'), AppColors.sumi),
      'R1': _Region('R1 · 1-${c[0]}', AppColors.beni),
      'R2': _Region('R2 · ${c[0] + 1}-${c[1]}', AppColors.beniLight),
      'R3': _Region('R3 · ${c[1] + 1}-${c[2]}', AppColors.kinDeep),
      'R4': _Region('R4 · ${c[2] + 1}-${c[3]}', AppColors.matcha),
      'R5': _Region('R5 · ${c[3] + 1}-$kWordCap', AppColors.muted),
      'C': _Region(tr('회화'), AppColors.ai),
    };
  }

  @override
  void initState() {
    super.initState();
    LearnerPrefs.reading.addListener(_onReading);
    _load();
  }

  void _onReading() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    LearnerPrefs.reading.removeListener(_onReading);
    super.dispose();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/data/freq/lang_ar_cliff.csv');
    final rows = const CsvToListConverter(eol: '\n', shouldParseNumbers: false).convert(raw);
    final entries = <CliffWord>[];
    for (final r in rows.skip(1)) {
      if (r.length < 7) continue;
      final rank = int.tryParse('${r[0]}') ?? 0;
      if (rank < 1 || rank > kWordCap) continue;
      entries.add(CliffWord(rank: rank, word: '${r[1]}', rd: '${r[2]}', ko: '${r[3]}', region: '${r[6]}'.trim()));
    }
    final conv = <CliffWord>[];
    try {
      final j = json.decode(await rootBundle.loadString('assets/data/freq/conv_words_ar.json')) as Map<String, dynamic>;
      var n = 0;
      for (final w in (j['words'] as List).cast<Map<String, dynamic>>()) {
        n++;
        conv.add(CliffWord(rank: n, word: w['word'] as String, rd: (w['rd'] as String?) ?? '', ko: (w['ko'] as String?) ?? '', region: 'C'));
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _words = entries;
      _conv = conv;
      _loading = false;
    });
  }

  List<CliffWord> get _pool => _withConv ? [..._words, ..._conv] : _words;

  @override
  Widget build(BuildContext context) {
    final pool = _pool;
    final filtered = _filter == 'ALL' ? pool : pool.where((w) => w.region == _filter).toList();
    final units = <List<CliffWord>>[];
    for (var i = 0; i < filtered.length; i += kWordUnit) {
      units.add(filtered.sublist(i, (i + kWordUnit).clamp(0, filtered.length)));
    }
    final chips = _regions.entries.where((e) => e.key != 'C' || _withConv).toList();

    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr('절벽 단어'), style: const TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(trf('이집트 구어 빈도 {0}위 · {1}어 단원 · 탭하면 발음', ['2,000', kWordUnit]),
                style: const TextStyle(color: AppColors.sumiLight, fontSize: 10, letterSpacing: 2)),
          ],
        ),
        actions: const [ReadingToggleAction()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.beni))
          : Column(
              children: [
                Container(
                  color: AppColors.washiDeep,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _ModeButton(label: tr('절벽구간 단어만'), selected: !_withConv, onTap: () => setState(() { _withConv = false; if (_filter == 'C') _filter = 'ALL'; })),
                          const SizedBox(width: 8),
                          _ModeButton(label: trf('회화 단어 포함 (+{0})', [_conv.length]), selected: _withConv, onTap: () => setState(() => _withConv = true)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: chips.map((e) {
                            final selected = _filter == e.key;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _filter = e.key),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: selected ? e.value.color : AppColors.washi,
                                    border: Border.all(color: e.value.color, width: selected ? 1.5 : 0.8),
                                  ),
                                  child: Text(e.value.label,
                                      style: TextStyle(color: selected ? AppColors.washi : e.value.color, fontWeight: FontWeight.w700, fontSize: 12)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const BandDivider(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 16 + bottomInset(context)),
                    itemCount: units.length,
                    itemBuilder: (context, i) => _UnitBlock(index: i + 1, words: units[i], regions: _regions),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ModeButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.sumi : AppColors.washi,
              border: Border.all(color: selected ? AppColors.sumi : AppColors.line),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label,
                style: TextStyle(color: selected ? AppColors.washi : AppColors.sumi, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ),
      );
}

/// 한 단원 = 20어. 머리줄(단원 번호·순위 범위·구간) + 네모 타일 격자.
class _UnitBlock extends StatelessWidget {
  final int index;
  final List<CliffWord> words;
  final Map<String, _Region> regions;
  const _UnitBlock({required this.index, required this.words, required this.regions});

  @override
  Widget build(BuildContext context) {
    final first = words.first;
    final last = words.last;
    final region = regions[first.region];
    final range = first.region == 'C'
        ? trf('회화 {0}-{1}', [first.rank, last.rank])
        : '#${first.rank}-${last.rank}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 6),
            child: Row(
              children: [
                Text(trf('{0}단원', [index]), style: const TextStyle(color: AppColors.sumi, fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Text(range, style: const TextStyle(color: AppColors.sumiLight, fontSize: 11)),
                const Spacer(),
                if (region != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: region.color, borderRadius: BorderRadius.circular(2)),
                    child: Text(first.region == 'C' ? tr('회화') : first.region,
                        style: const TextStyle(color: AppColors.washi, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
              ],
            ),
          ),
          // 칸 수는 자기 칸 너비 기준 — 아이패드 오른쪽 칸은 화면보다 좁다
          LayoutBuilder(
            builder: (context, c) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (c.maxWidth / 112).floor().clamp(3, 8),
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                mainAxisExtent: 124,
              ),
              itemCount: words.length,
              itemBuilder: (context, i) => _WordTile(w: words[i], color: region?.color ?? AppColors.sumi),
            ),
          ),
        ],
      ),
    );
  }
}

/// 네모 타일 — 그림(있으면) · 단어 · 읽기 · 뜻. 탭하면 발음.
class _WordTile extends StatelessWidget {
  final CliffWord w;
  final Color color;
  const _WordTile({required this.w, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 접미 표제(ـها 등)는 혼자 소리 나는 낱말이 아니라 읽어 주지 않는다
      onTap: w.word.startsWith('ـ') ? null : () => TtsService.instance.speak(w.word),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.washi,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(6),
        child: LayoutBuilder(
          builder: (context, c) {
            final art = (c.maxHeight * 0.42).clamp(28.0, 72.0);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(w.region == 'C' ? tr('회화') : '#${w.rank}', style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 4),
                    if (w.rd.isNotEmpty && LearnerPrefs.reading.value)
                      Expanded(
                        child: Text(w.rd, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 9, color: AppColors.sumiLight)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                WordArtThumb(word: w.word, size: art),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(w.word, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.sumi)),
                ),
                if (w.ko.isNotEmpty)
                  Text(w.ko, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, color: AppColors.sumiLight)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CliffWord {
  final int rank;
  final String word, rd, ko;
  final String region; // R1~R5 · C(회화 단어)
  const CliffWord({required this.rank, required this.word, required this.rd, required this.ko, required this.region});
}

class _Region {
  final String label;
  final Color color;
  const _Region(this.label, this.color);
}
