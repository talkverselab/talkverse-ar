import 'package:drift/drift.dart' show Value;

import '../db/app_database.dart';  // no hide needed — no name clash
import '../models/word.dart';
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';

/// Forgetting-curve review schedule per item.
///
/// `review_score` in the shared user_progress row also doubles as the
/// learner's current stage on the forgetting curve:
///   0 = new / just reset ("몰라요" pressed) — due immediately
///   1 = passed 알아요 once           → re-appear +1 hour
///   2 = passed 알아요 twice          → re-appear +1 day
///   3 = passed 알아요 three times    → re-appear +1 week
///   4 = passed 알아요 four times     → re-appear +1 month
///   5 = mastered                     → never scheduled again
///
/// "배우는 중" is an in-session-only signal handled by the flashcard
/// screen itself (it re-queues the word in the current deck and does
/// NOT touch the DB schedule).
class WordReviews {
  static const int masteredStage = 5;

  /// Stage → time until the next review.
  /// Stage 0 is intentionally absent: we set nextReviewAt = now.
  /// Stage 5 is intentionally absent: mastered items are never rescheduled.
  static const Map<int, Duration> _intervals = {
    1: Duration(hours: 1),
    2: Duration(days: 1),
    3: Duration(days: 7),
    4: Duration(days: 30),
  };

  static final WordReviews _instance = WordReviews._();
  factory WordReviews() => _instance;
  WordReviews._();

  AppDatabase get _db => SupabaseService.instance.db;

  final Map<String, int> _scores = {};
  final Map<String, DateTime> _nextReviewAt = {};

  Future<void> init() async {
    final rows = await _db.allProgress();
    _scores
      ..clear()
      ..addEntries(rows
          .where((r) => r.reviewScore > 0)
          .map((r) => MapEntry(r.itemId, r.reviewScore)));
    _nextReviewAt
      ..clear()
      ..addEntries(rows
          .where((r) => r.nextReviewAt != null)
          .map((r) => MapEntry(r.itemId, r.nextReviewAt!)));
  }

  int stageOf(String id) => _scores[id] ?? 0;
  DateTime? dueAt(String id) => _nextReviewAt[id];

  bool isMastered(String id) => stageOf(id) >= masteredStage;

  /// An item is "due for review" when it has a scheduled date in the
  /// past (or present) and isn't already mastered. Never-seen items
  /// (no schedule row) are NOT due — they belong in the regular
  /// 단어 외우기 flow, not in 복습.
  bool isDueForReview(String id) {
    if (isMastered(id)) return false;
    final due = _nextReviewAt[id];
    if (due == null) return false;
    return !due.isAfter(DateTime.now());
  }

  int reviewDueCount(Iterable<Word> pool) =>
      pool.where((w) => isDueForReview(w.id)).length;

  List<Word> onlyDue(List<Word> pool) =>
      pool.where((w) => isDueForReview(w.id)).toList();

  /// Weaker-score first, then input order. Used when starting a deck
  /// where we want the "least known" items up front.
  List<Word> prioritize(List<Word> pool) {
    final indexed = pool.asMap().entries.toList();
    indexed.sort((a, b) {
      final sa = stageOf(a.value.id);
      final sb = stageOf(b.value.id);
      if (sa != sb) return sa.compareTo(sb);
      return a.key.compareTo(b.key);
    });
    return indexed.map((e) => e.value).toList();
  }

  /// "알아요" → advance stage and schedule the next review.
  Future<void> recordKnown(String id) async {
    final current = stageOf(id);
    final nextStage =
        current >= masteredStage ? masteredStage : current + 1;
    _scores[id] = nextStage;
    final interval = _intervals[nextStage];
    final next = interval == null ? null : DateTime.now().toUtc().add(interval);
    if (next != null) {
      _nextReviewAt[id] = next;
    } else {
      _nextReviewAt.remove(id);
    }
    await _writeProgress(id, nextStage, next);
  }

  /// "몰라요" → reset to stage 0 and mark due now.
  Future<void> recordUnknown(String id) async {
    _scores[id] = 0;
    final now = DateTime.now().toUtc();
    _nextReviewAt[id] = now;
    await _writeProgress(id, 0, now);
  }

  /// Restore this item to an arbitrary stage + next-review time. Used by
  /// the flashcard "이전 단어" undo to roll back the last 알아요/몰라요
  /// press without advancing or resetting the schedule.
  Future<void> restoreTo(String id, int stage, DateTime? next) async {
    if (stage <= 0) {
      _scores.remove(id);
    } else {
      _scores[id] = stage;
    }
    if (next == null) {
      _nextReviewAt.remove(id);
    } else {
      _nextReviewAt[id] = next;
    }
    await _writeProgress(id, stage, next);
  }

  // Legacy aliases — keep old callsites happy until the flashcard
  // screen is migrated over.
  Future<void> recordCorrect(String id) => recordKnown(id);
  Future<void> recordWrong(String id) => recordUnknown(id);

  Future<void> refreshFromLocal() async {
    await init();
  }

  Future<void> _writeProgress(String id, int stage, DateTime? next) async {
    final existing = await _db.progressFor(id);
    await _db.writeProgress(UserProgressCompanion(
      itemId: Value(id),
      isKnown: Value(existing?.isKnown ?? false),
      isFavorite: Value(existing?.isFavorite ?? false),
      reviewScore: Value(stage),
      nextReviewAt: Value(next),
      updatedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
    ));
    SyncService.instance.schedulePushProgress();
  }
}
