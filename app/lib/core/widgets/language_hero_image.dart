import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/language_registry.dart';
import '../theme/app_colors.dart';

/// 홈 상단 히어로 — 모든 언어가 `assets/branding/icon.png` 공용 베이스를 쓰고,
/// 4시30분 자리의 말풍선에 그 언어의 [uniqueAlphabet] 을 덮어씌움.
///
/// 원 이미지의 "Ж" 말풍선 위에 불투명 흰색 캡슐을 깔아 완전히 가리고,
/// 그 위에 현재 언어의 문자를 얹는 구조. 러시아어도 동일하게 "Ж" 을 다시
/// 얹어 시각적 일관성 유지.
class LanguageHeroImage extends StatelessWidget {
  final double size;
  const LanguageHeroImage({super.key, this.size = 140});

  static const Color _lineColor = Color(0xFF1B2968); // icon.png 원본 네이비와 근사

  @override
  Widget build(BuildContext context) {
    final letter = LanguageRegistry.current.uniqueAlphabet;
    // icon.png 안 4:30 말풍선은 대략 오른쪽 가장자리 근처, 세로 중간 약간 아래.
    // 아래 %값은 실측 근사. icon.png 교체 시 이 비율만 조정하면 됨.
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/branding/icon.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: size * 0.02,
            top: size * 0.50,
            child: Container(
              width: size * 0.40,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.1),
                border: Border.all(color: _lineColor, width: size * 0.012),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  letter,
                  style: GoogleFonts.notoSans(
                    color: _lineColor,
                    fontWeight: FontWeight.w900,
                    fontSize: size * 0.13,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 폴백 단색 버전 (PNG 로드 실패 시) — 만일을 위해 유지.
  @visibleForTesting
  Widget fallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.textPrimary, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        LanguageRegistry.current.uniqueAlphabet,
        style: GoogleFonts.notoSans(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
