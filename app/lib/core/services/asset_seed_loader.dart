import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../config/app_config.dart';
import '../config/language_registry.dart';
import '../data/word_data.dart' as word_data;
import '../db/app_database.dart' hide UserProgress, UserStats;
import '../supabase/supabase_service.dart';

/// 번들 JSON 시드를 Drift로 1회 import.
///
/// 콘텐츠 시드는 Supabase가 아니라 `assets/data/` 안의 JSON 파일에서 옴.
/// 처음 부팅 시 (또는 schemaVersion 이 올라간 첫 부팅 시) 한 번 로드되고,
/// 이후 부팅에선 이미 import 되어 있는지 SyncMeta로 체크해서 skip.
class AssetSeedLoader {
  AssetSeedLoader._();
  static final AssetSeedLoader instance = AssetSeedLoader._();

  /// JSON 시드 schema 버전. 시드 포맷이 바뀔 때 bump → 다음 부팅에 재import.
  static const int seedVersion = 1;

  AppDatabase get _db => SupabaseService.instance.db;

  String _itemsKey(String lang) => 'seed_items_${lang}_v$seedVersion';
  static const _kHanjaMaster = 'seed_hanja_master_v';
  static const _kHanjaRelated = 'seed_hanja_related_v';
  static const _kHanziStudiesZh = 'seed_hanzi_studies_zh_v';
  static const _kHanziRelatedZh = 'seed_hanzi_related_zh_v';
  static const _kHanziStudiesJp = 'seed_hanzi_studies_jp_v';
  static const _kHanziRelatedJp = 'seed_hanzi_related_jp_v';
  static const _kEtymon = 'seed_etymon_v';

  /// 부팅 시점에 호출. 현재 언어 + appendix 언어의 items + 공유 자산을 로드.
  Future<void> ensureLoaded() async {
    final mainLang = AppConfig.languageCode;
    final langs = <String>[
      mainLang,
      ...LanguageRegistry.appendicesFor(mainLang),
    ];
    for (final lang in langs) {
      await _ensureItemsForLang(lang);
    }

    if (AppConfig.hasHanjaSupport) {
      await _ensureHanjaMaster();
      await _ensureHanjaRelated();
      switch (AppConfig.languageCode) {
        case 'zh':
          await _ensureHanziStudiesZh();
          await _ensureHanziRelatedZh();
          break;
        case 'ja':
          await _ensureHanziStudiesJp();
          await _ensureHanziRelatedJp();
          break;
      }
    }

    await _ensureEtymon();

    // Refresh in-memory word cache so consumers see the new rows.
    await word_data.loadWords();
  }

  Future<void> _ensureItemsForLang(String lang) async {
    final marker = _itemsKey(lang);
    if (await _db.getMeta(marker) == '1') return;

    final list = await _loadJsonList('assets/data/$lang/items.json');
    if (list == null) {
      if (kDebugMode) {
        debugPrint('[AssetSeedLoader] items.json missing for $lang — skip');
      }
      return;
    }

    final companions = <ItemsCompanion>[];
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        companions.add(_itemFromJson(r));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[AssetSeedLoader] item parse fail (${r['id']}): $e');
        }
      }
    }
    if (companions.isEmpty) return;
    await _db.upsertItems(companions);
    await _db.setMeta(marker, '1');
    if (kDebugMode) {
      debugPrint('[AssetSeedLoader] items[$lang] imported ${companions.length}');
    }
  }

  Future<void> _ensureHanjaMaster() async {
    final marker = '$_kHanjaMaster$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list = await _loadJsonList('assets/data/_shared/hanja_master.json');
    if (list == null) return;
    final rows = <HanjaMasterCompanion>[];
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        rows.add(HanjaMasterCompanion.insert(
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
          updatedAt: _parseUpdatedAt(r['updated_at']),
        ));
      } catch (_) {}
    }
    if (rows.isEmpty) return;
    await _db.upsertHanjaMaster(rows);
    await _db.setMeta(marker, '1');
  }

  Future<void> _ensureHanjaRelated() async {
    final marker = '$_kHanjaRelated$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list = await _loadJsonList('assets/data/_shared/hanja_related.json');
    if (list == null) return;
    final rows = <HanjaRelatedCompanion>[];
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        rows.add(HanjaRelatedCompanion.insert(
          source: r['source'] as String,
          related: r['related'] as String,
          relation: r['relation'] as String,
          position: Value((r['position'] as int?) ?? 0),
          note: Value((r['note'] as String?) ?? ''),
          addedBy: Value((r['added_by'] as String?) ?? ''),
          updatedAt: _parseUpdatedAt(r['updated_at']),
        ));
      } catch (_) {}
    }
    if (rows.isEmpty) return;
    await _db.upsertHanjaRelated(rows);
    await _db.setMeta(marker, '1');
  }

  Future<void> _ensureHanziStudiesZh() async {
    final marker = '$_kHanziStudiesZh$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list =
        await _loadJsonList('assets/data/_shared/hanzi_studies_zh.json');
    if (list == null) return;
    final rows = <HanziStudiesZhCompanion>[];
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        rows.add(HanziStudiesZhCompanion.insert(
          id: r['id'] as String,
          radical: r['radical'] as String,
          meaningKo: r['meaning_ko'] as String,
          pinyin: Value((r['pinyin'] as String?) ?? ''),
          tone: Value((r['tone'] as int?) ?? 0),
          description: Value((r['description'] as String?) ?? ''),
          sortOrder: Value((r['sort_order'] as int?) ?? 0),
          updatedAt: _parseUpdatedAt(r['updated_at']),
        ));
      } catch (_) {}
    }
    if (rows.isEmpty) return;
    await _db.upsertHanziStudiesZh(rows);
    await _db.setMeta(marker, '1');
  }

  Future<void> _ensureHanziRelatedZh() async {
    final marker = '$_kHanziRelatedZh$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list =
        await _loadJsonList('assets/data/_shared/hanzi_related_zh.json');
    if (list == null) return;
    // study_id 별로 그룹지어 replaceRelatedForStudyZh 호출
    final byStudy = <String, List<HanziRelatedZhCompanion>>{};
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        final studyId = r['study_id'] as String;
        byStudy.putIfAbsent(studyId, () => []).add(
              HanziRelatedZhCompanion.insert(
                studyId: studyId,
                character: r['character'] as String,
                pinyin: Value((r['pinyin'] as String?) ?? ''),
                tone: Value((r['tone'] as int?) ?? 0),
                meaningKo: r['meaning_ko'] as String,
                relationType: r['relation_type'] as String,
                position: Value((r['position'] as int?) ?? 0),
                note: Value((r['note'] as String?) ?? ''),
                updatedAt: _parseUpdatedAt(r['updated_at']),
              ),
            );
      } catch (_) {}
    }
    for (final entry in byStudy.entries) {
      await _db.replaceRelatedForStudyZh(entry.key, entry.value);
    }
    await _db.setMeta(marker, '1');
  }

  Future<void> _ensureHanziStudiesJp() async {
    final marker = '$_kHanziStudiesJp$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list =
        await _loadJsonList('assets/data/_shared/hanzi_studies_jp.json');
    if (list == null) return;
    final rows = <HanziStudiesJpCompanion>[];
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        rows.add(HanziStudiesJpCompanion.insert(
          id: r['id'] as String,
          radical: r['radical'] as String,
          meaningKo: r['meaning_ko'] as String,
          onyomi: Value((r['onyomi'] as String?) ?? ''),
          kunyomi: Value((r['kunyomi'] as String?) ?? ''),
          description: Value((r['description'] as String?) ?? ''),
          sortOrder: Value((r['sort_order'] as int?) ?? 0),
          updatedAt: _parseUpdatedAt(r['updated_at']),
        ));
      } catch (_) {}
    }
    if (rows.isEmpty) return;
    await _db.upsertHanziStudiesJp(rows);
    await _db.setMeta(marker, '1');
  }

  Future<void> _ensureHanziRelatedJp() async {
    final marker = '$_kHanziRelatedJp$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list =
        await _loadJsonList('assets/data/_shared/hanzi_related_jp.json');
    if (list == null) return;
    final byStudy = <String, List<HanziRelatedJpCompanion>>{};
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        final studyId = r['study_id'] as String;
        byStudy.putIfAbsent(studyId, () => []).add(
              HanziRelatedJpCompanion.insert(
                studyId: studyId,
                character: r['character'] as String,
                onyomi: Value((r['onyomi'] as String?) ?? ''),
                kunyomi: Value((r['kunyomi'] as String?) ?? ''),
                meaningKo: r['meaning_ko'] as String,
                relationType: r['relation_type'] as String,
                position: Value((r['position'] as int?) ?? 0),
                note: Value((r['note'] as String?) ?? ''),
                updatedAt: _parseUpdatedAt(r['updated_at']),
              ),
            );
      } catch (_) {}
    }
    for (final entry in byStudy.entries) {
      await _db.replaceRelatedForStudyJp(entry.key, entry.value);
    }
    await _db.setMeta(marker, '1');
  }

  Future<void> _ensureEtymon() async {
    final marker = '$_kEtymon$seedVersion';
    if (await _db.getMeta(marker) == '1') return;
    final list = await _loadJsonList('assets/data/_shared/etymon.json');
    if (list == null) return;
    final rows = <EtymonCompanion>[];
    for (final raw in list) {
      if (raw is! Map) continue;
      final r = raw.cast<String, dynamic>();
      try {
        rows.add(EtymonCompanion.insert(
          id: r['id'] as String,
          sourceLang: r['source_lang'] as String,
          root: r['root'] as String,
          meaningKo: r['meaning_ko'] as String,
          meaningEn: Value((r['meaning_en'] as String?) ?? ''),
          notes: Value((r['notes'] as String?) ?? ''),
          priority: Value((r['priority'] as int?) ?? 9),
          updatedAt: _parseUpdatedAt(r['updated_at']),
        ));
      } catch (_) {}
    }
    if (rows.isEmpty) return;
    await _db.upsertEtymon(rows);
    await _db.setMeta(marker, '1');
  }

  /// 콘텐츠 재import — items 시드 마커를 모두 비우고 items 테이블도 비우고
  /// 다시 로드. ProfileScreen "콘텐츠 재동기화" 버튼이 호출.
  Future<void> hardResyncItems() async {
    await _db.resetItemsSync();
    // SyncMeta 의 모든 seed_items_* 마커 제거
    await _clearItemsMarkers();
    await ensureLoaded();
  }

  Future<void> _clearItemsMarkers() async {
    // SyncMeta 에 직접 접근하는 helper가 없어 set으로 빈 문자열 덮기 (재 import에 1 만 보면 됨).
    // resetItemsSync 가 이미 items_watermark_* 만 지우므로 여기선 별도 처리 불필요.
    // setMeta 마커를 빈값으로 덮으면 ensureLoaded가 다시 import.
    final mainLang = AppConfig.languageCode;
    final langs = <String>[
      mainLang,
      ...LanguageRegistry.appendicesFor(mainLang),
    ];
    for (final lang in langs) {
      await _db.setMeta(_itemsKey(lang), '');
    }
  }

  Future<List<dynamic>?> _loadJsonList(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  ItemsCompanion _itemFromJson(Map<String, dynamic> r) {
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
      targetSouth: Value(r['target_south'] as String?),
      koreanSouth: Value(r['korean_south'] as String?),
      romanizationSouth: Value(r['romanization_south'] as String?),
      targetSpain: Value(r['target_spain'] as String?),
      koreanSpain: Value(r['korean_spain'] as String?),
      romanizationSpain: Value(r['romanization_spain'] as String?),
      tier: Value(r['tier'] as String?),
      dialogueOrder: Value((r['dialogue_order'] as int?) ?? 0),
      vocabHints: Value(r['vocab_hints'] == null
          ? null
          : (r['vocab_hints'] is String
              ? r['vocab_hints'] as String
              : jsonEncode(r['vocab_hints']))),
      isPolite: Value((r['is_polite'] as bool?) ?? false),
      applicableScenario: Value(r['applicable_scenario'] as int?),
      morphTags: Value(r['morph_tags'] == null
          ? null
          : (r['morph_tags'] is String
              ? r['morph_tags'] as String
              : jsonEncode(r['morph_tags']))),
      updatedAt: _parseUpdatedAt(r['updated_at']),
    );
  }

  DateTime _parseUpdatedAt(dynamic v) {
    if (v is String && v.isNotEmpty) {
      try {
        return DateTime.parse(v);
      } catch (_) {}
    }
    return DateTime.now().toUtc();
  }
}
