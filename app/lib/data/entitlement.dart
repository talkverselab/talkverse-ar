import 'package:flutter/material.dart';

import '../screens/paywall_screen.dart';
import '../services/curriculum_service.dart';
import '../services/dialogue_service.dart';
import 'account.dart';
import 'purchase.dart';

/// 이용권 — Talkverse 계정 이용권(lang 'ar', auth.talkverse.uk) OR 이 기기에서 산·복원한 평생 이용권(스토어). 한자 앱 entitlement.dart 와 같은 규칙.
/// 무료/유료 범위 = `~/talkverse/PAYWALL_SPEC.md`(2026-11-23, 사용자 「1 2 모두 진행」) — 판정은 [Access].
/// 가격은 스토어 값만 쓴다(코드에 원화 없음).
class Entitlement {
  Entitlement._();
  static const lang = 'ar';

  static bool get premium => Account.has(lang) || Purchase.owns(lang);

  /// 이용권이 바뀌면(구매·복원·로그인) 알림.
  static final Listenable changed = Listenable.merge([Purchase.owned, Account.user]);

  static Future<void> configure() => Purchase.configure('ar', const [
    Plan('lang_ar_1m', 1),
    Plan('lang_ar_3m', 3),
    Plan('lang_ar_1y', 12),
    Plan('lang_ar_life', 0),
    Plan('all_1y', 12, bundle: true),
    Plan('all_life', 0, bundle: true),
  ]);

  static Future<void> showPaywall(BuildContext context) => PaywallScreen.show(context);

  /// [free] 면 그냥 true, 아니면 이용권이 있으면 true, 없으면 결제 화면을 띄우고 닫힌 뒤의 이용권 여부.
  static Future<bool> gate(BuildContext context, bool free) async {
    if (free || premium) return true;
    await showPaywall(context);
    return premium;
  }
}

/// 무료/유료 경계(PAYWALL_SPEC §2). 값은 커리큘럼 JSON(서버) — 없으면 기본: 1단계·R0·R1 회화·문법 1~2스텝·언어감각 1급 무료.
class Access {
  Access._();
  static CurriculumPlan? get _plan => CurriculumService.instance.plan;

  static bool stageFree(String? key) {
    for (final s in _plan?.stages ?? const <CurStage>[]) {
      if (s.key == key) return s.free;
    }
    return key == '1';
  }

  /// 회화 편 — 무료 단계에 든 편, 어느 단계에도 없으면 R0·R1.
  static bool dialogueFree(Dialogue d) {
    final p = _plan;
    if (p != null) {
      var inAny = false;
      for (final s in p.stages) {
        if (s.dialogueIds.contains(d.id)) {
          if (s.free) return true;
          inAny = true;
        }
      }
      if (inAny) return false;
    }
    return d.region == 'R0' || d.region == 'R1';
  }

  /// 문법 스텝(1부터) · 언어감각 급(1부터).
  static bool grammarStepFree(int step) => step <= (_plan?.freeSteps ?? 2);
  static bool senseLevelFree(int level) => level <= (_plan?.freeSenseLevels ?? 1);

  static bool open(bool free) => free || Entitlement.premium;
}
