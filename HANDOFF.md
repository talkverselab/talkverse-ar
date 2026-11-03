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

## 이집트 구어 절벽·단어 그림 리스트 (2026-11-03 끝)
- 재산출: 이집트 영화·드라마 대사 108작품 · 43.9만 토큰(아랍어 자막 중 이집트 구어 표지 5% 이상만, 작품당 1개) · 표면형(모음 부호 제거·أإآ→ا·ى→ي). **R1 55% 635 · R2 60% 999 · R3 70% 2,491 · R4 80% 6,413**, 50% 404, 상위 2,500 = 70.0%. talkverse.uk /cliff/18/ 아랍어 행 ①단계·확정으로 반영됨.
- 작업 파일(리포 밖): M6 `~/corpus_work/ar_eg/` — `eg_cliff.py`, `freq_eg.tsv`(전체 순위·누적%), `summary.txt`, 출처 메모 `SOURCE.md`(비공개). 원본 9GB 사본은 지움(원본은 PC).
- 그림 리스트: `talkverselab/talkversehanja` 커밋 `538c212` — `talkverse_art/words/ar.csv`(상위 2,500, 카이로식 한글 독음·뜻·품사·그림 가능 Y 548) + `ar_food.csv`(이집트 음식 50). talkverse.uk 세션이 그림 대기열에 넣음(일본어 다음 도착 순).
- **앱에는 아직 반영 안 함**: 앱 빈도 단어(`app/assets/data/freq/lang_es_top.csv`, 옛 표준어 섞인 5,000)를 이집트 구어 목록으로 바꾸는 것은 새 학습 콘텐츠라 콘텐츠 작성 금지가 풀린 뒤 사용자 결정.

## 다음 할 일(순서)
1. (사용자 결정) 앱 빈도 단어를 이집트 구어 목록(`~/corpus_work/ar_eg/out/ar.csv`)으로 바꿀지 — 콘텐츠 금지 해제 뒤.
2. (사용자) App Store Connect 에서 TestFlight 2611030110 처리 확인·내부 그룹 설치, 포털 App ID 에 Sign in with Apple capability, 인앱 상품 `com.talkverse.arabicUniverse.lifetime`·Play `lang_ar` 등록, 무료/유료 구간·가격 결정.
3. 장면 컷(편당 4장) — 회화가 새로 나온 뒤. 요청 때 **카이로 동네 배경**(시안 그림이 흙벽 마을로 나왔음)·말풍선 없음 명시, 시트 v2 첨부.
4. 회화(사용자 지시 뒤): 공통 원칙 https://talkverse.uk/talkverse/dialogue-rules/ · 이집트 구어 · 성별판 · Grok 재작성 + **Gemini 검수(방언 판정 포함, 몇 편 해 보고 품질이 낮으면 중단·보고)**.
   - 반전 기준(사용자 지시 2026-11-03, 한국어앱 세션 경유·모든 언어앱 공통): 카오스(일이 걷잡을 수 없이 커짐) **30% 이상**, 심쿵 많이(연애·플러팅 편은 편마다 한 줄, 여성이 먼저 다가가는 편 더 많이), 편마다 `twist_type` = chaos·slip·reveal·emotion·ignore, 묶음마다 비율 확인. 참고 `~/talkverse/ko/assets/data/dialogues/`, 커밋 a2e8eb9(한국어앱). 새 편은 왕초보·초급 위주, 장면 그림 = A·B 쌍 1컷·말풍선·글자 없음·인물 기준 그림 첨부(공통 원칙 §9).
   - Grok·Gemini 를 직접 쓸 때: 사용자 지시가 있을 때만 M4 Chrome 을 켜고(미리 켜 두지 말 것), 쿠키 복사는 M4 안에서, M6 에서는 ssh 터널 — `~/talkverse/GROK_M4_LOGIN.md`, 포트 배정 `GROK_CHROME_PORTS.md`. 한 번에 한 작업, 연 탭은 닫고 끝나면 Chrome 끄기. 그림 요청은 지금처럼 한자 세션 경유도 가능.
5. 어근 가족 칸(시안 §4-B): 인도네시아어앱 `~/talkverse/id/docs/ROOTS.md` §4 방식 — 범위는 사용자 확인 뒤.

## 주의
- 서명 키 새로 만들지 말 것 — 리포의 `android/app/signing-key.jks`(SHA-1 `9C:C4:…:47:6B`, PC `D:\keys\talkverse-ar\` 백업, Doppler `SIGNKEY_*`). M6 `~/.android/debug.keystore` 는 다른 키.
- 공개 저장소 — 말뭉치·교재·영상 이름 금지(이력 정리했음, 다시 넣지 말 것).
- 아이콘 파일은 talkverse.uk 세션 담당 — 직접 고치지 말고 요청.
- M6 자원: 시뮬레이터는 자기 것(`ar-shots iPad Air 11`, F3FF452D…)만, 끝나면 shutdown. 빌드는 M6 전체 2~3개까지(`pgrep -f flutter_tools.snapshot | wc -l` 3 이상이면 대기).
- Android CI 의 "Update rolling latest release" 단계가 GitHub API 일시 오류로 한 번 실패했었다 — `gh run rerun <id> --failed` 로 해결.
- 빌드 뒤 `ios/Podfile`·`Podfile.lock`·`**/swiftpm/`·pbxproj 의 CocoaPods 줄·xcconfig 는 도구 잡음 — 커밋하지 말 것. 작업 트리의 CRLF 수정 표시도 잡음.
- 글자 돋보기·낱말 나누기는 ، ؛ ؟ 를 빼야 한다(같은 유니코드 블록) — 페르시아어앱 원본에도 같은 문제가 있을 수 있음.
