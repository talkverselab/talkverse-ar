import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which side is shown on the flashcard/conversation "front" (prompt).
/// The other side is revealed on flip/expand.
enum StudyDirection {
  /// Show Korean first → user guesses the target language.
  /// (Productive direction — harder, more effective for memorization.)
  koreanFirst,

  /// Show target language first → user guesses Korean.
  /// (Receptive direction — easier, good for beginners.)
  targetFirst,
}

/// Global user preference for study direction, persisted locally.
class LearningPreferences {
  static const _prefsKey = 'study_direction_v1';
  static const _romanizationKey = 'show_romanization_v1';
  static const _koreanOnlyKey = 'conversation_korean_only_v1';
  static const _morphColorsKey = 'show_morph_colors_v1';
  static const _slowAudioKey = 'tts_slow_audio_v1';

  static final LearningPreferences instance = LearningPreferences._();
  LearningPreferences._();

  late SharedPreferences _prefs;
  final ValueNotifier<StudyDirection> direction =
      ValueNotifier(StudyDirection.koreanFirst);

  /// 한글 독음(romanization) 표시 여부 — 플래시카드·관련단어 미니카드·
  /// 회화 채팅 풍선 등에서 같이 토글됨. true가 기본 (학습자 친화).
  final ValueNotifier<bool> showRomanization = ValueNotifier(true);

  /// 회화문에서 대상 언어 문장 숨기고 한국어만 보기 — 자기시험용.
  /// true면 원문 + 독음 모두 숨기고 뜻(korean) 만 표시.
  /// 플래시카드에는 영향 없음 (거기선 direction 으로 대체).
  final ValueNotifier<bool> conversationKoreanOnly = ValueNotifier(false);

  /// RU 굴절 색칠 표시 (Natasha morph_tags 기반). true = 색 ON.
  /// 명사 성·동사 1식/2식·불규칙·발음법칙 갈색을 글자색으로 시각화.
  /// 비-RU 언어에는 영향 없음 (morph_tags 가 NULL).
  final ValueNotifier<bool> showMorphColors = ValueNotifier(true);

  /// 사전 생성 mp3 (Azure TTS — MN 만) 재생 시 슬로우 (-20%) 변형 사용.
  /// false = normal (0%, 자연 속도). 학습자 따라 말하기 쉽게 ON 권장.
  /// MN 외 언어는 flutter_tts 사용 — 본 토글 영향 X.
  final ValueNotifier<bool> slowAudio = ValueNotifier(false);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getInt(_prefsKey);
    if (raw != null && raw >= 0 && raw < StudyDirection.values.length) {
      direction.value = StudyDirection.values[raw];
    }
    showRomanization.value = _prefs.getBool(_romanizationKey) ?? true;
    conversationKoreanOnly.value = _prefs.getBool(_koreanOnlyKey) ?? false;
    showMorphColors.value = _prefs.getBool(_morphColorsKey) ?? true;
    slowAudio.value = _prefs.getBool(_slowAudioKey) ?? false;
  }

  Future<void> toggle() async {
    final next = direction.value == StudyDirection.koreanFirst
        ? StudyDirection.targetFirst
        : StudyDirection.koreanFirst;
    await set(next);
  }

  Future<void> set(StudyDirection value) async {
    await _prefs.setInt(_prefsKey, value.index);
    direction.value = value;
  }

  Future<void> toggleRomanization() async {
    await setRomanization(!showRomanization.value);
  }

  Future<void> setRomanization(bool value) async {
    await _prefs.setBool(_romanizationKey, value);
    showRomanization.value = value;
  }

  Future<void> toggleKoreanOnly() async {
    await setKoreanOnly(!conversationKoreanOnly.value);
  }

  Future<void> setKoreanOnly(bool value) async {
    await _prefs.setBool(_koreanOnlyKey, value);
    conversationKoreanOnly.value = value;
  }

  Future<void> toggleMorphColors() async {
    await setMorphColors(!showMorphColors.value);
  }

  Future<void> setMorphColors(bool value) async {
    await _prefs.setBool(_morphColorsKey, value);
    showMorphColors.value = value;
  }

  Future<void> toggleSlowAudio() async {
    await setSlowAudio(!slowAudio.value);
  }

  Future<void> setSlowAudio(bool value) async {
    await _prefs.setBool(_slowAudioKey, value);
    slowAudio.value = value;
  }
}
