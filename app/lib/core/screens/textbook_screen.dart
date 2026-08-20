import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

/// MN 단국대 교재 학습 메뉴.
///
/// 구조:
///   - TextbookScreen: 30 챕터 리스트 (A1: 1-15 / A2: 16-30)
///   - TextbookChapterScreen: 본문 audio · 핵심회화 audio · 단어 학습 · 문장 학습
///
/// 자산: `assets/textbook_mn/` (mp3 63 + JSON 30 + chapters_meta.json)
class TextbookScreen extends StatefulWidget {
  const TextbookScreen({super.key});

  @override
  State<TextbookScreen> createState() => _TextbookScreenState();
}

class _TextbookScreenState extends State<TextbookScreen> {
  List<Map<String, dynamic>>? _chapters;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final raw =
          await rootBundle.loadString('assets/textbook_mn/chapters_meta.json');
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      list.sort((a, b) => (a['chapter'] as int).compareTo(b['chapter'] as int));
      if (mounted) setState(() => _chapters = list);
    } catch (e) {
      if (mounted) setState(() => _chapters = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapters = _chapters;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('📚 교과서 공부 (단국대)',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: chapters == null
          ? const Center(child: CircularProgressIndicator())
          : chapters.isEmpty
              ? const Center(child: Text('교과서 데이터 없음 (assets/textbook_mn/ 확인)'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _LevelHeader(
                        level: 1, label: 'A1 — 몽골어1 초급 (제1~15과)'),
                    ...chapters
                        .where((c) => c['level'] == 1)
                        .map((c) => _ChapterCard(meta: c)),
                    const SizedBox(height: 16),
                    _LevelHeader(
                        level: 2, label: 'A2 — 몽골어2 초급 (제16~30과)'),
                    ...chapters
                        .where((c) => c['level'] == 2)
                        .map((c) => _ChapterCard(meta: c)),
                    const SizedBox(height: 24),
                    Center(
                      child: Text('단국대학교 특수외국어진흥사업 교재 (무료 배포)',
                          style: GoogleFonts.notoSans(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
    );
  }
}

class _LevelHeader extends StatelessWidget {
  final int level;
  final String label;
  const _LevelHeader({required this.level, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(label,
          style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final Map<String, dynamic> meta;
  const _ChapterCard({required this.meta});

  @override
  Widget build(BuildContext context) {
    final ch = meta['chapter'] as int;
    final level = meta['level'] as int;
    final title = (meta['title'] as String?) ?? '';
    final wc = meta['word_count'] as int? ?? 0;
    final sc = meta['sentence_count'] as int? ?? 0;
    final code = 'A$level-${ch.toString().padLeft(2, '0')}';
    final hasContent = wc > 0 || sc > 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              hasContent ? AppConfig.brandColor : AppColors.textSecondary,
          child: Text(ch.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text('$code 과',
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
        subtitle: title.isEmpty
            ? const Text('(추출 데이터 없음 — 오디오만 가용)')
            : Text(title,
                maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('단어 $wc',
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: AppColors.textSecondary)),
            Text('문장 $sc',
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TextbookChapterScreen(chapter: ch))),
      ),
    );
  }
}

/// 단일 챕터 상세 화면. 4개 메뉴: 본문 audio / 핵심회화 audio / 단어 학습 / 문장 학습.
class TextbookChapterScreen extends StatefulWidget {
  final int chapter;
  const TextbookChapterScreen({super.key, required this.chapter});

  @override
  State<TextbookChapterScreen> createState() => _TextbookChapterScreenState();
}

class _TextbookChapterScreenState extends State<TextbookChapterScreen> {
  Map<String, dynamic>? _data;
  final AudioPlayer _player = AudioPlayer();
  String? _playingTag;

  @override
  void initState() {
    super.initState();
    _loadData();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingTag = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final ch = widget.chapter.toString().padLeft(2, '0');
    try {
      final raw = await rootBundle
          .loadString('assets/textbook_mn/ch${ch}_data.json');
      if (mounted) setState(() => _data = jsonDecode(raw));
    } catch (e) {
      if (mounted) setState(() => _data = {});
    }
  }

  Future<void> _toggleAudio(String tag, String assetPath) async {
    if (_playingTag == tag) {
      await _player.stop();
      if (mounted) setState(() => _playingTag = null);
      return;
    }
    await _player.stop();
    setState(() => _playingTag = tag);
    try {
      // assets/textbook_mn/ch01_main.mp3 → 'textbook_mn/ch01_main.mp3' (assets/ 자동)
      final stripped = assetPath.startsWith('assets/')
          ? assetPath.substring('assets/'.length)
          : assetPath;
      await _player.play(AssetSource(stripped));
    } catch (e) {
      if (mounted) {
        setState(() => _playingTag = null);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('재생 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final ch = widget.chapter;
    final code = 'A${ch <= 15 ? 1 : 2}-${ch.toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('$code 과',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if ((data['title'] as String? ?? '').isNotEmpty) ...[
                  Text(data['title'] as String,
                      style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                ],
                _AudioCard(
                  emoji: '📖',
                  label: '본문 듣기',
                  assetPath: data['main_audio'] as String? ??
                      'assets/textbook_mn/ch${ch.toString().padLeft(2, '0')}_main.mp3',
                  isPlaying: _playingTag == 'main',
                  onTap: () => _toggleAudio(
                      'main',
                      data['main_audio'] as String? ??
                          'assets/textbook_mn/ch${ch.toString().padLeft(2, '0')}_main.mp3'),
                ),
                const SizedBox(height: 8),
                _AudioCard(
                  emoji: '💬',
                  label: '핵심회화 듣기',
                  assetPath: data['dialogue_audio'] as String? ??
                      'assets/textbook_mn/ch${ch.toString().padLeft(2, '0')}_dialogue.mp3',
                  isPlaying: _playingTag == 'dialogue',
                  onTap: () => _toggleAudio(
                      'dialogue',
                      data['dialogue_audio'] as String? ??
                          'assets/textbook_mn/ch${ch.toString().padLeft(2, '0')}_dialogue.mp3'),
                ),
                const SizedBox(height: 16),
                _StudyCard(
                  emoji: '🔤',
                  label: '단어 플래시카드',
                  count: (data['words'] as List?)?.length ?? 0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TextbookFlashcardScreen(
                          chapter: ch,
                          mode: TextbookFlashcardMode.word,
                          cards: ((data['words'] as List?) ?? const [])
                              .cast<Map<String, dynamic>>()))),
                ),
                const SizedBox(height: 8),
                _StudyCard(
                  emoji: '✏️',
                  label: '문장 플래시카드',
                  count: (data['sentences'] as List?)?.length ?? 0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TextbookFlashcardScreen(
                          chapter: ch,
                          mode: TextbookFlashcardMode.sentence,
                          cards: ((data['sentences'] as List?) ?? const [])
                              .cast<Map<String, dynamic>>()))),
                ),
                const SizedBox(height: 8),
                _StudyCard(
                  emoji: '🎤',
                  label: '핵심회화 플래시카드',
                  count: (data['sentences'] as List?)?.length ?? 0,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TextbookFlashcardScreen(
                          chapter: ch,
                          mode: TextbookFlashcardMode.dialogue,
                          cards: ((data['sentences'] as List?) ?? const [])
                              .cast<Map<String, dynamic>>(),
                          dialogueAudioPath: data['dialogue_audio'] as String?))),
                ),
                if ((data['note'] as String?) != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('⚠ ${data['note']}',
                        style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ),
                ],
              ],
            ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String assetPath;
  final bool isPlaying;
  final VoidCallback onTap;
  const _AudioCard({
    required this.emoji,
    required this.label,
    required this.assetPath,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 28)),
        title: Text(label,
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
        trailing: Icon(isPlaying ? Icons.stop_circle : Icons.play_circle,
            color: AppConfig.brandColor, size: 32),
        onTap: onTap,
      ),
    );
  }
}

class _StudyCard extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final VoidCallback onTap;
  const _StudyCard({
    required this.emoji,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 28)),
        title: Text(label,
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
        subtitle: Text('$count 항목'),
        trailing: const Icon(Icons.chevron_right),
        onTap: count > 0
            ? onTap
            : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터 없음 (오디오만 가용)'))),
      ),
    );
  }
}

/// 텍스트북 플래시카드 모드 — UI title·아이콘 + 음원 옵션 차이.
enum TextbookFlashcardMode {
  word,      // 🔤 단어 (mn lemma → ko 의미)
  sentence,  // ✏️ 문장 (mn sentence → ko 번역)
  dialogue,  // 🎤 핵심회화 (sentence + 핵심회화 mp3 재생 가능)
}

/// 단국대 교재 학습용 플래시카드.
///
/// 흐름:
///   - 카드 앞면: 몽골어 (mn) — 큰 글씨
///   - 탭 → 뒤집기 → 한국어 (ko)
///   - 하단 컨트롤: 이전 / 듣기 (TTS) / 다음
///   - dialogue 모드: AppBar 에 핵심회화 mp3 재생 토글 추가
///   - 진도: i/N 표시
class TextbookFlashcardScreen extends StatefulWidget {
  final int chapter;
  final TextbookFlashcardMode mode;
  final List<Map<String, dynamic>> cards;
  final String? dialogueAudioPath;

  const TextbookFlashcardScreen({
    super.key,
    required this.chapter,
    required this.mode,
    required this.cards,
    this.dialogueAudioPath,
  });

  @override
  State<TextbookFlashcardScreen> createState() =>
      _TextbookFlashcardScreenState();
}

class _TextbookFlashcardScreenState extends State<TextbookFlashcardScreen> {
  int _index = 0;
  bool _showBack = false;
  bool _autoPlay = true; // 카드 등장 시 자동 TTS (사용자 페달고지: 근육 기억)
  final AudioPlayer _dialoguePlayer = AudioPlayer();
  final AudioPlayer _ttsPlayer = AudioPlayer(); // mn 단어/문장 사전생성 mp3 재생
  bool _dialoguePlaying = false;
  Set<String>? _audioManifest; // 가용 mp3 hash set

  @override
  void initState() {
    super.initState();
    _dialoguePlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _dialoguePlaying = false);
    });
    _loadAudioManifest();
    // 한국어 카드 (front) 등장 시 TTS 안 함. 사용자가 탭 → 뒷면 (mn) 갈 때만 재생.
  }

  /// audio_manifest.json 로드 — Azure 사전생성 mp3 가용 hash set.
  /// 없으면 빈 set (모두 flutter_tts fallback).
  Future<void> _loadAudioManifest() async {
    try {
      final raw = await rootBundle
          .loadString('assets/textbook_mn/audio_manifest.json');
      final m = jsonDecode(raw) as Map<String, dynamic>;
      if (mounted) setState(() => _audioManifest = m.keys.toSet());
    } catch (_) {
      if (mounted) setState(() => _audioManifest = <String>{});
    }
  }

  /// 텍스트 → md5 12자 hash (Python 측 generator 와 일치).
  String _textHash(String text) {
    final bytes = utf8.encode(text.trim());
    return md5.convert(bytes).toString().substring(0, 12);
  }

  @override
  void dispose() {
    _dialoguePlayer.dispose();
    _ttsPlayer.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  void _next() {
    if (_index < widget.cards.length - 1) {
      setState(() {
        _index++;
        _showBack = false;  // 다음 카드 = 한국어 front. TTS 안 함.
      });
      TtsService.instance.stop();
      _ttsPlayer.stop();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _showBack = false;
      });
      TtsService.instance.stop();
      _ttsPlayer.stop();
    }
  }

  void _toggleFlip() {
    setState(() => _showBack = !_showBack);
    // 한국어 → 몽골어 (flip TO back) 시에만 mn 재생.
    // 몽골어 → 한국어 (flip BACK to front) 시에는 stop + TTS 안 함.
    if (_showBack) {
      if (_autoPlay) {
        Future.delayed(const Duration(milliseconds: 200), _speakBackMn);
      }
    } else {
      TtsService.instance.stop();
      _ttsPlayer.stop();
    }
  }

  /// 카드 뒷면 (몽골어) TTS — Azure 사전생성 mp3 우선, 없으면 flutter_tts.
  Future<void> _speakBackMn() async {
    final text = (widget.cards[_index]['mn'] as String? ?? '').trim();
    if (text.isEmpty) return;
    final hash = _textHash(text);
    if (_audioManifest != null && _audioManifest!.contains(hash)) {
      // Azure 사전생성 mp3 재생 (mn-MN-BataaNeural voice 정확)
      try {
        await _ttsPlayer.stop();
        await _ttsPlayer.play(
            AssetSource('textbook_mn/audio/$hash.mp3'));
        return;
      } catch (e) {
        if (kDebugMode) debugPrint('[textbook] mp3 재생 실패: $e — fallback');
      }
    }
    // fallback: flutter_tts (폰에 mn voice 없으면 부정확)
    await TtsService.instance.setLanguageOverride(null);
    await TtsService.instance.speak(text, delay: Duration.zero);
  }

  Future<void> _toggleDialogueAudio() async {
    final path = widget.dialogueAudioPath;
    if (path == null) return;
    if (_dialoguePlaying) {
      await _dialoguePlayer.stop();
      if (mounted) setState(() => _dialoguePlaying = false);
      return;
    }
    final stripped = path.startsWith('assets/') ? path.substring(7) : path;
    setState(() => _dialoguePlaying = true);
    try {
      await _dialoguePlayer.play(AssetSource(stripped));
    } catch (e) {
      if (mounted) setState(() => _dialoguePlaying = false);
    }
  }

  String _modeIcon() {
    switch (widget.mode) {
      case TextbookFlashcardMode.word:
        return '🔤';
      case TextbookFlashcardMode.sentence:
        return '✏️';
      case TextbookFlashcardMode.dialogue:
        return '🎤';
    }
  }

  String _modeLabel() {
    switch (widget.mode) {
      case TextbookFlashcardMode.word:
        return '단어';
      case TextbookFlashcardMode.sentence:
        return '문장';
      case TextbookFlashcardMode.dialogue:
        return '핵심회화';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ch = widget.chapter;
    final code = 'A${ch <= 15 ? 1 : 2}-${ch.toString().padLeft(2, '0')}';
    final cards = widget.cards;
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('${_modeIcon()} $code ${_modeLabel()}')),
        body: const Center(child: Text('데이터 없음')),
      );
    }
    final card = cards[_index];
    final mn = card['mn'] as String? ?? '';
    final ko = card['ko'] as String? ?? '';
    final isDialogueMode = widget.mode == TextbookFlashcardMode.dialogue;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('${_modeIcon()} $code ${_modeLabel()}',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: Icon(
              _autoPlay ? Icons.volume_up : Icons.volume_off,
              color: _autoPlay
                  ? AppConfig.brandColor
                  : AppColors.textSecondary,
            ),
            tooltip: '자동 재생 ${_autoPlay ? "켜짐" : "꺼짐"}',
            onPressed: () => setState(() => _autoPlay = !_autoPlay),
          ),
          if (isDialogueMode && widget.dialogueAudioPath != null)
            IconButton(
              icon: Icon(
                  _dialoguePlaying ? Icons.stop_circle : Icons.headphones,
                  color: AppConfig.brandColor),
              tooltip: '핵심회화 전체 듣기',
              onPressed: _toggleDialogueAudio,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 진도 표시 — 한국어 (앞) → 몽골어 (뒤) production 학습
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_index + 1} / ${cards.length}',
                      style: GoogleFonts.notoSans(
                          fontSize: 14, color: AppColors.textSecondary)),
                  Text(_showBack ? '몽골어 정답' : '뜻 보고 → 탭 → 몽골어 확인',
                      style: GoogleFonts.notoSans(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 12),
              // 진도 bar
              LinearProgressIndicator(
                value: (_index + 1) / cards.length,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(AppConfig.brandColor),
                minHeight: 4,
              ),
              const SizedBox(height: 24),
              // 플래시카드 본체
              Expanded(
                child: GestureDetector(
                  onTap: _toggleFlip,
                  onHorizontalDragEnd: (d) {
                    if (d.primaryVelocity == null) return;
                    if (d.primaryVelocity! > 200) {
                      _prev();
                    } else if (d.primaryVelocity! < -200) {
                      _next();
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: _showBack
                        ? AppConfig.brandColor.withValues(alpha: 0.06)
                        : Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        // 앞 = 한국어 (뜻) / 뒤 = 몽골어 (정답)
                        child: Text(
                          _showBack ? mn : ko,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                              fontSize:
                                  widget.mode == TextbookFlashcardMode.word
                                      ? 32
                                      : 22,
                              fontWeight: FontWeight.bold,
                              color: _showBack
                                  ? AppConfig.brandColor
                                  : AppColors.textPrimary,
                              height: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 컨트롤
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(
                    icon: Icons.arrow_back_ios_rounded,
                    label: '이전',
                    onPressed: _index > 0 ? _prev : null,
                  ),
                  _ControlButton(
                    icon: Icons.volume_up_rounded,
                    label: '몽골어 듣기',
                    primary: true,
                    onPressed: _speakBackMn,
                  ),
                  _ControlButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    label: '다음',
                    onPressed: _index < cards.length - 1 ? _next : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final color = disabled
        ? AppColors.textSecondary.withValues(alpha: 0.3)
        : (primary ? AppConfig.brandColor : AppColors.textPrimary);
    return Column(
      children: [
        Material(
          color: primary && !disabled
              ? AppConfig.brandColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.notoSans(fontSize: 11, color: color)),
      ],
    );
  }
}

