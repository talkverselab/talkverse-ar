import 'dart:convert';
import 'dart:math';

import '../core/prefs.dart';
import 'dialogue_service.dart';

/// 토크버스 커리큘럼 — 전 언어 공통 기준 `~/talkverse/CURRICULUM_SPEC.md`(2026-11-22, 사용자 원문 uk 창).
/// 회화 레벨(R0~R5)에서 편을 골라 코스 → 편마다 듣기·확인 문제 → 간격 반복 복습(1·3·7일) →
/// 코스 시험 80% 이상이면 다음 코스 → 하루 목표(새 편 1·2·3 + 복습).
/// 저장: 기기 `curriculum_v1`(전 언어 같은 키·형식 §7). `today` 칸은 오늘 분량 셈용 덧붙임.

const curriculumKey = 'curriculum_v1';
const reviewDays = [1, 3, 7];
const passPercent = 80;

String dayOf(DateTime t) =>
    '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
DateTime _parseDay(String s) => DateTime.parse(s);
String addDays(String day, int n) => dayOf(_parseDay(day).add(Duration(days: n)));

/// 점수 = 정답 수 / 문제 수, 소수점 버림(§5).
int scorePercent(int correct, int total) => total <= 0 ? 0 : (correct * 100) ~/ total;
bool passed(int correct, int total) => scorePercent(correct, total) >= passPercent;

class ReviewItem {
  final String lineId; // '<편id>#<턴 번호>'
  String due; // YYYY-MM-DD
  int step; // 0·1·2 → 1·3·7일
  ReviewItem(this.lineId, this.due, this.step);
  Map<String, dynamic> toJson() => {'lineId': lineId, 'due': due, 'step': step};
  factory ReviewItem.fromJson(Map j) => ReviewItem('${j['lineId']}', '${j['due']}', (j['step'] as num?)?.toInt() ?? 0);
  String get dialogueId => lineId.split('#').first;
  int get turn => int.tryParse(lineId.split('#').last) ?? 0;
}

class Course {
  final String id;
  final List<String> dialogueIds;
  final List<String> practiced;
  final List<int> examScores;
  String? passedAt;
  Course({required this.id, required this.dialogueIds, List<String>? practiced, List<int>? examScores, this.passedAt})
      : practiced = practiced ?? [],
        examScores = examScores ?? [];
  Map<String, dynamic> toJson() =>
      {'id': id, 'dialogueIds': dialogueIds, 'practiced': practiced, 'examScores': examScores, 'passedAt': passedAt};
  factory Course.fromJson(Map j) => Course(
        id: '${j['id']}',
        dialogueIds: [for (final e in (j['dialogueIds'] as List? ?? const [])) '$e'],
        practiced: [for (final e in (j['practiced'] as List? ?? const [])) '$e'],
        examScores: [for (final e in (j['examScores'] as List? ?? const [])) (e as num).toInt()],
        passedAt: j['passedAt'] as String?,
      );
  bool get allPracticed => dialogueIds.every(practiced.contains);
  bool get done => passedAt != null;
}

class CurriculumState {
  String? level;
  int dailyGoal; // 새 편 수: 1 가볍게 · 2 보통 · 3 집중
  Course? course;
  final List<String> passedDialogues;
  final List<ReviewItem> review;
  int streakCount;
  String? streakLastDay;
  // 덧붙임: 오늘 한 것
  String? todayDay;
  int todayNew;
  int todayReview;

  CurriculumState({
    this.level,
    this.dailyGoal = 2,
    this.course,
    List<String>? passedDialogues,
    List<ReviewItem>? review,
    this.streakCount = 0,
    this.streakLastDay,
    this.todayDay,
    this.todayNew = 0,
    this.todayReview = 0,
  })  : passedDialogues = passedDialogues ?? [],
        review = review ?? [];

  Map<String, dynamic> toJson() => {
        'level': level,
        'dailyGoal': dailyGoal,
        'course': course?.toJson(),
        'passedDialogues': passedDialogues,
        'review': [for (final r in review) r.toJson()],
        'streak': {'count': streakCount, 'lastDay': streakLastDay},
        'today': {'day': todayDay, 'new': todayNew, 'review': todayReview},
      };

  factory CurriculumState.fromJson(Map j) {
    final s = j['streak'] as Map? ?? const {};
    final t = j['today'] as Map? ?? const {};
    return CurriculumState(
      level: j['level'] as String?,
      dailyGoal: ((j['dailyGoal'] as num?)?.toInt() ?? 2).clamp(1, 3),
      course: j['course'] is Map ? Course.fromJson(j['course'] as Map) : null,
      passedDialogues: [for (final e in (j['passedDialogues'] as List? ?? const [])) '$e'],
      review: [for (final e in (j['review'] as List? ?? const [])) if (e is Map) ReviewItem.fromJson(e)],
      streakCount: (s['count'] as num?)?.toInt() ?? 0,
      streakLastDay: s['lastDay'] as String?,
      todayDay: t['day'] as String?,
      todayNew: (t['new'] as num?)?.toInt() ?? 0,
      todayReview: (t['review'] as num?)?.toInt() ?? 0,
    );
  }

  void _rollDay(String today) {
    if (todayDay == today) return;
    todayDay = today;
    todayNew = 0;
    todayReview = 0;
  }

  List<ReviewItem> dueReviews(String today) => review.where((r) => r.due.compareTo(today) <= 0).toList();

  /// 연습한 편의 줄을 복습 대기열에(이미 있으면 그대로), 틀린 줄은 1일로 되돌림.
  void addPracticed(String dialogueId, Iterable<int> turns, Set<int> wrong, String today) {
    for (final n in turns) {
      final id = '$dialogueId#$n';
      final have = review.where((r) => r.lineId == id).firstOrNull;
      if (have == null) {
        review.add(ReviewItem(id, addDays(today, reviewDays[0]), 0));
      } else if (wrong.contains(n)) {
        have
          ..step = 0
          ..due = addDays(today, reviewDays[0]);
      }
    }
  }

  /// 복습 답: 맞히면 다음 간격(7일 뒤 맞히면 졸업 — 대기열에서 뺌), 틀리면 1일로.
  void answerReview(String lineId, bool correct, String today) {
    final r = review.where((e) => e.lineId == lineId).firstOrNull;
    if (r == null) return;
    _rollDay(today);
    todayReview++;
    if (!correct) {
      r
        ..step = 0
        ..due = addDays(today, reviewDays[0]);
      return;
    }
    if (r.step >= reviewDays.length - 1) {
      review.remove(r);
      return;
    }
    r.step++;
    r.due = addDays(today, reviewDays[r.step]);
  }

  void markPracticed(String dialogueId, String today) {
    final c = course;
    if (c == null || c.practiced.contains(dialogueId)) return;
    c.practiced.add(dialogueId);
    _rollDay(today);
    if (c.examScores.isEmpty) todayNew++; // 시험에 떨어져 다시 연습한 편은 새 편으로 세지 않음
  }

  /// 시험 결과 기록. 통과면 코스 완료·편 통과 처리.
  bool recordExam(int correct, int total, String today, {Set<String> wrongDialogues = const {}}) {
    final c = course;
    if (c == null) return false;
    final sc = scorePercent(correct, total);
    c.examScores.add(sc);
    if (sc < passPercent) {
      c.practiced.removeWhere(wrongDialogues.contains); // 틀린 편만 다시 연습(§5)
      return false;
    }
    c.passedAt = today;
    for (final id in c.dialogueIds) {
      if (!passedDialogues.contains(id)) passedDialogues.add(id);
    }
    return true;
  }

  int newLeftToday(String today) => todayDay == today ? max(0, dailyGoal - todayNew) : dailyGoal;
  int newDoneToday(String today) => todayDay == today ? todayNew : 0;
  int reviewDoneToday(String today) => todayDay == today ? todayReview : 0;

  /// 오늘 분량을 다 했으면 연속 일수를 올린다(하루 한 번). [newAvailable] = 남은 새 편이 있는지.
  bool checkDayDone(String today, {required bool newAvailable}) {
    final done = dueReviews(today).isEmpty && (newLeftToday(today) == 0 || !newAvailable) &&
        (newDoneToday(today) + reviewDoneToday(today) > 0);
    if (!done || streakLastDay == today) return done;
    streakCount = streakLastDay == addDays(today, -1) ? streakCount + 1 : 1;
    streakLastDay = today;
    return true;
  }

  int streakShown(String today) =>
      (streakLastDay == today || streakLastDay == addDays(today, -1)) ? streakCount : 0;
}

/// 확인 문제 한 개. kind: 'meaning'(아랍어 줄 → 뜻 4지선다) · 'cloze'(빈칸 낱말 4지선다).
class CurQuestion {
  final String kind;
  final String dialogueId;
  final int turn;
  final String prompt; // 화면에 보일 글
  final String? hint; // 빈칸 문제의 뜻
  final List<String> options;
  final int answer;
  const CurQuestion(this.kind, this.dialogueId, this.turn, this.prompt, this.hint, this.options, this.answer);
  String get lineId => '$dialogueId#$turn';
}

String _clean(String s) => s.replaceAll(RegExp(r'\{[a-z_]+\}'), '…').replaceAll(RegExp(r'\s+'), ' ').trim();

/// 그 편의 줄로 문제를 만든다. 뜻 고르기와 빈칸 낱말 고르기를 번갈아. [pool] = 오답 보기를 꺼낼 다른 편들.
List<CurQuestion> buildQuestions(Dialogue d, {int max = 10, List<Dialogue> pool = const [], Random? rnd, Iterable<int>? onlyTurns}) {
  final r = rnd ?? Random();
  final turns = d.turns.where((t) => t.ko.trim().isNotEmpty && t.tl.trim().isNotEmpty && (onlyTurns == null || onlyTurns.contains(t.num))).toList()..shuffle(r);
  final kos = <String>{for (final x in [d, ...pool]) for (final t in x.turns) if (t.ko.trim().isNotEmpty) t.ko.trim()};
  final words = <String>{for (final x in [d, ...pool]) for (final t in x.turns) for (final l in t.lemmas) if (l.surface.length >= 2) l.surface};
  final out = <CurQuestion>[];
  for (final t in turns) {
    if (out.length >= max) break;
    final ko = t.ko.trim();
    final cand = t.lemmas.map((l) => l.surface).where((w) => w.length >= 2 && t.tl.contains(w)).toList();
    final useCloze = out.length.isOdd && cand.isNotEmpty && words.length >= 4;
    if (useCloze) {
      final w = cand[r.nextInt(cand.length)];
      final wrong = (words.where((x) => x != w).toList()..shuffle(r)).take(3).toList();
      final opts = [w, ...wrong]..shuffle(r);
      out.add(CurQuestion('cloze', d.id, t.num, _clean(t.tl.replaceFirst(w, '＿＿＿')), ko, opts, opts.indexOf(w)));
      continue;
    }
    final wrong = (kos.where((x) => x != ko).toList()..shuffle(r)).take(3).toList();
    if (wrong.length < 3) continue;
    final opts = [ko, ...wrong]..shuffle(r);
    out.add(CurQuestion('meaning', d.id, t.num, _clean(t.tl), null, opts, opts.indexOf(ko)));
  }
  return out;
}

/// 코스 시험: 편당 최소 3, 전체 최대 30(§5).
List<CurQuestion> buildExam(List<Dialogue> ds, {List<Dialogue> pool = const [], Random? rnd}) {
  if (ds.isEmpty) return const [];
  final per = max(3, 30 ~/ ds.length);
  final out = <CurQuestion>[];
  for (final d in ds) {
    out.addAll(buildQuestions(d, max: per, pool: [...ds, ...pool], rnd: rnd));
  }
  out.shuffle(rnd ?? Random());
  return out.take(30).toList();
}

/// 추천으로 채우기: 아직 통과 안 한 편에서 주제가 겹치지 않게(돌아가며) [n]개.
List<String> recommend(List<Dialogue> level, Set<String> passed, int n, {List<String> keep = const []}) {
  final out = [...keep];
  final byIsland = <String, List<Dialogue>>{};
  for (final d in level) {
    if (passed.contains(d.id) || out.contains(d.id)) continue;
    byIsland.putIfAbsent(d.island, () => []).add(d);
  }
  final used = {for (final id in out) level.where((d) => d.id == id).firstOrNull?.island};
  final keys = [...byIsland.keys.where((k) => !used.contains(k)), ...byIsland.keys.where(used.contains)];
  while (out.length < n && byIsland.values.any((l) => l.isNotEmpty)) {
    for (final k in keys) {
      if (out.length >= n) break;
      final l = byIsland[k]!;
      if (l.isNotEmpty) out.add(l.removeAt(0).id);
    }
  }
  return out;
}

class CurriculumStore {
  static Future<CurriculumState> load() async {
    try {
      final s = (await Prefs.getInstance()).getString(curriculumKey);
      if (s != null && s.isNotEmpty) return CurriculumState.fromJson(json.decode(s) as Map);
    } catch (_) {}
    return CurriculumState();
  }

  static Future<void> save(CurriculumState s) async =>
      (await Prefs.getInstance()).setString(curriculumKey, json.encode(s.toJson()));
}
