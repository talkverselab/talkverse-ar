/// 베트남어 동적 호칭(`{{self}}` / `{{other}}`) 치환 시스템.
///
/// `seed_vi.sql` 의 L1 row target_text 에 placeholder 가 박혀있고,
/// 사용자 프로필(시나리오) 에 따라 화면 렌더 직전에 치환된다.
///
/// 시나리오 enumeration (5개):
///   1: 여 연하 → 남 연상 (em → anh)
///   2: 여 연하 → 여 연상 (em → chị)
///   3: 남 연하 → 남 연상 (em → anh)
///   4: 남 연하 → 여 연상 (em → chị)
///   5: 동년배 친구 (tớ → cậu)
///
/// 적용 단위: row 의 `speaker` 가 'A' 인 turn 에서 `{{self}}` = 학습자 호칭,
/// 'B' 인 turn 에서는 `{{self}}` = 상대 호칭. 즉 한 dialogue 안에서
/// `{{self}}` 의 의미는 화자 입장에 따라 동적으로 바뀐다.
class ScenarioPair {
  final int id;
  final String selfVi;
  final String selfRom;
  final String otherVi;
  final String otherRom;

  const ScenarioPair({
    required this.id,
    required this.selfVi,
    required this.selfRom,
    required this.otherVi,
    required this.otherRom,
  });
}

/// 시나리오 ID → ScenarioPair preset.
const Map<int, ScenarioPair> _presets = {
  1: ScenarioPair(
    id: 1, selfVi: 'em', selfRom: '엠', otherVi: 'anh', otherRom: '안',
  ),
  2: ScenarioPair(
    id: 2, selfVi: 'em', selfRom: '엠', otherVi: 'chị', otherRom: '찌',
  ),
  3: ScenarioPair(
    id: 3, selfVi: 'em', selfRom: '엠', otherVi: 'anh', otherRom: '안',
  ),
  4: ScenarioPair(
    id: 4, selfVi: 'em', selfRom: '엠', otherVi: 'chị', otherRom: '찌',
  ),
  5: ScenarioPair(
    id: 5, selfVi: 'tớ', selfRom: '떠', otherVi: 'cậu', otherRom: '꺼우',
  ),
};

class ScenarioResolver {
  /// 시나리오 ID 로 ScenarioPair 조회. 잘못된 ID 면 시나리오 1 (default) 반환.
  static ScenarioPair pairFor(int scenarioId) {
    return _presets[scenarioId] ?? _presets[1]!;
  }

  /// `{{self}}` / `{{other}}` placeholder 를 화자(speaker) 입장에 맞춰 치환.
  ///
  /// [raw] : `target_text` 또는 `romanization` 등 원본 텍스트
  /// [pair] : 사용자 시나리오 호칭 쌍
  /// [speakerIsLearner] : 이 turn 의 발화자가 학습자 입장이면 true.
  ///                     일반적으로 row.speaker == 'A' 가 학습자.
  /// [isRomanization] : romanization 컬럼이면 true (한글 음역 매핑 사용)
  static String apply(
    String raw,
    ScenarioPair pair, {
    required bool speakerIsLearner,
    required bool isRomanization,
  }) {
    if (!raw.contains('{{')) return raw;
    final selfStr = speakerIsLearner
        ? (isRomanization ? pair.selfRom : pair.selfVi)
        : (isRomanization ? pair.otherRom : pair.otherVi);
    final otherStr = speakerIsLearner
        ? (isRomanization ? pair.otherRom : pair.otherVi)
        : (isRomanization ? pair.selfRom : pair.selfVi);
    return raw
        .replaceAll('{{self}}', selfStr)
        .replaceAll('{{other}}', otherStr);
  }
}
