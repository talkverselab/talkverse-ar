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
    expect(all.length, 7);
    expect(all.map((d) => d.region).toSet(), {'R0', 'R1', 'R2', 'R3', 'R4', 'R5'});
    final t = DialogueService.instance.byId('r0_friends_a1')!.turns.first;
    LearnerPrefs.gender.value = 'male';
    expect(t.rd, contains('이스막'));
    LearnerPrefs.gender.value = 'female';
    expect(t.rd, contains('이스믹'));
    LearnerPrefs.gender.value = 'male';
  });
}
