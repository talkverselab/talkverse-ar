# 심사 메모(App Review Notes) · 개인정보 답 · 방침 추가 문안 — 아랍어유니버스 (2026-11-02)

> 한자유니버스 `docs/store/review_notes.md`·`data_safety.md` 를 아랍어앱에 맞춘 것. 서버·계정 구조는 `~/talkverse/TALKVERSE_ID_APP_GUIDE.md`.
> 이 앱은 **아직 잠근 콘텐츠가 없다**(무료/유료 구간 미정 — 사용자 결정). 평생 이용권은 프로필 → 계정 → 평생 이용권 보기에서 산다.
> 확인 필요: 개인정보처리방침 URL(아래 `<방침 URL>`), 데모 계정에 이용권 lang `ar` 부여(talkverse.uk 세션), App Store Connect 앱 레코드·IAP 상품 등록(사용자).

## App Store Connect "심사 정보 → 메모"

```
[로그인] 로그인은 선택입니다. 모든 학습 기능은 로그인 없이 사용할 수 있고, 로그인은 구매 복원과 기기 간 이용권 공유에만 쓰입니다.
- 로그인 화면: 프로필 탭 → 설정 → 계정 → 로그인. Apple로 로그인 + 이메일 로그인(심사·테스트용).
- 데모 계정(이메일 로그인): review@talkverse.uk / 비밀번호: <Doppler keys/prd TALKVERSE_REVIEW_ACCOUNT 에서 복사해 여기 입력>
- 계정 삭제: 프로필 탭 → 설정 → 계정 → 계정 삭제(확인 창) → 서버에서 개인정보가 삭제되고 모든 기기에서 로그아웃됩니다.
[인앱 구입] 비소모성 "평생 이용권"(com.talkverse.arabicUniverse.lifetime) 1개. 프로필 탭 → 설정 → 계정 → [평생 이용권 보기] → [평생 이용권 구매 ₩…], 복원은 [이전 구매 복원]. Sandbox 계정으로 시험할 수 있습니다. 로그인 없이도 구매·복원이 됩니다.
[마이크·음성 인식] 말하기 연습에서 사용자가 말한 아랍어 문장을 기기 음성 인식으로 판정할 때만 씁니다. 녹음은 서버로 보내지 않습니다.

[Sign-in] Optional. Every learning feature works without an account; sign-in is only for restoring purchases across devices.
- Where: Profile tab → Settings → Account → Sign in (Sign in with Apple, or email sign-in for review/testing).
- Demo account (email sign-in): review@talkverse.uk / password: <paste from Doppler>
- Account deletion: Profile tab → Settings → Account → Delete account (confirmation) → personal data is deleted server-side and all sessions are revoked.
[IAP] One non-consumable "Lifetime Pass" (com.talkverse.arabicUniverse.lifetime). Profile tab → Settings → Account → [See Lifetime Pass] → [Buy Lifetime Pass ₩…]; [Restore purchases] to restore. Works with a Sandbox account; sign-in is not required to buy or restore.
[Microphone / speech recognition] Used only in speaking practice to check the Arabic sentence the user says, with on-device speech recognition. Audio is not sent to our servers.
```

## App Store "앱 개인정보 보호" 답
- 데이터 수집: **예**(로그인·구매한 사용자만).
- 수집 항목(사용자와 연결됨, 추적 아님): 이메일 주소(계정 관리) · 이름(로그인 제공자가 주는 범위, 선택) · 사용자 ID(Talkverse 계정 ID) · 구매 내역(이용권 복원).
- 수집하지 않음: 위치·건강·금융(카드는 Apple/Google 처리)·사용 데이터·진단·검색 기록·음성(말하기 판정은 기기 안). 추적(ATT) 없음.
- 학습 기록·설정은 기기 안에만. 계정 동기화를 넣으면 "사용자 콘텐츠 → 기타(학습 진도)" 추가.

## Google Play 데이터 보안 답
- 수집: 예 — 이메일 주소·이름(계정 관리, 선택), 사용자 ID, 구매 내역. 전송 암호화 예. 사용자가 삭제 요청 가능: 예 — 앱 안 "계정 삭제" + https://talkverse.uk/account/delete
- 공유: 없음(결제 처리는 Google Play). 광고 없음.
- 권한: 인터넷, 마이크(말하기 연습), 앱 업데이트 설치(직접 배포판).

## 개인정보처리방침에 추가할 문안(`<방침 URL>` — talkverse.uk 세션 반영)
```
계정(선택)
아랍어유니버스는 로그인 없이 쓸 수 있습니다. Talkverse 계정으로 로그인하면 다음을 처리합니다.
- 수집 항목: 이메일 주소, 이름(Apple·Google 등 로그인 제공자가 전달하는 범위), 계정 ID, 로그인 시각·기기 식별 토큰.
- 목적: 로그인 유지, 구매(평생 이용권) 복원과 기기 간 공유, 고객 문의 응대.
- 보관: 계정 삭제 시 즉시 삭제(구매·주문 기록은 관계 법령에 따라 회계 목적으로 사용자 ID 만 남깁니다).
- 삭제 방법: 앱 → 프로필 → 계정 → 계정 삭제. 또는 talkverse.lab@gmail.com 으로 요청.
- 처리 위탁·국외 이전: 계정 서버는 Cloudflare(미국 등 글로벌 리전)에서 운영됩니다.

결제
평생 이용권 결제는 Apple App Store 또는 Google Play 가 처리하며, 앱은 카드 정보를 받지 않습니다. 앱은 구매 영수증(거래 번호·상품 ID)만 확인해 이용권을 적용합니다.
```

## IAP 상품 심사 스크린샷
- 평생 이용권 시트 캡처(프로필 → 계정 → 평생 이용권 보기)를 상품 등록 화면 "심사 정보 → 스크린샷"에 올린다.
