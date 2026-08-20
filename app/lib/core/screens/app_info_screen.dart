import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../widgets/tone_curve.dart';

/// 앱 설명문 — 사용자 결정 2026-05-09: 메뉴 마지막에 신규.
/// 여러 꼭지(섹션) 모음 — 내용은 조금씩 채울 예정. 순서도 후속 조정.
class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('📖 앱 설명문'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.notoSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionCard(
            emoji: '🎯',
            title: '학술 기반 성조 표시',
            color: AppColors.sage500,
            child: _AcademicTonesSection(),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            emoji: '🗣️',
            title: '북부·남부 발음 차이',
            color: AppColors.coral500,
            child: Text(
              '내용 추가 예정 — 6 성조(북부) vs 5 성조(남부, hỏi/ngã 통합), '
              'd/r/s 등 자음 발음 차이.',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            emoji: '👥',
            title: '호칭 (anh / em / chị)',
            color: AppColors.purpleDark,
            child: Text(
              '내용 추가 예정 — 베트남어 대화에서 가장 중요한 호칭 시스템 안내. '
              '나이·성별·관계에 따른 anh/em/chị/ông/bà 사용 규칙.',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            emoji: '⏱️',
            title: '학습 흐름 추천',
            color: const Color(0xFFB35F00),
            child: Text(
              '내용 추가 예정 — 알파벳 → 6 성조 → 기초 회화 → 채팅 → 비즈니스 순서, '
              '하루 학습 시간 권장량 등.',
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final Color color;
  final Widget child;
  const _SectionCard({
    required this.emoji,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSoft,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.85),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            offset: const Offset(0, 8),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _AcademicTonesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '베트남어 6 성조의 높이는 본 앱에서 학술 데이터(University of Maryland · '
          'Brunelle · Nguyen & Edmondson)를 기반으로 정규화해서 표시합니다. '
          'ngang을 100 기준으로 다른 톤의 시작·중간·끝 pitch를 정확히 반영했어요.',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            color: AppColors.textPrimary,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 14),
        // 학술 차트 미니 미리보기
        const ToneComparisonChart(dialect: 'north', height: 180),
        const SizedBox(height: 10),
        Text(
          '• ngang = 100 기준선 (점선)\n'
          '• ✂ 표시 = 글로탈 스톱(성대 닫힘) 위치 — nặng / ngã\n'
          '• 직선 + 시작점 숫자 라벨로 음 높이 변화 명확히 표현',
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
