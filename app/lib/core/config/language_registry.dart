import '../services/language_service.dart';
import '../theme/app_colors.dart';
import 'language_profile.dart';
import 'package:talkverse/core/config/profiles/default_profile.dart';

/// 아랍어 전용 [LanguageProfile] 레지스트리 (slim 빌드).
///
/// 원본 모노레포(talkverse-learning-flavors)에서 아랍어만 분리한 standalone
/// 앱이라 레지스트리에는 'ar' 하나만 등록한다. 다른 언어 profile/flavor 는
/// 가져오지 않는다. fallback 역시 'ar' 로 고정.
class LanguageRegistry {
  LanguageRegistry._();

  /// 레지스트리 본체. key = language code (아랍어만).
  static const Map<String, LanguageProfile> _profiles = {
    // 아랍어 — 기본 TTS = ar-EG (이집트). 우리 dialogue가 Egyptian dialect라
    // 일치시킴. 사용자가 MSA 격식 듣고 싶을 땐 향후 dialect toggle (예정).
    'ar': DefaultProfile(
        code: 'ar',
        nameKo: '아랍어',
        nameEn: 'Arabic',
        flagEmoji: '🇪🇬',
        ttsLocale: 'ar-EG',
        isRtl: true,
        hasArabicAlphabetMenu: true,
        hasArabicAffixGameMenu: true,
        brandColor: AppColors.brandAr,
        uniqueAlphabetValue: 'ع'),
  };

  /// 부록(appendix) 언어 매핑. 아랍어 slim 빌드에는 부록 없음.
  static const Map<String, List<String>> appendices = {};

  /// 주어진 [mainLang]의 부록 코드 리스트 (없으면 빈 리스트).
  static List<String> appendicesFor(String mainLang) =>
      appendices[mainLang] ?? const [];

  /// 현재 활성 언어 프로필. 아랍어 slim 빌드라 항상 'ar'.
  static LanguageProfile get current {
    final code = LanguageService.instance.code.value;
    return _profiles[code] ?? _profiles['ar']!;
  }

  /// 특정 code 로 프로필 조회. 등록되지 않은 code는 아랍어 fallback.
  static LanguageProfile forCode(String code) {
    return _profiles[code] ?? _profiles['ar']!;
  }

  /// 등록된 전체 언어 코드 목록.
  static Iterable<String> get allCodes => _profiles.keys;
}
