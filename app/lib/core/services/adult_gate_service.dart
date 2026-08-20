import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent "I am 18+" unlock flag for adult-gated courses.
///
/// Course 6 items are shipped to the DB but filtered out in the UI by
/// default (see [AppConfig.adultGatedCourses]). The profile screen lets
/// the user unlock them after a modal age-confirmation dialog; the
/// unlock state is stored in SharedPreferences and survives restarts.
///
/// We intentionally do NOT sync this to Supabase — it's a per-device
/// choice, and keeping it local avoids shipping age claims over the
/// network.
class AdultGateService {
  static const _prefsKey = 'adult_unlocked_v1';

  static final AdultGateService instance = AdultGateService._();
  AdultGateService._();

  late SharedPreferences _prefs;

  /// Reactive flag: UI can `ValueListenableBuilder` on this to react
  /// to unlock / lock transitions.
  final ValueNotifier<bool> unlocked = ValueNotifier(false);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // 개발 모드 디폴트 unlock — 운영 출시 시 false 로 되돌릴 것.
    // (--dart-define=ADULT_DEFAULT_UNLOCK=false 로 끌 수 있음)
    const defaultUnlock = bool.fromEnvironment(
      'ADULT_DEFAULT_UNLOCK',
      defaultValue: true,
    );
    unlocked.value = _prefs.getBool(_prefsKey) ?? defaultUnlock;
  }

  Future<void> unlock() async {
    await _prefs.setBool(_prefsKey, true);
    unlocked.value = true;
  }

  Future<void> lock() async {
    await _prefs.setBool(_prefsKey, false);
    unlocked.value = false;
  }
}
