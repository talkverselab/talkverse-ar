import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import '../config/app_config.dart';
import '../config/language_registry.dart';
import 'audio_playback_service.dart';
import 'learning_preferences.dart';

/// TTS 래퍼. 화자 구분(speaker='A'/'B'/'C')에 따라 voice + pitch 조합 변조.
///
/// **2026-04-26 갱신** — speaker → voice gender 매핑 도입:
/// - A = 남성 voice (가능 시) + pitch 1.05
/// - B = 여성 voice (가능 시) + pitch 1.10
/// - C = 남성 voice + pitch 0.92 (어른·부모)
/// - 기본 = neutral pitch 1.0
///
/// flutter_tts `getVoices()` 결과 — Android 는 voice 이름에 'male'/'female'·'#male'/'#female'
/// 또는 `gender` 필드 있음. iOS 는 `gender` 필드 직접 노출.
/// 가용 voice 없으면 graceful fallback → pitch 만 변조 (이전 동작 유지).
class TtsService {
  TtsService._internal();
  static final TtsService instance = TtsService._internal();

  /// Google TTS Standard voice 명명 (`<lang>-<region>-x-<prefix><suffix>-...`)
  /// 의 suffix alphabet → gender 매핑. 언어별 매핑 다름 (Google TTS docs 기준).
  /// 예: 'fr-fr-x-fra-network' → suffix 'a' → FR 의 'a' = female
  static const Map<String, Map<String, String>> _googleVoiceGenderMap = {
    // FR: a/c/e = female · b/d = male
    'fr': {'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male', 'e': 'female',
           'f': 'female', 'g': 'male', 'h': 'male', 'i': 'male', 'j': 'male', 'k': 'male'},
    // DE: a/c/f = female · b/d/e/g = male
    'de': {'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male', 'e': 'male',
           'f': 'female', 'g': 'male', 'h': 'male', 'i': 'male', 'j': 'male'},
    // ES: a/d = female · b/c = male
    'es': {'a': 'female', 'b': 'male', 'c': 'male', 'd': 'female', 'e': 'female',
           'f': 'female', 'g': 'male', 'h': 'male'},
    // RU: a/c/e = female · b/d = male
    'ru': {'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male', 'e': 'female',
           'f': 'female', 'g': 'male', 'h': 'male'},
    // EN: a/b/d = male · c/e/f/g/h/i/j = female (en-US 기준)
    'en': {'a': 'male', 'b': 'male', 'c': 'female', 'd': 'male', 'e': 'female',
           'f': 'female', 'g': 'female', 'h': 'female', 'i': 'female', 'j': 'female'},
    // JA: a/b = female · c/d = male
    'ja': {'a': 'female', 'b': 'female', 'c': 'male', 'd': 'male', 'e': 'female', 'f': 'male'},
    // KO: a/b = female · c/d = male
    'ko': {'a': 'female', 'b': 'female', 'c': 'male', 'd': 'male', 'e': 'female', 'f': 'male'},
    // ZH: a/d = female · b/c = male
    'zh': {'a': 'female', 'b': 'male', 'c': 'male', 'd': 'female', 'e': 'female', 'f': 'male'},
    // ID: Azure mp3 primary path (Storage). flutter_tts fallback 만 사용. default 패턴 명시.
    'id': {'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male'},
    // MS: Azure mp3 미생성 단계 — flutter_tts default 사용. ID 와 동일 패턴.
    'ms': {'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male'},
    // PT: BR 기본 (ES 부록). pt-BR Standard a/b/c/d (Google TTS docs).
    'pt': {'a': 'female', 'b': 'male', 'c': 'male', 'd': 'female', 'e': 'female', 'f': 'male'},
    // MY: my-MM voice 가용성 OS 별 다름. flutter_tts default fallback. 사전 mp3 권장.
    'my': {'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male'},
    // 기타 언어 = default (a/c/e = female, b/d = male — 가장 흔한 패턴)
  };

  /// 언어 매핑 미정 시 default (a/c/e = female, b/d = male).
  static const Map<String, String> _defaultVoiceGenderMap = {
    'a': 'female', 'b': 'male', 'c': 'female', 'd': 'male',
    'e': 'female', 'f': 'female', 'g': 'male', 'h': 'male',
    'i': 'male', 'j': 'male', 'k': 'male',
  };

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  double _lastPitch = 0;
  String? _lastLocale;
  String? _lastVoiceName;

  /// 현재 locale 의 male/female voice 캐시. setLanguage 시 갱신.
  Map<String, dynamic>? _maleVoice;
  Map<String, dynamic>? _femaleVoice;

  /// dialogue id → {speaker: gender} 매핑 (옵션 2 — JSON 로드).
  /// 예: { "de:sent:l2_d01": {"A": "male", "B": "female"} }
  Map<String, Map<String, String>> _speakerGender = {};
  String? _loadedSpeakerLang;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    // Android: Google TTS engine 강제 (Samsung TTS 는 de-DE male voice 부재 다수).
    // 가용 engine 목록 확인 → google 선호.
    try {
      final engines = await _tts.getEngines;
      if (engines is List) {
        debugPrint('[TtsService] available engines: $engines');
        final googleEngine = engines.cast<dynamic>().firstWhere(
              (e) => e is String && e.toLowerCase().contains('google'),
              orElse: () => null,
            );
        if (googleEngine is String) {
          await _tts.setEngine(googleEngine);
          debugPrint('[TtsService] engine set: $googleEngine');
        }
      }
    } catch (e) {
      debugPrint('[TtsService] engine setup skip: $e');
    }
    await _tts.setLanguage(AppConfig.ttsLocale);
    await _tts.setSpeechRate(AppConfig.ttsDefaultRate);
    await _tts.awaitSpeakCompletion(true);
    _lastLocale = AppConfig.ttsLocale;
    await _refreshVoiceCache();
    await _loadSpeakerGenderMap();
    _initialized = true;
  }

  /// 부록(appendix) 언어로 TTS locale 일시 전환 — 예: 'lo'.
  /// null 이면 주 언어 ttsLocale 로 복귀. 키보드 연습/회화 진입 직전 호출.
  Future<void> setLanguageOverride(String? appendixLang) async {
    await _ensureInit();
    final target = appendixLang == null
        ? AppConfig.ttsLocale
        : LanguageRegistry.forCode(appendixLang).ttsLocale;
    if (target != _lastLocale) {
      await _tts.setLanguage(target);
      _lastLocale = target;
      await _refreshVoiceCache();
      await _loadSpeakerGenderMap();
    }
  }

  /// 현재 lang 코드 (ttsLocale prefix). 'de-DE' → 'de'.
  String get _currentLangCode {
    final loc = _lastLocale ?? AppConfig.ttsLocale;
    return loc.toLowerCase().split('-').first;
  }

  /// `assets/tts/{lang}_speaker_gender.json` 로드. 없으면 빈 매핑 (default 매핑 사용).
  Future<void> _loadSpeakerGenderMap() async {
    final lang = _currentLangCode;
    if (_loadedSpeakerLang == lang) return;
    _speakerGender = {};
    _loadedSpeakerLang = lang;
    try {
      final raw = await rootBundle.loadString('assets/tts/${lang}_speaker_gender.json');
      final data = json.decode(raw);
      if (data is Map) {
        data.forEach((k, v) {
          if (k is String && v is Map) {
            final inner = <String, String>{};
            v.forEach((sk, sv) {
              if (sk is String && sv is String) {
                inner[sk.toUpperCase()] = sv.toLowerCase();
              }
            });
            if (inner.isNotEmpty) _speakerGender[k] = inner;
          }
        });
      }
      if (kDebugMode) {
        debugPrint('[TtsService] $lang speaker_gender.json: ${_speakerGender.length} dialogues');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[TtsService] $lang speaker_gender.json 없음 → default 매핑 (A=male/B=female/C=male)');
      }
    }
  }

  /// itemId 'de:sent:l2_d01_t05' → 'de:sent:l2_d01' (turn suffix 제거).
  String? _dialogueIdOf(String? itemId) {
    if (itemId == null) return null;
    final m = RegExp(r'^(.+?)_t\d+$').firstMatch(itemId);
    return m?.group(1);
  }

  /// JSON 매핑 또는 default 에서 gender 결정.
  String _genderFor(String speaker, String? itemId) {
    final spkUpper = speaker.toUpperCase();
    final dId = _dialogueIdOf(itemId);
    if (dId != null) {
      final mapping = _speakerGender[dId];
      if (mapping != null && mapping.containsKey(spkUpper)) {
        return mapping[spkUpper]!;
      }
    }
    // default: A=male / B=female / C=male
    switch (spkUpper) {
      case 'B':
        return 'female';
      default:
        return 'male';
    }
  }

  /// 현재 locale 의 male / female voice 를 찾아 캐시.
  /// Android: voice 이름에 'male'·'female' 키워드 / `gender` 필드 / `#male`·`#female` suffix
  /// iOS: `gender` 필드 'male'·'female'
  /// 없으면 null 유지 (pitch 만 변조).
  Future<void> _refreshVoiceCache() async {
    _maleVoice = null;
    _femaleVoice = null;
    try {
      final voices = await _tts.getVoices;
      if (voices is! List) return;
      final localeLower = (_lastLocale ?? '').toLowerCase();
      // locale prefix 매칭 (예: 'mn-MN' → 'mn' 시작)
      final localePrefix = localeLower.split('-').first;
      for (final v in voices.cast<dynamic>()) {
        if (v is! Map) continue;
        final voice = Map<String, dynamic>.from(v);
        final voiceLocale =
            (voice['locale'] as String?)?.toLowerCase() ?? '';
        if (voiceLocale != localeLower &&
            !voiceLocale.startsWith('$localePrefix-')) {
          continue;
        }
        final name = (voice['name'] as String?)?.toLowerCase() ?? '';
        final gender = (voice['gender'] as String?)?.toLowerCase() ?? '';

        // Google Android TTS voice 코드 패턴: '<lang>-<region>-x-<prefix><suffix>-...'
        // 예: 'fr-fr-x-fra-network' → suffix 'a'
        //     'de-de-x-deg-local'  → suffix 'g'
        // 언어별 매핑 dict (`_googleVoiceGenderMap`) 로 male/female 결정.
        // FR a/c/e = female · b/d = male / DE a/c/f = female · b/d/e/g = male / etc.
        String? googleMappedGender;
        final suffixMatch = RegExp(r'-x-[a-z]{2,3}([a-z])(?:-|$)').firstMatch(name);
        if (suffixMatch != null) {
          final suffix = suffixMatch.group(1)!;
          final langMap = _googleVoiceGenderMap[localePrefix] ?? _defaultVoiceGenderMap;
          googleMappedGender = langMap[suffix];
        }

        final isFemale = gender == 'female' ||
            name.contains('female') ||
            name.contains('#female') ||
            name.endsWith('-f') ||
            name.endsWith('_f') ||
            googleMappedGender == 'female';
        final isMale = gender == 'male' ||
            (name.contains('male') && !name.contains('female')) ||
            name.contains('#male') ||
            name.endsWith('-m') ||
            name.endsWith('_m') ||
            googleMappedGender == 'male';
        if (isFemale && _femaleVoice == null) _femaleVoice = voice;
        if (isMale && _maleVoice == null) _maleVoice = voice;
      }
      // 디버그 강제 출력 (production 도) — 사용자 voice 진단용. 안정 후 kDebugMode 복구.
      debugPrint('[TtsService] $_lastLocale 매칭: '
          'male=${_maleVoice?['name']} / female=${_femaleVoice?['name']}');
      // 모든 매칭 후보 voice 출력 (locale prefix 동일)
      try {
        final allVoices = await _tts.getVoices;
        if (allVoices is List) {
          final localePrefix = (_lastLocale ?? '').toLowerCase().split('-').first;
          int count = 0;
          for (final v in allVoices.cast<dynamic>()) {
            if (v is! Map) continue;
            final voice = Map<String, dynamic>.from(v);
            final loc = (voice['locale'] as String?)?.toLowerCase() ?? '';
            if (!loc.startsWith(localePrefix)) continue;
            count++;
            debugPrint('  [voice] name=${voice['name']} locale=$loc gender=${voice['gender']}');
            if (count >= 20) {
              debugPrint('  ... +more');
              break;
            }
          }
        }
      } catch (_) {}
    } catch (e) {
      if (kDebugMode) debugPrint('[TtsService] getVoices failed: $e');
    }
  }

  /// gender + speaker → (voice, pitch).
  /// male/female voice 둘 다 있으면 부드러운 pitch (1.0 / 1.05).
  /// 부재 시 (DE 등 일부 OS) → pitch 차이 강화 (남 0.85 / 여 1.20) — "모두 여성" 인식 방지.
  ({Map<String, dynamic>? voice, double pitch}) _voiceAndPitchForGender(
      String gender, String speaker) {
    final hasMale = _maleVoice != null;
    final hasFemale = _femaleVoice != null;
    final hasBoth = hasMale && hasFemale;

    if (hasBoth) {
      if (gender == 'female') return (voice: _femaleVoice, pitch: 1.05);
      final pitchM = speaker.toUpperCase() == 'C' ? 0.92 : 1.0;
      return (voice: _maleVoice, pitch: pitchM);
    }

    // voice 부재 또는 한쪽만 — pitch 차이 강화
    if (gender == 'female') {
      return (voice: _femaleVoice ?? _maleVoice, pitch: 1.20);
    }
    final pitchM = speaker.toUpperCase() == 'C' ? 0.75 : 0.85;
    return (voice: _maleVoice ?? _femaleVoice, pitch: pitchM);
  }

  /// Speaks [text] after a short [delay] (default 500ms) so playback feels
  /// less abrupt when a screen opens. Pass `Duration.zero` to skip.
  /// [speaker] = 'A' (남) | 'B' (여) | 'C' (어른) | '' (기본).
  /// [itemId] 가 주어지고 본 앱이 그 언어용 사전 생성 mp3 (Azure)를 가지면
  /// 거기로 위임 (현재 MN). 없거나 다운로드 실패 시 flutter_tts 로 fallback.
  Future<void> speak(
    String text, {
    Duration delay = const Duration(milliseconds: 500),
    String speaker = '',
    String? itemId,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    // 침묵 turn (예: '...' 무응답·점선) — 글자·숫자 없으면 발화 X.
    if (!RegExp(r'\p{L}|\p{N}', unicode: true).hasMatch(trimmed)) return;

    // Azure mp3 분기 (Decision 56: MN/DE 만)
    if (itemId != null && AudioPlaybackService.instance.canPlay(itemId)) {
      if (delay > Duration.zero) {
        await Future.delayed(delay);
      }
      final ok = await AudioPlaybackService.instance.playSentence(
        itemId,
        slow: LearningPreferences.instance.slowAudio.value,
      );
      if (ok) return;
      // fallback to flutter_tts (네트워크 실패 등)
    }

    await _ensureInit();
    await _tts.stop();

    final gender = _genderFor(speaker, itemId);
    final mapping = _voiceAndPitchForGender(gender, speaker);
    final voice = mapping.voice;
    final pitch = mapping.pitch;

    // Voice 변경 (가용 시)
    if (voice != null) {
      final voiceName = voice['name'] as String?;
      if (voiceName != null && voiceName != _lastVoiceName) {
        try {
          await _tts.setVoice({
            'name': voiceName,
            'locale': voice['locale'] as String? ?? _lastLocale ?? '',
          });
          _lastVoiceName = voiceName;
        } catch (e) {
          if (kDebugMode) debugPrint('[TtsService] setVoice failed: $e');
        }
      }
    }

    if (pitch != _lastPitch) {
      await _tts.setPitch(pitch);
      _lastPitch = pitch;
    }
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    await _tts.speak(trimmed);
  }

  Future<void> stop() async {
    await AudioPlaybackService.instance.stop();
    if (!_initialized) return;
    await _tts.stop();
  }
}
