import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/word_data.dart';
import '../models/word.dart';
import '../services/adult_verification_service.dart';
import '../services/subscription_service.dart';
import '../theme/app_colors.dart';
import 'conversation_screen.dart';
import 'paywall_pro_screen.dart';
import 'profile_screen.dart';

/// L6 성인 콘텐츠 허브 — 6개 서브카테고리.
///
/// 진입 흐름 (사용자 결정 2026-04-24):
///   - 대화문 우선 → ConversationScreen으로 (암기 버튼은 화면 하단)
///   - 단어 외우기 메뉴는 L6에 노출하지 않음 (대신 회화 카드 hint에 단어 정리)
///
/// 카드 진입 시 이중 게이트:
///   1) 성인 인증 미완료 → 인증 유도 다이얼로그 (→ 내 정보로 이동)
///   2) Pro 구독 미보유  → Paywall Pro 화면
///   3) 둘 다 OK       → ConversationScreen(course=6, initialCategory=label)
class AdultHubScreen extends StatelessWidget {
  /// 부록 언어 override — 'lo' 등. null 이면 주 언어.
  final String? languageOverride;
  const AdultHubScreen({super.key, this.languageOverride});

  /// 6 테마 정의 + 각 테마에 속한 dialogue 번호. ID 기준 그룹화 (DB category 무관).
  /// **VI/RU 표준 매핑**: d01-d03 intimate, d04-d05 jealousy, d06+d16-d18 conflict/taboo,
  /// d07-d09 dating, d10-d12 consent/boundaries, d13-d15 aftermath/breakup.
  static const _themesDefault =
      <({String emoji, String label, List<int> dialogues})>[
    (emoji: '💕', label: '연인 인티밋', dialogues: [1, 2, 3]),
    (emoji: '💢', label: '격렬한 다툼', dialogues: [6, 16, 17, 18]),
    (emoji: '👀', label: '질투와 신뢰', dialogues: [4, 5]),
    (emoji: '📱', label: '데이팅앱', dialogues: [7, 8, 9]),
    (emoji: '🛡️', label: '동의와 경계', dialogues: [10, 11, 12]),
    (emoji: '💔', label: '이별과 헤어짐', dialogues: [13, 14, 15]),
  ];

  /// **MN 별도 매핑** (Decision 50 — L6 별도 narrative + bridge + UB 나이트):
  /// d01-03 intimate / d04-05 jealousy / d06-08 conflict / d09-11 dating(creep)
  /// d12-14 consent / d15-17 breakup / d18-19 bridge(intimate) / d20-22 nightlife(dating)
  /// **L6 part2 추가 (2026-04-27, 사용자 "더 많이" 요청)**:
  /// d23-24 intimate (호텔 weekend + morning after) / d25 jealousy (IG)
  /// d26 conflict (돈·미래) / d27 dating (blind date) / d28 consent (boundary)
  /// d29 breakup (healthy) / d30 bridge (Жон+Сараа 1주년)
  static const _themesMn =
      <({String emoji, String label, List<int> dialogues})>[
    (emoji: '💕', label: '연인 인티밋', dialogues: [1, 2, 3, 18, 19, 23, 24, 30]),
    (emoji: '💢', label: '격렬한 다툼', dialogues: [6, 7, 8, 26]),
    (emoji: '👀', label: '질투와 신뢰', dialogues: [4, 5, 25]),
    (emoji: '📱', label: '데이팅앱', dialogues: [9, 10, 11, 20, 21, 22, 27]),
    (emoji: '🛡️', label: '동의와 경계', dialogues: [12, 13, 14, 28]),
    (emoji: '💔', label: '이별과 헤어짐', dialogues: [15, 16, 17, 29]),
  ];

  /// **ID 별도 매핑** (Decision 45.2 — L6 = 러브·자극 81% 비표준 분포):
  /// intimate 19 + sweet 7 흡수 = 24 dial / family 3 (종교·정착) → 이별 흡수
  /// jealousy 1 / dating sext 2 / consent 중복 2 / 폐기 5 (d19,20,23,24,26)
  static const _themesId =
      <({String emoji, String label, List<int> dialogues})>[
    (emoji: '💕', label: '연인 인티밋', dialogues: [16, 22, 27, 28, 29, 30, 33, 34, 35, 36, 37, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 52]),
    (emoji: '💢', label: '격렬한 다툼', dialogues: [18]),
    (emoji: '👀', label: '질투와 신뢰', dialogues: [21]),
    (emoji: '📱', label: '데이팅앱', dialogues: [38, 51]),
    (emoji: '🛡️', label: '동의와 경계', dialogues: [22, 29]),
    (emoji: '💔', label: '이별과 헤어짐', dialogues: [17, 25]),
  ];

  /// MY 6 테마 매핑 — 한-미얀 결혼·연애 narrative 별도 (Min-jun/Su Su 외 5 커플).
  /// L6 d01-d15 사용. 일부 d01_intimate / d04_conflict 등 suffix 포함되지만 regex 가 d번호만 추출.
  static const _themesMy =
      <({String emoji, String label, List<int> dialogues})>[
    (emoji: '💕', label: '연인 인티밋', dialogues: [1, 8, 9]),
    (emoji: '👀', label: '질투와 신뢰', dialogues: [3, 11]),
    (emoji: '💢', label: '격렬한 다툼', dialogues: [4, 12, 13]),
    (emoji: '🛡️', label: '동의와 경계', dialogues: [2, 5, 10]),
    (emoji: '📱', label: '데이팅·디지털', dialogues: [14]),
    (emoji: '💔', label: '이별·교육', dialogues: [6, 7, 15]),
  ];

  /// 언어별 테마 매핑 선택. 신규 언어가 별도 매핑 필요하면 여기 추가.
  static List<({String emoji, String label, List<int> dialogues})> _themesFor(
      String langCode) {
    if (langCode == 'mn') return _themesMn;
    if (langCode == 'id') return _themesId;
    if (langCode == 'my') return _themesMy;
    return _themesDefault;
  }

  static final _idDialogueRegex = RegExp(r'l6_d(\d+)_');

  /// 한 sentence 의 id 에서 dialogue 번호 추출 (예: 'ru:sent:l6_d05_t01' → 5).
  /// L6 가 아니면 null.
  static int? _dialogueOf(Word w) {
    final m = _idDialogueRegex.firstMatch(w.id);
    return m == null ? null : int.parse(m.group(1)!);
  }

  /// 6 테마 카드. dialogue 번호 매핑 기준으로 카운트. DB category 무관.
  /// languageOverride 가 지정되면 해당 언어 ID prefix 만 카운트.
  List<({String emoji, String label, int count, List<int> dialogues})>
      _themeCardsForCurrentLang() {
    final lang = languageOverride ?? AppConfig.languageCode;
    final themes = _themesFor(lang);
    final l6Items = conversationPoolAll()
        .where((w) =>
            w.course == 6 &&
            w.id.startsWith('$lang:'))
        .toList();
    return themes.map((theme) {
      final count = l6Items.where((w) {
        final d = _dialogueOf(w);
        return d != null && theme.dialogues.contains(d);
      }).length;
      return (
        emoji: theme.emoji,
        label: theme.label,
        count: count,
        dialogues: theme.dialogues,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.midnightBurgundy,
        elevation: 0,
        title: Text('🍷 Midnight Lounge',
            style: GoogleFonts.notoSans(
                color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: AdultVerificationService.instance.verified,
        builder: (context, verified, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: SubscriptionService.instance.isProListenable,
            builder: (context, isPro, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _GateBanner(verified: verified, isPro: isPro),
                    const SizedBox(height: 16),
                    Builder(builder: (context) {
                      final themes = _themeCardsForCurrentLang();
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                        children: themes
                            .map((t) => _SubCard(
                                  emoji: t.emoji,
                                  label: t.label,
                                  count: t.count,
                                  onTap: () => _onThemeTap(context, t.label,
                                      t.dialogues, verified, isPro),
                                ))
                            .toList(),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onThemeTap(BuildContext context, String themeLabel,
      List<int> dialogues, bool verified, bool isPro) async {
    // Gate 1: verification
    if (!verified) {
      final goVerify = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('🛡️ 성인 인증이 필요해요'),
          content: Text(
            'Midnight Lounge 진입에는 만 19세 이상 확인이 필요합니다. 내 정보 > 성인 인증에서 '
            '인증을 완료한 뒤 다시 시도하세요.',
            style: GoogleFonts.notoSans(
                fontSize: 13, color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('인증하러 가기'),
            ),
          ],
        ),
      );
      if (goVerify == true && context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      }
      return;
    }

    // Gate 2: Pro subscription
    if (!isPro) {
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaywallProScreen()),
      );
      return;
    }

    // Both gates passed → 2단계 화면: 이 테마의 dialogue 목록.
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ThemeDialogueListScreen(
          themeLabel: themeLabel,
          dialogues: dialogues,
          languageOverride: languageOverride,
        ),
      ),
    );
  }
}

/// scenario 풀 텍스트의 짧은 제목 부분만 추출. 보통 em dash 앞이 장소·주제.
/// 예: '호텔 방 — 연인 스탐...' → '호텔 방'
String _shortScenario(String full) {
  if (full.isEmpty) return '';
  for (final sep in [' — ', ' - ', '—', ' – ']) {
    final i = full.indexOf(sep);
    if (i > 0 && i < 30) return full.substring(0, i).trim();
  }
  // separator 못 찾으면 첫 15자 (한글 기준 짧게)
  return full.length > 15 ? '${full.substring(0, 15)}…' : full;
}

/// scenario 키워드로 이모지 매핑. 한국어 기준 (모든 언어 scenario 가 한국어 라벨).
String _emojiForScenario(String s) {
  if (s.contains('호텔')) return '🏨';
  if (s.contains('침대') || s.contains('침실') || s.contains('침구')) return '🛏️';
  if (s.contains('카페')) return '☕';
  if (s.contains('레스토랑') || s.contains('식당') || s.contains('밥집')) return '🍽️';
  if (s.contains('와인') || s.contains('술집') || s.contains('바 ') || s.contains('칵테일')) {
    return '🍷';
  }
  if (s.contains('맥주') || s.contains('호프') || s.contains('펍')) return '🍺';
  if (s.contains('파티') || s.contains('연회') || s.contains('회식')) return '🎉';
  if (s.contains('영화관') || s.contains('영화')) return '🎬';
  if (s.contains('해변') || s.contains('바다')) return '🏖️';
  if (s.contains('공원') || s.contains('산책')) return '🌳';
  if (s.contains('쇼핑') || s.contains('백화점') || s.contains('매장')) return '🛍️';
  if (s.contains('자동차') || s.contains('드라이브') || s.contains('차안')) return '🚗';
  if (s.contains('지하철') || s.contains('전철') || s.contains('버스')) return '🚌';
  if (s.contains('학교') || s.contains('교실') || s.contains('대학')) return '🏫';
  if (s.contains('사무실') || s.contains('회사') || s.contains('오피스')) return '🏢';
  if (s.contains('병원') || s.contains('의원')) return '🏥';
  if (s.contains('데이팅') || s.contains('Tinder') || s.contains('매칭앱')) return '📱';
  if (s.contains('욕설') || s.contains('금기') || s.contains('상소리') || s.contains('mat ')) {
    return '⚠️';
  }
  if (s.contains('이별') || s.contains('헤어')) return '💔';
  if (s.contains('데이트') || s.contains('연애') || s.contains('썸')) return '💕';
  if (s.contains('질투') || s.contains('의심') || s.contains('바람')) return '👀';
  if (s.contains('다툼') || s.contains('싸움') || s.contains('갈등')) return '💢';
  if (s.contains('방')) return '🚪';
  return '💬';
}

/// L6 테마 → dialogue 목록 화면 (3 단계 중간). 각 dialogue 카드 →
/// ConversationScreen(course=6, initialCategory='대화XX').
class _ThemeDialogueListScreen extends StatelessWidget {
  final String themeLabel;
  final List<int> dialogues;
  final String? languageOverride;
  const _ThemeDialogueListScreen({
    required this.themeLabel,
    required this.dialogues,
    this.languageOverride,
  });

  @override
  Widget build(BuildContext context) {
    final lang = languageOverride;
    final l6Items = conversationPoolAll()
        .where((w) =>
            w.course == 6 &&
            (lang == null || w.id.startsWith('$lang:')))
        .toList();
    // dialogue 번호별 그룹화 (이 테마에 속하는 것만)
    final byDialogue = <int, List<Word>>{};
    for (final w in l6Items) {
      final m = AdultHubScreen._idDialogueRegex.firstMatch(w.id);
      if (m == null) continue;
      final d = int.parse(m.group(1)!);
      if (!dialogues.contains(d)) continue;
      byDialogue.putIfAbsent(d, () => []).add(w);
    }
    final sorted = byDialogue.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.midnightBurgundy,
        elevation: 0,
        title: Text(themeLabel,
            style: GoogleFonts.notoSans(
                color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
          children: sorted.map((d) {
            final items = byDialogue[d]!;
            // 같은 dialogue 의 첫 row 의 category 가 '대화XX' (또는 6 테마 이름).
            final dialogueCategory = items.first.category;
            // scenario 의 짧은 제목 (em dash 앞) + 키워드 기반 이모지.
            final shortTitle = _shortScenario(items.first.scenario);
            final emoji = _emojiForScenario(items.first.scenario);
            return _SubCard(
              emoji: emoji,
              label: shortTitle.isEmpty
                  ? '대화${d.toString().padLeft(2, '0')}'
                  : shortTitle,
              count: items.length,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationScreen(
                      course: 6,
                      initialCategory: dialogueCategory,
                      langCode: languageOverride,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GateBanner extends StatelessWidget {
  final bool verified;
  final bool isPro;
  const _GateBanner({required this.verified, required this.isPro});

  @override
  Widget build(BuildContext context) {
    final bothOk = verified && isPro;
    final bg = bothOk
        ? AppColors.success.withValues(alpha: 0.10)
        : AppColors.warning.withValues(alpha: 0.12);
    final border = bothOk
        ? AppColors.success.withValues(alpha: 0.5)
        : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _gateLine(
            ok: verified,
            labelOk: '성인 인증 완료',
            labelMissing: '성인 인증 필요 (내 정보 > 성인 인증)',
          ),
          const SizedBox(height: 6),
          _gateLine(
            ok: isPro,
            labelOk: 'Pro 구독 중',
            labelMissing: 'Pro 구독 필요 (진입 시 페이월 표시)',
          ),
        ],
      ),
    );
  }

  Widget _gateLine(
      {required bool ok,
      required String labelOk,
      required String labelMissing}) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: ok ? AppColors.success : AppColors.textMuted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ok ? labelOk : labelMissing,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              color: ok ? AppColors.successDark : AppColors.textPrimary,
              fontWeight: ok ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubCard extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _SubCard({
    required this.emoji,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppConfig.brandColor.withValues(alpha: 0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text('$count개 항목',
                style: GoogleFonts.notoSans(
                    fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
