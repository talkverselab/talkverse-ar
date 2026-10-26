# Supabase → Cloudflare 이관 — 아랍어앱 조사

2026-10-26 작성. 지침 `~/cloudflare-migration/GUIDE.md`, 설계 `talkverse/th/docs/CLOUDFLARE_MIGRATION.md` §2. **아무것도 만들거나 지우지 않았다**(D1·R2·Worker 생성, 코드 변경 없음).

## 결론 — 지금 앱은 Supabase 를 쓰지 않는다 (확인 2026-10-26)

- 앱 코드(`lib/`)·`pubspec.yaml`·`AndroidManifest.xml`·`Info.plist`·CI 워크플로에 Supabase 주소·키·패키지·딥링크가 없다. 2026-09-11 재구축 때 `supabase_flutter` 가 빠졌고, 2026-09-22 커밋 `72919c2` 에서 마지막 딥링크도 지웠다.
- 회화·단어·빈도 콘텐츠는 앱 안 자산(`assets/data/`), 앱 업데이트는 GitHub 릴리스 — 네트워크 DB 가 없다.
- 로그인·계정·구독·코스 동기화·개발자 메모 기능 없음 → `talkverse-accounts`·`talkverse-auth`·`talkverse-db` 로 옮길 것 없음.
- `app/` 의 `build_apk.log`·`run_device*.log`·`analyze_out.txt` 에 `supabase_flutter` 가 보이는 것은 재구축 전 옛 기록(추적 안 되는 파일).

## 리포에 남은 Supabase 흔적 (앱이 실행 중 쓰지 않음)

| 파일 | 내용 |
|---|---|
| `app/supabase/seed_ar.sql` (약 597 kB) | 옛 공용 `items` 표에 넣던 시드 SQL(회화 문장·빈도 단어) |
| `app/supabase/seed_order_ar.sql` · `seed_tier_ar.sql` | 같은 표의 순서·등급 갱신문 |
| `app/supabase/tools/_export_seed_to_json.py` | 위 SQL → 로컬 JSON 자산 변환기(Supabase 에 접속하지 않음) |

옛 시스템의 자료일 뿐이라 이관 대상이 아니다. 지울지는 사용자 결정(지금은 그대로 둠).

## 공용 Supabase 안의 아랍어 행 (SELECT 만, 2026-10-26)

| 표 | `ar` 행 | 비고 |
|---|---|---|
| `public.items` | 14 (sentence·word, 약 3 kB) | 옛 템플릿 시절 시험 행. 앱이 읽지 않는다 |
| `tv_course_answers` · `tv_course_progress` · `tv_dev_notes` | 0 · 0 · 0 | |
| 저장소 버킷 | 아랍어 파일 0 | |

→ Cloudflare 로 옮길 데이터 없음. `items` 의 `ar` 14행 삭제는 다른 언어 행과 함께 사용자가 정리할 때 실행(세션은 지우지 않음).

## 나중에 할 일 (지금은 대기 없음)

- 이 앱에 로그인·코스 동기화·개발자 메모를 넣게 되면 처음부터 `talkverse-auth`·`talkverse-api`(th 설계 §2-5·§2-6, `lang='ar'`)를 쓴다. Supabase 를 다시 넣지 않는다.
