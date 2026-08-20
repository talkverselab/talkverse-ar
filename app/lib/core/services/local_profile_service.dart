import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 단일 디바이스 로컬 닉네임 저장소 (Supabase Auth 제거 후 대체).
///
/// 닉네임은 SharedPreferences `local_nickname_v1` 에만 저장. 로그인·계정 개념 없음.
class LocalProfileService {
  static const _kNickname = 'local_nickname_v1';

  static final LocalProfileService instance = LocalProfileService._();
  LocalProfileService._();

  late SharedPreferences _prefs;
  final ValueNotifier<String?> nickname = ValueNotifier<String?>(null);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs.getString(_kNickname);
    nickname.value = (stored == null || stored.isEmpty) ? null : stored;
  }

  Future<void> setNickname(String? value) async {
    final v = value?.trim();
    if (v == null || v.isEmpty) {
      await _prefs.remove(_kNickname);
      nickname.value = null;
    } else {
      await _prefs.setString(_kNickname, v);
      nickname.value = v;
    }
  }
}
