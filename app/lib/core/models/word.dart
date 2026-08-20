import '../config/app_config.dart';
import '../services/language_service.dart';
import '../services/scenario_resolver.dart';

enum ItemType { word, sentence, phrase }

ItemType itemTypeFrom(String s) {
  switch (s) {
    case 'sentence':
      return ItemType.sentence;
    case 'phrase':
      return ItemType.phrase;
    default:
      return ItemType.word;
  }
}

class Word {
  final String id;
  final ItemType type;
  /// Text in the target language being studied (Chinese, Russian, …).
  /// May contain `{tag:text}` markers for grammar/tone highlighting.
  final String target;
  final String korean;
  final String romanization;
  final String category;
  final int course;
  final Set<String> tags;
  /// Learner-facing notes: grammar, culture, usage examples.
  final String notes;
  /// Dev-only memo (never shown in UI). For authoring context.
  final String comment;
  /// CSV of related target_text strings (max 4). Resolved to actual
  /// Word objects at render time by matching against `targetPlain`.
  final String relatedCsv;
  /// Unified root/etymon refs. CSV of ids into either `etymon.id`
  /// (`lat:am`, `ar:k-t-b`) or hanja_master with a `han:` prefix
  /// (`han:愛`). Replaces the old item_etymon N:N mapping.
  final String rootRefs;
  /// Dialogue speaker — 'A' / 'B' / '' (non-dialogue).
  final String speaker;
  /// Position within the dialogue (1, 2, 3, ...). 0 = non-dialogue.
  final int turnOrder;
  /// Scenario header shown above the dialogue script.
  final String scenario;
  /// 베트남어 남부 방언 변형 (vi 전용). NULL이면 base 사용.
  /// LanguageService.viRegion == 'south'일 때 우선 표시.
  final String? targetSouth;
  final String? koreanSouth;
  final String? romanizationSouth;
  /// 스페인어 스페인(이베리아) 변형 (es 전용). base=latam, variant=spain.
  /// LanguageService.esRegion == 'spain'일 때 우선 표시.
  final String? targetSpain;
  final String? koreanSpain;
  final String? romanizationSpain;
  /// 어휘 빈도 기반 난이도. 'beginner' / 'intermediate' / 'advanced'. NULL = KPI 외.
  final String? tier;
  /// v17 (vi 전용). true = ạ 사용 polite tone, false = 반말. row 자체에 박힘.
  /// L2~L6 row 는 default false (변환 미진행).
  final bool isPolite;
  /// v17 (vi 전용). 1~5 = 시나리오 lock, NULL = universal.
  /// 사용자 시나리오와 일치하지 않으면 dialogue 노출 제외 권장.
  final int? applicableScenario;
  /// v18 (ru 전용). Natasha 자동 색칠 메타. JSON string of token entries:
  /// `[{"t":"красивую","c":"fem"}, {"t":"лучшего","c":"masc","ph":"его"}]`
  /// NULL = 색칠 데이터 없음 (다른 언어 / 미생성). RussianMorphText 위젯이 파싱.
  final String? morphTags;

  Word({
    required this.id,
    required this.type,
    required this.target,
    required this.korean,
    required this.romanization,
    required this.category,
    this.course = 1,
    Set<String>? tags,
    this.notes = '',
    this.comment = '',
    this.relatedCsv = '',
    this.rootRefs = '',
    this.speaker = '',
    this.turnOrder = 0,
    this.scenario = '',
    this.targetSouth,
    this.koreanSouth,
    this.romanizationSouth,
    this.targetSpain,
    this.koreanSpain,
    this.romanizationSpain,
    this.tier,
    this.isPolite = false,
    this.applicableScenario,
    this.morphTags,
  }) : tags = tags ?? const {};

  /// Region-aware target text. Looks up the language-specific variant
  /// column when [region] matches a known variant for that language:
  ///   * vi south  → targetSouth
  ///   * es spain  → targetSpain
  /// NULL/empty variant falls through to the base [target].
  String targetForRegion(String region) {
    if (region == 'south' && targetSouth != null && targetSouth!.isNotEmpty) {
      return targetSouth!;
    }
    if (region == 'spain' && targetSpain != null && targetSpain!.isNotEmpty) {
      return targetSpain!;
    }
    return target;
  }

  String koreanForRegion(String region) {
    if (region == 'south' && koreanSouth != null && koreanSouth!.isNotEmpty) {
      return koreanSouth!;
    }
    if (region == 'spain' && koreanSpain != null && koreanSpain!.isNotEmpty) {
      return koreanSpain!;
    }
    return korean;
  }

  String romanizationForRegion(String region) {
    if (region == 'south' &&
        romanizationSouth != null &&
        romanizationSouth!.isNotEmpty) {
      return romanizationSouth!;
    }
    if (region == 'spain' &&
        romanizationSpain != null &&
        romanizationSpain!.isNotEmpty) {
      return romanizationSpain!;
    }
    return romanization;
  }

  /// v17: region + scenario 적용 target text.
  /// `targetForRegion` 결과에 `{{self}}/{{other}}` placeholder 치환.
  /// vi 외 언어는 placeholder 가 없으므로 동일 결과.
  String targetResolved(String region, ScenarioPair scenario) {
    return ScenarioResolver.apply(
      targetForRegion(region),
      scenario,
      speakerIsLearner: speaker == 'A',
      isRomanization: false,
    );
  }

  /// v17: region + scenario 적용 romanization.
  String romanizationResolved(String region, ScenarioPair scenario) {
    return ScenarioResolver.apply(
      romanizationForRegion(region),
      scenario,
      speakerIsLearner: speaker == 'A',
      isRomanization: true,
    );
  }

  /// v17 convenience — `LanguageService.instance` 의 현재 region + viScenario 를
  /// 자동 적용한 target 텍스트. 렌더링 사이트 default 진입점.
  /// vi 외 언어는 placeholder 가 없어서 raw target 과 동일.
  String get targetForCurrent {
    final svc = LanguageService.instance;
    return targetResolved(
      svc.viRegion.value,
      ScenarioResolver.pairFor(svc.viScenario.value),
    );
  }

  /// v17 convenience — 현재 region + scenario 적용 romanization.
  String get romanizationForCurrent {
    final svc = LanguageService.instance;
    return romanizationResolved(
      svc.viRegion.value,
      ScenarioResolver.pairFor(svc.viScenario.value),
    );
  }

  /// v17 convenience — 현재 region + scenario 적용 + grammar marker stripped.
  /// TTS·키보드 연습 등 plain 텍스트 필요할 때.
  String get targetPlainForCurrent => _stripMarkers(targetForCurrent);

  /// True when this item is part of a dialogue script (has A/B speaker).
  bool get isDialogue => speaker.isNotEmpty;

  /// Target text with `{tag:text}` markers stripped — what to feed TTS,
  /// the keyboard practice target, etc.
  String get targetPlain => _stripMarkers(target);

  bool hasTag(String tag) => tags.contains(tag);

  /// Items in course 2+ require a premium subscription.
  /// Course 1 is always free (introductory content).
  bool get isPremium => course >= 2;

  /// Parse [rootRefs] into a list of trimmed non-empty tokens.
  /// Each token is like 'han:愛' or 'lat:am'.
  List<String> get rootRefList {
    if (rootRefs.isEmpty) return const [];
    return rootRefs
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  /// Parse [relatedCsv] into a list of trimmed non-empty tokens
  /// (capped at 4 — anything beyond is dropped to enforce the 1×4
  /// row layout in the flashcard UI).
  List<String> get relatedTexts {
    if (relatedCsv.isEmpty) return const [];
    return relatedCsv
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .take(4)
        .toList();
  }
}

String _stripMarkers(String input) {
  return input.replaceAllMapped(
    RegExp(r'\{[^{}:]+:([^{}]+)\}'),
    (m) => m.group(1)!,
  );
}

class TextSegment {
  final String text;
  /// 격 (nom/gen/dat/acc/inst/prep) — 텍스트 색상 결정.
  final String? caseTag;
  /// 명사 성(性) (fem/masc/neut) — 밑줄 색상 결정.
  /// 한 세그먼트가 격과 성을 동시에 가질 수 있음 (예: {gen,fem:книги}).
  final String? genderTag;
  final bool isNew;

  const TextSegment({
    required this.text,
    this.caseTag,
    this.genderTag,
    this.isNew = false,
  });

  bool get hasHighlight => caseTag != null || genderTag != null || isNew;
}

/// 명사 성별 마커. 격 태그와 독립적으로 같은 세그먼트에 공존 가능.
const Set<String> _genderTags = {'fem', 'masc', 'neut'};

List<TextSegment> parseMarkers(String input) {
  final regex = RegExp(r'\{([^{}:]+):([^{}]+)\}');
  final segments = <TextSegment>[];
  int cursor = 0;

  for (final match in regex.allMatches(input)) {
    if (match.start > cursor) {
      segments.add(TextSegment(text: input.substring(cursor, match.start)));
    }
    final tags = match.group(1)!.split(',').map((t) => t.trim()).toSet();
    final text = match.group(2)!;
    String? caseTag;
    String? genderTag;
    for (final t in tags) {
      if (_caseTags.contains(t) && caseTag == null) caseTag = t;
      if (_genderTags.contains(t) && genderTag == null) genderTag = t;
    }
    segments.add(TextSegment(
      text: text,
      caseTag: caseTag,
      genderTag: genderTag,
      isNew: tags.contains('new'),
    ));
    cursor = match.end;
  }
  if (cursor < input.length) {
    segments.add(TextSegment(text: input.substring(cursor)));
  }
  return segments;
}

Set<String> get _caseTags => AppConfig.grammarTagNames.keys.toSet();
