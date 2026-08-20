import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../screens/paywall_screen.dart';
import '../services/subscription_service.dart';

/// Small banner inviting free users to upgrade.
/// Renders nothing for premium users.
class UpgradeBanner extends StatelessWidget {
  final int lockedCount;

  const UpgradeBanner({super.key, required this.lockedCount});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SubscriptionService.instance.isPremiumListenable,
      builder: (context, isPremium, _) {
        if (isPremium || lockedCount <= 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaywallScreen()),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppConfig.brandColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppConfig.brandColor.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$lockedCount개 더 해제 · 프리미엄으로 업그레이드',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppConfig.brandColor,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppConfig.brandColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
