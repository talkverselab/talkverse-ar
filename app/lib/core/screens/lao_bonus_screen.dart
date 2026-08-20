import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/language_registry.dart';
import '../data/word_data.dart';
import '../models/word.dart';
import '../theme/app_colors.dart';
import 'adult_hub_screen.dart';
import 'conversation_screen.dart';
import 'flashcard_screen.dart';
import 'keyboard_screen.dart';

/// 부록 언어(예: 라오어) 보너스 챕터 진입 화면.
///
/// Decision 38·41 — 라오어는 2차 레이어(tier X, advanced 배제).
/// 메뉴 구성:
///   - 상단: 복습 풀너비 카드 (1×1)
///   - 2×2 그리드: 단어외우기 / 키보드연습 / 회화공부 / 미드나잇 라운지
///   - 우하단 FAB: 🇹🇭 태국어 가기 (Navigator.pop)
///
/// 현재 단계: 키보드 연습은 부록 언어 데이터로 작동. 단어외우기/회화공부/복습/
/// 미드나잇 은 [FlashCardScreen]·[ConversationScreen]·[AdultHubScreen] 에
/// languageOverride 가 추가되는 다음 단계까지 SnackBar 안내.
class LaoBonusScreen extends StatelessWidget {
  /// 부록 언어 코드. 현재 'lo' 만 의미 있음.
  final String appendixLang;

  const LaoBonusScreen({super.key, required this.appendixLang});

  @override
  Widget build(BuildContext context) {
    final profile = LanguageRegistry.forCode(appendixLang);
    final pool = appendixPool(appendixLang);
    final sentL1 = pool
        .where((w) => w.type == ItemType.sentence && w.course == 1)
        .length;
    final sentL2 = pool
        .where((w) => w.type == ItemType.sentence && w.course == 2)
        .length;
    final sentL6 = pool
        .where((w) => w.type == ItemType.sentence && w.course == 6)
        .length;
    final wordCount = pool.where((w) => w.type == ItemType.word).length;

    const navy = Color(0xFF1B4F8C); // 라오 네이비 (Decision 32)

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: Text(
          '${profile.flagEmoji} ${profile.nameKo} 보너스',
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 복습 1×1 풀너비
              _LaoWideCard(
                icon: Icons.refresh_rounded,
                title: '복습',
                subtitle: '학습한 라오어 항목',
                color: AppColors.danger,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashCardScreen(
                      reviewMode: true,
                      languageOverride: appendixLang,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 2×2 그리드
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  _LaoSquareCard(
                    icon: Icons.menu_book_outlined,
                    title: '단어 외우기',
                    subtitle: wordCount > 0
                        ? '$wordCount개'
                        : '회화 문장 ${sentL1 + sentL2 + sentL6}개',
                    color: navy,
                    // LO word row 0개라도 sentence 가 있으면 flashcard 모드로 진입 가능
                    enabled: pool.isNotEmpty,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashCardScreen(
                          languageOverride: appendixLang,
                        ),
                      ),
                    ),
                  ),
                  _LaoSquareCard(
                    icon: Icons.keyboard_outlined,
                    title: '키보드 연습',
                    subtitle: 'L1 $sentL1 · L2 $sentL2',
                    color: AppColors.successDark,
                    enabled: sentL1 > 0 || sentL2 > 0,
                    onTap: () => _showKeyboardPicker(
                        context, sentL1: sentL1, sentL2: sentL2),
                  ),
                  _LaoSquareCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: '회화 공부',
                    subtitle: 'L1·L2 ${sentL1 + sentL2}개',
                    color: AppColors.purpleDark,
                    enabled: sentL1 + sentL2 > 0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationScreen(
                          langCode: appendixLang,
                        ),
                      ),
                    ),
                  ),
                  _LaoSquareCard(
                    icon: Icons.wine_bar,
                    title: 'Midnight Lounge',
                    subtitle: 'L6 $sentL6개',
                    color: AppColors.midnightBurgundy,
                    enabled: sentL6 > 0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdultHubScreen(
                          languageOverride: appendixLang,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80), // FAB 가림 방지
            ],
          ),
        ),
      ),
      // 우하단 — 태국어 가기 (Navigator.pop)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        backgroundColor: AppColors.brandTh,
        foregroundColor: Colors.white,
        icon: const Text('🇹🇭', style: TextStyle(fontSize: 18)),
        label: Text('태국어 가기',
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showKeyboardPicker(BuildContext context,
      {required int sentL1, required int sentL2}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('⌨️ 라오어 키보드 연습',
                  style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              if (sentL1 > 0)
                _PickerTile(
                  emoji: '🌱',
                  label: 'L1 회화 (필수)',
                  count: sentL1,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KeyboardScreen(
                          course: 1,
                          itemType: ItemType.sentence,
                          languageOverride: appendixLang,
                        ),
                      ),
                    );
                  },
                ),
              if (sentL2 > 0)
                _PickerTile(
                  emoji: '💬',
                  label: 'L2 회화 (채팅)',
                  count: sentL2,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KeyboardScreen(
                          course: 2,
                          itemType: ItemType.sentence,
                          languageOverride: appendixLang,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

}

class _LaoSquareCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _LaoSquareCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = enabled ? color : AppColors.textMuted;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: c, size: 28),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: c)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _LaoWideCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LaoWideCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.notoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Text(subtitle,
                      style: GoogleFonts.notoSans(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _PickerTile({
    required this.emoji,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(label,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      trailing: Text('$count개',
          style: GoogleFonts.notoSans(color: AppColors.textMuted)),
    );
  }
}
