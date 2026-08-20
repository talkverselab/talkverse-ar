import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../theme/app_colors.dart';
import 'language_registry.dart';

// ==========================================================================
// Language-aware app configuration — RUNTIME resolved via LanguageRegistry.
//
// 기존 거대한 if/else 분기는 모두 `LanguageRegistry.current` 가 돌려주는
// LanguageProfile 객체로 위임됨. 새 언어 추가 = 새 profile 하나 등록.
// AppConfig는 기존 callsite를 깨지 않는 얇은 facade.
//
// 값이 `const` 가 아닌 이유: 런타임에 LanguageService 가 바뀌면 프로필도
// 교체되므로 const 불가. 위젯 트리는 LanguageService.instance.code 에
// ValueListenableBuilder 로 rebuild 됨.
// ==========================================================================

class AppConfig {
  AppConfig._();

  // ---------------- Language resolution ----------------
  static String get languageCode => LanguageService.instance.code.value;

  /// CJK Hanzi/Kanji 학습 메뉴 노출 여부 (profile 제공).
  static bool get hasHanjaSupport =>
      LanguageRegistry.current.hasHanjaSupport;

  /// AR 알파벳 메뉴 (사알투무니하) 노출 여부.
  static bool get hasArabicAlphabetMenu =>
      LanguageRegistry.current.hasArabicAlphabetMenu;

  /// AR 접사게임 메뉴 (5 패턴) 노출 여부.
  static bool get hasArabicAffixGameMenu =>
      LanguageRegistry.current.hasArabicAffixGameMenu;

  /// MY 알파벳 메뉴 (자음 33 + 모음 19 + 톤 4 + 결합 4) 노출 여부.
  static bool get hasMyanmarAlphabetMenu =>
      LanguageRegistry.current.hasMyanmarAlphabetMenu;

  // ---------------- Crash reporting ----------------
  /// Sentry DSN. 빈 문자열이면 Sentry 비활성화.
  /// Sentry DSN은 공개용 public key로 소스 노출 OK (데이터 전송만, 조회 불가).
  /// 빌드 시 덮어쓰고 싶으면: --dart-define=SENTRY_DSN=https://...@sentry.io/...
  static String get sentryDsn => const String.fromEnvironment(
        'SENTRY_DSN',
        defaultValue:
            'https://f7f18a2193188535402e275a487da35b@o4511268520919040.ingest.us.sentry.io/4511268522295296',
      );

  /// Sentry 환경 태그. --dart-define=SENTRY_ENV=production 으로 override.
  static String get sentryEnvironment => const String.fromEnvironment(
        'SENTRY_ENV',
        defaultValue: 'development',
      );

  // ---------------- Branding ----------------
  /// Android task switcher / MaterialApp title. 언어 무관 고정.
  static const String appName = 'Talkverse';

  static String get targetLanguageName => LanguageRegistry.current.nameKo;
  static String get targetLanguageEnglish => LanguageRegistry.current.nameEn;
  static String get flagEmoji => LanguageRegistry.current.flagEmoji;

  static String get homeTitlePrefix => '$flagEmoji $targetLanguageName';
  static String get homeTitleSuffix => '학습 앱';
  static String get homeSubtitle =>
      '오늘도 $targetLanguageName 공부 시작해볼까요?';

  // ---------------- TTS ----------------
  static String get ttsLocale => LanguageRegistry.current.ttsLocale;
  static const double ttsDefaultRate = 0.45;
  static const double ttsPitch = 1.0;

  // ---------------- Theme ----------------
  /// 브랜드 컬러 — 언어별 override (국가 상징 컬러). fallback = brandDefault.
  /// MaterialApp의 ColorScheme.fromSeed 가 이 컬러를 시드로 전체 팔레트 파생.
  static Color get brandColor =>
      LanguageRegistry.current.brandColorOverride ?? AppColors.brandDefault;

  // ---------------- Assets ----------------
  static const String dataCsvPath = 'assets/data.csv';

  // ---------------- Menu copy ----------------
  static String get keyboardMenuSubtitle =>
      LanguageRegistry.current.keyboardMenuSubtitle ??
      '$targetLanguageName 타이핑 연습';
  static const String hanjaMenuTitle = '🀄 한자 공부';
  static const String hanjaMenuSubtitle = '부수 중심으로 관련 한자 한눈에';

  // ---------------- Courses ----------------
  // Theme per course (2026-04-24 재편, mirrored across all language flavors):
  //   1=필수, 2=채팅, 3=연애, 4=여행, 5=취미·팬덤, 6=Midnight Lounge
  // 비즈니스는 별도 트랙(코스 분류 외)으로 분리.
  static String courseDisplayName(int course) {
    switch (course) {
      case 1:
        return '필수';
      case 2:
        return '채팅';
      case 3:
        return '연애';
      case 4:
        return '여행';
      case 5:
        return '취미·팬덤';
      case 6:
        return 'Midnight Lounge';
      default:
        return '$course단계';
    }
  }

  static String courseEmoji(int course) {
    switch (course) {
      case 1:
        return '🌱';
      case 2:
        return '💬';
      case 3:
        return '💕';
      case 4:
        return '✈️';
      case 5:
        return '🎤';
      case 6:
        return '🌙';
      default:
        return '⭐';
    }
  }

  /// Course numbers that require explicit 18+ unlock in 내 정보.
  static const Set<int> adultGatedCourses = {6};

  // ---------------- Highlight / grammar tags ----------------
  /// Marker tag → Korean display name. 언어별 profile이 결정.
  static Map<String, String> get grammarTagNames =>
      LanguageRegistry.current.grammarTagNames;

  /// Marker tag → color. 언어별 profile이 결정.
  static Map<String, Color> get grammarTagColors =>
      LanguageRegistry.current.grammarTagColors;

  // ---------------- Gender tag (명사 성) 밑줄 색상 ----------------
  /// 언어에 문법적 성이 없으면 빈 map. marker 파서는 비어있으면 단순 skip.
  static Map<String, Color> get genderTagColors =>
      LanguageRegistry.current.genderTagColors ?? const {};

  static Map<String, String> get genderTagNames =>
      LanguageRegistry.current.genderTagNames ?? const {};
}
