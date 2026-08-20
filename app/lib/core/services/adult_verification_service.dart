import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 성인 인증 상태 — L6 서브카테고리 진입에 [AdultGateService.unlocked]와
/// [SubscriptionService.isPro]와 함께 모두 true여야 통과.
///
/// 이 상태는 "법적 성인임을 증빙한" 것을 의미 (Google Play / 공동인증 / 휴대폰
/// 본인확인 등 외부 인증 결과). [AdultGateService.unlocked]는 단순 자가체크로
/// 메뉴 노출 여부만 제어하므로 별개.
///
/// 현재는 단순 로컬 플래그 — 실제 Google Play adult verification 연계는
/// TODO. verify() 호출 경로만 갖추고 플래그를 true로 세팅.
class AdultVerificationService {
  static const _prefsKey = 'adult_verified_v1';

  static final AdultVerificationService instance =
      AdultVerificationService._();
  AdultVerificationService._();

  late SharedPreferences _prefs;

  /// Reactive flag. UI uses this to show "인증 완료" vs "인증하기" buttons.
  final ValueNotifier<bool> verified = ValueNotifier(false);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Fail-safe: 운영 빌드는 기본 false (인증 미통과). 개발 빌드에서만
    // --dart-define=DEV_UNLOCK=true 로 첫 실행부터 인증 통과 상태 시작.
    const devUnlock = bool.fromEnvironment('DEV_UNLOCK');
    verified.value = _prefs.getBool(_prefsKey) ?? devUnlock;
  }

  /// Mark as verified. Called by the UI after a successful external
  /// verification flow. In dev/mock builds this is called directly from
  /// the "인증하기" button.
  Future<void> verify() async {
    await _prefs.setBool(_prefsKey, true);
    verified.value = true;
  }

  /// Clear verification — for dev/testing the gate flow.
  Future<void> clear() async {
    await _prefs.setBool(_prefsKey, false);
    verified.value = false;
  }
}
