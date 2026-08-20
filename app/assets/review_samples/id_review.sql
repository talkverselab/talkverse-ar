-- ============================================================
-- ID (인도네시아어) Talkverse 회화 콘텐츠 — Gemini 검수 sample
-- 작성: 2026-04-26
-- 목적: native speaker 검수 (자연성·번역·romanization·문화·윤리·자극 수위)
-- 분량: 6 dialogue / 68 turns (전체 596 turns 의 11% sample)
-- 선정 기준:
--   - L1 d01 인사 -- essential 톤·어기조사 (ya) 검증
--   - L3 d04 한국 가자 -- narrative 핵심 (인니녀 적극 제안)
--   - L3 d07 한국 결혼식 -- cross-cultural family + 종교 sensitive
--   - L6 d27 호텔 첫 밤 -- intimate sensual 수위 (Google Play 정책 안)
--   - L6 d29 첫 키스 -- consent 표현 핵심
--   - L6 d36 결혼 1주년 -- Sari x Min-jun arc cross + sweet talk
--
-- 검수 가이드: docs/_id_review_session_brief.md
-- 콘텐츠 정책: docs/planning/decisions_log.md Decision 45 + 45.1~45.3
-- ============================================================

-- 컬럼 형식:
--   id, type, target_text(인니어), korean(한국어 번역), romanization(한글 음역),
--   category, course, tags, notes(어휘 hint), comment(문화·맥락 주석),
--   language_code, speaker(A/B), turn_order, scenario

-- ============================================================
-- L1 d01 -- 인사 (Halo / Selamat pagi) -- 6턴
-- 시나리오: 아침 인사
-- 학습 포인트: greeting 표준, apa kabar 표준, baik/sehat, ya 어기조사 자연
-- ============================================================
('id:sent:l1_d01_t01', 'sentence', 'Halo, selamat pagi.', '안녕, 좋은 아침.', '할로, 슬라맛 빠기.', '대화01', 1, '{essential,greeting}', 'selamat pagi = 좋은 아침 (5-10시)', '아침 인사', 'id', 'A', 1, '아침 인사'),
('id:sent:l1_d01_t02', 'sentence', 'Pagi! Apa kabar?', '좋은 아침! 잘 지내?', '빠기! 아빠 까바르?', '대화01', 1, '{essential,greeting}', 'apa kabar = 안부 묻기 표준', '', 'id', 'B', 2, '아침 인사'),
('id:sent:l1_d01_t03', 'sentence', 'Baik, terima kasih. Kamu?', '좋아, 고마워. 너는?', '바익, 뜨리마 까시. 까무?', '대화01', 1, '{essential,greeting}', 'baik = 좋다', '', 'id', 'A', 3, '아침 인사'),
('id:sent:l1_d01_t04', 'sentence', 'Baik juga.', '나도 좋아.', '바익 주가.', '대화01', 1, '{essential,greeting}', 'juga = 또한', '', 'id', 'B', 4, '아침 인사'),
('id:sent:l1_d01_t05', 'sentence', 'Senang bertemu kamu.', '만나서 반가워.', '스낭 브르뜨무 까무.', '대화01', 1, '{essential,greeting}', 'bertemu = 만나다', '', 'id', 'A', 5, '아침 인사'),
('id:sent:l1_d01_t06', 'sentence', 'Senang bertemu juga.', '나도 반가워.', '스낭 브르뜨무 주가.', '대화01', 1, '{essential,greeting}', '', '', 'id', 'B', 6, '아침 인사'),

-- ============================================================
-- L3 d04 -- 인니녀 한국 가자 + 결혼 의향 (14턴) -- 사용자 컨셉 핵심
-- 캐릭터: Sari (27, 자카르타 K-pop 팬덤·카페 매니저) x Min-jun (32, IT 출장->정주)
-- 시나리오: Sari 집 -- 한국 정착 결심
-- 학습 포인트: nih 어기조사, mau, pindah, hidup, pikirin matang, siap, rela
-- 문화: 인니녀 가족 (이슬람 보수~자유), 인니녀 적극 한국 정착 의향
-- ============================================================
('id:sent:l3_d04_t01', 'sentence', 'Min-jun, kita serius nih?', '민준, 우리 진지해?', '민준, 끼따 스리우스 니?', '대화04', 3, '{romance,marriage,korea_move}', 'nih = 어기조사 (이거)', '관계 평가', 'id', 'B', 1, 'Sari 집 -- 한국 정착'),
('id:sent:l3_d04_t02', 'sentence', 'Aku serius.', '난 진지.', '아꾸 스리우스.', '대화04', 3, '{romance,marriage,korea_move}', '', '', 'id', 'A', 2, '집'),
('id:sent:l3_d04_t03', 'sentence', 'Aku mau ke Korea sama kamu.', '한국 같이 가고 싶어.', '아꾸 마우 끄 꼬레아 사마 까무.', '대화04', 3, '{romance,marriage,korea_move}', 'sama kamu = 너와 함께', '핵심 -- 인니녀 적극 제안', 'id', 'B', 3, '집'),
('id:sent:l3_d04_t04', 'sentence', 'Pindah ke Korea?', '한국 이주?', '삔다 끄 꼬레아?', '대화04', 3, '{romance,marriage,korea_move}', 'pindah = 이주', '한남 숙고', 'id', 'A', 4, '집'),
('id:sent:l3_d04_t05', 'sentence', 'Iya, hidup di Seoul.', '응, 서울에서 살아.', '이야, 히둡 디 세울.', '대화04', 3, '{romance,marriage,korea_move}', 'hidup = 살다', 'Sari 결심 강조', 'id', 'B', 5, '집'),
('id:sent:l3_d04_t06', 'sentence', 'Pikirin matang.', '잘 생각해.', '삐끼린 마땅.', '대화04', 3, '{romance,marriage,korea_move}', 'pikirin = memikirkan 구어, matang = 성숙', '신중 권고', 'id', 'A', 6, '집'),
('id:sent:l3_d04_t07', 'sentence', 'Sudah. Aku siap.', '이미. 준비됨.', '수다. 아꾸 시압.', '대화04', 3, '{romance,marriage,korea_move}', 'siap = 준비된', '확고', 'id', 'B', 7, '집'),
('id:sent:l3_d04_t08', 'sentence', 'Bahasa Korea kamu?', '한국어는?', '바하사 꼬레아 까무?', '대화04', 3, '{romance,marriage,korea_move}', 'bahasa = 언어', '실제 점검', 'id', 'A', 8, '집'),
('id:sent:l3_d04_t09', 'sentence', 'Aku belajar serius dua tahun.', '2년 진지하게 공부.', '아꾸 블라자르 스리우스 두아 따훈.', '대화04', 3, '{romance,marriage,korea_move}', 'belajar = 공부하다', 'Sari 한국어 노력', 'id', 'B', 9, '집'),
('id:sent:l3_d04_t10', 'sentence', 'Keluargamu?', '가족은?', '끌루아르가무?', '대화04', 3, '{romance,marriage,korea_move}', 'keluargamu = keluarga + mu (네)', '', 'id', 'A', 10, '집'),
('id:sent:l3_d04_t11', 'sentence', 'Ibu nangis tapi rela.', '엄마 울었지만 받아들임.', '이부 낭이스 따삐 를라.', '대화04', 3, '{romance,marriage,korea_move}', 'rela = 받아들이다, 기꺼이', '가족 동의', 'id', 'B', 11, '집'),
('id:sent:l3_d04_t12', 'sentence', 'Kerja di sana?', '일은?', '끄르자 디 사나?', '대화04', 3, '{romance,marriage,korea_move}', 'di sana = 거기', '한국 직업', 'id', 'A', 12, '집'),
('id:sent:l3_d04_t13', 'sentence', 'Sebagai barista atau cafe manager.', '바리스타나 카페 매니저.', '스바가이 바리스따 아따우 까페 마네저르.', '대화04', 3, '{romance,marriage,korea_move}', 'sebagai = ~로서', 'Sari 현재 직업 활용', 'id', 'B', 13, '집'),
('id:sent:l3_d04_t14', 'sentence', 'Oke, kita rencanain bareng.', '오케이, 같이 계획.', '오께, 끼따 른짜나인 바릉.', '대화04', 3, '{romance,marriage,korea_move}', 'bareng = 함께 (구어, bersama)', '결심 합의', 'id', 'A', 14, '집'),

-- ============================================================
-- L3 d07 -- 한국 결혼식 (서울, Min-jun 가족, 종교 sensitive) (14턴)
-- 시나리오: 한국 결혼식 전날, Sari 가 Min-jun 에게 시댁·종교 입장 물음
-- 학습 포인트: 정중 saya/anda vs 친근 aku/kamu 구분, hijab, dress, Muslim, oppa
-- 문화: 한남 가족 종교 sensitive, hijab 미착용 결정 (Sari 자유 무슬림),
--       호텔 결혼 (종교 중립), Sari 가 정중 'saya' 사용 (시댁 앞 톤)
-- ============================================================
('id:sent:l3_d07_t01', 'sentence', 'Min-jun, ibumu udah terima aku?', '어머니 받아들였어?', '민준, 이부무 우다 뜨리마 아꾸?', '대화07', 3, '{romance,wedding,korea,family}', 'ibumu = ibu+mu', '한국 결혼식 전', 'id', 'B', 1, '서울 결혼식 전날'),
('id:sent:l3_d07_t02', 'sentence', 'Ibu masih awkward.', '어색해하셔.', '이부 마시 어쿼드.', '대화07', 3, '{romance,wedding,korea,family}', 'awkward = 영어 차용', '한남 가족 적응', 'id', 'A', 2, '집'),
('id:sent:l3_d07_t03', 'sentence', 'Karena saya non-Korea?', '한국인 X 라서?', '까르나 사야 논 꼬레아?', '대화07', 3, '{romance,wedding,korea,family}', 'saya = 정중 1인칭', '시댁 앞 정중 호칭', 'id', 'B', 3, '집'),
('id:sent:l3_d07_t04', 'sentence', 'Bukan, lebih ke agama.', '종교 때문.', '부깐, 르비 끄 아가마.', '대화07', 3, '{romance,wedding,korea,family}', '', '한남 가족 issue', 'id', 'A', 4, '집'),
('id:sent:l3_d07_t05', 'sentence', 'Aku pakai dress aja, nggak hijab.', '드레스만, hijab X.', '아꾸 빠까이 드레스 아자, 응각 히잡.', '대화07', 3, '{romance,wedding,korea,family}', 'dress = 영어 차용', '한국 결혼식 적응 결정', 'id', 'B', 5, '집'),
('id:sent:l3_d07_t06', 'sentence', 'Pinter, biar Ibu nyaman.', '좋아, 엄마 편하게.', '삔뜨르, 비아르 이부 냐만.', '대화07', 3, '{romance,wedding,korea,family}', 'pinter = pintar 구어, nyaman = 편안', '', 'id', 'A', 6, '집'),
('id:sent:l3_d07_t07', 'sentence', 'Tapi aku tetap Muslim ya.', '그래도 무슬림.', '따삐 아꾸 뜨땁 무슬림 야.', '대화07', 3, '{romance,wedding,korea,family}', 'tetap = 여전히', '신앙 정체성 유지', 'id', 'B', 7, '집'),
('id:sent:l3_d07_t08', 'sentence', 'Iya, Ibu juga tahu.', '응, 엄마도 알아.', '이야, 이부 주가 따후.', '대화07', 3, '{romance,wedding,korea,family}', '', '', 'id', 'A', 8, '집'),
('id:sent:l3_d07_t09', 'sentence', 'Vow di gereja?', '서약 교회?', '보우 디 그레자?', '대화07', 3, '{romance,wedding,korea,family}', 'vow = 영어 차용, gereja = 교회', '', 'id', 'B', 9, '집'),
('id:sent:l3_d07_t10', 'sentence', 'Bukan, hotel saja, generic.', '호텔, 일반.', '부깐, 호뗄 사자, 제네릭.', '대화07', 3, '{romance,wedding,korea,family}', 'generic = 영어 차용', '종교 중립 선택', 'id', 'A', 10, '집'),
('id:sent:l3_d07_t11', 'sentence', 'Lega. Aku takut konflik.', '안심. 갈등 무서웠어.', '르가. 아꾸 따꿋 콘플릭.', '대화07', 3, '{romance,wedding,korea,family}', 'lega = 안심, konflik = 갈등', '', 'id', 'B', 11, '집'),
('id:sent:l3_d07_t12', 'sentence', 'Sudah aku jelaskan dulu.', '이미 설명.', '수다 아꾸 즐라스깐 둘루.', '대화07', 3, '{romance,wedding,korea,family}', 'jelaskan = 설명하다', '한남 사전 협상', 'id', 'A', 12, '집'),
('id:sent:l3_d07_t13', 'sentence', 'Makasih, oppa.', '고마워, 오빠.', '마까시, 오빠.', '대화07', 3, '{romance,wedding,korea,family}', 'oppa = 오빠 (한국어 차용)', 'K-pop 영향 한국어 차용', 'id', 'B', 13, '집'),
('id:sent:l3_d07_t14', 'sentence', 'Hari ini bahagia ya.', '오늘 행복하지.', '하리 이니 바하기아 야.', '대화07', 3, '{romance,wedding,korea,family}', 'bahagia = 행복', '', 'id', 'A', 14, '집'),

-- ============================================================
-- L6 d27 -- 호텔 첫 밤 (anonymous, sensual 시작) (10턴)
-- 시나리오: 결혼 첫 밤, 호텔 방, 인티밋 (anonymous A/B -- L3 캐릭터 X)
-- 학습 포인트: pelan-pelan (consent 부드러운 시작), sentuh, lembut, gugup
-- 자극 수위: Google Play 정책 안 sensual -- intimate touch + 부드러운 표현 OK
-- ============================================================
('id:sent:l6_d27_t01', 'sentence', 'Akhirnya cuma kita berdua.', '드디어 우리 둘만.', '아키르냐 쭈마 끼따 브르두아.', '대화27', 6, '{intimate,sensual}', 'akhirnya = 드디어', '신혼 첫 밤', 'id', 'A', 1, '호텔 첫 밤'),
('id:sent:l6_d27_t02', 'sentence', 'Aku gugup sedikit.', '조금 긴장.', '아꾸 구굽 스디낏.', '대화27', 6, '{intimate,sensual}', 'gugup = 긴장', '', 'id', 'B', 2, '호텔 침실'),
('id:sent:l6_d27_t03', 'sentence', 'Jangan terburu-buru.', '서두르지 말고.', '장안 뜨르부루 부루.', '대화27', 6, '{intimate,sensual}', 'reduplication 강조', 'consent 부드러운 시작', 'id', 'A', 3, '호텔'),
('id:sent:l6_d27_t04', 'sentence', 'Pelukan dulu.', '먼저 안아.', '쁠루깐 둘루.', '대화27', 6, '{intimate,sensual}', 'pelukan = 포옹', '', 'id', 'B', 4, '호텔'),
('id:sent:l6_d27_t05', 'sentence', 'Kamu sangat cantik.', '정말 예뻐.', '까무 상앗 짠띡.', '대화27', 6, '{intimate,sensual}', 'sangat = 매우', '칭찬', 'id', 'A', 5, '호텔'),
('id:sent:l6_d27_t06', 'sentence', 'Kamu juga.', '당신도.', '까무 주가.', '대화27', 6, '{intimate,sensual}', '', '', 'id', 'B', 6, '호텔'),
('id:sent:l6_d27_t07', 'sentence', 'Aku matikan lampu?', '불 끌까?', '아꾸 마띠깐 람뿌?', '대화27', 6, '{intimate,sensual}', 'matikan = 끄다, lampu = 등', '', 'id', 'A', 7, '호텔'),
('id:sent:l6_d27_t08', 'sentence', 'Iya, sedikit redup.', '응, 조금 어둡게.', '이야, 스디낏 르둡.', '대화27', 6, '{intimate,sensual}', 'redup = 어둡다', '', 'id', 'B', 8, '호텔'),
('id:sent:l6_d27_t09', 'sentence', 'Pakai musik soft.', '부드러운 음악.', '빠까이 무식 소프트.', '대화27', 6, '{intimate,sensual}', 'soft = 영어 차용', '분위기', 'id', 'A', 9, '호텔'),
('id:sent:l6_d27_t10', 'sentence', 'Sentuhmu lembut.', '네 손길 부드러워.', '슨뚜무 름붓.', '대화27', 6, '{intimate,sensual}', 'sentuh = 만지다, lembut = 부드러운', 'sensual 표현', 'id', 'B', 10, '호텔'),

-- ============================================================
-- L6 d29 -- 첫 키스 카페 후 (anonymous, sensual tension) (10턴)
-- 시나리오: 데이트 후 카페·공원, 첫 키스 순간
-- 학습 포인트: cium (키스), Bisa aku cium? (consent 명시 핵심), bibir, manis
-- 자극 수위: consent 명시 + 부드러운 sensual (Google 안전)
-- ============================================================
('id:sent:l6_d29_t01', 'sentence', 'Hari ini menyenangkan.', '오늘 즐거웠어.', '하리 이니 므녀낭깐.', '대화29', 6, '{intimate,first_kiss,sensual}', 'menyenangkan = 즐거운', '데이트 후', 'id', 'A', 1, '공원 -- 첫 키스'),
('id:sent:l6_d29_t02', 'sentence', 'Belum mau pulang.', '아직 안 가.', '블룸 마우 뿔랑.', '대화29', 6, '{intimate,first_kiss,sensual}', '', '', 'id', 'B', 2, '카페 앞'),
('id:sent:l6_d29_t03', 'sentence', 'Mampir minum lagi?', '한 잔 더?', '맘삐르 미눔 라기?', '대화29', 6, '{intimate,first_kiss,sensual}', 'mampir = 들르다', '', 'id', 'A', 3, '카페 앞'),
('id:sent:l6_d29_t04', 'sentence', 'Atau jalan kaki di taman.', '공원 산책.', '아따우 잘란 까끼 디 따만.', '대화29', 6, '{intimate,first_kiss,sensual}', 'taman = 공원', '', 'id', 'B', 4, '공원'),
('id:sent:l6_d29_t05', 'sentence', 'Aku ingin sesuatu.', '뭔가 원해.', '아꾸 잉인 스수아뚜.', '대화29', 6, '{intimate,first_kiss,sensual}', 'ingin = 원하다, sesuatu = 무엇', 'tension', 'id', 'A', 5, '공원'),
('id:sent:l6_d29_t06', 'sentence', 'Apa?', '뭐?', '아빠?', '대화29', 6, '{intimate,first_kiss,sensual}', '', '', 'id', 'B', 6, '공원'),
('id:sent:l6_d29_t07', 'sentence', 'Bisa aku cium?', '키스해도?', '비사 아꾸 찌움?', '대화29', 6, '{intimate,first_kiss,sensual}', 'cium = 키스', 'consent 명시 핵심', 'id', 'A', 7, '공원'),
('id:sent:l6_d29_t08', 'sentence', 'Pelan ya...', '천천히...', '쁠란 야...', '대화29', 6, '{intimate,first_kiss,sensual}', '', 'consent 부드러운 동의', 'id', 'B', 8, '공원'),
('id:sent:l6_d29_t09', 'sentence', 'Bibirmu manis.', '입술 달콤.', '비비르무 마니스.', '대화29', 6, '{intimate,first_kiss,sensual}', 'bibir = 입술, manis = 달콤', '키스 후 표현', 'id', 'A', 9, '공원'),
('id:sent:l6_d29_t10', 'sentence', 'Sekali lagi.', '한 번 더.', '스깔리 라기.', '대화29', 6, '{intimate,first_kiss,sensual}', '', '', 'id', 'B', 10, '공원'),

-- ============================================================
-- L6 d36 -- 결혼 1주년 sweet (Sari x Min-jun arc cross) (14턴)
-- 시나리오: 결혼 1주년, 사진 앨범 + 두 번째 반지 + 약속 갱신
-- 학습 포인트: oppa, hadiah, cincin, simbol selamanya, sweet talk
-- 캐릭터 cross 정책: 사용자 명시 "일부 dial 만 cross OK" -- 본 dial 만 적용
-- 자극 수위: sweet (intimate touch X, 감정 깊이 ↑)
-- ============================================================
('id:sent:l6_d36_t01', 'sentence', 'Hari ini setahun, oppa.', '오빠, 오늘 1년.', '하리 이니 스따훈, 오빠.', '대화36', 6, '{intimate,anniversary,sweet_talk}', 'oppa = 오빠 (한국어 차용)', 'Sari x Min-jun arc 후속', 'id', 'B', 1, '결혼 1주년'),
('id:sent:l6_d36_t02', 'sentence', 'Cepat banget.', '빠르네.', '쯔빳 방엣.', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', '', 'id', 'A', 2, '집'),
('id:sent:l6_d36_t03', 'sentence', 'Aku punya hadiah.', '선물.', '아꾸 뿐야 하디아.', '대화36', 6, '{intimate,anniversary,sweet_talk}', 'hadiah = 선물', '', 'id', 'B', 3, '집'),
('id:sent:l6_d36_t04', 'sentence', 'Apa?', '뭐?', '아빠?', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', '', 'id', 'A', 4, '집'),
('id:sent:l6_d36_t05', 'sentence', 'Album foto kita setahun ini.', '1년 사진 앨범.', '알붐 포또 끼따 스따훈 이니.', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', 'sentimental 선물', 'id', 'B', 5, '집'),
('id:sent:l6_d36_t06', 'sentence', 'Wah, romantis banget.', '로맨틱.', '와, 로맨띠스 방엣.', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', '', 'id', 'A', 6, '집'),
('id:sent:l6_d36_t07', 'sentence', 'Setiap halaman cerita.', '각 페이지 이야기.', '스띠압 할라만 쩨리따.', '대화36', 6, '{intimate,anniversary,sweet_talk}', 'halaman = 페이지', '', 'id', 'B', 7, '집'),
('id:sent:l6_d36_t08', 'sentence', 'Aku juga punya untuk kamu.', '나도 있어.', '아꾸 주가 뿐야 운뚝 까무.', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', '', 'id', 'A', 8, '집'),
('id:sent:l6_d36_t09', 'sentence', 'Apa?', '뭐?', '아빠?', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', '', 'id', 'B', 9, '집'),
('id:sent:l6_d36_t10', 'sentence', 'Cincin kedua, simbol selamanya.', '두 번째 반지, 영원.', '찐찐 끄두아, 심볼 슬라마냐.', '대화36', 6, '{intimate,anniversary,sweet_talk}', 'cincin = 반지, selamanya = 영원히', 'arc 심화', 'id', 'A', 10, '집'),
('id:sent:l6_d36_t11', 'sentence', 'Aku menangis.', '울어.', '아꾸 므낭이스.', '대화36', 6, '{intimate,anniversary,sweet_talk}', 'menangis = 울다', '', 'id', 'B', 11, '집'),
('id:sent:l6_d36_t12', 'sentence', 'Air mata bahagia.', '행복 눈물.', '아이르 마따 바하기아.', '대화36', 6, '{intimate,anniversary,sweet_talk}', 'air mata = 눈물', '', 'id', 'A', 12, '집'),
('id:sent:l6_d36_t13', 'sentence', 'Kita selalu seperti ini ya.', '이렇게 늘.', '끼따 슬랄루 스쁘르띠 이니 야.', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', '', 'id', 'B', 13, '집'),
('id:sent:l6_d36_t14', 'sentence', 'Aku janji.', '약속.', '아꾸 잔지.', '대화36', 6, '{intimate,anniversary,sweet_talk}', '', 'sweet 마무리', 'id', 'A', 14, '집');

-- ============================================================
-- 검수 끝. 검수 가이드: docs/_id_review_session_brief.md
-- 합계: 6 dialogue / 68 turns
-- ============================================================
