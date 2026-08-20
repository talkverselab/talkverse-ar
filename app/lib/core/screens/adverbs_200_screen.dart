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

/// 몽골어 부사·표현 200 — 영화/일상 회화 빈출 표현 플래시카드.
///
/// 각 entry: { num, mn, pron(한글 발음), ko, key }
/// 자산: assets/adverbs_200_mn/{data.json, audio_manifest.json, audio/<hash>.mp3}
/// 동작: 한국어 (앞) → 탭 → 몽골어 + 한글 발음 + Azure mn-MN TTS 자동재생
class Adverbs200Screen extends StatefulWidget {
  const Adverbs200Screen({super.key});

  @override
  State<Adverbs200Screen> createState() => _Adverbs200ScreenState();
}

class _Adverbs200ScreenState extends State<Adverbs200Screen> {
  List<Map<String, dynamic>>? _entries;
  Set<String>? _audioManifest;
  String _title = '몽골어 부사·표현 200';

  int _index = 0;
  bool _showBack = false;
  bool _autoPlay = true;
  final AudioPlayer _ttsPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadAudioManifest();
  }

  @override
  void dispose() {
    _ttsPlayer.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final raw = await rootBundle.loadString('assets/adverbs_200_mn/data.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final entries = (json['entries'] as List).cast<Map<String, dynamic>>();
      if (mounted) {
        setState(() {
          _entries = entries;
          _title = (json['title'] as String?) ?? _title;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _entries = []);
    }
  }

  Future<void> _loadAudioManifest() async {
    try {
      final raw = await rootBundle
          .loadString('assets/adverbs_200_mn/audio_manifest.json');
      final m = jsonDecode(raw) as Map<String, dynamic>;
      if (mounted) setState(() => _audioManifest = m.keys.toSet());
    } catch (_) {
      if (mounted) setState(() => _audioManifest = <String>{});
    }
  }

  String _textHash(String text) {
    final bytes = utf8.encode(text.trim());
    return md5.convert(bytes).toString().substring(0, 12);
  }

  Future<void> _speakMn() async {
    if (_entries == null || _entries!.isEmpty) return;
    final text = (_entries![_index]['mn'] as String? ?? '').trim();
    if (text.isEmpty) return;
    final hash = _textHash(text);
    if (_audioManifest != null && _audioManifest!.contains(hash)) {
      try {
        await _ttsPlayer.stop();
        await _ttsPlayer.play(AssetSource('adverbs_200_mn/audio/$hash.mp3'));
        return;
      } catch (e) {
        if (kDebugMode) debugPrint('[adverbs200] mp3 fail: $e');
      }
    }
    await TtsService.instance.setLanguageOverride(null);
    await TtsService.instance.speak(text, delay: Duration.zero);
  }

  void _next() {
    if (_entries == null) return;
    if (_index < _entries!.length - 1) {
      setState(() {
        _index++;
        _showBack = false;
      });
      _ttsPlayer.stop();
      TtsService.instance.stop();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _showBack = false;
      });
      _ttsPlayer.stop();
      TtsService.instance.stop();
    }
  }

  void _toggleFlip() {
    setState(() => _showBack = !_showBack);
    if (_showBack) {
      if (_autoPlay) {
        Future.delayed(const Duration(milliseconds: 200), _speakMn);
      }
    } else {
      _ttsPlayer.stop();
      TtsService.instance.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    if (entries == null) {
      return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (entries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: const Center(child: Text('데이터 없음')),
      );
    }

    final entry = entries[_index];
    final mn = entry['mn'] as String? ?? '';
    final pron = entry['pron'] as String? ?? '';
    final ko = entry['ko'] as String? ?? '';
    final keyHint = entry['key'] as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('🎯 부사·표현 200',
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
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_index + 1} / ${entries.length}',
                      style: GoogleFonts.notoSans(
                          fontSize: 14, color: AppColors.textSecondary)),
                  Text(_showBack ? '몽골어 정답' : '뜻 보고 → 탭',
                      style: GoogleFonts.notoSans(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (_index + 1) / entries.length,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(AppConfig.brandColor),
                minHeight: 4,
              ),
              const SizedBox(height: 24),
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
                        child: _showBack
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(mn,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSans(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppConfig.brandColor,
                                          height: 1.5)),
                                  if (pron.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(pron,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoSans(
                                            fontSize: 16,
                                            color: AppColors.textSecondary,
                                            height: 1.4)),
                                  ],
                                  if (keyHint.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Text(keyHint,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoSans(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.textSecondary)),
                                  ],
                                ],
                              )
                            : Text(ko,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.5)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                    onPressed: _speakMn,
                  ),
                  _ControlButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    label: '다음',
                    onPressed:
                        _index < entries.length - 1 ? _next : null,
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
