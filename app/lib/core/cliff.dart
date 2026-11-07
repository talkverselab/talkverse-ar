/// 이집트 구어 절벽 값(레마 기준, 2026-11-03 산출) — 화면·앱 소개가 모두 여기를 쓴다.
/// 누적 55/60/70/80% 에 처음 닿는 순위가 R1~R4 의 끝, 그 뒤는 R5. R5 는 2,000위에서 끊음(누적 91.7%).
const List<int> kWordCliffs = [68, 101, 216, 512];
const int kWordCap = 2000;
const double kWordCapPct = 91.7;
const int kWordUnit = 20;
