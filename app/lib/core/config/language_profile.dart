import 'package:flutter/material.dart';

/// 언어별 특성을 한 객체로 모은 프로필. AppConfig는 이제 `LanguageRegistry.current`
/// 가 돌려주는 이 객체의 getter들을 delegate 하는 얇은 facade로 동작.
///
/// 새 언어를 추가하거나 기존 언어의 문법 마커·참조표 등을 바꾸려면 해당 프로필
/// 파일 하나만 수정하면 됨 (기존 AppConfig if/else 분기 제거됨).
///
/// 구현 전략:
///   * 대부분의 언어는 [DefaultProfile]로 기본값만 지정 (code / 이름 / TTS).
///   * 문법 시각화(러시아어 격, 중국어 성조 등) 가 있는 언어는 전용 서브클래스.
abstract class LanguageProfile {
  const LanguageProfile();

  // ---------------- 기본 메타 ----------------
  String get code; // BCP-47: 'ru', 'zh', 'ja', ...
  String get nameKo; // 한국어 표기 ("러시아어")
  String get nameEn; // English name ("Russian")
  String get flagEmoji; // 🇷🇺
  String get ttsLocale; // 'ru-RU'

  // ---------------- Feature 플래그 ----------------

  /// CJK 한자/가나 학습 메뉴 노출. zh/ja만 true.
  bool get hasHanjaSupport => false;

  /// RTL 스크립트 (아랍어·페르시아어). 미구현 레이아웃 있으나 향후 확장 대비.
  bool get isRtl => false;

  /// AR 알파벳 메뉴 (사알투무니하 10 자) 노출 여부. AR 만 true.
  /// 사용처: 홈 메뉴 카드 조건부 노출.
  bool get hasArabicAlphabetMenu => false;

  /// AR 접사게임 메뉴 (5 패턴 명사 파생) 노출 여부. AR 만 true.
  /// 사용처: 홈 메뉴 카드 조건부 노출.
  bool get hasArabicAffixGameMenu => false;

  /// MY 알파벳 메뉴 (자음 33 + 모음 19 + 톤 4 + 결합 4) 노출 여부. MY 만 true.
  /// 사용처: 홈 메뉴 카드 조건부 노출. drop barrier 1번 (Burmese script).
  bool get hasMyanmarAlphabetMenu => false;

  /// 브랜드 색상 override. null이면 기본 파랑 사용.
  Color? get brandColorOverride => null;

  /// 홈 '키보드 연습' 카드의 subtitle. null이면 "{언어명} 타이핑 연습" 자동 생성.
  String? get keyboardMenuSubtitle => null;

  /// 홈 화면 히어로 이미지 PNG 경로 — 지구+말풍선 일러스트.
  /// 파일이 없으면 LanguageHeroImage 위젯이 자동 폴백 렌더 (지구 원 + flagEmoji + uniqueAlphabet).
  /// 규칙: assets/branding/hero_{code}.png. 러시아어(ru)만 기본 제공. 다른 언어는
  /// 같은 포맷으로 생성 후 드롭하면 자동 인식.
  String get heroImageAsset => 'assets/branding/hero_$code.png';

  /// 홈 히어로 이미지의 4시30분 위치 말풍선에 표시할 고유 알파벳(1~3자).
  /// 그 언어에만 있거나 가장 상징적인 문자로 정함. 히어로 PNG 가 없을 때
  /// 폴백 위젯이 이 값을 화면에 그림.
  String get uniqueAlphabet;

  // ---------------- 문법 마커 색상/라벨 ----------------

  /// `{nom:...}` 같은 격/성조/품사 마커 → 텍스트 색상.
  /// 빈 map이면 해당 언어는 marker 기반 하이라이팅 없음.
  Map<String, Color> get grammarTagColors => const {};

  /// 마커 코드 → 한국어 라벨 (예: 'nom' → '주격'). UI 툴팁 등에 사용.
  Map<String, String> get grammarTagNames => const {};

  /// 명사 성(性) 마커 → 밑줄 색상. 성이 없는 언어는 null.
  Map<String, Color>? get genderTagColors => null;

  /// 성 마커 → 한국어 라벨.
  Map<String, String>? get genderTagNames => null;

}
