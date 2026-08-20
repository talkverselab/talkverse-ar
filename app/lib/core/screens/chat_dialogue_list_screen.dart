// ignore_for_file: unused_element
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../data/chat_dialogue_loader.dart';
import '../data/user_stats.dart';
import '../models/chat_dialogue.dart';
import '../services/address_preference_service.dart';
import '../services/language_service.dart';
import '../theme/app_colors.dart';
import 'chat_dialogue_memorize_screen.dart';

/// VI dialogue 리스트 — 4 theme 공유 (chat / dating / travel / business).
///
/// 구성:
///   1. AppBar: 제목 + 호칭 토글 (anh/em)
///   2. dialogue 카드 grid — 친구-친구 / 시나리오 색상 구분
///   3. 카드 탭 → ChatDialogueDetailScreen (이 파일 안)
class ChatDialogueListScreen extends StatefulWidget {
  final String theme; // 'chat' | 'dating' | 'travel' | 'business'
  final String levelLabel; // 'L2' | 'L3' | 'L4' | 'L5'
  final String emoji;
  final String displayName;
  const ChatDialogueListScreen({
    super.key,
    this.theme = 'chat',
    this.levelLabel = 'Level 2',
    this.emoji = '💬',
    this.displayName = '채팅',
  });

  @override
  State<ChatDialogueListScreen> createState() => _ChatDialogueListScreenState();
}

class _ChatDialogueListScreenState extends State<ChatDialogueListScreen> {
  List<ChatDialogue> _dialogues = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    LanguageService.instance.viRegion.addListener(_onDialectChange);
  }

  @override
  void dispose() {
    LanguageService.instance.viRegion.removeListener(_onDialectChange);
    super.dispose();
  }

  void _onDialectChange() {
    ChatDialogueLoader.clearCache();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final dialect = LanguageService.instance.viRegion.value;
    final list =
        await ChatDialogueLoader.load(dialect, theme: widget.theme);
    if (!mounted) return;
    setState(() {
      _dialogues = list;
      _loading = false;
    });
  }

  /// Variant D — Vertical timeline (Talkverse_VN/screens-home.jsx).
  /// 사용자 결정 2026-05-09: 다이얼로그 선택창 timeline UI + 모두 선택 가능 (locked 제거).
  ///
  /// 진행 상태:
  /// - 사용자 학습 활동 수만큼 done 처리 (placeholder)
  /// - 다음 1개 current
  /// - 나머지 available (locked 없음)
  Widget _buildTimeline() {
    final doneCount =
        (UserStats().longestStreak / 2).floor().clamp(0, _dialogues.length - 1);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      itemCount: _dialogues.length,
      itemBuilder: (context, i) {
        final d = _dialogues[i];
        final isFirst = i == 0;
        final isLast = i == _dialogues.length - 1;
        final state = i < doneCount
            ? _DialogueState.done
            : (i == doneCount
                ? _DialogueState.current
                : _DialogueState.available);
        return _TimelineRow(
          dialogue: d,
          number: d.id,
          state: state,
          isFirst: isFirst,
          isLast: isLast,
          progressFractionAbove: i < doneCount
              ? 1.0
              : (i == doneCount ? 0.5 : 0.0),
          theme: widget.theme,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text('${widget.emoji} ${widget.displayName} (${widget.levelLabel})',
            style: GoogleFonts.notoSans(
                color: AppColors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        iconTheme: const IconThemeData(color: AppColors.ink),
        // 사용자 결정 2026-05-09: "내가 em" 호칭 토글 버튼 제거.
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _dialogues.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      LanguageService.instance.viRegion.value == 'south'
                          ? '남부 채팅 데이터 준비 중'
                          : '채팅 데이터 없음',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          color: AppColors.textSecondary),
                    ),
                  ),
                )
              : _buildTimeline(),
    );
  }
}

/// 채팅 dialogue 상세 — 전체 화면 채팅 버블 뷰.
class ChatDialogueDetailScreen extends StatefulWidget {
  final ChatDialogue dialogue;
  final String theme; // 'chat' | 'dating' | 'travel' | 'business' (mp3 prefix)
  const ChatDialogueDetailScreen({
    super.key,
    required this.dialogue,
    this.theme = 'chat',
  });

  @override
  State<ChatDialogueDetailScreen> createState() =>
      _ChatDialogueDetailScreenState();
}

/// 채팅 dialogue 상세 — 사용자 결정 2026-05-09: 모든 turn 보기 (옛 모드 복원) +
/// 하단 외우기 버튼 → ChatDialogueMemorizeScreen.
/// 디자인: LessonE 시안의 헤더(scene pill) + 마스코트 버블 톤 적용.
class _ChatDialogueDetailScreenState extends State<ChatDialogueDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _showKo = true;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _sub(String raw) =>
      AddressPreferenceService.instance.substitute(raw);

  Future<void> _playTurn(ChatTurn t) async {
    final dialect = LanguageService.instance.viRegion.value;
    final gender =
        AddressPreferenceService.instance.ttsGenderForSpeaker(t.speaker);
    // mp3 경로: audio/tts/vi/{dialect}_{gender}/{theme}_{dialogue_id}_{turn}.mp3
    final assetPath =
        'audio/tts/vi/${dialect}_$gender/${widget.theme}_${widget.dialogue.id.toString().padLeft(2, '0')}_${t.turn.toString().padLeft(2, '0')}.mp3';
    try {
      await rootBundle.load('assets/$assetPath');
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {/* asset 없으면 silent */}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AddressPreferenceService.instance,
      builder: (context, _) {
        final d = widget.dialogue;
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            backgroundColor: AppColors.bg,
            elevation: 0,
            title: Text(
              _sub(d.title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSans(
                color: AppColors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.ink),
            actions: [
              IconButton(
                icon: Icon(
                  _showKo ? Icons.subtitles : Icons.subtitles_off,
                  color: _showKo ? AppConfig.brandColor : AppColors.inkFaint,
                  size: 22,
                ),
                tooltip: '한국어 표시',
                onPressed: () => setState(() => _showKo = !_showKo),
              ),
            ],
          ),
          body: Column(
            children: [
              if (d.header.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD8B5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Text('☕', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _sub(d.header),
                          style: GoogleFonts.notoSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7A2E0E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
                  itemCount: d.turns.length,
                  itemBuilder: (context, i) {
                    final t = d.turns[i];
                    final isMe = t.speaker == 'A';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: isMe ? _meBubble(t) : _otherBubble(t),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.school_outlined, size: 18),
                label: Text(
                  '문장 외우기 (${d.turns.length}문장)',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await UserStats().recordActivity();
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDialogueMemorizeScreen(
                        dialogue: d,
                        theme: widget.theme,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// 학습자 turn — 우측 sage gradient 카드 (LessonE 톤, 빈칸 없음).
  Widget _meBubble(ChatTurn t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () => _playTurn(t),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.sage300, AppColors.sage500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sage500.withValues(alpha: 0.35),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sub(t.vi),
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  if (_showKo && t.ko.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _sub(t.ko),
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _avatar(speaker: 'A'),
      ],
    );
  }

  /// 상대 turn — 좌측 마스코트 + cream 카드 (LessonE 톤).
  Widget _otherBubble(ChatTurn t) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _avatar(speaker: 'B'),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTap: () => _playTurn(t),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              decoration: BoxDecoration(
                color: AppColors.bgSoft,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sub(t.vi),
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.coral500,
                      height: 1.4,
                    ),
                  ),
                  if (_showKo && t.ko.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _sub(t.ko),
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatar({required String speaker}) {
    // 사용자 결정 2026-05-09: 성중립 동물 마스코트 — A=🦊 여우, B=🐻 곰.
    final color = speaker == 'A' ? AppColors.purpleDark : AppColors.coral500;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        speaker == 'A' ? '🦊' : '🐻',
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Timeline UI (사용자 결정 2026-05-09 — Talkverse_VN Variant D)
// ─────────────────────────────────────────────────────────────

enum _DialogueState { done, current, available, locked }

class _TimelineRow extends StatelessWidget {
  final ChatDialogue dialogue;
  final int number;
  final _DialogueState state;
  final bool isFirst;
  final bool isLast;
  final double progressFractionAbove; // 0~1, 좌측 라인 fill 비율
  final String theme;

  const _TimelineRow({
    required this.dialogue,
    required this.number,
    required this.state,
    required this.isFirst,
    required this.isLast,
    required this.progressFractionAbove,
    required this.theme,
  });

  Color get _accent {
    switch (state) {
      case _DialogueState.done:
        return AppColors.sage500;
      case _DialogueState.current:
        return AppColors.coral500;
      case _DialogueState.available:
      case _DialogueState.locked:
        return AppColors.bgDeep;
    }
  }

  @override
  Widget build(BuildContext context) {
    const nodeSize = 60.0;
    const lineWidth = 4.0;
    final isLocked = state == _DialogueState.locked;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==== 좌측 timeline 라인 + 노드 ====
          SizedBox(
            width: nodeSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 배경 라인 (deep cream)
                Positioned(
                  top: isFirst ? nodeSize / 2 : 0,
                  bottom: isLast ? nodeSize / 2 : 0,
                  child: Container(
                    width: lineWidth,
                    color: AppColors.bgDeep,
                  ),
                ),
                // 진행 fill (sage→coral)
                if (progressFractionAbove > 0)
                  Positioned(
                    top: isFirst ? nodeSize / 2 : 0,
                    child: Container(
                      width: lineWidth,
                      height: progressFractionAbove > 0.99
                          ? double.infinity
                          : 80 * progressFractionAbove,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.sage300, AppColors.coral300],
                        ),
                      ),
                    ),
                  ),
                // 노드 (원형)
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked
                        ? AppColors.bg
                        : _accent.withValues(alpha: 0.85),
                    boxShadow: isLocked
                        ? null
                        : [
                            BoxShadow(
                              color: _accent.withValues(alpha: 0.85),
                              offset: const Offset(0, 5),
                              blurRadius: 0,
                            ),
                            BoxShadow(
                              color: _accent.withValues(alpha: 0.3),
                              offset: const Offset(0, 8),
                              blurRadius: 12,
                            ),
                          ],
                  ),
                  alignment: Alignment.center,
                  child: state == _DialogueState.done
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 28)
                      : isLocked
                          ? const Icon(Icons.lock_outline,
                              color: AppColors.inkFaint, size: 22)
                          : Text(
                              number.toString().padLeft(2, "0"),
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          // ==== 우측 텍스트 ====
          Expanded(
            child: GestureDetector(
              onTap: isLocked
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDialogueDetailScreen(
                            dialogue: dialogue,
                            theme: theme,
                          ),
                        ),
                      ),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: state == _DialogueState.current
                    ? BoxDecoration(
                        color: AppColors.bgSoft,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.coral500.withValues(alpha: 0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ],
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "DAY ${number.toString().padLeft(2, "0")}",
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.inkFaint,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AddressPreferenceService.instance.substitute(dialogue.title),
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: isLocked ? AppColors.inkFaint : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _statusLabel(),
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: state == _DialogueState.current
                            ? AppColors.coral500
                            : AppColors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel() {
    switch (state) {
      case _DialogueState.done:
        return "완료";
      case _DialogueState.current:
        return "진행 중 · ${dialogue.turns.length}문장";
      case _DialogueState.available:
        return "${dialogue.turns.length}문장";
      case _DialogueState.locked:
        return "잠금";
    }
  }
}

