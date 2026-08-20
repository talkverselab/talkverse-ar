// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTextMeta =
      const VerificationMeta('targetText');
  @override
  late final GeneratedColumn<String> targetText = GeneratedColumn<String>(
      'target_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _koreanMeta = const VerificationMeta('korean');
  @override
  late final GeneratedColumn<String> korean = GeneratedColumn<String>(
      'korean', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _romanizationMeta =
      const VerificationMeta('romanization');
  @override
  late final GeneratedColumn<String> romanization = GeneratedColumn<String>(
      'romanization', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _targetSouthMeta =
      const VerificationMeta('targetSouth');
  @override
  late final GeneratedColumn<String> targetSouth = GeneratedColumn<String>(
      'target_south', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _koreanSouthMeta =
      const VerificationMeta('koreanSouth');
  @override
  late final GeneratedColumn<String> koreanSouth = GeneratedColumn<String>(
      'korean_south', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _romanizationSouthMeta =
      const VerificationMeta('romanizationSouth');
  @override
  late final GeneratedColumn<String> romanizationSouth =
      GeneratedColumn<String>('romanization_south', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetSpainMeta =
      const VerificationMeta('targetSpain');
  @override
  late final GeneratedColumn<String> targetSpain = GeneratedColumn<String>(
      'target_spain', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _koreanSpainMeta =
      const VerificationMeta('koreanSpain');
  @override
  late final GeneratedColumn<String> koreanSpain = GeneratedColumn<String>(
      'korean_spain', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _romanizationSpainMeta =
      const VerificationMeta('romanizationSpain');
  @override
  late final GeneratedColumn<String> romanizationSpain =
      GeneratedColumn<String>('romanization_spain', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  @override
  late final GeneratedColumn<int> course = GeneratedColumn<int>(
      'course', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _tagsCsvMeta =
      const VerificationMeta('tagsCsv');
  @override
  late final GeneratedColumn<String> tagsCsv = GeneratedColumn<String>(
      'tags_csv', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _relatedCsvMeta =
      const VerificationMeta('relatedCsv');
  @override
  late final GeneratedColumn<String> relatedCsv = GeneratedColumn<String>(
      'related_csv', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _rootRefsMeta =
      const VerificationMeta('rootRefs');
  @override
  late final GeneratedColumn<String> rootRefs = GeneratedColumn<String>(
      'root_refs', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _speakerMeta =
      const VerificationMeta('speaker');
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
      'speaker', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _turnOrderMeta =
      const VerificationMeta('turnOrder');
  @override
  late final GeneratedColumn<int> turnOrder = GeneratedColumn<int>(
      'turn_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _scenarioMeta =
      const VerificationMeta('scenario');
  @override
  late final GeneratedColumn<String> scenario = GeneratedColumn<String>(
      'scenario', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
      'tier', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dialogueOrderMeta =
      const VerificationMeta('dialogueOrder');
  @override
  late final GeneratedColumn<int> dialogueOrder = GeneratedColumn<int>(
      'dialogue_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _vocabHintsMeta =
      const VerificationMeta('vocabHints');
  @override
  late final GeneratedColumn<String> vocabHints = GeneratedColumn<String>(
      'vocab_hints', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPoliteMeta =
      const VerificationMeta('isPolite');
  @override
  late final GeneratedColumn<bool> isPolite = GeneratedColumn<bool>(
      'is_polite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_polite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _applicableScenarioMeta =
      const VerificationMeta('applicableScenario');
  @override
  late final GeneratedColumn<int> applicableScenario = GeneratedColumn<int>(
      'applicable_scenario', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _morphTagsMeta =
      const VerificationMeta('morphTags');
  @override
  late final GeneratedColumn<String> morphTags = GeneratedColumn<String>(
      'morph_tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        targetText,
        korean,
        romanization,
        targetSouth,
        koreanSouth,
        romanizationSouth,
        targetSpain,
        koreanSpain,
        romanizationSpain,
        category,
        course,
        tagsCsv,
        notes,
        comment,
        relatedCsv,
        rootRefs,
        speaker,
        turnOrder,
        scenario,
        tier,
        dialogueOrder,
        vocabHints,
        isPolite,
        applicableScenario,
        morphTags,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_text')) {
      context.handle(
          _targetTextMeta,
          targetText.isAcceptableOrUnknown(
              data['target_text']!, _targetTextMeta));
    } else if (isInserting) {
      context.missing(_targetTextMeta);
    }
    if (data.containsKey('korean')) {
      context.handle(_koreanMeta,
          korean.isAcceptableOrUnknown(data['korean']!, _koreanMeta));
    } else if (isInserting) {
      context.missing(_koreanMeta);
    }
    if (data.containsKey('romanization')) {
      context.handle(
          _romanizationMeta,
          romanization.isAcceptableOrUnknown(
              data['romanization']!, _romanizationMeta));
    }
    if (data.containsKey('target_south')) {
      context.handle(
          _targetSouthMeta,
          targetSouth.isAcceptableOrUnknown(
              data['target_south']!, _targetSouthMeta));
    }
    if (data.containsKey('korean_south')) {
      context.handle(
          _koreanSouthMeta,
          koreanSouth.isAcceptableOrUnknown(
              data['korean_south']!, _koreanSouthMeta));
    }
    if (data.containsKey('romanization_south')) {
      context.handle(
          _romanizationSouthMeta,
          romanizationSouth.isAcceptableOrUnknown(
              data['romanization_south']!, _romanizationSouthMeta));
    }
    if (data.containsKey('target_spain')) {
      context.handle(
          _targetSpainMeta,
          targetSpain.isAcceptableOrUnknown(
              data['target_spain']!, _targetSpainMeta));
    }
    if (data.containsKey('korean_spain')) {
      context.handle(
          _koreanSpainMeta,
          koreanSpain.isAcceptableOrUnknown(
              data['korean_spain']!, _koreanSpainMeta));
    }
    if (data.containsKey('romanization_spain')) {
      context.handle(
          _romanizationSpainMeta,
          romanizationSpain.isAcceptableOrUnknown(
              data['romanization_spain']!, _romanizationSpainMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('course')) {
      context.handle(_courseMeta,
          course.isAcceptableOrUnknown(data['course']!, _courseMeta));
    }
    if (data.containsKey('tags_csv')) {
      context.handle(_tagsCsvMeta,
          tagsCsv.isAcceptableOrUnknown(data['tags_csv']!, _tagsCsvMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('related_csv')) {
      context.handle(
          _relatedCsvMeta,
          relatedCsv.isAcceptableOrUnknown(
              data['related_csv']!, _relatedCsvMeta));
    }
    if (data.containsKey('root_refs')) {
      context.handle(_rootRefsMeta,
          rootRefs.isAcceptableOrUnknown(data['root_refs']!, _rootRefsMeta));
    }
    if (data.containsKey('speaker')) {
      context.handle(_speakerMeta,
          speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta));
    }
    if (data.containsKey('turn_order')) {
      context.handle(_turnOrderMeta,
          turnOrder.isAcceptableOrUnknown(data['turn_order']!, _turnOrderMeta));
    }
    if (data.containsKey('scenario')) {
      context.handle(_scenarioMeta,
          scenario.isAcceptableOrUnknown(data['scenario']!, _scenarioMeta));
    }
    if (data.containsKey('tier')) {
      context.handle(
          _tierMeta, tier.isAcceptableOrUnknown(data['tier']!, _tierMeta));
    }
    if (data.containsKey('dialogue_order')) {
      context.handle(
          _dialogueOrderMeta,
          dialogueOrder.isAcceptableOrUnknown(
              data['dialogue_order']!, _dialogueOrderMeta));
    }
    if (data.containsKey('vocab_hints')) {
      context.handle(
          _vocabHintsMeta,
          vocabHints.isAcceptableOrUnknown(
              data['vocab_hints']!, _vocabHintsMeta));
    }
    if (data.containsKey('is_polite')) {
      context.handle(_isPoliteMeta,
          isPolite.isAcceptableOrUnknown(data['is_polite']!, _isPoliteMeta));
    }
    if (data.containsKey('applicable_scenario')) {
      context.handle(
          _applicableScenarioMeta,
          applicableScenario.isAcceptableOrUnknown(
              data['applicable_scenario']!, _applicableScenarioMeta));
    }
    if (data.containsKey('morph_tags')) {
      context.handle(_morphTagsMeta,
          morphTags.isAcceptableOrUnknown(data['morph_tags']!, _morphTagsMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      targetText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_text'])!,
      korean: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}korean'])!,
      romanization: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}romanization'])!,
      targetSouth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_south']),
      koreanSouth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}korean_south']),
      romanizationSouth: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}romanization_south']),
      targetSpain: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_spain']),
      koreanSpain: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}korean_spain']),
      romanizationSpain: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}romanization_spain']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      course: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}course'])!,
      tagsCsv: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_csv'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      relatedCsv: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related_csv'])!,
      rootRefs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}root_refs'])!,
      speaker: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}speaker'])!,
      turnOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}turn_order'])!,
      scenario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario'])!,
      tier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tier']),
      dialogueOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dialogue_order'])!,
      vocabHints: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vocab_hints']),
      isPolite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_polite'])!,
      applicableScenario: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}applicable_scenario']),
      morphTags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}morph_tags']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final String id;
  final String type;
  final String targetText;
  final String korean;
  final String romanization;

  /// 베트남어 남부 방언 변형 (vi 전용). NULL이면 base targetText 사용.
  /// 사용자가 메인화면 toggle로 region='south' 선택 시, 남부 컬럼이 있으면 우선.
  /// 다른 언어는 항상 NULL.
  final String? targetSouth;
  final String? koreanSouth;
  final String? romanizationSouth;

  /// 스페인어 스페인(이베리아) 발음·어휘 변형 (es 전용). NULL이면 base 사용.
  /// 우리 dialogue는 라틴(멕시코) 기반이므로 base = latam, variant = spain.
  /// 사용자가 메인화면 toggle로 region='spain' 선택 시 우선 표시.
  final String? targetSpain;
  final String? koreanSpain;
  final String? romanizationSpain;
  final String category;
  final int course;

  /// Stored as comma-joined string in SQLite (Drift has no native list type).
  final String tagsCsv;

  /// Learner-facing notes: grammar, culture, usage examples.
  final String notes;

  /// Dev-only memo. Never shown in UI; useful for authoring/editing.
  final String comment;

  /// CSV of related target_text strings (max 4). Each token, when matched
  /// against another item's `targetPlain`, becomes a tappable mini-card on
  /// the flashcard. Empty = no related-words row.
  final String relatedCsv;

  /// Unified root/etymon refs. CSV of ids: 'han:愛' (hanja_master) or
  /// 'lat:am' / 'ar:k-t-b' (etymon). Replaces the old item_etymon table.
  final String rootRefs;

  /// Dialogue speaker — 'A' or 'B' (or '' for non-dialogue items).
  /// Items with the same `category` AND non-empty `speaker` form a
  /// single dialogue script displayed in ConversationScreen.
  final String speaker;

  /// Order of this turn within the dialogue (1, 2, 3, ...). 0 = non-dialogue.
  final int turnOrder;

  /// Free-text scenario description shown above the dialogue
  /// (e.g. "카페에서 우연한 만남"). Empty for non-dialogue items.
  final String scenario;

  /// Vocabulary tier (v15): 'beginner' / 'intermediate' / 'advanced'.
  /// Auto-assigned by freq-based classifier. NULL = not yet classified.
  final String? tier;

  /// Learner-facing dialogue order (v15). Curated interest-curve order
  /// within (language_code, course). Raw d-number ordering may differ.
  final int dialogueOrder;

  /// Vocab hints (v16): JSON array of {"w":"단어","ko":"뜻"} for off-freq
  /// words and proper nouns. Rendered as chips on flashcard front/back.
  final String? vocabHints;

  /// v17: politeness 표지 (vi). true = ạ 사용 polite, false = 반말.
  /// 알고리즘 변환 X — row 자체에 polite/casual 박혀 있음.
  final bool isPolite;

  /// v17: 회화 적용 시나리오 lock (vi). 1~5 = 시나리오 ID, NULL = universal.
  /// NULL 이 default — 모든 시나리오 사용자에게 노출. 시나리오 lock 회화는
  /// 일치하는 사용자에게만 노출하는 데 사용.
  final int? applicableScenario;

  /// v18: morph_tags (ru 전용, Natasha 자동 생성). JSON 배열 of token entries:
  /// [{"t":"красивую","c":"fem","ph":"ого"?}, ...]
  /// c = masc/fem/neut/v1/v2/irr | ph = 발음법칙 갈색 어미. 다른 언어는 NULL.
  final String? morphTags;
  final DateTime updatedAt;
  const Item(
      {required this.id,
      required this.type,
      required this.targetText,
      required this.korean,
      required this.romanization,
      this.targetSouth,
      this.koreanSouth,
      this.romanizationSouth,
      this.targetSpain,
      this.koreanSpain,
      this.romanizationSpain,
      required this.category,
      required this.course,
      required this.tagsCsv,
      required this.notes,
      required this.comment,
      required this.relatedCsv,
      required this.rootRefs,
      required this.speaker,
      required this.turnOrder,
      required this.scenario,
      this.tier,
      required this.dialogueOrder,
      this.vocabHints,
      required this.isPolite,
      this.applicableScenario,
      this.morphTags,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['target_text'] = Variable<String>(targetText);
    map['korean'] = Variable<String>(korean);
    map['romanization'] = Variable<String>(romanization);
    if (!nullToAbsent || targetSouth != null) {
      map['target_south'] = Variable<String>(targetSouth);
    }
    if (!nullToAbsent || koreanSouth != null) {
      map['korean_south'] = Variable<String>(koreanSouth);
    }
    if (!nullToAbsent || romanizationSouth != null) {
      map['romanization_south'] = Variable<String>(romanizationSouth);
    }
    if (!nullToAbsent || targetSpain != null) {
      map['target_spain'] = Variable<String>(targetSpain);
    }
    if (!nullToAbsent || koreanSpain != null) {
      map['korean_spain'] = Variable<String>(koreanSpain);
    }
    if (!nullToAbsent || romanizationSpain != null) {
      map['romanization_spain'] = Variable<String>(romanizationSpain);
    }
    map['category'] = Variable<String>(category);
    map['course'] = Variable<int>(course);
    map['tags_csv'] = Variable<String>(tagsCsv);
    map['notes'] = Variable<String>(notes);
    map['comment'] = Variable<String>(comment);
    map['related_csv'] = Variable<String>(relatedCsv);
    map['root_refs'] = Variable<String>(rootRefs);
    map['speaker'] = Variable<String>(speaker);
    map['turn_order'] = Variable<int>(turnOrder);
    map['scenario'] = Variable<String>(scenario);
    if (!nullToAbsent || tier != null) {
      map['tier'] = Variable<String>(tier);
    }
    map['dialogue_order'] = Variable<int>(dialogueOrder);
    if (!nullToAbsent || vocabHints != null) {
      map['vocab_hints'] = Variable<String>(vocabHints);
    }
    map['is_polite'] = Variable<bool>(isPolite);
    if (!nullToAbsent || applicableScenario != null) {
      map['applicable_scenario'] = Variable<int>(applicableScenario);
    }
    if (!nullToAbsent || morphTags != null) {
      map['morph_tags'] = Variable<String>(morphTags);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      type: Value(type),
      targetText: Value(targetText),
      korean: Value(korean),
      romanization: Value(romanization),
      targetSouth: targetSouth == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSouth),
      koreanSouth: koreanSouth == null && nullToAbsent
          ? const Value.absent()
          : Value(koreanSouth),
      romanizationSouth: romanizationSouth == null && nullToAbsent
          ? const Value.absent()
          : Value(romanizationSouth),
      targetSpain: targetSpain == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSpain),
      koreanSpain: koreanSpain == null && nullToAbsent
          ? const Value.absent()
          : Value(koreanSpain),
      romanizationSpain: romanizationSpain == null && nullToAbsent
          ? const Value.absent()
          : Value(romanizationSpain),
      category: Value(category),
      course: Value(course),
      tagsCsv: Value(tagsCsv),
      notes: Value(notes),
      comment: Value(comment),
      relatedCsv: Value(relatedCsv),
      rootRefs: Value(rootRefs),
      speaker: Value(speaker),
      turnOrder: Value(turnOrder),
      scenario: Value(scenario),
      tier: tier == null && nullToAbsent ? const Value.absent() : Value(tier),
      dialogueOrder: Value(dialogueOrder),
      vocabHints: vocabHints == null && nullToAbsent
          ? const Value.absent()
          : Value(vocabHints),
      isPolite: Value(isPolite),
      applicableScenario: applicableScenario == null && nullToAbsent
          ? const Value.absent()
          : Value(applicableScenario),
      morphTags: morphTags == null && nullToAbsent
          ? const Value.absent()
          : Value(morphTags),
      updatedAt: Value(updatedAt),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      targetText: serializer.fromJson<String>(json['targetText']),
      korean: serializer.fromJson<String>(json['korean']),
      romanization: serializer.fromJson<String>(json['romanization']),
      targetSouth: serializer.fromJson<String?>(json['targetSouth']),
      koreanSouth: serializer.fromJson<String?>(json['koreanSouth']),
      romanizationSouth:
          serializer.fromJson<String?>(json['romanizationSouth']),
      targetSpain: serializer.fromJson<String?>(json['targetSpain']),
      koreanSpain: serializer.fromJson<String?>(json['koreanSpain']),
      romanizationSpain:
          serializer.fromJson<String?>(json['romanizationSpain']),
      category: serializer.fromJson<String>(json['category']),
      course: serializer.fromJson<int>(json['course']),
      tagsCsv: serializer.fromJson<String>(json['tagsCsv']),
      notes: serializer.fromJson<String>(json['notes']),
      comment: serializer.fromJson<String>(json['comment']),
      relatedCsv: serializer.fromJson<String>(json['relatedCsv']),
      rootRefs: serializer.fromJson<String>(json['rootRefs']),
      speaker: serializer.fromJson<String>(json['speaker']),
      turnOrder: serializer.fromJson<int>(json['turnOrder']),
      scenario: serializer.fromJson<String>(json['scenario']),
      tier: serializer.fromJson<String?>(json['tier']),
      dialogueOrder: serializer.fromJson<int>(json['dialogueOrder']),
      vocabHints: serializer.fromJson<String?>(json['vocabHints']),
      isPolite: serializer.fromJson<bool>(json['isPolite']),
      applicableScenario: serializer.fromJson<int?>(json['applicableScenario']),
      morphTags: serializer.fromJson<String?>(json['morphTags']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'targetText': serializer.toJson<String>(targetText),
      'korean': serializer.toJson<String>(korean),
      'romanization': serializer.toJson<String>(romanization),
      'targetSouth': serializer.toJson<String?>(targetSouth),
      'koreanSouth': serializer.toJson<String?>(koreanSouth),
      'romanizationSouth': serializer.toJson<String?>(romanizationSouth),
      'targetSpain': serializer.toJson<String?>(targetSpain),
      'koreanSpain': serializer.toJson<String?>(koreanSpain),
      'romanizationSpain': serializer.toJson<String?>(romanizationSpain),
      'category': serializer.toJson<String>(category),
      'course': serializer.toJson<int>(course),
      'tagsCsv': serializer.toJson<String>(tagsCsv),
      'notes': serializer.toJson<String>(notes),
      'comment': serializer.toJson<String>(comment),
      'relatedCsv': serializer.toJson<String>(relatedCsv),
      'rootRefs': serializer.toJson<String>(rootRefs),
      'speaker': serializer.toJson<String>(speaker),
      'turnOrder': serializer.toJson<int>(turnOrder),
      'scenario': serializer.toJson<String>(scenario),
      'tier': serializer.toJson<String?>(tier),
      'dialogueOrder': serializer.toJson<int>(dialogueOrder),
      'vocabHints': serializer.toJson<String?>(vocabHints),
      'isPolite': serializer.toJson<bool>(isPolite),
      'applicableScenario': serializer.toJson<int?>(applicableScenario),
      'morphTags': serializer.toJson<String?>(morphTags),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Item copyWith(
          {String? id,
          String? type,
          String? targetText,
          String? korean,
          String? romanization,
          Value<String?> targetSouth = const Value.absent(),
          Value<String?> koreanSouth = const Value.absent(),
          Value<String?> romanizationSouth = const Value.absent(),
          Value<String?> targetSpain = const Value.absent(),
          Value<String?> koreanSpain = const Value.absent(),
          Value<String?> romanizationSpain = const Value.absent(),
          String? category,
          int? course,
          String? tagsCsv,
          String? notes,
          String? comment,
          String? relatedCsv,
          String? rootRefs,
          String? speaker,
          int? turnOrder,
          String? scenario,
          Value<String?> tier = const Value.absent(),
          int? dialogueOrder,
          Value<String?> vocabHints = const Value.absent(),
          bool? isPolite,
          Value<int?> applicableScenario = const Value.absent(),
          Value<String?> morphTags = const Value.absent(),
          DateTime? updatedAt}) =>
      Item(
        id: id ?? this.id,
        type: type ?? this.type,
        targetText: targetText ?? this.targetText,
        korean: korean ?? this.korean,
        romanization: romanization ?? this.romanization,
        targetSouth: targetSouth.present ? targetSouth.value : this.targetSouth,
        koreanSouth: koreanSouth.present ? koreanSouth.value : this.koreanSouth,
        romanizationSouth: romanizationSouth.present
            ? romanizationSouth.value
            : this.romanizationSouth,
        targetSpain: targetSpain.present ? targetSpain.value : this.targetSpain,
        koreanSpain: koreanSpain.present ? koreanSpain.value : this.koreanSpain,
        romanizationSpain: romanizationSpain.present
            ? romanizationSpain.value
            : this.romanizationSpain,
        category: category ?? this.category,
        course: course ?? this.course,
        tagsCsv: tagsCsv ?? this.tagsCsv,
        notes: notes ?? this.notes,
        comment: comment ?? this.comment,
        relatedCsv: relatedCsv ?? this.relatedCsv,
        rootRefs: rootRefs ?? this.rootRefs,
        speaker: speaker ?? this.speaker,
        turnOrder: turnOrder ?? this.turnOrder,
        scenario: scenario ?? this.scenario,
        tier: tier.present ? tier.value : this.tier,
        dialogueOrder: dialogueOrder ?? this.dialogueOrder,
        vocabHints: vocabHints.present ? vocabHints.value : this.vocabHints,
        isPolite: isPolite ?? this.isPolite,
        applicableScenario: applicableScenario.present
            ? applicableScenario.value
            : this.applicableScenario,
        morphTags: morphTags.present ? morphTags.value : this.morphTags,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      targetText:
          data.targetText.present ? data.targetText.value : this.targetText,
      korean: data.korean.present ? data.korean.value : this.korean,
      romanization: data.romanization.present
          ? data.romanization.value
          : this.romanization,
      targetSouth:
          data.targetSouth.present ? data.targetSouth.value : this.targetSouth,
      koreanSouth:
          data.koreanSouth.present ? data.koreanSouth.value : this.koreanSouth,
      romanizationSouth: data.romanizationSouth.present
          ? data.romanizationSouth.value
          : this.romanizationSouth,
      targetSpain:
          data.targetSpain.present ? data.targetSpain.value : this.targetSpain,
      koreanSpain:
          data.koreanSpain.present ? data.koreanSpain.value : this.koreanSpain,
      romanizationSpain: data.romanizationSpain.present
          ? data.romanizationSpain.value
          : this.romanizationSpain,
      category: data.category.present ? data.category.value : this.category,
      course: data.course.present ? data.course.value : this.course,
      tagsCsv: data.tagsCsv.present ? data.tagsCsv.value : this.tagsCsv,
      notes: data.notes.present ? data.notes.value : this.notes,
      comment: data.comment.present ? data.comment.value : this.comment,
      relatedCsv:
          data.relatedCsv.present ? data.relatedCsv.value : this.relatedCsv,
      rootRefs: data.rootRefs.present ? data.rootRefs.value : this.rootRefs,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      turnOrder: data.turnOrder.present ? data.turnOrder.value : this.turnOrder,
      scenario: data.scenario.present ? data.scenario.value : this.scenario,
      tier: data.tier.present ? data.tier.value : this.tier,
      dialogueOrder: data.dialogueOrder.present
          ? data.dialogueOrder.value
          : this.dialogueOrder,
      vocabHints:
          data.vocabHints.present ? data.vocabHints.value : this.vocabHints,
      isPolite: data.isPolite.present ? data.isPolite.value : this.isPolite,
      applicableScenario: data.applicableScenario.present
          ? data.applicableScenario.value
          : this.applicableScenario,
      morphTags: data.morphTags.present ? data.morphTags.value : this.morphTags,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('targetText: $targetText, ')
          ..write('korean: $korean, ')
          ..write('romanization: $romanization, ')
          ..write('targetSouth: $targetSouth, ')
          ..write('koreanSouth: $koreanSouth, ')
          ..write('romanizationSouth: $romanizationSouth, ')
          ..write('targetSpain: $targetSpain, ')
          ..write('koreanSpain: $koreanSpain, ')
          ..write('romanizationSpain: $romanizationSpain, ')
          ..write('category: $category, ')
          ..write('course: $course, ')
          ..write('tagsCsv: $tagsCsv, ')
          ..write('notes: $notes, ')
          ..write('comment: $comment, ')
          ..write('relatedCsv: $relatedCsv, ')
          ..write('rootRefs: $rootRefs, ')
          ..write('speaker: $speaker, ')
          ..write('turnOrder: $turnOrder, ')
          ..write('scenario: $scenario, ')
          ..write('tier: $tier, ')
          ..write('dialogueOrder: $dialogueOrder, ')
          ..write('vocabHints: $vocabHints, ')
          ..write('isPolite: $isPolite, ')
          ..write('applicableScenario: $applicableScenario, ')
          ..write('morphTags: $morphTags, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        type,
        targetText,
        korean,
        romanization,
        targetSouth,
        koreanSouth,
        romanizationSouth,
        targetSpain,
        koreanSpain,
        romanizationSpain,
        category,
        course,
        tagsCsv,
        notes,
        comment,
        relatedCsv,
        rootRefs,
        speaker,
        turnOrder,
        scenario,
        tier,
        dialogueOrder,
        vocabHints,
        isPolite,
        applicableScenario,
        morphTags,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.type == this.type &&
          other.targetText == this.targetText &&
          other.korean == this.korean &&
          other.romanization == this.romanization &&
          other.targetSouth == this.targetSouth &&
          other.koreanSouth == this.koreanSouth &&
          other.romanizationSouth == this.romanizationSouth &&
          other.targetSpain == this.targetSpain &&
          other.koreanSpain == this.koreanSpain &&
          other.romanizationSpain == this.romanizationSpain &&
          other.category == this.category &&
          other.course == this.course &&
          other.tagsCsv == this.tagsCsv &&
          other.notes == this.notes &&
          other.comment == this.comment &&
          other.relatedCsv == this.relatedCsv &&
          other.rootRefs == this.rootRefs &&
          other.speaker == this.speaker &&
          other.turnOrder == this.turnOrder &&
          other.scenario == this.scenario &&
          other.tier == this.tier &&
          other.dialogueOrder == this.dialogueOrder &&
          other.vocabHints == this.vocabHints &&
          other.isPolite == this.isPolite &&
          other.applicableScenario == this.applicableScenario &&
          other.morphTags == this.morphTags &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> targetText;
  final Value<String> korean;
  final Value<String> romanization;
  final Value<String?> targetSouth;
  final Value<String?> koreanSouth;
  final Value<String?> romanizationSouth;
  final Value<String?> targetSpain;
  final Value<String?> koreanSpain;
  final Value<String?> romanizationSpain;
  final Value<String> category;
  final Value<int> course;
  final Value<String> tagsCsv;
  final Value<String> notes;
  final Value<String> comment;
  final Value<String> relatedCsv;
  final Value<String> rootRefs;
  final Value<String> speaker;
  final Value<int> turnOrder;
  final Value<String> scenario;
  final Value<String?> tier;
  final Value<int> dialogueOrder;
  final Value<String?> vocabHints;
  final Value<bool> isPolite;
  final Value<int?> applicableScenario;
  final Value<String?> morphTags;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.targetText = const Value.absent(),
    this.korean = const Value.absent(),
    this.romanization = const Value.absent(),
    this.targetSouth = const Value.absent(),
    this.koreanSouth = const Value.absent(),
    this.romanizationSouth = const Value.absent(),
    this.targetSpain = const Value.absent(),
    this.koreanSpain = const Value.absent(),
    this.romanizationSpain = const Value.absent(),
    this.category = const Value.absent(),
    this.course = const Value.absent(),
    this.tagsCsv = const Value.absent(),
    this.notes = const Value.absent(),
    this.comment = const Value.absent(),
    this.relatedCsv = const Value.absent(),
    this.rootRefs = const Value.absent(),
    this.speaker = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.scenario = const Value.absent(),
    this.tier = const Value.absent(),
    this.dialogueOrder = const Value.absent(),
    this.vocabHints = const Value.absent(),
    this.isPolite = const Value.absent(),
    this.applicableScenario = const Value.absent(),
    this.morphTags = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String type,
    required String targetText,
    required String korean,
    this.romanization = const Value.absent(),
    this.targetSouth = const Value.absent(),
    this.koreanSouth = const Value.absent(),
    this.romanizationSouth = const Value.absent(),
    this.targetSpain = const Value.absent(),
    this.koreanSpain = const Value.absent(),
    this.romanizationSpain = const Value.absent(),
    this.category = const Value.absent(),
    this.course = const Value.absent(),
    this.tagsCsv = const Value.absent(),
    this.notes = const Value.absent(),
    this.comment = const Value.absent(),
    this.relatedCsv = const Value.absent(),
    this.rootRefs = const Value.absent(),
    this.speaker = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.scenario = const Value.absent(),
    this.tier = const Value.absent(),
    this.dialogueOrder = const Value.absent(),
    this.vocabHints = const Value.absent(),
    this.isPolite = const Value.absent(),
    this.applicableScenario = const Value.absent(),
    this.morphTags = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        targetText = Value(targetText),
        korean = Value(korean),
        updatedAt = Value(updatedAt);
  static Insertable<Item> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? targetText,
    Expression<String>? korean,
    Expression<String>? romanization,
    Expression<String>? targetSouth,
    Expression<String>? koreanSouth,
    Expression<String>? romanizationSouth,
    Expression<String>? targetSpain,
    Expression<String>? koreanSpain,
    Expression<String>? romanizationSpain,
    Expression<String>? category,
    Expression<int>? course,
    Expression<String>? tagsCsv,
    Expression<String>? notes,
    Expression<String>? comment,
    Expression<String>? relatedCsv,
    Expression<String>? rootRefs,
    Expression<String>? speaker,
    Expression<int>? turnOrder,
    Expression<String>? scenario,
    Expression<String>? tier,
    Expression<int>? dialogueOrder,
    Expression<String>? vocabHints,
    Expression<bool>? isPolite,
    Expression<int>? applicableScenario,
    Expression<String>? morphTags,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (targetText != null) 'target_text': targetText,
      if (korean != null) 'korean': korean,
      if (romanization != null) 'romanization': romanization,
      if (targetSouth != null) 'target_south': targetSouth,
      if (koreanSouth != null) 'korean_south': koreanSouth,
      if (romanizationSouth != null) 'romanization_south': romanizationSouth,
      if (targetSpain != null) 'target_spain': targetSpain,
      if (koreanSpain != null) 'korean_spain': koreanSpain,
      if (romanizationSpain != null) 'romanization_spain': romanizationSpain,
      if (category != null) 'category': category,
      if (course != null) 'course': course,
      if (tagsCsv != null) 'tags_csv': tagsCsv,
      if (notes != null) 'notes': notes,
      if (comment != null) 'comment': comment,
      if (relatedCsv != null) 'related_csv': relatedCsv,
      if (rootRefs != null) 'root_refs': rootRefs,
      if (speaker != null) 'speaker': speaker,
      if (turnOrder != null) 'turn_order': turnOrder,
      if (scenario != null) 'scenario': scenario,
      if (tier != null) 'tier': tier,
      if (dialogueOrder != null) 'dialogue_order': dialogueOrder,
      if (vocabHints != null) 'vocab_hints': vocabHints,
      if (isPolite != null) 'is_polite': isPolite,
      if (applicableScenario != null) 'applicable_scenario': applicableScenario,
      if (morphTags != null) 'morph_tags': morphTags,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? targetText,
      Value<String>? korean,
      Value<String>? romanization,
      Value<String?>? targetSouth,
      Value<String?>? koreanSouth,
      Value<String?>? romanizationSouth,
      Value<String?>? targetSpain,
      Value<String?>? koreanSpain,
      Value<String?>? romanizationSpain,
      Value<String>? category,
      Value<int>? course,
      Value<String>? tagsCsv,
      Value<String>? notes,
      Value<String>? comment,
      Value<String>? relatedCsv,
      Value<String>? rootRefs,
      Value<String>? speaker,
      Value<int>? turnOrder,
      Value<String>? scenario,
      Value<String?>? tier,
      Value<int>? dialogueOrder,
      Value<String?>? vocabHints,
      Value<bool>? isPolite,
      Value<int?>? applicableScenario,
      Value<String?>? morphTags,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ItemsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      targetText: targetText ?? this.targetText,
      korean: korean ?? this.korean,
      romanization: romanization ?? this.romanization,
      targetSouth: targetSouth ?? this.targetSouth,
      koreanSouth: koreanSouth ?? this.koreanSouth,
      romanizationSouth: romanizationSouth ?? this.romanizationSouth,
      targetSpain: targetSpain ?? this.targetSpain,
      koreanSpain: koreanSpain ?? this.koreanSpain,
      romanizationSpain: romanizationSpain ?? this.romanizationSpain,
      category: category ?? this.category,
      course: course ?? this.course,
      tagsCsv: tagsCsv ?? this.tagsCsv,
      notes: notes ?? this.notes,
      comment: comment ?? this.comment,
      relatedCsv: relatedCsv ?? this.relatedCsv,
      rootRefs: rootRefs ?? this.rootRefs,
      speaker: speaker ?? this.speaker,
      turnOrder: turnOrder ?? this.turnOrder,
      scenario: scenario ?? this.scenario,
      tier: tier ?? this.tier,
      dialogueOrder: dialogueOrder ?? this.dialogueOrder,
      vocabHints: vocabHints ?? this.vocabHints,
      isPolite: isPolite ?? this.isPolite,
      applicableScenario: applicableScenario ?? this.applicableScenario,
      morphTags: morphTags ?? this.morphTags,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetText.present) {
      map['target_text'] = Variable<String>(targetText.value);
    }
    if (korean.present) {
      map['korean'] = Variable<String>(korean.value);
    }
    if (romanization.present) {
      map['romanization'] = Variable<String>(romanization.value);
    }
    if (targetSouth.present) {
      map['target_south'] = Variable<String>(targetSouth.value);
    }
    if (koreanSouth.present) {
      map['korean_south'] = Variable<String>(koreanSouth.value);
    }
    if (romanizationSouth.present) {
      map['romanization_south'] = Variable<String>(romanizationSouth.value);
    }
    if (targetSpain.present) {
      map['target_spain'] = Variable<String>(targetSpain.value);
    }
    if (koreanSpain.present) {
      map['korean_spain'] = Variable<String>(koreanSpain.value);
    }
    if (romanizationSpain.present) {
      map['romanization_spain'] = Variable<String>(romanizationSpain.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (course.present) {
      map['course'] = Variable<int>(course.value);
    }
    if (tagsCsv.present) {
      map['tags_csv'] = Variable<String>(tagsCsv.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (relatedCsv.present) {
      map['related_csv'] = Variable<String>(relatedCsv.value);
    }
    if (rootRefs.present) {
      map['root_refs'] = Variable<String>(rootRefs.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (turnOrder.present) {
      map['turn_order'] = Variable<int>(turnOrder.value);
    }
    if (scenario.present) {
      map['scenario'] = Variable<String>(scenario.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (dialogueOrder.present) {
      map['dialogue_order'] = Variable<int>(dialogueOrder.value);
    }
    if (vocabHints.present) {
      map['vocab_hints'] = Variable<String>(vocabHints.value);
    }
    if (isPolite.present) {
      map['is_polite'] = Variable<bool>(isPolite.value);
    }
    if (applicableScenario.present) {
      map['applicable_scenario'] = Variable<int>(applicableScenario.value);
    }
    if (morphTags.present) {
      map['morph_tags'] = Variable<String>(morphTags.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('targetText: $targetText, ')
          ..write('korean: $korean, ')
          ..write('romanization: $romanization, ')
          ..write('targetSouth: $targetSouth, ')
          ..write('koreanSouth: $koreanSouth, ')
          ..write('romanizationSouth: $romanizationSouth, ')
          ..write('targetSpain: $targetSpain, ')
          ..write('koreanSpain: $koreanSpain, ')
          ..write('romanizationSpain: $romanizationSpain, ')
          ..write('category: $category, ')
          ..write('course: $course, ')
          ..write('tagsCsv: $tagsCsv, ')
          ..write('notes: $notes, ')
          ..write('comment: $comment, ')
          ..write('relatedCsv: $relatedCsv, ')
          ..write('rootRefs: $rootRefs, ')
          ..write('speaker: $speaker, ')
          ..write('turnOrder: $turnOrder, ')
          ..write('scenario: $scenario, ')
          ..write('tier: $tier, ')
          ..write('dialogueOrder: $dialogueOrder, ')
          ..write('vocabHints: $vocabHints, ')
          ..write('isPolite: $isPolite, ')
          ..write('applicableScenario: $applicableScenario, ')
          ..write('morphTags: $morphTags, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isKnownMeta =
      const VerificationMeta('isKnown');
  @override
  late final GeneratedColumn<bool> isKnown = GeneratedColumn<bool>(
      'is_known', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_known" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reviewScoreMeta =
      const VerificationMeta('reviewScore');
  @override
  late final GeneratedColumn<int> reviewScore = GeneratedColumn<int>(
      'review_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
      'next_review_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        itemId,
        isKnown,
        isFavorite,
        reviewScore,
        nextReviewAt,
        updatedAt,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(Insertable<UserProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('is_known')) {
      context.handle(_isKnownMeta,
          isKnown.isAcceptableOrUnknown(data['is_known']!, _isKnownMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('review_score')) {
      context.handle(
          _reviewScoreMeta,
          reviewScore.isAcceptableOrUnknown(
              data['review_score']!, _reviewScoreMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  UserProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressRow(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      isKnown: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_known'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      reviewScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_score'])!,
      nextReviewAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressRow extends DataClass implements Insertable<UserProgressRow> {
  final String itemId;
  final bool isKnown;
  final bool isFavorite;

  /// Forgetting-curve stage: 0 (new) → 1 (+1h) → 2 (+1d) → 3 (+1w) →
  /// 4 (+1m) → 5 (mastered). "알아요" increments; "몰라요" resets to 0.
  final int reviewScore;

  /// When this item becomes due again. Null = already due (never scheduled).
  final DateTime? nextReviewAt;
  final DateTime updatedAt;
  final bool synced;
  const UserProgressRow(
      {required this.itemId,
      required this.isKnown,
      required this.isFavorite,
      required this.reviewScore,
      this.nextReviewAt,
      required this.updatedAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['is_known'] = Variable<bool>(isKnown);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['review_score'] = Variable<int>(reviewScore);
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      itemId: Value(itemId),
      isKnown: Value(isKnown),
      isFavorite: Value(isFavorite),
      reviewScore: Value(reviewScore),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
    );
  }

  factory UserProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      isKnown: serializer.fromJson<bool>(json['isKnown']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      reviewScore: serializer.fromJson<int>(json['reviewScore']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'isKnown': serializer.toJson<bool>(isKnown),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'reviewScore': serializer.toJson<int>(reviewScore),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  UserProgressRow copyWith(
          {String? itemId,
          bool? isKnown,
          bool? isFavorite,
          int? reviewScore,
          Value<DateTime?> nextReviewAt = const Value.absent(),
          DateTime? updatedAt,
          bool? synced}) =>
      UserProgressRow(
        itemId: itemId ?? this.itemId,
        isKnown: isKnown ?? this.isKnown,
        isFavorite: isFavorite ?? this.isFavorite,
        reviewScore: reviewScore ?? this.reviewScore,
        nextReviewAt:
            nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
        updatedAt: updatedAt ?? this.updatedAt,
        synced: synced ?? this.synced,
      );
  UserProgressRow copyWithCompanion(UserProgressCompanion data) {
    return UserProgressRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      isKnown: data.isKnown.present ? data.isKnown.value : this.isKnown,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      reviewScore:
          data.reviewScore.present ? data.reviewScore.value : this.reviewScore,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressRow(')
          ..write('itemId: $itemId, ')
          ..write('isKnown: $isKnown, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('reviewScore: $reviewScore, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, isKnown, isFavorite, reviewScore,
      nextReviewAt, updatedAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressRow &&
          other.itemId == this.itemId &&
          other.isKnown == this.isKnown &&
          other.isFavorite == this.isFavorite &&
          other.reviewScore == this.reviewScore &&
          other.nextReviewAt == this.nextReviewAt &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressRow> {
  final Value<String> itemId;
  final Value<bool> isKnown;
  final Value<bool> isFavorite;
  final Value<int> reviewScore;
  final Value<DateTime?> nextReviewAt;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const UserProgressCompanion({
    this.itemId = const Value.absent(),
    this.isKnown = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.reviewScore = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProgressCompanion.insert({
    required String itemId,
    this.isKnown = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.reviewScore = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    required DateTime updatedAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : itemId = Value(itemId),
        updatedAt = Value(updatedAt);
  static Insertable<UserProgressRow> custom({
    Expression<String>? itemId,
    Expression<bool>? isKnown,
    Expression<bool>? isFavorite,
    Expression<int>? reviewScore,
    Expression<DateTime>? nextReviewAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (isKnown != null) 'is_known': isKnown,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (reviewScore != null) 'review_score': reviewScore,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProgressCompanion copyWith(
      {Value<String>? itemId,
      Value<bool>? isKnown,
      Value<bool>? isFavorite,
      Value<int>? reviewScore,
      Value<DateTime?>? nextReviewAt,
      Value<DateTime>? updatedAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return UserProgressCompanion(
      itemId: itemId ?? this.itemId,
      isKnown: isKnown ?? this.isKnown,
      isFavorite: isFavorite ?? this.isFavorite,
      reviewScore: reviewScore ?? this.reviewScore,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (isKnown.present) {
      map['is_known'] = Variable<bool>(isKnown.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (reviewScore.present) {
      map['review_score'] = Variable<int>(reviewScore.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('itemId: $itemId, ')
          ..write('isKnown: $isKnown, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('reviewScore: $reviewScore, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTable extends UserStats
    with TableInfo<$UserStatsTable, UserStatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currentStreakMeta =
      const VerificationMeta('currentStreak');
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
      'current_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastStudyDateMeta =
      const VerificationMeta('lastStudyDate');
  @override
  late final GeneratedColumn<DateTime> lastStudyDate =
      GeneratedColumn<DateTime>('last_study_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dailyGoalMeta =
      const VerificationMeta('dailyGoal');
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
      'daily_goal', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        currentStreak,
        longestStreak,
        lastStudyDate,
        dailyGoal,
        updatedAt,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(Insertable<UserStatRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_streak')) {
      context.handle(
          _currentStreakMeta,
          currentStreak.isAcceptableOrUnknown(
              data['current_streak']!, _currentStreakMeta));
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    }
    if (data.containsKey('last_study_date')) {
      context.handle(
          _lastStudyDateMeta,
          lastStudyDate.isAcceptableOrUnknown(
              data['last_study_date']!, _lastStudyDateMeta));
    }
    if (data.containsKey('daily_goal')) {
      context.handle(_dailyGoalMeta,
          dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStatRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currentStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_streak'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      lastStudyDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_study_date']),
      dailyGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_goal'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $UserStatsTable createAlias(String alias) {
    return $UserStatsTable(attachedDatabase, alias);
  }
}

class UserStatRow extends DataClass implements Insertable<UserStatRow> {
  final int id;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastStudyDate;
  final int dailyGoal;
  final DateTime updatedAt;
  final bool synced;
  const UserStatRow(
      {required this.id,
      required this.currentStreak,
      required this.longestStreak,
      this.lastStudyDate,
      required this.dailyGoal,
      required this.updatedAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastStudyDate != null) {
      map['last_study_date'] = Variable<DateTime>(lastStudyDate);
    }
    map['daily_goal'] = Variable<int>(dailyGoal);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  UserStatsCompanion toCompanion(bool nullToAbsent) {
    return UserStatsCompanion(
      id: Value(id),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastStudyDate: lastStudyDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStudyDate),
      dailyGoal: Value(dailyGoal),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
    );
  }

  factory UserStatRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStatRow(
      id: serializer.fromJson<int>(json['id']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastStudyDate: serializer.fromJson<DateTime?>(json['lastStudyDate']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastStudyDate': serializer.toJson<DateTime?>(lastStudyDate),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  UserStatRow copyWith(
          {int? id,
          int? currentStreak,
          int? longestStreak,
          Value<DateTime?> lastStudyDate = const Value.absent(),
          int? dailyGoal,
          DateTime? updatedAt,
          bool? synced}) =>
      UserStatRow(
        id: id ?? this.id,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastStudyDate:
            lastStudyDate.present ? lastStudyDate.value : this.lastStudyDate,
        dailyGoal: dailyGoal ?? this.dailyGoal,
        updatedAt: updatedAt ?? this.updatedAt,
        synced: synced ?? this.synced,
      );
  UserStatRow copyWithCompanion(UserStatsCompanion data) {
    return UserStatRow(
      id: data.id.present ? data.id.value : this.id,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastStudyDate: data.lastStudyDate.present
          ? data.lastStudyDate.value
          : this.lastStudyDate,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStatRow(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastStudyDate: $lastStudyDate, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentStreak, longestStreak,
      lastStudyDate, dailyGoal, updatedAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStatRow &&
          other.id == this.id &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastStudyDate == this.lastStudyDate &&
          other.dailyGoal == this.dailyGoal &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced);
}

class UserStatsCompanion extends UpdateCompanion<UserStatRow> {
  final Value<int> id;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastStudyDate;
  final Value<int> dailyGoal;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  const UserStatsCompanion({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastStudyDate = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  UserStatsCompanion.insert({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastStudyDate = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    required DateTime updatedAt,
    this.synced = const Value.absent(),
  }) : updatedAt = Value(updatedAt);
  static Insertable<UserStatRow> custom({
    Expression<int>? id,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastStudyDate,
    Expression<int>? dailyGoal,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastStudyDate != null) 'last_study_date': lastStudyDate,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
    });
  }

  UserStatsCompanion copyWith(
      {Value<int>? id,
      Value<int>? currentStreak,
      Value<int>? longestStreak,
      Value<DateTime?>? lastStudyDate,
      Value<int>? dailyGoal,
      Value<DateTime>? updatedAt,
      Value<bool>? synced}) {
    return UserStatsCompanion(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastStudyDate.present) {
      map['last_study_date'] = Variable<DateTime>(lastStudyDate.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsCompanion(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastStudyDate: $lastStudyDate, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $DailyCountsTable extends DailyCounts
    with TableInfo<$DailyCountsTable, DailyCountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyCountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [date, count, updatedAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_counts';
  @override
  VerificationContext validateIntegrity(Insertable<DailyCountRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyCountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCountRow(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $DailyCountsTable createAlias(String alias) {
    return $DailyCountsTable(attachedDatabase, alias);
  }
}

class DailyCountRow extends DataClass implements Insertable<DailyCountRow> {
  final String date;
  final int count;
  final DateTime updatedAt;
  final bool synced;
  const DailyCountRow(
      {required this.date,
      required this.count,
      required this.updatedAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['count'] = Variable<int>(count);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DailyCountsCompanion toCompanion(bool nullToAbsent) {
    return DailyCountsCompanion(
      date: Value(date),
      count: Value(count),
      updatedAt: Value(updatedAt),
      synced: Value(synced),
    );
  }

  factory DailyCountRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCountRow(
      date: serializer.fromJson<String>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'count': serializer.toJson<int>(count),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  DailyCountRow copyWith(
          {String? date, int? count, DateTime? updatedAt, bool? synced}) =>
      DailyCountRow(
        date: date ?? this.date,
        count: count ?? this.count,
        updatedAt: updatedAt ?? this.updatedAt,
        synced: synced ?? this.synced,
      );
  DailyCountRow copyWithCompanion(DailyCountsCompanion data) {
    return DailyCountRow(
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCountRow(')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, count, updatedAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCountRow &&
          other.date == this.date &&
          other.count == this.count &&
          other.updatedAt == this.updatedAt &&
          other.synced == this.synced);
}

class DailyCountsCompanion extends UpdateCompanion<DailyCountRow> {
  final Value<String> date;
  final Value<int> count;
  final Value<DateTime> updatedAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const DailyCountsCompanion({
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyCountsCompanion.insert({
    required String date,
    this.count = const Value.absent(),
    required DateTime updatedAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : date = Value(date),
        updatedAt = Value(updatedAt);
  static Insertable<DailyCountRow> custom({
    Expression<String>? date,
    Expression<int>? count,
    Expression<DateTime>? updatedAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyCountsCompanion copyWith(
      {Value<String>? date,
      Value<int>? count,
      Value<DateTime>? updatedAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return DailyCountsCompanion(
      date: date ?? this.date,
      count: count ?? this.count,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyCountsCompanion(')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetaRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaRow extends DataClass implements Insertable<SyncMetaRow> {
  final String key;
  final String value;
  const SyncMetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory SyncMetaRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaRow copyWith({String? key, String? value}) => SyncMetaRow(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  SyncMetaRow copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<SyncMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HanziStudiesZhTable extends HanziStudiesZh
    with TableInfo<$HanziStudiesZhTable, HanziStudyZhRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanziStudiesZhTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _radicalMeta =
      const VerificationMeta('radical');
  @override
  late final GeneratedColumn<String> radical = GeneratedColumn<String>(
      'radical', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningKoMeta =
      const VerificationMeta('meaningKo');
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
      'meaning_ko', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
      'pinyin', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _toneMeta = const VerificationMeta('tone');
  @override
  late final GeneratedColumn<int> tone = GeneratedColumn<int>(
      'tone', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, radical, meaningKo, pinyin, tone, description, sortOrder, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanzi_studies_zh';
  @override
  VerificationContext validateIntegrity(Insertable<HanziStudyZhRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('radical')) {
      context.handle(_radicalMeta,
          radical.isAcceptableOrUnknown(data['radical']!, _radicalMeta));
    } else if (isInserting) {
      context.missing(_radicalMeta);
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(_meaningKoMeta,
          meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta));
    } else if (isInserting) {
      context.missing(_meaningKoMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(_pinyinMeta,
          pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta));
    }
    if (data.containsKey('tone')) {
      context.handle(
          _toneMeta, tone.isAcceptableOrUnknown(data['tone']!, _toneMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HanziStudyZhRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanziStudyZhRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      radical: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}radical'])!,
      meaningKo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_ko'])!,
      pinyin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pinyin'])!,
      tone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tone'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HanziStudiesZhTable createAlias(String alias) {
    return $HanziStudiesZhTable(attachedDatabase, alias);
  }
}

class HanziStudyZhRow extends DataClass implements Insertable<HanziStudyZhRow> {
  final String id;
  final String radical;
  final String meaningKo;
  final String pinyin;
  final int tone;
  final String description;
  final int sortOrder;
  final DateTime updatedAt;
  const HanziStudyZhRow(
      {required this.id,
      required this.radical,
      required this.meaningKo,
      required this.pinyin,
      required this.tone,
      required this.description,
      required this.sortOrder,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['radical'] = Variable<String>(radical);
    map['meaning_ko'] = Variable<String>(meaningKo);
    map['pinyin'] = Variable<String>(pinyin);
    map['tone'] = Variable<int>(tone);
    map['description'] = Variable<String>(description);
    map['sort_order'] = Variable<int>(sortOrder);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HanziStudiesZhCompanion toCompanion(bool nullToAbsent) {
    return HanziStudiesZhCompanion(
      id: Value(id),
      radical: Value(radical),
      meaningKo: Value(meaningKo),
      pinyin: Value(pinyin),
      tone: Value(tone),
      description: Value(description),
      sortOrder: Value(sortOrder),
      updatedAt: Value(updatedAt),
    );
  }

  factory HanziStudyZhRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanziStudyZhRow(
      id: serializer.fromJson<String>(json['id']),
      radical: serializer.fromJson<String>(json['radical']),
      meaningKo: serializer.fromJson<String>(json['meaningKo']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      tone: serializer.fromJson<int>(json['tone']),
      description: serializer.fromJson<String>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'radical': serializer.toJson<String>(radical),
      'meaningKo': serializer.toJson<String>(meaningKo),
      'pinyin': serializer.toJson<String>(pinyin),
      'tone': serializer.toJson<int>(tone),
      'description': serializer.toJson<String>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HanziStudyZhRow copyWith(
          {String? id,
          String? radical,
          String? meaningKo,
          String? pinyin,
          int? tone,
          String? description,
          int? sortOrder,
          DateTime? updatedAt}) =>
      HanziStudyZhRow(
        id: id ?? this.id,
        radical: radical ?? this.radical,
        meaningKo: meaningKo ?? this.meaningKo,
        pinyin: pinyin ?? this.pinyin,
        tone: tone ?? this.tone,
        description: description ?? this.description,
        sortOrder: sortOrder ?? this.sortOrder,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HanziStudyZhRow copyWithCompanion(HanziStudiesZhCompanion data) {
    return HanziStudyZhRow(
      id: data.id.present ? data.id.value : this.id,
      radical: data.radical.present ? data.radical.value : this.radical,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      tone: data.tone.present ? data.tone.value : this.tone,
      description:
          data.description.present ? data.description.value : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanziStudyZhRow(')
          ..write('id: $id, ')
          ..write('radical: $radical, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('pinyin: $pinyin, ')
          ..write('tone: $tone, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, radical, meaningKo, pinyin, tone, description, sortOrder, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanziStudyZhRow &&
          other.id == this.id &&
          other.radical == this.radical &&
          other.meaningKo == this.meaningKo &&
          other.pinyin == this.pinyin &&
          other.tone == this.tone &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt);
}

class HanziStudiesZhCompanion extends UpdateCompanion<HanziStudyZhRow> {
  final Value<String> id;
  final Value<String> radical;
  final Value<String> meaningKo;
  final Value<String> pinyin;
  final Value<int> tone;
  final Value<String> description;
  final Value<int> sortOrder;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HanziStudiesZhCompanion({
    this.id = const Value.absent(),
    this.radical = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.tone = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HanziStudiesZhCompanion.insert({
    required String id,
    required String radical,
    required String meaningKo,
    this.pinyin = const Value.absent(),
    this.tone = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        radical = Value(radical),
        meaningKo = Value(meaningKo),
        updatedAt = Value(updatedAt);
  static Insertable<HanziStudyZhRow> custom({
    Expression<String>? id,
    Expression<String>? radical,
    Expression<String>? meaningKo,
    Expression<String>? pinyin,
    Expression<int>? tone,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (radical != null) 'radical': radical,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (pinyin != null) 'pinyin': pinyin,
      if (tone != null) 'tone': tone,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HanziStudiesZhCompanion copyWith(
      {Value<String>? id,
      Value<String>? radical,
      Value<String>? meaningKo,
      Value<String>? pinyin,
      Value<int>? tone,
      Value<String>? description,
      Value<int>? sortOrder,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return HanziStudiesZhCompanion(
      id: id ?? this.id,
      radical: radical ?? this.radical,
      meaningKo: meaningKo ?? this.meaningKo,
      pinyin: pinyin ?? this.pinyin,
      tone: tone ?? this.tone,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (radical.present) {
      map['radical'] = Variable<String>(radical.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (tone.present) {
      map['tone'] = Variable<int>(tone.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanziStudiesZhCompanion(')
          ..write('id: $id, ')
          ..write('radical: $radical, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('pinyin: $pinyin, ')
          ..write('tone: $tone, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HanziRelatedZhTable extends HanziRelatedZh
    with TableInfo<$HanziRelatedZhTable, HanziRelatedZhRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanziRelatedZhTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studyIdMeta =
      const VerificationMeta('studyId');
  @override
  late final GeneratedColumn<String> studyId = GeneratedColumn<String>(
      'study_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _characterMeta =
      const VerificationMeta('character');
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
      'character', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
      'pinyin', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _toneMeta = const VerificationMeta('tone');
  @override
  late final GeneratedColumn<int> tone = GeneratedColumn<int>(
      'tone', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _meaningKoMeta =
      const VerificationMeta('meaningKo');
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
      'meaning_ko', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationTypeMeta =
      const VerificationMeta('relationType');
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
      'relation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studyId,
        character,
        pinyin,
        tone,
        meaningKo,
        relationType,
        position,
        note,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanzi_related_zh';
  @override
  VerificationContext validateIntegrity(Insertable<HanziRelatedZhRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('study_id')) {
      context.handle(_studyIdMeta,
          studyId.isAcceptableOrUnknown(data['study_id']!, _studyIdMeta));
    } else if (isInserting) {
      context.missing(_studyIdMeta);
    }
    if (data.containsKey('character')) {
      context.handle(_characterMeta,
          character.isAcceptableOrUnknown(data['character']!, _characterMeta));
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(_pinyinMeta,
          pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta));
    }
    if (data.containsKey('tone')) {
      context.handle(
          _toneMeta, tone.isAcceptableOrUnknown(data['tone']!, _toneMeta));
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(_meaningKoMeta,
          meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta));
    } else if (isInserting) {
      context.missing(_meaningKoMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
          _relationTypeMeta,
          relationType.isAcceptableOrUnknown(
              data['relation_type']!, _relationTypeMeta));
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HanziRelatedZhRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanziRelatedZhRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}study_id'])!,
      character: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character'])!,
      pinyin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pinyin'])!,
      tone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tone'])!,
      meaningKo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_ko'])!,
      relationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation_type'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HanziRelatedZhTable createAlias(String alias) {
    return $HanziRelatedZhTable(attachedDatabase, alias);
  }
}

class HanziRelatedZhRow extends DataClass
    implements Insertable<HanziRelatedZhRow> {
  final int id;
  final String studyId;
  final String character;
  final String pinyin;
  final int tone;
  final String meaningKo;
  final String relationType;
  final int position;
  final String note;
  final DateTime updatedAt;
  const HanziRelatedZhRow(
      {required this.id,
      required this.studyId,
      required this.character,
      required this.pinyin,
      required this.tone,
      required this.meaningKo,
      required this.relationType,
      required this.position,
      required this.note,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['study_id'] = Variable<String>(studyId);
    map['character'] = Variable<String>(character);
    map['pinyin'] = Variable<String>(pinyin);
    map['tone'] = Variable<int>(tone);
    map['meaning_ko'] = Variable<String>(meaningKo);
    map['relation_type'] = Variable<String>(relationType);
    map['position'] = Variable<int>(position);
    map['note'] = Variable<String>(note);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HanziRelatedZhCompanion toCompanion(bool nullToAbsent) {
    return HanziRelatedZhCompanion(
      id: Value(id),
      studyId: Value(studyId),
      character: Value(character),
      pinyin: Value(pinyin),
      tone: Value(tone),
      meaningKo: Value(meaningKo),
      relationType: Value(relationType),
      position: Value(position),
      note: Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory HanziRelatedZhRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanziRelatedZhRow(
      id: serializer.fromJson<int>(json['id']),
      studyId: serializer.fromJson<String>(json['studyId']),
      character: serializer.fromJson<String>(json['character']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      tone: serializer.fromJson<int>(json['tone']),
      meaningKo: serializer.fromJson<String>(json['meaningKo']),
      relationType: serializer.fromJson<String>(json['relationType']),
      position: serializer.fromJson<int>(json['position']),
      note: serializer.fromJson<String>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studyId': serializer.toJson<String>(studyId),
      'character': serializer.toJson<String>(character),
      'pinyin': serializer.toJson<String>(pinyin),
      'tone': serializer.toJson<int>(tone),
      'meaningKo': serializer.toJson<String>(meaningKo),
      'relationType': serializer.toJson<String>(relationType),
      'position': serializer.toJson<int>(position),
      'note': serializer.toJson<String>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HanziRelatedZhRow copyWith(
          {int? id,
          String? studyId,
          String? character,
          String? pinyin,
          int? tone,
          String? meaningKo,
          String? relationType,
          int? position,
          String? note,
          DateTime? updatedAt}) =>
      HanziRelatedZhRow(
        id: id ?? this.id,
        studyId: studyId ?? this.studyId,
        character: character ?? this.character,
        pinyin: pinyin ?? this.pinyin,
        tone: tone ?? this.tone,
        meaningKo: meaningKo ?? this.meaningKo,
        relationType: relationType ?? this.relationType,
        position: position ?? this.position,
        note: note ?? this.note,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HanziRelatedZhRow copyWithCompanion(HanziRelatedZhCompanion data) {
    return HanziRelatedZhRow(
      id: data.id.present ? data.id.value : this.id,
      studyId: data.studyId.present ? data.studyId.value : this.studyId,
      character: data.character.present ? data.character.value : this.character,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      tone: data.tone.present ? data.tone.value : this.tone,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      position: data.position.present ? data.position.value : this.position,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanziRelatedZhRow(')
          ..write('id: $id, ')
          ..write('studyId: $studyId, ')
          ..write('character: $character, ')
          ..write('pinyin: $pinyin, ')
          ..write('tone: $tone, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('relationType: $relationType, ')
          ..write('position: $position, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studyId, character, pinyin, tone,
      meaningKo, relationType, position, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanziRelatedZhRow &&
          other.id == this.id &&
          other.studyId == this.studyId &&
          other.character == this.character &&
          other.pinyin == this.pinyin &&
          other.tone == this.tone &&
          other.meaningKo == this.meaningKo &&
          other.relationType == this.relationType &&
          other.position == this.position &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class HanziRelatedZhCompanion extends UpdateCompanion<HanziRelatedZhRow> {
  final Value<int> id;
  final Value<String> studyId;
  final Value<String> character;
  final Value<String> pinyin;
  final Value<int> tone;
  final Value<String> meaningKo;
  final Value<String> relationType;
  final Value<int> position;
  final Value<String> note;
  final Value<DateTime> updatedAt;
  const HanziRelatedZhCompanion({
    this.id = const Value.absent(),
    this.studyId = const Value.absent(),
    this.character = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.tone = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.relationType = const Value.absent(),
    this.position = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HanziRelatedZhCompanion.insert({
    this.id = const Value.absent(),
    required String studyId,
    required String character,
    this.pinyin = const Value.absent(),
    this.tone = const Value.absent(),
    required String meaningKo,
    required String relationType,
    this.position = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
  })  : studyId = Value(studyId),
        character = Value(character),
        meaningKo = Value(meaningKo),
        relationType = Value(relationType),
        updatedAt = Value(updatedAt);
  static Insertable<HanziRelatedZhRow> custom({
    Expression<int>? id,
    Expression<String>? studyId,
    Expression<String>? character,
    Expression<String>? pinyin,
    Expression<int>? tone,
    Expression<String>? meaningKo,
    Expression<String>? relationType,
    Expression<int>? position,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyId != null) 'study_id': studyId,
      if (character != null) 'character': character,
      if (pinyin != null) 'pinyin': pinyin,
      if (tone != null) 'tone': tone,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (relationType != null) 'relation_type': relationType,
      if (position != null) 'position': position,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HanziRelatedZhCompanion copyWith(
      {Value<int>? id,
      Value<String>? studyId,
      Value<String>? character,
      Value<String>? pinyin,
      Value<int>? tone,
      Value<String>? meaningKo,
      Value<String>? relationType,
      Value<int>? position,
      Value<String>? note,
      Value<DateTime>? updatedAt}) {
    return HanziRelatedZhCompanion(
      id: id ?? this.id,
      studyId: studyId ?? this.studyId,
      character: character ?? this.character,
      pinyin: pinyin ?? this.pinyin,
      tone: tone ?? this.tone,
      meaningKo: meaningKo ?? this.meaningKo,
      relationType: relationType ?? this.relationType,
      position: position ?? this.position,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studyId.present) {
      map['study_id'] = Variable<String>(studyId.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (tone.present) {
      map['tone'] = Variable<int>(tone.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanziRelatedZhCompanion(')
          ..write('id: $id, ')
          ..write('studyId: $studyId, ')
          ..write('character: $character, ')
          ..write('pinyin: $pinyin, ')
          ..write('tone: $tone, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('relationType: $relationType, ')
          ..write('position: $position, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $HanziStudiesJpTable extends HanziStudiesJp
    with TableInfo<$HanziStudiesJpTable, HanziStudyJpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanziStudiesJpTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _radicalMeta =
      const VerificationMeta('radical');
  @override
  late final GeneratedColumn<String> radical = GeneratedColumn<String>(
      'radical', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningKoMeta =
      const VerificationMeta('meaningKo');
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
      'meaning_ko', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _onyomiMeta = const VerificationMeta('onyomi');
  @override
  late final GeneratedColumn<String> onyomi = GeneratedColumn<String>(
      'onyomi', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _kunyomiMeta =
      const VerificationMeta('kunyomi');
  @override
  late final GeneratedColumn<String> kunyomi = GeneratedColumn<String>(
      'kunyomi', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        radical,
        meaningKo,
        onyomi,
        kunyomi,
        description,
        sortOrder,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanzi_studies_jp';
  @override
  VerificationContext validateIntegrity(Insertable<HanziStudyJpRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('radical')) {
      context.handle(_radicalMeta,
          radical.isAcceptableOrUnknown(data['radical']!, _radicalMeta));
    } else if (isInserting) {
      context.missing(_radicalMeta);
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(_meaningKoMeta,
          meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta));
    } else if (isInserting) {
      context.missing(_meaningKoMeta);
    }
    if (data.containsKey('onyomi')) {
      context.handle(_onyomiMeta,
          onyomi.isAcceptableOrUnknown(data['onyomi']!, _onyomiMeta));
    }
    if (data.containsKey('kunyomi')) {
      context.handle(_kunyomiMeta,
          kunyomi.isAcceptableOrUnknown(data['kunyomi']!, _kunyomiMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HanziStudyJpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanziStudyJpRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      radical: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}radical'])!,
      meaningKo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_ko'])!,
      onyomi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}onyomi'])!,
      kunyomi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kunyomi'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HanziStudiesJpTable createAlias(String alias) {
    return $HanziStudiesJpTable(attachedDatabase, alias);
  }
}

class HanziStudyJpRow extends DataClass implements Insertable<HanziStudyJpRow> {
  final String id;
  final String radical;
  final String meaningKo;
  final String onyomi;
  final String kunyomi;
  final String description;
  final int sortOrder;
  final DateTime updatedAt;
  const HanziStudyJpRow(
      {required this.id,
      required this.radical,
      required this.meaningKo,
      required this.onyomi,
      required this.kunyomi,
      required this.description,
      required this.sortOrder,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['radical'] = Variable<String>(radical);
    map['meaning_ko'] = Variable<String>(meaningKo);
    map['onyomi'] = Variable<String>(onyomi);
    map['kunyomi'] = Variable<String>(kunyomi);
    map['description'] = Variable<String>(description);
    map['sort_order'] = Variable<int>(sortOrder);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HanziStudiesJpCompanion toCompanion(bool nullToAbsent) {
    return HanziStudiesJpCompanion(
      id: Value(id),
      radical: Value(radical),
      meaningKo: Value(meaningKo),
      onyomi: Value(onyomi),
      kunyomi: Value(kunyomi),
      description: Value(description),
      sortOrder: Value(sortOrder),
      updatedAt: Value(updatedAt),
    );
  }

  factory HanziStudyJpRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanziStudyJpRow(
      id: serializer.fromJson<String>(json['id']),
      radical: serializer.fromJson<String>(json['radical']),
      meaningKo: serializer.fromJson<String>(json['meaningKo']),
      onyomi: serializer.fromJson<String>(json['onyomi']),
      kunyomi: serializer.fromJson<String>(json['kunyomi']),
      description: serializer.fromJson<String>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'radical': serializer.toJson<String>(radical),
      'meaningKo': serializer.toJson<String>(meaningKo),
      'onyomi': serializer.toJson<String>(onyomi),
      'kunyomi': serializer.toJson<String>(kunyomi),
      'description': serializer.toJson<String>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HanziStudyJpRow copyWith(
          {String? id,
          String? radical,
          String? meaningKo,
          String? onyomi,
          String? kunyomi,
          String? description,
          int? sortOrder,
          DateTime? updatedAt}) =>
      HanziStudyJpRow(
        id: id ?? this.id,
        radical: radical ?? this.radical,
        meaningKo: meaningKo ?? this.meaningKo,
        onyomi: onyomi ?? this.onyomi,
        kunyomi: kunyomi ?? this.kunyomi,
        description: description ?? this.description,
        sortOrder: sortOrder ?? this.sortOrder,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HanziStudyJpRow copyWithCompanion(HanziStudiesJpCompanion data) {
    return HanziStudyJpRow(
      id: data.id.present ? data.id.value : this.id,
      radical: data.radical.present ? data.radical.value : this.radical,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      onyomi: data.onyomi.present ? data.onyomi.value : this.onyomi,
      kunyomi: data.kunyomi.present ? data.kunyomi.value : this.kunyomi,
      description:
          data.description.present ? data.description.value : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanziStudyJpRow(')
          ..write('id: $id, ')
          ..write('radical: $radical, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('onyomi: $onyomi, ')
          ..write('kunyomi: $kunyomi, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, radical, meaningKo, onyomi, kunyomi,
      description, sortOrder, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanziStudyJpRow &&
          other.id == this.id &&
          other.radical == this.radical &&
          other.meaningKo == this.meaningKo &&
          other.onyomi == this.onyomi &&
          other.kunyomi == this.kunyomi &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt);
}

class HanziStudiesJpCompanion extends UpdateCompanion<HanziStudyJpRow> {
  final Value<String> id;
  final Value<String> radical;
  final Value<String> meaningKo;
  final Value<String> onyomi;
  final Value<String> kunyomi;
  final Value<String> description;
  final Value<int> sortOrder;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HanziStudiesJpCompanion({
    this.id = const Value.absent(),
    this.radical = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.onyomi = const Value.absent(),
    this.kunyomi = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HanziStudiesJpCompanion.insert({
    required String id,
    required String radical,
    required String meaningKo,
    this.onyomi = const Value.absent(),
    this.kunyomi = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        radical = Value(radical),
        meaningKo = Value(meaningKo),
        updatedAt = Value(updatedAt);
  static Insertable<HanziStudyJpRow> custom({
    Expression<String>? id,
    Expression<String>? radical,
    Expression<String>? meaningKo,
    Expression<String>? onyomi,
    Expression<String>? kunyomi,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (radical != null) 'radical': radical,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (onyomi != null) 'onyomi': onyomi,
      if (kunyomi != null) 'kunyomi': kunyomi,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HanziStudiesJpCompanion copyWith(
      {Value<String>? id,
      Value<String>? radical,
      Value<String>? meaningKo,
      Value<String>? onyomi,
      Value<String>? kunyomi,
      Value<String>? description,
      Value<int>? sortOrder,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return HanziStudiesJpCompanion(
      id: id ?? this.id,
      radical: radical ?? this.radical,
      meaningKo: meaningKo ?? this.meaningKo,
      onyomi: onyomi ?? this.onyomi,
      kunyomi: kunyomi ?? this.kunyomi,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (radical.present) {
      map['radical'] = Variable<String>(radical.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (onyomi.present) {
      map['onyomi'] = Variable<String>(onyomi.value);
    }
    if (kunyomi.present) {
      map['kunyomi'] = Variable<String>(kunyomi.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanziStudiesJpCompanion(')
          ..write('id: $id, ')
          ..write('radical: $radical, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('onyomi: $onyomi, ')
          ..write('kunyomi: $kunyomi, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HanziRelatedJpTable extends HanziRelatedJp
    with TableInfo<$HanziRelatedJpTable, HanziRelatedJpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanziRelatedJpTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studyIdMeta =
      const VerificationMeta('studyId');
  @override
  late final GeneratedColumn<String> studyId = GeneratedColumn<String>(
      'study_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _characterMeta =
      const VerificationMeta('character');
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
      'character', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _onyomiMeta = const VerificationMeta('onyomi');
  @override
  late final GeneratedColumn<String> onyomi = GeneratedColumn<String>(
      'onyomi', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _kunyomiMeta =
      const VerificationMeta('kunyomi');
  @override
  late final GeneratedColumn<String> kunyomi = GeneratedColumn<String>(
      'kunyomi', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _meaningKoMeta =
      const VerificationMeta('meaningKo');
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
      'meaning_ko', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationTypeMeta =
      const VerificationMeta('relationType');
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
      'relation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studyId,
        character,
        onyomi,
        kunyomi,
        meaningKo,
        relationType,
        position,
        note,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanzi_related_jp';
  @override
  VerificationContext validateIntegrity(Insertable<HanziRelatedJpRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('study_id')) {
      context.handle(_studyIdMeta,
          studyId.isAcceptableOrUnknown(data['study_id']!, _studyIdMeta));
    } else if (isInserting) {
      context.missing(_studyIdMeta);
    }
    if (data.containsKey('character')) {
      context.handle(_characterMeta,
          character.isAcceptableOrUnknown(data['character']!, _characterMeta));
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('onyomi')) {
      context.handle(_onyomiMeta,
          onyomi.isAcceptableOrUnknown(data['onyomi']!, _onyomiMeta));
    }
    if (data.containsKey('kunyomi')) {
      context.handle(_kunyomiMeta,
          kunyomi.isAcceptableOrUnknown(data['kunyomi']!, _kunyomiMeta));
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(_meaningKoMeta,
          meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta));
    } else if (isInserting) {
      context.missing(_meaningKoMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
          _relationTypeMeta,
          relationType.isAcceptableOrUnknown(
              data['relation_type']!, _relationTypeMeta));
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HanziRelatedJpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanziRelatedJpRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}study_id'])!,
      character: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character'])!,
      onyomi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}onyomi'])!,
      kunyomi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kunyomi'])!,
      meaningKo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_ko'])!,
      relationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation_type'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HanziRelatedJpTable createAlias(String alias) {
    return $HanziRelatedJpTable(attachedDatabase, alias);
  }
}

class HanziRelatedJpRow extends DataClass
    implements Insertable<HanziRelatedJpRow> {
  final int id;
  final String studyId;
  final String character;
  final String onyomi;
  final String kunyomi;
  final String meaningKo;
  final String relationType;
  final int position;
  final String note;
  final DateTime updatedAt;
  const HanziRelatedJpRow(
      {required this.id,
      required this.studyId,
      required this.character,
      required this.onyomi,
      required this.kunyomi,
      required this.meaningKo,
      required this.relationType,
      required this.position,
      required this.note,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['study_id'] = Variable<String>(studyId);
    map['character'] = Variable<String>(character);
    map['onyomi'] = Variable<String>(onyomi);
    map['kunyomi'] = Variable<String>(kunyomi);
    map['meaning_ko'] = Variable<String>(meaningKo);
    map['relation_type'] = Variable<String>(relationType);
    map['position'] = Variable<int>(position);
    map['note'] = Variable<String>(note);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HanziRelatedJpCompanion toCompanion(bool nullToAbsent) {
    return HanziRelatedJpCompanion(
      id: Value(id),
      studyId: Value(studyId),
      character: Value(character),
      onyomi: Value(onyomi),
      kunyomi: Value(kunyomi),
      meaningKo: Value(meaningKo),
      relationType: Value(relationType),
      position: Value(position),
      note: Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory HanziRelatedJpRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanziRelatedJpRow(
      id: serializer.fromJson<int>(json['id']),
      studyId: serializer.fromJson<String>(json['studyId']),
      character: serializer.fromJson<String>(json['character']),
      onyomi: serializer.fromJson<String>(json['onyomi']),
      kunyomi: serializer.fromJson<String>(json['kunyomi']),
      meaningKo: serializer.fromJson<String>(json['meaningKo']),
      relationType: serializer.fromJson<String>(json['relationType']),
      position: serializer.fromJson<int>(json['position']),
      note: serializer.fromJson<String>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studyId': serializer.toJson<String>(studyId),
      'character': serializer.toJson<String>(character),
      'onyomi': serializer.toJson<String>(onyomi),
      'kunyomi': serializer.toJson<String>(kunyomi),
      'meaningKo': serializer.toJson<String>(meaningKo),
      'relationType': serializer.toJson<String>(relationType),
      'position': serializer.toJson<int>(position),
      'note': serializer.toJson<String>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HanziRelatedJpRow copyWith(
          {int? id,
          String? studyId,
          String? character,
          String? onyomi,
          String? kunyomi,
          String? meaningKo,
          String? relationType,
          int? position,
          String? note,
          DateTime? updatedAt}) =>
      HanziRelatedJpRow(
        id: id ?? this.id,
        studyId: studyId ?? this.studyId,
        character: character ?? this.character,
        onyomi: onyomi ?? this.onyomi,
        kunyomi: kunyomi ?? this.kunyomi,
        meaningKo: meaningKo ?? this.meaningKo,
        relationType: relationType ?? this.relationType,
        position: position ?? this.position,
        note: note ?? this.note,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HanziRelatedJpRow copyWithCompanion(HanziRelatedJpCompanion data) {
    return HanziRelatedJpRow(
      id: data.id.present ? data.id.value : this.id,
      studyId: data.studyId.present ? data.studyId.value : this.studyId,
      character: data.character.present ? data.character.value : this.character,
      onyomi: data.onyomi.present ? data.onyomi.value : this.onyomi,
      kunyomi: data.kunyomi.present ? data.kunyomi.value : this.kunyomi,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      position: data.position.present ? data.position.value : this.position,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanziRelatedJpRow(')
          ..write('id: $id, ')
          ..write('studyId: $studyId, ')
          ..write('character: $character, ')
          ..write('onyomi: $onyomi, ')
          ..write('kunyomi: $kunyomi, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('relationType: $relationType, ')
          ..write('position: $position, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studyId, character, onyomi, kunyomi,
      meaningKo, relationType, position, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanziRelatedJpRow &&
          other.id == this.id &&
          other.studyId == this.studyId &&
          other.character == this.character &&
          other.onyomi == this.onyomi &&
          other.kunyomi == this.kunyomi &&
          other.meaningKo == this.meaningKo &&
          other.relationType == this.relationType &&
          other.position == this.position &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class HanziRelatedJpCompanion extends UpdateCompanion<HanziRelatedJpRow> {
  final Value<int> id;
  final Value<String> studyId;
  final Value<String> character;
  final Value<String> onyomi;
  final Value<String> kunyomi;
  final Value<String> meaningKo;
  final Value<String> relationType;
  final Value<int> position;
  final Value<String> note;
  final Value<DateTime> updatedAt;
  const HanziRelatedJpCompanion({
    this.id = const Value.absent(),
    this.studyId = const Value.absent(),
    this.character = const Value.absent(),
    this.onyomi = const Value.absent(),
    this.kunyomi = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.relationType = const Value.absent(),
    this.position = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HanziRelatedJpCompanion.insert({
    this.id = const Value.absent(),
    required String studyId,
    required String character,
    this.onyomi = const Value.absent(),
    this.kunyomi = const Value.absent(),
    required String meaningKo,
    required String relationType,
    this.position = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
  })  : studyId = Value(studyId),
        character = Value(character),
        meaningKo = Value(meaningKo),
        relationType = Value(relationType),
        updatedAt = Value(updatedAt);
  static Insertable<HanziRelatedJpRow> custom({
    Expression<int>? id,
    Expression<String>? studyId,
    Expression<String>? character,
    Expression<String>? onyomi,
    Expression<String>? kunyomi,
    Expression<String>? meaningKo,
    Expression<String>? relationType,
    Expression<int>? position,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyId != null) 'study_id': studyId,
      if (character != null) 'character': character,
      if (onyomi != null) 'onyomi': onyomi,
      if (kunyomi != null) 'kunyomi': kunyomi,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (relationType != null) 'relation_type': relationType,
      if (position != null) 'position': position,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HanziRelatedJpCompanion copyWith(
      {Value<int>? id,
      Value<String>? studyId,
      Value<String>? character,
      Value<String>? onyomi,
      Value<String>? kunyomi,
      Value<String>? meaningKo,
      Value<String>? relationType,
      Value<int>? position,
      Value<String>? note,
      Value<DateTime>? updatedAt}) {
    return HanziRelatedJpCompanion(
      id: id ?? this.id,
      studyId: studyId ?? this.studyId,
      character: character ?? this.character,
      onyomi: onyomi ?? this.onyomi,
      kunyomi: kunyomi ?? this.kunyomi,
      meaningKo: meaningKo ?? this.meaningKo,
      relationType: relationType ?? this.relationType,
      position: position ?? this.position,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studyId.present) {
      map['study_id'] = Variable<String>(studyId.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (onyomi.present) {
      map['onyomi'] = Variable<String>(onyomi.value);
    }
    if (kunyomi.present) {
      map['kunyomi'] = Variable<String>(kunyomi.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanziRelatedJpCompanion(')
          ..write('id: $id, ')
          ..write('studyId: $studyId, ')
          ..write('character: $character, ')
          ..write('onyomi: $onyomi, ')
          ..write('kunyomi: $kunyomi, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('relationType: $relationType, ')
          ..write('position: $position, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $HanjaMasterTable extends HanjaMaster
    with TableInfo<$HanjaMasterTable, HanjaMasterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanjaMasterTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _korHanjaMeta =
      const VerificationMeta('korHanja');
  @override
  late final GeneratedColumn<String> korHanja = GeneratedColumn<String>(
      'kor_hanja', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _korSoundMeta =
      const VerificationMeta('korSound');
  @override
  late final GeneratedColumn<String> korSound = GeneratedColumn<String>(
      'kor_sound', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _korMeaningMeta =
      const VerificationMeta('korMeaning');
  @override
  late final GeneratedColumn<String> korMeaning = GeneratedColumn<String>(
      'kor_meaning', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _korLevelMeta =
      const VerificationMeta('korLevel');
  @override
  late final GeneratedColumn<String> korLevel = GeneratedColumn<String>(
      'kor_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _radicalMeta =
      const VerificationMeta('radical');
  @override
  late final GeneratedColumn<String> radical = GeneratedColumn<String>(
      'radical', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _strokeExMeta =
      const VerificationMeta('strokeEx');
  @override
  late final GeneratedColumn<int> strokeEx = GeneratedColumn<int>(
      'stroke_ex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _strokeTotalMeta =
      const VerificationMeta('strokeTotal');
  @override
  late final GeneratedColumn<int> strokeTotal = GeneratedColumn<int>(
      'stroke_total', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _zhSimplifiedMeta =
      const VerificationMeta('zhSimplified');
  @override
  late final GeneratedColumn<String> zhSimplified = GeneratedColumn<String>(
      'zh_simplified', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _zhTraditionalMeta =
      const VerificationMeta('zhTraditional');
  @override
  late final GeneratedColumn<String> zhTraditional = GeneratedColumn<String>(
      'zh_traditional', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jaKanjiMeta =
      const VerificationMeta('jaKanji');
  @override
  late final GeneratedColumn<String> jaKanji = GeneratedColumn<String>(
      'ja_kanji', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _hskLevelMeta =
      const VerificationMeta('hskLevel');
  @override
  late final GeneratedColumn<int> hskLevel = GeneratedColumn<int>(
      'hsk_level', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jlptLevelMeta =
      const VerificationMeta('jlptLevel');
  @override
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
      'jlpt_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _importanceMeta =
      const VerificationMeta('importance');
  @override
  late final GeneratedColumn<int> importance = GeneratedColumn<int>(
      'importance', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteAdminMeta =
      const VerificationMeta('noteAdmin');
  @override
  late final GeneratedColumn<String> noteAdmin = GeneratedColumn<String>(
      'note_admin', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        korHanja,
        korSound,
        korMeaning,
        korLevel,
        radical,
        strokeEx,
        strokeTotal,
        zhSimplified,
        zhTraditional,
        jaKanji,
        priority,
        hskLevel,
        jlptLevel,
        importance,
        noteAdmin,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanja_master';
  @override
  VerificationContext validateIntegrity(Insertable<HanjaMasterRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kor_hanja')) {
      context.handle(_korHanjaMeta,
          korHanja.isAcceptableOrUnknown(data['kor_hanja']!, _korHanjaMeta));
    } else if (isInserting) {
      context.missing(_korHanjaMeta);
    }
    if (data.containsKey('kor_sound')) {
      context.handle(_korSoundMeta,
          korSound.isAcceptableOrUnknown(data['kor_sound']!, _korSoundMeta));
    }
    if (data.containsKey('kor_meaning')) {
      context.handle(
          _korMeaningMeta,
          korMeaning.isAcceptableOrUnknown(
              data['kor_meaning']!, _korMeaningMeta));
    }
    if (data.containsKey('kor_level')) {
      context.handle(_korLevelMeta,
          korLevel.isAcceptableOrUnknown(data['kor_level']!, _korLevelMeta));
    }
    if (data.containsKey('radical')) {
      context.handle(_radicalMeta,
          radical.isAcceptableOrUnknown(data['radical']!, _radicalMeta));
    }
    if (data.containsKey('stroke_ex')) {
      context.handle(_strokeExMeta,
          strokeEx.isAcceptableOrUnknown(data['stroke_ex']!, _strokeExMeta));
    }
    if (data.containsKey('stroke_total')) {
      context.handle(
          _strokeTotalMeta,
          strokeTotal.isAcceptableOrUnknown(
              data['stroke_total']!, _strokeTotalMeta));
    }
    if (data.containsKey('zh_simplified')) {
      context.handle(
          _zhSimplifiedMeta,
          zhSimplified.isAcceptableOrUnknown(
              data['zh_simplified']!, _zhSimplifiedMeta));
    }
    if (data.containsKey('zh_traditional')) {
      context.handle(
          _zhTraditionalMeta,
          zhTraditional.isAcceptableOrUnknown(
              data['zh_traditional']!, _zhTraditionalMeta));
    }
    if (data.containsKey('ja_kanji')) {
      context.handle(_jaKanjiMeta,
          jaKanji.isAcceptableOrUnknown(data['ja_kanji']!, _jaKanjiMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('hsk_level')) {
      context.handle(_hskLevelMeta,
          hskLevel.isAcceptableOrUnknown(data['hsk_level']!, _hskLevelMeta));
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(_jlptLevelMeta,
          jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta));
    }
    if (data.containsKey('importance')) {
      context.handle(
          _importanceMeta,
          importance.isAcceptableOrUnknown(
              data['importance']!, _importanceMeta));
    }
    if (data.containsKey('note_admin')) {
      context.handle(_noteAdminMeta,
          noteAdmin.isAcceptableOrUnknown(data['note_admin']!, _noteAdminMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {korHanja};
  @override
  HanjaMasterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanjaMasterRow(
      korHanja: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kor_hanja'])!,
      korSound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kor_sound'])!,
      korMeaning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kor_meaning'])!,
      korLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kor_level'])!,
      radical: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}radical'])!,
      strokeEx: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stroke_ex'])!,
      strokeTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stroke_total'])!,
      zhSimplified: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zh_simplified']),
      zhTraditional: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zh_traditional']),
      jaKanji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ja_kanji']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      hskLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hsk_level']),
      jlptLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jlpt_level']),
      importance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}importance']),
      noteAdmin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_admin'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HanjaMasterTable createAlias(String alias) {
    return $HanjaMasterTable(attachedDatabase, alias);
  }
}

class HanjaMasterRow extends DataClass implements Insertable<HanjaMasterRow> {
  final String korHanja;
  final String korSound;
  final String korMeaning;
  final String korLevel;
  final String radical;
  final int strokeEx;
  final int strokeTotal;
  final String? zhSimplified;
  final String? zhTraditional;
  final String? jaKanji;
  final int priority;
  final int? hskLevel;
  final String? jlptLevel;
  final int? importance;
  final String noteAdmin;
  final DateTime updatedAt;
  const HanjaMasterRow(
      {required this.korHanja,
      required this.korSound,
      required this.korMeaning,
      required this.korLevel,
      required this.radical,
      required this.strokeEx,
      required this.strokeTotal,
      this.zhSimplified,
      this.zhTraditional,
      this.jaKanji,
      required this.priority,
      this.hskLevel,
      this.jlptLevel,
      this.importance,
      required this.noteAdmin,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kor_hanja'] = Variable<String>(korHanja);
    map['kor_sound'] = Variable<String>(korSound);
    map['kor_meaning'] = Variable<String>(korMeaning);
    map['kor_level'] = Variable<String>(korLevel);
    map['radical'] = Variable<String>(radical);
    map['stroke_ex'] = Variable<int>(strokeEx);
    map['stroke_total'] = Variable<int>(strokeTotal);
    if (!nullToAbsent || zhSimplified != null) {
      map['zh_simplified'] = Variable<String>(zhSimplified);
    }
    if (!nullToAbsent || zhTraditional != null) {
      map['zh_traditional'] = Variable<String>(zhTraditional);
    }
    if (!nullToAbsent || jaKanji != null) {
      map['ja_kanji'] = Variable<String>(jaKanji);
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || hskLevel != null) {
      map['hsk_level'] = Variable<int>(hskLevel);
    }
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    if (!nullToAbsent || importance != null) {
      map['importance'] = Variable<int>(importance);
    }
    map['note_admin'] = Variable<String>(noteAdmin);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HanjaMasterCompanion toCompanion(bool nullToAbsent) {
    return HanjaMasterCompanion(
      korHanja: Value(korHanja),
      korSound: Value(korSound),
      korMeaning: Value(korMeaning),
      korLevel: Value(korLevel),
      radical: Value(radical),
      strokeEx: Value(strokeEx),
      strokeTotal: Value(strokeTotal),
      zhSimplified: zhSimplified == null && nullToAbsent
          ? const Value.absent()
          : Value(zhSimplified),
      zhTraditional: zhTraditional == null && nullToAbsent
          ? const Value.absent()
          : Value(zhTraditional),
      jaKanji: jaKanji == null && nullToAbsent
          ? const Value.absent()
          : Value(jaKanji),
      priority: Value(priority),
      hskLevel: hskLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(hskLevel),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
      importance: importance == null && nullToAbsent
          ? const Value.absent()
          : Value(importance),
      noteAdmin: Value(noteAdmin),
      updatedAt: Value(updatedAt),
    );
  }

  factory HanjaMasterRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanjaMasterRow(
      korHanja: serializer.fromJson<String>(json['korHanja']),
      korSound: serializer.fromJson<String>(json['korSound']),
      korMeaning: serializer.fromJson<String>(json['korMeaning']),
      korLevel: serializer.fromJson<String>(json['korLevel']),
      radical: serializer.fromJson<String>(json['radical']),
      strokeEx: serializer.fromJson<int>(json['strokeEx']),
      strokeTotal: serializer.fromJson<int>(json['strokeTotal']),
      zhSimplified: serializer.fromJson<String?>(json['zhSimplified']),
      zhTraditional: serializer.fromJson<String?>(json['zhTraditional']),
      jaKanji: serializer.fromJson<String?>(json['jaKanji']),
      priority: serializer.fromJson<int>(json['priority']),
      hskLevel: serializer.fromJson<int?>(json['hskLevel']),
      jlptLevel: serializer.fromJson<String?>(json['jlptLevel']),
      importance: serializer.fromJson<int?>(json['importance']),
      noteAdmin: serializer.fromJson<String>(json['noteAdmin']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'korHanja': serializer.toJson<String>(korHanja),
      'korSound': serializer.toJson<String>(korSound),
      'korMeaning': serializer.toJson<String>(korMeaning),
      'korLevel': serializer.toJson<String>(korLevel),
      'radical': serializer.toJson<String>(radical),
      'strokeEx': serializer.toJson<int>(strokeEx),
      'strokeTotal': serializer.toJson<int>(strokeTotal),
      'zhSimplified': serializer.toJson<String?>(zhSimplified),
      'zhTraditional': serializer.toJson<String?>(zhTraditional),
      'jaKanji': serializer.toJson<String?>(jaKanji),
      'priority': serializer.toJson<int>(priority),
      'hskLevel': serializer.toJson<int?>(hskLevel),
      'jlptLevel': serializer.toJson<String?>(jlptLevel),
      'importance': serializer.toJson<int?>(importance),
      'noteAdmin': serializer.toJson<String>(noteAdmin),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HanjaMasterRow copyWith(
          {String? korHanja,
          String? korSound,
          String? korMeaning,
          String? korLevel,
          String? radical,
          int? strokeEx,
          int? strokeTotal,
          Value<String?> zhSimplified = const Value.absent(),
          Value<String?> zhTraditional = const Value.absent(),
          Value<String?> jaKanji = const Value.absent(),
          int? priority,
          Value<int?> hskLevel = const Value.absent(),
          Value<String?> jlptLevel = const Value.absent(),
          Value<int?> importance = const Value.absent(),
          String? noteAdmin,
          DateTime? updatedAt}) =>
      HanjaMasterRow(
        korHanja: korHanja ?? this.korHanja,
        korSound: korSound ?? this.korSound,
        korMeaning: korMeaning ?? this.korMeaning,
        korLevel: korLevel ?? this.korLevel,
        radical: radical ?? this.radical,
        strokeEx: strokeEx ?? this.strokeEx,
        strokeTotal: strokeTotal ?? this.strokeTotal,
        zhSimplified:
            zhSimplified.present ? zhSimplified.value : this.zhSimplified,
        zhTraditional:
            zhTraditional.present ? zhTraditional.value : this.zhTraditional,
        jaKanji: jaKanji.present ? jaKanji.value : this.jaKanji,
        priority: priority ?? this.priority,
        hskLevel: hskLevel.present ? hskLevel.value : this.hskLevel,
        jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
        importance: importance.present ? importance.value : this.importance,
        noteAdmin: noteAdmin ?? this.noteAdmin,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HanjaMasterRow copyWithCompanion(HanjaMasterCompanion data) {
    return HanjaMasterRow(
      korHanja: data.korHanja.present ? data.korHanja.value : this.korHanja,
      korSound: data.korSound.present ? data.korSound.value : this.korSound,
      korMeaning:
          data.korMeaning.present ? data.korMeaning.value : this.korMeaning,
      korLevel: data.korLevel.present ? data.korLevel.value : this.korLevel,
      radical: data.radical.present ? data.radical.value : this.radical,
      strokeEx: data.strokeEx.present ? data.strokeEx.value : this.strokeEx,
      strokeTotal:
          data.strokeTotal.present ? data.strokeTotal.value : this.strokeTotal,
      zhSimplified: data.zhSimplified.present
          ? data.zhSimplified.value
          : this.zhSimplified,
      zhTraditional: data.zhTraditional.present
          ? data.zhTraditional.value
          : this.zhTraditional,
      jaKanji: data.jaKanji.present ? data.jaKanji.value : this.jaKanji,
      priority: data.priority.present ? data.priority.value : this.priority,
      hskLevel: data.hskLevel.present ? data.hskLevel.value : this.hskLevel,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      importance:
          data.importance.present ? data.importance.value : this.importance,
      noteAdmin: data.noteAdmin.present ? data.noteAdmin.value : this.noteAdmin,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanjaMasterRow(')
          ..write('korHanja: $korHanja, ')
          ..write('korSound: $korSound, ')
          ..write('korMeaning: $korMeaning, ')
          ..write('korLevel: $korLevel, ')
          ..write('radical: $radical, ')
          ..write('strokeEx: $strokeEx, ')
          ..write('strokeTotal: $strokeTotal, ')
          ..write('zhSimplified: $zhSimplified, ')
          ..write('zhTraditional: $zhTraditional, ')
          ..write('jaKanji: $jaKanji, ')
          ..write('priority: $priority, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('importance: $importance, ')
          ..write('noteAdmin: $noteAdmin, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      korHanja,
      korSound,
      korMeaning,
      korLevel,
      radical,
      strokeEx,
      strokeTotal,
      zhSimplified,
      zhTraditional,
      jaKanji,
      priority,
      hskLevel,
      jlptLevel,
      importance,
      noteAdmin,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanjaMasterRow &&
          other.korHanja == this.korHanja &&
          other.korSound == this.korSound &&
          other.korMeaning == this.korMeaning &&
          other.korLevel == this.korLevel &&
          other.radical == this.radical &&
          other.strokeEx == this.strokeEx &&
          other.strokeTotal == this.strokeTotal &&
          other.zhSimplified == this.zhSimplified &&
          other.zhTraditional == this.zhTraditional &&
          other.jaKanji == this.jaKanji &&
          other.priority == this.priority &&
          other.hskLevel == this.hskLevel &&
          other.jlptLevel == this.jlptLevel &&
          other.importance == this.importance &&
          other.noteAdmin == this.noteAdmin &&
          other.updatedAt == this.updatedAt);
}

class HanjaMasterCompanion extends UpdateCompanion<HanjaMasterRow> {
  final Value<String> korHanja;
  final Value<String> korSound;
  final Value<String> korMeaning;
  final Value<String> korLevel;
  final Value<String> radical;
  final Value<int> strokeEx;
  final Value<int> strokeTotal;
  final Value<String?> zhSimplified;
  final Value<String?> zhTraditional;
  final Value<String?> jaKanji;
  final Value<int> priority;
  final Value<int?> hskLevel;
  final Value<String?> jlptLevel;
  final Value<int?> importance;
  final Value<String> noteAdmin;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HanjaMasterCompanion({
    this.korHanja = const Value.absent(),
    this.korSound = const Value.absent(),
    this.korMeaning = const Value.absent(),
    this.korLevel = const Value.absent(),
    this.radical = const Value.absent(),
    this.strokeEx = const Value.absent(),
    this.strokeTotal = const Value.absent(),
    this.zhSimplified = const Value.absent(),
    this.zhTraditional = const Value.absent(),
    this.jaKanji = const Value.absent(),
    this.priority = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.importance = const Value.absent(),
    this.noteAdmin = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HanjaMasterCompanion.insert({
    required String korHanja,
    this.korSound = const Value.absent(),
    this.korMeaning = const Value.absent(),
    this.korLevel = const Value.absent(),
    this.radical = const Value.absent(),
    this.strokeEx = const Value.absent(),
    this.strokeTotal = const Value.absent(),
    this.zhSimplified = const Value.absent(),
    this.zhTraditional = const Value.absent(),
    this.jaKanji = const Value.absent(),
    this.priority = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.importance = const Value.absent(),
    this.noteAdmin = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : korHanja = Value(korHanja),
        updatedAt = Value(updatedAt);
  static Insertable<HanjaMasterRow> custom({
    Expression<String>? korHanja,
    Expression<String>? korSound,
    Expression<String>? korMeaning,
    Expression<String>? korLevel,
    Expression<String>? radical,
    Expression<int>? strokeEx,
    Expression<int>? strokeTotal,
    Expression<String>? zhSimplified,
    Expression<String>? zhTraditional,
    Expression<String>? jaKanji,
    Expression<int>? priority,
    Expression<int>? hskLevel,
    Expression<String>? jlptLevel,
    Expression<int>? importance,
    Expression<String>? noteAdmin,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (korHanja != null) 'kor_hanja': korHanja,
      if (korSound != null) 'kor_sound': korSound,
      if (korMeaning != null) 'kor_meaning': korMeaning,
      if (korLevel != null) 'kor_level': korLevel,
      if (radical != null) 'radical': radical,
      if (strokeEx != null) 'stroke_ex': strokeEx,
      if (strokeTotal != null) 'stroke_total': strokeTotal,
      if (zhSimplified != null) 'zh_simplified': zhSimplified,
      if (zhTraditional != null) 'zh_traditional': zhTraditional,
      if (jaKanji != null) 'ja_kanji': jaKanji,
      if (priority != null) 'priority': priority,
      if (hskLevel != null) 'hsk_level': hskLevel,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (importance != null) 'importance': importance,
      if (noteAdmin != null) 'note_admin': noteAdmin,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HanjaMasterCompanion copyWith(
      {Value<String>? korHanja,
      Value<String>? korSound,
      Value<String>? korMeaning,
      Value<String>? korLevel,
      Value<String>? radical,
      Value<int>? strokeEx,
      Value<int>? strokeTotal,
      Value<String?>? zhSimplified,
      Value<String?>? zhTraditional,
      Value<String?>? jaKanji,
      Value<int>? priority,
      Value<int?>? hskLevel,
      Value<String?>? jlptLevel,
      Value<int?>? importance,
      Value<String>? noteAdmin,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return HanjaMasterCompanion(
      korHanja: korHanja ?? this.korHanja,
      korSound: korSound ?? this.korSound,
      korMeaning: korMeaning ?? this.korMeaning,
      korLevel: korLevel ?? this.korLevel,
      radical: radical ?? this.radical,
      strokeEx: strokeEx ?? this.strokeEx,
      strokeTotal: strokeTotal ?? this.strokeTotal,
      zhSimplified: zhSimplified ?? this.zhSimplified,
      zhTraditional: zhTraditional ?? this.zhTraditional,
      jaKanji: jaKanji ?? this.jaKanji,
      priority: priority ?? this.priority,
      hskLevel: hskLevel ?? this.hskLevel,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      importance: importance ?? this.importance,
      noteAdmin: noteAdmin ?? this.noteAdmin,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (korHanja.present) {
      map['kor_hanja'] = Variable<String>(korHanja.value);
    }
    if (korSound.present) {
      map['kor_sound'] = Variable<String>(korSound.value);
    }
    if (korMeaning.present) {
      map['kor_meaning'] = Variable<String>(korMeaning.value);
    }
    if (korLevel.present) {
      map['kor_level'] = Variable<String>(korLevel.value);
    }
    if (radical.present) {
      map['radical'] = Variable<String>(radical.value);
    }
    if (strokeEx.present) {
      map['stroke_ex'] = Variable<int>(strokeEx.value);
    }
    if (strokeTotal.present) {
      map['stroke_total'] = Variable<int>(strokeTotal.value);
    }
    if (zhSimplified.present) {
      map['zh_simplified'] = Variable<String>(zhSimplified.value);
    }
    if (zhTraditional.present) {
      map['zh_traditional'] = Variable<String>(zhTraditional.value);
    }
    if (jaKanji.present) {
      map['ja_kanji'] = Variable<String>(jaKanji.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (hskLevel.present) {
      map['hsk_level'] = Variable<int>(hskLevel.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (importance.present) {
      map['importance'] = Variable<int>(importance.value);
    }
    if (noteAdmin.present) {
      map['note_admin'] = Variable<String>(noteAdmin.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanjaMasterCompanion(')
          ..write('korHanja: $korHanja, ')
          ..write('korSound: $korSound, ')
          ..write('korMeaning: $korMeaning, ')
          ..write('korLevel: $korLevel, ')
          ..write('radical: $radical, ')
          ..write('strokeEx: $strokeEx, ')
          ..write('strokeTotal: $strokeTotal, ')
          ..write('zhSimplified: $zhSimplified, ')
          ..write('zhTraditional: $zhTraditional, ')
          ..write('jaKanji: $jaKanji, ')
          ..write('priority: $priority, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('importance: $importance, ')
          ..write('noteAdmin: $noteAdmin, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HanjaRelatedTable extends HanjaRelated
    with TableInfo<$HanjaRelatedTable, HanjaRelatedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HanjaRelatedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relatedMeta =
      const VerificationMeta('related');
  @override
  late final GeneratedColumn<String> related = GeneratedColumn<String>(
      'related', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationMeta =
      const VerificationMeta('relation');
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
      'relation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _addedByMeta =
      const VerificationMeta('addedBy');
  @override
  late final GeneratedColumn<String> addedBy = GeneratedColumn<String>(
      'added_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, source, related, relation, position, note, addedBy, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hanja_related';
  @override
  VerificationContext validateIntegrity(Insertable<HanjaRelatedRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('related')) {
      context.handle(_relatedMeta,
          related.isAcceptableOrUnknown(data['related']!, _relatedMeta));
    } else if (isInserting) {
      context.missing(_relatedMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(_relationMeta,
          relation.isAcceptableOrUnknown(data['relation']!, _relationMeta));
    } else if (isInserting) {
      context.missing(_relationMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('added_by')) {
      context.handle(_addedByMeta,
          addedBy.isAcceptableOrUnknown(data['added_by']!, _addedByMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HanjaRelatedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HanjaRelatedRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      related: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related'])!,
      relation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      addedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}added_by'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HanjaRelatedTable createAlias(String alias) {
    return $HanjaRelatedTable(attachedDatabase, alias);
  }
}

class HanjaRelatedRow extends DataClass implements Insertable<HanjaRelatedRow> {
  final int id;
  final String source;
  final String related;
  final String relation;
  final int position;
  final String note;
  final String addedBy;
  final DateTime updatedAt;
  const HanjaRelatedRow(
      {required this.id,
      required this.source,
      required this.related,
      required this.relation,
      required this.position,
      required this.note,
      required this.addedBy,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source'] = Variable<String>(source);
    map['related'] = Variable<String>(related);
    map['relation'] = Variable<String>(relation);
    map['position'] = Variable<int>(position);
    map['note'] = Variable<String>(note);
    map['added_by'] = Variable<String>(addedBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HanjaRelatedCompanion toCompanion(bool nullToAbsent) {
    return HanjaRelatedCompanion(
      id: Value(id),
      source: Value(source),
      related: Value(related),
      relation: Value(relation),
      position: Value(position),
      note: Value(note),
      addedBy: Value(addedBy),
      updatedAt: Value(updatedAt),
    );
  }

  factory HanjaRelatedRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HanjaRelatedRow(
      id: serializer.fromJson<int>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      related: serializer.fromJson<String>(json['related']),
      relation: serializer.fromJson<String>(json['relation']),
      position: serializer.fromJson<int>(json['position']),
      note: serializer.fromJson<String>(json['note']),
      addedBy: serializer.fromJson<String>(json['addedBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<String>(source),
      'related': serializer.toJson<String>(related),
      'relation': serializer.toJson<String>(relation),
      'position': serializer.toJson<int>(position),
      'note': serializer.toJson<String>(note),
      'addedBy': serializer.toJson<String>(addedBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HanjaRelatedRow copyWith(
          {int? id,
          String? source,
          String? related,
          String? relation,
          int? position,
          String? note,
          String? addedBy,
          DateTime? updatedAt}) =>
      HanjaRelatedRow(
        id: id ?? this.id,
        source: source ?? this.source,
        related: related ?? this.related,
        relation: relation ?? this.relation,
        position: position ?? this.position,
        note: note ?? this.note,
        addedBy: addedBy ?? this.addedBy,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HanjaRelatedRow copyWithCompanion(HanjaRelatedCompanion data) {
    return HanjaRelatedRow(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      related: data.related.present ? data.related.value : this.related,
      relation: data.relation.present ? data.relation.value : this.relation,
      position: data.position.present ? data.position.value : this.position,
      note: data.note.present ? data.note.value : this.note,
      addedBy: data.addedBy.present ? data.addedBy.value : this.addedBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HanjaRelatedRow(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('related: $related, ')
          ..write('relation: $relation, ')
          ..write('position: $position, ')
          ..write('note: $note, ')
          ..write('addedBy: $addedBy, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, source, related, relation, position, note, addedBy, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HanjaRelatedRow &&
          other.id == this.id &&
          other.source == this.source &&
          other.related == this.related &&
          other.relation == this.relation &&
          other.position == this.position &&
          other.note == this.note &&
          other.addedBy == this.addedBy &&
          other.updatedAt == this.updatedAt);
}

class HanjaRelatedCompanion extends UpdateCompanion<HanjaRelatedRow> {
  final Value<int> id;
  final Value<String> source;
  final Value<String> related;
  final Value<String> relation;
  final Value<int> position;
  final Value<String> note;
  final Value<String> addedBy;
  final Value<DateTime> updatedAt;
  const HanjaRelatedCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.related = const Value.absent(),
    this.relation = const Value.absent(),
    this.position = const Value.absent(),
    this.note = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HanjaRelatedCompanion.insert({
    this.id = const Value.absent(),
    required String source,
    required String related,
    required String relation,
    this.position = const Value.absent(),
    this.note = const Value.absent(),
    this.addedBy = const Value.absent(),
    required DateTime updatedAt,
  })  : source = Value(source),
        related = Value(related),
        relation = Value(relation),
        updatedAt = Value(updatedAt);
  static Insertable<HanjaRelatedRow> custom({
    Expression<int>? id,
    Expression<String>? source,
    Expression<String>? related,
    Expression<String>? relation,
    Expression<int>? position,
    Expression<String>? note,
    Expression<String>? addedBy,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (related != null) 'related': related,
      if (relation != null) 'relation': relation,
      if (position != null) 'position': position,
      if (note != null) 'note': note,
      if (addedBy != null) 'added_by': addedBy,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HanjaRelatedCompanion copyWith(
      {Value<int>? id,
      Value<String>? source,
      Value<String>? related,
      Value<String>? relation,
      Value<int>? position,
      Value<String>? note,
      Value<String>? addedBy,
      Value<DateTime>? updatedAt}) {
    return HanjaRelatedCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      related: related ?? this.related,
      relation: relation ?? this.relation,
      position: position ?? this.position,
      note: note ?? this.note,
      addedBy: addedBy ?? this.addedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (related.present) {
      map['related'] = Variable<String>(related.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (addedBy.present) {
      map['added_by'] = Variable<String>(addedBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HanjaRelatedCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('related: $related, ')
          ..write('relation: $relation, ')
          ..write('position: $position, ')
          ..write('note: $note, ')
          ..write('addedBy: $addedBy, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EtymonTable extends Etymon with TableInfo<$EtymonTable, EtymonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EtymonTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceLangMeta =
      const VerificationMeta('sourceLang');
  @override
  late final GeneratedColumn<String> sourceLang = GeneratedColumn<String>(
      'source_lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
      'root', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningKoMeta =
      const VerificationMeta('meaningKo');
  @override
  late final GeneratedColumn<String> meaningKo = GeneratedColumn<String>(
      'meaning_ko', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningEnMeta =
      const VerificationMeta('meaningEn');
  @override
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
      'meaning_en', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourceLang, root, meaningKo, meaningEn, notes, priority, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'etymon';
  @override
  VerificationContext validateIntegrity(Insertable<EtymonRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_lang')) {
      context.handle(
          _sourceLangMeta,
          sourceLang.isAcceptableOrUnknown(
              data['source_lang']!, _sourceLangMeta));
    } else if (isInserting) {
      context.missing(_sourceLangMeta);
    }
    if (data.containsKey('root')) {
      context.handle(
          _rootMeta, root.isAcceptableOrUnknown(data['root']!, _rootMeta));
    } else if (isInserting) {
      context.missing(_rootMeta);
    }
    if (data.containsKey('meaning_ko')) {
      context.handle(_meaningKoMeta,
          meaningKo.isAcceptableOrUnknown(data['meaning_ko']!, _meaningKoMeta));
    } else if (isInserting) {
      context.missing(_meaningKoMeta);
    }
    if (data.containsKey('meaning_en')) {
      context.handle(_meaningEnMeta,
          meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EtymonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EtymonRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_lang'])!,
      root: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}root'])!,
      meaningKo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_ko'])!,
      meaningEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_en'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EtymonTable createAlias(String alias) {
    return $EtymonTable(attachedDatabase, alias);
  }
}

class EtymonRow extends DataClass implements Insertable<EtymonRow> {
  final String id;
  final String sourceLang;
  final String root;
  final String meaningKo;
  final String meaningEn;
  final String notes;
  final int priority;
  final DateTime updatedAt;
  const EtymonRow(
      {required this.id,
      required this.sourceLang,
      required this.root,
      required this.meaningKo,
      required this.meaningEn,
      required this.notes,
      required this.priority,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_lang'] = Variable<String>(sourceLang);
    map['root'] = Variable<String>(root);
    map['meaning_ko'] = Variable<String>(meaningKo);
    map['meaning_en'] = Variable<String>(meaningEn);
    map['notes'] = Variable<String>(notes);
    map['priority'] = Variable<int>(priority);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EtymonCompanion toCompanion(bool nullToAbsent) {
    return EtymonCompanion(
      id: Value(id),
      sourceLang: Value(sourceLang),
      root: Value(root),
      meaningKo: Value(meaningKo),
      meaningEn: Value(meaningEn),
      notes: Value(notes),
      priority: Value(priority),
      updatedAt: Value(updatedAt),
    );
  }

  factory EtymonRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EtymonRow(
      id: serializer.fromJson<String>(json['id']),
      sourceLang: serializer.fromJson<String>(json['sourceLang']),
      root: serializer.fromJson<String>(json['root']),
      meaningKo: serializer.fromJson<String>(json['meaningKo']),
      meaningEn: serializer.fromJson<String>(json['meaningEn']),
      notes: serializer.fromJson<String>(json['notes']),
      priority: serializer.fromJson<int>(json['priority']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceLang': serializer.toJson<String>(sourceLang),
      'root': serializer.toJson<String>(root),
      'meaningKo': serializer.toJson<String>(meaningKo),
      'meaningEn': serializer.toJson<String>(meaningEn),
      'notes': serializer.toJson<String>(notes),
      'priority': serializer.toJson<int>(priority),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EtymonRow copyWith(
          {String? id,
          String? sourceLang,
          String? root,
          String? meaningKo,
          String? meaningEn,
          String? notes,
          int? priority,
          DateTime? updatedAt}) =>
      EtymonRow(
        id: id ?? this.id,
        sourceLang: sourceLang ?? this.sourceLang,
        root: root ?? this.root,
        meaningKo: meaningKo ?? this.meaningKo,
        meaningEn: meaningEn ?? this.meaningEn,
        notes: notes ?? this.notes,
        priority: priority ?? this.priority,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  EtymonRow copyWithCompanion(EtymonCompanion data) {
    return EtymonRow(
      id: data.id.present ? data.id.value : this.id,
      sourceLang:
          data.sourceLang.present ? data.sourceLang.value : this.sourceLang,
      root: data.root.present ? data.root.value : this.root,
      meaningKo: data.meaningKo.present ? data.meaningKo.value : this.meaningKo,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      notes: data.notes.present ? data.notes.value : this.notes,
      priority: data.priority.present ? data.priority.value : this.priority,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EtymonRow(')
          ..write('id: $id, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('root: $root, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('notes: $notes, ')
          ..write('priority: $priority, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sourceLang, root, meaningKo, meaningEn, notes, priority, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EtymonRow &&
          other.id == this.id &&
          other.sourceLang == this.sourceLang &&
          other.root == this.root &&
          other.meaningKo == this.meaningKo &&
          other.meaningEn == this.meaningEn &&
          other.notes == this.notes &&
          other.priority == this.priority &&
          other.updatedAt == this.updatedAt);
}

class EtymonCompanion extends UpdateCompanion<EtymonRow> {
  final Value<String> id;
  final Value<String> sourceLang;
  final Value<String> root;
  final Value<String> meaningKo;
  final Value<String> meaningEn;
  final Value<String> notes;
  final Value<int> priority;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EtymonCompanion({
    this.id = const Value.absent(),
    this.sourceLang = const Value.absent(),
    this.root = const Value.absent(),
    this.meaningKo = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.notes = const Value.absent(),
    this.priority = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EtymonCompanion.insert({
    required String id,
    required String sourceLang,
    required String root,
    required String meaningKo,
    this.meaningEn = const Value.absent(),
    this.notes = const Value.absent(),
    this.priority = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceLang = Value(sourceLang),
        root = Value(root),
        meaningKo = Value(meaningKo),
        updatedAt = Value(updatedAt);
  static Insertable<EtymonRow> custom({
    Expression<String>? id,
    Expression<String>? sourceLang,
    Expression<String>? root,
    Expression<String>? meaningKo,
    Expression<String>? meaningEn,
    Expression<String>? notes,
    Expression<int>? priority,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceLang != null) 'source_lang': sourceLang,
      if (root != null) 'root': root,
      if (meaningKo != null) 'meaning_ko': meaningKo,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (notes != null) 'notes': notes,
      if (priority != null) 'priority': priority,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EtymonCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceLang,
      Value<String>? root,
      Value<String>? meaningKo,
      Value<String>? meaningEn,
      Value<String>? notes,
      Value<int>? priority,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return EtymonCompanion(
      id: id ?? this.id,
      sourceLang: sourceLang ?? this.sourceLang,
      root: root ?? this.root,
      meaningKo: meaningKo ?? this.meaningKo,
      meaningEn: meaningEn ?? this.meaningEn,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceLang.present) {
      map['source_lang'] = Variable<String>(sourceLang.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (meaningKo.present) {
      map['meaning_ko'] = Variable<String>(meaningKo.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EtymonCompanion(')
          ..write('id: $id, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('root: $root, ')
          ..write('meaningKo: $meaningKo, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('notes: $notes, ')
          ..write('priority: $priority, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $UserStatsTable userStats = $UserStatsTable(this);
  late final $DailyCountsTable dailyCounts = $DailyCountsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final $HanziStudiesZhTable hanziStudiesZh = $HanziStudiesZhTable(this);
  late final $HanziRelatedZhTable hanziRelatedZh = $HanziRelatedZhTable(this);
  late final $HanziStudiesJpTable hanziStudiesJp = $HanziStudiesJpTable(this);
  late final $HanziRelatedJpTable hanziRelatedJp = $HanziRelatedJpTable(this);
  late final $HanjaMasterTable hanjaMaster = $HanjaMasterTable(this);
  late final $HanjaRelatedTable hanjaRelated = $HanjaRelatedTable(this);
  late final $EtymonTable etymon = $EtymonTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        items,
        userProgress,
        userStats,
        dailyCounts,
        syncMeta,
        hanziStudiesZh,
        hanziRelatedZh,
        hanziStudiesJp,
        hanziRelatedJp,
        hanjaMaster,
        hanjaRelated,
        etymon
      ];
}

typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String type,
  required String targetText,
  required String korean,
  Value<String> romanization,
  Value<String?> targetSouth,
  Value<String?> koreanSouth,
  Value<String?> romanizationSouth,
  Value<String?> targetSpain,
  Value<String?> koreanSpain,
  Value<String?> romanizationSpain,
  Value<String> category,
  Value<int> course,
  Value<String> tagsCsv,
  Value<String> notes,
  Value<String> comment,
  Value<String> relatedCsv,
  Value<String> rootRefs,
  Value<String> speaker,
  Value<int> turnOrder,
  Value<String> scenario,
  Value<String?> tier,
  Value<int> dialogueOrder,
  Value<String?> vocabHints,
  Value<bool> isPolite,
  Value<int?> applicableScenario,
  Value<String?> morphTags,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> targetText,
  Value<String> korean,
  Value<String> romanization,
  Value<String?> targetSouth,
  Value<String?> koreanSouth,
  Value<String?> romanizationSouth,
  Value<String?> targetSpain,
  Value<String?> koreanSpain,
  Value<String?> romanizationSpain,
  Value<String> category,
  Value<int> course,
  Value<String> tagsCsv,
  Value<String> notes,
  Value<String> comment,
  Value<String> relatedCsv,
  Value<String> rootRefs,
  Value<String> speaker,
  Value<int> turnOrder,
  Value<String> scenario,
  Value<String?> tier,
  Value<int> dialogueOrder,
  Value<String?> vocabHints,
  Value<bool> isPolite,
  Value<int?> applicableScenario,
  Value<String?> morphTags,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetText => $composableBuilder(
      column: $table.targetText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get korean => $composableBuilder(
      column: $table.korean, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get romanization => $composableBuilder(
      column: $table.romanization, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetSouth => $composableBuilder(
      column: $table.targetSouth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get koreanSouth => $composableBuilder(
      column: $table.koreanSouth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get romanizationSouth => $composableBuilder(
      column: $table.romanizationSouth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetSpain => $composableBuilder(
      column: $table.targetSpain, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get koreanSpain => $composableBuilder(
      column: $table.koreanSpain, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get romanizationSpain => $composableBuilder(
      column: $table.romanizationSpain,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get course => $composableBuilder(
      column: $table.course, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsCsv => $composableBuilder(
      column: $table.tagsCsv, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedCsv => $composableBuilder(
      column: $table.relatedCsv, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rootRefs => $composableBuilder(
      column: $table.rootRefs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speaker => $composableBuilder(
      column: $table.speaker, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get turnOrder => $composableBuilder(
      column: $table.turnOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenario => $composableBuilder(
      column: $table.scenario, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dialogueOrder => $composableBuilder(
      column: $table.dialogueOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vocabHints => $composableBuilder(
      column: $table.vocabHints, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPolite => $composableBuilder(
      column: $table.isPolite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get applicableScenario => $composableBuilder(
      column: $table.applicableScenario,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get morphTags => $composableBuilder(
      column: $table.morphTags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetText => $composableBuilder(
      column: $table.targetText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get korean => $composableBuilder(
      column: $table.korean, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get romanization => $composableBuilder(
      column: $table.romanization,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetSouth => $composableBuilder(
      column: $table.targetSouth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get koreanSouth => $composableBuilder(
      column: $table.koreanSouth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get romanizationSouth => $composableBuilder(
      column: $table.romanizationSouth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetSpain => $composableBuilder(
      column: $table.targetSpain, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get koreanSpain => $composableBuilder(
      column: $table.koreanSpain, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get romanizationSpain => $composableBuilder(
      column: $table.romanizationSpain,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get course => $composableBuilder(
      column: $table.course, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsCsv => $composableBuilder(
      column: $table.tagsCsv, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedCsv => $composableBuilder(
      column: $table.relatedCsv, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rootRefs => $composableBuilder(
      column: $table.rootRefs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speaker => $composableBuilder(
      column: $table.speaker, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get turnOrder => $composableBuilder(
      column: $table.turnOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenario => $composableBuilder(
      column: $table.scenario, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dialogueOrder => $composableBuilder(
      column: $table.dialogueOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vocabHints => $composableBuilder(
      column: $table.vocabHints, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPolite => $composableBuilder(
      column: $table.isPolite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get applicableScenario => $composableBuilder(
      column: $table.applicableScenario,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get morphTags => $composableBuilder(
      column: $table.morphTags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get targetText => $composableBuilder(
      column: $table.targetText, builder: (column) => column);

  GeneratedColumn<String> get korean =>
      $composableBuilder(column: $table.korean, builder: (column) => column);

  GeneratedColumn<String> get romanization => $composableBuilder(
      column: $table.romanization, builder: (column) => column);

  GeneratedColumn<String> get targetSouth => $composableBuilder(
      column: $table.targetSouth, builder: (column) => column);

  GeneratedColumn<String> get koreanSouth => $composableBuilder(
      column: $table.koreanSouth, builder: (column) => column);

  GeneratedColumn<String> get romanizationSouth => $composableBuilder(
      column: $table.romanizationSouth, builder: (column) => column);

  GeneratedColumn<String> get targetSpain => $composableBuilder(
      column: $table.targetSpain, builder: (column) => column);

  GeneratedColumn<String> get koreanSpain => $composableBuilder(
      column: $table.koreanSpain, builder: (column) => column);

  GeneratedColumn<String> get romanizationSpain => $composableBuilder(
      column: $table.romanizationSpain, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get course =>
      $composableBuilder(column: $table.course, builder: (column) => column);

  GeneratedColumn<String> get tagsCsv =>
      $composableBuilder(column: $table.tagsCsv, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get relatedCsv => $composableBuilder(
      column: $table.relatedCsv, builder: (column) => column);

  GeneratedColumn<String> get rootRefs =>
      $composableBuilder(column: $table.rootRefs, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<int> get turnOrder =>
      $composableBuilder(column: $table.turnOrder, builder: (column) => column);

  GeneratedColumn<String> get scenario =>
      $composableBuilder(column: $table.scenario, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get dialogueOrder => $composableBuilder(
      column: $table.dialogueOrder, builder: (column) => column);

  GeneratedColumn<String> get vocabHints => $composableBuilder(
      column: $table.vocabHints, builder: (column) => column);

  GeneratedColumn<bool> get isPolite =>
      $composableBuilder(column: $table.isPolite, builder: (column) => column);

  GeneratedColumn<int> get applicableScenario => $composableBuilder(
      column: $table.applicableScenario, builder: (column) => column);

  GeneratedColumn<String> get morphTags =>
      $composableBuilder(column: $table.morphTags, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
    Item,
    PrefetchHooks Function()> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> targetText = const Value.absent(),
            Value<String> korean = const Value.absent(),
            Value<String> romanization = const Value.absent(),
            Value<String?> targetSouth = const Value.absent(),
            Value<String?> koreanSouth = const Value.absent(),
            Value<String?> romanizationSouth = const Value.absent(),
            Value<String?> targetSpain = const Value.absent(),
            Value<String?> koreanSpain = const Value.absent(),
            Value<String?> romanizationSpain = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> course = const Value.absent(),
            Value<String> tagsCsv = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<String> relatedCsv = const Value.absent(),
            Value<String> rootRefs = const Value.absent(),
            Value<String> speaker = const Value.absent(),
            Value<int> turnOrder = const Value.absent(),
            Value<String> scenario = const Value.absent(),
            Value<String?> tier = const Value.absent(),
            Value<int> dialogueOrder = const Value.absent(),
            Value<String?> vocabHints = const Value.absent(),
            Value<bool> isPolite = const Value.absent(),
            Value<int?> applicableScenario = const Value.absent(),
            Value<String?> morphTags = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            type: type,
            targetText: targetText,
            korean: korean,
            romanization: romanization,
            targetSouth: targetSouth,
            koreanSouth: koreanSouth,
            romanizationSouth: romanizationSouth,
            targetSpain: targetSpain,
            koreanSpain: koreanSpain,
            romanizationSpain: romanizationSpain,
            category: category,
            course: course,
            tagsCsv: tagsCsv,
            notes: notes,
            comment: comment,
            relatedCsv: relatedCsv,
            rootRefs: rootRefs,
            speaker: speaker,
            turnOrder: turnOrder,
            scenario: scenario,
            tier: tier,
            dialogueOrder: dialogueOrder,
            vocabHints: vocabHints,
            isPolite: isPolite,
            applicableScenario: applicableScenario,
            morphTags: morphTags,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String targetText,
            required String korean,
            Value<String> romanization = const Value.absent(),
            Value<String?> targetSouth = const Value.absent(),
            Value<String?> koreanSouth = const Value.absent(),
            Value<String?> romanizationSouth = const Value.absent(),
            Value<String?> targetSpain = const Value.absent(),
            Value<String?> koreanSpain = const Value.absent(),
            Value<String?> romanizationSpain = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> course = const Value.absent(),
            Value<String> tagsCsv = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<String> relatedCsv = const Value.absent(),
            Value<String> rootRefs = const Value.absent(),
            Value<String> speaker = const Value.absent(),
            Value<int> turnOrder = const Value.absent(),
            Value<String> scenario = const Value.absent(),
            Value<String?> tier = const Value.absent(),
            Value<int> dialogueOrder = const Value.absent(),
            Value<String?> vocabHints = const Value.absent(),
            Value<bool> isPolite = const Value.absent(),
            Value<int?> applicableScenario = const Value.absent(),
            Value<String?> morphTags = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            type: type,
            targetText: targetText,
            korean: korean,
            romanization: romanization,
            targetSouth: targetSouth,
            koreanSouth: koreanSouth,
            romanizationSouth: romanizationSouth,
            targetSpain: targetSpain,
            koreanSpain: koreanSpain,
            romanizationSpain: romanizationSpain,
            category: category,
            course: course,
            tagsCsv: tagsCsv,
            notes: notes,
            comment: comment,
            relatedCsv: relatedCsv,
            rootRefs: rootRefs,
            speaker: speaker,
            turnOrder: turnOrder,
            scenario: scenario,
            tier: tier,
            dialogueOrder: dialogueOrder,
            vocabHints: vocabHints,
            isPolite: isPolite,
            applicableScenario: applicableScenario,
            morphTags: morphTags,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
    Item,
    PrefetchHooks Function()>;
typedef $$UserProgressTableCreateCompanionBuilder = UserProgressCompanion
    Function({
  required String itemId,
  Value<bool> isKnown,
  Value<bool> isFavorite,
  Value<int> reviewScore,
  Value<DateTime?> nextReviewAt,
  required DateTime updatedAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$UserProgressTableUpdateCompanionBuilder = UserProgressCompanion
    Function({
  Value<String> itemId,
  Value<bool> isKnown,
  Value<bool> isFavorite,
  Value<int> reviewScore,
  Value<DateTime?> nextReviewAt,
  Value<DateTime> updatedAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isKnown => $composableBuilder(
      column: $table.isKnown, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewScore => $composableBuilder(
      column: $table.reviewScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isKnown => $composableBuilder(
      column: $table.isKnown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewScore => $composableBuilder(
      column: $table.reviewScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<bool> get isKnown =>
      $composableBuilder(column: $table.isKnown, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<int> get reviewScore => $composableBuilder(
      column: $table.reviewScore, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$UserProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressRow,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressRow,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressRow>
    ),
    UserProgressRow,
    PrefetchHooks Function()> {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemId = const Value.absent(),
            Value<bool> isKnown = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> reviewScore = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProgressCompanion(
            itemId: itemId,
            isKnown: isKnown,
            isFavorite: isFavorite,
            reviewScore: reviewScore,
            nextReviewAt: nextReviewAt,
            updatedAt: updatedAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemId,
            Value<bool> isKnown = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> reviewScore = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            required DateTime updatedAt,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProgressCompanion.insert(
            itemId: itemId,
            isKnown: isKnown,
            isFavorite: isFavorite,
            reviewScore: reviewScore,
            nextReviewAt: nextReviewAt,
            updatedAt: updatedAt,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressRow,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressRow,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressRow>
    ),
    UserProgressRow,
    PrefetchHooks Function()>;
typedef $$UserStatsTableCreateCompanionBuilder = UserStatsCompanion Function({
  Value<int> id,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastStudyDate,
  Value<int> dailyGoal,
  required DateTime updatedAt,
  Value<bool> synced,
});
typedef $$UserStatsTableUpdateCompanionBuilder = UserStatsCompanion Function({
  Value<int> id,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastStudyDate,
  Value<int> dailyGoal,
  Value<DateTime> updatedAt,
  Value<bool> synced,
});

class $$UserStatsTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastStudyDate => $composableBuilder(
      column: $table.lastStudyDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyGoal => $composableBuilder(
      column: $table.dailyGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$UserStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastStudyDate => $composableBuilder(
      column: $table.lastStudyDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
      column: $table.dailyGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$UserStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => column);

  GeneratedColumn<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastStudyDate => $composableBuilder(
      column: $table.lastStudyDate, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$UserStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserStatsTable,
    UserStatRow,
    $$UserStatsTableFilterComposer,
    $$UserStatsTableOrderingComposer,
    $$UserStatsTableAnnotationComposer,
    $$UserStatsTableCreateCompanionBuilder,
    $$UserStatsTableUpdateCompanionBuilder,
    (UserStatRow, BaseReferences<_$AppDatabase, $UserStatsTable, UserStatRow>),
    UserStatRow,
    PrefetchHooks Function()> {
  $$UserStatsTableTableManager(_$AppDatabase db, $UserStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastStudyDate = const Value.absent(),
            Value<int> dailyGoal = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
          }) =>
              UserStatsCompanion(
            id: id,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastStudyDate: lastStudyDate,
            dailyGoal: dailyGoal,
            updatedAt: updatedAt,
            synced: synced,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastStudyDate = const Value.absent(),
            Value<int> dailyGoal = const Value.absent(),
            required DateTime updatedAt,
            Value<bool> synced = const Value.absent(),
          }) =>
              UserStatsCompanion.insert(
            id: id,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastStudyDate: lastStudyDate,
            dailyGoal: dailyGoal,
            updatedAt: updatedAt,
            synced: synced,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserStatsTable,
    UserStatRow,
    $$UserStatsTableFilterComposer,
    $$UserStatsTableOrderingComposer,
    $$UserStatsTableAnnotationComposer,
    $$UserStatsTableCreateCompanionBuilder,
    $$UserStatsTableUpdateCompanionBuilder,
    (UserStatRow, BaseReferences<_$AppDatabase, $UserStatsTable, UserStatRow>),
    UserStatRow,
    PrefetchHooks Function()>;
typedef $$DailyCountsTableCreateCompanionBuilder = DailyCountsCompanion
    Function({
  required String date,
  Value<int> count,
  required DateTime updatedAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$DailyCountsTableUpdateCompanionBuilder = DailyCountsCompanion
    Function({
  Value<String> date,
  Value<int> count,
  Value<DateTime> updatedAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$DailyCountsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyCountsTable> {
  $$DailyCountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$DailyCountsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyCountsTable> {
  $$DailyCountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$DailyCountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyCountsTable> {
  $$DailyCountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$DailyCountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyCountsTable,
    DailyCountRow,
    $$DailyCountsTableFilterComposer,
    $$DailyCountsTableOrderingComposer,
    $$DailyCountsTableAnnotationComposer,
    $$DailyCountsTableCreateCompanionBuilder,
    $$DailyCountsTableUpdateCompanionBuilder,
    (
      DailyCountRow,
      BaseReferences<_$AppDatabase, $DailyCountsTable, DailyCountRow>
    ),
    DailyCountRow,
    PrefetchHooks Function()> {
  $$DailyCountsTableTableManager(_$AppDatabase db, $DailyCountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyCountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyCountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyCountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyCountsCompanion(
            date: date,
            count: count,
            updatedAt: updatedAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            Value<int> count = const Value.absent(),
            required DateTime updatedAt,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyCountsCompanion.insert(
            date: date,
            count: count,
            updatedAt: updatedAt,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyCountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyCountsTable,
    DailyCountRow,
    $$DailyCountsTableFilterComposer,
    $$DailyCountsTableOrderingComposer,
    $$DailyCountsTableAnnotationComposer,
    $$DailyCountsTableCreateCompanionBuilder,
    $$DailyCountsTableUpdateCompanionBuilder,
    (
      DailyCountRow,
      BaseReferences<_$AppDatabase, $DailyCountsTable, DailyCountRow>
    ),
    DailyCountRow,
    PrefetchHooks Function()>;
typedef $$SyncMetaTableCreateCompanionBuilder = SyncMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SyncMetaTableUpdateCompanionBuilder = SyncMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetaTable,
    SyncMetaRow,
    $$SyncMetaTableFilterComposer,
    $$SyncMetaTableOrderingComposer,
    $$SyncMetaTableAnnotationComposer,
    $$SyncMetaTableCreateCompanionBuilder,
    $$SyncMetaTableUpdateCompanionBuilder,
    (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
    SyncMetaRow,
    PrefetchHooks Function()> {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetaCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetaCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetaTable,
    SyncMetaRow,
    $$SyncMetaTableFilterComposer,
    $$SyncMetaTableOrderingComposer,
    $$SyncMetaTableAnnotationComposer,
    $$SyncMetaTableCreateCompanionBuilder,
    $$SyncMetaTableUpdateCompanionBuilder,
    (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
    SyncMetaRow,
    PrefetchHooks Function()>;
typedef $$HanziStudiesZhTableCreateCompanionBuilder = HanziStudiesZhCompanion
    Function({
  required String id,
  required String radical,
  required String meaningKo,
  Value<String> pinyin,
  Value<int> tone,
  Value<String> description,
  Value<int> sortOrder,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HanziStudiesZhTableUpdateCompanionBuilder = HanziStudiesZhCompanion
    Function({
  Value<String> id,
  Value<String> radical,
  Value<String> meaningKo,
  Value<String> pinyin,
  Value<int> tone,
  Value<String> description,
  Value<int> sortOrder,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$HanziStudiesZhTableFilterComposer
    extends Composer<_$AppDatabase, $HanziStudiesZhTable> {
  $$HanziStudiesZhTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinyin => $composableBuilder(
      column: $table.pinyin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tone => $composableBuilder(
      column: $table.tone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HanziStudiesZhTableOrderingComposer
    extends Composer<_$AppDatabase, $HanziStudiesZhTable> {
  $$HanziStudiesZhTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinyin => $composableBuilder(
      column: $table.pinyin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tone => $composableBuilder(
      column: $table.tone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HanziStudiesZhTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanziStudiesZhTable> {
  $$HanziStudiesZhTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get radical =>
      $composableBuilder(column: $table.radical, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<int> get tone =>
      $composableBuilder(column: $table.tone, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HanziStudiesZhTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HanziStudiesZhTable,
    HanziStudyZhRow,
    $$HanziStudiesZhTableFilterComposer,
    $$HanziStudiesZhTableOrderingComposer,
    $$HanziStudiesZhTableAnnotationComposer,
    $$HanziStudiesZhTableCreateCompanionBuilder,
    $$HanziStudiesZhTableUpdateCompanionBuilder,
    (
      HanziStudyZhRow,
      BaseReferences<_$AppDatabase, $HanziStudiesZhTable, HanziStudyZhRow>
    ),
    HanziStudyZhRow,
    PrefetchHooks Function()> {
  $$HanziStudiesZhTableTableManager(
      _$AppDatabase db, $HanziStudiesZhTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanziStudiesZhTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanziStudiesZhTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanziStudiesZhTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> radical = const Value.absent(),
            Value<String> meaningKo = const Value.absent(),
            Value<String> pinyin = const Value.absent(),
            Value<int> tone = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HanziStudiesZhCompanion(
            id: id,
            radical: radical,
            meaningKo: meaningKo,
            pinyin: pinyin,
            tone: tone,
            description: description,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String radical,
            required String meaningKo,
            Value<String> pinyin = const Value.absent(),
            Value<int> tone = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HanziStudiesZhCompanion.insert(
            id: id,
            radical: radical,
            meaningKo: meaningKo,
            pinyin: pinyin,
            tone: tone,
            description: description,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HanziStudiesZhTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HanziStudiesZhTable,
    HanziStudyZhRow,
    $$HanziStudiesZhTableFilterComposer,
    $$HanziStudiesZhTableOrderingComposer,
    $$HanziStudiesZhTableAnnotationComposer,
    $$HanziStudiesZhTableCreateCompanionBuilder,
    $$HanziStudiesZhTableUpdateCompanionBuilder,
    (
      HanziStudyZhRow,
      BaseReferences<_$AppDatabase, $HanziStudiesZhTable, HanziStudyZhRow>
    ),
    HanziStudyZhRow,
    PrefetchHooks Function()>;
typedef $$HanziRelatedZhTableCreateCompanionBuilder = HanziRelatedZhCompanion
    Function({
  Value<int> id,
  required String studyId,
  required String character,
  Value<String> pinyin,
  Value<int> tone,
  required String meaningKo,
  required String relationType,
  Value<int> position,
  Value<String> note,
  required DateTime updatedAt,
});
typedef $$HanziRelatedZhTableUpdateCompanionBuilder = HanziRelatedZhCompanion
    Function({
  Value<int> id,
  Value<String> studyId,
  Value<String> character,
  Value<String> pinyin,
  Value<int> tone,
  Value<String> meaningKo,
  Value<String> relationType,
  Value<int> position,
  Value<String> note,
  Value<DateTime> updatedAt,
});

class $$HanziRelatedZhTableFilterComposer
    extends Composer<_$AppDatabase, $HanziRelatedZhTable> {
  $$HanziRelatedZhTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studyId => $composableBuilder(
      column: $table.studyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinyin => $composableBuilder(
      column: $table.pinyin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tone => $composableBuilder(
      column: $table.tone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HanziRelatedZhTableOrderingComposer
    extends Composer<_$AppDatabase, $HanziRelatedZhTable> {
  $$HanziRelatedZhTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studyId => $composableBuilder(
      column: $table.studyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinyin => $composableBuilder(
      column: $table.pinyin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tone => $composableBuilder(
      column: $table.tone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationType => $composableBuilder(
      column: $table.relationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HanziRelatedZhTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanziRelatedZhTable> {
  $$HanziRelatedZhTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studyId =>
      $composableBuilder(column: $table.studyId, builder: (column) => column);

  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<int> get tone =>
      $composableBuilder(column: $table.tone, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HanziRelatedZhTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HanziRelatedZhTable,
    HanziRelatedZhRow,
    $$HanziRelatedZhTableFilterComposer,
    $$HanziRelatedZhTableOrderingComposer,
    $$HanziRelatedZhTableAnnotationComposer,
    $$HanziRelatedZhTableCreateCompanionBuilder,
    $$HanziRelatedZhTableUpdateCompanionBuilder,
    (
      HanziRelatedZhRow,
      BaseReferences<_$AppDatabase, $HanziRelatedZhTable, HanziRelatedZhRow>
    ),
    HanziRelatedZhRow,
    PrefetchHooks Function()> {
  $$HanziRelatedZhTableTableManager(
      _$AppDatabase db, $HanziRelatedZhTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanziRelatedZhTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanziRelatedZhTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanziRelatedZhTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> studyId = const Value.absent(),
            Value<String> character = const Value.absent(),
            Value<String> pinyin = const Value.absent(),
            Value<int> tone = const Value.absent(),
            Value<String> meaningKo = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HanziRelatedZhCompanion(
            id: id,
            studyId: studyId,
            character: character,
            pinyin: pinyin,
            tone: tone,
            meaningKo: meaningKo,
            relationType: relationType,
            position: position,
            note: note,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String studyId,
            required String character,
            Value<String> pinyin = const Value.absent(),
            Value<int> tone = const Value.absent(),
            required String meaningKo,
            required String relationType,
            Value<int> position = const Value.absent(),
            Value<String> note = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              HanziRelatedZhCompanion.insert(
            id: id,
            studyId: studyId,
            character: character,
            pinyin: pinyin,
            tone: tone,
            meaningKo: meaningKo,
            relationType: relationType,
            position: position,
            note: note,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HanziRelatedZhTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HanziRelatedZhTable,
    HanziRelatedZhRow,
    $$HanziRelatedZhTableFilterComposer,
    $$HanziRelatedZhTableOrderingComposer,
    $$HanziRelatedZhTableAnnotationComposer,
    $$HanziRelatedZhTableCreateCompanionBuilder,
    $$HanziRelatedZhTableUpdateCompanionBuilder,
    (
      HanziRelatedZhRow,
      BaseReferences<_$AppDatabase, $HanziRelatedZhTable, HanziRelatedZhRow>
    ),
    HanziRelatedZhRow,
    PrefetchHooks Function()>;
typedef $$HanziStudiesJpTableCreateCompanionBuilder = HanziStudiesJpCompanion
    Function({
  required String id,
  required String radical,
  required String meaningKo,
  Value<String> onyomi,
  Value<String> kunyomi,
  Value<String> description,
  Value<int> sortOrder,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HanziStudiesJpTableUpdateCompanionBuilder = HanziStudiesJpCompanion
    Function({
  Value<String> id,
  Value<String> radical,
  Value<String> meaningKo,
  Value<String> onyomi,
  Value<String> kunyomi,
  Value<String> description,
  Value<int> sortOrder,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$HanziStudiesJpTableFilterComposer
    extends Composer<_$AppDatabase, $HanziStudiesJpTable> {
  $$HanziStudiesJpTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get onyomi => $composableBuilder(
      column: $table.onyomi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kunyomi => $composableBuilder(
      column: $table.kunyomi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HanziStudiesJpTableOrderingComposer
    extends Composer<_$AppDatabase, $HanziStudiesJpTable> {
  $$HanziStudiesJpTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get onyomi => $composableBuilder(
      column: $table.onyomi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kunyomi => $composableBuilder(
      column: $table.kunyomi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HanziStudiesJpTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanziStudiesJpTable> {
  $$HanziStudiesJpTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get radical =>
      $composableBuilder(column: $table.radical, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get onyomi =>
      $composableBuilder(column: $table.onyomi, builder: (column) => column);

  GeneratedColumn<String> get kunyomi =>
      $composableBuilder(column: $table.kunyomi, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HanziStudiesJpTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HanziStudiesJpTable,
    HanziStudyJpRow,
    $$HanziStudiesJpTableFilterComposer,
    $$HanziStudiesJpTableOrderingComposer,
    $$HanziStudiesJpTableAnnotationComposer,
    $$HanziStudiesJpTableCreateCompanionBuilder,
    $$HanziStudiesJpTableUpdateCompanionBuilder,
    (
      HanziStudyJpRow,
      BaseReferences<_$AppDatabase, $HanziStudiesJpTable, HanziStudyJpRow>
    ),
    HanziStudyJpRow,
    PrefetchHooks Function()> {
  $$HanziStudiesJpTableTableManager(
      _$AppDatabase db, $HanziStudiesJpTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanziStudiesJpTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanziStudiesJpTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanziStudiesJpTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> radical = const Value.absent(),
            Value<String> meaningKo = const Value.absent(),
            Value<String> onyomi = const Value.absent(),
            Value<String> kunyomi = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HanziStudiesJpCompanion(
            id: id,
            radical: radical,
            meaningKo: meaningKo,
            onyomi: onyomi,
            kunyomi: kunyomi,
            description: description,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String radical,
            required String meaningKo,
            Value<String> onyomi = const Value.absent(),
            Value<String> kunyomi = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HanziStudiesJpCompanion.insert(
            id: id,
            radical: radical,
            meaningKo: meaningKo,
            onyomi: onyomi,
            kunyomi: kunyomi,
            description: description,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HanziStudiesJpTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HanziStudiesJpTable,
    HanziStudyJpRow,
    $$HanziStudiesJpTableFilterComposer,
    $$HanziStudiesJpTableOrderingComposer,
    $$HanziStudiesJpTableAnnotationComposer,
    $$HanziStudiesJpTableCreateCompanionBuilder,
    $$HanziStudiesJpTableUpdateCompanionBuilder,
    (
      HanziStudyJpRow,
      BaseReferences<_$AppDatabase, $HanziStudiesJpTable, HanziStudyJpRow>
    ),
    HanziStudyJpRow,
    PrefetchHooks Function()>;
typedef $$HanziRelatedJpTableCreateCompanionBuilder = HanziRelatedJpCompanion
    Function({
  Value<int> id,
  required String studyId,
  required String character,
  Value<String> onyomi,
  Value<String> kunyomi,
  required String meaningKo,
  required String relationType,
  Value<int> position,
  Value<String> note,
  required DateTime updatedAt,
});
typedef $$HanziRelatedJpTableUpdateCompanionBuilder = HanziRelatedJpCompanion
    Function({
  Value<int> id,
  Value<String> studyId,
  Value<String> character,
  Value<String> onyomi,
  Value<String> kunyomi,
  Value<String> meaningKo,
  Value<String> relationType,
  Value<int> position,
  Value<String> note,
  Value<DateTime> updatedAt,
});

class $$HanziRelatedJpTableFilterComposer
    extends Composer<_$AppDatabase, $HanziRelatedJpTable> {
  $$HanziRelatedJpTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studyId => $composableBuilder(
      column: $table.studyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get onyomi => $composableBuilder(
      column: $table.onyomi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kunyomi => $composableBuilder(
      column: $table.kunyomi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HanziRelatedJpTableOrderingComposer
    extends Composer<_$AppDatabase, $HanziRelatedJpTable> {
  $$HanziRelatedJpTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studyId => $composableBuilder(
      column: $table.studyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get onyomi => $composableBuilder(
      column: $table.onyomi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kunyomi => $composableBuilder(
      column: $table.kunyomi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationType => $composableBuilder(
      column: $table.relationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HanziRelatedJpTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanziRelatedJpTable> {
  $$HanziRelatedJpTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studyId =>
      $composableBuilder(column: $table.studyId, builder: (column) => column);

  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<String> get onyomi =>
      $composableBuilder(column: $table.onyomi, builder: (column) => column);

  GeneratedColumn<String> get kunyomi =>
      $composableBuilder(column: $table.kunyomi, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
      column: $table.relationType, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HanziRelatedJpTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HanziRelatedJpTable,
    HanziRelatedJpRow,
    $$HanziRelatedJpTableFilterComposer,
    $$HanziRelatedJpTableOrderingComposer,
    $$HanziRelatedJpTableAnnotationComposer,
    $$HanziRelatedJpTableCreateCompanionBuilder,
    $$HanziRelatedJpTableUpdateCompanionBuilder,
    (
      HanziRelatedJpRow,
      BaseReferences<_$AppDatabase, $HanziRelatedJpTable, HanziRelatedJpRow>
    ),
    HanziRelatedJpRow,
    PrefetchHooks Function()> {
  $$HanziRelatedJpTableTableManager(
      _$AppDatabase db, $HanziRelatedJpTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanziRelatedJpTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanziRelatedJpTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanziRelatedJpTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> studyId = const Value.absent(),
            Value<String> character = const Value.absent(),
            Value<String> onyomi = const Value.absent(),
            Value<String> kunyomi = const Value.absent(),
            Value<String> meaningKo = const Value.absent(),
            Value<String> relationType = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HanziRelatedJpCompanion(
            id: id,
            studyId: studyId,
            character: character,
            onyomi: onyomi,
            kunyomi: kunyomi,
            meaningKo: meaningKo,
            relationType: relationType,
            position: position,
            note: note,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String studyId,
            required String character,
            Value<String> onyomi = const Value.absent(),
            Value<String> kunyomi = const Value.absent(),
            required String meaningKo,
            required String relationType,
            Value<int> position = const Value.absent(),
            Value<String> note = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              HanziRelatedJpCompanion.insert(
            id: id,
            studyId: studyId,
            character: character,
            onyomi: onyomi,
            kunyomi: kunyomi,
            meaningKo: meaningKo,
            relationType: relationType,
            position: position,
            note: note,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HanziRelatedJpTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HanziRelatedJpTable,
    HanziRelatedJpRow,
    $$HanziRelatedJpTableFilterComposer,
    $$HanziRelatedJpTableOrderingComposer,
    $$HanziRelatedJpTableAnnotationComposer,
    $$HanziRelatedJpTableCreateCompanionBuilder,
    $$HanziRelatedJpTableUpdateCompanionBuilder,
    (
      HanziRelatedJpRow,
      BaseReferences<_$AppDatabase, $HanziRelatedJpTable, HanziRelatedJpRow>
    ),
    HanziRelatedJpRow,
    PrefetchHooks Function()>;
typedef $$HanjaMasterTableCreateCompanionBuilder = HanjaMasterCompanion
    Function({
  required String korHanja,
  Value<String> korSound,
  Value<String> korMeaning,
  Value<String> korLevel,
  Value<String> radical,
  Value<int> strokeEx,
  Value<int> strokeTotal,
  Value<String?> zhSimplified,
  Value<String?> zhTraditional,
  Value<String?> jaKanji,
  Value<int> priority,
  Value<int?> hskLevel,
  Value<String?> jlptLevel,
  Value<int?> importance,
  Value<String> noteAdmin,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HanjaMasterTableUpdateCompanionBuilder = HanjaMasterCompanion
    Function({
  Value<String> korHanja,
  Value<String> korSound,
  Value<String> korMeaning,
  Value<String> korLevel,
  Value<String> radical,
  Value<int> strokeEx,
  Value<int> strokeTotal,
  Value<String?> zhSimplified,
  Value<String?> zhTraditional,
  Value<String?> jaKanji,
  Value<int> priority,
  Value<int?> hskLevel,
  Value<String?> jlptLevel,
  Value<int?> importance,
  Value<String> noteAdmin,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$HanjaMasterTableFilterComposer
    extends Composer<_$AppDatabase, $HanjaMasterTable> {
  $$HanjaMasterTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get korHanja => $composableBuilder(
      column: $table.korHanja, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get korSound => $composableBuilder(
      column: $table.korSound, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get korMeaning => $composableBuilder(
      column: $table.korMeaning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get korLevel => $composableBuilder(
      column: $table.korLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get strokeEx => $composableBuilder(
      column: $table.strokeEx, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get strokeTotal => $composableBuilder(
      column: $table.strokeTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zhSimplified => $composableBuilder(
      column: $table.zhSimplified, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zhTraditional => $composableBuilder(
      column: $table.zhTraditional, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jaKanji => $composableBuilder(
      column: $table.jaKanji, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteAdmin => $composableBuilder(
      column: $table.noteAdmin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HanjaMasterTableOrderingComposer
    extends Composer<_$AppDatabase, $HanjaMasterTable> {
  $$HanjaMasterTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get korHanja => $composableBuilder(
      column: $table.korHanja, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get korSound => $composableBuilder(
      column: $table.korSound, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get korMeaning => $composableBuilder(
      column: $table.korMeaning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get korLevel => $composableBuilder(
      column: $table.korLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get radical => $composableBuilder(
      column: $table.radical, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get strokeEx => $composableBuilder(
      column: $table.strokeEx, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get strokeTotal => $composableBuilder(
      column: $table.strokeTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zhSimplified => $composableBuilder(
      column: $table.zhSimplified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zhTraditional => $composableBuilder(
      column: $table.zhTraditional,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jaKanji => $composableBuilder(
      column: $table.jaKanji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
      column: $table.jlptLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteAdmin => $composableBuilder(
      column: $table.noteAdmin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HanjaMasterTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanjaMasterTable> {
  $$HanjaMasterTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get korHanja =>
      $composableBuilder(column: $table.korHanja, builder: (column) => column);

  GeneratedColumn<String> get korSound =>
      $composableBuilder(column: $table.korSound, builder: (column) => column);

  GeneratedColumn<String> get korMeaning => $composableBuilder(
      column: $table.korMeaning, builder: (column) => column);

  GeneratedColumn<String> get korLevel =>
      $composableBuilder(column: $table.korLevel, builder: (column) => column);

  GeneratedColumn<String> get radical =>
      $composableBuilder(column: $table.radical, builder: (column) => column);

  GeneratedColumn<int> get strokeEx =>
      $composableBuilder(column: $table.strokeEx, builder: (column) => column);

  GeneratedColumn<int> get strokeTotal => $composableBuilder(
      column: $table.strokeTotal, builder: (column) => column);

  GeneratedColumn<String> get zhSimplified => $composableBuilder(
      column: $table.zhSimplified, builder: (column) => column);

  GeneratedColumn<String> get zhTraditional => $composableBuilder(
      column: $table.zhTraditional, builder: (column) => column);

  GeneratedColumn<String> get jaKanji =>
      $composableBuilder(column: $table.jaKanji, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get hskLevel =>
      $composableBuilder(column: $table.hskLevel, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumn<int> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => column);

  GeneratedColumn<String> get noteAdmin =>
      $composableBuilder(column: $table.noteAdmin, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HanjaMasterTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HanjaMasterTable,
    HanjaMasterRow,
    $$HanjaMasterTableFilterComposer,
    $$HanjaMasterTableOrderingComposer,
    $$HanjaMasterTableAnnotationComposer,
    $$HanjaMasterTableCreateCompanionBuilder,
    $$HanjaMasterTableUpdateCompanionBuilder,
    (
      HanjaMasterRow,
      BaseReferences<_$AppDatabase, $HanjaMasterTable, HanjaMasterRow>
    ),
    HanjaMasterRow,
    PrefetchHooks Function()> {
  $$HanjaMasterTableTableManager(_$AppDatabase db, $HanjaMasterTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanjaMasterTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanjaMasterTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanjaMasterTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> korHanja = const Value.absent(),
            Value<String> korSound = const Value.absent(),
            Value<String> korMeaning = const Value.absent(),
            Value<String> korLevel = const Value.absent(),
            Value<String> radical = const Value.absent(),
            Value<int> strokeEx = const Value.absent(),
            Value<int> strokeTotal = const Value.absent(),
            Value<String?> zhSimplified = const Value.absent(),
            Value<String?> zhTraditional = const Value.absent(),
            Value<String?> jaKanji = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int?> hskLevel = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
            Value<int?> importance = const Value.absent(),
            Value<String> noteAdmin = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HanjaMasterCompanion(
            korHanja: korHanja,
            korSound: korSound,
            korMeaning: korMeaning,
            korLevel: korLevel,
            radical: radical,
            strokeEx: strokeEx,
            strokeTotal: strokeTotal,
            zhSimplified: zhSimplified,
            zhTraditional: zhTraditional,
            jaKanji: jaKanji,
            priority: priority,
            hskLevel: hskLevel,
            jlptLevel: jlptLevel,
            importance: importance,
            noteAdmin: noteAdmin,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String korHanja,
            Value<String> korSound = const Value.absent(),
            Value<String> korMeaning = const Value.absent(),
            Value<String> korLevel = const Value.absent(),
            Value<String> radical = const Value.absent(),
            Value<int> strokeEx = const Value.absent(),
            Value<int> strokeTotal = const Value.absent(),
            Value<String?> zhSimplified = const Value.absent(),
            Value<String?> zhTraditional = const Value.absent(),
            Value<String?> jaKanji = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int?> hskLevel = const Value.absent(),
            Value<String?> jlptLevel = const Value.absent(),
            Value<int?> importance = const Value.absent(),
            Value<String> noteAdmin = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HanjaMasterCompanion.insert(
            korHanja: korHanja,
            korSound: korSound,
            korMeaning: korMeaning,
            korLevel: korLevel,
            radical: radical,
            strokeEx: strokeEx,
            strokeTotal: strokeTotal,
            zhSimplified: zhSimplified,
            zhTraditional: zhTraditional,
            jaKanji: jaKanji,
            priority: priority,
            hskLevel: hskLevel,
            jlptLevel: jlptLevel,
            importance: importance,
            noteAdmin: noteAdmin,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HanjaMasterTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HanjaMasterTable,
    HanjaMasterRow,
    $$HanjaMasterTableFilterComposer,
    $$HanjaMasterTableOrderingComposer,
    $$HanjaMasterTableAnnotationComposer,
    $$HanjaMasterTableCreateCompanionBuilder,
    $$HanjaMasterTableUpdateCompanionBuilder,
    (
      HanjaMasterRow,
      BaseReferences<_$AppDatabase, $HanjaMasterTable, HanjaMasterRow>
    ),
    HanjaMasterRow,
    PrefetchHooks Function()>;
typedef $$HanjaRelatedTableCreateCompanionBuilder = HanjaRelatedCompanion
    Function({
  Value<int> id,
  required String source,
  required String related,
  required String relation,
  Value<int> position,
  Value<String> note,
  Value<String> addedBy,
  required DateTime updatedAt,
});
typedef $$HanjaRelatedTableUpdateCompanionBuilder = HanjaRelatedCompanion
    Function({
  Value<int> id,
  Value<String> source,
  Value<String> related,
  Value<String> relation,
  Value<int> position,
  Value<String> note,
  Value<String> addedBy,
  Value<DateTime> updatedAt,
});

class $$HanjaRelatedTableFilterComposer
    extends Composer<_$AppDatabase, $HanjaRelatedTable> {
  $$HanjaRelatedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get related => $composableBuilder(
      column: $table.related, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addedBy => $composableBuilder(
      column: $table.addedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HanjaRelatedTableOrderingComposer
    extends Composer<_$AppDatabase, $HanjaRelatedTable> {
  $$HanjaRelatedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get related => $composableBuilder(
      column: $table.related, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addedBy => $composableBuilder(
      column: $table.addedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HanjaRelatedTableAnnotationComposer
    extends Composer<_$AppDatabase, $HanjaRelatedTable> {
  $$HanjaRelatedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get related =>
      $composableBuilder(column: $table.related, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get addedBy =>
      $composableBuilder(column: $table.addedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HanjaRelatedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HanjaRelatedTable,
    HanjaRelatedRow,
    $$HanjaRelatedTableFilterComposer,
    $$HanjaRelatedTableOrderingComposer,
    $$HanjaRelatedTableAnnotationComposer,
    $$HanjaRelatedTableCreateCompanionBuilder,
    $$HanjaRelatedTableUpdateCompanionBuilder,
    (
      HanjaRelatedRow,
      BaseReferences<_$AppDatabase, $HanjaRelatedTable, HanjaRelatedRow>
    ),
    HanjaRelatedRow,
    PrefetchHooks Function()> {
  $$HanjaRelatedTableTableManager(_$AppDatabase db, $HanjaRelatedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HanjaRelatedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HanjaRelatedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HanjaRelatedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> related = const Value.absent(),
            Value<String> relation = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<String> addedBy = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HanjaRelatedCompanion(
            id: id,
            source: source,
            related: related,
            relation: relation,
            position: position,
            note: note,
            addedBy: addedBy,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String source,
            required String related,
            required String relation,
            Value<int> position = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<String> addedBy = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              HanjaRelatedCompanion.insert(
            id: id,
            source: source,
            related: related,
            relation: relation,
            position: position,
            note: note,
            addedBy: addedBy,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HanjaRelatedTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HanjaRelatedTable,
    HanjaRelatedRow,
    $$HanjaRelatedTableFilterComposer,
    $$HanjaRelatedTableOrderingComposer,
    $$HanjaRelatedTableAnnotationComposer,
    $$HanjaRelatedTableCreateCompanionBuilder,
    $$HanjaRelatedTableUpdateCompanionBuilder,
    (
      HanjaRelatedRow,
      BaseReferences<_$AppDatabase, $HanjaRelatedTable, HanjaRelatedRow>
    ),
    HanjaRelatedRow,
    PrefetchHooks Function()>;
typedef $$EtymonTableCreateCompanionBuilder = EtymonCompanion Function({
  required String id,
  required String sourceLang,
  required String root,
  required String meaningKo,
  Value<String> meaningEn,
  Value<String> notes,
  Value<int> priority,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$EtymonTableUpdateCompanionBuilder = EtymonCompanion Function({
  Value<String> id,
  Value<String> sourceLang,
  Value<String> root,
  Value<String> meaningKo,
  Value<String> meaningEn,
  Value<String> notes,
  Value<int> priority,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$EtymonTableFilterComposer
    extends Composer<_$AppDatabase, $EtymonTable> {
  $$EtymonTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get root => $composableBuilder(
      column: $table.root, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$EtymonTableOrderingComposer
    extends Composer<_$AppDatabase, $EtymonTable> {
  $$EtymonTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get root => $composableBuilder(
      column: $table.root, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningKo => $composableBuilder(
      column: $table.meaningKo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningEn => $composableBuilder(
      column: $table.meaningEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$EtymonTableAnnotationComposer
    extends Composer<_$AppDatabase, $EtymonTable> {
  $$EtymonTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceLang => $composableBuilder(
      column: $table.sourceLang, builder: (column) => column);

  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);

  GeneratedColumn<String> get meaningKo =>
      $composableBuilder(column: $table.meaningKo, builder: (column) => column);

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EtymonTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EtymonTable,
    EtymonRow,
    $$EtymonTableFilterComposer,
    $$EtymonTableOrderingComposer,
    $$EtymonTableAnnotationComposer,
    $$EtymonTableCreateCompanionBuilder,
    $$EtymonTableUpdateCompanionBuilder,
    (EtymonRow, BaseReferences<_$AppDatabase, $EtymonTable, EtymonRow>),
    EtymonRow,
    PrefetchHooks Function()> {
  $$EtymonTableTableManager(_$AppDatabase db, $EtymonTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EtymonTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EtymonTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EtymonTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceLang = const Value.absent(),
            Value<String> root = const Value.absent(),
            Value<String> meaningKo = const Value.absent(),
            Value<String> meaningEn = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EtymonCompanion(
            id: id,
            sourceLang: sourceLang,
            root: root,
            meaningKo: meaningKo,
            meaningEn: meaningEn,
            notes: notes,
            priority: priority,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceLang,
            required String root,
            required String meaningKo,
            Value<String> meaningEn = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> priority = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EtymonCompanion.insert(
            id: id,
            sourceLang: sourceLang,
            root: root,
            meaningKo: meaningKo,
            meaningEn: meaningEn,
            notes: notes,
            priority: priority,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EtymonTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EtymonTable,
    EtymonRow,
    $$EtymonTableFilterComposer,
    $$EtymonTableOrderingComposer,
    $$EtymonTableAnnotationComposer,
    $$EtymonTableCreateCompanionBuilder,
    $$EtymonTableUpdateCompanionBuilder,
    (EtymonRow, BaseReferences<_$AppDatabase, $EtymonTable, EtymonRow>),
    EtymonRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db, _db.userStats);
  $$DailyCountsTableTableManager get dailyCounts =>
      $$DailyCountsTableTableManager(_db, _db.dailyCounts);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
  $$HanziStudiesZhTableTableManager get hanziStudiesZh =>
      $$HanziStudiesZhTableTableManager(_db, _db.hanziStudiesZh);
  $$HanziRelatedZhTableTableManager get hanziRelatedZh =>
      $$HanziRelatedZhTableTableManager(_db, _db.hanziRelatedZh);
  $$HanziStudiesJpTableTableManager get hanziStudiesJp =>
      $$HanziStudiesJpTableTableManager(_db, _db.hanziStudiesJp);
  $$HanziRelatedJpTableTableManager get hanziRelatedJp =>
      $$HanziRelatedJpTableTableManager(_db, _db.hanziRelatedJp);
  $$HanjaMasterTableTableManager get hanjaMaster =>
      $$HanjaMasterTableTableManager(_db, _db.hanjaMaster);
  $$HanjaRelatedTableTableManager get hanjaRelated =>
      $$HanjaRelatedTableTableManager(_db, _db.hanjaRelated);
  $$EtymonTableTableManager get etymon =>
      $$EtymonTableTableManager(_db, _db.etymon);
}
