import 'package:drift/drift.dart' show Value;

import '../db/app_database.dart' hide UserStats;
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';

/// Streak / daily goal / activity-count tracker. Backed by Drift.
///
/// Daily goal semantics (2026-04 rewrite): `todayCount` / `dailyGoal`
/// track **sentence** practice only. Word drills are unlimited and
/// don't move the goal forward — the whole app is oriented around
/// learning sentences per day. Streaks still fire on any activity
/// (word OR sentence) so a light practice day still counts.
class UserStats {
  /// 10 sentences a day — matches the "문장을 외우는 게 포인트" product
  /// stance in the 2026-04 spec.
  static const int _defaultGoal = 10;
  static const int _maxHistoryDays = 30;

  static final UserStats _instance = UserStats._();
  factory UserStats() => _instance;
  UserStats._();

  AppDatabase get _db => SupabaseService.instance.db;

  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastStudyDate;
  int _dailyGoal = _defaultGoal;
  /// 'YYYY-MM-DD' → count
  final Map<String, int> _dailyCounts = {};

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get dailyGoal => _dailyGoal;

  int get todayCount => _dailyCounts[_todayKey()] ?? 0;
  double get todayProgress =>
      _dailyGoal == 0 ? 0 : (todayCount / _dailyGoal).clamp(0.0, 1.0);
  bool get goalReached => todayCount >= _dailyGoal;

  List<({DateTime date, int count})> last7Days() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return (date: d, count: _dailyCounts[_formatDate(d)] ?? 0);
    });
  }

  Future<void> init() async {
    final stats = await _db.getStats();
    if (stats != null) {
      _currentStreak = stats.currentStreak;
      _longestStreak = stats.longestStreak;
      _lastStudyDate = stats.lastStudyDate;
      _dailyGoal = stats.dailyGoal;
    }
    final nowKey = _todayKey();
    final since = _formatDate(
        DateTime.now().subtract(const Duration(days: _maxHistoryDays)));
    final rows = await _db.countsBetween(since, nowKey);
    _dailyCounts
      ..clear()
      ..addEntries(rows.map((r) => MapEntry(r.date, r.count)));
    _recomputeStreakIfStale();
  }

  /// Called on every UI interaction that counts as "studying".
  /// Streak always advances. `dailyCounts` (the challenge counter)
  /// only advances when [isSentence] is true.
  Future<void> recordActivity({bool isSentence = false}) async {
    final today = _todayKey();
    final lastKey = _lastStudyDate == null ? null : _formatDate(_lastStudyDate!);

    if (lastKey != today) {
      if (lastKey != null && _isYesterday(lastKey)) {
        _currentStreak += 1;
      } else {
        _currentStreak = 1;
      }
      if (_currentStreak > _longestStreak) {
        _longestStreak = _currentStreak;
      }
      _lastStudyDate = DateTime.now();
    }

    if (isSentence) {
      _dailyCounts[today] = (_dailyCounts[today] ?? 0) + 1;
      _trimHistory();
      await _persistDailyCount(today, _dailyCounts[today]!);
    }

    await _persistStats();
    SyncService.instance.schedulePushStats();
  }

  Future<void> setDailyGoal(int goal) async {
    if (goal < 1) return;
    _dailyGoal = goal;
    await _persistStats();
    SyncService.instance.schedulePushStats();
  }

  Future<void> refreshFromLocal() async {
    await init();
  }

  // ---- Internal ----

  Future<void> _persistStats() async {
    await _db.writeStats(UserStatsCompanion(
      id: const Value(1),
      currentStreak: Value(_currentStreak),
      longestStreak: Value(_longestStreak),
      lastStudyDate: Value(_lastStudyDate),
      dailyGoal: Value(_dailyGoal),
      updatedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
    ));
  }

  Future<void> _persistDailyCount(String date, int count) async {
    await _db.writeDailyCount(DailyCountsCompanion(
      date: Value(date),
      count: Value(count),
      updatedAt: Value(DateTime.now().toUtc()),
      synced: const Value(false),
    ));
  }

  void _recomputeStreakIfStale() {
    if (_lastStudyDate == null) {
      _currentStreak = 0;
      return;
    }
    final lastKey = _formatDate(_lastStudyDate!);
    final today = _todayKey();
    if (lastKey == today || _isYesterday(lastKey)) return;
    _currentStreak = 0;
  }

  void _trimHistory() {
    if (_dailyCounts.length <= _maxHistoryDays) return;
    final keys = _dailyCounts.keys.toList()..sort();
    final drop = keys.length - _maxHistoryDays;
    for (var i = 0; i < drop; i++) {
      _dailyCounts.remove(keys[i]);
    }
  }

  String _todayKey() => _formatDate(DateTime.now());

  String _formatDate(DateTime d) {
    final local = DateTime(d.year, d.month, d.day);
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  bool _isYesterday(String dateKey) {
    final parts = dateKey.split('-');
    if (parts.length != 3) return false;
    final parsed = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    return parsed.year == yesterday.year &&
        parsed.month == yesterday.month &&
        parsed.day == yesterday.day;
  }
}

