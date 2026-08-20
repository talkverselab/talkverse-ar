import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../services/subscription_service.dart';
import '../theme/app_colors.dart';

/// Pro 티어 전용 페이월 — 성인 콘텐츠(L6) 해제용. Premium과 별개 결제.
class PaywallProScreen extends StatefulWidget {
  const PaywallProScreen({super.key});

  @override
  State<PaywallProScreen> createState() => _PaywallProScreenState();
}

class _PaywallProScreenState extends State<PaywallProScreen> {
  _Plan _selected = _Plan.monthly;

  static const _features = [
    ('💘', '헌팅 표현', '바·클럽·파티에서 자연스럽게 말 걸기'),
    ('😏', '플러팅 / 썸', '이중의미·암시·유혹성 대사'),
    ('🛏️', '잠자리 표현', '친밀한 순간의 선호·동의·리드'),
    ('🛡️', '성 건강 / 안전', '피임·경계·거절 등 실용 표현'),
    ('✅', '성인 인증 포함', '안전한 성인 학습 환경'),
  ];

  void _upgrade() async {
    // Mock "purchase" — in production, call Google Play Billing here.
    await SubscriptionService.instance.setPro(true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pro가 활성화됐어요! 👑',
            style: GoogleFonts.notoSans(color: Colors.white)),
        backgroundColor: AppColors.successDark,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    const Center(
                        child: Text('👑', style: TextStyle(fontSize: 56))),
                    const SizedBox(height: 12),
                    Text(
                      'Pro로 Midnight Lounge 해제',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${AppConfig.targetLanguageName}로 어른의 대화까지 자연스럽게',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ..._features.map((f) => _FeatureRow(
                          emoji: f.$1,
                          title: f.$2,
                          subtitle: f.$3,
                        )),
                    const SizedBox(height: 20),
                    _PlanCard(
                      plan: _Plan.monthly,
                      selected: _selected == _Plan.monthly,
                      onTap: () => setState(() => _selected = _Plan.monthly),
                    ),
                    const SizedBox(height: 10),
                    _PlanCard(
                      plan: _Plan.lifetime,
                      selected: _selected == _Plan.lifetime,
                      onTap: () => setState(() => _selected = _Plan.lifetime),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '만 19세 이상만 구독 가능 · 언제든 해지 가능',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _upgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  'Pro 구독하기',
                  style: GoogleFonts.notoSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('나중에',
                    style: GoogleFonts.notoSans(
                        color: AppColors.textSecondary, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Plan { monthly, lifetime }

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (title, price, note, badge) = plan == _Plan.monthly
        ? ('Pro 월 구독', '14,900원 / 월', '언제든 해지 가능', null)
        : ('Pro 평생권', '129,000원', '한 번 결제로 영구 사용', '🔥 인기');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppConfig.brandColor : AppColors.cardBorder,
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppConfig.brandColor : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: GoogleFonts.notoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(badge,
                              style: GoogleFonts.notoSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(note,
                      style: GoogleFonts.notoSans(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text(price,
                style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.brandColor)),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.notoSans(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
