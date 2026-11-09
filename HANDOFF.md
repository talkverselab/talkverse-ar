# HANDOFF — talkverse-ar (아랍어유니버스)

_2026-11-08 전체 다시 씀, 2026-11-09 가격·통합 앱·스토어 문서 반영(세션 종료). 앱 규칙 SSOT 는 `app/CLAUDE.md`, 회화 규칙은 `app/docs/DIALOGUE_RULES_ar.md`, 인물은 `CHARACTERS.md`._

## 지금 상태 (2026-11-09)

| 항목 | 상태 |
|---|---|
| 리포 | `talkverselab/talkverse-ar`(공개) `main`, 마지막 커밋 `ee377dc` |
| Android | CI 빌드 **15**(`ee377dc`, 서명 확인) → Zealot 「아랍어유니버스」 https://apps.talkverse.uk/yCwOQ/427 , PC `D:\OneDrive\app project\talkverse-ar\talkverse-ar-latest.apk` |
| iOS | TestFlight **2611091223**(`ee377dc`, Android 15 와 같은 변경). IPA 백업 PC `D:\OneDrive\app project\arabic_universe\ios\` |
| 서명 | `android/app/signing-key.jks` SHA-1 `9C:C4:…:47:6B`(PC `D:\keys\talkverse-ar\`, Doppler `SIGNKEY_*`). 새로 만들지 말 것 |
| 로그인·결제 | Talkverse ID(client `ar`, 통합 앱 안에서는 `talkverse`) · 상품 `lang_ar_1m·3m·1y·life`·`all_1y`·`all_life`(가격 `~/talkverse/PRICING.md`, 정가 취소선·30%), 옛 `lang_ar`·`com.talkverse.arabicUniverse.lifetime` 은 복원 때 `lang_ar_life`. **잠근 콘텐츠 없음**(무료/유료 구간은 사용자 결정). 스토어 등록은 사용자 — `app/docs/STORE_PRODUCTS.md` |
| 통합 앱 | 패키지 `arabic_universe`(`lib/embed.dart` embedInit/embedApp, `core/embed_env.dart` 에셋 `packages/arabic_universe/`, `core/prefs.dart` 저장 이름 `ar_` 접두 — 단독 앱은 첫 실행 때 옛 키·DB(`arabic_universe.sqlite` → `ar_arabic_universe`)를 한 번 옮김), 콜백 `talkverse.ar://auth`. 통합 앱 쪽 연결은 uk 몫(2026-11-09 알림 보냄) |

## 2026-11-07~08 한 일
- **일본어앱 단어·메뉴 개편 이식**(`d1cfde2`): 절벽 단어 = 이집트 구어 레마 상위 2,000(`assets/data/freq/lang_ar_cliff.csv`, 검토로 225개 숨김 — 조각·인명·비속어·판정 불가, 순위 번호는 그대로) · 20어 단원 타일 · 「회화 단어 포함」(`conv_words_ar.json`) · 앱 소개(`about_screen.dart`, 값은 `lib/core/cliff.dart` 한 곳) · 메뉴 = 기초 → 문법 → 회화 → 단어 → 참고 · 탭 「배우기·회화·진행·프로필」 · 프로필 정리(앱 업데이트 타일 삭제, 학습 기록 초기화) · 문장 낱말 탭 = 단어창, 길게 = 글자 시트 · 독음 전역 토글(기본 미표시, 켤 때 「힘들어도 독음을 보지 않고 익혀보세요」).
  - 만들기: `python3 tools/build_cliff_words.py ~/corpus_work/ar_eg/out/ar.csv ~/corpus_work/ar_eg/lemma_eg.tsv ~/corpus_work/ar_eg/review`(검토 JSON 은 리포 밖).
- **기초 「글자와 발음」**(`b8e3567`, `f8fa668`): 28자+ة·ى 격자(RTL)·묶음 칩(쉬운 소리·닮았지만 다른 소리·목 소리·강조음·모음 부호·**접사 글자 10 = 사알투무니하**)·한글 소리 토글·소리 시트(1초 뒤 재생·IPA 카이로/표준어·소리 나는 곳·조음 그림·한국어 비교·글자 모양·예시). 데이터 `lib/services/arabic_phonetics.dart`. 조음 그림은 **임시**(출시 전 자체 그림으로 교체, 출처 표기 넣지 않음 — 사용자 지시). 옛 앱 사알투무니하 원본 = `~/talkverse/_legacy/ar/lib/core/screens/ar_alphabet_screen.dart`, 리포 이력 `2a3dcd4`.
- **회화 Claude 초안**(사용자: 샘플 통과, Fable 로 작성): `data/review/write/samples_20261107/` — 레벨 0~5 한 편씩 7편 78턴(`sample.md` 에 세 줄 + 감정 + 여성판). chaos 3/7. 앱 에셋에는 아직 안 넣음. 성별판 칸 = `ar_f`·`rd_f`·`ko_f`·`segs_f`.
- **회화 규칙 확정**(`app/docs/DIALOGUE_RULES_ar.md`): 굴절어 공통안 + 아랍어 대안 3개(사용자 동의) — 존댓말 활용 없음 → 가게 장면 R1 허용·حضرتك 만 그래머2 / 회화 어휘 상한 = 상위 512위, 밖 단어 턴당 R1 1·R2 2·R3 3 / 본문 타슈킬 없음. 시샤 소재 금지.

## 다음 할 일(순서)
0. **빌드 15 확인**: 저장 이름 `ar_` 이전 첫 판 — 폰·아이패드에서 덮어 설치 뒤 학습 기록·이름·성과가 남는지 확인.
1. 미얀마어앱 사알투무니하 좌우 반전판 — 사용자 지시로 2026-11-08 빌드 12 뒤 미얀마어 세션(`my-f6`)에 요청 보냄(만드는 것은 그 세션 몫).
2. **아이패드 스크린샷 확인**: `python3 app/tools/pane_shots.py F3FF452D-C5CF-4782-83DB-3DCF252451D9 <폴더>` — 11-08 실행이 앱 빌드 뒤 멈춰 중단함(원인 미확인, 재부팅 직후). 흐름 `integration_test/dialogue_pane_test.dart` 에 절벽 단어·앱 소개·글자와 발음 단계 추가돼 있음. 호스트 테스트(`test/menu_words_test.dart`, 폰·아이패드 칸·전체 크기)는 넘침 없이 통과.
3. **회화**: Grok 재작성(11-09 13:30 재개, 편마다 새 방, 한자 세션 경유 가능) → 리뷰 → 사용자 통과 → 앱 에셋(`assets/data/dialogues/R<레벨>/<주제>/`, 로더가 `es` 칸을 읽으니 `ar`↔`es` 정리) → 음성(`~/talkverse/ja/docs/DIALOGUE_AUDIO.md`, 감정 열로 계획 자동 생성 스크립트를 이 앱용으로, uk 에 "시험 준비됨" → "지금 시작" 뒤 PC) → `data/review/REVIEW_ar.html` → uk "REVIEW_ar 갱신". 레벨별 한 편 뒤 추가 작성은 사용자 지시 뒤(B15).
4. (사용자) TestFlight 설치 확인, App ID Sign in with Apple, 인앱 상품 등록(`app/docs/STORE_PRODUCTS.md` 표), 무료/유료 구간. 출시는 Talkverse 통합 앱 하나.
5. 표현 풀 CSV(إزيك·ماشي·خلاص·طب·على حسابي·متشكر…)와 「Conv」 단어장 보강(شاي·زحمة 등) — 회화 밖 콘텐츠라 동결 해제 뒤.

## 주의
- **Grok(2026-11-09 허브 공지 `~/logs/rc/RELAY_grok_20261109.md`)**: 한자 세션 대행 중단 — 이 세션이 직접. 자기 크롬을 켜고 M4 의 `/usr/bin/python3 ~/talkverse-uk/tools/grok_cookie_sync.py 9231 <자기 포트>`(M6 에서는 `ssh macmini4` 경유)로 쿠키 동기화, 요청 도구는 M6 `~/Hanja/tools/grok_req.py`·`grok_cdp.py` 를 복사. uk 의 방(포트 9231)은 건드리지 말 것.
- **Grok 프롬프트 최소화(사용자 지시 2026-11-09)**: 규칙은 문서에 한 번(첨부), 방 첫 메시지에 「앞으로 파일 이름 한 줄만 보낸다」 약속, 이후 채팅은 한 줄만. 그림이 처음과 달라지면 최초 통과 그림 기준(이미 만든 것은 그대로). 회화는 줄마다 음성용 `emotion`(감정이 바뀌면 `segs`).
- 공개 저장소 — 말뭉치·작품·자막 이름 금지. 출처 이름은 `~/corpus_work/ar_eg/SOURCE.md` 에만.
- M6 빌드 수: `ps -axo args= | grep -c '^[^ ]*dartvm .*flutter_tools.* build '`(`pgrep -f flutter_tools.snapshot` 은 대기 명령까지 세어 서로 기다리게 됨). 시뮬레이터는 `ar-shots iPad Air 11` 만, 끝나면 shutdown.
- 빌드 뒤 `ios/Podfile*`·`swiftpm/`·pbxproj·xcconfig·xcscheme 변경과 CRLF 표시는 잡음 — 커밋하지 말 것. `git add` 는 경로 지정.
- 아이콘은 talkverse.uk 세션 담당. 서명 키 새로 만들지 말 것.
