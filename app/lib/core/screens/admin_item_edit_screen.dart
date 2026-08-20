import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/word_data.dart' as word_data;
import '../models/word.dart';
import '../services/sync_service.dart';
import '../services/tts_service.dart';
import '../supabase/supabase_service.dart';
import '../theme/app_colors.dart';

/// 관리자 전용 — 단발 항목/대화 라인 하나의 모든 편집 가능 필드를 수정.
/// comment 에는 [검수완료] 등 태그를 자동 주입/제거 (체크박스 UI).
class AdminItemEditScreen extends StatefulWidget {
  final String itemId;
  const AdminItemEditScreen({super.key, required this.itemId});

  @override
  State<AdminItemEditScreen> createState() => _AdminItemEditScreenState();
}

class _AdminItemEditScreenState extends State<AdminItemEditScreen> {
  /// 검수 상태를 표현하는 태그. comment 안에 `[태그명]` 형태로 저장.
  static const List<String> _reviewTags = [
    '검수완료',
    '톤재검토',
    '번역재확인',
    '독음재확인',
  ];
  static final RegExp _tagPattern = RegExp(r'\[([^\]]+)\]');

  late final Word _original;
  late final TextEditingController _target;
  late final TextEditingController _korean;
  late final TextEditingController _romanization;
  late final TextEditingController _category;
  late final TextEditingController _notes;
  /// 태그를 제외한 자유 텍스트만 담는 controller.
  late final TextEditingController _commentFree;
  late final TextEditingController _relatedCsv;
  late final TextEditingController _rootRefs;
  late int _course;
  /// 체크 상태인 태그 집합. comment 저장 시 `[태그]` 로 직렬화.
  final Set<String> _checkedTags = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final w = word_data.allItems.firstWhere((w) => w.id == widget.itemId);
    _original = w;
    _target = TextEditingController(text: w.target);
    _korean = TextEditingController(text: w.korean);
    _romanization = TextEditingController(text: w.romanization);
    _category = TextEditingController(text: w.category);
    _notes = TextEditingController(text: w.notes);
    _relatedCsv = TextEditingController(text: w.relatedCsv);
    _rootRefs = TextEditingController(text: w.rootRefs);
    _course = w.course;

    // comment 를 (태그들, 자유 텍스트) 로 분리.
    final commentTags = _tagPattern
        .allMatches(w.comment)
        .map((m) => m.group(1)!)
        .toSet();
    _checkedTags.addAll(commentTags.where(_reviewTags.contains));
    _commentFree = TextEditingController(
      text: w.comment.replaceAll(_tagPattern, '').trim(),
    );
  }

  @override
  void dispose() {
    _target.dispose();
    _korean.dispose();
    _romanization.dispose();
    _category.dispose();
    _notes.dispose();
    _commentFree.dispose();
    _relatedCsv.dispose();
    _rootRefs.dispose();
    super.dispose();
  }

  /// 체크된 태그 + 자유 텍스트를 하나의 comment 문자열로 직렬화.
  String _serializeComment() {
    final tagsPart =
        _checkedTags.map((t) => '[$t]').toList()..sort();
    final parts = <String>[
      ...tagsPart,
      if (_commentFree.text.trim().isNotEmpty) _commentFree.text.trim(),
    ];
    return parts.join(' ');
  }

  Map<String, dynamic> _diffForSupabase() {
    final m = <String, dynamic>{};
    if (_target.text != _original.target) m['target_text'] = _target.text;
    if (_korean.text != _original.korean) m['korean'] = _korean.text;
    if (_romanization.text != _original.romanization) {
      m['romanization'] = _romanization.text;
    }
    if (_category.text != _original.category) m['category'] = _category.text;
    if (_course != _original.course) m['course'] = _course;
    if (_notes.text != _original.notes) m['notes'] = _notes.text;
    final newComment = _serializeComment();
    if (newComment != _original.comment) m['comment'] = newComment;
    if (_relatedCsv.text != _original.relatedCsv) {
      m['related_csv'] = _relatedCsv.text;
    }
    if (_rootRefs.text != _original.rootRefs) {
      m['root_refs'] = _rootRefs.text;
    }
    return m;
  }

  Future<void> _save() async {
    final diff = _diffForSupabase();
    if (diff.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('변경 사항 없음')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await SupabaseService.instance.db.updateItemFields(
        widget.itemId,
        targetText: diff['target_text'] as String?,
        korean: diff['korean'] as String?,
        romanization: diff['romanization'] as String?,
        category: diff['category'] as String?,
        course: diff['course'] as int?,
        notes: diff['notes'] as String?,
        comment: diff['comment'] as String?,
        relatedCsv: diff['related_csv'] as String?,
        rootRefs: diff['root_refs'] as String?,
      );
      word_data.updateLocalFields(
        widget.itemId,
        target: diff['target_text'] as String?,
        korean: diff['korean'] as String?,
        romanization: diff['romanization'] as String?,
        category: diff['category'] as String?,
        course: diff['course'] as int?,
        notes: diff['notes'] as String?,
        comment: diff['comment'] as String?,
        relatedCsv: diff['related_csv'] as String?,
        rootRefs: diff['root_refs'] as String?,
      );
      await SyncService.instance.pushItemFields(widget.itemId, diff);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('저장 완료'),
          backgroundColor: AppColors.successDark,
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장 실패: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('항목 편집',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              _saving ? '저장 중...' : '저장',
              style: GoogleFonts.notoSans(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _idChip(_original.id),
          const SizedBox(height: 16),
          _targetFieldWithTts(),
          _field('Korean (한국어)', _korean, minLines: 1, maxLines: 3),
          _field('Romanization (한글 독음)', _romanization),
          _courseDropdown(),
          _field('Category', _category),
          _field('Notes (학습자 메모)', _notes, minLines: 1, maxLines: 4),
          _reviewTagsBlock(),
          _field('Comment 자유 메모', _commentFree, minLines: 1, maxLines: 4),
          _field('Related CSV (관련단어)', _relatedCsv),
          _field('Root refs (어원 · han:愛 또는 lat:am CSV)', _rootRefs),
        ],
      ),
    );
  }

  Widget _idChip(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(id,
          style: GoogleFonts.robotoMono(
              fontSize: 11, color: AppColors.textSecondary)),
    );
  }

  Widget _targetFieldWithTts() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Target (러시아어)',
                  style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  final plain = _target.text.replaceAllMapped(
                    RegExp(r'\{[^{}:]+:([^{}]+)\}'),
                    (m) => m.group(1)!,
                  );
                  TtsService.instance.speak(plain);
                },
                icon: const Icon(Icons.volume_up, size: 20),
                color: AppConfig.brandColor,
                tooltip: '미리듣기',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _target,
            minLines: 1,
            maxLines: 3,
            style: GoogleFonts.notoSans(fontSize: 14),
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

  Widget _field(String label, TextEditingController c,
      {int minLines = 1, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(
            controller: c,
            minLines: minLines,
            maxLines: maxLines,
            style: GoogleFonts.notoSans(fontSize: 14),
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

  Widget _reviewTagsBlock() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('검수 상태',
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final tag in _reviewTags)
                FilterChip(
                  label: Text(tag,
                      style: GoogleFonts.notoSans(fontSize: 12)),
                  selected: _checkedTags.contains(tag),
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _checkedTags.add(tag);
                      } else {
                        _checkedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor:
                      AppConfig.brandColor.withValues(alpha: 0.18),
                  checkmarkColor: AppConfig.brandColor,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _courseDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Course',
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          DropdownButtonFormField<int>(
            initialValue: _course,
            items: const [
              DropdownMenuItem(value: 1, child: Text('L1 필수')),
              DropdownMenuItem(value: 2, child: Text('L2 채팅')),
              DropdownMenuItem(value: 3, child: Text('L3 연애')),
              DropdownMenuItem(value: 4, child: Text('L4 여행')),
              DropdownMenuItem(value: 5, child: Text('L5 취미·팬덤')),
              DropdownMenuItem(value: 6, child: Text('L6 Midnight Lounge')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _course = v);
            },
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
}
