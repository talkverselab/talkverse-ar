import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Runtime-switchable language code (BCP-47-ish: 'zh', 'ru', 'ja', …).
///
/// We used to bake the target language into AppConfig at compile time
/// via `--dart-define=APP_FLAVOR=…`. That's still the *initial* value
/// on first launch, but after that the user can flip the language in
/// 내 정보 and the UI rebuilds around this notifier.
///
/// AppConfig's getters all read `LanguageService.instance.code.value`,
/// so anything touching language-specific config (TTS locale, hanja
/// support, flag emoji, grammar tag colors, etc.) will re-evaluate
/// when the code changes.
class LanguageService {
  static const _prefsKey = 'app_language_code_v1';
  /// 베트남어 방언 모드. 'north' (기본, 하노이 표준) 또는 'south' (호치민).
  /// vi 외 언어에서는 무시됨. 메인 화면 토글로 변경.
  static const _viRegionKey = 'vi_region_v1';
  /// 스페인어 발음·어휘 모드. 'latam' (기본, 멕시코 기준) 또는 'spain' (이베리아).
  /// es 외 언어에서는 무시됨. 메인 화면 토글로 변경.
  static const _esRegionKey = 'es_region_v1';
  /// 베트남어 호칭 시나리오 (1~5). placeholder `{{self}}/{{other}}` 치환에 사용.
  /// vi 외 언어에서는 무시됨.
  static const _viScenarioKey = 'vi_scenario_v1';

  static final LanguageService instance = LanguageService._();
  LanguageService._();

  late SharedPreferences _prefs;

  /// Current language code. Start value is the compile-time
  /// APP_FLAVOR mapped to its BCP-47 code. User override wins
  /// after that.
  final ValueNotifier<String> code = ValueNotifier(_initialCode);

  /// 베트남어 방언 — 'north' 기본, 'south' 선택 시 row.targetSouth 우선.
  /// 영구 저장 (SharedPreferences). 메인 화면 토글이 이 값을 변경.
  final ValueNotifier<String> viRegion = ValueNotifier('north');

  /// 스페인어 발음·어휘 — 'latam' 기본 (멕시코 기준 데이터),
  /// 'spain' 선택 시 row.targetSpain 우선.
  final ValueNotifier<String> esRegion = ValueNotifier('latam');

  /// 베트남어 호칭 시나리오 (1~5). 사용자 프로필(성별·상대 연령) 기반.
  /// 1: 여 연하 → 남 연상 (em → anh)  -- default
  /// 2: 여 연하 → 여 연상 (em → chị)
  /// 3: 남 연하 → 남 연상 (em → anh)
  /// 4: 남 연하 → 여 연상 (em → chị)
  /// 5: 동년배 친구 (tớ → cậu)
  final ValueNotifier<int> viScenario = ValueNotifier(1);

  static String get _initialCode {
    const flavor =
        String.fromEnvironment('APP_FLAVOR', defaultValue: 'arabic');
    return switch (flavor) {
      'chinese' => 'zh',
      'japanese' => 'ja',
      'korean' => 'ko',
      'russian' => 'ru',
      'spanish' => 'es',
      'english' => 'en',
      'french' => 'fr',
      'mongolian' => 'mn',
      'thai' => 'th',
      'vietnamese' => 'vi',
      'arabic' => 'ar',
      'persian' => 'fa',
      'burmese' => 'my',
      'indonesian' => 'id',
      _ => flavor, // already a BCP-47 code
    };
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs.getString(_prefsKey);
    if (stored != null && stored.isNotEmpty) {
      code.value = stored;
    }
    final viRegionStored = _prefs.getString(_viRegionKey);
    if (viRegionStored == 'south' || viRegionStored == 'north') {
      viRegion.value = viRegionStored!;
    }
    final esRegionStored = _prefs.getString(_esRegionKey);
    if (esRegionStored == 'latam' || esRegionStored == 'spain') {
      esRegion.value = esRegionStored!;
    }
    final viScenarioStored = _prefs.getInt(_viScenarioKey);
    if (viScenarioStored != null &&
        viScenarioStored >= 1 &&
        viScenarioStored <= 5) {
      viScenario.value = viScenarioStored;
    }
  }

  Future<void> setLanguage(String newCode) async {
    if (code.value == newCode) return;
    await _prefs.setString(_prefsKey, newCode);
    code.value = newCode;
  }

  /// 베트남어 방언 변경. 'north' 또는 'south' 만 받음.
  Future<void> setViRegion(String region) async {
    if (region != 'north' && region != 'south') return;
    if (viRegion.value == region) return;
    await _prefs.setString(_viRegionKey, region);
    viRegion.value = region;
  }

  /// 스페인어 발음·어휘 모드 변경. 'latam' 또는 'spain' 만 받음.
  Future<void> setEsRegion(String region) async {
    if (region != 'latam' && region != 'spain') return;
    if (esRegion.value == region) return;
    await _prefs.setString(_esRegionKey, region);
    esRegion.value = region;
  }

  /// 베트남어 호칭 시나리오 변경. 1~5 만 받음.
  Future<void> setViScenario(int scenario) async {
    if (scenario < 1 || scenario > 5) return;
    if (viScenario.value == scenario) return;
    await _prefs.setInt(_viScenarioKey, scenario);
    viScenario.value = scenario;
  }

  /// All languages available in the UI picker, in display order.
  /// 부록 언어(ms/pt/lo/uk)는 여기에 노출하지 않음 — 부모 언어의 코스 선택 화면에서만 진입.
  static const List<({String code, String nameKo, String flag})> supported = [
    (code: 'ar', nameKo: '아랍어', flag: '🇪🇬'), // Egyptian 기본 TTS — slim 빌드는 아랍어만
  ];
}
