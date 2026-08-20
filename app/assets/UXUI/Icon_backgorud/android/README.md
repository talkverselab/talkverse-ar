# Talkverse · Android 리소스 핸드오프

이 폴더는 **Android Studio 프로젝트의 `app/src/main/res/`에 그대로 복사**할 수 있는 리소스 모음이에요.

## 📁 폴더 구조

```
android/res/
├─ drawable/
│  ├─ ic_launcher_foreground.xml   ← Adaptive icon foreground (108dp)
│  ├─ ic_launcher_background.xml   ← Adaptive icon background (cream)
│  └─ splash_icon.xml              ← Splash screen icon (Android 12+)
├─ mipmap-anydpi-v26/
│  ├─ ic_launcher.xml              ← Adaptive icon manifest
│  └─ ic_launcher_round.xml        ← Round variant
├─ values/
│  ├─ colors.xml                   ← Brand 컬러 토큰
│  ├─ strings.xml                  ← 기본 (KO)
│  └─ themes.xml                   ← Splash 테마
└─ values-vi/
   └─ strings.xml                  ← 베트남어
```

---

## ✅ 적용 순서 (Claude Code 가이드)

### 1. 리소스 복사
```bash
cp -r android/res/* app/src/main/res/
```
기존 `values/colors.xml`, `themes.xml`, `strings.xml`이 있다면 **머지**하세요.

### 2. AndroidManifest.xml 수정
```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:roundIcon="@mipmap/ic_launcher_round"
    android:label="@string/app_name"
    android:theme="@style/Theme.Talkverse.Splash">  <!-- ← Splash 테마 -->
```

### 3. SplashScreen 의존성 (Android 12+ 호환)
`app/build.gradle.kts`:
```kotlin
dependencies {
    implementation("androidx.core:core-splashscreen:1.0.1")
}
```

### 4. MainActivity.kt
```kotlin
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()  // ← splash before super.onCreate
        super.onCreate(savedInstanceState)
        // ...
    }
}
```

### 5. (선택) PNG 폴백 생성
구형 디바이스(Android < 8.0)는 adaptive icon을 지원하지 않아요.
Android Studio → **Image Asset Studio** → Foreground로 `ic_launcher_foreground.xml`,
Background로 `@color/ic_launcher_background` 지정하면 자동으로
`mipmap-mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi`에 PNG가 생성됩니다.

---

## 🎨 디자인 토큰 (colors.xml)

| 이름 | 값 | 용도 |
|---|---|---|
| `brand_cream` | `#F4EDE0` | 앱 배경, 스플래시 |
| `brand_ink` | `#1F3A6E` | 본문 텍스트, 라인 |
| `mint_500` | `#7FCBA4` | 주요 액션, Talky 마스코트 |
| `pink_500` | `#FF8FB1` | 보조 강조 |
| `peach` | `#FFB59C` | 볼터치, 하트 |

---

## 🇻🇳 베트남어 카피

| 키 | 베트남어 | 한국어 |
|---|---|---|
| `app_name` | Talkverse | Talkverse |
| `splash_tagline` | Học tiếng Việt mỗi ngày | 매일 베트남어를 배워요 |
| `splash_greeting` | Tốt! | 좋아! |
| `splash_question` | Thử nhé? | 한번 해볼까? |

기본 로케일은 한국어. 시스템 언어가 베트남어면 자동으로 `values-vi/`가 적용돼요.

---

## 📐 규격 체크리스트

- ✅ Adaptive icon **108×108dp** 캔버스
- ✅ 안전영역 **72dp 중앙 원형** 안에 마스코트 배치
- ✅ Foreground/Background 레이어 분리 (시차 효과 지원)
- ✅ **Monochrome** 레이어 포함 (Android 13+ themed icon)
- ✅ Vector(VectorDrawable) — 모든 dpi 자동 대응
- ✅ Splash: Android 12+ `SplashScreen` API 표준 따름

---

## 🔍 미리보기

브라우저에서 `android/app-icon.html`을 열어 확인하세요:
- 4가지 마스크(원/스쿼클/라운드/풀) 미리보기
- 다크모드 대비 테스트
- 베트남어 스플래시 화면 시뮬레이션
