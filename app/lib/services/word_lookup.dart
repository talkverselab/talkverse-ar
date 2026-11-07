import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dialogue_service.dart' show Lemma;

/// 앱 단어장(절벽 단어 CSV, 그다음 옛 빈도 단어 CSV) 찾기 — 문장 레마 칩용(2026-11-04, 일본어앱 `WordService.byLemmas` 의 아랍어판).
/// 철자는 모음 부호·타트윌을 지우고 أإآ→ا · ى→ي · ة→ه 로 맞춰 비교한다(레마와 단어장의 철자 차이 흡수).
class WordEntry {
  final String word, ko, rd;
  const WordEntry(this.word, this.ko, this.rd);
}

class WordLookup {
  WordLookup._();
  static final WordLookup instance = WordLookup._();
  final Map<String, WordEntry> _byKey = {};
  Future<void>? _loading;

  static final _diac = RegExp(r'[ً-ْٰـ]');
  static String key(String w) =>
      w.replaceAll(_diac, '').replaceAll(RegExp('[أإآ]'), 'ا').replaceAll('ى', 'ي').replaceAll('ة', 'ه').trim();

  Future<void> _load() async {
    try {
      // 이집트 구어 절벽 단어가 먼저(뜻·독음이 구어 기준). 접미 표제(ـها 등)는 낱말이 아니라 찾기에서 뺀다.
      final cliff = const CsvToListConverter(eol: '\n', shouldParseNumbers: false).convert(await rootBundle.loadString('assets/data/freq/lang_ar_cliff.csv'));
      for (final r in cliff.skip(1)) {
        if (r.length < 4) continue;
        final w = '${r[1]}'.trim();
        if (w.isEmpty || w.startsWith('ـ')) continue;
        _byKey.putIfAbsent(key(w), () => WordEntry(w, '${r[3]}'.trim(), '${r[2]}'.trim()));
      }
      final rows = const CsvToListConverter(eol: '\n').convert(await rootBundle.loadString('assets/data/freq/lang_es_top.csv'));
      for (final r in rows.skip(1)) {
        if (r.length < 5) continue;
        final w = '${r[1]}'.trim();
        if (w.isEmpty) continue;
        _byKey.putIfAbsent(key(w), () => WordEntry(w, '${r[4]}'.trim(), ''));
      }
    } catch (_) {}
  }

  /// 레마들 → 단어장 항목(기본형으로 찾고, 없으면 문장 속 꼴로; 없는 것은 빠짐).
  Future<Map<String, WordEntry>> byLemmas(Iterable<Lemma> lemmas) async {
    await (_loading ??= _load());
    final out = <String, WordEntry>{};
    for (final l in lemmas) {
      final e = _byKey[key(l.base)] ?? _byKey[key(l.surface)];
      if (e != null) out[l.base] = e;
    }
    return out;
  }
}
