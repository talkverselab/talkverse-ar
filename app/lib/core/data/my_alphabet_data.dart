/// 미얀마어 알파벳 학습 모듈 데이터.
///
/// 출처: `assets/alphabet/my_*.json` (자음 33 / 모음 19 / 톤 4 / 결합 4 / 메타).
/// rootBundle 로 JSON 로드 → typed class 로 파싱.
///
/// Pali only 글자는 `isPaliOnly=true` 로 표시 → UI 에서 회색 톤 처리.
library;

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

// ---------- 자음 (Consonants) ----------

class MyConsonant {
  final String letter;
  final String nameMy;
  final String nameKo;
  final String roman;
  final String ipa;
  final String koreanSoundHint;
  final String rowGroup;
  final int rowPosition;
  final bool isPaliOnly;
  final String paliNote;
  final String stackedFormExample;
  final List<MyWordExample> commonWords;
  final String mnemonicForKorean;

  const MyConsonant({
    required this.letter,
    required this.nameMy,
    required this.nameKo,
    required this.roman,
    required this.ipa,
    required this.koreanSoundHint,
    required this.rowGroup,
    required this.rowPosition,
    required this.isPaliOnly,
    required this.paliNote,
    required this.stackedFormExample,
    required this.commonWords,
    required this.mnemonicForKorean,
  });

  factory MyConsonant.fromJson(Map<String, dynamic> j) => MyConsonant(
        letter: j['letter'] as String,
        nameMy: j['name_my'] as String,
        nameKo: j['name_ko'] as String,
        roman: j['roman'] as String,
        ipa: j['ipa'] as String,
        koreanSoundHint: j['korean_sound_hint'] as String,
        rowGroup: j['row_group'] as String,
        rowPosition: j['row_position'] as int,
        isPaliOnly: j['is_pali_only'] as bool,
        paliNote: j['pali_note'] as String,
        stackedFormExample: j['stacked_form_example'] as String,
        commonWords: (j['common_words'] as List)
            .map((e) => MyWordExample.fromJson(e as Map<String, dynamic>))
            .toList(),
        mnemonicForKorean: j['mnemonic_for_korean'] as String,
      );
}

// ---------- 모음 (Vowels) ----------

class MyMedialSign {
  final String sign;
  final String nameMy;
  final String nameKo;
  final String roman;
  final String koreanSound;
  final String position;
  final String exampleWithKa;
  final MyWordExample exampleWord;
  final bool isPaliOnly;
  final String mnemonicForKorean;

  const MyMedialSign({
    required this.sign,
    required this.nameMy,
    required this.nameKo,
    required this.roman,
    required this.koreanSound,
    required this.position,
    required this.exampleWithKa,
    required this.exampleWord,
    required this.isPaliOnly,
    required this.mnemonicForKorean,
  });

  factory MyMedialSign.fromJson(Map<String, dynamic> j) => MyMedialSign(
        sign: j['sign'] as String,
        nameMy: j['name_my'] as String,
        nameKo: j['name_ko'] as String,
        roman: j['roman'] as String,
        koreanSound: j['korean_sound'] as String,
        position: j['position'] as String,
        exampleWithKa: j['example_with_ka'] as String,
        exampleWord: MyWordExample.fromJson(j['example_word'] as Map<String, dynamic>),
        isPaliOnly: j['is_pali_only'] as bool,
        mnemonicForKorean: j['mnemonic_for_korean'] as String,
      );
}

class MyIndependentVowel {
  final String letter;
  final String nameMy;
  final String nameKo;
  final String roman;
  final String koreanSound;
  final bool isPaliOnly;
  final String paliNote;
  final List<MyWordExample> commonWords;

  const MyIndependentVowel({
    required this.letter,
    required this.nameMy,
    required this.nameKo,
    required this.roman,
    required this.koreanSound,
    required this.isPaliOnly,
    required this.paliNote,
    required this.commonWords,
  });

  factory MyIndependentVowel.fromJson(Map<String, dynamic> j) => MyIndependentVowel(
        letter: j['letter'] as String,
        nameMy: j['name_my'] as String,
        nameKo: j['name_ko'] as String,
        roman: j['roman'] as String,
        koreanSound: j['korean_sound'] as String,
        isPaliOnly: j['is_pali_only'] as bool,
        paliNote: j['pali_note'] as String,
        commonWords: (j['common_words'] as List)
            .map((e) => MyWordExample.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class MyVowels {
  final List<MyMedialSign> medialSigns;
  final List<MyIndependentVowel> independentVowels;

  const MyVowels({required this.medialSigns, required this.independentVowels});

  factory MyVowels.fromJson(Map<String, dynamic> j) => MyVowels(
        medialSigns: (j['medial_signs'] as List)
            .map((e) => MyMedialSign.fromJson(e as Map<String, dynamic>))
            .toList(),
        independentVowels: (j['independent_vowels'] as List)
            .map((e) => MyIndependentVowel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ---------- 톤 (Tones) ----------

class MyToneExample {
  final String word;
  final String ipa;
  final String ko;
  final String audioHint;

  const MyToneExample({
    required this.word,
    required this.ipa,
    required this.ko,
    required this.audioHint,
  });

  factory MyToneExample.fromJson(Map<String, dynamic> j) => MyToneExample(
        word: j['word'] as String,
        ipa: j['ipa'] as String,
        ko: j['ko'] as String,
        audioHint: j['audio_hint'] as String,
      );
}

class MyTone {
  final String id;
  final String nameKo;
  final String markMy;
  final String markPosition;
  final String ipaTone;
  final int durationMsApprox;
  final String koreanAnalogy;
  final List<MyToneExample> examples;

  const MyTone({
    required this.id,
    required this.nameKo,
    required this.markMy,
    required this.markPosition,
    required this.ipaTone,
    required this.durationMsApprox,
    required this.koreanAnalogy,
    required this.examples,
  });

  factory MyTone.fromJson(Map<String, dynamic> j) => MyTone(
        id: j['id'] as String,
        nameKo: j['name_ko'] as String,
        markMy: j['mark_my'] as String,
        markPosition: j['mark_position'] as String,
        ipaTone: j['ipa_tone'] as String,
        durationMsApprox: j['duration_ms_approx'] as int,
        koreanAnalogy: j['korean_analogy'] as String,
        examples: (j['examples'] as List)
            .map((e) => MyToneExample.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class MyTones {
  final int toneCount;
  final String toneCountNote;
  final List<MyTone> tones;
  final String koreanLearnerCriticalNote;

  const MyTones({
    required this.toneCount,
    required this.toneCountNote,
    required this.tones,
    required this.koreanLearnerCriticalNote,
  });

  factory MyTones.fromJson(Map<String, dynamic> j) => MyTones(
        toneCount: j['tone_count'] as int,
        toneCountNote: j['tone_count_note'] as String,
        tones: (j['tones'] as List)
            .map((e) => MyTone.fromJson(e as Map<String, dynamic>))
            .toList(),
        koreanLearnerCriticalNote: j['korean_learner_critical_note'] as String,
      );
}

// ---------- 결합 (Combinations) ----------

class MyMedialChain {
  final String base;
  final String withMedial;
  final String ipa;
  final String koreanSound;
  final String rom;

  const MyMedialChain({
    required this.base,
    required this.withMedial,
    required this.ipa,
    required this.koreanSound,
    required this.rom,
  });

  factory MyMedialChain.fromJson(Map<String, dynamic> j) => MyMedialChain(
        base: j['base'] as String,
        withMedial: j['with_medial'] as String,
        ipa: j['ipa'] as String,
        koreanSound: j['korean_sound'] as String,
        rom: j['rom'] as String,
      );
}

class MyMedial {
  final String id;
  final String sign;
  final String nameMy;
  final String nameKo;
  final String functionKo;
  final String visualPosition;
  final List<MyMedialChain> exampleChain;
  final List<MyWordExample> commonWords;
  final String koreanLearnerNote;

  const MyMedial({
    required this.id,
    required this.sign,
    required this.nameMy,
    required this.nameKo,
    required this.functionKo,
    required this.visualPosition,
    required this.exampleChain,
    required this.commonWords,
    required this.koreanLearnerNote,
  });

  factory MyMedial.fromJson(Map<String, dynamic> j) => MyMedial(
        id: j['id'] as String,
        sign: j['sign'] as String,
        nameMy: j['name_my'] as String,
        nameKo: j['name_ko'] as String,
        functionKo: j['function_ko'] as String,
        visualPosition: j['visual_position'] as String,
        exampleChain: (j['example_chain'] as List)
            .map((e) => MyMedialChain.fromJson(e as Map<String, dynamic>))
            .toList(),
        commonWords: (j['common_words'] as List)
            .map((e) => MyWordExample.fromJson(e as Map<String, dynamic>))
            .toList(),
        koreanLearnerNote: j['korean_learner_note'] as String,
      );
}

// ---------- 공통 ----------

class MyWordExample {
  final String word;
  final String ko;
  final String? rom;

  const MyWordExample({required this.word, required this.ko, this.rom});

  factory MyWordExample.fromJson(Map<String, dynamic> j) => MyWordExample(
        word: j['word'] as String,
        ko: j['ko'] as String,
        rom: j['rom'] as String?,
      );
}

// ---------- 로더 (singleton 캐시) ----------

class MyAlphabetData {
  MyAlphabetData._();

  static List<MyConsonant>? _consonants;
  static MyVowels? _vowels;
  static MyTones? _tones;
  static List<MyMedial>? _medials;

  static Future<List<MyConsonant>> loadConsonants() async {
    if (_consonants != null) return _consonants!;
    final raw = await rootBundle.loadString('assets/alphabet/my_consonants.json');
    final list = jsonDecode(raw) as List;
    _consonants = list
        .map((e) => MyConsonant.fromJson(e as Map<String, dynamic>))
        .toList();
    return _consonants!;
  }

  static Future<MyVowels> loadVowels() async {
    if (_vowels != null) return _vowels!;
    final raw = await rootBundle.loadString('assets/alphabet/my_vowels.json');
    _vowels = MyVowels.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return _vowels!;
  }

  static Future<MyTones> loadTones() async {
    if (_tones != null) return _tones!;
    final raw = await rootBundle.loadString('assets/alphabet/my_tones.json');
    _tones = MyTones.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return _tones!;
  }

  static Future<List<MyMedial>> loadMedials() async {
    if (_medials != null) return _medials!;
    final raw = await rootBundle.loadString('assets/alphabet/my_combinations.json');
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final list = j['medials'] as List;
    _medials = list
        .map((e) => MyMedial.fromJson(e as Map<String, dynamic>))
        .toList();
    return _medials!;
  }
}
