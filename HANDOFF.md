# HANDOFF — talkverse-ar (아랍어유니버스)

_2026-11-08 전체 다시 씀, 2026-11-09 가격·통합 앱·스토어 문서 반영(세션 종료). 앱 규칙 SSOT 는 `app/CLAUDE.md`, 회화 규칙은 `app/docs/DIALOGUE_RULES_ar.md`, 인물은 `CHARACTERS.md`._


## 2026-11-23 이용권 실제 기능(PAYWALL_SPEC, 사용자 「1 2 모두 진행」) — 11ed3d9
- 무료 = 커리큘럼 1단계 · 회화 R0/R1(무료 단계 편) · 문법 1~2스텝 · 언어감각 1급. 나머지는 **자물쇠 표시 → 결제 화면**(숨기지 않음). 판정 `Access`(`lib/data/entitlement.dart`), 값은 커리큘럼 JSON rev 2 의 단계 `free`·최상위 `freeSteps`·`freeSenseLevels`(묶음 `assets/curriculum_ar.json` rev 2, 서버 rev 2 받기 확인).
- 결제 화면: 스토어 가격만(원화·할인 코드 삭제), 혜택 줄 = 유료 범위, 상품 못 받으면 「다시 시도」·닫기(12초 상한), 약관·개인정보 링크·복원. 저장 `ar_entitlement_v1`(옛 `iap_owned2` 읽음) + 종합은 `all_entitlement_v1`.
- **시작 때 복원 조회는 넣지 않음**: iOS 에서 앱을 켤 때마다 Apple ID 암호 창이 뜰 수 있어서(심사자 첫 화면). 스토어가 미완료 거래를 스트림으로 보내 주는 것 + 「이전 구매 복원」 단추로 처리. 필요하면 uk 와 정할 것.
- 문장 카드·말하기 연습 등은 모든 편 문장을 쓰므로 유료 편 문장이 거기선 보임(잠금 범위 밖 — 사양에 없음).
- 시험 `app/test/paywall_access_test.dart`. analyze 0·시험 57.

## 2026-11-23 심사 점검 수정(uk 「심사막을 부분 다 수정」) — 26a685f
- (이용권 입구 숨김 A 는 PAYWALL_SPEC 로 취소·되돌림) · 로그인 「이메일로 로그인」(괄호 뺌)·서버에 없는 제공자 버튼 숨김 · 결제 안내 iOS=App Store / Android=Google Play 따로, 해지 안내 이름 Talkverse · r4_love_b1 9번 ko 「错过한 거야」 → 「놓친 거야」(앱 에셋 + data/review 원본).
- F(작업 기록 칸 AI 이름): ar 회화·문법 JSON 에 없음(검사함).
- 서버 원고 rev 3 올림(사용자 「DB업로드 언제나 허용승인」 뒤, c7821ca) — r4_love_b1 고침 + 문법 2파일. **이후 DB·서버 원고 올리기는 묻지 않고 진행.**

## 2026-11-23 커리큘럼 §12(사용자 「커리큘럼 내용도 모두 DB에서 · 5단계」, uk 전달) — 1e2e7fc
- 단계 1~5 = `app/assets/curriculum_ar.json`(uk 의 `~/talkverse/curriculum/ar.json` 복사, rev 1, 65편 id 전부 앱 편과 맞음) → 시작 때 `https://talkverse.uk/api/curriculum/ar` rev 가 더 높으면 기기에 받아 바로 바꿈(Worker 배포 전엔 404 → 묶음 그대로). 편 0개 단계 숨김, 앱에 없는 id 건너뜀, JSON 실패면 회화 레벨 기본 대응(R0+R1→1 … R5→5). 저장 칸 level = 단계 '1'~'5'(옛 R 값은 읽을 때 바꿈). 코스·시험·복습은 그대로. **pick·pass·daily·title·desc 도 JSON 에서**(§12 덧붙임, 없으면 3·5·10 / 80 / 1·2·3 — 통과 점수는 시험 판정과 화면 문구 둘 다). ar 은 prep(JLPT/HSK) 없음.
- 코드 `CurriculumPlan`·`CurStage`(`curriculum_service.dart`), 시험 `app/test/curriculum_plan_test.dart`. analyze 0·시험 52 통과.

## 3090 「비었다」 판정(uk 11-23 07시)
- nvidia-smi 사용량만 보고 판단하지 말 것(묶음마다 모델을 올렸다 내리는 실행기는 몇 초씩 576MiB 로 비어 보임). **① 앞 세션 「GPU 끝」 또는 uk 「ar 지금 시작」 + ② PC `D:\tts_test\job\job.log`·`moss_jobs.json` 수정 시각이 5분 넘게 멈춤 — 둘 다일 때만.** 실행기의 「8GB 아래면 시작」 조건은 uk 시작 신호 뒤에만.

## 음성 만들 때 주의(uk 11-23, 한국어앱 버그)
- 받아쓰기 검사 캐시는 파일 이름이 아니라 **파일 내용 해시**로 기억할 것 — 이름으로 기억하면 다시 만든 불합격 조각에 옛 합격 점수가 남아 그대로 올라감(ko 603조각 중 268). 참고 `~/talkverse/ko` c6433c4 · `tools/tts/retake.py`(나쁜 조각만 최대 3회 다시). 불합격은 서버 목록에서 빼면 앱이 TTS 로 읽음.

## M6 iOS 빌드 규칙(uk 11-23, 디스크 꽉 참 뒤)
- 시작 전 `df -h /System/Volumes/Data` 10GB 넘는지 + `pgrep -x xcodebuild`(**`pgrep -f` 금지** — 기다리는 셸 자신에 걸림; flutter 쪽은 `ps -axo comm=,args= | awk '$1 ~ /dart$/ && /build ipa/'`) 로 다른 빌드 없는지 확인(한 번에 한 세션). 올리기 끝나면 그 자리에서 `app/build` 삭제. 여유 10GB 아래면 uk 에 한 줄.

## 2026-11-23 문법 스텝 서버 받기(사용자 「스텝 15까지·내용 없으면 안 나타나게·DB 업데이트로 늘거나 줄게」, uk·문법 세션 전달) — 4e73bd9
- 문법 강의 = `grammar/lessonN.json` 파일들(N 제한 없음), 언어감각 = `grammar/sense_course.json` 의 levels. **개수·제목·순서는 데이터 그대로**, 코드에 안 박음.
- 목록 = 앱 안 파일 + 서버에서 받은 새 파일 − 서버 목록에서 뺀 파일. 각 파일은 서버 판이 있으면 그것(`ScriptSync.tryLoad`). 내용(패턴·문장) 없는 스텝·회차는 숨김(「준비 중」 칸 없음). 서버 못 받으면 묶음 목록.
- 올리기 도구 `app/tools/script_publish.py` 대상에 문법 파일 추가. **아직 안 올림**(운영 쓰기 — 사용자 승인 뒤 `python3 tools/script_publish.py --publish` → 서버 rev 3, `script_rev.json` 커밋). 올리기 전에는 기준표에 문법 파일이 없어 옛 빌드에서 「서버 목록에서 빼서 숨기기」가 안 먹음(새 스텝 추가·내용 덮기는 됨).
- 지금 내용 있는 스텝: 문법 강의 1 · 언어감각 10. 시험 `app/test/grammar_steps_test.dart`(서버 없음 = 묶음 · 서버에만 있는 스텝 나타남·덮어쓰기 · 서버 목록에서 빠지면 숨김 · 빈 스텝 숨김). analyze 0·시험 49 통과.

## 2026-11-22 23시 언어감각 익히기 10급(사용자 「언어감각 10급은 클로드로만 진행」, uk 전달) — 052e30b
- 배우기 맨 위 「정규과정 → 언어감각 익히기」. 급마다 외울 대화 10줄(`memorize`, 문장마다 who·ar·rd·ko) + 참고 1회(`ref`). 전체 100줄 + 참고 40문장, **Claude 글**(Grok 안 거침).
- 급: L1 소유 붙이기 -i·-ak·-ik · L2 b- 현재형 · L3 과거 끝소리 · L4 남자에게·여자에게 · L5 ma…sh·mish · L6 ha-·عايز · L7 목적어 붙이기 · L8 명령형·ممكن · L9 عشان·عمري ما·لسه · L10 فاكر إن·لو·يمكن.
- 원고 = `tools/sense_course_ar.py`(고칠 때 여기서 → `--write`). 검사: 10줄·양쪽 번호 같음·**아랍어는 낱말 통째로 색칠**(낱말 중간을 끊으면 글자 잇기가 깨짐)·독음 있음. 12+ 점검: 일상 장면만(술·폭력·성적 내용 없음).
- 화면 `app/lib/screens/sense_course_screen.dart`(헝가리어앱 판을 옮김, 아랍어 줄 RTL). **영상 칸·video_player 는 넣지 않음**(영상 없음 + 심사 전날 플러그인 추가 위험) — 영상이 생기면 hu 판의 `LessonVideo` 와 플러그인을 들이면 됨. 마친 회차 Prefs `sense_course_done`.
- 시험 `app/test/sense_course_test.dart`(원고 형식·색·390/300 폭). analyze 0·시험 45 통과. 서버 원고(rev)에는 아직 안 올림(앱 에셋에 들어 있음).

## 2026-11-22 65편 통과 처리(사용자 「사용자 리뷰 - 그냥 진행」, uk 전달) — 서버 rev 2·장면 컷 10장 올림
- 65편 JSON 에 `approved`(2026-11-22) → `sync_dialogues.py` 로 앱 에셋 65편 → add_lemmas(내용어 1670, 단어장 68%, 없는 레마 174 → `data/review/write/missing_lemmas.csv`) → build_cliff_words(회화 단어 갱신).
- 턴 잠금 경고 2건(다시 쓴 편에서 옛 줄이 다른 번호에 나옴): r0_friends_a1 「أهلا! اسمك إيه؟」 2→1, 「أهلا」 1→9 · r1_love_a1 「متشكر. كده صح؟」 5→4, 「غلط. من الأول.」 4→10. 대사·순서는 그대로, 번호만(앱 새 편 화면은 배열 순서로 보임; num 정렬 화면 episode_screen 은 옛 L1 DB). 경고 0.
- r2_love_c1 턴 11 قولي(남성 학습자에게 여성 명령형): 세션 판단으로 Grok 원문 그대로 둠(대사 고치기는 권한 정책이 막음 + 「Grok 이 쓴 그대로」 규칙). 고치려면 ar 을 قول, rd 를 「울」로(ar_f 는 قولي).
- **서버 올림(11-22 사용자 「둘 다 올려」)**: script_publish → 서버 rev 2(65편, index.json 확인), 장면 컷 `scene_upload_ar.py` → R2·D1 10행.
- 그다음: 장면 컷 10장(uk Grok 순서) · 음성(01~07시).
- **장면 컷 10장 받음(11-22 16시, ru 「Grok 끝」 뒤)**: `tools/grok_scene_ar.py`(ru 도구 복사, 4편씩 한 방, 시트 chars_ar_v2 + 톤 ref/clay_389_tomodachi.png 첨부, 빠른, 3분 상한) → 원본 `~/talkverse/ar-art/scene/ar/<편>/cut1.jpg`(공개 repo 밖). 고른 10편(세션 판단, 레벨마다·장소 안 겹치게): r0_friends_a1·r0_life_a1·r0_travel_a2·r1_love_a2·r1_life_a3·r1_survival_a3·r2_love_c1·r3_friends_b1·r4_travel_b1·r5_friends_b1. 10장 눈으로 확인(글자 없음, 시트대로). 방 https://grok.com/c/eb2f6ae9-f315-414d-b308-596758e93e96. 크롬 9248·터널 닫음, uk·hi 에 「Grok 끝」. **올리기 = `/usr/bin/python3 tools/scene_upload_ar.py`(R2 scene/ar + D1 art_scenes lang=ar, 운영 쓰기 → 사용자 승인 뒤).** 앱은 컷이 하나면 모든 턴에 cut1(ArtService.sceneCut).
- **11-22 19시 사용자(uk 전달)**: 「pc 작업은 잠시멈춤」 → 풀렸다는 전달 전에는 PC 작업(음성·Grok 포함) 시작 안 함. 「전체 심사」 → 통합 앱 심사 빌드(11-23)에 ar 포함, 작업 폴더를 늘 빌드되는 상태로(11-22 analyze 0건). uk 에 알린 점: 회화 음성은 기기 TTS, 문장 카드·말하기는 옛 L1.
- **11-22 18:33 「PC재가동」(uk 전달)**: PC 멈춤 풀림. ar 음성은 그대로 11-26 새벽 pt 65편(01:00~) 「GPU 끝」 뒤. 시작 직전 3090 빈 메모리 확인(부팅 때 :8002 vLLM 이 22.9GB 를 쥘 수 있음 — 남의 프로세스는 끄지 않고, 모자라면 uk 에 한 줄). vox_jobs.json·moss_jobs.json 은 공용 — 앞 세션 「GPU 끝」 뒤에만 덮어씀.
- **3090 우선순위(사용자 11-22 18:41 「3090 짐프리 - 문법 - 사운드 순이야」, uk 전달)**: Gym-free → 문법 영상 → 음성. 겹치면 음성 줄이 밀림. 시작 직전 3090 사용 중 8GB 넘으면 시작하지 않음. :8002 vLLM 은 내려짐(재부팅하면 다시 뜸).
- **11-22 19:5x(uk 전달)**: 상태가 바뀌면 `~/bin/tv-progress ar <stop|wait|user|run|done> "<멈춘 것>" "<이유>" "<필요한 것>" ["<보고>"]` 로 체크리스트 페이지(talkverse.uk/talkverse/review/release/) 갱신(지금 wait 올림). 3090 순서 「한자 → 짐프리 → 문법 → 음성」, 음성은 낮에도 넘김(문법 창에서 사용자 확정이라고 전달됨 — 전역 CLAUDE.md 「TTS 01~07시」와 다름) → uk 「지금 시작」 받으면 시작, 앞 순서가 달라면 묶음 경계에서 멈추고 비움. 회화 소리는 녹음 우선·없으면 TTS(9805e25, `lib/services/dialogue_audio.dart`).
- **순서 확정(uk 11-22)**: ① 장면 컷 — 그림 줄 ru → ar → hi → kk → my → pt. **러시아어앱의 「Grok 끝」= 「ar 시작」**(uk 기다리지 않음, 빠른, 크롬 하나·켜기 전 부하/스왑). 끝나면 크롬 끄고 터널 닫고 「Grok 끝」을 uk·힌디어앱에 같이. 한도 경고 → 멈추고 uk 에. ② 음성 약 700조각(2~2.5시간) — **11-26 새벽, 포르투갈어(00:01~, 4시간 30분) 「GPU 끝」 받고 3090 빈 것 확인 뒤 시작**, 06:30 이후 새 묶음 금지·06:55 까지 비움, 못 끝내면 11-27 이어서, 끝나면 「GPU 끝」을 uk 에. 참고 음성(2060)은 미리 만들어도 되지만 TTS 라 01~07시 안에서만.

## 2026-11-19 새벽 Grok 회화 65편 받음(리뷰 대기)
- uk 「ar 시작」(11-19 02:3x) → PC 9248 빠른 모드, 방 4개(R0 12 · R1 18 · R2 14 · R3~R5 21), TIMEOUT·한도 0. 사용자 결정 「Grok으로 다시 써」로 나간 7편도 새로 씀(초안 끝 「다시 쓰기 7편」). uk 에 「Grok 끝」 알림.
- 원문 `data/review/grok/write/<id>.md` → `data/review/write/grok_20261118/<id>.json`(65편 602턴). 변환기가 고치는 것: 독음 프랑코 3(ع)→모음, 목록 밖 감정 → 가까운 것(confused→flustered 등), 채팅 화자 이름(نور@)→기호, segs 를 이으면 ar 와 똑같게. 검사(화자·라틴·금지낱말·숫자·rd_f·segs·감정) 0건.
- 남은 경고: 감정 수 ≠ 문장 수인 줄은 첫 감정만(review.warn). 다시 쓴 편 턴 수: r1_life_a1 10(전 8)·r1_love_a1 9(8)·r4_love_b1 15(14)·r5_friends_b1 15(14) — 늘어난 번호는 새 번호라 잠금 규칙 안. r2_love_c1 턴 11 에서 남성 학습자에게 قولي(여성 명령형) — 리뷰 때 사용자 판단.
- 리뷰 Artifact(이번 판) https://claude.ai/artifact/6YctG1ZYGj1YGT4DrAXYuX (db `reviews`). 통과하면 편 JSON 에 approved → `cd app && python3 tools/sync_dialogues.py ../data/review/write/grok_20261118/*.json` → add_lemmas·build_cliff_words → `python3 tools/script_publish.py --publish` → script_rev.json 커밋 → uk 에 rev·커밋 알림.

## 지금 상태 (2026-11-09)

| 항목 | 상태 |
|---|---|
| 리포 | `talkverselab/talkverse-ar`(공개) `main`, 마지막 커밋 `aa95f7f` |
| Android | CI 빌드 **19**(`aa95f7f`, 서명 확인, 회화 7편 연결) → Zealot 「아랍어유니버스」 https://apps.talkverse.uk/yCwOQ/435 , PC `D:\OneDrive\app project\talkverse-ar\talkverse-ar-latest.apk` |
| iOS | TestFlight **2611092320**(`aa95f7f`, Android 19 와 같은 변경). IPA 백업 PC `D:\OneDrive\app project\arabic_universe\ios\` |
| 서명 | `android/app/signing-key.jks` SHA-1 `9C:C4:…:47:6B`(PC `D:\keys\talkverse-ar\`, Doppler `SIGNKEY_*`). 새로 만들지 말 것 |
| 로그인·결제 | Talkverse ID(client `ar`, 통합 앱 안에서는 `talkverse`) · 상품 `lang_ar_1m·3m·1y·life`·`all_1y`·`all_life`(가격 `~/talkverse/PRICING.md`, 정가 취소선·30%), 옛 `lang_ar`·`com.talkverse.arabicUniverse.lifetime` 은 복원 때 `lang_ar_life`. **잠근 콘텐츠 없음**(무료/유료 구간은 사용자 결정). 스토어 등록은 사용자 — `app/docs/STORE_PRODUCTS.md` |
| 통합 앱 | 패키지 `arabic_universe`(`lib/embed.dart` embedInit/embedApp, `core/embed_env.dart` 에셋 `packages/arabic_universe/`, `core/prefs.dart` 저장 이름 `ar_` 접두 — 단독 앱은 첫 실행 때 옛 키·DB(`arabic_universe.sqlite` → `ar_arabic_universe`)를 한 번 옮김), 콜백 `talkverse.ar://auth`. 통합 앱 쪽 연결은 uk 몫(2026-11-09 알림 보냄) |

## 2026-11-18 iOS 심사 준비(통합 앱) — 일본어앱 수준 맞추기
- 지시(일본어앱 전달 `~/talkverse/ja/docs/RELAY_2026-11-18_ja_parity.md`): 회화 원고 서버 받기 + 회화 30%(급마다) + 단어 그림은 공용 DB + 장면 컷 10장이면 심사 준비 끝.
- **원고 서버 받기 완료**(`cfc5bf6`): `lib/services/script_sync.dart`(켤 때마다 `embedInit` 에서 15초까지), 회화 읽기 = `ScriptSync.load`, 기준표 `assets/data/script_rev.json`. 서버 R2 `script/ar/` rev 1(index + 7편, `https://auth.talkverse.uk/art/script/ar/index.json`). 원고를 고치면 `cd app && python3 tools/script_publish.py --publish` 후 `script_rev.json` 커밋. 편 id·턴 번호 잠금 `app/data/review/turn_lock_ar.json`(`tools/turn_lock.py`).
- 장면 설명의 A/{name} → 이름(`Dialogue.sceneShown`, 일본어앱 111).
- CI: 새 Flutter stable 이 Gradle 9.3 을 요구 → `release.yml` Flutter 3.47.7 고정(`ccdb8c0`). Android 빌드 **23** https://apps.talkverse.uk/yCwOQ/504 (빌드 20 은 옛 코드였음 — 무시).
- **회화 58편 = 대사는 전부 Grok**(사용자 「무조건 그록으로 쓴걸로 해야해 클로드가 쓴건 지문이 남아」, uk 원칙 「Claude 는 초안까지」). 사용자 선택: 65편(R0 12·R1 18·R2 14·R3 10·R4 6·R5 5) · Grok 빠른 · 장면 컷 10장은 이 세션이 Grok 으로.
  - 초안+규칙 `tools/prompts/write_grok_ar.md`(편 58줄 = 상황·인물·반전·낱말), 돌리기 `zsh tools/grok_write_run.sh <id>...`(→ `data/review/grok/write/<id>.md`), 변환 `python3 tools/grok_write_to_json.py`(→ `data/review/write/grok_20261118/`, 대사 손대지 않음). 그 뒤 리뷰 페이지 → 사용자 통과 → `sync_dialogues.py` → `script_publish.py --publish`(새 빌드 불필요).
  - **Grok 은 uk 순서 11번 — uk 가 「ar 시작」을 보낼 때까지 멈춤.** PC 크롬 9248 은 켜 둠(로그인 쿠키 동기화·빠른 모드 확인 완료).
  - 이미 나간 7편은 대부분 Claude 문장 — uk 에 신고, 다시 쓸지는 사용자 결정 대기.
- 남은 일(일본어앱 §2): 언어감각 과정(영상 → 외울 대화+참고) · 외국어 단어 3단계·퀴즈(아랍어엔 외래어 표기 체계가 없어 단어 복습 퀴즈로만) — 회화 다음.

## 2026-11-10 세션 종료(허브 정리 지시 — M6 디스크 꽉 참)
- 마지막 커밋 `9c45e02`(Grok 3분 상한). 진행 중 작업·루프·예약 작업 없음, PC 크롬 9248 Grok 탭 닫음(크롬도 같이 꺼짐 — 다시 쓸 때 PC 예약 작업 `Grok-Chrome-ar-9248`).
- DB 업로드 확인(uk 전달 사용자 지시): ar 은 새로 올릴 것 0 — `art_words` ar 2,554 는 이미 있음, 음성·장면 컷은 아직 안 만듦, 회화 JSON 은 앱 에셋+저장소가 정본(uk 확인).
- 정리: `app/build`·`.dart_tool`·`android/.gradle`·`ios/Pods`·`.wrangler`·`__pycache__`·`run_device.log` 삭제(약 3.9GB). **다음 빌드 전 `flutter pub get`(iOS 는 `pod install` 자동)** — 첫 빌드가 오래 걸림.
- uk 전언: 「음성 새벽 원칙은 사용자가 폐기(11/10)」 — 사용자 직접 확인 전이라 전역 CLAUDE.md 원칙(01~07시)대로 둠.
- 다음: 아래 「다음 할 일」 그대로(음성 → 장면 컷 → `seed_loader.dart` 새 편 이전).

## 2026-11-07~08 한 일
- **일본어앱 단어·메뉴 개편 이식**(`d1cfde2`): 절벽 단어 = 이집트 구어 레마 상위 2,000(`assets/data/freq/lang_ar_cliff.csv`, 검토로 225개 숨김 — 조각·인명·비속어·판정 불가, 순위 번호는 그대로) · 20어 단원 타일 · 「회화 단어 포함」(`conv_words_ar.json`) · 앱 소개(`about_screen.dart`, 값은 `lib/core/cliff.dart` 한 곳) · 메뉴 = 기초 → 문법 → 회화 → 단어 → 참고 · 탭 「배우기·회화·진행·프로필」 · 프로필 정리(앱 업데이트 타일 삭제, 학습 기록 초기화) · 문장 낱말 탭 = 단어창, 길게 = 글자 시트 · 독음 전역 토글(기본 미표시, 켤 때 「힘들어도 독음을 보지 않고 익혀보세요」).
  - 만들기: `python3 tools/build_cliff_words.py ~/corpus_work/ar_eg/out/ar.csv ~/corpus_work/ar_eg/lemma_eg.tsv ~/corpus_work/ar_eg/review`(검토 JSON 은 리포 밖).
- **기초 「글자와 발음」**(`b8e3567`, `f8fa668`): 28자+ة·ى 격자(RTL)·묶음 칩(쉬운 소리·닮았지만 다른 소리·목 소리·강조음·모음 부호·**접사 글자 10 = 사알투무니하**)·한글 소리 토글·소리 시트(1초 뒤 재생·IPA 카이로/표준어·소리 나는 곳·조음 그림·한국어 비교·글자 모양·예시). 데이터 `lib/services/arabic_phonetics.dart`. 조음 그림은 **임시**(출시 전 자체 그림으로 교체, 출처 표기 넣지 않음 — 사용자 지시). 옛 앱 사알투무니하 원본 = `~/talkverse/_legacy/ar/lib/core/screens/ar_alphabet_screen.dart`, 리포 이력 `2a3dcd4`.
- **회화 Claude 초안**(사용자: 샘플 통과, Fable 로 작성): `data/review/write/samples_20261107/` — 레벨 0~5 한 편씩 7편 78턴(`sample.md` 에 세 줄 + 감정 + 여성판). chaos 3/7. 앱 에셋에는 아직 안 넣음. 성별판 칸 = `ar_f`·`rd_f`·`ko_f`·`segs_f`.
- **회화 규칙 확정**(`app/docs/DIALOGUE_RULES_ar.md`): 굴절어 공통안 + 아랍어 대안 3개(사용자 동의) — 존댓말 활용 없음 → 가게 장면 R1 허용·حضرتك 만 그래머2 / 회화 어휘 상한 = 상위 512위, 밖 단어 턴당 R1 1·R2 2·R3 3 / 본문 타슈킬 없음. 시샤 소재 금지.

## 다음 할 일(순서)
- **회화 7편 통과(2026-11-09 사용자 「좀더 일상대화처럼 하고 그냥 진행」)** — 5편 일부를 실제 일상 흐름으로 고치고(`sample.md` 맨 위 표) 앱 에셋 연결: `app/assets/data/dialogues/R0~R5/<주제>/<id>.json`(`python3 tools/sync_dialogues.py ../data/review/write/samples_20261107/r*.json` — `approved` 편만, 그 뒤 `~/corpus_work/ar_eg/.venv/bin/python tools/add_lemmas.py`, `python3 tools/build_cliff_words.py …` 로 회화 단어 갱신). 로더 `dialogue_service.dart` 가 편 파일을 읽고(없을 때만 옛 L1), 학습자 성별이 여성이면 `ar_f`·`rd_f`·`ko_f`. 문장 카드·말하기 DB 시딩(`seed_loader.dart`)은 아직 옛 L1. 리뷰 Artifact https://claude.ai/artifact/5ttchBXSuh4vKs9V5dMQFZ (db `reviews`). **다음: 음성(새벽 01~07시만 — `~/talkverse/ja/docs/DIALOGUE_AUDIO.md`, 감정 열로 계획 생성) → 장면 컷 → 레벨별 추가 편(사용자 지시 뒤).** PC Grok = 크롬 9248(`Grok-Chrome-ar-9248`, 터널 `ssh -fN -L 9248:127.0.0.1:9248 pc`), 회차 `zsh tools/grok_rewrite_run.sh <편id>...`, 원고 `python3 tools/grok_src.py <json>...`.
0. **빌드 15 확인**: 저장 이름 `ar_` 이전 첫 판 — 폰·아이패드에서 덮어 설치 뒤 학습 기록·이름·성과가 남는지 확인.
1. 미얀마어앱 사알투무니하 좌우 반전판 — 사용자 지시로 2026-11-08 빌드 12 뒤 미얀마어 세션(`my-f6`)에 요청 보냄(만드는 것은 그 세션 몫).
2. **아이패드 스크린샷 확인**: `python3 app/tools/pane_shots.py F3FF452D-C5CF-4782-83DB-3DCF252451D9 <폴더>` — 11-08 실행이 앱 빌드 뒤 멈춰 중단함(원인 미확인, 재부팅 직후). 흐름 `integration_test/dialogue_pane_test.dart` 에 절벽 단어·앱 소개·글자와 발음 단계 추가돼 있음. 호스트 테스트(`test/menu_words_test.dart`, 폰·아이패드 칸·전체 크기)는 넘침 없이 통과.
3. **회화**: Grok 재작성(11-09 13:30 재개, 편마다 새 방, 한자 세션 경유 가능) → 리뷰 → 사용자 통과 → 앱 에셋(`assets/data/dialogues/R<레벨>/<주제>/`, 로더가 `es` 칸을 읽으니 `ar`↔`es` 정리) → 음성(`~/talkverse/ja/docs/DIALOGUE_AUDIO.md`, 감정 열로 계획 자동 생성 스크립트를 이 앱용으로, uk 에 "시험 준비됨" → "지금 시작" 뒤 PC) → `data/review/REVIEW_ar.html` → uk "REVIEW_ar 갱신". 레벨별 한 편 뒤 추가 작성은 사용자 지시 뒤(B15).
4. (사용자) TestFlight 설치 확인, App ID Sign in with Apple, 인앱 상품 등록(`app/docs/STORE_PRODUCTS.md` 표), 무료/유료 구간. 출시는 Talkverse 통합 앱 하나.
5. 표현 풀 CSV(إزيك·ماشي·خلاص·طب·على حسابي·متشكر…)와 「Conv」 단어장 보강(شاي·زحمة 등) — 회화 밖 콘텐츠라 동결 해제 뒤.

## 주의
- **Grok(2026-11-09 허브 공지 `~/logs/rc/RELAY_grok_20261109.md`)**: 한자 세션 대행 중단 — 이 세션이 직접. 자기 크롬을 켜고 M4 의 `/usr/bin/python3 ~/talkverse-uk/tools/grok_cookie_sync.py 9231 <자기 포트>`(M6 에서는 `ssh macmini4` 경유)로 쿠키 동기화, 요청 도구는 M6 `~/Hanja/tools/grok_req.py`·`grok_cdp.py` 를 복사. uk 의 방(포트 9231)은 건드리지 말 것. **모델은 「전문가」**(사용자 지시 2026-11-09) — 켤 때마다 `/usr/bin/python3 ~/talkverse-uk/tools/grok_mode.py <포트>`(보기만 `--check`, M4)로 확인·전환.
- **Grok 답은 3분까지만(사용자 지시 2026-11-10 「그록 3분만, 넘어가면 대화방 중지 — 토큰 낭비」)**: `tools/grok_text.py` 대기 상한 180초, 넘으면 중지 단추(없으면 Escape) 누르고 종료 코드 4 — `grok_rewrite_run.sh` 는 그 답을 버린다.
- **Grok 프롬프트 최소화(사용자 지시 2026-11-09)**: 규칙은 문서에 한 번(첨부), 방 첫 메시지에 「앞으로 파일 이름 한 줄만 보낸다」 약속, 이후 채팅은 한 줄만. 그림이 처음과 달라지면 최초 통과 그림 기준(이미 만든 것은 그대로). 회화는 줄마다 음성용 `emotion`(감정이 바뀌면 `segs`).
- 공개 저장소 — 말뭉치·작품·자막 이름 금지. 출처 이름은 `~/corpus_work/ar_eg/SOURCE.md` 에만.
- M6 빌드 수: `ps -axo args= | grep -c '^[^ ]*dartvm .*flutter_tools.* build '`(`pgrep -f flutter_tools.snapshot` 은 대기 명령까지 세어 서로 기다리게 됨). 시뮬레이터는 `ar-shots iPad Air 11` 만, 끝나면 shutdown.
- 빌드 뒤 `ios/Podfile*`·`swiftpm/`·pbxproj·xcconfig·xcscheme 변경과 CRLF 표시는 잡음 — 커밋하지 말 것. `git add` 는 경로 지정.
- 아이콘은 talkverse.uk 세션 담당. 서명 키 새로 만들지 말 것.

## 2026-11-22 밤 — 토크버스 커리큘럼 메뉴(uk 전달, 기준 `~/talkverse/CURRICULUM_SPEC.md`)
- 사용자 원문(uk 창): 「모든 세션에 토크버스 커리큘럼 메뉴를 만들어줘…80% 이상이 넘으면 코스가 넘어가고 매일 분량을 주고.」
- `app/lib/services/curriculum.dart`(저장·채점·간격 반복 1/3/7일·문제 생성·추천) + `app/lib/screens/curriculum_screen.dart`(레벨 고르기·코스 3/5/10편·연습·확인 문제·코스 시험·복습) + 홈 카드 `CurriculumHomeCard`(메뉴 위, R 레벨 편 없으면 숨김).
- 저장 키 = `Prefs` 접두로 `ar_curriculum_v1`(uk 정정 「<언어>_curriculum_v1」 충족). 형식 §7 + 덧붙임 `today{day,new,review}`. dailyGoal = 새 편 수 1·2·3.
- 문제 꼴: 뜻 4지선다 · 빈칸 낱말 4지선다(lemmas). 7일 간격에서 맞히면 대기열에서 졸업. 시험 실패 → 틀린 편만 practiced 에서 빠짐.
- 시험: `test/curriculum_test.dart`(80% 경계·간격 날짜·형식 왕복), `test/curriculum_screen_test.dart`. `dialogue_load_test` 는 Grok 원고·턴 재배치에 맞춰 고침(옛 원고 기준 단언).
- 남음: 일본어앱 기준 커밋이 나오면 화면·문구 맞춤. §9 AI 다이얼로그 작성은 일본어앱 공유 → uk 재전달 뒤(만들어도 숨김).
- **11-22 밤 일본어 기준(ja ceb91c3)으로 맞춤**(uk 전달, SPEC §10): 내 첫 판 `curriculum.dart` 를 지우고 ja `curriculum_service.dart`·`curriculum_screen.dart`·`test/curriculum_test.dart` 를 옮김(칸 ja→tl, 레벨 `kCurLevels` R0~R5, 아랍어 줄 RTL·독음 표시, 홈 카드는 R 편 없으면 숨김). 문구 50줄 en/ja/zh 를 l10n_dict 에 추가. 시험 문제 수 = 편당 max(3, min(10, 30÷편수)).
- **AI 회화 작성(맞춤 회화) 화면 숨김 상태로**(SPEC §11): ja `custom_script_screen.dart`·`custom_script_service.dart` 를 옮김 — 서버 `https://talkverse.uk/api/script/ar`, 레벨 R0~R5, 추천 상황은 이집트 장면으로 바꿈, `kCustomScriptLive = false`(메뉴 `회화` 칸에 조건부). `Dialogue.fromJson` 을 dialogue_service 에 뽑아 공용. 맞춤 회화 문구 번역(en/ja/zh)은 아직 — 켤 때 ja 사전에서 옮길 것. 켜는 것은 사용자 결정(작성기는 uk 공용).
- **11-22 밤 칩 줄 Wrap**(uk 전달, 몽골어앱 발견): 코스 고르기 3·5·10 칩 + 「추천으로 채우기」 Row→Wrap(300px 폭 136px 넘침). `test/curriculum_width_test.dart`(폰 390·좁은 칸 300) — 옛 코드에서 실패 확인. 사용자 「넣어야지」(uk 전달) — 커리큘럼은 심사 빌드에 보이게, 맞춤 회화는 숨김 그대로.
