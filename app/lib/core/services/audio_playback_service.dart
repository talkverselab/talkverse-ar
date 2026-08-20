import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../supabase/supabase_config.dart';

/// 사전 생성 mp3 (Azure Speech) 재생 + 디바이스 캐시.
///
/// **현재 적용 언어**: MN + DE + ID (Decision 56, 2026-04-26 / ID 추가 2026-04-27).
/// 다른 언어는 flutter_tts 직접 사용 — 본 서비스 호출 안 됨.
///
/// 흐름:
/// 1. itemId (예: `mn:sent:l1_d01_t01`) + variant (`normal`|`slow`) 받음
/// 2. 디바이스 캐시 (`<appSupportDir>/tts/<lang>/<variant>/<id>.mp3`) 확인
/// 3. 없으면 Supabase Storage 공개 bucket `tts` 에서 다운로드
/// 4. 로컬 파일 재생
///
/// 캐시 무효화 정책: 미구현. 콘텐츠 재생성 시 사용자가 앱 캐시 삭제 또는
/// 향후 콘텐츠 ver 컬럼으로 자동 무효화.
class AudioPlaybackService {
  AudioPlaybackService._internal();
  static final AudioPlaybackService instance = AudioPlaybackService._internal();

  final AudioPlayer _player = AudioPlayer();
  Directory? _cacheRoot;

  /// 본 서비스가 처리하는 언어 — 콘텐츠 데이터 갖춰지면 추가.
  /// 'id' 추가 (2026-04-27): Azure TTS (en-US-AndrewMultilingualNeural / id-ID-GadisNeural)
  ///                        1498 sentence Storage 업로드 완료.
  /// 'de' 제외 (2026-04-27): 디바이스 native TTS (de-DE) 음성 품질 양호 + 비용·빌드 작업 절약 결정.
  ///                        flutter_tts + tts_service.dart 의 _googleVoiceGenderMap 로 남녀 분리 처리.
  /// 미업로드 시 _download() 가 false 반환 → flutter_tts fallback 자동.
  static const Set<String> supportedLangs = {'mn', 'id'};

  Future<Directory> _ensureCacheRoot() async {
    if (_cacheRoot != null) return _cacheRoot!;
    final supportDir = await getApplicationSupportDirectory();
    final dir = Directory(p.join(supportDir.path, 'tts'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheRoot = dir;
    return dir;
  }

  /// itemId → 언어·문장 부분 추출. 형식: `<lang>:sent:<rest>`.
  /// 예: `mn:sent:l1_d01_t01` → ('mn', 'l1_d01_t01').
  /// 잘못된 형식이면 null.
  ({String lang, String suffix})? _parseItemId(String itemId) {
    final parts = itemId.split(':');
    if (parts.length < 3 || parts[1] != 'sent') return null;
    return (lang: parts[0], suffix: parts.sublist(2).join(':'));
  }

  String _publicUrl(String lang, String variant, String suffix) {
    return '${SupabaseConfig.url}/storage/v1/object/public/tts/$lang/$variant/$suffix.mp3';
  }

  Future<File> _localFile(String lang, String variant, String suffix) async {
    final root = await _ensureCacheRoot();
    final dir = Directory(p.join(root.path, lang, variant));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File(p.join(dir.path, '$suffix.mp3'));
  }

  /// itemId 의 언어가 본 서비스 처리 대상인지.
  bool canPlay(String itemId) {
    final parsed = _parseItemId(itemId);
    return parsed != null && supportedLangs.contains(parsed.lang);
  }

  /// mp3 재생 시도. 성공 시 true, 본 서비스 처리 대상 아니거나 실패 시 false.
  /// `slow=true` 면 -20% 변형 (Decision 57).
  /// 호출자: 결과가 false 면 flutter_tts 등 fallback 호출.
  Future<bool> playSentence(String itemId, {bool slow = false}) async {
    final parsed = _parseItemId(itemId);
    if (parsed == null || !supportedLangs.contains(parsed.lang)) return false;

    final variant = slow ? 'slow' : 'normal';
    final file = await _localFile(parsed.lang, variant, parsed.suffix);

    if (!await file.exists()) {
      final ok = await _download(
        _publicUrl(parsed.lang, variant, parsed.suffix),
        file,
      );
      if (!ok) return false;
    }

    try {
      await _player.stop();
      await _player.play(DeviceFileSource(file.path));
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioPlaybackService] play failed: $e');
      }
      return false;
    }
  }

  /// Storage URL → 로컬 파일 다운로드. 성공 시 true.
  Future<bool> _download(String url, File destination) async {
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) {
        if (kDebugMode) {
          debugPrint('[AudioPlaybackService] HTTP ${resp.statusCode}: $url');
        }
        return false;
      }
      if (resp.bodyBytes.length < 100) return false;
      final tmp = File('${destination.path}.tmp');
      await tmp.writeAsBytes(resp.bodyBytes, flush: true);
      await tmp.rename(destination.path);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioPlaybackService] download failed: $e');
      }
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }
}
