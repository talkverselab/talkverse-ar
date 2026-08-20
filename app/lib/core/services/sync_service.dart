import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../config/language_registry.dart';
import '../data/favorite_words.dart';
import '../data/user_progress.dart';
import '../data/user_stats.dart';
import '../data/word_data.dart' as word_data;
import '../data/word_reviews.dart';
import '../db/app_database.dart' hide UserProgress, UserStats;
import '../supabase/supabase_service.dart';

/// Orchestrates two kinds of sync:
///   1. **Content** (items table) — anonymous read, pulled on startup.
///   2. **User data** (progress/stats/counts) — pulled on login, pushed after
///      local writes with a 1s debounce.
class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  /// Items watermark is **per-language** (`items_watermark_ru`, `items_watermark_es`, ...)
  /// so switching languages never filters out fresh data from the new language.
  /// Using the legacy global key would cause syncItems to return 0 rows for the
  /// new language if its max(updated_at) ≤ prior language's watermark.
  static String _metaItemsWatermark(String langCode) =>
      'items_watermark_$langCode';
  static const _metaHanziWatermark = 'hanzi_watermark';
  static const _metaHanjaWatermark = 'hanja_master_watermark';
  static const _metaHanjaRelWatermark = 'hanja_related_watermark';
  static const _metaEtymonWatermark = 'etymon_watermark';

  Timer? _pushProgressTimer;
  Timer? _pushStatsTimer;
  bool _pushingProgress = false;
  bool _pushingStats = false;

  AppDatabase get _db => SupabaseService.instance.db;

  /// 로컬 items 테이블 + watermark 전부 비우고 풀 재동기화.
  /// 부분 동기화로 누락된 카테고리(예: Midnight Lounge 연인 인티밋 4/25)
  /// 복구용.
  Future<void> hardResyncItems() async {
    await _db.resetItemsSync();
    await syncItems();
    await word_data.loadWords();
  }

  // ==================== Content (items) ====================

  /// Pull all items for current language from Supabase into local Drift.
  ///
  /// 페이지네이션 = id 기준 offset (Supabase `.range()`). watermark 기반 페이지네이션은
  /// 한 트랜잭션에서 INSERT 된 rows 가 모두 같은 `updated_at` 을 가지면 두 번째 페이지의
  /// `gt(watermark)` 가 0 rows 를 반환해서 첫 페이지(1000개) 만 동기화되고 끝나는 버그가
  /// 있어 폐기 (2026-04-25).
  ///
  /// 한 언어 = ~6700 rows 이므로 1000 × 7 페이지 ≈ ~5MB 전송. ON CONFLICT 로 idempotent.
  /// 변경 감지 최적화는 `items_watermark_<lang>` 에 마지막 sync 시각만 저장 (현재 미사용).
  Future<void> syncItems() async {
    try {
      final mainLang = AppConfig.languageCode;
      // 부록 언어 (Decision 41 — TH→LO 보너스 챕터, ID→MS 등) 도 함께 fetch.
      // 부모 언어와 같은 sync 사이클에서 끌고 와야 conversation/keyboard 메뉴에 노출됨.
      final langs = <String>[
        mainLang,
        ...LanguageRegistry.appendicesFor(mainLang),
      ];
      const pageSize = 1000;
      var offset = 0;
      var pagesPulled = 0;
      const maxPages = 20; // 안전장치 — 1000 × 20 = 20k rows

      while (pagesPulled < maxPages) {
        final rows = await SupabaseService.instance.client
            .from('items')
            .select()
            .inFilter('language_code', langs)
            .order('id', ascending: true)
            .range(offset, offset + pageSize - 1);

        if (rows.isEmpty) {
          if (kDebugMode) {
            debugPrint('[SyncService] syncItems done — '
                'lang=$mainLang offset=$offset pages=$pagesPulled (empty page)');
          }
          return; // 완료
        }
        if (!await _processItemsBatch(rows, mainLang)) {
          if (kDebugMode) {
            debugPrint('[SyncService] syncItems STOPPED — '
                'batch failed at offset=$offset (${rows.length} rows). '
                '메뉴 카운트가 0/2 등 비정상 시 hardResyncItems() 호출.');
          }
          return; // 업서트 실패
        }
        offset += rows.length;
        pagesPulled++;
        if (rows.length < pageSize) {
          if (kDebugMode) {
            debugPrint('[SyncService] syncItems done — '
                'lang=$mainLang total=$offset pages=$pagesPulled (last page short)');
          }
          return; // 마지막 페이지
        }
      }
      if (kDebugMode) {
        debugPrint('[SyncService] syncItems hit maxPages=$maxPages — '
            'total=$offset rows synced. 더 있으면 maxPages 늘려야 함.');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[SyncService] syncItems exception: $e\n$st');
      }
    }
  }

  /// 단일 배치 upsert + watermark 갱신. 성공 시 true, 실패 시 false.
  Future<bool> _processItemsBatch(
      List<Map<String, dynamic>> rows, String lang) async {
    try {
      if (rows.isEmpty) return false;

      final companions = rows.map<ItemsCompanion>((r) {
        final tags = (r['tags'] as List?)?.cast<String>() ?? const <String>[];
        return ItemsCompanion.insert(
          id: r['id'] as String,
          type: r['type'] as String,
          targetText: r['target_text'] as String,
          korean: r['korean'] as String,
          romanization: Value((r['romanization'] as String?) ?? ''),
          category: Value((r['category'] as String?) ?? ''),
          course: Value((r['course'] as int?) ?? 1),
          tagsCsv: Value(tags.join(',')),
          notes: Value((r['notes'] as String?) ?? ''),
          comment: Value((r['comment'] as String?) ?? ''),
          relatedCsv: Value((r['related_csv'] as String?) ?? ''),
          rootRefs: Value((r['root_refs'] as String?) ?? ''),
          speaker: Value((r['speaker'] as String?) ?? ''),
          turnOrder: Value((r['turn_order'] as int?) ?? 0),
          scenario: Value((r['scenario'] as String?) ?? ''),
          // 베트남어 남부 방언 변형 (대부분 NULL).
          targetSouth: Value(r['target_south'] as String?),
          koreanSouth: Value(r['korean_south'] as String?),
          romanizationSouth: Value(r['romanization_south'] as String?),
          // 스페인어 스페인 본토 변형 (대부분 NULL — base는 라틴아메리카).
          targetSpain: Value(r['target_spain'] as String?),
          koreanSpain: Value(r['korean_spain'] as String?),
          romanizationSpain: Value(r['romanization_spain'] as String?),
          // v15: tier (어휘 빈도 기반) + dialogue_order (흥미 곡선).
          tier: Value(r['tier'] as String?),
          dialogueOrder: Value((r['dialogue_order'] as int?) ?? 0),
          // v16: vocab_hints (freq 밖 어휘·고유명사 해설).
          // Supabase는 jsonb로 저장 → Dart map/list 반환. JSON string으로 저장.
          vocabHints: Value(r['vocab_hints'] == null
              ? null
              : (r['vocab_hints'] is String
                  ? r['vocab_hints'] as String
                  : jsonEncode(r['vocab_hints']))),
          // v17: VI 호칭 placeholder 시스템 (is_polite + applicable_scenario).
          isPolite: Value((r['is_polite'] as bool?) ?? false),
          applicableScenario: Value(r['applicable_scenario'] as int?),
          // v18: morph_tags (RU 전용 Natasha 색칠 메타).
          // Supabase는 jsonb로 저장 → Dart map/list 반환. JSON string으로 저장.
          morphTags: Value(r['morph_tags'] == null
              ? null
              : (r['morph_tags'] is String
                  ? r['morph_tags'] as String
                  : jsonEncode(r['morph_tags']))),
          updatedAt: DateTime.parse(r['updated_at'] as String),
        );
      }).toList();

      await _db.upsertItems(companions);

      // Advance per-language watermark to the max updated_at seen.
      final maxUpdated = rows
          .map((r) => r['updated_at'] as String)
          .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
      await _db.setMeta(_metaItemsWatermark(lang), maxUpdated);

      // Refresh in-memory word cache.
      await word_data.loadWords();
      return true;
    } catch (e, st) {
      // 카운트 0/2 같은 증상의 가장 흔한 원인 — 여기 잡힘.
      // 가능 원인: schema mismatch (Supabase 새 컬럼 vs Drift v18 미적용),
      //            NOT NULL 제약 위반, type 불일치, batch upsert 1행 실패시 전체 rollback.
      if (kDebugMode) {
        final firstId = rows.isNotEmpty ? rows.first['id'] : '(empty)';
        debugPrint('[SyncService] _processItemsBatch FAIL — '
            'lang=$lang batchSize=${rows.length} firstId=$firstId\n'
            'error: $e\nstack: $st');
      }
      return false;
    }
  }

  /// Etymon catalog — universal (모든 언어 공유).
  /// 카탈로그(~130행)만 sync. 아이템별 매핑은 items.root_refs 로 syncItems 에서 처리.
  Future<void> syncEtymon() async {
    try {
      final client = SupabaseService.instance.client;
      final wm = await _db.getMeta(_metaEtymonWatermark);
      var q = client
          .from('etymon')
          .select()
          .order('updated_at', ascending: true)
          .limit(500);
      if (wm != null) {
        q = client
            .from('etymon')
            .select()
            .gt('updated_at', wm)
            .order('updated_at', ascending: true)
            .limit(500);
      }
      final rows = await q;
      if (rows.isEmpty) return;

      final companions = rows.map<EtymonCompanion>((r) {
        return EtymonCompanion.insert(
          id: r['id'] as String,
          sourceLang: r['source_lang'] as String,
          root: r['root'] as String,
          meaningKo: r['meaning_ko'] as String,
          meaningEn: Value((r['meaning_en'] as String?) ?? ''),
          notes: Value((r['notes'] as String?) ?? ''),
          priority: Value((r['priority'] as int?) ?? 9),
          updatedAt: DateTime.parse(r['updated_at'] as String),
        );
      }).toList();
      await _db.upsertEtymon(companions);
      final maxUpdated = rows
          .map((r) => r['updated_at'] as String)
          .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
      await _db.setMeta(_metaEtymonWatermark, maxUpdated);
    } catch (_) {
      // Offline / transient.
    }
  }

  /// Pull any new/changed hanzi studies + their related characters.
  /// Dispatches to the per-language table matching the current flavor:
  /// Chinese → hanzi_studies_zh, Japanese → hanzi_studies_jp.
  /// Non-CJK flavors skip entirely.
  Future<void> syncHanziStudies() async {
    if (!AppConfig.hasHanjaSupport) return;
    try {
      switch (AppConfig.languageCode) {
        case 'zh':
          await _syncHanziStudiesZh();
          break;
        case 'ja':
          await _syncHanziStudiesJp();
          break;
        // Other CJK-adjacent languages would go here.
      }
      // 한자 마스터(통합)는 zh/ja 모두 사용 — 한 번 더 sync.
      await _syncHanjaMaster();
      await _syncHanjaRelated();
    } catch (_) {
      // Offline / transient.
    }
  }

  /// 한국 한자 5,978자 통합 마스터 동기화. zh/ja 양쪽이 모두 참조.
  /// 5K+ 행이라 watermark 기반 incremental 필수.
  Future<void> _syncHanjaMaster() async {
    final client = SupabaseService.instance.client;
    final watermark = await _db.getMeta(_metaHanjaWatermark);

    var query = client
        .from('hanja_master')
        .select()
        .order('updated_at', ascending: true)
        .limit(1000);
    if (watermark != null) {
      query = client
          .from('hanja_master')
          .select()
          .gt('updated_at', watermark)
          .order('updated_at', ascending: true)
          .limit(1000);
    }

    while (true) {
      final rows = await query;
      if (rows.isEmpty) break;

      final companions = rows.map<HanjaMasterCompanion>((r) {
        return HanjaMasterCompanion.insert(
          korHanja: r['kor_hanja'] as String,
          korSound: Value((r['kor_sound'] as String?) ?? ''),
          korMeaning: Value((r['kor_meaning'] as String?) ?? ''),
          korLevel: Value((r['kor_level'] as String?) ?? ''),
          radical: Value((r['radical'] as String?) ?? ''),
          strokeEx: Value((r['stroke_ex'] as int?) ?? 0),
          strokeTotal: Value((r['stroke_total'] as int?) ?? 0),
          zhSimplified: Value(r['zh_simplified'] as String?),
          zhTraditional: Value(r['zh_traditional'] as String?),
          jaKanji: Value(r['ja_kanji'] as String?),
          priority: Value((r['priority'] as int?) ?? 9),
          hskLevel: Value(r['hsk_level'] as int?),
          jlptLevel: Value(r['jlpt_level'] as String?),
          updatedAt: DateTime.parse(r['updated_at'] as String),
        );
      }).toList();

      await _db.upsertHanjaMaster(companions);

      final maxUpdated = rows
          .map((r) => r['updated_at'] as String)
          .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
      await _db.setMeta(_metaHanjaWatermark, maxUpdated);

      if (rows.length < 1000) break;
      query = client
          .from('hanja_master')
          .select()
          .gt('updated_at', maxUpdated)
          .order('updated_at', ascending: true)
          .limit(1000);
    }
  }

  /// hanja_related — 부수 자동 매핑 ~24K + 음 큐레이션 향후 추가.
  /// 동일하게 watermark 기반 incremental.
  Future<void> _syncHanjaRelated() async {
    final client = SupabaseService.instance.client;
    final watermark = await _db.getMeta(_metaHanjaRelWatermark);

    var query = client
        .from('hanja_related')
        .select()
        .order('updated_at', ascending: true)
        .limit(2000);
    if (watermark != null) {
      query = client
          .from('hanja_related')
          .select()
          .gt('updated_at', watermark)
          .order('updated_at', ascending: true)
          .limit(2000);
    }

    while (true) {
      final rows = await query;
      if (rows.isEmpty) break;

      final companions = rows.map<HanjaRelatedCompanion>((r) {
        return HanjaRelatedCompanion.insert(
          source: r['source'] as String,
          related: r['related'] as String,
          relation: r['relation'] as String,
          position: Value((r['position'] as int?) ?? 0),
          note: Value((r['note'] as String?) ?? ''),
          addedBy: Value((r['added_by'] as String?) ?? ''),
          updatedAt: DateTime.parse(r['updated_at'] as String),
        );
      }).toList();

      await _db.upsertHanjaRelated(companions);

      final maxUpdated = rows
          .map((r) => r['updated_at'] as String)
          .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
      await _db.setMeta(_metaHanjaRelWatermark, maxUpdated);

      if (rows.length < 2000) break;
      query = client
          .from('hanja_related')
          .select()
          .gt('updated_at', maxUpdated)
          .order('updated_at', ascending: true)
          .limit(2000);
    }
  }

  Future<void> _syncHanziStudiesZh() async {
    final client = SupabaseService.instance.client;
    final watermark = await _db.getMeta(_metaHanziWatermark);

    var studiesQuery = client
        .from('hanzi_studies_zh')
        .select()
        .order('updated_at', ascending: true)
        .limit(500);
    if (watermark != null) {
      studiesQuery = client
          .from('hanzi_studies_zh')
          .select()
          .gt('updated_at', watermark)
          .order('updated_at', ascending: true)
          .limit(500);
    }
    final studyRows = await studiesQuery;
    if (studyRows.isEmpty) return;

    final studyCompanions = studyRows.map<HanziStudiesZhCompanion>((r) {
      return HanziStudiesZhCompanion.insert(
        id: r['id'] as String,
        radical: r['radical'] as String,
        meaningKo: r['meaning_ko'] as String,
        pinyin: Value((r['pinyin'] as String?) ?? ''),
        tone: Value((r['tone'] as int?) ?? 0),
        description: Value((r['description'] as String?) ?? ''),
        sortOrder: Value((r['sort_order'] as int?) ?? 0),
        updatedAt: DateTime.parse(r['updated_at'] as String),
      );
    }).toList();

    await _db.upsertHanziStudiesZh(studyCompanions);

    for (final r in studyRows) {
      final studyId = r['id'] as String;
      final relatedRows = await client
          .from('hanzi_related_zh')
          .select()
          .eq('study_id', studyId)
          .order('position', ascending: true);

      final relatedCompanions = relatedRows.map<HanziRelatedZhCompanion>((rr) {
        return HanziRelatedZhCompanion.insert(
          studyId: studyId,
          character: rr['character'] as String,
          pinyin: Value((rr['pinyin'] as String?) ?? ''),
          tone: Value((rr['tone'] as int?) ?? 0),
          meaningKo: rr['meaning_ko'] as String,
          relationType: rr['relation_type'] as String,
          position: Value((rr['position'] as int?) ?? 0),
          note: Value((rr['note'] as String?) ?? ''),
          updatedAt: DateTime.parse(rr['updated_at'] as String),
        );
      }).toList();

      await _db.replaceRelatedForStudyZh(studyId, relatedCompanions);
    }

    final maxUpdated = studyRows
        .map((r) => r['updated_at'] as String)
        .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
    await _db.setMeta(_metaHanziWatermark, maxUpdated);
  }

  Future<void> _syncHanziStudiesJp() async {
    final client = SupabaseService.instance.client;
    final watermark = await _db.getMeta(_metaHanziWatermark);

    var studiesQuery = client
        .from('hanzi_studies_jp')
        .select()
        .order('updated_at', ascending: true)
        .limit(500);
    if (watermark != null) {
      studiesQuery = client
          .from('hanzi_studies_jp')
          .select()
          .gt('updated_at', watermark)
          .order('updated_at', ascending: true)
          .limit(500);
    }
    final studyRows = await studiesQuery;
    if (studyRows.isEmpty) return;

    final studyCompanions = studyRows.map<HanziStudiesJpCompanion>((r) {
      return HanziStudiesJpCompanion.insert(
        id: r['id'] as String,
        radical: r['radical'] as String,
        meaningKo: r['meaning_ko'] as String,
        onyomi: Value((r['onyomi'] as String?) ?? ''),
        kunyomi: Value((r['kunyomi'] as String?) ?? ''),
        description: Value((r['description'] as String?) ?? ''),
        sortOrder: Value((r['sort_order'] as int?) ?? 0),
        updatedAt: DateTime.parse(r['updated_at'] as String),
      );
    }).toList();

    await _db.upsertHanziStudiesJp(studyCompanions);

    for (final r in studyRows) {
      final studyId = r['id'] as String;
      final relatedRows = await client
          .from('hanzi_related_jp')
          .select()
          .eq('study_id', studyId)
          .order('position', ascending: true);

      final relatedCompanions = relatedRows.map<HanziRelatedJpCompanion>((rr) {
        return HanziRelatedJpCompanion.insert(
          studyId: studyId,
          character: rr['character'] as String,
          onyomi: Value((rr['onyomi'] as String?) ?? ''),
          kunyomi: Value((rr['kunyomi'] as String?) ?? ''),
          meaningKo: rr['meaning_ko'] as String,
          relationType: rr['relation_type'] as String,
          position: Value((rr['position'] as int?) ?? 0),
          note: Value((rr['note'] as String?) ?? ''),
          updatedAt: DateTime.parse(rr['updated_at'] as String),
        );
      }).toList();

      await _db.replaceRelatedForStudyJp(studyId, relatedCompanions);
    }

    final maxUpdated = studyRows
        .map((r) => r['updated_at'] as String)
        .reduce((a, b) => a.compareTo(b) > 0 ? a : b);
    await _db.setMeta(_metaHanziWatermark, maxUpdated);
  }

  // ==================== User data ====================

  /// On login: pull remote user state and reconcile with local.
  Future<void> syncUserDataOnLogin() async {
    final userId = SupabaseService.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    await Future.wait([
      _pullProgress(userId),
      _pullStats(userId),
      _pullDailyCounts(userId),
    ]);

    // After pulling remote, push any local pending changes.
    await _pushProgressNow();
    await _pushStatsNow();

    // Refresh in-memory caches.
    await UserProgress().refreshFromLocal();
    await FavoriteWords().refreshFromLocal();
    await WordReviews().refreshFromLocal();
    await UserStats().refreshFromLocal();
  }

  Future<void> _pullProgress(String userId) async {
    try {
      final remote = await SupabaseService.instance.client
          .from('user_progress')
          .select()
          .eq('user_id', userId);

      for (final r in remote) {
        final itemId = r['item_id'] as String;
        final local = await _db.progressFor(itemId);
        final remoteUpdated = DateTime.parse(r['updated_at'] as String);

        // Remote-wins only if local is already synced AND older.
        // If local has unsynced changes, keep local.
        if (local != null && !local.synced) continue;
        if (local != null && local.updatedAt.isAfter(remoteUpdated)) continue;

        await _db.writeProgress(UserProgressCompanion(
          itemId: Value(itemId),
          isKnown: Value((r['is_known'] as bool?) ?? false),
          isFavorite: Value((r['is_favorite'] as bool?) ?? false),
          reviewScore: Value((r['review_score'] as int?) ?? 0),
          nextReviewAt: Value(r['next_review_at'] == null
              ? null
              : DateTime.parse(r['next_review_at'] as String)),
          updatedAt: Value(remoteUpdated),
          synced: const Value(true),
        ));
      }
    } catch (_) {
      // Keep local state on failure.
    }
  }

  Future<void> _pullStats(String userId) async {
    try {
      final remote = await SupabaseService.instance.client
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (remote == null) return;

      final local = await _db.getStats();
      final remoteUpdated = DateTime.parse(remote['updated_at'] as String);
      if (local != null && !local.synced) return;
      if (local != null && local.updatedAt.isAfter(remoteUpdated)) return;

      await _db.writeStats(UserStatsCompanion(
        id: const Value(1),
        currentStreak: Value((remote['current_streak'] as int?) ?? 0),
        longestStreak: Value((remote['longest_streak'] as int?) ?? 0),
        lastStudyDate: Value(remote['last_study_date'] == null
            ? null
            : DateTime.parse(remote['last_study_date'] as String)),
        dailyGoal: Value((remote['daily_goal'] as int?) ?? 10),
        updatedAt: Value(remoteUpdated),
        synced: const Value(true),
      ));
    } catch (_) {}
  }

  Future<void> _pullDailyCounts(String userId) async {
    try {
      final remote = await SupabaseService.instance.client
          .from('daily_counts')
          .select()
          .eq('user_id', userId);

      for (final r in remote) {
        final date = r['date'] as String;
        final remoteUpdated = DateTime.parse(r['updated_at'] as String);
        await _db.writeDailyCount(DailyCountsCompanion(
          date: Value(date),
          count: Value((r['count'] as int?) ?? 0),
          updatedAt: Value(remoteUpdated),
          synced: const Value(true),
        ));
      }
    } catch (_) {}
  }

  // -------- Push (debounced) --------

  void schedulePushProgress() {
    _pushProgressTimer?.cancel();
    _pushProgressTimer = Timer(const Duration(seconds: 1), _pushProgressNow);
  }

  void schedulePushStats() {
    _pushStatsTimer?.cancel();
    _pushStatsTimer = Timer(const Duration(seconds: 1), _pushStatsNow);
  }

  Future<void> _pushProgressNow() async {
    if (_pushingProgress) return;
    final userId = SupabaseService.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _pushingProgress = true;
    try {
      final pending = await _db.unsyncedProgress();
      if (pending.isEmpty) return;

      final rows = pending
          .map((r) => {
                'user_id': userId,
                'item_id': r.itemId,
                'is_known': r.isKnown,
                'is_favorite': r.isFavorite,
                'review_score': r.reviewScore,
                'next_review_at': r.nextReviewAt?.toIso8601String(),
                'updated_at': r.updatedAt.toIso8601String(),
              })
          .toList();

      await SupabaseService.instance.client
          .from('user_progress')
          .upsert(rows, onConflict: 'user_id,item_id');

      await _db.markProgressSynced(pending.map((r) => r.itemId).toList());
    } catch (_) {
      // Retry on next trigger.
    } finally {
      _pushingProgress = false;
    }
  }

  Future<void> _pushStatsNow() async {
    if (_pushingStats) return;
    final userId = SupabaseService.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _pushingStats = true;
    try {
      final stats = await _db.getStats();
      if (stats != null && !stats.synced) {
        await SupabaseService.instance.client.from('user_stats').upsert({
          'user_id': userId,
          'current_streak': stats.currentStreak,
          'longest_streak': stats.longestStreak,
          'last_study_date': stats.lastStudyDate?.toIso8601String().split('T').first,
          'daily_goal': stats.dailyGoal,
          'updated_at': stats.updatedAt.toIso8601String(),
        }, onConflict: 'user_id');
        await _db.writeStats(UserStatsCompanion(
          id: const Value(1),
          currentStreak: Value(stats.currentStreak),
          longestStreak: Value(stats.longestStreak),
          lastStudyDate: Value(stats.lastStudyDate),
          dailyGoal: Value(stats.dailyGoal),
          updatedAt: Value(stats.updatedAt),
          synced: const Value(true),
        ));
      }

      final pendingCounts = await _db.unsyncedDailyCounts();
      if (pendingCounts.isNotEmpty) {
        final rows = pendingCounts
            .map((r) => {
                  'user_id': userId,
                  'date': r.date,
                  'count': r.count,
                  'updated_at': r.updatedAt.toIso8601String(),
                })
            .toList();
        await SupabaseService.instance.client
            .from('daily_counts')
            .upsert(rows, onConflict: 'user_id,date');
        for (final r in pendingCounts) {
          await _db.writeDailyCount(DailyCountsCompanion(
            date: Value(r.date),
            count: Value(r.count),
            updatedAt: Value(r.updatedAt),
            synced: const Value(true),
          ));
        }
      }
    } catch (_) {
      // Retry on next trigger.
    } finally {
      _pushingStats = false;
    }
  }

  /// Wipe all per-user data from Drift (called on sign-out).
  Future<void> clearLocalUserData() async {
    _pushProgressTimer?.cancel();
    _pushStatsTimer?.cancel();
    await _db.clearUserData();
  }

  /// Push an admin-edited dev memo to Supabase. Requires the signed-in
  /// email to be on the items-update RLS allowlist (see schema.sql).
  /// Throws if the network call fails so the UI can surface the error.
  Future<void> pushItemComment(String itemId, String comment) async {
    await SupabaseService.instance.client
        .from('items')
        .update({'comment': comment}).eq('id', itemId);
  }

  /// Generic admin push — update any subset of an item's fields remotely.
  /// Caller builds the map with only the keys that changed. Keys must
  /// match Supabase column names exactly: target_text, korean,
  /// romanization, category, course, notes, comment, related_csv,
  /// root_refs, speaker, turn_order, scenario.
  Future<void> pushItemFields(
      String itemId, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;
    await SupabaseService.instance.client
        .from('items')
        .update(fields)
        .eq('id', itemId);
  }

  /// Admin — insert a new items row to Supabase.
  Future<void> pushItemInsert(Map<String, dynamic> row) async {
    await SupabaseService.instance.client.from('items').insert(row);
  }

  /// Admin — delete a row from Supabase by id.
  Future<void> pushItemDelete(String id) async {
    await SupabaseService.instance.client
        .from('items')
        .delete()
        .eq('id', id);
  }

  // ==================== Admin: hanja_master / hanja_related ====================

  /// 한자 큐레이션 필드 업데이트 (importance / note_admin).
  /// 다른 한자 메타(음/뜻/등급)는 일괄 시드로 관리하므로 admin 화면에서 안 건드림.
  Future<void> pushHanjaCuration({
    required String korHanja,
    int? importance,
    String? noteAdmin,
  }) async {
    final fields = <String, dynamic>{};
    fields['importance'] = importance; // null 가능 (지움)
    if (noteAdmin != null) fields['note_admin'] = noteAdmin;
    await SupabaseService.instance.client
        .from('hanja_master')
        .update(fields)
        .eq('kor_hanja', korHanja);
  }

  /// 음 매핑 (phonetic) 전체 교체 — 해당 source 의 phonetic 행 모두 삭제 후
  /// 새 리스트 insert. 부수(radical) 매핑은 자동 시드라 admin 에서 안 건드림.
  Future<void> pushHanjaPhoneticReplace({
    required String source,
    required List<({String related, int position, String note})> rows,
    required String addedBy,
  }) async {
    final client = SupabaseService.instance.client;
    await client
        .from('hanja_related')
        .delete()
        .eq('source', source)
        .eq('relation', 'phonetic');
    if (rows.isEmpty) return;
    final payload = rows
        .map((r) => {
              'source': source,
              'related': r.related,
              'relation': 'phonetic',
              'position': r.position,
              'note': r.note,
              'added_by': addedBy,
            })
        .toList();
    await client.from('hanja_related').insert(payload);
  }
}
