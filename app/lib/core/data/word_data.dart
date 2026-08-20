import '../config/app_config.dart';
import '../config/language_registry.dart';
import '../db/app_database.dart';
import '../models/word.dart';
import '../services/subscription_service.dart';
import '../services/tier_service.dart';
import '../supabase/supabase_service.dart';

/// In-memory cache of all items, populated once from the Drift DB at startup
/// (see [loadWords]). Keeps reads O(1) for screens — matches the old
/// CSV-era perf characteristics while letting content come from Supabase.
List<Word> _all = [];

List<Word> get allItems => _all;

List<Word> get wordData =>
    _all.where((w) => w.type == ItemType.word).toList();

List<Word> get sentences =>
    _all.where((w) => w.type == ItemType.sentence).toList();

List<Word> get phrases =>
    _all.where((w) => w.type == ItemType.phrase).toList();

List<String> get categories =>
    _all.map((w) => w.category).toSet().toList()..sort();

/// Free users see only non-premium words; premium sees all.
Iterable<Word> _filterBySubscription(Iterable<Word> source) {
  if (SubscriptionService.instance.isPremium) return source;
  return source.where((w) => !w.isPremium);
}

/// 현재 선택된 tier 로 필터. tier=NULL 항목은 통과시켜 graceful fallback —
/// `seed_tier_*.sql` 가 일부만 적용된 상태에서도 콘텐츠가 0 으로 보이지 않도록.
/// 모든 항목에 tier 가 박히면 자연스럽게 엄격한 필터가 됨.
Iterable<Word> _filterByTier(Iterable<Word> source) {
  final selected = TierService.instance.tier.value.name;
  return source.where((w) => w.tier == null || w.tier == selected);
}

/// Flashcard pool — tier + premium-gated.
List<Word> flashcardPool() => _filterBySubscription(
      _filterByTier(_all.where((w) => w.type != ItemType.phrase)),
    ).toList();

/// All flashcard-eligible words regardless of subscription, used by
/// course-picker UI to surface locked-course options. Tier 필터는 적용.
List<Word> flashcardPoolAll() =>
    _filterByTier(_all.where((w) => w.type != ItemType.phrase)).toList();

/// Keyboard pool — NEVER gated (always free, per product decision).
/// Tier 필터는 적용 (선택된 난이도의 단어/문장만).
///
/// 포함 대상:
///   * 단어 (type=word, 길이 ≤ maxLen) — 기본
///   * L1·L2 회화 문장 (type=sentence, course ∈ {1,2}, 길이 ≤ 80)
///     → 키보드 연습용 짧은 일상 표현 타이핑
List<Word> keyboardPool({int maxLen = 6, int sentenceMaxLen = 80}) =>
    _filterByTier(_all).where((w) {
      if (w.type == ItemType.word) {
        return w.targetPlain.length <= maxLen;
      }
      if (w.type == ItemType.sentence &&
          (w.course == 1 || w.course == 2) &&
          w.targetPlain.length <= sentenceMaxLen) {
        return true;
      }
      return false;
    }).toList();

/// Conversation pool — tier + premium-gated.
List<Word> conversationPool() => _filterBySubscription(
      _filterByTier(_all.where(
          (w) => w.type == ItemType.sentence || w.type == ItemType.phrase)),
    ).toList();

/// All conversation-eligible items regardless of subscription. Tier 필터 적용.
List<Word> conversationPoolAll() => _filterByTier(_all
    .where((w) => w.type == ItemType.sentence || w.type == ItemType.phrase))
    .toList();

/// Count how many words are locked behind premium (for UI hints).
int premiumLockedCount({required bool conversation}) {
  final source = conversation
      ? _all.where(
          (w) => w.type == ItemType.sentence || w.type == ItemType.phrase)
      : _all.where((w) => w.type != ItemType.phrase);
  return source.where((w) => w.isPremium).length;
}

/// Rehydrate the in-memory cache from the local Drift DB.
/// Call this once at app start and again after a successful items sync.
///
/// Also loads appendix language rows (e.g. id → ms) so the appendix menu
/// on CourseSelectScreen can show counts and the user can drill in.
Future<void> loadWords() async {
  final rows = await SupabaseService.instance.db.allItems();
  final mainLang = AppConfig.languageCode;
  final appendices = LanguageRegistry.appendicesFor(mainLang);
  final allowedPrefixes = <String>[
    '$mainLang:',
    for (final a in appendices) '$a:',
  ];
  _all = rows
      .where((r) => allowedPrefixes.any((p) => r.id.startsWith(p)))
      .map(_rowToWord)
      .toList();
}

/// 부록(appendix) 언어의 pool만 필터. 비어있으면 부록 카드를 숨김.
List<Word> appendixPool(String appendixLang) =>
    _all.where((w) => w.id.startsWith('$appendixLang:')).toList();

Word _rowToWord(Item row) {
  final tags = row.tagsCsv.isEmpty
      ? <String>{}
      : row.tagsCsv.split(',').map((t) => t.trim()).toSet();
  return Word(
    id: row.id,
    type: itemTypeFrom(row.type),
    target: row.targetText,
    korean: row.korean,
    romanization: row.romanization,
    category: row.category,
    course: row.course,
    tags: tags,
    notes: row.notes,
    comment: row.comment,
    relatedCsv: row.relatedCsv,
    rootRefs: row.rootRefs,
    speaker: row.speaker,
    turnOrder: row.turnOrder,
    scenario: row.scenario,
    targetSouth: row.targetSouth,
    koreanSouth: row.koreanSouth,
    romanizationSouth: row.romanizationSouth,
    targetSpain: row.targetSpain,
    koreanSpain: row.koreanSpain,
    romanizationSpain: row.romanizationSpain,
    tier: row.tier,
    isPolite: row.isPolite,
    applicableScenario: row.applicableScenario,
    morphTags: row.morphTags,
  );
}

/// Lookup helper for the flashcard's related-words mini cards.
/// Matches by [Word.targetPlain] (markers stripped), case-sensitive,
/// trimmed. Returns null when nothing matches in the current language pool.
Word? findByTargetText(String text) {
  final needle = text.trim();
  if (needle.isEmpty) return null;
  for (final w in _all) {
    if (w.targetPlain.trim() == needle) return w;
  }
  return null;
}

/// Replace one item in the in-memory cache with a comment-updated copy.
/// Called by the memo editor after it persists to Drift + Supabase, so the
/// next render reflects the new comment without a full reload.
void updateLocalComment(String id, String newComment) {
  updateLocalFields(id, comment: newComment);
}

/// Admin — append a new Word to the in-memory cache (not sorted; caller
/// typically re-queries the list from allItems).
void addLocalItem(Word w) {
  _all.add(w);
}

/// Admin — remove a Word from the in-memory cache by id.
void removeLocalItem(String id) {
  _all.removeWhere((w) => w.id == id);
}

/// Generic in-memory update — replace any subset of a Word's fields.
/// Used by the admin curriculum editor.
void updateLocalFields(
  String id, {
  String? target,
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
}) {
  for (var i = 0; i < _all.length; i++) {
    final w = _all[i];
    if (w.id != id) continue;
    _all[i] = Word(
      id: w.id,
      type: w.type,
      target: target ?? w.target,
      korean: korean ?? w.korean,
      romanization: romanization ?? w.romanization,
      category: category ?? w.category,
      course: course ?? w.course,
      tags: w.tags,
      notes: notes ?? w.notes,
      comment: comment ?? w.comment,
      relatedCsv: relatedCsv ?? w.relatedCsv,
      rootRefs: rootRefs ?? w.rootRefs,
      speaker: speaker ?? w.speaker,
      turnOrder: turnOrder ?? w.turnOrder,
      scenario: scenario ?? w.scenario,
      targetSouth: w.targetSouth,
      koreanSouth: w.koreanSouth,
      romanizationSouth: w.romanizationSouth,
      targetSpain: w.targetSpain,
      koreanSpain: w.koreanSpain,
      romanizationSpain: w.romanizationSpain,
      tier: w.tier,
      isPolite: w.isPolite,
      applicableScenario: w.applicableScenario,
      morphTags: w.morphTags,
    );
    return;
  }
}
