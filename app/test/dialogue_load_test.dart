import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabic_universe/services/dialogue_service.dart';
import 'package:arabic_universe/services/learner_prefs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('편 파일 R0~R5 를 읽고 여성 학습자판으로 바뀐다', () async {
    SharedPreferences.setMockInitialValues({});
    await rootBundle.loadString('assets/data/dialogues/R0/friends/r0_friends_a1.json');
    await DialogueService.instance.ensureLoaded();
    final all = DialogueService.instance.all;
    expect(all.length, greaterThanOrEqualTo(7)); // 11-22 65편 동기화 뒤 늘어남
    expect(all.map((d) => d.region).toSet(), {'R0', 'R1', 'R2', 'R3', 'R4', 'R5'});
    // 11-22 Grok 원고로 바뀜 — 여성 학습자판이 있는 줄 아무거나로 바뀜을 확인
    final t = all.expand((d) => d.turns).firstWhere((x) => (x.rdF ?? '').isNotEmpty);
    LearnerPrefs.gender.value = 'male';
    final m = t.rd;
    LearnerPrefs.gender.value = 'female';
    expect(t.rd, t.rdF);
    expect(t.rd, isNot(m));
    LearnerPrefs.gender.value = 'male';
  });
}
