-- ============================================================
-- Gemini 검수 대상 — DE L6 sample (1 dialogue / 9 turns)
-- 검수 프롬프트: docs/_de_l6_review_gemini_prompt.md
--   → 먼저 프롬프트 보내고 "OK" 답 받은 뒤 본 파일 통째로 두 번째 메시지로 전송
--
-- 작성: Talkverse 총괄 룸, 2026-04-26
-- 원본: supabase/seed_dialogue_de_l6_sample.sql (동일 내용 — Gemini 1차 교정 t04·t09 반영됨)
--
-- ============================================================
-- 검수 컨텍스트 요약 (프롬프트와 중복 — 빠른 참조용)
-- ============================================================
--
-- 앱: 한국 학습자용 독일어 학습 모바일 앱 (Talkverse)
-- 레벨: L6 (Midnight Lounge — 성인 인증 게이트)
-- 목표: 30대 어른 연애·동거·친밀 회화 학습
-- 양산 예정: 30 dialogues. 본 sample 은 첫 dialogue, 톤 calibration 용
--
-- 캐릭터:
--   A = Ben    (35, 독일인, 베를린 시니어 엔지니어)
--   B = Hannah (32, 한국인, 베를린 5년차 IT PM, 독어 C1)
--
-- 장면: 회사 워크숍 후 와인 → 호텔. 다음날 아침. Morning-after pillow talk.
--
-- 톤 정책:
--   OK: 시적 관능 / 욕망 / 신체 sensation / morning-after / Sauna 누드 / 동의
--       어휘 풀: Begierde, Verlangen, Sehnsucht, Haut, Berührung, zärtlich,
--       atmen, zittern, glühen, schwül, Liebkosung, Lust, Höhepunkt, nackt
--   X : graphic 행위 / 명시 성기 / 체액 묘사 / ficken 류 vulgar / 미성년 / 비합의
--
-- 평가 6축 (각 1~5):
--   1. 자연도 (베를린 30대 morning-after 톤?)
--   2. 어휘 적절성 (시적 비율, 어색함)
--   3. 등급 안전 (Google Play / App Store 통과)
--   4. 캐릭터 일관성 (시니어 엔지니어 / 한국인 IT PM 페르소나)
--   5. 학습 가치 (어휘·문법 충분성)
--   6. Hook (학습 동기)
--
-- 출력: 평가 표 + 교정 제안 (있으면 1~3개) + L6 30 dialogues 양산 가이드
-- ============================================================

delete from public.items where id like 'de:sent:l6_d01_%';

insert into public.items
  (id, type, target_text, korean, romanization, category, course,
   tags, notes, comment, language_code, speaker, turn_order, scenario, vocab_hints)
values

('de:sent:l6_d01_t01', 'sentence',
 'Du bist noch da.',
 '아직 있네.',
 '두 비스트 노흐 다.',
 '대화01', 6, '{new,l6,arc1,intimate}',
 'noch = 아직. da = 여기 (강조)', 'Ben 잠 깨 옆을 돌아봄. 약간의 놀람·기쁨',
 'de', 'A', 1,
 'L6 arc1 d01 — 호텔 방, 토요일 아침 8시. Ben (35, 독일인 시니어 엔지니어) 깨어남. 옆에 Hannah (32, 한국인 IT PM, 베를린 5년차) 있음. 어제 회사 워크숍 후 와인 → 첫 밤',
 '[{"w":"noch","ko":"아직"},{"w":"da","ko":"여기 (강조)"}]'::jsonb),

('de:sent:l6_d01_t02', 'sentence',
 'Sollte ich nicht?',
 '있으면 안 돼?',
 '졸테 이히 니히트?',
 '대화01', 6, '{new,l6,arc1,intimate}',
 'sollte = sollen 접속법2 (~해야 했나?)', 'Hannah 눈 뜨며. 가벼운 도발',
 'de', 'B', 2, '호텔 방',
 '[{"w":"Sollte","ko":"~해야 했다 (sollen 접속법2)"},{"w":"ich","ko":"나 (1격)"},{"w":"nicht","ko":"~않다"}]'::jsonb),

('de:sent:l6_d01_t03', 'sentence',
 'Doch. Sehr.',
 '있어야지. 아주.',
 '도흐. 제어.',
 '대화01', 6, '{new,l6,arc1,intimate}',
 'Doch = 부정 질문에 긍정 답 (DE 핵심)', '★ Doch 의 결정적 사용 — 한국어에 없는 답 방식',
 'de', 'A', 3, '호텔 방',
 '[{"w":"Doch","ko":"긍정 (부정 질문 거부 답)"},{"w":"Sehr","ko":"아주·매우"}]'::jsonb),

('de:sent:l6_d01_t04', 'sentence',
 'Ich hab deinen Atem auf meiner Haut gespürt. Die ganze Nacht.',
 '네 숨을 내 피부에서 느꼈어. 밤새.',
 '이히 합 다이넨 아템 아우프 마이너 하우트 게슈퓌어트. 디 간체 나흐트.',
 '대화01', 6, '{new,l6,arc1,intimate}',
 'hab gespürt = haben + 과거분사 (현재완료, pillow talk 생동감). deinen Atem = 4격. meiner Haut = Dat 3격', '★ 시적 회상 — Gemini 검수 반영 (현재완료로 즉각성 ↑)',
 'de', 'B', 4, '호텔 방',
 '[{"w":"hab","ko":"~했다 (ich, 구어 완료조동사)"},{"w":"deinen Atem","ko":"네 숨 (m, 4격)"},{"w":"auf","ko":"~위에 (Dat)"},{"w":"meiner Haut","ko":"내 피부 (f, Dat)"},{"w":"gespürt","ko":"느꼈다 (과거분사)"},{"w":"Die ganze Nacht","ko":"밤새 (f, 4격)"}]'::jsonb),

('de:sent:l6_d01_t05', 'sentence',
 'Und ich dachte, ich träume.',
 '난 꿈인 줄 알았어.',
 '운트 이히 닥흐테, 이히 트로이메.',
 '대화01', 6, '{new,l6,arc1,intimate}',
 'dachte = denken 과거. träumen = 꿈꾸다', '',
 'de', 'A', 5, '호텔 방',
 '[{"w":"dachte","ko":"생각했다 (denken 과거)"},{"w":"träume","ko":"꿈꾸다 (ich)"}]'::jsonb),

('de:sent:l6_d01_t06', 'sentence',
 'Bin ich zu echt für einen Traum?',
 '꿈이라기엔 너무 진짜야?',
 '빈 이히 추 에히트 퓌어 아이넨 트라움?',
 '대화01', 6, '{new,l6,arc1,intimate,flirt}',
 'zu + 형용사 = 너무 ~한. für + Akk = ~에게', 'Hannah 의 도발 — 진심 + 장난',
 'de', 'B', 6, '호텔 방',
 '[{"w":"zu","ko":"너무 (정도)"},{"w":"echt","ko":"진짜의"},{"w":"für","ko":"~위해 (Akk)"},{"w":"einen Traum","ko":"꿈 (m, 4격)"}]'::jsonb),

('de:sent:l6_d01_t07', 'sentence',
 'Du bist warm. Du bist hier. Du riechst nach Wein und nach... nach mir.',
 '너 따뜻해. 너 여기 있어. 와인 향, 그리고... 내 향이 나.',
 '두 비스트 바름. 두 비스트 히어. 두 리히스트 나흐 바인 운트 나흐... 나흐 미어.',
 '대화01', 6, '{new,l6,arc1,intimate,sensual}',
 'riechen nach + Dat = ~향이 나다. mir = ich 의 Dat 3격', '★ sensual peak — 신체 sensation, 행위 묘사 X',
 'de', 'A', 7, '호텔 방',
 '[{"w":"warm","ko":"따뜻한"},{"w":"hier","ko":"여기"},{"w":"riechst","ko":"향이 나다 (du)"},{"w":"nach","ko":"~의 (Dat)"},{"w":"Wein","ko":"와인 (m, Dat)"},{"w":"mir","ko":"나에게 (Dat)"}]'::jsonb),

('de:sent:l6_d01_t08', 'sentence',
 'Lass mich nicht aufstehen.',
 '일어나게 하지 마.',
 '라스 미히 니히트 아우프슈테엔.',
 '대화01', 6, '{new,l6,arc1,intimate,desire}',
 'lassen + Akk + 원형 = ~하게 두다. aufstehen = 분리동사 (일어나다)', '★ 욕망 표현 — 직접적, 우아함, 정책 안전',
 'de', 'B', 8, '호텔 방',
 '[{"w":"Lass","ko":"~하게 둬 (du 명령)"},{"w":"mich","ko":"나를 (4격)"},{"w":"aufstehen","ko":"일어나다 (분리)"}]'::jsonb),

('de:sent:l6_d01_t09', 'sentence',
 'Keine Sorge, ich hab den Wecker schon ausgeschaltet.',
 '걱정 마, 이미 알람 꺼놨어.',
 '카이네 조르게, 이히 합 덴 베커 숀 아우스게샬테트.',
 '대화01', 6, '{new,l6,arc1,intimate,punchline}',
 'Keine Sorge = 걱정 마 (안심 표현). ausschalten = 분리동사. ausgeschaltet = 과거분사', '★ 펀치라인 — Ben 다정함 보강 (Gemini 검수 반영)',
 'de', 'A', 9, '호텔 방',
 '[{"w":"Keine Sorge","ko":"걱정 마 (f, 4격)"},{"w":"hab","ko":"~했다 (ich, 구어)"},{"w":"den Wecker","ko":"알람 (m, 4격)"},{"w":"schon","ko":"이미"},{"w":"ausgeschaltet","ko":"꺼놨다 (과거분사)"}]'::jsonb)

on conflict (id) do update set
  target_text = excluded.target_text,
  korean = excluded.korean,
  romanization = excluded.romanization,
  category = excluded.category,
  course = excluded.course,
  tags = excluded.tags,
  notes = excluded.notes,
  comment = excluded.comment,
  language_code = excluded.language_code,
  speaker = excluded.speaker,
  turn_order = excluded.turn_order,
  scenario = excluded.scenario,
  vocab_hints = excluded.vocab_hints;
