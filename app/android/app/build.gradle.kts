import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 릴리스 서명: android/key.properties 가 있으면 사용, 없으면 debug 키 폴백.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKey = keystorePropertiesFile.exists()
if (hasReleaseKey) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.talkverse.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // applicationId set per flavor below.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // `draft` flavor for active development (single Android package,
    // content language picked at Dart compile time via --dart-define).
    // Per-language flavors (22) for distinct Play Store apps.
    // Build commands:
    //   flutter build apk --flavor draft
    //   flutter build apk --flavor mn --dart-define=APP_FLAVOR=mn
    //   flutter build apk --flavor vi --dart-define=APP_FLAVOR=vi
    flavorDimensions += "stage"
    productFlavors {
        create("draft") {
            dimension = "stage"
            applicationId = "com.talkverse.draft"
            manifestPlaceholders["appLabel"] = "Talkverse"
        }
        // 20 language flavors — keep alphabetical to match lib/flavors/.
        // LO removed (2026-05-12) — Lao content lives inside TH flavor as appendix (Decision 41).
        listOf(
            "ar", "de", "en", "es", "fa", "fr", "id", "ja", "kk",
            "ko", "mn", "ms", "my", "pl", "pt",
            "ru", "th", "tr", "vi", "zh",
        ).forEach { lang ->
            create(lang) {
                dimension = "stage"
                applicationId = "com.talkverse.$lang"
                manifestPlaceholders["appLabel"] = "아랍어유니버스"
            }
        }
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
