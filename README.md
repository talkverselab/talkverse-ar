# 아랍어유니버스 (Talkverse AR)

한국어 화자 대상 아랍어 학습 앱 — Flutter (Material 3) + Drift, 번들 JSON 콘텐츠(5,080 항목).
`talkverse-learning-flavors` 모노레포에서 `ar` flavor 만 분리한 standalone 앱.

## 구조 (2026-08 UX 개편, zh 앱 구조 이식)
- 4탭: **홈 / 학습 / 진행 / 프로필** (`lib/core/screens/main_screen.dart`, `progress_screen.dart`)
- 아랍풍 테마: 녹색·금·상아색 (`lib/core/theme/ar_theme.dart`, `app_colors.dart`)
- 장식 위젯: 인장·8각별 문양·아치 디바이더 (`lib/core/widgets/arabic_decor.dart`)
- 아랍어 텍스트는 `ArabicText` / `arabicStyle` 로 **RTL + Amiri** 렌더링
- 키보드 연습: 홈 메뉴 + 학습 탭에서 진입, L1/L2 × 단어/회화 picker 유지, RTL 입력, 타슈킬 무시 채점

## 실행
```powershell
cd app
flutter pub get
flutter run -d <device> --flavor ar --target lib/main_ar.dart --dart-define=APP_FLAVOR=ar --dart-define=DEV_UNLOCK=true
```

## 폴더
- `app/` Flutter 앱
- `arzen/` ArzEn 코퍼스(raw)
