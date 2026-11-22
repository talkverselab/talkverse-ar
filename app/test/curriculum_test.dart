import 'package:flutter_test/flutter_test.dart';
import 'package:arabic_universe/services/curriculum.dart';

void main() {
  test('점수 80% 경계 — 소수점 버림', () {
    expect(scorePercent(8, 10), 80);
    expect(passed(8, 10), isTrue);
    expect(scorePercent(79, 100), 79);
    expect(passed(79, 100), isFalse);
    expect(scorePercent(23, 29), 79); // 79.3 → 79
    expect(passed(23, 29), isFalse);
    expect(passed(24, 30), isTrue);
    expect(scorePercent(0, 0), 0);
  });

  test('간격 반복 1 → 3 → 7일, 틀리면 1일로, 7일 뒤 맞히면 졸업', () {
    final s = CurriculumState();
    s.addPracticed('ep', [1, 2], {}, '2026-11-22');
    expect(s.review.map((r) => r.due).toSet(), {'2026-11-23'});
    s.answerReview('ep#1', true, '2026-11-23');
    expect(s.review.firstWhere((r) => r.lineId == 'ep#1').due, '2026-11-26');
    s.answerReview('ep#1', true, '2026-11-26');
    expect(s.review.firstWhere((r) => r.lineId == 'ep#1').due, '2026-12-03');
    s.answerReview('ep#1', true, '2026-12-03');
    expect(s.review.any((r) => r.lineId == 'ep#1'), isFalse);
    s.answerReview('ep#2', true, '2026-11-23');
    s.answerReview('ep#2', false, '2026-11-26');
    final r2 = s.review.firstWhere((r) => r.lineId == 'ep#2');
    expect(r2.due, '2026-11-27');
    expect(r2.step, 0);
    expect(s.dueReviews('2026-11-26'), isEmpty);
    expect(s.dueReviews('2026-11-27').length, 1);
  });

  test('시험 통과·실패, 저장 형식 왕복, 연속 일수', () {
    final s = CurriculumState(level: 'R1');
    s.course = Course(id: 'c1', dialogueIds: ['a', 'b']);
    s.markPracticed('a', '2026-11-22');
    s.markPracticed('b', '2026-11-22');
    expect(s.course!.allPracticed, isTrue);
    expect(s.recordExam(7, 10, '2026-11-22', wrongDialogues: {'b'}), isFalse);
    expect(s.course!.practiced, ['a']);
    s.markPracticed('b', '2026-11-22');
    expect(s.todayNew, 2); // 다시 연습은 새 편으로 안 셈
    expect(s.recordExam(8, 10, '2026-11-22'), isTrue);
    expect(s.passedDialogues, ['a', 'b']);
    final back = CurriculumState.fromJson(s.toJson());
    expect(back.course!.examScores, [70, 80]);
    expect(back.course!.passedAt, '2026-11-22');
    expect(back.toJson().keys, containsAll(['level', 'dailyGoal', 'course', 'passedDialogues', 'review', 'streak']));
    expect(s.checkDayDone('2026-11-22', newAvailable: false), isTrue);
    expect(s.streakCount, 1);
    expect(addDays('2026-12-30', 3), '2027-01-02');
  });
}
