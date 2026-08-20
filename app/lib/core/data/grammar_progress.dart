import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'grammar_content.dart';

/// 언어별 문법 학습 Day 완료 상태 추적.
///
/// 저장 키: `grammar_done_<langCode>` → '1,2,3' 형태 CSV 문자열.
/// 단순 SharedPreferences 로컬 저장. Supabase 동기화는 후속 작업.
///
/// "누적 달성(accumulated)" 개념:
///   Day N이 "진짜 달성"되려면 Day 1..N 모두 완료 필요.
///   → 건너뛰기 방지 + 매일 이전 내용 복습 유도.
///
/// Day 수는 언어별 상이 (ru=10, vi=5 등 — grammar_content.dart 참조).
class GrammarProgress extends ChangeNotifier {
  GrammarProgress._();
  static final GrammarProgress instance = GrammarProgress._();

  /// 최대 가능 Day (저장 파싱 시 상한).
  static const int _maxDaysHardLimit = 30;

  SharedPreferences? _prefs;
  final Map<String, Set<int>> _completed = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final keys = _prefs!.getKeys();
    for (final k in keys) {
      if (!k.startsWith('grammar_done_')) continue;
      final lang = k.substring('grammar_done_'.length);
      final raw = _prefs!.getString(k) ?? '';
      final set = <int>{};
      for (final p in raw.split(',')) {
        final n = int.tryParse(p.trim());
        if (n != null && n >= 1 && n <= _maxDaysHardLimit) set.add(n);
      }
      _completed[lang] = set;
    }
  }

  Set<int> _forLang(String lang) =>
      _completed.putIfAbsent(lang, () => <int>{});

  /// 해당 언어의 총 Day 수.
  int totalDaysFor(String lang) => grammarTotalDaysFor(lang);

  /// Day N을 "완료" 처리했는지 (단순 flag).
  bool isDayRead(String lang, int day) => _forLang(lang).contains(day);

  /// Day N이 "누적 달성" 상태인지 (1..N 전부 완료).
  bool isDayAchieved(String lang, int day) {
    final set = _forLang(lang);
    for (var i = 1; i <= day; i++) {
      if (!set.contains(i)) return false;
    }
    return true;
  }

  /// Day N에 접근 가능한지 (직전 Day까지 읽었거나 Day 1인 경우).
  bool isDayUnlocked(String lang, int day) {
    if (day <= 1) return true;
    return isDayRead(lang, day - 1);
  }

  /// 누적 달성된 마지막 Day (0이면 아직 아무것도 달성 안 됨).
  int accumulatedCompletedDay(String lang) {
    final total = totalDaysFor(lang);
    for (var d = total; d >= 1; d--) {
      if (isDayAchieved(lang, d)) return d;
    }
    return 0;
  }

  /// 홈 화면 "오늘 목표"용 진행률 (0.0~1.0).
  double progressFraction(String lang) {
    final total = totalDaysFor(lang);
    if (total == 0) return 0;
    return accumulatedCompletedDay(lang) / total;
  }

  /// Day N "읽기 완료" 기록.
  /// 반환: 이번 완료로 인해 새로 도달한 "누적 달성 Day" (없으면 0).
  Future<int> markDayRead(String lang, int day) async {
    final total = totalDaysFor(lang);
    if (day < 1 || day > total) return 0;
    final before = accumulatedCompletedDay(lang);
    _forLang(lang).add(day);
    await _persist(lang);
    notifyListeners();
    final after = accumulatedCompletedDay(lang);
    return after > before ? after : 0;
  }

  /// Day N 완료 해제 (다시 읽기 미완료 상태로).
  Future<void> unmarkDayRead(String lang, int day) async {
    _forLang(lang).remove(day);
    await _persist(lang);
    notifyListeners();
  }

  /// 축하 표시 대상 Day인지 (언어별 마일스톤).
  static bool shouldCelebrate(String lang, int day) =>
      grammarCelebrationDaysFor(lang).contains(day);

  Future<void> _persist(String lang) async {
    final p = _prefs;
    if (p == null) return;
    final list = _forLang(lang).toList()..sort();
    await p.setString('grammar_done_$lang', list.join(','));
  }
}
