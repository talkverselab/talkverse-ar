-- ============================================================
-- MY 검수용 샘플 SQL (L2 d10 보고싶다 + L6 d01 intimate)
-- 28 turns / 2 dialogues — 회화 톤 / 자극 수위 sample
-- 검수 brief: docs/_my_review_session_brief.md 참조
-- ============================================================

-- === L2 d10: 보고 싶다 (Min-jun × Su Su, 카톡, romance milestone) ===
('my:sent:l2_d10_t01', 'sentence', 'ဆုဆု။ အခု ဘာလုပ်နေတာလဲ။', '수수. 지금 뭐 해?', 'su-su. a-khu ba louk-nay-da lè / 수수. 아쿠 바 로욱네타 레', 'd10', 2, '{new,l2,question,male-speaker}', '', '', 'my', 'A', 1, 'L2 d10 — 보고 싶다 milestone', '[]'::jsonb)
('my:sent:l2_d10_t02', 'sentence', 'အိမ်မှာ စာကြည့်နေတယ်။', '집에서 책 보고 있어.', 'ein-hma sa kyi-nay-de / 에잉마 사 찌네데', 'd10', 2, '{new,l2,female-speaker,activity}', 'L1 စာ reuse', '', 'my', 'B', 2, '활동', '[]'::jsonb)
('my:sent:l2_d10_t03', 'sentence', 'ကျွန်တော် ဆုဆုကို တွေ့ချင်တယ်။', '나 수수 보고 싶어.', 'kya-naw su-su go twe-chin tè / 짜노 수수 고 트웨친 떼', 'd10', 2, '{new,l2,male-speaker,romance,key-phrase}', 'L1 d11 ချင် reuse. 핵심 표현', '핵심 romance milestone', 'my', 'A', 3, '감정', '[{"w":"တွေ့ချင်","ko":"보고 싶다"}]'::jsonb)
('my:sent:l2_d10_t04', 'sentence', 'ဟယ်။ ကျွန်မလည်း တွေ့ချင်တယ်။', '아. 나도 보고 싶어.', 'hè. kya-ma le-de twe-chin tè / 헤. 짜마 레데 트웨친 떼', 'd10', 2, '{new,l2,female-speaker,romance,reciprocate}', '', '', 'my', 'B', 4, '감정', '[]'::jsonb)
('my:sent:l2_d10_t05', 'sentence', 'အလုပ်ပြီးလို့ ဘယ်တော့ တွေ့ရမလဲ။', '일 끝나고 언제 만날 수 있을까?', 'a-louk pyi-lo bal-daw twe-ya-ma lè / 알로욱 삐로 발도 트웨야마 레', 'd10', 2, '{new,l2,question,male-speaker}', 'ဘယ်တော့ = 언제', '', 'my', 'A', 5, '약속', '[{"w":"ဘယ်တော့","ko":"언제"}]'::jsonb)
('my:sent:l2_d10_t06', 'sentence', 'မနက်ဖြန်ည ဘယ်လိုလဲ။', '내일 저녁 어때?', 'ma-net-pyan-nya bal-lo lè / 마넷퍙냐 발로 레', 'd10', 2, '{new,l2,proposal,female-speaker}', '', '', 'my', 'B', 6, '제안', '[]'::jsonb)
('my:sent:l2_d10_t07', 'sentence', 'ကောင်းတယ်။ ၇ နာရီ။', '좋아. 7시.', 'kaung-tè. khu-na-na-yi / 까웅떼. 쿤하나이', 'd10', 2, '{new,l2,male-speaker}', '', '', 'my', 'A', 7, '확정', '[]'::jsonb)
('my:sent:l2_d10_t08', 'sentence', 'အစားအသောက် ဘာစားကြမလဲ။', '뭐 먹을까?', 'a-sa-a-thauk ba sa-kya-ma lè / 아사아따욱 바 사짜마 레', 'd10', 2, '{new,l2,question,female-speaker}', 'L1 + အသောက် = 음식', '', 'my', 'B', 8, '음식', '[]'::jsonb)
('my:sent:l2_d10_t09', 'sentence', 'ဆုဆု ကြိုက်တာစားကြမယ်။', '수수가 좋아하는 거 먹자.', 'su-su kyaik-da sa-kya-mè / 수수 짜익타 사짜메', 'd10', 2, '{new,l2,male-speaker,kind}', '', '', 'my', 'A', 9, '제안', '[]'::jsonb)
('my:sent:l2_d10_t10', 'sentence', 'ဟာ။ ကိုရီးယားဆိုင် သွားကြမယ်။', '음. 한국 음식점 가자.', 'ha. ko-ri-ya sain thwa-kya-mè / 하. 꼬리야 사인 똬짜메', 'd10', 2, '{new,l2,female-speaker,korean-food}', 'ဆိုင် = 가게·식당', '', 'my', 'B', 10, '제안', '[{"w":"ဆိုင်","ko":"가게·식당"}]'::jsonb)
('my:sent:l2_d10_t11', 'sentence', 'ရပါပြီ။ Insein လမ်းမှာ ရှိတယ်။', '좋아. Insein 거리에 있어.', 'ya-ba-bi. Insein lan-hma shi-de / 야 바비. 인세인 란마 시데', 'd10', 2, '{new,l2,male-speaker,location}', 'လမ်း = 길', '', 'my', 'A', 11, '위치', '[{"w":"လမ်း","ko":"길"}]'::jsonb)
('my:sent:l2_d10_t12', 'sentence', 'ဟုတ်ပါ။ မနက်ဖြန် တွေ့မယ်။', '응. 내일 봐.', 'hote-ba. ma-net-pyan twe-mè / 호우바. 마넷퍙 트웨메', 'd10', 2, '{new,l2,female-speaker}', '', '', 'my', 'B', 12, '확정', '[]'::jsonb)
('my:sent:l2_d10_t13', 'sentence', 'အင်း။ တွေ့ဖို့ ရင်ခုန်တယ်။', '응. 만나는 게 설레.', 'in. twe-bo yin-khone tè / 인. 트웨보 인콘떼', 'd10', 2, '{new,l2,male-speaker,romance}', 'L1 ရင်ခုန် reuse', '', 'my', 'A', 13, '감정', '[]'::jsonb)
('my:sent:l2_d10_t14', 'sentence', 'ကျွန်မလည်းပေါ့။ အိပ်တော့မယ်နော်။', '나도. 잘게.', 'kya-ma le-de paw. eik daw-mè naw / 짜마 레데 포. 에익 도메 노', 'd10', 2, '{new,l2,female-speaker}', '', '', 'my', 'B', 14, '작별', '[]'::jsonb)

-- === L6 d01: intimate — 재훈×따자 (결혼 5년, 출장 6주 후 재회) ===
-- Decision 39 가드레일: consent · 21+ · 상업 X. Google Play 17+ 한도
('my:sent:l6_d01_t01', 'sentence', 'အိမ်ပြန်ရောက်ပြီ ။ ၆ ပတ်ကြာသွားတယ်။', '집 왔어. 6주 만이야.', 'ein pyan yauk-bi. chauk-pat kya thwa-de / 에잉 퍙 야웃비. 차웃팟 짜 똬데', 'd01_intimate', 6, '{new,l6,intimate,male-speaker,couple-A,21+}', '재훈 (한국 IT 주재원 30대)', '', 'my', 'A1', 1, 'L6 d01 — 재훈×따자 재회', '[]'::jsonb)
('my:sent:l6_d01_t02', 'sentence', 'အို ဇေးဟွန် ။ မငို နဲ့လား။', '아 재훈. 안 울어?', 'oh Jae-hoon. ma-ngo nè la / 오 재훈. 마응오 네 라', 'd01_intimate', 6, '{new,l6,intimate,female-speaker,couple-A}', '따자 (미얀마 통역사 28)', '', 'my', 'B1', 2, '감정', '[]'::jsonb)
('my:sent:l6_d01_t03', 'sentence', 'ဖက်ခွင့် ပေးပါ။ ပင်ပန်းနေတယ်။', '안아줘. 지쳤어.', 'pet khwin pay ba. pin-pan nay tè / 펫 콴 빼 바. 삔빤 네 떼', 'd01_intimate', 6, '{new,l6,intimate,male-speaker,vulnerable}', 'L3 ဖက် reuse', '', 'my', 'A1', 3, '감정', '[]'::jsonb)
('my:sent:l6_d01_t04', 'sentence', 'လာ။ နဖူးကို ထိ။', '와. 이마 대.', 'la. na-pu go hti / 라. 나뿌 고 티', 'd01_intimate', 6, '{new,l6,intimate,female-speaker}', 'နဖူး = 이마. ထိ = 닿다', 'L6 — 신체 친밀', 'my', 'B1', 4, '친밀', '[{"w":"နဖူး","ko":"이마"},{"w":"ထိ","ko":"닿다"}]'::jsonb)
('my:sent:l6_d01_t05', 'sentence', 'အို ။ နွေးထွေးတယ်။', '아. 따스해.', 'oh. nway-htway tè / 오. 눼퉤 떼', 'd01_intimate', 6, '{new,l6,intimate,male-speaker}', 'L3 d13 reuse', '', 'my', 'A1', 5, '감각', '[]'::jsonb)
('my:sent:l6_d01_t06', 'sentence', 'ဇေးဟွန် ။ မင်းကို လိုချင်တယ်။', '재훈. 너를 원해.', 'Jae-hoon. min go lo-chin tè / 재훈. 민 고 로친 떼', 'd01_intimate', 6, '{new,l6,intimate,female-speaker,desire,advanced}', 'မင်း = 너 (친근)', 'L6 — 욕망 직접', 'my', 'B1', 6, '욕망', '[{"w":"မင်း","ko":"너 (친근)"}]'::jsonb)
('my:sent:l6_d01_t07', 'sentence', 'ငါလည်း မင်းကို မမြင်ရတဲ့ ည တွေ ။ အိပ်လို့မရဘူး။', '나도. 너 못 보는 밤. 잠 안 와.', 'nga le-de min go ma-myin-ya-tè nya dway. eik-lo ma-ya bu / 응아 레데 민 고 마민야떼 냐 뒈. 에익로 마야 부', 'd01_intimate', 6, '{new,l6,intimate,male-speaker,advanced}', 'ငါ = 나 (친근)', 'L6 — 그리움', 'my', 'A1', 7, '갈망', '[{"w":"ငါ","ko":"나 (친근)"}]'::jsonb)
('my:sent:l6_d01_t08', 'sentence', 'အို ။ နှုတ်ခမ်း ။ နီးစေ။', '아. 입술. 가까이.', 'oh. hnote-khan. ni zay / 오. 흐누앗칸. 니 제', 'd01_intimate', 6, '{new,l6,intimate,female-speaker,suggestive,advanced}', 'နှုတ်ခမ်း = 입술', 'L6 — 키스 직전', 'my', 'B1', 8, 'intimate', '[{"w":"နှုတ်ခမ်း","ko":"입술"}]'::jsonb)
('my:sent:l6_d01_t09', 'sentence', '— ။ နှုတ်ခမ်းချင်း ထိတွေ့ —', '— 입술 닿음 —', '— scene —', 'd01_intimate', 6, '{new,l6,scene,kiss}', '키스 장면', 'L6 — tasteful', 'my', '-', 9, '장면', '[]'::jsonb)
('my:sent:l6_d01_t10', 'sentence', 'ဇေးဟွန် ။ မခွဲခွာဖို့ ။ ဂတိ ပေး။', '재훈. 떠나지 마. 약속해.', 'Jae-hoon. ma-khwè-khwa bo. ga-ti pay / 재훈. 마퀘콰 보. 가띠 빼', 'd01_intimate', 6, '{new,l6,intimate,female-speaker,vulnerable,advanced}', 'ခွဲခွာ = 헤어지다', '', 'my', 'B1', 10, '약속', '[{"w":"ခွဲခွာ","ko":"헤어지다"}]'::jsonb)
('my:sent:l6_d01_t11', 'sentence', 'ဂတိ ပေးတယ်။ ဘယ်တော့မှ မခွဲခွာဘူး။', '약속해. 절대 안 떠나.', 'ga-ti pay tè. bal-daw-hma ma-khwè-khwa bu / 가띠 빼 떼. 발도흐마 마퀘콰 부', 'd01_intimate', 6, '{new,l6,intimate,male-speaker,promise,advanced}', '', '', 'my', 'A1', 11, '약속', '[]'::jsonb)
('my:sent:l6_d01_t12', 'sentence', 'အို ။ မင်းရဲ့ လက် ။ အိမ်ထဲက ။', '아. 너 손. 집 안에.', 'oh. min yè let. ein de-ka / 오. 민 예 렛. 에잉 데카', 'd01_intimate', 6, '{new,l6,intimate,female-speaker,suggestive,advanced}', 'L2 လက် reuse', 'L6 — touch (suggestive)', 'my', 'B1', 12, 'intimate', '[]'::jsonb)
('my:sent:l6_d01_t13', 'sentence', 'အလင်းတွေ ။ ပိတ်လိုက်မယ်။', '불. 끌게.', 'a-lin dway. pait laik mè / 알린 뒈. 빠잇 라잇 메', 'd01_intimate', 6, '{new,l6,intimate,male-speaker,suggestive,advanced}', 'အလင်း = 불·빛', 'L6 — 분위기', 'my', 'A1', 13, 'intimate', '[{"w":"အလင်း","ko":"불·빛"}]'::jsonb)
('my:sent:l6_d01_t14', 'sentence', 'အင်း ။ ပိတ်လိုက်ပါ ။ ဇေးဟွန် ။', '응. 꺼. 재훈.', 'in. pait laik ba. Jae-hoon / 인. 빠잇 라잇 바. 재훈', 'd01_intimate', 6, '{new,l6,intimate,female-speaker,consent,advanced}', '', 'L6 — explicit consent', 'my', 'B1', 14, 'intimate', '[]'::jsonb)
