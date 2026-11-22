import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/pane.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/curriculum.dart';
import '../services/dialogue_audio.dart';
import '../services/dialogue_service.dart';

/// 토크버스 커리큘럼(전 언어 공통 `~/talkverse/CURRICULUM_SPEC.md`, 2026-11-22).
/// 레벨 고르기 → 코스(편 3·5·10 고르기) → 편마다 듣기·따라 말하기·확인 문제 → 코스 시험 80% → 다음 코스·레벨.
/// 오늘 분량 = 복습(간격 1·3·7일) 먼저 + 새 편(하루 목표 1·2·3).
String _today() => dayOf(DateTime.now());

List<String> curriculumLevels() {
  final rs = DialogueService.instance.regions.where((r) => RegExp(r'^R[0-9]$').hasMatch(r)).toList()..sort();
  return rs;
}

String _levelName(String lv) => '$lv · ${tr(DialogueService.levelKo[lv] ?? '')}';

/// 홈 카드: 「오늘: 복습 N · 새 편 N」 + 진행 막대. 회화 R 레벨 편이 없으면 숨김.
class CurriculumHomeCard extends StatefulWidget {
  const CurriculumHomeCard({super.key});
  @override
  State<CurriculumHomeCard> createState() => _CurriculumHomeCardState();
}

class _CurriculumHomeCardState extends State<CurriculumHomeCard> {
  CurriculumState? _s;
  bool _has = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await DialogueService.instance.ensureLoaded();
    final s = await CurriculumStore.load();
    if (!mounted) return;
    setState(() {
      _s = s;
      _has = curriculumLevels().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    if (s == null || !_has) return const SizedBox.shrink();
    final today = _today();
    final due = s.dueReviews(today).length;
    final newLeft = s.course == null || s.course!.done ? 0 : s.newLeftToday(today);
    final doneN = s.newDoneToday(today) + s.reviewDoneToday(today);
    final total = doneN + due + newLeft;
    final finished = s.level != null && due == 0 && newLeft == 0 && doneN > 0;
    final streak = s.streakShown(today);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await openPane(context, (_) => const CurriculumScreen());
          _load();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cal,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.beni.withValues(alpha: 0.5)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.school, color: AppColors.beni, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(tr('토크버스 커리큘럼'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.tinta)),
              ),
              if (streak > 0)
                Text(trf('🔥 {0}일 연속', [streak]),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.beniDeep)),
            ]),
            const SizedBox(height: 6),
            Text(
              s.level == null
                  ? tr('레벨을 고르고 다이얼로그 코스를 시작하세요')
                  : finished
                      ? tr('오늘 분량 끝')
                      : trf('오늘: 복습 {0} · 새 편 {1}', [due, newLeft]),
              style: const TextStyle(fontSize: 13, color: AppColors.tintaLight, fontWeight: FontWeight.w600),
            ),
            if (s.level != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : doneN / total,
                  minHeight: 6,
                  backgroundColor: AppColors.line,
                  color: AppColors.beni,
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});
  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  CurriculumState? _s;
  bool _pickLevel = false;
  bool _building = false;
  bool _confirmNew = false;
  int _pickCount = 5;
  final List<String> _picked = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await DialogueService.instance.ensureLoaded();
    final s = await CurriculumStore.load();
    if (!mounted) return;
    setState(() {
      _s = s;
      _pickLevel = s.level == null;
    });
  }

  Future<void> _save() async {
    final s = _s!;
    s.checkDayDone(_today(), newAvailable: _newAvailable());
    await CurriculumStore.save(s);
    if (mounted) setState(() {});
  }

  List<Dialogue> _levelDs([String? lv]) => DialogueService.instance.list(region: lv ?? _s!.level);

  bool _newAvailable() {
    final c = _s!.course;
    return c != null && !c.done && !c.allPracticed;
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: Text(tr('토크버스 커리큘럼'),
            style: const TextStyle(color: AppColors.sumi, fontWeight: FontWeight.w800, fontSize: 16)),
      ),
      body: s == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.beni))
          : ListView(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset(context)),
              children: _pickLevel ? _levelPicker(s) : _main(s),
            ),
    );
  }

  // ── 레벨 고르기 ──
  List<Widget> _levelPicker(CurriculumState s) {
    final lvs = curriculumLevels();
    return [
      Text(tr('레벨 고르기'), style: _h),
      const SizedBox(height: 4),
      Text(tr('처음이면 가장 낮은 레벨부터 권합니다'), style: _sub),
      const SizedBox(height: 12),
      for (final (i, lv) in lvs.indexed)
        _Tile(
          title: _levelName(lv),
          sub: trf('다이얼로그 {0}편 · 통과 {1}', [_levelDs(lv).length, _levelDs(lv).where((d) => s.passedDialogues.contains(d.id)).length]),
          badge: i == 0 && s.level == null ? tr('추천') : (lv == s.level ? tr('지금') : null),
          onTap: () async {
            if (s.level != lv) {
              s.level = lv;
              if (s.course != null && !s.course!.done) s.course = null;
            }
            _pickLevel = false;
            await _save();
          },
        ),
    ];
  }

  // ── 레벨 화면 ──
  List<Widget> _main(CurriculumState s) {
    final today = _today();
    final due = s.dueReviews(today);
    final c = s.course;
    final lvDs = _levelDs();
    final lvPassed = lvDs.isNotEmpty && lvDs.every((d) => s.passedDialogues.contains(d.id));
    final lvs = curriculumLevels();
    final next = lvs.indexOf(s.level!) + 1 < lvs.length ? lvs[lvs.indexOf(s.level!) + 1] : null;
    return [
      Row(children: [
        Expanded(child: Text(_levelName(s.level!), style: _h)),
        TextButton(onPressed: () => setState(() => _pickLevel = true), child: Text(tr('레벨 바꾸기'))),
      ]),
      const SizedBox(height: 6),
      Text(tr('하루 목표'), style: _sub),
      const SizedBox(height: 4),
      Wrap(spacing: 8, children: [
        for (final (g, label) in [(1, tr('가볍게 · 새 편 1')), (2, tr('보통 · 새 편 2')), (3, tr('집중 · 새 편 3'))])
          ChoiceChip(
            label: Text(label),
            selected: s.dailyGoal == g,
            onSelected: (_) {
              s.dailyGoal = g;
              _save();
            },
          ),
      ]),
      const SizedBox(height: 12),
      _Box(children: [
        Text(
          due.isEmpty && s.newLeftToday(today) == 0 && s.newDoneToday(today) + s.reviewDoneToday(today) > 0
              ? tr('오늘 분량 끝')
              : trf('오늘: 복습 {0} · 새 편 {1}', [due.length, c == null || c.done ? 0 : s.newLeftToday(today)]),
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.tinta),
        ),
        if (s.streakShown(today) > 0) Text(trf('🔥 {0}일 연속', [s.streakShown(today)]), style: _sub),
        if (due.isNotEmpty) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            icon: const Icon(Icons.replay),
            label: Text(trf('복습 {0}줄 시작', [due.length.clamp(0, 20)])),
            onPressed: () => _startReview(due.take(20).toList()),
          ),
        ],
      ]),
      const SizedBox(height: 16),
      if (lvPassed) ...[
        _Box(children: [
          Text(tr('이 레벨의 편을 모두 통과했습니다'), style: const TextStyle(fontWeight: FontWeight.w700)),
          if (next != null) ...[
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                s.level = next;
                s.course = null;
                await _save();
              },
              child: Text(trf('다음 레벨 {0} 열기', [next])),
            ),
          ],
        ]),
        const SizedBox(height: 16),
      ],
      if (c != null && !c.done && !_building) ..._courseView(s, c) else ..._builder(s, c),
    ];
  }

  // ── 지금 코스 ──
  List<Widget> _courseView(CurriculumState s, Course c) {
    final svc = DialogueService.instance;
    final last = c.examScores.isEmpty ? null : c.examScores.last;
    return [
      Row(children: [
        Expanded(child: Text(trf('지금 코스 · {0}편', [c.dialogueIds.length]), style: _h)),
        TextButton(onPressed: () => setState(() => _confirmNew = true), child: Text(tr('새 코스'))),
      ]),
      if (_confirmNew)
        _Box(children: [
          Text(tr('지금 코스를 버리고 새 코스를 만들까요? 연습 기록은 복습에 남습니다.')),
          const SizedBox(height: 8),
          Row(children: [
            FilledButton(
              onPressed: () => setState(() {
                _confirmNew = false;
                _building = true;
                _picked.clear();
              }),
              child: Text(tr('새 코스 만들기')),
            ),
            const SizedBox(width: 8),
            TextButton(onPressed: () => setState(() => _confirmNew = false), child: Text(tr('그대로 두기'))),
          ]),
        ]),
      if (last != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(trf('지난 시험 {0}% — 80% 이상이면 통과. 틀린 편만 다시 연습하세요', [last]), style: _sub),
        ),
      for (final id in c.dialogueIds)
        if (svc.byId(id) case final d?)
          _Tile(
            title: '${d.emoji} ${d.title}',
            sub: '${tr(DialogueService.islandKo[d.island] ?? d.island)} · ${trf('{0}줄', [d.turns.length])}',
            badge: c.practiced.contains(id) ? tr('연습 끝') : null,
            onTap: () => _practice(d),
          ),
      const SizedBox(height: 10),
      FilledButton.icon(
        icon: const Icon(Icons.fact_check),
        label: Text(c.allPracticed ? tr('코스 시험 보기') : trf('코스 시험 — 연습 {0}/{1}', [c.practiced.length, c.dialogueIds.length])),
        onPressed: c.allPracticed ? _exam : null,
      ),
    ];
  }

  // ── 코스 만들기 ──
  List<Widget> _builder(CurriculumState s, Course? c) {
    final lvDs = _levelDs();
    final passed = s.passedDialogues.toSet();
    return [
      if (c != null && c.done)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(trf('지난 코스 통과 ({0}%) — 다음 코스를 만드세요', [c.examScores.isEmpty ? 0 : c.examScores.last]),
              style: const TextStyle(color: AppColors.matcha, fontWeight: FontWeight.w700)),
        ),
      Text(tr('코스 만들기'), style: _h),
      const SizedBox(height: 4),
      Text(tr('이 레벨에서 연습할 다이얼로그를 고르세요'), style: _sub),
      const SizedBox(height: 6),
      Row(children: [
        for (final n in [3, 5, 10]) ...[
          ChoiceChip(
            label: Text(trf('{0}편', [n])),
            selected: _pickCount == n,
            onSelected: (_) => setState(() {
              _pickCount = n;
              if (_picked.length > n) _picked.removeRange(n, _picked.length);
            }),
          ),
          const SizedBox(width: 6),
        ],
        const Spacer(),
        TextButton(
          onPressed: () => setState(() {
            final r = recommend(lvDs, passed, _pickCount, keep: _picked);
            _picked
              ..clear()
              ..addAll(r);
          }),
          child: Text(tr('추천으로 채우기')),
        ),
      ]),
      for (final d in lvDs)
        CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          value: _picked.contains(d.id),
          onChanged: (v) => setState(() {
            if (v == true && _picked.length < _pickCount) {
              _picked.add(d.id);
            } else {
              _picked.remove(d.id);
            }
          }),
          title: Text('${d.emoji} ${d.title}', style: const TextStyle(fontSize: 14)),
          subtitle: Text(
            '${tr(DialogueService.islandKo[d.island] ?? d.island)}${passed.contains(d.id) ? ' · ${tr('통과')}' : ''}',
            style: TextStyle(fontSize: 12, color: passed.contains(d.id) ? AppColors.matcha : AppColors.muted),
          ),
        ),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: _picked.isEmpty
            ? null
            : () async {
                s.course = Course(id: 'c${DateTime.now().millisecondsSinceEpoch}', dialogueIds: [..._picked]);
                _building = false;
                _picked.clear();
                await _save();
              },
        child: Text(trf('코스 시작 ({0}/{1})', [_picked.length, _pickCount])),
      ),
      if (_building && c != null && !c.done)
        TextButton(onPressed: () => setState(() => _building = false), child: Text(tr('지금 코스로 돌아가기'))),
    ];
  }

  // ── 동작 ──
  Future<void> _practice(Dialogue d) async {
    final res = await openFull<QuizResult>(context, (_) => PracticeScreen(dialogue: d));
    if (res == null) return;
    final s = _s!;
    final today = _today();
    s.addPracticed(d.id, d.turns.map((t) => t.num), res.wrongTurns(d.id), today);
    s.markPracticed(d.id, today);
    await _save();
  }

  Future<void> _exam() async {
    final s = _s!;
    final c = s.course!;
    final svc = DialogueService.instance;
    final ds = [for (final id in c.dialogueIds) ?svc.byId(id)];
    final qs = buildExam(ds, pool: _levelDs());
    if (qs.isEmpty) return;
    final res = await openFull<QuizResult>(context, (_) => QuizScreen(title: tr('코스 시험'), questions: qs, exam: true));
    if (res == null) return;
    final today = _today();
    for (final d in ds) {
      s.addPracticed(d.id, res.wrongTurns(d.id), res.wrongTurns(d.id), today);
    }
    s.recordExam(res.correct, res.total, today, wrongDialogues: res.wrongDialogues);
    await _save();
  }

  Future<void> _startReview(List<ReviewItem> items) async {
    final svc = DialogueService.instance;
    final qs = <CurQuestion>[];
    for (final r in items) {
      final d = svc.byId(r.dialogueId);
      if (d == null) {
        _s!.review.remove(r);
        continue;
      }
      qs.addAll(buildQuestions(d, max: 1, pool: _levelDs(), onlyTurns: [r.turn]));
    }
    if (qs.isEmpty) {
      await _save();
      return;
    }
    final res = await openFull<QuizResult>(context, (_) => QuizScreen(title: tr('복습'), questions: qs));
    if (res == null) return;
    final today = _today();
    for (final (q, ok) in res.answers) {
      _s!.answerReview(q.lineId, ok, today);
    }
    await _save();
  }

  static const _h = TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.tinta);
  static const _sub = TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w600);
}

class _Box extends StatelessWidget {
  final List<Widget> children;
  const _Box({required this.children});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.calDeep,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );
}

class _Tile extends StatelessWidget {
  final String title, sub;
  final String? badge;
  final VoidCallback onTap;
  const _Tile({required this.title, required this.sub, this.badge, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.line)),
        child: ListTile(
          onTap: onTap,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
          trailing: badge == null
              ? const Icon(Icons.chevron_right)
              : Text(badge!, style: const TextStyle(color: AppColors.matcha, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
      );
}

/// 문제 풀이 결과.
class QuizResult {
  final List<(CurQuestion, bool)> answers;
  const QuizResult(this.answers);
  int get total => answers.length;
  int get correct => answers.where((a) => a.$2).length;
  Set<int> wrongTurns(String dialogueId) => {for (final (q, ok) in answers) if (!ok && q.dialogueId == dialogueId) q.turn};
  Set<String> get wrongDialogues => {for (final (q, ok) in answers) if (!ok) q.dialogueId};
}

/// 편 연습: ① 듣기·읽기(전체 재생, 줄마다 뜻) ② 따라 말하기(줄 반복 듣기, 채점 없음) ③ 확인 문제.
class PracticeScreen extends StatefulWidget {
  final Dialogue dialogue;
  const PracticeScreen({super.key, required this.dialogue});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool _showKo = true;
  int? _playing;
  bool _stop = false;

  @override
  void dispose() {
    _stop = true;
    DialogueAudio.instance.stop();
    super.dispose();
  }

  Future<void> _playAll() async {
    _stop = false;
    for (final t in widget.dialogue.turns) {
      if (_stop || !mounted) break;
      setState(() => _playing = t.num);
      await speakTurn(widget.dialogue, t);
      await Future.delayed(const Duration(milliseconds: 350));
    }
    if (mounted) setState(() => _playing = null);
  }

  Future<void> _repeat(DialogueTurn t) async {
    _stop = false;
    for (var i = 0; i < 3 && !_stop && mounted; i++) {
      setState(() => _playing = t.num);
      await speakTurn(widget.dialogue, t);
      await Future.delayed(const Duration(milliseconds: 1500)); // 따라 말할 틈
    }
    if (mounted) setState(() => _playing = null);
  }

  Future<void> _halt() async {
    _stop = true;
    await DialogueAudio.instance.stop();
    if (mounted) setState(() => _playing = null);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dialogue;
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(title: Text('${d.emoji} ${d.title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 100 + bottomInset(context)),
        children: [
          if (d.sceneShown.isNotEmpty) Text(d.sceneShown, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 8),
          Row(children: [
            FilledButton.icon(
              icon: Icon(_playing == null ? Icons.play_arrow : Icons.stop),
              label: Text(_playing == null ? tr('전체 듣기') : tr('멈춤')),
              onPressed: _playing == null ? _playAll : _halt,
            ),
            const Spacer(),
            Text(tr('뜻'), style: const TextStyle(fontSize: 13)),
            Switch(value: _showKo, onChanged: (v) => setState(() => _showKo = v)),
          ]),
          Text(tr('줄을 누르면 듣기 · 🔁 는 3번 반복(따라 말하기, 채점 없음)'),
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 8),
          for (final t in d.turns)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: _playing == t.num ? AppColors.beni.withValues(alpha: 0.08) : AppColors.cal,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _playing == t.num ? AppColors.beni : AppColors.line),
              ),
              child: ListTile(
                onTap: () async {
                  _stop = true;
                  setState(() => _playing = t.num);
                  await speakTurn(d, t);
                  if (mounted && _playing == t.num) setState(() => _playing = null);
                },
                title: Text(t.tl.replaceAll('{name}', d.speakerName('A')),
                    textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 18)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${d.speakerName(t.speaker)}${t.rd.isNotEmpty ? ' · ${t.rd}' : ''}',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  if (_showKo && t.ko.isNotEmpty) Text(t.ko, style: const TextStyle(fontSize: 13, color: AppColors.tintaLight)),
                ]),
                trailing: IconButton(icon: const Icon(Icons.repeat), tooltip: tr('3번 반복'), onPressed: () => _repeat(t)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            icon: const Icon(Icons.quiz),
            label: Text(tr('확인 문제 풀기')),
            onPressed: () async {
              await _halt();
              if (!context.mounted) return;
              final qs = buildQuestions(d, pool: DialogueService.instance.list(region: d.region));
              if (qs.isEmpty) {
                Navigator.pop(context, const QuizResult([]));
                return;
              }
              final res = await Navigator.push<QuizResult>(
                  context, MaterialPageRoute(builder: (_) => QuizScreen(title: tr('확인 문제'), questions: qs)));
              if (res != null && context.mounted) Navigator.pop(context, res);
            },
          ),
        ),
      ),
    );
  }
}

/// 4지선다 풀이(뜻 고르기·빈칸 낱말). 끝나면 점수 화면 → QuizResult 로 돌아감.
class QuizScreen extends StatefulWidget {
  final String title;
  final List<CurQuestion> questions;
  final bool exam;
  const QuizScreen({super.key, required this.title, required this.questions, this.exam = false});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _i = 0;
  int? _chosen;
  final List<(CurQuestion, bool)> _answers = [];

  @override
  Widget build(BuildContext context) {
    final qs = widget.questions;
    final done = _i >= qs.length;
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(title: Text(done ? widget.title : '${widget.title} ${_i + 1}/${qs.length}')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset(context)),
        child: done ? _result() : _question(qs[_i]),
      ),
    );
  }

  Widget _question(CurQuestion q) {
    final answered = _chosen != null;
    return ListView(children: [
      Text(q.kind == 'cloze' ? tr('빈칸에 들어갈 낱말은?') : tr('이 줄의 뜻은?'),
          style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Text(q.prompt, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
      if (q.hint != null) ...[
        const SizedBox(height: 6),
        Text(q.hint!, style: const TextStyle(color: AppColors.tintaLight)),
      ],
      const SizedBox(height: 18),
      for (final (k, o) in q.options.indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              alignment: Alignment.centerLeft,
              backgroundColor: !answered
                  ? null
                  : k == q.answer
                      ? AppColors.matcha.withValues(alpha: 0.12)
                      : k == _chosen
                          ? AppColors.fem.withValues(alpha: 0.10)
                          : null,
            ),
            onPressed: answered ? null : () => setState(() => _chosen = k),
            child: Text(o,
                textDirection: q.kind == 'cloze' ? TextDirection.rtl : null,
                style: TextStyle(fontSize: q.kind == 'cloze' ? 19 : 15, color: AppColors.tinta)),
          ),
        ),
      if (answered)
        FilledButton(
          onPressed: () => setState(() {
            _answers.add((q, _chosen == q.answer));
            _chosen = null;
            _i++;
          }),
          child: Text(tr('다음')),
        ),
    ]);
  }

  Widget _result() {
    final res = QuizResult(_answers);
    final sc = scorePercent(res.correct, res.total);
    final ok = sc >= passPercent;
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('$sc%', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: ok ? AppColors.matcha : AppColors.fem)),
      Text(trf('{0} / {1} 정답', [res.correct, res.total]), textAlign: TextAlign.center),
      if (widget.exam) ...[
        const SizedBox(height: 8),
        Text(ok ? tr('통과! 다음 코스로 넘어갑니다') : tr('80% 미만 — 틀린 편만 다시 연습한 뒤 다시 시험'),
            textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
      const SizedBox(height: 20),
      FilledButton(onPressed: () => Navigator.pop(context, res), child: Text(tr('확인'))),
    ]);
  }
}
