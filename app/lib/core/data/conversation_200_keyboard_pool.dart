import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/word.dart';
import '../services/language_service.dart';

/// conversation_200_vi 의 sentence를 KeyboardScreen 이 쓸 수 있는 Word 객체 list로 변환.
///
/// dialect 는 LanguageService.instance.viRegion 에 따라 자동 분기:
///   'north' → conv200_north.json
///   'south' → conv200_south.json
///
/// 생성된 Word 의 핵심 필드:
///   id          = 'vi:conv200:001' ~ 'vi:conv200:200' (dialect 무관 공유)
///   type        = ItemType.sentence
///   target      = entry['vi']
///   korean      = entry['ko']
///   romanization= entry['pron']
///   course      = 1 (기초 레벨)
///   notes       = entry['key'] (어기조사·신규단어 설명)
///
/// SRS·통계 측면에서 conversation_200_vi_screen 과 같은 itemId 사용 → 진도 공유.
Future<List<Word>> loadConversation200KeyboardPool() async {
  final dialect = LanguageService.instance.viRegion.value;
  final assetPath =
      'assets/conversation_200_vi/conv200_$dialect.json';

  final raw = await rootBundle.loadString(assetPath);
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final entries = (json['entries'] as List).cast<Map<String, dynamic>>();

  return entries.map((e) {
    final num = e['num'] as int;
    final id = 'vi:conv200:${num.toString().padLeft(3, '0')}';
    return Word(
      id: id,
      type: ItemType.sentence,
      target: (e['vi'] as String?) ?? '',
      korean: (e['ko'] as String?) ?? '',
      romanization: (e['pron'] as String?) ?? '',
      category: 'conv200',
      course: 1,
      tags: const {'conv200', 'keyboard'},
      notes: (e['key'] as String?) ?? '',
      turnOrder: num,
      tier: 'beginner',
    );
  }).toList();
}
