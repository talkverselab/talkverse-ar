import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 어휘 빈도 기반 학습 난이도. items.tier 컬럼 값과 1:1 매칭 (소문자 enum 이름).
enum WordTier { beginner, intermediate, advanced }

extension WordTierLabel on WordTier {
  String get emoji => switch (this) {
        WordTier.beginner => '🌱',
        WordTier.intermediate => '📚',
        WordTier.advanced => '🏆',
      };

  String get label => switch (this) {
        WordTier.beginner => '초급',
        WordTier.intermediate => '중급',
        WordTier.advanced => '고급',
      };
}

/// 사용자가 선택한 난이도. 모든 메뉴 (단어외우기·회화공부·키보드·Midnight Lounge)
/// 의 콘텐츠를 이 값으로 필터링.
///
/// 영속: SharedPreferences `selected_tier`. 미선택/오류 시 beginner.
class TierService {
  TierService._();
  static final TierService instance = TierService._();

  static const _key = 'selected_tier';

  final ValueNotifier<WordTier> tier = ValueNotifier(WordTier.beginner);

  /// 앱 시작 시 1회 호출. main.dart 참조.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return;
    tier.value = WordTier.values.firstWhere(
      (t) => t.name == stored,
      orElse: () => WordTier.beginner,
    );
  }

  Future<void> setTier(WordTier t) async {
    if (tier.value == t) return;
    tier.value = t;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, t.name);
  }
}
