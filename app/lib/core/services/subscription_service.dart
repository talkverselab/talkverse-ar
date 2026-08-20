import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscription tiers. Strictly ordered Free < Premium < Pro.
///   free    → L1 필수 + 키보드 연습 (무료)
///   premium → + L2~L5 (채팅/연애/여행/취미·팬덤)
///   pro     → + L6 Midnight Lounge (19+ 인증 + 이 티어 둘 다 필요)
enum SubscriptionTier { free, premium, pro }

/// Tracks the user's current subscription tier.
///
/// Tier is granted from EITHER of:
///   1. A local stored tier (set via the dev toggle in 학습 현황 screen or
///      by the future IAP / billing callbacks),
///   2. The signed-in email being on [_adminAllowlist] — used to hand
///      out Pro to internal / lab accounts without routing them through
///      a real purchase.
///
/// Any change on the auth stream re-evaluates the computed tier so
/// logging in as an allow-listed email flips the tier immediately
/// without the user touching settings.
class SubscriptionService {
  /// Persists the tier name ('free' | 'premium' | 'pro'). Replaces the
  /// old bool key `is_premium_v1`; we migrate on first init.
  static const _tierPrefsKey = 'tier_v1';

  /// Legacy bool flag — still read once at init for one-way migration
  /// to [_tierPrefsKey], then ignored.
  static const _legacyPremiumKey = 'is_premium_v1';

  /// Emails that are always treated as Pro. Kept lowercase; the
  /// comparison is case-insensitive so typing case doesn't matter.
  static const Set<String> _adminAllowlist = {
    'talkverse.lab@gmail.com',
  };

  static final SubscriptionService instance = SubscriptionService._();
  SubscriptionService._();

  late SharedPreferences _prefs;

  /// Reactive current tier. UI can ValueListenableBuilder on this.
  final ValueNotifier<SubscriptionTier> currentTierListenable =
      ValueNotifier(SubscriptionTier.free);

  /// Legacy boolean — kept for existing callsites that only care about
  /// "is paid at all". True for premium OR pro.
  final ValueNotifier<bool> isPremiumListenable = ValueNotifier(false);

  /// New: specifically gates L6 성인 콘텐츠. Only Pro flips this to true.
  final ValueNotifier<bool> isProListenable = ValueNotifier(false);

  /// True when the signed-in email is in [_adminAllowlist]. Gates dev-only
  /// affordances like the per-item memo editor on long-press.
  final ValueNotifier<bool> isAdminListenable = ValueNotifier(false);

  StreamSubscription<AuthState>? _authSub;

  SubscriptionTier get currentTier => currentTierListenable.value;
  bool get isPremium => isPremiumListenable.value;
  bool get isPro => isProListenable.value;
  bool get isAdmin => isAdminListenable.value;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _migrateLegacyFlag();
    _recompute();

    // Re-evaluate whenever the auth state flips (sign in, sign out,
    // token refresh) so allow-listed emails pick up their Pro grant
    // as soon as login completes.
    _authSub?.cancel();
    _authSub =
        Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      _recompute();
    });
  }

  /// Called by the dev toggle or real IAP callbacks.
  Future<void> setTier(SubscriptionTier tier) async {
    await _prefs.setString(_tierPrefsKey, tier.name);
    _recompute();
  }

  /// Legacy helper for existing callsites: setPremium(true) = premium,
  /// setPremium(false) = free. Doesn't touch Pro.
  Future<void> setPremium(bool value) =>
      setTier(value ? SubscriptionTier.premium : SubscriptionTier.free);

  /// Convenience for Pro paywall.
  Future<void> setPro(bool value) async {
    if (value) {
      await setTier(SubscriptionTier.pro);
    } else {
      // Dropping Pro falls back to Premium (still paid, just not adult).
      await setTier(SubscriptionTier.premium);
    }
  }

  Future<void> _migrateLegacyFlag() async {
    if (_prefs.getString(_tierPrefsKey) != null) return;
    final legacy = _prefs.getBool(_legacyPremiumKey);
    if (legacy == null) return;
    await _prefs.setString(_tierPrefsKey,
        legacy ? SubscriptionTier.premium.name : SubscriptionTier.free.name);
    await _prefs.remove(_legacyPremiumKey);
  }

  void _recompute() {
    final stored = _readStoredTier();
    final allowlisted = _isEmailAllowlisted();
    // Allow-listed accounts jump straight to Pro regardless of stored tier.
    final effective = allowlisted ? SubscriptionTier.pro : stored;
    currentTierListenable.value = effective;
    isPremiumListenable.value =
        effective.index >= SubscriptionTier.premium.index;
    isProListenable.value = effective == SubscriptionTier.pro;
    isAdminListenable.value = allowlisted;
  }

  SubscriptionTier _readStoredTier() {
    final raw = _prefs.getString(_tierPrefsKey);
    if (raw == null) {
      // Fail-safe: 운영 빌드는 기본 free. 개발 빌드에서만
      // --dart-define=DEV_UNLOCK=true 로 Pro 상태로 시작.
      const devUnlock = bool.fromEnvironment('DEV_UNLOCK');
      return devUnlock ? SubscriptionTier.pro : SubscriptionTier.free;
    }
    return SubscriptionTier.values.firstWhere(
      (t) => t.name == raw,
      orElse: () => SubscriptionTier.free,
    );
  }

  bool _isEmailAllowlisted() {
    final email =
        Supabase.instance.client.auth.currentUser?.email?.toLowerCase();
    return email != null && _adminAllowlist.contains(email);
  }
}
