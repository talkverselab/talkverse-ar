import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/chat_dialogue.dart';

/// VI dialogue JSON loader (chat / dating / travel / business).
///
/// 자산 경로:
///   assets/conversation_{theme}_vi/{theme}_{dialect}.json
///   theme:   'chat' | 'dating' | 'travel' | 'business'
///   dialect: 'north' | 'south'
class ChatDialogueLoader {
  static final Map<String, List<ChatDialogue>> _cache = {};

  /// 주어진 theme + dialect 의 모든 dialogue 로드.
  /// 미발견 시 빈 리스트 반환.
  static Future<List<ChatDialogue>> load(
    String dialect, {
    String theme = 'chat',
  }) async {
    final cacheKey = 'vi:$theme:$dialect';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    try {
      final raw = await rootBundle.loadString(
          'assets/conversation_${theme}_vi/${theme}_$dialect.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final list = (json['dialogues'] as List)
          .cast<Map<String, dynamic>>()
          .map(ChatDialogue.fromJson)
          .toList();
      _cache[cacheKey] = list;
      return list;
    } catch (_) {
      _cache[cacheKey] = const [];
      return const [];
    }
  }

  /// 캐시 클리어 — dialect 변경 후 호출.
  static void clearCache() {
    _cache.clear();
  }
}
