import 'package:flutter/material.dart';

/// 앱 전역 팔레트. 톤 방향성: **심플 + 전문 + 약간 따뜻**.
///
/// - 배경은 순백 유지(심플)하되 surface/border는 크림 톤으로 소폭 shift.
/// - 텍스트 primary는 인디고 블랙 계열 — 스플래시 라인아트와 동일 가족.
/// - 브랜드 컬러는 언어별 override (brand{Code}). 기본 fallback은 brandDefault.
class AppColors {
  AppColors._();

  // ---------------- 아랍풍 팔레트 (2026-08 UX 개편) ----------------
  // 主色 녹색(이슬람 전통·국기), 副色 금(모스크 문양·서예 장식),
  // 배경 상아색 종이, 텍스트 먹색, 보조 테라코타(사막·흙).
  static const arGreen = Color(0xFF0D5C3F);
  static const arGreenDeep = Color(0xFF073F2B);
  static const arGreenLight = Color(0xFF2F8A63);
  static const arGold = Color(0xFFC9A227);
  static const arGoldBright = Color(0xFFE9C65A);
  static const arGoldDeep = Color(0xFF8A6D12);
  static const arIvory = Color(0xFFFBF6EA);
  static const arIvoryDeep = Color(0xFFF0E6CF);
  static const arInk = Color(0xFF1F1B17);
  static const arInkLight = Color(0xFF5C544A);
  static const arTerracotta = Color(0xFFB5543A);
  static const arTurquoise = Color(0xFF1E8A8A);
  static const arIndigo = Color(0xFF2E3A8C);

  // ---------------- 표면 (surface) ----------------
  static const background = Color(0xFFFBF6EA); // 상아(ivory) 종이
  static const surface = Color(0xFFF3EAD6); // 모래빛 크림
  static const cardBorder = Color(0xFFD9C48A); // 금빛 테두리
  static const divider = Color(0xFFD9C48A);

  // ---------------- 텍스트 ----------------
  static const textPrimary = Color(0xFF1F1B17); // 먹(ink) 블랙
  static const textSecondary = Color(0xFF5C544A);
  static const textMuted = Color(0xFF9A8F80);

  // ---------------- 시맨틱 팔레트 (신규 디자인) ----------------
  // 일부 화면(chat_dialogue_*, app_info, hero_card, weekly_strip)이 쓰는
  // bg/ink/sage/coral/peach 스케일. 기존 cream/warm 미감에 맞춰 정의.
  // bg: 배경 3단계, ink: 텍스트 3단계.
  static const bg = Color(0xFFFBF6EA);
  static const bgSoft = Color(0xFFF3EAD6);
  static const bgDeep = Color(0xFFE7DAB9);
  static const ink = Color(0xFF1F1B17);
  static const inkSoft = Color(0xFF5C544A);
  static const inkFaint = Color(0xFF9A8F80);
  // sage: 차분한 그린 액센트 스케일 (200 밝음 → 700 깊음)
  static const sage200 = Color(0xFFD7E4D2);
  static const sage300 = Color(0xFFBBD0B2);
  static const sage400 = Color(0xFF93B488);
  static const sage500 = Color(0xFF6E9A63);
  static const sage700 = Color(0xFF3F6B36);
  // coral: 따뜻한 산호 액센트
  static const coral300 = Color(0xFFF6B4A6);
  static const coral500 = Color(0xFFE5715A);
  // peach: 복숭아 액센트
  static const peach300 = Color(0xFFFAD9B8);
  static const peach400 = Color(0xFFF6C28E);
  static const peach600 = Color(0xFFE89B4C);

  // ---------------- 상태/시맨틱 (Duolingo 계열 유지) ----------------
  static const primaryBlue = Color(0xFF1CB0F6);
  static const primaryBlueDark = Color(0xFF0091D5);
  static const success = Color(0xFF58CC02);
  static const successDark = Color(0xFF46A302);
  static const danger = Color(0xFFFF4B4B);
  static const dangerDark = Color(0xFFDC2A2A);
  static const warning = Color(0xFFFFC800);
  static const purple = Color(0xFFCE82FF);
  static const purpleDark = Color(0xFF8549BA);

  // "새 단어" 표시용. 초록 계열로 통일 (2026-04 요구).
  static const newHighlight = Color(0xFFC8E6C9);
  static const newHighlightBorder = Color(0xFF388E3C);

  // ---------------- Midnight Lounge (L6) ----------------
  // 버건디 컬러 (2026-04-25 Gemini 제안 반영). 19+ 게이트 카드·허브 UI에 사용.
  static const midnightBurgundy = Color(0xFF722F37);
  static const midnightBurgundyDark = Color(0xFF5A1E26);

  // ---------------- 언어별 브랜드 컬러 ----------------
  // 각 국가의 대표 색(국기·전통)을 톤다운해 앱의 전문적 느낌에 맞춤.
  // ColorScheme.fromSeed 가 이 컬러를 시드로 M3 팔레트를 파생 생성.
  static const brandDefault = Color(0xFF1565C0); // fallback (Material Blue 800)

  static const brandZh = Color(0xFFC8102E); // 중국 국기 빨강 (심플·묵직)
  static const brandJa = Color(0xFFA80B27); // 일본 일장기 — 깊은 크림슨
  static const brandKo = Color(0xFF12355B); // 태극기 남색
  static const brandRu = Color(0xFF0032A0); // 러시아 국기 파랑 (흰·파·빨 중 메인)
  static const brandTh = Color(0xFF2D2A4A); // 태국 국기 네이비
  static const brandVi = Color(0xFFB11E1E); // 베트남 국기 빨강 톤다운
  static const brandEs = Color(0xFFAA151B); // 스페인 왕실 빨강
  static const brandEn = Color(0xFF012169); // 영국 네이비
  static const brandFr = Color(0xFF1B3A8C); // 프랑스 국기 파랑
  static const brandMn = Color(0xFF0066B3); // 몽골 국기 파랑
  static const brandAr = Color(0xFF0D5C3F); // 아랍 녹색 (주색, 아래 ArPalette 참조)
  static const brandFa = Color(0xFF1B6B3A); // 이란 녹색
  static const brandMy = Color(0xFF2E8B3C); // 미얀마 국기 녹색
  static const brandId = Color(0xFFA51C30); // 인도네시아 국기 빨강
  static const brandDe = Color(0xFF1A1A1A); // 독일 국기 검정 (검·빨·금 중 안정 톤)
  static const brandTr = Color(0xFFB31515); // 터키 국기 빨강 (톤다운)
  static const brandPl = Color(0xFFB91426); // 폴란드 국기 빨강 (톤다운)
  static const brandKk = Color(0xFF00A1C9); // 카자흐 국기 하늘색
  // 부록 언어 (직접 선택 X, 부모 언어의 코스 선택 화면에서 진입).
  static const brandMs = Color(0xFF010066); // 말레이시아 국기 캔턴 블루 (id 부록)
  static const brandLo = Color(0xFF1B4F8C); // 라오스 국기 네이비 (th 부록, Decision 32)
  static const brandPt = Color(0xFF1F6E3F); // 브라질 국기 녹색 톤다운 (es 부록, BR 기본 + PT 토글)
}
