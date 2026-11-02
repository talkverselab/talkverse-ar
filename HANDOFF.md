# HANDOFF — talkverse-ar (아랍어유니버스)

_2026-11-03 전체 다시 씀. 앱 규칙 SSOT 는 `app/CLAUDE.md`(서명·배포·Zealot·회화 원칙 링크), 인물은 `CHARACTERS.md`._

## 지금 상태 (2026-11-03)

| 항목 | 상태 |
|---|---|
| 리포 | `talkverselab/talkverse-ar`(공개) `main`, 마지막 앱 커밋 `7285dd7` |
| Android | CI 빌드 **8**(`latest` 릴리스), Zealot 「아랍어유니버스」 빌드 8 — https://apps.talkverse.uk/yCwOQ/211 , PC `D:\OneDrive\app project\talkverse-ar\` |
| iOS | TestFlight 업로드 빌드 **2611030110**(번들 `com.talkverse.arabicUniverse`, Apple 로그인 entitlements·iPad 포함 확인), IPA 백업 PC `D:\OneDrive\app project\arabic_universe\ios\` |
| 캐릭터 | 시트 v2 사용자 통과(유세프만 고친 판) — `data/review/art/chars_ar_v2.jpg`, `CHARACTERS.md` |
| UX/UI | 시안 01 사용자 통과 — `data/review/uxui/sian_ar_01.md|.jpg`. **장면 그림엔 말풍선·글자 없음, 앱이 오버레이**(사용자 결정) |
| 앱 구조 | 일본어앱 구조(페르시아어앱 이식판 바탕): 아이패드 두 화면·회화 리더·그림 카드·「나」 성과·학습자 프로필·글자 돋보기(낱말 → 글자 4형, 아랍어 28자 + ة·ى) |
| 로그인·결제 | Talkverse ID(client `ar`, `talkverse.ar://auth`) + 평생 이용권(iOS `com.talkverse.arabicUniverse.lifetime` / Android `lang_ar`). **잠근 콘텐츠 없음**(무료/유료 구간은 사용자 결정) |
| 회화 | 옛 앱에서 옮긴 L1 7편 77턴(주제 「생활」로 표시) — **회화 작성 금지 상태**(사용자 지시 전까지) |
| 저작권·이력 | 2026-11-02 외부 말뭉치·교재 추출 파일·옛 Supabase 시드 삭제 + 이력 재작성(강제 푸시). Supabase 사용 없음 |

## 진행 중
- **이집트 구어 절벽 재산출 → 단어 그림 리스트**(사용자 선택 "재산출 먼저", 2026-11-03): 아랍어 자막 원본(PC `D:\datasets\…`)을 M6 `~/corpus_work/ar_eg/`(리포 밖, 출처 메모 `SOURCE.md`)로 복사 중 → `eg_cliff.py`(이집트 구어 표지 비율로 문서 고르기, 기준 보정: 이집트 자막 9~16%·표준어 0%) → R1~R4(55/60/70/80%) → talkverse.uk 세션에 숫자 전달 → `talkversehanja` `talkverse_art/words/ar.csv`(+ 이미 만든 `~/corpus_work/ar_eg/out/ar_food.csv` 50개) 푸시, 커밋 "words/ar: 단어·음식 리스트".
- 앱 `assets/data/freq/lang_es_top.csv` 의 freq·cum_pct·region 채우기도 같은 결과로(콘텐츠 생성 아님 — 통계).

## 다음 할 일(순서)
1. 위 재산출·리스트 푸시 → talkverse.uk 세션에 R 값·캐릭터 시트 경로 한 줄.
2. (사용자) App Store Connect 에서 TestFlight 2611030110 처리 확인·내부 그룹 설치, 포털 App ID 에 Sign in with Apple capability, 인앱 상품 `com.talkverse.arabicUniverse.lifetime`·Play `lang_ar` 등록, 무료/유료 구간·가격 결정.
3. 장면 컷(편당 4장) — 회화가 새로 나온 뒤. 요청 때 **카이로 동네 배경**(시안 그림이 흙벽 마을로 나왔음)·말풍선 없음 명시, 시트 v2 첨부.
4. 회화(사용자 지시 뒤): 공통 원칙 https://talkverse.uk/talkverse/dialogue-rules/ · 이집트 구어 · 성별판 · Grok 재작성 + **Gemini 검수(방언 판정 포함, 몇 편 해 보고 품질이 낮으면 중단·보고)**.
5. 어근 가족 칸(시안 §4-B): 인도네시아어앱 `~/talkverse/id/docs/ROOTS.md` §4 방식 — 범위는 사용자 확인 뒤.

## 주의
- 서명 키 새로 만들지 말 것 — 리포의 `android/app/signing-key.jks`(SHA-1 `9C:C4:…:47:6B`, PC `D:\keys\talkverse-ar\` 백업, Doppler `SIGNKEY_*`). M6 `~/.android/debug.keystore` 는 다른 키.
- 공개 저장소 — 말뭉치·교재·영상 이름 금지(이력 정리했음, 다시 넣지 말 것).
- 아이콘 파일은 talkverse.uk 세션 담당 — 직접 고치지 말고 요청.
- M6 자원: 시뮬레이터는 자기 것(`ar-shots iPad Air 11`, F3FF452D…)만, 끝나면 shutdown. 빌드는 M6 전체 2~3개까지(`pgrep -f flutter_tools.snapshot | wc -l` 3 이상이면 대기).
- Android CI 의 "Update rolling latest release" 단계가 GitHub API 일시 오류로 한 번 실패했었다 — `gh run rerun <id> --failed` 로 해결.
- 빌드 뒤 `ios/Podfile`·`Podfile.lock`·`**/swiftpm/`·pbxproj 의 CocoaPods 줄·xcconfig 는 도구 잡음 — 커밋하지 말 것. 작업 트리의 CRLF 수정 표시도 잡음.
- 글자 돋보기·낱말 나누기는 ، ؛ ؟ 를 빼야 한다(같은 유니코드 블록) — 페르시아어앱 원본에도 같은 문제가 있을 수 있음.
