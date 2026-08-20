import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'my_alphabet_combinations_screen.dart';
import 'my_alphabet_consonants_screen.dart';
import 'my_alphabet_tones_screen.dart';
import 'my_alphabet_vowels_screen.dart';

/// 미얀마 알파벳 학습 메뉴 — 자음 / 모음 / 톤 / 결합 4 sub menu.
///
/// LTR (왼쪽→오른쪽). AR 알파벳 화면 (`ArAlphabetScreen`) 구조 참고하되
/// 미얀마는 RTL 이 아니므로 Directionality.ltr.
///
/// Pali 회색 처리 정책:
///   - is_pali_only=true 글자 → #9E9E9E (회색)
///   - 자음 화면 하단 disclaimer "회색 = Pali 전용 (외우지 X)"
class MyAlphabetScreen extends StatelessWidget {
  const MyAlphabetScreen({super.key});

  static const _myBrand = Color(0xFF5E35B1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🔤 미얀마 알파벳'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _SubMenuCard(
              icon: '🔤',
              titleKo: '자음',
              titleMy: 'ဗျည်း',
              subtitle: '33자 (Pali 전용 7 + Pali origin 4 회색)',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MyAlphabetConsonantsScreen(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _SubMenuCard(
              icon: '🔡',
              titleKo: '모음',
              titleMy: 'သရ',
              subtitle: '부호 12 + 독립 7',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MyAlphabetVowelsScreen(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _SubMenuCard(
              icon: '🎵',
              titleKo: '톤 (성조)',
              titleMy: 'အသံ',
              subtitle: '4성조 (low · high · creaky · checked)',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MyAlphabetTonesScreen(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _SubMenuCard(
              icon: '🔗',
              titleKo: '결합 규칙',
              titleMy: 'ပူးတွဲ',
              subtitle: '4 medial signs + stacking',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MyAlphabetCombinationsScreen(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLearningPath(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _myBrand.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _myBrand.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'မြန်မာ အက္ခရာ',
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _myBrand,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mon-Burmese script · Unicode 표준',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '회색 글자는 Pali (불교 경전·법률·격식) 전용입니다.\n외우지 마세요. 일상 미얀마어 회화에 거의 등장하지 않습니다.',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningPath() {
    final steps = [
      ('1', '자음 ka·pa·ma·na·ta 그룹 (10자)', '15분'),
      ('2', '모음 부호 ာ ိ ု ေ ို (5개)', '10분'),
      ('3', '결합 ya pin ျ + wa hswe ွ', '10분'),
      ('4', '톤 4종 비교 (ka 계열)', '12분'),
      ('5', '나머지 자음 + 모음 점진 확장', '30분'),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline, size: 16, color: _myBrand),
              const SizedBox(width: 6),
              Text(
                '추천 학습 경로',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _myBrand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...steps.map((s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _myBrand.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        s.$1,
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _myBrand,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.$2,
                        style: GoogleFonts.notoSans(fontSize: 12.5),
                      ),
                    ),
                    Text(
                      s.$3,
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          Text(
            '한 번에 외우지 마세요. 5개씩 끊어서 진행하면 부담이 적습니다.',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubMenuCard extends StatelessWidget {
  final String icon;
  final String titleKo;
  final String titleMy;
  final String subtitle;
  final VoidCallback onTap;

  const _SubMenuCard({
    required this.icon,
    required this.titleKo,
    required this.titleMy,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: MyAlphabetScreen._myBrand.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        titleKo,
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        titleMy,
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: MyAlphabetScreen._myBrand,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
