import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/word_data.dart' as word_data;
import '../db/app_database.dart';
import '../models/word.dart';
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';
import '../theme/app_colors.dart';
import 'admin_item_edit_screen.dart';

/// 관리자 — 대화 스크립트 하나를 전체 보면서 편집.
///   * 상단: 시나리오 편집 (저장 시 같은 그룹 모든 라인에 일괄 적용)
///   * 본문: A/B 채팅 풍선 리스트. 드래그 → 순서 변경 / 풍선 탭 → 라인 편집
///   * 각 풍선에 삭제 버튼, 하단에 "+라인 추가" 버튼
///
/// [slug] — 새 대화 세트 생성 후 진입 시 ID prefix 힌트. 기존 라인이 있으면
/// 그 id 에서 자동 추출되므로 slug는 빈 대화의 첫 라인 추가 시에만 사용.
class AdminDialogueEditScreen extends StatefulWidget {
  final int course;
  final String category;
  final String? slug;

  const AdminDialogueEditScreen({
    super.key,
    required this.course,
    required this.category,
    this.slug,
  });

  @override
  State<AdminDialogueEditScreen> createState() =>
      _AdminDialogueEditScreenState();
}

class _AdminDialogueEditScreenState extends State<AdminDialogueEditScreen> {
  late TextEditingController _scenario;
  String _originalScenario = '';
  bool _savingScenario = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final lines = _lines();
    _originalScenario = lines.isNotEmpty ? lines.first.scenario : '';
    _scenario = TextEditingController(text: _originalScenario);
  }

  @override
  void dispose() {
    _scenario.dispose();
    super.dispose();
  }

  List<Word> _lines() {
    return word_data.allItems
        .where((w) =>
            w.isDialogue &&
            w.course == widget.course &&
            w.category == widget.category)
        .toList()
      ..sort((a, b) => a.turnOrder.compareTo(b.turnOrder));
  }

  /// `ru:sent:l2_d01_t07` → `ru:sent:l2_d01` (turn suffix 제거된 공통 prefix).
  /// 기존 라인에서 추출. 없으면 slug 사용.
  String? _idPrefix() {
    final lines = _lines();
    if (lines.isNotEmpty) {
      final sample = lines.first.id;
      final idx = sample.lastIndexOf('_t');
      if (idx > 0) return sample.substring(0, idx);
    }
    if (widget.slug != null && widget.slug!.isNotEmpty) {
      return 'ru:sent:l${widget.course}_${widget.slug}';
    }
    return null;
  }

  Future<void> _saveScenario() async {
    final newScenario = _scenario.text;
    if (newScenario == _originalScenario) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시나리오 변경 없음')),
      );
      return;
    }
    final lines = _lines();
    setState(() => _savingScenario = true);
    try {
      for (final w in lines) {
        await SupabaseService.instance.db
            .updateItemFields(w.id, scenario: newScenario);
        word_data.updateLocalFields(w.id, scenario: newScenario);
        await SyncService.instance
            .pushItemFields(w.id, {'scenario': newScenario});
      }
      _originalScenario = newScenario;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('시나리오 ${lines.length}개 라인에 적용됨',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.successDark,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장 실패: $e',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _savingScenario = false);
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    final lines = _lines();
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex == newIndex) return;

    final moved = lines.removeAt(oldIndex);
    lines.insert(newIndex, moved);

    setState(() => _busy = true);
    try {
      // turn_order 전체 재배정 (1-based).
      for (var i = 0; i < lines.length; i++) {
        final w = lines[i];
        final newOrder = i + 1;
        if (w.turnOrder == newOrder) continue;
        await SupabaseService.instance.db
            .updateItemFields(w.id, turnOrder: newOrder);
        word_data.updateLocalFields(w.id, turnOrder: newOrder);
        await SyncService.instance
            .pushItemFields(w.id, {'turn_order': newOrder});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('순서 저장 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteLine(Word w) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('라인 삭제'),
        content: Text('이 라인을 삭제하시겠어요?\n${w.targetPlain}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await SupabaseService.instance.db.deleteItemById(w.id);
      word_data.removeLocalItem(w.id);
      await SyncService.instance.pushItemDelete(w.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제 완료')),
      );
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addLine() async {
    final prefix = _idPrefix();
    if (prefix == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID prefix를 결정할 수 없음. slug 필요.')),
      );
      return;
    }
    final result = await showModalBottomSheet<_NewLineDraft>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _NewLineSheet(existingLines: _lines().length),
    );
    if (result == null) return;

    final nextTurn = _lines().isEmpty
        ? 1
        : _lines().last.turnOrder + 1;
    final newId = '${prefix}_t${nextTurn.toString().padLeft(2, '0')}';

    setState(() => _busy = true);
    try {
      // Drift insert
      await SupabaseService.instance.db.insertItem(
        ItemsCompanion.insert(
          id: newId,
          type: 'sentence',
          targetText: result.target,
          korean: result.korean,
          updatedAt: DateTime.now().toUtc(),
          romanization: Value(result.romanization),
          category: Value(widget.category),
          course: Value(widget.course),
          tagsCsv: const Value('new'),
          notes: Value(result.notes),
          comment: const Value(''),
          relatedCsv: const Value(''),
          speaker: Value(result.speaker),
          turnOrder: Value(nextTurn),
          scenario: Value(_scenario.text),
        ),
      );
      // in-memory
      word_data.addLocalItem(Word(
        id: newId,
        type: ItemType.sentence,
        target: result.target,
        korean: result.korean,
        romanization: result.romanization,
        category: widget.category,
        course: widget.course,
        tags: const {'new'},
        notes: result.notes,
        comment: '',
        relatedCsv: '',
        speaker: result.speaker,
        turnOrder: nextTurn,
        scenario: _scenario.text,
      ));
      // Supabase
      await SyncService.instance.pushItemInsert({
        'id': newId,
        'type': 'sentence',
        'target_text': result.target,
        'korean': result.korean,
        'romanization': result.romanization,
        'category': widget.category,
        'course': widget.course,
        'tags': ['new'],
        'notes': result.notes,
        'comment': '',
        'related_csv': '',
        'speaker': result.speaker,
        'turn_order': nextTurn,
        'scenario': _scenario.text,
        'language_code': 'ru',
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('라인 추가됨')),
      );
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('추가 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = _lines();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('L${widget.course} · ${widget.category}',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _scenarioBlock(),
          const Divider(height: 1),
          Expanded(
            child: lines.isEmpty
                ? const Center(
                    child: Text('라인 없음 — 아래 버튼으로 추가',
                        style: TextStyle(color: AppColors.textSecondary)))
                : ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    itemCount: lines.length,
                    onReorder: _onReorder,
                    buildDefaultDragHandles: false,
                    itemBuilder: (ctx, i) {
                      final w = lines[i];
                      return KeyedSubtree(
                        key: ValueKey(w.id),
                        child: _BubbleRow(
                          index: i,
                          word: w,
                          onEdit: () async {
                            await Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminItemEditScreen(itemId: w.id),
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                          onDelete: () => _deleteLine(w),
                        ),
                      );
                    },
                  ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _scenarioBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.theater_comedy,
                  size: 16, color: AppColors.purple),
              const SizedBox(width: 6),
              Text('시나리오 (전체 라인 공유)',
                  style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
              const Spacer(),
              TextButton(
                onPressed: _savingScenario ? null : _saveScenario,
                child: Text(
                  _savingScenario ? '저장 중...' : '시나리오 저장',
                  style: GoogleFonts.notoSans(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _scenario,
            minLines: 1,
            maxLines: 3,
            style: GoogleFonts.notoSans(fontSize: 13),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: ElevatedButton.icon(
          onPressed: _busy ? null : _addLine,
          icon: const Icon(Icons.add, size: 18),
          label: Text(_busy ? '작업 중...' : '+ 라인 추가',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.brandColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 44),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class _BubbleRow extends StatelessWidget {
  final int index;
  final Word word;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BubbleRow({
    required this.index,
    required this.word,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isA = word.speaker == 'A';
    final bubbleColor =
        isA ? Colors.white : AppConfig.brandColor.withValues(alpha: 0.12);
    final borderColor = isA
        ? AppColors.cardBorder
        : AppConfig.brandColor.withValues(alpha: 0.4);

    final bubble = GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isA ? 4 : 12),
            bottomRight: Radius.circular(isA ? 12 : 4),
          ),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('#${word.turnOrder}',
                    style: GoogleFonts.notoSans(
                        fontSize: 9, color: AppColors.textMuted)),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 11, color: AppColors.textMuted),
                if (word.comment.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.sticky_note_2,
                      size: 11, color: AppColors.warning),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(word.targetPlain,
                style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            if (word.romanization.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(word.romanization,
                  style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 3),
            Text(word.korean,
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );

    final controls = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle,
              size: 18, color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onDelete,
          child: const Icon(Icons.delete_outline,
              size: 18, color: AppColors.danger),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isA ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isA) _speakerBadge('A', AppColors.success),
          if (isA) const SizedBox(width: 6),
          Flexible(child: bubble),
          const SizedBox(width: 6),
          controls,
          if (!isA) const SizedBox(width: 6),
          if (!isA) _speakerBadge('B', AppConfig.brandColor),
        ],
      ),
    );
  }

  Widget _speakerBadge(String label, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(label,
            style: GoogleFonts.notoSans(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _NewLineDraft {
  final String speaker;
  final String target;
  final String korean;
  final String romanization;
  final String notes;

  const _NewLineDraft({
    required this.speaker,
    required this.target,
    required this.korean,
    required this.romanization,
    required this.notes,
  });
}

class _NewLineSheet extends StatefulWidget {
  final int existingLines;
  const _NewLineSheet({required this.existingLines});

  @override
  State<_NewLineSheet> createState() => _NewLineSheetState();
}

class _NewLineSheetState extends State<_NewLineSheet> {
  String _speaker = 'A';
  final _target = TextEditingController();
  final _korean = TextEditingController();
  final _romanization = TextEditingController();
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default next speaker = opposite of 마지막 (turn 수 홀/짝 기준).
    _speaker = widget.existingLines.isOdd ? 'B' : 'A';
  }

  @override
  void dispose() {
    _target.dispose();
    _korean.dispose();
    _romanization.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('+ 라인 추가',
              style: GoogleFonts.notoSans(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('화자',
                  style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              ChoiceChip(
                label: const Text('A'),
                selected: _speaker == 'A',
                onSelected: (_) => setState(() => _speaker = 'A'),
                selectedColor: AppColors.success.withValues(alpha: 0.18),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('B'),
                selected: _speaker == 'B',
                onSelected: (_) => setState(() => _speaker = 'B'),
                selectedColor:
                    AppConfig.brandColor.withValues(alpha: 0.18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _tf('Target (러시아어)', _target, maxLines: 3),
          _tf('Korean (한국어)', _korean, maxLines: 2),
          _tf('Romanization (한글 독음)', _romanization),
          _tf('Notes (학습자 메모)', _notes, maxLines: 2),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_target.text.trim().isEmpty ||
                      _korean.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Target/Korean 필수')),
                    );
                    return;
                  }
                  Navigator.of(context).pop(_NewLineDraft(
                    speaker: _speaker,
                    target: _target.text,
                    korean: _korean.text,
                    romanization: _romanization.text,
                    notes: _notes.text,
                  ));
                },
                child: const Text('추가'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tf(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.notoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 3),
          TextField(
            controller: c,
            minLines: 1,
            maxLines: maxLines,
            style: GoogleFonts.notoSans(fontSize: 13),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
