import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_service.dart';
import '../config/app_config.dart';
import '../services/adult_gate_service.dart';
import '../services/adult_verification_service.dart';
import '../services/asset_seed_loader.dart';
import '../services/learning_preferences.dart';
import '../services/subscription_service.dart';
import '../services/sync_service.dart';
import '../theme/app_colors.dart';

/// 내 정보 화면 — 로그인 이메일, 학습 방향, 성인 콘텐츠 잠금 해제, 로그아웃.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = AuthService.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('내 정보',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---- Account ----
          _sectionLabel('계정'),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('로그인 이메일',
                    style: GoogleFonts.notoSans(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(email ?? '(비로그인)',
                    style: GoogleFonts.notoSans(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ---- Learning ----
          _sectionLabel('학습 설정'),
          _card(
            child: ValueListenableBuilder<StudyDirection>(
              valueListenable: LearningPreferences.instance.direction,
              builder: (context, dir, _) {
                final koreanFirst = dir == StudyDirection.koreanFirst;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('학습 방향',
                              style: GoogleFonts.notoSans(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            koreanFirst
                                ? '한국어 → ${AppConfig.targetLanguageName}'
                                : '${AppConfig.targetLanguageName} → 한국어',
                            style: GoogleFonts.notoSans(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: koreanFirst,
                      onChanged: (_) =>
                          LearningPreferences.instance.toggle(),
                      activeThumbColor: AppConfig.brandColor,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // ---- Subscription ----
          _sectionLabel('구독'),
          _card(
            child: ValueListenableBuilder<SubscriptionTier>(
              valueListenable:
                  SubscriptionService.instance.currentTierListenable,
              builder: (context, tier, _) {
                final (emoji, label, desc) = switch (tier) {
                  SubscriptionTier.free => (
                      '🆓',
                      'Free',
                      '기초(L1) + 키보드 연습'
                    ),
                  SubscriptionTier.premium => (
                      '💎',
                      'Premium',
                      'L1~L5 전체 + 회화'
                    ),
                  SubscriptionTier.pro => (
                      '👑',
                      'Pro',
                      'Premium + Midnight Lounge (L6)'
                    ),
                };
                return Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('현재 등급: $label',
                              style: GoogleFonts.notoSans(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(desc,
                              style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // ---- Midnight Lounge gate ----
          _sectionLabel('🌙 Midnight Lounge'),
          _card(
            child: ValueListenableBuilder<bool>(
              valueListenable: AdultGateService.instance.unlocked,
              builder: (context, unlocked, _) {
                return Row(
                  children: [
                    const Text('👍', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Midnight Lounge 표시',
                              style: GoogleFonts.notoSans(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            unlocked
                                ? '메인 메뉴에 Midnight Lounge가 표시됩니다'
                                : '기본적으로 숨겨져 있습니다',
                            style: GoogleFonts.notoSans(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: unlocked,
                      onChanged: (next) => _onAdultToggle(context, next),
                      activeThumbColor: AppConfig.brandColor,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _card(
            child: ValueListenableBuilder<bool>(
              valueListenable:
                  AdultVerificationService.instance.verified,
              builder: (context, verified, _) {
                return Row(
                  children: [
                    const Text('🛡️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('성인 인증',
                              style: GoogleFonts.notoSans(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            verified
                                ? 'Google 인증 완료 — Midnight Lounge 접근 가능'
                                : '미인증 — Midnight Lounge 진입 시 인증 필요',
                            style: GoogleFonts.notoSans(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (verified)
                      const Icon(Icons.check_circle,
                          color: AppColors.success, size: 22)
                    else
                      TextButton(
                        onPressed: () => _onVerifyTap(context),
                        child: Text('인증하기',
                            style: GoogleFonts.notoSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppConfig.brandColor)),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // ---- Resync (for partial-sync recovery) ----
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _onResync(context),
              icon: const Icon(Icons.cloud_sync, size: 18),
              label: const Text('콘텐츠 재동기화'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- Sign out ----
          if (email != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await AuthService.instance.signOut();
                  if (context.mounted) Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('로그아웃'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                      color: AppColors.danger.withValues(alpha: 0.4)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onResync(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('콘텐츠 재동기화'),
        content: const Text(
            '로컬에 저장된 회화/단어를 비우고 서버에서 다시 받아옵니다. '
            '몇 초 걸릴 수 있어요. 진행할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('재동기화'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    messenger.showSnackBar(const SnackBar(
        content: Text('재동기화 중…'), duration: Duration(seconds: 2)));
    try {
      // 데이터 소스 분기 — 빌드 시 USE_LOCAL_DATA flag 따라.
      const useLocalData =
          bool.fromEnvironment('USE_LOCAL_DATA', defaultValue: true);
      if (useLocalData) {
        await AssetSeedLoader.instance.hardResyncItems();
      } else {
        await SyncService.instance.hardResyncItems();
      }
      messenger.showSnackBar(const SnackBar(
          content: Text('재동기화 완료'), duration: Duration(seconds: 2)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text('재동기화 실패: $e'),
          duration: const Duration(seconds: 3)));
    }
  }

  Future<void> _onAdultToggle(BuildContext context, bool next) async {
    if (next) {
      final ok = await _confirmUnlockDialog(context);
      if (ok == true) {
        await AdultGateService.instance.unlock();
      }
    } else {
      await AdultGateService.instance.lock();
    }
  }

  /// 성인 인증 버튼 탭 — 현재는 모의 인증. 실제 배포에서는 Google Play
  /// adult verification API / 본인확인 / 공동인증 중 하나를 연계.
  Future<void> _onVerifyTap(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🛡️ 성인 인증'),
        content: Text(
          '실제 배포에서는 Google Play의 adult verification, 휴대폰 본인확인 '
          '또는 공동인증으로 연결됩니다. 현재는 개발용 모의 인증입니다.',
          style: GoogleFonts.notoSans(
              fontSize: 13, color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('인증 완료 처리'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await AdultVerificationService.instance.verify();
    }
  }

  Future<bool?> _confirmUnlockDialog(BuildContext context) {
    bool agreed = false;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('🌙 Midnight Lounge 잠금 해제'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이 기능은 만 19세 이상만 이용할 수 있으며, 노골적인 성적 표현을 포함할 수 있습니다.',
                    style: GoogleFonts.notoSans(
                        fontSize: 14, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: agreed,
                    onChanged: (v) => setState(() => agreed = v ?? false),
                    title: Text('만 19세 이상이며 내용에 동의합니다',
                        style: GoogleFonts.notoSans(fontSize: 13)),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: agreed
                      ? () => Navigator.of(context).pop(true)
                      : null,
                  child: const Text('잠금 해제'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(label,
            style: GoogleFonts.notoSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5)),
      );

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
}

