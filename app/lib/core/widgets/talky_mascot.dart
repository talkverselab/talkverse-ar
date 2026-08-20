import 'package:flutter/material.dart';

/// Talky 마스코트 — 누락일수에 따라 7단계 표정.
///
/// stage 매핑 (assets/UXUI/Talky/talky-stages.jsx 기반):
///   1: 웃음 (Day 1) — 활발 상태, 오늘 학습 함
///   2: 화이팅 (Day 2) — 1일 누락
///   3: 굳은 결심 (Day 3) — 2일 누락
///   4: 걱정 (Day 4) — 3일 누락
///   5: 꼬라봄 (Day 5) — 4일 누락
///   6: 무릎꿇고 빔 (Day 6) — 5일 누락
///   7: 체념 (Day 7+) — 6일 이상 누락, "하..." 표정 계속
///
/// 현재는 emoji placeholder. 추후 SVG/Lottie 로 교체 예정.
class TalkyMascot extends StatelessWidget {
  /// 누락 일수.  Days inactive (0 = 오늘 활동).
  final int daysInactive;
  final double size;
  final double opacity;

  const TalkyMascot({
    super.key,
    required this.daysInactive,
    this.size = 56,
    this.opacity = 0.92,
  });

  /// daysInactive → stage (1-7).
  static int stageFor(int daysInactive) {
    if (daysInactive <= 0) return 1;
    if (daysInactive >= 6) return 7;
    return daysInactive + 1;
  }

  /// stage → 임시 emoji placeholder.  Talky SVG 미구현시 fallback.
  /// 사용자 결정 2026-05-08: 미소 제거 (캡처 디자인 시안 따라).
  static String _emojiFor(int stage) {
    switch (stage) {
      case 1:
        return '🌍'; // active — 무표정 globe (미소 X)
      case 2:
        return '💪'; // 화이팅
      case 3:
        return '🔥'; // 굳은 결심
      case 4:
        return '😐'; // 걱정 (무표정)
      case 5:
        return '😒'; // 꼬라봄 (side-eye)
      case 6:
        return '🥺'; // 무릎꿇고 빔 (pleading)
      case 7:
      default:
        return '😴'; // 체념 (squat / 하...)
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = stageFor(daysInactive);
    return Opacity(
      opacity: opacity,
      child: Text(
        _emojiFor(stage),
        style: TextStyle(fontSize: size, height: 1.0),
      ),
    );
  }
}
