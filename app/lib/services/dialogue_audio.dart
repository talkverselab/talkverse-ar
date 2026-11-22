import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'dialogue_service.dart';
import 'learner_prefs.dart';
import 'tts_service.dart';

/// 회화 턴 소리: 녹음 음성(서버)이 있으면 녹음, 없으면 기기 음성(TTS) — 사용자 지시 2026-11-22
/// 「음성이 없는건 TTS로 하도록」(uk 전달). 일본어앱 `dialogue_audio.dart` 와 같은 규격.
///
/// 음성 목록: `GET https://auth.talkverse.uk/art/ar/audio/manifest?episode=<편id>` →
/// `{base, items:[{episode, turn, voice(m|f), key, ms, text}]}` (규격 `~/talkverse/ja/docs/DIALOGUE_AUDIO.md`).
/// 편마다 처음 들을 때 한 번 받아 메모리에 둔다(실패하면 1분 뒤 다시). 학습자 성별의 판(m·f)을 쓴다.
/// 대사를 고쳐 옛 음성의 글(`text`)이 지금 대사와 안 맞는 줄은 녹음을 쓰지 않고 TTS 로 읽는다.
class DialogueAudio {
  DialogueAudio._();
  static final DialogueAudio instance = DialogueAudio._();

  static const manifestUrl = 'https://auth.talkverse.uk/art/ar/audio/manifest';

  final Map<String, Map<String, Map<String, dynamic>>> _lines = {}; // 편 → '턴:판' → 항목
  final Map<String, DateTime> _failedAt = {};
  final Map<String, Future<void>> _loading = {};
  String _base = 'https://auth.talkverse.uk/art/';

  AudioPlayer? _player;
  Completer<void>? _wait;
  int _gen = 0;

  Future<void> _load(String ep) {
    if (_lines.containsKey(ep)) return Future.value();
    final f = _failedAt[ep];
    if (f != null && DateTime.now().difference(f) < const Duration(minutes: 1)) return Future.value();
    return _loading[ep] ??= () async {
      try {
        final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
        final req = await client.getUrl(Uri.parse('$manifestUrl?episode=${Uri.encodeQueryComponent(ep)}'));
        final res = await req.close().timeout(const Duration(seconds: 8));
        if (res.statusCode != 200) throw 'HTTP ${res.statusCode}';
        final j = json.decode(await res.transform(utf8.decoder).join()) as Map<String, dynamic>;
        client.close();
        _base = (j['base'] as String?) ?? _base;
        final m = <String, Map<String, dynamic>>{};
        for (final it in (j['items'] as List? ?? const [])) {
          if (it is Map<String, dynamic> && it['episode'] == ep) m['${it['turn']}:${it['voice']}'] = it;
        }
        _lines[ep] = m;
      } catch (e) {
        _failedAt[ep] = DateTime.now();
        debugPrint('DialogueAudio: 목록 실패 $ep $e');
      } finally {
        _loading.remove(ep);
      }
    }();
  }

  /// 대사(이름 자리 `{name}` 은 빼고)의 조각이 음성 글에 순서대로 다 있으면 같은 대사로 본다.
  static bool _same(String turnText, String audioText) {
    String n(String s) => s.replaceAll(RegExp(r'[\sً-ْـ.,!?؟،…«»"]+'), '');
    final a = n(audioText);
    var at = 0;
    for (final part in turnText.split(RegExp(r'\{[a-z_]+\}'))) {
      final p = n(part);
      if (p.isEmpty) continue;
      final i = a.indexOf(p, at);
      if (i < 0) return false;
      at = i + p.length;
    }
    return true;
  }

  /// 녹음을 끝까지 재생한다. 녹음이 없거나·대사가 바뀌었거나·재생에 실패하면 false(부르는 쪽이 TTS 로).
  Future<bool> play(Dialogue d, DialogueTurn t, {double rate = 1.0}) async {
    final my = ++_gen;
    await _load(d.id);
    if (my != _gen) return true; // 그새 다른 줄을 눌렀다 — 이 줄은 읽지 않는다
    final l = _lines[d.id]?['${t.num}:${LearnerPrefs.isFemale ? 'f' : 'm'}'];
    if (l == null || !_same(t.tl, (l['text'] as String?) ?? '')) return false;
    try {
      await TtsService.instance.stop();
      final p = _player ??= AudioPlayer();
      await p.stop();
      _wait?.complete();
      final done = _wait = Completer<void>();
      final sub = p.onPlayerComplete.listen((_) {
        if (!done.isCompleted) done.complete();
      });
      try {
        await p.setPlaybackRate(rate);
        await p.play(UrlSource('$_base${l['key']}')).timeout(const Duration(seconds: 12));
        if (my != _gen) return true;
        await p.setPlaybackRate(rate); // 일부 기기는 재생을 시작한 뒤에야 속도가 먹는다
        final ms = (l['ms'] as num?)?.toInt() ?? 8000;
        await done.future.timeout(Duration(milliseconds: (ms / rate).round() + 6000), onTimeout: () {});
      } finally {
        await sub.cancel();
      }
      return true;
    } catch (e) {
      debugPrint('DialogueAudio: 재생 실패 ${d.id}/${t.num} $e');
      return false;
    }
  }

  Future<void> stop() async {
    _gen++;
    final w = _wait;
    if (w != null && !w.isCompleted) w.complete();
    try {
      await _player?.stop();
    } catch (_) {}
    await TtsService.instance.stop();
  }
}

/// 턴 하나 읽기: 녹음이 있으면 녹음, 없으면 기기 음성.
/// rate = 재생 속도 배수(1.0 = 보통), ttsRate = 기기 음성 말 속도(없으면 TtsService 기본 0.45).
Future<void> speakTurn(Dialogue d, DialogueTurn t, {double rate = 1.0, double? ttsRate}) async {
  if (await DialogueAudio.instance.play(d, t, rate: rate)) return;
  final s = t.tl.replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\{[a-z_]+\}'), '').trim();
  await TtsService.instance.speakAs(s, gender: d.voiceGender(t.speaker), rate: ttsRate);
}
