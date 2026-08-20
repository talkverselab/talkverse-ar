import 'package:drift/drift.dart' show Value;

import '../db/app_database.dart' hide UserProgress;
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';

/// Tracks which items the user marked as "known".
///
/// Reads/writes hit the local Drift DB immediately. Writes are queued for
/// Supabase sync via [SyncService] — UI never blocks on network.
class UserProgress {
  static final UserProgress _instance = UserProgress._();
  factory UserProgress() => _instance;
  UserProgress._();

  AppDatabase get _db => SupabaseService.instance.db;

  final Set<String> _known = {};

  Future<void> init() async {
    final rows = await _db.allProgress();
    _known
      ..clear()
      ..addAll(rows.where((r) => r.isKnown).map((r) => r.itemId));
  }

  bool isKnown(String id) => _known.contains(id);
  int get knownCount => _known.length;

  Future<void> markKnown(String id) async {
    if (!_known.add(id)) return;
    await _writeRow(id, isKnown: true);
  }

  Future<void> unmarkKnown(String id) async {
    if (!_known.remove(id)) return;
    await _writeRow(id, isKnown: false);
  }

  Future<void> resetAll() async {
    final ids = _known.toList();
    _known.clear();
    for (final id in ids) {
      await _writeRow(id, isKnown: false);
    }
  }

  /// Reload in-memory state from Drift. Call after a sync pull.
  Future<void> refreshFromLocal() async {
    final rows = await _db.allProgress();
    _known
      ..clear()
      ..addAll(rows.where((r) => r.isKnown).map((r) => r.itemId));
  }

  Future<void> _writeRow(String id, {required bool isKnown}) async {
    final existing = await _db.progressFor(id);
    await _db.writeProgress(UserProgressCompanion(
      itemId: Value(id),
      isKnown: Value(isKnown),
      isFavorite: Value(existing?.isFavorite ?? false),
      reviewScore: Value(existing?.reviewScore ?? 0),
      // Preserve the review schedule — we're only touching the known flag.
      nextReviewAt: Value(existing?.nextReviewAt),
      updatedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
    ));
    SyncService.instance.schedulePushProgress();
  }
}

