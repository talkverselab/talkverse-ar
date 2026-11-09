# 스토어 상품·차별화 — 아랍어유니버스 (2026-11-09)

출시는 **Talkverse 통합 앱 하나**(com.talkverse.app)로 한다(uk 공지). 이 앱은 통합 앱 안의 아랍어 패키지이자, 개발·시험용 단독 앱(Zealot·TestFlight)이다. 가격 = `~/talkverse/PRICING.md`(사용자 확정 2026-11-09) 의 앱 정가 / 앱 할인가. **등록은 사용자가** App Store Connect·Google Play Console 에서 한다.

## 1. 상품

| 상품 ID | 이름(한국어 표시) | 종류 | 기간 | 앱 정가 | 스토어 판매가(할인가) |
|---|---|---|---|---|---|
| `lang_ar_1m` | 아랍어 1개월 | 자동 갱신 구독 | 1개월 | 5,500 | **3,900** |
| `lang_ar_3m` | 아랍어 3개월 | 자동 갱신 구독 | 3개월 | 12,900 | **9,000** |
| `lang_ar_1y` | 아랍어 1년 | 자동 갱신 구독 | 1년 | 28,500 | **19,900** |
| `lang_ar_life` | 아랍어 평생 이용권(서비스 운영 기간 동안) | 비소모성 | — | 69,900 | **49,000** |
| `all_1y` | 종합 패키지 1년 — 모든 언어 | 자동 갱신 구독 | 1년 | 112,900 | **79,000** |
| `all_life` | 종합 패키지 평생 — 모든 언어(서비스 운영 기간 동안) | 비소모성 | — | 469,000 | **329,000** |

- 앱 결제 시트는 정가를 취소선으로, 스토어 가격을 크게 보여 준다(`lib/screens/paywall_screen.dart`, 가격표는 `Purchase.configure`). 앱 안에서 사이트 가격을 안내·유도하지 않는다.
- 옛 평생 상품 `com.talkverse.arabicUniverse.lifetime`(iOS)·`lang_ar`(Android)은 판매 중지, 앱은 복원 때 `lang_ar_life` 로 인정한다.
- 약관 https://talkverse.uk/terms/ · 개인정보처리방침 https://talkverse.uk/talkverse/ar/privacy/
- 통합 앱에서는 공용 결제가 스토어 스트림을 듣고 이 언어 상품을 패키지로 넘긴다(EMBED_GUIDE 5단계). `all_*` 의 등록·인정 방식은 uk 가 정한다.
- **아직 잠근 기능이 없다** — 무엇을 유료로 할지 사용자 결정 대기(굴절어 전략 A10: 무료 = 레벨 0 + 코어 + 라임 + 레벨 1 묶음 1~2, 페이월 = 라임 직후).

## 2. 차별화(애플 지침 4.3 대비, `~/talkverse/STORE_DIFFERENTIATION.md`)

### 스토어 설명 첫 줄(안)
> 글자가 자리마다 모양을 바꾸고 오른쪽에서 왼쪽으로 읽는 말 — 교과서 표준어가 아니라 카이로 사람들이 실제로 쓰는 이집트 구어를, 대사에 가장 자주 나오는 순서대로 배웁니다.

### 아랍어 전용 학습 도구(지금 앱에 있는 것만)
1. **글자와 발음** — 28자 + 낱말 끝 글자 ة·ى 격자(오른쪽→왼쪽), 묶음별(쉬운 소리·닮았지만 다른 소리·목 소리 ح خ ع غ ق·강조음 ص ض ط ظ). 글자를 누르면 1초 뒤 소리, IPA(카이로 발음과 표준어 발음을 함께 — ج = g, ق = 성문 닫힘), 소리 나는 곳, 조음 위치 그림, 한국어 소리와 비교, 자리별 글자 모양 4가지, 예시 낱말. 모음 부호 6개.
2. **접사 글자 10(사알투무니하 سألتمونيها)** — 낱말 앞뒤에 붙는 10글자를 이집트 구어 쓰임(카이로 미래 هـ, 부정 ما…ش, 「나·너·그」 활용 접두)과 예문으로.
3. **글자 돋보기** — 회화 문장의 낱말을 길게 누르면 글자로 풀어 지금 쓰인 모양(홀로·앞·가운데·끝)을 보여 준다. 낱말을 누르면 기본형 단어창(활용형 → 표제어).
4. **절벽 단어** — 이집트 구어 영화·드라마 대사를 형태 분석기로 표제어(관사·접미 분리)로 센 순위: 68단어로 55%, 101단어 60%, 216단어 70%, 512단어 80%, 2,000위까지 91.7%. 20어 단원 타일, 회화에 나온 단어 포함 보기.
5. **오른쪽→왼쪽 화면** — 회화 리더·단어창·글자 격자가 아랍어 흐름(RTL)으로 놓인다. 한글 독음은 기본 꺼짐(켜면 「힘들어도 독음을 보지 않고 익혀보세요」).

### 출시 전에 채울 것(지금은 없음 — 설명에 쓰지 않는다)
- 회화: 앱의 회화는 옛 앱에서 옮긴 7편 77턴. 새 회화(굴절어 전략 레벨 0~5, 성별판·감정 열)는 Claude 초안 7편(`data/review/write/samples_20261107/`) — Grok 재작성·사용자 통과 뒤 앱 연결.
- 회화 음성(남녀 학습자판) 없음, 장면 컷 없음.
- 조음 위치 그림은 임시 — 출시 전 자체 그림으로 교체(사용자 지시).
- 표현 풀·「Conv」 단어장 보강(متشكر·شاي 등 생활 필수어).

### 실측 숫자(출시 때 다시 확인)
- 절벽: R1 68 · R2 101 · R3 216 · R4 512 레마, 2,000위 누적 91.7%(이집트 구어 대사 108편·44만 어절). 절벽 단어 화면 표시 1,774어(조각·인명·비속어·중복 226개 숨김).
- 회화: 앱 7편·77턴 / 새 초안 7편·78턴(출시 전 숫자로 바꿀 것). 음성 줄: 0.
- 글자: 30자(28 + ة·ى) · 글자 모양 104가지(4형 22자 + 2형 8자) · 모음 부호 6 · 접사 글자 10.

### 심사 메모 문단(영문, 숫자는 출시 판 기준으로 채움)
> This app is one of a family of language-specific apps by Universal Talking Lab (Talkverse). Each app is built from scratch for one target language for Korean speakers and is NOT a re-skin: the Arabic app has a right-to-left interface throughout, its own script & pronunciation module (28 letters plus ة/ى with their four positional shapes, throat and emphatic consonants, Cairene vs. Standard pronunciation, vowel marks, and the ten affix letters "sa'altumuniha"), a letter magnifier that splits any word in a dialogue into its letter shapes, and it teaches spoken Egyptian Arabic rather than textbook Standard Arabic. It includes [N] original conversation episodes with recorded audio written for this dialect, and a vocabulary list measured from an Egyptian Arabic conversation corpus (68 / 101 / 216 / 512 lemmas cover 55 / 60 / 70 / 80 %). Content, curriculum and UI flows differ between apps; we keep them separate because learners search for and buy one language at a time.

### 스크린샷 순서(고유 화면 먼저)
1. 글자와 발음 — 오른쪽→왼쪽 격자(목 소리·강조음 색) + 소리 시트(IPA 카이로/표준어·글자 모양 4가지)
2. 회화 리더 — 낱말 길게 누름 = 글자 돋보기(자리별 모양), 탭 = 단어창
3. 접사 글자 10(사알투무니하) 카드
4. 절벽 단어 — 68/101/216/512 표와 20어 단원 타일
5. 결제 시트(정가 취소선·할인가) — 마지막. 홈·프로필로 시작하지 않는다.
