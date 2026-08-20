import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/word_data.dart';
import '../models/word.dart';
import '../theme/app_colors.dart';
import 'admin_dialogue_edit_screen.dart';
import 'admin_hanja_screen.dart';
import 'admin_item_edit_screen.dart';

/// 관리자 전용 커리큘럼 편집기. `SubscriptionService.isAdmin` true인
/// 계정(talkverse.lab@gmail.com)만 홈의 개발자 메뉴 카드로 진입.
///
/// 두 탭:
///   * 대화 — (course, category) 그룹핑, 탭하면 DialogueEditScreen
///   * 단발 — 개별 item 리스트, 탭하면 AdminItemEditScreen
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int? _filterCourse;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  /// (course, category) → 해당 그룹의 dialogue 라인들.
  Map<(int, String), List<Word>> _dialogueGroups() {
    final map = <(int, String), List<Word>>{};
    for (final w in allItems) {
      if (!w.isDialogue) continue;
      if (_filterCourse != null && w.course != _filterCourse) continue;
      final key = (w.course, w.category);
      map.putIfAbsent(key, () => []).add(w);
    }
    for (final entry in map.entries) {
      entry.value.sort((a, b) => a.turnOrder.compareTo(b.turnOrder));
    }
    return map;
  }

  List<Word> _singletonItems() {
    return allItems.where((w) {
      if (w.isDialogue) return false;
      if (_filterCourse != null && w.course != _filterCourse) return false;
      return true;
    }).toList()
      ..sort((a, b) {
        final c = a.course.compareTo(b.course);
        if (c != 0) return c;
        final cat = a.category.compareTo(b.category);
        if (cat != 0) return cat;
        return a.id.compareTo(b.id);
      });
  }

  Future<void> _createNewDialogue() async {
    final draft = await showDialog<_NewDialogueDraft>(
      context: context,
      builder: (ctx) => const _NewDialogueDialog(),
    );
    if (draft == null || !mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminDialogueEditScreen(
          course: draft.course,
          category: draft.category,
          slug: draft.slug,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('👨‍💻 개발자 메뉴',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            tooltip: '한자 편집',
            icon: const Icon(Icons.translate, color: AppColors.textPrimary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminHanjaScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppConfig.brandColor,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppConfig.brandColor,
          labelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: '대화'),
            Tab(text: '단발'),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tab,
        builder: (context, _) {
          // 대화 탭에서만 FAB 표시.
          if (_tab.index != 0) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: _createNewDialogue,
            backgroundColor: AppConfig.brandColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: Text('새 대화',
                style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
          );
        },
      ),
      body: Column(
        children: [
          _StatsHeader(filterCourse: _filterCourse),
          _CourseFilterBar(
            value: _filterCourse,
            onChanged: (c) => setState(() => _filterCourse = c),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _DialogueList(groups: _dialogueGroups()),
                _SingletonList(items: _singletonItems()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewDialogueDraft {
  final int course;
  final String category;
  final String slug;
  const _NewDialogueDraft({
    required this.course,
    required this.category,
    required this.slug,
  });
}

class _NewDialogueDialog extends StatefulWidget {
  const _NewDialogueDialog();

  @override
  State<_NewDialogueDialog> createState() => _NewDialogueDialogState();
}

class _NewDialogueDialogState extends State<_NewDialogueDialog> {
  int _course = 2;
  final _category = TextEditingController();
  final _slug = TextEditingController();

  @override
  void dispose() {
    _category.dispose();
    _slug.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새 대화 세트'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course'),
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
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text('카테고리 라벨'),
          const SizedBox(height: 4),
          TextField(
            controller: _category,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: '예: 대화16',
            ),
          ),
          const SizedBox(height: 12),
          const Text('ID slug (영문/숫자)'),
          const SizedBox(height: 4),
          TextField(
            controller: _slug,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: '예: d16 → ru:sent:l2_d16_t01',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            final cat = _category.text.trim();
            final slug = _slug.text.trim();
            if (cat.isEmpty || slug.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('카테고리와 slug 모두 필요')),
              );
              return;
            }
            Navigator.of(context).pop(
              _NewDialogueDraft(course: _course, category: cat, slug: slug),
            );
          },
          child: const Text('생성'),
        ),
      ],
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final int? filterCourse;
  const _StatsHeader({required this.filterCourse});

  @override
  Widget build(BuildContext context) {
    final scoped = filterCourse == null
        ? allItems
        : allItems.where((w) => w.course == filterCourse).toList();
    final total = scoped.length;
    final dialogues = scoped.where((w) => w.isDialogue).length;
    final singletons = total - dialogues;
    final dialogueCount = scoped
        .where((w) => w.isDialogue)
        .map((w) => '${w.course}-${w.category}')
        .toSet()
        .length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _StatCell(label: '전체', value: '$total'),
          const SizedBox(width: 12),
          _StatCell(label: '대화 세트', value: '$dialogueCount'),
          const SizedBox(width: 12),
          _StatCell(label: '대화 라인', value: '$dialogues'),
          const SizedBox(width: 12),
          _StatCell(label: '단발', value: '$singletons'),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.notoSans(
                    fontSize: 10, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(value,
                style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.brandColor)),
          ],
        ),
      ),
    );
  }
}

class _CourseFilterBar extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  const _CourseFilterBar({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _CourseChip(label: '전체', selected: value == null, onTap: () => onChanged(null)),
          for (final c in const [1, 2, 3, 4, 5, 6])
            _CourseChip(
              label: 'L$c',
              selected: value == c,
              onTap: () => onChanged(c),
            ),
        ],
      ),
    );
  }
}

class _CourseChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CourseChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppConfig.brandColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: selected
                    ? AppConfig.brandColor
                    : AppColors.cardBorder),
          ),
          child: Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogueList extends StatelessWidget {
  final Map<(int, String), List<Word>> groups;
  const _DialogueList({required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Center(
        child: Text('대화 없음',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    final keys = groups.keys.toList()
      ..sort((a, b) {
        final c = a.$1.compareTo(b.$1);
        if (c != 0) return c;
        return a.$2.compareTo(b.$2);
      });
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: keys.length,
      itemBuilder: (ctx, i) {
        final key = keys[i];
        final lines = groups[key]!;
        final first = lines.first;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () async {
              await Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) =>
                      AdminDialogueEditScreen(course: key.$1, category: key.$2),
                ),
              );
              // Force rebuild when returning (in-memory cache may have changed)
              (ctx as Element).markNeedsBuild();
            },
            title: Text('L${key.$1} · ${key.$2}',
                style: GoogleFonts.notoSans(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(
              first.scenario.isEmpty ? '(시나리오 없음)' : first.scenario,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${lines.length}라인',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textMuted)),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SingletonList extends StatelessWidget {
  final List<Word> items;
  const _SingletonList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('항목 없음',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final w = items[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            dense: true,
            onTap: () async {
              await Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => AdminItemEditScreen(itemId: w.id),
                ),
              );
              (ctx as Element).markNeedsBuild();
            },
            title: Text(w.targetPlain,
                style: GoogleFonts.notoSans(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text('${w.korean}  ·  L${w.course}/${w.category}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: AppColors.textSecondary)),
            trailing: w.comment.isEmpty
                ? const Icon(Icons.chevron_right,
                    size: 18, color: AppColors.textMuted)
                : const Icon(Icons.sticky_note_2,
                    size: 16, color: AppColors.warning),
          ),
        );
      },
    );
  }
}
