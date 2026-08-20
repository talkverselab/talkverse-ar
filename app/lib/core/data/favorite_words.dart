import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../db/app_database.dart';  // no hide needed — no name clash
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';

/// User's personal "saved" item list.
/// Backed by the same `user_progress` table as UserProgressRepo — the
/// `is_favorite` column is just a different facet of per-item state.
///
/// [ChangeNotifier] 라서 화면에서 `AnimatedBuilder(animation: FavoriteWords())`
/// 로 즐겨찾기 토글에 반응해 리빌드할 수 있다.
class FavoriteWords extends ChangeNotifier {
  static final FavoriteWords _instance = FavoriteWords._();
  factory FavoriteWords() => _instance;
  FavoriteWords._();

  AppDatabase get _db => SupabaseService.instance.db;

  final Set<String> _ids = {};

  Future<void> init() async {
    final rows = await _db.allProgress();
    _ids
      ..clear()
      ..addAll(rows.where((r) => r.isFavorite).map((r) => r.itemId));
  }

  bool isFavorite(String id) => _ids.contains(id);
  int get count => _ids.length;
  Set<String> get all => Set.unmodifiable(_ids);

  Future<void> toggle(String id) async {
    final nowFavorite = !_ids.contains(id);
    if (nowFavorite) {
      _ids.add(id);
    } else {
      _ids.remove(id);
    }
    final existing = await _db.progressFor(id);
    await _db.writeProgress(UserProgressCompanion(
      itemId: Value(id),
      isKnown: Value(existing?.isKnown ?? false),
      isFavorite: Value(nowFavorite),
      reviewScore: Value(existing?.reviewScore ?? 0),
      nextReviewAt: Value(existing?.nextReviewAt),
      updatedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
    ));
    SyncService.instance.schedulePushProgress();
    notifyListeners();
  }

  Future<void> refreshFromLocal() async {
    final rows = await _db.allProgress();
    _ids
      ..clear()
      ..addAll(rows.where((r) => r.isFavorite).map((r) => r.itemId));
  }
}

