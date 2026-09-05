# Claude 업데이트 메모 — talkverse-ar (ar)

> 기준 앱: chinese_universe(zh). 이식 세부 규격은 `zh/docs/PORTING_GUIDE_2026-09.md` 참고.
> 작성: 2026-09-05 (Claude Code 세션). 이후 변경은 git log 참고.

## 변경 이력
- 코드 변경 **없음**. 2026-09-02 확인·푸시(원격 최신 상태)·릴리스 빌드·S25 설치만 수행.

## 검토 결과
- zh 패턴(독음 토글·외우기)이 **이미 자체 구현돼 있어 이식 불필요**:
  - `services/learning_preferences.dart` — `showRomanization`(SharedPreferences 영속) + `conversationKoreanOnly`(한글만 모드). 회화·플래시카드 앱바 토글.
  - `screens/chat_dialogue_memorize_screen.dart` — 문장 외우기(플래시카드 모드).
  - `widgets/stressed_romanization.dart` — 독음 강세 음절 표시.

## 참고
- 구 monorepo 플레이버 구조 유지 — 릴리스 APK 경로가 `build/app/outputs/apk/ar/release/app-ar-release.apk` (flutter-apk 폴더 아님). 설치 시 이 경로 사용.
