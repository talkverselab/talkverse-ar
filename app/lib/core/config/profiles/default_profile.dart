import 'package:flutter/material.dart';

import '../language_profile.dart';

/// 특별한 언어별 특징이 없는 언어를 위한 concrete 프로필. 14개 언어 중
/// 실제 커리큘럼 content 확장 전 단계에선 ko/th/vi/es/en/fr/mn/ar/fa/my/id
/// 모두 이 프로필로 등록. 필요 시 해당 언어 전용 서브클래스로 승격.
///
/// `brandColor` 파라미터로 각 국가 상징 컬러를 주입받아 테마 seed 로 사용.
class DefaultProfile extends LanguageProfile {
  @override
  final String code;
  @override
  final String nameKo;
  @override
  final String nameEn;
  @override
  final String flagEmoji;
  @override
  final String ttsLocale;
  @override
  final bool hasHanjaSupport;
  @override
  final bool isRtl;
  @override
  final bool hasArabicAlphabetMenu;
  @override
  final bool hasArabicAffixGameMenu;
  @override
  final bool hasMyanmarAlphabetMenu;

  final Color? brandColor;
  final String uniqueAlphabetValue;

  const DefaultProfile({
    required this.code,
    required this.nameKo,
    required this.nameEn,
    required this.flagEmoji,
    required this.ttsLocale,
    required this.uniqueAlphabetValue,
    this.hasHanjaSupport = false,
    this.isRtl = false,
    this.hasArabicAlphabetMenu = false,
    this.hasArabicAffixGameMenu = false,
    this.hasMyanmarAlphabetMenu = false,
    this.brandColor,
  });

  @override
  Color? get brandColorOverride => brandColor;

  @override
  String get uniqueAlphabet => uniqueAlphabetValue;
}
