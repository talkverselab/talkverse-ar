import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/auth/auth_gate.dart';
import 'core/config/app_config.dart';
import 'core/data/favorite_words.dart';
import 'core/data/grammar_progress.dart';
import 'core/data/user_progress.dart';
import 'core/data/user_stats.dart';
import 'core/data/word_data.dart';
import 'core/data/word_reviews.dart';
import 'core/services/adult_gate_service.dart';
import 'core/services/adult_verification_service.dart';
import 'core/services/asset_seed_loader.dart';
import 'core/services/grammar_loader.dart';
import 'core/services/language_service.dart';
import 'core/services/learning_preferences.dart';
import 'core/services/subscription_service.dart';
import 'core/services/sync_service.dart';
import 'core/services/tier_service.dart';
import 'core/supabase/supabase_config.dart';
import 'core/supabase/supabase_service.dart';
import 'core/theme/ar_theme.dart';

void _log(String step) {
  assert(() {
    // ignore: avoid_print
    print('[bootstrap] $step');
    return true;
  }());
}

Future<T?> _withTimeout<T>(Future<T> f, Duration d, String label) async {
  try {
    return await f.timeout(d);
  } on TimeoutException {
    _log('TIMEOUT: $label ($d)');
    return null;
  } catch (e) {
    _log('ERROR: $label → $e');
    return null;
  }
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  _log('1. binding ready');

  await _withTimeout(
    Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    ),
    const Duration(seconds: 10),
    'Supabase.initialize',
  );
  _log('2. supabase init done');

  await SupabaseService.instance.init();
  _log('3. supabase service init');

  await LanguageService.instance.init();
  _log('4. language service init (${LanguageService.instance.code.value})');

  // 콘텐츠 데이터 소스 선택 (2026-05-12 Option A):
  //   USE_LOCAL_DATA=true  → 번들 JSON (assets/data/{lang}/items.json) 에서 Drift 시드.
  //   USE_LOCAL_DATA=false → Supabase 네트워크 sync (legacy 동작).
  // 기본값 true — 현재는 Local JSON. 나중에 Supabase 복귀 시 flag 만 끄면 됨.
  // 빌드: flutter build apk --flavor {lang} --dart-define=USE_LOCAL_DATA=false  ← Supabase
  //       (기본 빌드는 USE_LOCAL_DATA=true 와 동등)
  const useLocalData = bool.fromEnvironment('USE_LOCAL_DATA', defaultValue: true);

  if (useLocalData) {
    _log('5. AssetSeedLoader (USE_LOCAL_DATA=true) — bundled JSON');
    await _withTimeout(AssetSeedLoader.instance.ensureLoaded(),
        const Duration(seconds: 30), 'AssetSeedLoader.ensureLoaded');
    _log('5. AssetSeedLoader done');
  } else {
    // 네트워크 sync — 오프라인이어도 계속 진행하게 타임아웃.
    await _withTimeout(SyncService.instance.syncItems(),
        const Duration(seconds: 20), 'syncItems');
    _log('5. syncItems done');
    await _withTimeout(SyncService.instance.syncHanziStudies(),
        const Duration(seconds: 10), 'syncHanziStudies');
    _log('6. syncHanziStudies done');
    await _withTimeout(SyncService.instance.syncEtymon(),
        const Duration(seconds: 10), 'syncEtymon');
    _log('7. syncEtymon done');
  }

  await loadWords();
  _log('8. loadWords done');

  // 자동 복구: 현 언어 in-memory pool 이 비정상으로 적으면
  // (sync 부분 실패·schema 불일치·watermark 꼬임 등) hardResync 1회 시도.
  // 임계값 10 = 정상 언어는 항상 100+ items, 0~2 같은 증상의 신호.
  // (5번 실수 방지 — Decision 56~58 후속 부수 fix, 2026-04-27)
  {
    final lang = LanguageService.instance.code.value;
    final mnCount = wordData.length + sentences.length + phrases.length;
    final langCount = allItems
        .where((w) => w.id.startsWith('$lang:'))
        .length;
    if (kDebugMode) {
      _log('8.1 item count check — lang=$lang langItems=$langCount '
          '(global cache=$mnCount)');
    }
    if (langCount < 10) {
      _log('8.1 ⚠ langCount=$langCount < 10 — hardResyncItems 시도');
      try {
        if (useLocalData) {
          await _withTimeout(AssetSeedLoader.instance.hardResyncItems(),
              const Duration(seconds: 30), 'AssetSeedLoader.hardResyncItems');
        } else {
          await _withTimeout(SyncService.instance.hardResyncItems(),
              const Duration(seconds: 30), 'SyncService.hardResyncItems');
        }
        final retryCount = allItems
            .where((w) => w.id.startsWith('$lang:'))
            .length;
        _log('8.1 hardResync 후 langCount=$retryCount');
        if (retryCount < 10 && kDebugMode) {
          if (useLocalData) {
            debugPrint('🔴 [main] $lang 데이터 여전히 부족 ($retryCount). '
                'assets/data/$lang/items.json 누락 또는 손상 가능. '
                'pubspec.yaml assets 선언 + 자산 재빌드 확인.');
          } else {
            debugPrint('🔴 [main] $lang 데이터 여전히 부족 ($retryCount). '
                'Supabase Studio 에서 seed_dialogue_'
                '${lang}_*.sql + seed_words_$lang.sql 등 적용 필요.');
          }
        }
      } catch (e) {
        _log('8.1 hardResync 실패: $e');
      }
    }
  }

  await _withTimeout(UserProgress().init(), const Duration(seconds: 5), 'UserProgress');
  _log('8a. UserProgress');
  await _withTimeout(UserStats().init(), const Duration(seconds: 5), 'UserStats');
  _log('8b. UserStats');
  await _withTimeout(WordReviews().init(), const Duration(seconds: 5), 'WordReviews');
  _log('8c. WordReviews');
  await _withTimeout(FavoriteWords().init(), const Duration(seconds: 5), 'FavoriteWords');
  _log('8d. FavoriteWords');
  await _withTimeout(
      GrammarRepository.loadForLanguage(LanguageService.instance.code.value),
      const Duration(seconds: 5),
      'grammar load');
  _log('8e. grammar');
  await _withTimeout(GrammarProgress.instance.init(), const Duration(seconds: 5), 'GrammarProgress');
  _log('8f. GrammarProgress');
  await _withTimeout(LearningPreferences.instance.init(), const Duration(seconds: 5), 'LearningPreferences');
  _log('8g. LearningPreferences');
  await _withTimeout(AdultGateService.instance.init(), const Duration(seconds: 5), 'AdultGateService');
  _log('8h. AdultGateService');
  await _withTimeout(AdultVerificationService.instance.init(), const Duration(seconds: 5), 'AdultVerificationService');
  _log('8i. AdultVerificationService');
  await _withTimeout(SubscriptionService.instance.init(), const Duration(seconds: 10), 'SubscriptionService');
  await _withTimeout(TierService.instance.load(), const Duration(seconds: 5), 'TierService');
  _log('9. services init done');

  _log('10. runApp');
  runApp(const MyApp());
}

void main() {
  // Sentry 비활성화 (일시) — splash 멈춤 디버깅 중.
  // 나중에 SENTRY_ENABLED=true 환경에서만 켜도록 전환.
  const sentryEnabled = bool.fromEnvironment('SENTRY_ENABLED', defaultValue: false);
  final dsn = AppConfig.sentryDsn;
  if (!sentryEnabled || dsn.isEmpty) {
    _bootstrap();
    return;
  }

  SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      options.environment = AppConfig.sentryEnvironment;
      options.tracesSampleRate =
          AppConfig.sentryEnvironment == 'production' ? 0.2 : 1.0;
      // attachScreenshot / attachViewHierarchy 는 experimental — 안정성 확인 후 추가.
    },
    appRunner: _bootstrap,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild the whole MaterialApp whenever the user toggles language
    // in 내 정보 — theme's seedColor, title, and every AppConfig.*
    // getter re-resolves under the new code.
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.instance.code,
      builder: (context, _, __) {
        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          // 아랍풍 전역 테마 (2026-08 UX 개편 — zh 앱 구조 이식).
          theme: ArTheme.light(),
          home: const AuthGate(),
        );
      },
    );
  }
}
