import '../db/app_database.dart';
import '../supabase/supabase_service.dart';

/// Convenience bundle: one center radical + its related characters.
class HanziStudyBundle {
  final HanziStudyZhRow study;
  final List<HanziRelatedZhRow> related;

  const HanziStudyBundle({required this.study, required this.related});
}

/// Reads hanzi study content from the local Drift DB.
/// Content is read-only on the client — writes come from sync only.
class HanziStudyRepo {
  static final HanziStudyRepo _instance = HanziStudyRepo._();
  factory HanziStudyRepo() => _instance;
  HanziStudyRepo._();

  AppDatabase get _db => SupabaseService.instance.db;

  Future<List<HanziStudyZhRow>> list() => _db.allHanziStudiesZh();

  Future<HanziStudyBundle?> load(String studyId) async {
    final study = await _db.hanziStudyZhById(studyId);
    if (study == null) return null;
    final related = await _db.relatedForStudyZh(studyId);
    return HanziStudyBundle(study: study, related: related);
  }

  /// 단어외우기에서 한자 한 글자를 탭했을 때 해당 부수의 studyId 를 찾는다.
  /// radical 컬럼 exact match — 없으면 null 반환 (해당 글자에 학습 콘텐츠 없음).
  Future<HanziStudyZhRow?> findByRadical(String character) async {
    final all = await _db.allHanziStudiesZh();
    for (final row in all) {
      if (row.radical == character) return row;
    }
    return null;
  }
}
