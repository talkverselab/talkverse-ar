import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 사용자 호칭 선택 — VI dialogue 의 {ME}/{YOU} placeholder 치환에 사용.
///
/// 결정 (2026-05-07):
/// - 초기 다운로드: anh(남) / em(여) 두 개 호칭만 + 북부/남부 = 4 mp3 set
/// - 텍스트는 placeholder 치환으로 모든 호칭 지원
/// - 추가 호칭(chị, bạn, cô 등)은 추후 dialogue 데이터 확보 후 확장
///
/// MeRole = 학습자 자신의 호칭. {ME} 자리에 들어감.
/// {YOU} 는 MeRole의 거울값으로 자동 결정 (anh ↔ em).
enum MeRole {
  anh, // 남(연상) — 보통 남성 학습자
  em,  // 여(연하) 또는 자기보다 나이 많은 사람과 대화 시 사용
}

class AddressPreferenceService extends ChangeNotifier {
  AddressPreferenceService._();
  static final AddressPreferenceService instance = AddressPreferenceService._();

  static const _keyMeRole = 'address_me_role';

  MeRole _meRole = MeRole.em; // 기본 = em (가장 일반적)
  bool _initialized = false;

  MeRole get meRole => _meRole;

  /// {ME} placeholder 치환값.
  String get meText => _meRole == MeRole.anh ? 'anh' : 'em';
  /// {YOU} placeholder 치환값. anh ↔ em 거울값.
  String get youText => _meRole == MeRole.anh ? 'em' : 'anh';

  /// TTS mp3 파일 prefix — 화자(speaker A/B)별로 결정.
  /// speaker A = 학습자(자기) = meRole 기반
  /// speaker B = 상대 = youRole 기반
  /// 현재는 anh=male, em=female 로 매핑.
  String ttsGenderForSpeaker(String speaker) {
    final role = (speaker == 'A') ? _meRole : _opposite();
    return role == MeRole.anh ? 'male' : 'female';
  }

  MeRole _opposite() => _meRole == MeRole.anh ? MeRole.em : MeRole.anh;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyMeRole);
    if (stored == 'anh') _meRole = MeRole.anh;
    if (stored == 'em') _meRole = MeRole.em;
    _initialized = true;
  }

  Future<void> setMeRole(MeRole role) async {
    if (_meRole == role) return;
    _meRole = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMeRole, role == MeRole.anh ? 'anh' : 'em');
    notifyListeners();
  }

  /// {ME} / {YOU} placeholder 치환.
  /// 대문자 시작은 첫 글자만 대문자 (예: {ME} → "Anh", "Em").
  String substitute(String text) {
    if (!text.contains('{')) return text;
    return text
        .replaceAll('{ME}', _capitalizedAtStart(text, '{ME}', meText))
        .replaceAll('{YOU}', _capitalizedAtStart(text, '{YOU}', youText));
  }

  /// placeholder 가 문장 첫 단어면 대문자 시작.
  String _capitalizedAtStart(String text, String placeholder, String value) {
    final idx = text.indexOf(placeholder);
    if (idx <= 0) return value[0].toUpperCase() + value.substring(1);
    // 앞이 공백이면 본 단어 — 소문자 그대로
    return value;
  }
}
