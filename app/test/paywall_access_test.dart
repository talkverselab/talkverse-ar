import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabic_universe/data/entitlement.dart';
import 'package:arabic_universe/data/purchase.dart';
import 'package:arabic_universe/services/curriculum_service.dart';
import 'package:arabic_universe/services/dialogue_service.dart';

/// 이용권 잠금 경계(PAYWALL_SPEC §2·§5): 1단계 열림 · 2단계 잠김 · 이용권 있으면 열림.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Purchase.owned.value = const {};
    final svc = CurriculumService.instance;
    await svc.ensureLoaded();
    svc.plan = CurriculumPlan.parse(File('assets/curriculum_ar.json').readAsStringSync());
  });

  test('묶음 JSON rev 2 — 1단계만 무료, 문법 2스텝·언어감각 1급 무료', () {
    final p = CurriculumService.instance.plan!;
    expect(p.rev, greaterThanOrEqualTo(2));
    expect([for (final s in p.stages) s.free], [true, false, false, false, false]);
    expect(p.freeSteps, 2);
    expect(p.freeSenseLevels, 1);
  });

  test('이용권 없음 — 1단계·R0/R1 편·문법 1~2·언어감각 1급만 열림', () {
    final ds = DialogueService.instance.list();
    final r0 = ds.firstWhere((d) => d.region == 'R0'), r3 = ds.firstWhere((d) => d.region == 'R3');
    expect(Entitlement.premium, isFalse);
    expect(Access.open(Access.stageFree('1')), isTrue);
    expect(Access.open(Access.stageFree('2')), isFalse);
    expect(Access.open(Access.dialogueFree(r0)), isTrue);
    expect(Access.open(Access.dialogueFree(r3)), isFalse);
    expect(Access.open(Access.grammarStepFree(2)), isTrue);
    expect(Access.open(Access.grammarStepFree(3)), isFalse);
    expect(Access.open(Access.senseLevelFree(1)), isTrue);
    expect(Access.open(Access.senseLevelFree(2)), isFalse);
  });

  test('이용권(언어 또는 종합) 있으면 전부 열림 · 기한 지나면 다시 잠김', () {
    final future = DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch;
    for (final id in ['lang_ar_1m', 'lang_ar_life', 'all_1y', 'all_life']) {
      Purchase.owned.value = {id: id.endsWith('life') ? 0 : future};
      expect(Entitlement.premium, isTrue, reason: id);
      expect(Access.open(Access.stageFree('5')), isTrue);
      expect(Access.open(Access.grammarStepFree(9)), isTrue);
    }
    Purchase.owned.value = {'lang_ar_1m': DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch};
    expect(Entitlement.premium, isFalse);
    Purchase.owned.value = {'lang_ja_life': 0}; // 다른 언어 이용권은 안 열림
    expect(Entitlement.premium, isFalse);
  });

  test('서버가 free 값을 바꾸면 그대로 · 값이 없으면 기본(1단계만)', () {
    final p = CurriculumPlan.parse('{"rev":3,"stages":[{"n":1,"dialogueIds":["a"]},{"n":2,"dialogueIds":["b"],"free":true}],"freeSteps":4}')!;
    CurriculumService.instance.plan = p;
    expect(Access.stageFree('1'), isTrue);
    expect(Access.stageFree('2'), isTrue);
    expect(Access.grammarStepFree(4), isTrue);
    expect(Access.senseLevelFree(2), isFalse);
  });
}
