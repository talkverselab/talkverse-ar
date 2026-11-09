import 'package:flutter/material.dart';

import '../screens/paywall_screen.dart';
import 'account.dart';
import 'purchase.dart';

/// 이용권 — Talkverse 계정 이용권(lang 'ar', auth.talkverse.uk) OR 이 기기에서 산·복원한 평생 이용권(스토어). 한자 앱 entitlement.dart 와 같은 규칙.
/// 아랍어앱은 아직 잠근 콘텐츠가 없다(무료/유료 구간 미정 — 사용자 결정) — 잠글 때 화면에서 `Entitlement.premium` 을 보고 `showPaywall` 을 띄운다.
class Entitlement {
  Entitlement._();
  static const lang = 'ar';

  static bool get premium => Account.has(lang) || Purchase.owns(lang);

  static Future<void> configure() => Purchase.configure('ar', const [
    Plan('lang_ar_1m', 1, 3900, listKrw: 5500),
    Plan('lang_ar_3m', 3, 9000, listKrw: 12900),
    Plan('lang_ar_1y', 12, 19900, listKrw: 28500),
    Plan('lang_ar_life', 0, 49000, listKrw: 69900),
    Plan('all_1y', 12, 79000, listKrw: 112900, bundle: true),
    Plan('all_life', 0, 329000, listKrw: 469000, bundle: true),
  ]);

  static Future<void> showPaywall(BuildContext context) => PaywallScreen.show(context);
}
