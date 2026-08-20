import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_service.dart';
import '../config/app_config.dart';
import '../db/app_database.dart' hide UserStats, UserProgress;
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';
import '../theme/app_colors.dart';

/// 관리자 전용 — 한자 마스터(5,978자) 큐레이션 화면.
/// 검색 → 한자 선택 → 중요도/메모/음매핑 편집.
class AdminHanjaScreen extends StatefulWidget {
  const AdminHanjaScreen({super.key});

  @override
  State<AdminHanjaScreen> createState() => _AdminHanjaScreenState();
}

class _AdminHanjaScreenState extends State<AdminHanjaScreen> {
  final TextEditingController _query = TextEditingController();
  Timer? _debounce;
  List<HanjaMasterRow> _results = const [];
  bool _loading = true;

  AppDatabase get _db => SupabaseService.instance.db;

  @override
  void initState() {
    super.initState();
    _runSearch('');
    _query.addListener(_onQueryChange);
  }

  @override
  void dispose() {
    _query.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      _runSearch(_query.text);
    });
  }

  Future<void> _runSearch(String q) async {
    setState(() => _loading = true);
    final rows = await _db.searchHanja(q, limit: 60);
    if (!mounted) return;
    setState(() {
      _results = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text('한자 편집',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _query,
              decoration: InputDecoration(
                isDense: true,
                hintText: '한자 / 음 / 뜻 검색 (예: 田, 전, 밭)',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _query.clear();
                          _runSearch('');
                        },
                      ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('일치하는 한자 없음'),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, i) =>
                    _HanjaListTile(row: _results[i], onChanged: () {
                  // 편집 후 돌아오면 결과 리스트 갱신.
                  _runSearch(_query.text);
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _HanjaListTile extends StatelessWidget {
  final HanjaMasterRow row;
  final VoidCallback onChanged;
  const _HanjaListTile({required this.row, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: SizedBox(
        width: 44,
        child: Text(row.korHanja,
            style: GoogleFonts.notoSans(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
      title: Text(
        '${row.korMeaning} ${row.korSound}'.trim(),
        style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
      subtitle: Text(
        [
          if (row.korLevel.isNotEmpty) '한자 ${row.korLevel}',
          if (row.jlptLevel != null) 'JLPT ${row.jlptLevel}',
          if (row.hskLevel != null) 'HSK ${row.hskLevel}',
          if (row.radical.isNotEmpty) '부수 ${row.radical}',
          '${row.strokeTotal}획',
        ].join(' · '),
        style: GoogleFonts.notoSans(
            fontSize: 11, color: AppColors.textSecondary),
      ),
      trailing: row.importance != null
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppConfig.brandColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('★ ${row.importance}',
                  style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.brandColor)),
            )
          : null,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdminHanjaEditScreen(korHanja: row.korHanja),
          ),
        );
        onChanged();
      },
    );
  }
}

/// 단일 한자 편집 화면.
class AdminHanjaEditScreen extends StatefulWidget {
  final String korHanja;
  const AdminHanjaEditScreen({super.key, required this.korHanja});

  @override
  State<AdminHanjaEditScreen> createState() => _AdminHanjaEditScreenState();
}

class _AdminHanjaEditScreenState extends State<AdminHanjaEditScreen> {
  HanjaMasterRow? _row;
  List<HanjaMasterRow> _radicalPeers = const [];
  List<HanjaRelatedRow> _phoneticRel = const [];
  int? _importance;
  final TextEditingController _note = TextEditingController();
  bool _saving = false;

  AppDatabase get _db => SupabaseService.instance.db;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final row = await _db.hanjaByKor(widget.korHanja);
    if (row == null) return;
    final phonetic =
        await _db.hanjaRelatedFor(widget.korHanja, relation: 'phonetic');
    final peers = row.radical.isEmpty
        ? const <HanjaMasterRow>[]
        : await _db.hanjaByRadical(row.radical,
            excludeKorHanja: widget.korHanja);
    setState(() {
      _row = row;
      _importance = row.importance;
      _note.text = row.noteAdmin;
      _radicalPeers = peers;
      _phoneticRel = phonetic
        ..sort((a, b) => a.position.compareTo(b.position));
    });
  }

  Future<void> _addPhonetic() async {
    final picked = await showDialog<HanjaMasterRow>(
      context: context,
      builder: (_) => const _PickHanjaDialog(),
    );
    if (picked == null) return;
    if (_phoneticRel.any((r) => r.related == picked.korHanja)) return;
    setState(() {
      _phoneticRel = [
        ..._phoneticRel,
        HanjaRelatedRow(
          id: -DateTime.now().millisecondsSinceEpoch, // temp id
          source: widget.korHanja,
          related: picked.korHanja,
          relation: 'phonetic',
          position: _phoneticRel.length,
          note: '',
          addedBy: 'user',
          updatedAt: DateTime.now(),
        ),
      ];
    });
  }

  void _removePhonetic(int idx) {
    setState(() {
      final next = [..._phoneticRel];
      next.removeAt(idx);
      // position 재정렬
      for (var i = 0; i < next.length; i++) {
        next[i] = HanjaRelatedRow(
          id: next[i].id,
          source: next[i].source,
          related: next[i].related,
          relation: next[i].relation,
          position: i,
          note: next[i].note,
          addedBy: next[i].addedBy,
          updatedAt: next[i].updatedAt,
        );
      }
      _phoneticRel = next;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final addedBy = AuthService.instance.currentUser?.email ?? 'admin';
    try {
      // 1) hanja_master importance/note 업데이트
      await _db.setHanjaCuration(
        korHanja: widget.korHanja,
        importance: _importance,
        noteAdmin: _note.text,
      );
      await SyncService.instance.pushHanjaCuration(
        korHanja: widget.korHanja,
        importance: _importance,
        noteAdmin: _note.text,
      );
      // 2) phonetic 매핑 전체 교체
      final companions = _phoneticRel
          .asMap()
          .entries
          .map((e) => HanjaRelatedCompanion.insert(
                source: widget.korHanja,
                related: e.value.related,
                relation: 'phonetic',
                position: Value(e.key),
                addedBy: Value(addedBy),
                updatedAt: DateTime.now().toUtc(),
              ))
          .toList();
      await _db.replaceHanjaRelated(
          source: widget.korHanja,
          relation: 'phonetic',
          rows: companions);
      await SyncService.instance.pushHanjaPhoneticReplace(
        source: widget.korHanja,
        addedBy: addedBy,
        rows: _phoneticRel
            .asMap()
            .entries
            .map((e) => (
                  related: e.value.related,
                  position: e.key,
                  note: e.value.note,
                ))
            .toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장됐어요')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final row = _row;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text('한자 편집 · ${widget.korHanja}',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold)),
        actions: [
          if (row != null)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('저장',
                      style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.bold,
                          color: AppConfig.brandColor)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: row == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _meta(row),
                  const SizedBox(height: 20),
                  _importanceBlock(),
                  const SizedBox(height: 20),
                  _noteBlock(),
                  const SizedBox(height: 20),
                  _radicalBlock(),
                  const SizedBox(height: 20),
                  _phoneticBlock(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
    );
  }

  Widget _meta(HanjaMasterRow row) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(row.korHanja,
              style: GoogleFonts.notoSans(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.0)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${row.korMeaning} ${row.korSound}'.trim(),
                    style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _badge('한자 ${row.korLevel.isEmpty ? "?" : row.korLevel}'),
                    _badge('부수 ${row.radical.isEmpty ? "?" : row.radical}'),
                    _badge('${row.strokeTotal}획'),
                    _badge('priority ${row.priority}'),
                    if (row.jlptLevel != null) _badge('JLPT ${row.jlptLevel}'),
                    if (row.hskLevel != null) _badge('HSK ${row.hskLevel}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _importanceBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('중요도 (importance)',
                style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            if (_importance != null)
              TextButton(
                onPressed: () => setState(() => _importance = null),
                child: const Text('지움'),
              ),
          ],
        ),
        Slider(
          value: (_importance ?? 0).toDouble(),
          min: 0,
          max: 5,
          divisions: 5,
          label: _importance == null ? '미지정' : '$_importance',
          onChanged: (v) {
            setState(() => _importance = v.round() == 0 ? null : v.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('미지정',
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: AppColors.textMuted)),
            for (var i = 1; i <= 5; i++)
              Text('$i',
                  style: GoogleFonts.notoSans(
                      fontSize: 11,
                      fontWeight: _importance == i
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _importance == i
                          ? AppConfig.brandColor
                          : AppColors.textMuted)),
          ],
        ),
      ],
    );
  }

  Widget _noteBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('관리자 메모 (학습자 비공개)',
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: _note,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '학습 순서, 예문 아이디어, 큐레이션 메모…',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _radicalBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('부수 연관 (자동 계산 · 읽기 전용)',
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        if (_radicalPeers.isEmpty)
          Text('— 같은 부수의 다른 한자가 없습니다',
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppColors.textMuted))
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final r in _radicalPeers) _readonlyChip(r.korHanja),
            ],
          ),
      ],
    );
  }

  Widget _phoneticBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('음 연관 (사용자 큐레이션)',
                style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            TextButton.icon(
              onPressed: _phoneticRel.length >= 8 ? null : _addPhonetic,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('추가'),
            ),
          ],
        ),
        if (_phoneticRel.isEmpty)
          Text('— 음으로 연관된 한자를 추가해보세요',
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppColors.textMuted))
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < _phoneticRel.length; i++)
                _editableChip(_phoneticRel[i].related, () => _removePhonetic(i)),
            ],
          ),
      ],
    );
  }

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(text,
            style: GoogleFonts.notoSans(
                fontSize: 11, color: AppColors.textSecondary)),
      );

  Widget _readonlyChip(String char) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        alignment: Alignment.center,
        child: Text(char,
            style: GoogleFonts.notoSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      );

  Widget _editableChip(String char, VoidCallback onRemove) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppConfig.brandColor.withValues(alpha: 0.4),
                width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(char,
              style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.brandColor)),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

/// 한자 추가 다이얼로그 — 검색 후 선택.
class _PickHanjaDialog extends StatefulWidget {
  const _PickHanjaDialog();

  @override
  State<_PickHanjaDialog> createState() => _PickHanjaDialogState();
}

class _PickHanjaDialogState extends State<_PickHanjaDialog> {
  final TextEditingController _query = TextEditingController();
  Timer? _debounce;
  List<HanjaMasterRow> _results = const [];

  AppDatabase get _db => SupabaseService.instance.db;

  @override
  void dispose() {
    _query.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChange(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () async {
      final rows = await _db.searchHanja(q, limit: 30);
      if (!mounted) return;
      setState(() => _results = rows);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('한자 선택'),
      content: SizedBox(
        width: 320,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _query,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '한자 / 음 / 뜻',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: _onQueryChange,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, i) {
                  final r = _results[i];
                  return ListTile(
                    dense: true,
                    leading: Text(r.korHanja,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    title: Text('${r.korMeaning} ${r.korSound}'.trim()),
                    onTap: () => Navigator.of(context).pop(r),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
      ],
    );
  }
}
