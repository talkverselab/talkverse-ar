import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../config/app_config.dart';

part 'app_database.g.dart';

// -------------------- Tables --------------------

/// Master content: word / sentence / phrase. Mirror of Supabase `items`.
/// Updated only by sync (never written to by UI code).
@DataClassName('Item')
class Items extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get targetText => text()();
  TextColumn get korean => text()();
  TextColumn get romanization => text().withDefault(const Constant(''))();
  /// 베트남어 남부 방언 변형 (vi 전용). NULL이면 base targetText 사용.
  /// 사용자가 메인화면 toggle로 region='south' 선택 시, 남부 컬럼이 있으면 우선.
  /// 다른 언어는 항상 NULL.
  TextColumn get targetSouth => text().nullable()();
  TextColumn get koreanSouth => text().nullable()();
  TextColumn get romanizationSouth => text().nullable()();
  /// 스페인어 스페인(이베리아) 발음·어휘 변형 (es 전용). NULL이면 base 사용.
  /// 우리 dialogue는 라틴(멕시코) 기반이므로 base = latam, variant = spain.
  /// 사용자가 메인화면 toggle로 region='spain' 선택 시 우선 표시.
  TextColumn get targetSpain => text().nullable()();
  TextColumn get koreanSpain => text().nullable()();
  TextColumn get romanizationSpain => text().nullable()();
  TextColumn get category => text().withDefault(const Constant(''))();
  IntColumn get course => integer().withDefault(const Constant(1))();
  /// Stored as comma-joined string in SQLite (Drift has no native list type).
  TextColumn get tagsCsv => text().withDefault(const Constant(''))();
  /// Learner-facing notes: grammar, culture, usage examples.
  TextColumn get notes => text().withDefault(const Constant(''))();
  /// Dev-only memo. Never shown in UI; useful for authoring/editing.
  TextColumn get comment => text().withDefault(const Constant(''))();
  /// CSV of related target_text strings (max 4). Each token, when matched
  /// against another item's `targetPlain`, becomes a tappable mini-card on
  /// the flashcard. Empty = no related-words row.
  TextColumn get relatedCsv => text().withDefault(const Constant(''))();
  /// Unified root/etymon refs. CSV of ids: 'han:愛' (hanja_master) or
  /// 'lat:am' / 'ar:k-t-b' (etymon). Replaces the old item_etymon table.
  TextColumn get rootRefs =>
      text().named('root_refs').withDefault(const Constant(''))();
  /// Dialogue speaker — 'A' or 'B' (or '' for non-dialogue items).
  /// Items with the same `category` AND non-empty `speaker` form a
  /// single dialogue script displayed in ConversationScreen.
  TextColumn get speaker => text().withDefault(const Constant(''))();
  /// Order of this turn within the dialogue (1, 2, 3, ...). 0 = non-dialogue.
  IntColumn get turnOrder => integer().withDefault(const Constant(0))();
  /// Free-text scenario description shown above the dialogue
  /// (e.g. "카페에서 우연한 만남"). Empty for non-dialogue items.
  TextColumn get scenario => text().withDefault(const Constant(''))();
  /// Vocabulary tier (v15): 'beginner' / 'intermediate' / 'advanced'.
  /// Auto-assigned by freq-based classifier. NULL = not yet classified.
  TextColumn get tier => text().nullable()();
  /// Learner-facing dialogue order (v15). Curated interest-curve order
  /// within (language_code, course). Raw d-number ordering may differ.
  IntColumn get dialogueOrder =>
      integer().named('dialogue_order').withDefault(const Constant(0))();
  /// Vocab hints (v16): JSON array of {"w":"단어","ko":"뜻"} for off-freq
  /// words and proper nouns. Rendered as chips on flashcard front/back.
  TextColumn get vocabHints =>
      text().named('vocab_hints').nullable()();
  /// v17: politeness 표지 (vi). true = ạ 사용 polite, false = 반말.
  /// 알고리즘 변환 X — row 자체에 polite/casual 박혀 있음.
  BoolColumn get isPolite =>
      boolean().named('is_polite').withDefault(const Constant(false))();
  /// v17: 회화 적용 시나리오 lock (vi). 1~5 = 시나리오 ID, NULL = universal.
  /// NULL 이 default — 모든 시나리오 사용자에게 노출. 시나리오 lock 회화는
  /// 일치하는 사용자에게만 노출하는 데 사용.
  IntColumn get applicableScenario =>
      integer().named('applicable_scenario').nullable()();
  /// v18: morph_tags (ru 전용, Natasha 자동 생성). JSON 배열 of token entries:
  /// [{"t":"красивую","c":"fem","ph":"ого"?}, ...]
  /// c = masc/fem/neut/v1/v2/irr | ph = 발음법칙 갈색 어미. 다른 언어는 NULL.
  TextColumn get morphTags =>
      text().named('morph_tags').nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Per-item learning state. Mirror of Supabase `user_progress`.
@DataClassName('UserProgressRow')
class UserProgress extends Table {
  TextColumn get itemId => text()();
  BoolColumn get isKnown => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  /// Forgetting-curve stage: 0 (new) → 1 (+1h) → 2 (+1d) → 3 (+1w) →
  /// 4 (+1m) → 5 (mastered). "알아요" increments; "몰라요" resets to 0.
  IntColumn get reviewScore => integer().withDefault(const Constant(0))();
  /// When this item becomes due again. Null = already due (never scheduled).
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {itemId};
}

/// One row. Mirror of Supabase `user_stats`.
@DataClassName('UserStatRow')
class UserStats extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastStudyDate => dateTime().nullable()();
  IntColumn get dailyGoal => integer().withDefault(const Constant(10))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Daily study activity count. Mirror of Supabase `daily_counts`.
@DataClassName('DailyCountRow')
class DailyCounts extends Table {
  TextColumn get date => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {date};
}

/// Single-row metadata (sync watermarks, current user id, etc.).
@DataClassName('SyncMetaRow')
class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// -------------------- Hanzi: Chinese (zh) --------------------

/// Center "radical" of a Chinese hanzi study. Mirror of `hanzi_studies_zh`.
@DataClassName('HanziStudyZhRow')
class HanziStudiesZh extends Table {
  TextColumn get id => text()();
  TextColumn get radical => text()();
  TextColumn get meaningKo => text()();
  TextColumn get pinyin => text().withDefault(const Constant(''))();
  IntColumn get tone => integer().withDefault(const Constant(0))();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Related chars for a Chinese hanzi study. Mirror of `hanzi_related_zh`.
@DataClassName('HanziRelatedZhRow')
class HanziRelatedZh extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get studyId => text()();
  TextColumn get character => text()();
  TextColumn get pinyin => text().withDefault(const Constant(''))();
  IntColumn get tone => integer().withDefault(const Constant(0))();
  TextColumn get meaningKo => text()();
  TextColumn get relationType => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
}

// -------------------- Hanzi: Japanese (jp) --------------------

/// Center character of a Japanese kanji study. Mirror of `hanzi_studies_jp`.
/// Readings differ from Chinese: onyomi (음독) / kunyomi (훈독).
@DataClassName('HanziStudyJpRow')
class HanziStudiesJp extends Table {
  TextColumn get id => text()();
  TextColumn get radical => text()();
  TextColumn get meaningKo => text()();
  TextColumn get onyomi => text().withDefault(const Constant(''))();
  TextColumn get kunyomi => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Related chars for a Japanese kanji study. Mirror of `hanzi_related_jp`.
@DataClassName('HanziRelatedJpRow')
class HanziRelatedJp extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get studyId => text()();
  TextColumn get character => text()();
  TextColumn get onyomi => text().withDefault(const Constant(''))();
  TextColumn get kunyomi => text().withDefault(const Constant(''))();
  TextColumn get meaningKo => text()();
  TextColumn get relationType => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
}

// -------------------- Hanja Master (KR/CN/TW/JP unified) --------------------

/// 한국 한자 5,978자 기준 통합 한자 마스터. Mirror of `hanja_master`.
/// kor_hanja 가 PK. zh_simplified / ja_kanji 등은 다중 스크립트 매핑용.
/// importance / note_admin 은 admin UI 입력용 큐레이션.
@DataClassName('HanjaMasterRow')
class HanjaMaster extends Table {
  TextColumn get korHanja => text().named('kor_hanja')();
  TextColumn get korSound =>
      text().named('kor_sound').withDefault(const Constant(''))();
  TextColumn get korMeaning =>
      text().named('kor_meaning').withDefault(const Constant(''))();
  TextColumn get korLevel =>
      text().named('kor_level').withDefault(const Constant(''))();
  TextColumn get radical => text().withDefault(const Constant(''))();
  IntColumn get strokeEx =>
      integer().named('stroke_ex').withDefault(const Constant(0))();
  IntColumn get strokeTotal =>
      integer().named('stroke_total').withDefault(const Constant(0))();
  TextColumn get zhSimplified => text().named('zh_simplified').nullable()();
  TextColumn get zhTraditional => text().named('zh_traditional').nullable()();
  TextColumn get jaKanji => text().named('ja_kanji').nullable()();
  IntColumn get priority => integer().withDefault(const Constant(9))();
  IntColumn get hskLevel => integer().named('hsk_level').nullable()();
  TextColumn get jlptLevel => text().named('jlpt_level').nullable()();
  IntColumn get importance => integer().nullable()(); // 1~5, admin 입력
  TextColumn get noteAdmin =>
      text().named('note_admin').withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {korHanja};
}

/// 한자 간 연관 매핑. relation = 'radical' / 'phonetic' / 'semantic'.
/// 부수(자동) + 음(사용자 큐레이션) + 의미(확장용).
@DataClassName('HanjaRelatedRow')
class HanjaRelated extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get source => text()();
  TextColumn get related => text()();
  TextColumn get relation => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get addedBy =>
      text().named('added_by').withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
}

// -------------------- Etymon (Latin/Greek/Germanic/Arabic 어근) --------------------

/// 비-CJK 어근 카탈로그. id 형식: 'lat:spec', 'gr:bio', 'ar:k-t-b'.
@DataClassName('EtymonRow')
class Etymon extends Table {
  TextColumn get id => text()();
  TextColumn get sourceLang => text().named('source_lang')();
  TextColumn get root => text()();
  TextColumn get meaningKo => text().named('meaning_ko')();
  TextColumn get meaningEn =>
      text().named('meaning_en').withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get priority => integer().withDefault(const Constant(9))();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// -------------------- Database --------------------

@DriftDatabase(tables: [
  Items,
  UserProgress,
  UserStats,
  DailyCounts,
  SyncMeta,
  HanziStudiesZh,
  HanziRelatedZh,
  HanziStudiesJp,
  HanziRelatedJp,
  HanjaMaster,
  HanjaRelated,
  Etymon,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 18;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2 added the legacy single hanzi_studies table.
            // We skip its creation here — v4 drops it anyway.
          }
          if (from < 3) {
            await customStatement(
                'ALTER TABLE items RENAME COLUMN level TO course');
          }
          if (from < 4) {
            await customStatement(
                'ALTER TABLE items RENAME COLUMN hint TO notes');
            await customStatement('DROP TABLE IF EXISTS hanzi_related');
            await customStatement('DROP TABLE IF EXISTS hanzi_studies');
            await m.createTable(hanziStudiesZh);
            await m.createTable(hanziRelatedZh);
            await m.createTable(hanziStudiesJp);
            await m.createTable(hanziRelatedJp);
          }
          if (from < 5) {
            // v5 adds items.comment — dev-only memo column.
            await customStatement(
                "ALTER TABLE items ADD COLUMN comment TEXT NOT NULL DEFAULT ''");
          }
          if (from < 6) {
            // v6 adds user_progress.next_review_at for the forgetting-curve
            // schedule. Nullable — pre-existing rows count as due now.
            await customStatement(
                "ALTER TABLE user_progress ADD COLUMN next_review_at DATETIME");
          }
          if (from < 7) {
            // v7 adds items.related_csv — comma-separated target_text strings
            // for the "관련단어" mini-card row at the bottom of the flashcard.
            await customStatement(
                "ALTER TABLE items ADD COLUMN related_csv TEXT NOT NULL DEFAULT ''");
          }
          if (from < 8) {
            // v8 adds dialogue grouping: speaker (A/B), turn_order, scenario.
            // Lets ConversationScreen render category as a chat script.
            await customStatement(
                "ALTER TABLE items ADD COLUMN speaker TEXT NOT NULL DEFAULT ''");
            await customStatement(
                "ALTER TABLE items ADD COLUMN turn_order INTEGER NOT NULL DEFAULT 0");
            await customStatement(
                "ALTER TABLE items ADD COLUMN scenario TEXT NOT NULL DEFAULT ''");
          }
          if (from < 9) {
            // v9 adds the unified hanja_master table (5,978 Korean hanja with
            // multi-script + JLPT/HSK/priority columns).
            await m.createTable(hanjaMaster);
          }
          if (from < 10) {
            // v10 adds importance/note_admin to hanja_master + new
            // hanja_related table for admin-curated 부수/음 매핑.
            await customStatement(
                'ALTER TABLE hanja_master ADD COLUMN importance INTEGER');
            await customStatement(
                "ALTER TABLE hanja_master ADD COLUMN note_admin TEXT NOT NULL DEFAULT ''");
            await m.createTable(hanjaRelated);
          }
          if (from < 11) {
            // v11 adds etymon (Latin/Greek/Germanic/Arabic root catalog).
            // item_etymon (N:N) also existed here but is dropped in v12.
            await m.createTable(etymon);
          }
          if (from < 12) {
            // v12 collapses item_etymon N:N into items.root_refs (CSV of
            // root ids, e.g. 'han:愛' or 'lat:am'). Also removes the
            // auto-generated 'radical' rows from hanja_related.
            await customStatement(
                "ALTER TABLE items ADD COLUMN root_refs TEXT NOT NULL DEFAULT ''");
            await customStatement('DROP TABLE IF EXISTS item_etymon');
            await customStatement(
                "DELETE FROM hanja_related WHERE relation = 'radical'");
          }
          if (from < 13) {
            // v13 adds Vietnamese Southern dialect variant columns. NULL by
            // default; populated only for rows where the south differs from
            // the base (north). LanguageService.viRegion controls fallback.
            await customStatement(
                'ALTER TABLE items ADD COLUMN target_south TEXT');
            await customStatement(
                'ALTER TABLE items ADD COLUMN korean_south TEXT');
            await customStatement(
                'ALTER TABLE items ADD COLUMN romanization_south TEXT');
          }
          if (from < 14) {
            // v14 adds Spanish Iberian (Spain) variant columns. Mirror of v13
            // for ES — base=latam (멕시코 기준), variant=spain (Castilian).
            // LanguageService.esRegion controls which one is shown.
            await customStatement(
                'ALTER TABLE items ADD COLUMN target_spain TEXT');
            await customStatement(
                'ALTER TABLE items ADD COLUMN korean_spain TEXT');
            await customStatement(
                'ALTER TABLE items ADD COLUMN romanization_spain TEXT');
          }
          if (from < 15) {
            // v15: tier (어휘 빈도 기반 초/중/고) + dialogue_order (흥미
            // 곡선 배치). 둘 다 nullable·기본값 존재 — 기존 데이터 안전.
            await customStatement(
                'ALTER TABLE items ADD COLUMN tier TEXT');
            await customStatement(
                'ALTER TABLE items ADD COLUMN dialogue_order INTEGER NOT NULL DEFAULT 0');
          }
          if (from < 16) {
            // v16: vocab_hints — freq 밖 어휘·고유명사 해설 JSON 배열.
            // 포맷: [{"w":"단어","ko":"뜻"}, ...]
            await customStatement(
                'ALTER TABLE items ADD COLUMN vocab_hints TEXT');
          }
          if (from < 17) {
            // v17: VI 호칭 placeholder 시스템 도입.
            // is_polite (반말/존대 표지) + applicable_scenario (시나리오 lock).
            await customStatement(
                'ALTER TABLE items ADD COLUMN is_polite INTEGER NOT NULL DEFAULT 0');
            await customStatement(
                'ALTER TABLE items ADD COLUMN applicable_scenario INTEGER');
          }
          if (from < 18) {
            // v18: morph_tags (RU 전용, Natasha 자동 색칠 메타).
            // JSON 배열 — 명사 성·동사 1식/2식·불규칙·발음법칙 갈색.
            await customStatement(
                'ALTER TABLE items ADD COLUMN morph_tags TEXT');
          }
        },
      );

  // ---- Items ----

  Future<List<Item>> allItems() => select(items).get();
  Future<Item?> itemById(String id) =>
      (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertItems(List<ItemsCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(items, rows);
    });
  }

  Future<DateTime?> latestItemsUpdatedAt() async {
    final row = await (selectOnly(items)
          ..addColumns([items.updatedAt.max()]))
        .getSingleOrNull();
    return row?.read(items.updatedAt.max());
  }

  /// Update the dev-only `comment` field on a single item. Used by the
  /// long-press memo editor (admin-only). Caller is responsible for
  /// pushing the change to Supabase via SyncService.
  Future<void> updateItemComment(String id, String comment) async {
    await (update(items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(
        comment: Value(comment),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// Admin — delete a single item locally. Supabase-side via SyncService.
  Future<void> deleteItemById(String id) async {
    await (delete(items)..where((t) => t.id.equals(id))).go();
  }

  /// Admin — insert a new item locally. Supabase-side via SyncService.
  Future<void> insertItem(ItemsCompanion row) async {
    await into(items).insert(row);
  }

  /// Generic admin edit — update any subset of an item's editable fields.
  /// Used by the AdminScreen curriculum editor.
  Future<void> updateItemFields(
    String id, {
    String? targetText,
    String? korean,
    String? romanization,
    String? category,
    int? course,
    String? notes,
    String? comment,
    String? relatedCsv,
    String? rootRefs,
    String? speaker,
    int? turnOrder,
    String? scenario,
  }) async {
    await (update(items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(
        targetText:
            targetText == null ? const Value.absent() : Value(targetText),
        korean: korean == null ? const Value.absent() : Value(korean),
        romanization:
            romanization == null ? const Value.absent() : Value(romanization),
        category: category == null ? const Value.absent() : Value(category),
        course: course == null ? const Value.absent() : Value(course),
        notes: notes == null ? const Value.absent() : Value(notes),
        comment: comment == null ? const Value.absent() : Value(comment),
        relatedCsv:
            relatedCsv == null ? const Value.absent() : Value(relatedCsv),
        rootRefs:
            rootRefs == null ? const Value.absent() : Value(rootRefs),
        speaker: speaker == null ? const Value.absent() : Value(speaker),
        turnOrder:
            turnOrder == null ? const Value.absent() : Value(turnOrder),
        scenario: scenario == null ? const Value.absent() : Value(scenario),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // ---- UserProgress ----

  Future<UserProgressRow?> progressFor(String itemId) =>
      (select(userProgress)..where((t) => t.itemId.equals(itemId)))
          .getSingleOrNull();

  Future<List<UserProgressRow>> allProgress() => select(userProgress).get();

  Future<List<UserProgressRow>> unsyncedProgress() =>
      (select(userProgress)..where((t) => t.synced.equals(false))).get();

  Future<void> writeProgress(UserProgressCompanion row) =>
      into(userProgress).insertOnConflictUpdate(row);

  Future<void> markProgressSynced(List<String> itemIds) async {
    await (update(userProgress)..where((t) => t.itemId.isIn(itemIds)))
        .write(const UserProgressCompanion(synced: Value(true)));
  }

  Future<void> clearUserData() async {
    await batch((b) {
      b.deleteWhere(userProgress, (t) => const Constant(true));
      b.deleteWhere(userStats, (t) => const Constant(true));
      b.deleteWhere(dailyCounts, (t) => const Constant(true));
    });
  }

  // ---- UserStats (single-row) ----

  Future<UserStatRow?> getStats() =>
      (select(userStats)..where((t) => t.id.equals(1))).getSingleOrNull();

  Future<void> writeStats(UserStatsCompanion row) =>
      into(userStats).insertOnConflictUpdate(row);

  // ---- DailyCounts ----

  Future<int> countForDate(String date) async {
    final row = await (select(dailyCounts)..where((t) => t.date.equals(date)))
        .getSingleOrNull();
    return row?.count ?? 0;
  }

  Future<List<DailyCountRow>> countsBetween(String fromDate, String toDate) =>
      (select(dailyCounts)
            ..where((t) => t.date.isBetweenValues(fromDate, toDate))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<void> writeDailyCount(DailyCountsCompanion row) =>
      into(dailyCounts).insertOnConflictUpdate(row);

  Future<List<DailyCountRow>> unsyncedDailyCounts() =>
      (select(dailyCounts)..where((t) => t.synced.equals(false))).get();

  // ---- SyncMeta ----

  Future<String?> getMeta(String key) async {
    final row = await (select(syncMeta)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setMeta(String key, String value) =>
      into(syncMeta).insertOnConflictUpdate(
        SyncMetaCompanion.insert(key: key, value: value),
      );

  /// 전체 items 테이블과 관련 watermark를 비움 — Midnight Lounge 누락 등
  /// watermark 기반 부분 동기화가 꼬였을 때 재동기화용.
  Future<void> resetItemsSync() async {
    await delete(items).go();
    await (delete(syncMeta)..where((t) => t.key.like('items_watermark_%'))).go();
  }

  // ---- Hanzi (Chinese) ----

  Future<List<HanziStudyZhRow>> allHanziStudiesZh() =>
      (select(hanziStudiesZh)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<HanziStudyZhRow?> hanziStudyZhById(String id) =>
      (select(hanziStudiesZh)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertHanziStudiesZh(List<HanziStudiesZhCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(hanziStudiesZh, rows));
  }

  Future<List<HanziRelatedZhRow>> relatedForStudyZh(String studyId) =>
      (select(hanziRelatedZh)
            ..where((t) => t.studyId.equals(studyId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<void> replaceRelatedForStudyZh(
    String studyId,
    List<HanziRelatedZhCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(hanziRelatedZh)..where((t) => t.studyId.equals(studyId)))
          .go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(hanziRelatedZh, rows));
      }
    });
  }

  // ---- Hanzi (Japanese) ----

  Future<List<HanziStudyJpRow>> allHanziStudiesJp() =>
      (select(hanziStudiesJp)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<HanziStudyJpRow?> hanziStudyJpById(String id) =>
      (select(hanziStudiesJp)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertHanziStudiesJp(List<HanziStudiesJpCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(hanziStudiesJp, rows));
  }

  Future<List<HanziRelatedJpRow>> relatedForStudyJp(String studyId) =>
      (select(hanziRelatedJp)
            ..where((t) => t.studyId.equals(studyId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<void> replaceRelatedForStudyJp(
    String studyId,
    List<HanziRelatedJpCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(hanziRelatedJp)..where((t) => t.studyId.equals(studyId)))
          .go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(hanziRelatedJp, rows));
      }
    });
  }

  // ---- Hanja Master (4-script unified) ----

  /// 우선순위(낮은 = 기초) 순으로 정렬된 한자 리스트.
  Future<List<HanjaMasterRow>> allHanjaMaster({int? limit}) {
    final q = select(hanjaMaster)
      ..orderBy([(t) => OrderingTerm.asc(t.priority)]);
    if (limit != null) q.limit(limit);
    return q.get();
  }

  Future<HanjaMasterRow?> hanjaByKor(String korHanja) =>
      (select(hanjaMaster)..where((t) => t.korHanja.equals(korHanja)))
          .getSingleOrNull();

  /// 일본 한자(ja_kanji) 컬럼으로 역조회 — 일본어 학습에서 한자 → 한국 음/뜻 가져올 때.
  Future<HanjaMasterRow?> hanjaByJaKanji(String kanji) =>
      (select(hanjaMaster)..where((t) => t.jaKanji.equals(kanji)))
          .getSingleOrNull();

  /// JLPT 레벨로 필터 (N5..N1).
  Future<List<HanjaMasterRow>> hanjaByJlpt(String level) =>
      (select(hanjaMaster)
            ..where((t) => t.jlptLevel.equals(level))
            ..orderBy([(t) => OrderingTerm.asc(t.priority)]))
          .get();

  /// 부수가 같은 한자들 (hanja_related 'radical' 캐시 대체).
  /// priority → stroke_total → kor_hanja 순. 자기 자신 제외.
  Future<List<HanjaMasterRow>> hanjaByRadical(String radical,
      {String? excludeKorHanja, int limit = 4}) {
    final q = select(hanjaMaster)
      ..where((t) => t.radical.equals(radical))
      ..orderBy([
        (t) => OrderingTerm.asc(t.priority),
        (t) => OrderingTerm.asc(t.strokeTotal),
        (t) => OrderingTerm.asc(t.korHanja),
      ])
      ..limit(limit);
    if (excludeKorHanja != null) {
      q.where((t) => t.korHanja.equals(excludeKorHanja).not());
    }
    return q.get();
  }

  Future<void> upsertHanjaMaster(List<HanjaMasterCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(hanjaMaster, rows));
  }

  Future<DateTime?> latestHanjaUpdatedAt() async {
    final row = await (selectOnly(hanjaMaster)
          ..addColumns([hanjaMaster.updatedAt.max()]))
        .getSingleOrNull();
    return row?.read(hanjaMaster.updatedAt.max());
  }

  /// Admin UI 검색: kor_hanja / kor_sound / kor_meaning 어디든 매칭.
  /// 기본 정렬은 importance NULLS LAST → priority asc.
  Future<List<HanjaMasterRow>> searchHanja(String query, {int limit = 50}) {
    final q = query.trim();
    final select_ = select(hanjaMaster);
    if (q.isNotEmpty) {
      final pattern = '%$q%';
      select_.where((t) =>
          t.korHanja.equals(q) |
          t.korSound.like(pattern) |
          t.korMeaning.like(pattern));
    }
    select_.orderBy([
      // importance 가 채워진 것 우선 (큰 값일수록 먼저)
      (t) => OrderingTerm.desc(t.importance),
      (t) => OrderingTerm.asc(t.priority),
      (t) => OrderingTerm.asc(t.korHanja),
    ]);
    select_.limit(limit);
    return select_.get();
  }

  /// Admin 입력 — importance / note_admin 만 변경 (다른 컬럼은 sync 가 관리).
  Future<void> setHanjaCuration({
    required String korHanja,
    int? importance,
    String? noteAdmin,
  }) async {
    final now = DateTime.now().toUtc();
    await (update(hanjaMaster)
          ..where((t) => t.korHanja.equals(korHanja)))
        .write(HanjaMasterCompanion(
      importance: Value(importance),
      noteAdmin:
          noteAdmin == null ? const Value.absent() : Value(noteAdmin),
      updatedAt: Value(now),
    ));
  }

  // ---- Hanja Related (radical / phonetic / semantic) ----

  Future<List<HanjaRelatedRow>> hanjaRelatedFor(String source,
      {String? relation}) {
    final q = select(hanjaRelated)
      ..where((t) => t.source.equals(source))
      ..orderBy([
        (t) => OrderingTerm.asc(t.relation),
        (t) => OrderingTerm.asc(t.position),
      ]);
    if (relation != null) {
      q.where((t) => t.relation.equals(relation));
    }
    return q.get();
  }

  Future<void> upsertHanjaRelated(List<HanjaRelatedCompanion> rows) async {
    if (rows.isEmpty) return;
    await batch((b) => b.insertAll(hanjaRelated, rows,
        onConflict: DoUpdate(
          (old) => HanjaRelatedCompanion.custom(
            position: const CustomExpression('excluded.position'),
            note: const CustomExpression('excluded.note'),
            addedBy: const CustomExpression('excluded.added_by'),
          ),
          target: [hanjaRelated.source, hanjaRelated.related, hanjaRelated.relation],
        )));
  }

  /// 어드민에서 phonetic 매핑 전체 교체 (해당 source 의 phonetic 다 지우고 새로).
  Future<void> replaceHanjaRelated({
    required String source,
    required String relation,
    required List<HanjaRelatedCompanion> rows,
  }) async {
    await transaction(() async {
      await (delete(hanjaRelated)
            ..where((t) =>
                t.source.equals(source) & t.relation.equals(relation)))
          .go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(hanjaRelated, rows));
      }
    });
  }

  Future<DateTime?> latestHanjaRelatedUpdatedAt() async {
    final row = await (selectOnly(hanjaRelated)
          ..addColumns([hanjaRelated.updatedAt.max()]))
        .getSingleOrNull();
    return row?.read(hanjaRelated.updatedAt.max());
  }

  // ---- Etymon (Latin/Greek/Germanic/Arabic 어근) ----

  Future<EtymonRow?> etymonById(String id) =>
      (select(etymon)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertEtymon(List<EtymonCompanion> rows) async {
    if (rows.isEmpty) return;
    await batch((b) => b.insertAllOnConflictUpdate(etymon, rows));
  }

  Future<DateTime?> latestEtymonUpdatedAt() async {
    final row = await (selectOnly(etymon)
          ..addColumns([etymon.updatedAt.max()]))
        .getSingleOrNull();
    return row?.read(etymon.updatedAt.max());
  }

  /// 같은 root ref 를 공유하는 다른 item id 들 (현재 item 제외).
  /// root_refs CSV 안에 해당 토큰이 포함된 행을 LIKE 로 검색.
  /// 'lat:am' 으로 호출하면 es/fr/en 동시 검색 가능.
  Future<List<String>> itemsForRootRef(String rootRef,
      {String? excludeItemId, int limit = 24}) async {
    final escaped = rootRef.replaceAll('%', r'\%').replaceAll('_', r'\_');
    // Match as CSV token: preceded by start/',' and followed by end/','.
    final q = select(items)
      ..where((t) =>
          t.rootRefs.like(escaped) |
          t.rootRefs.like('$escaped,%') |
          t.rootRefs.like('%,$escaped') |
          t.rootRefs.like('%,$escaped,%'))
      ..orderBy([(t) => OrderingTerm.asc(t.id)])
      ..limit(limit);
    if (excludeItemId != null) {
      q.where((t) => t.id.equals(excludeItemId).not());
    }
    final rows = await q.get();
    return rows.map((r) => r.id).toList();
  }
}

/// Per-flavor SQLite filename: each Play Store app has its own
/// applicationId so the file path is already sandboxed, but using a
/// flavor-tagged name makes it obvious in logs / device inspectors.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file =
        File(p.join(dir.path, 'talkverse_${AppConfig.languageCode}.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
