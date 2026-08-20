import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Modal bottom sheet that walks the user through installing a Chinese
/// (Simplified, Pinyin) keyboard on Android (Samsung) and iOS.
///
/// Call via [showChineseKeyboardGuide].
Future<void> showChineseKeyboardGuide(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _ChineseKeyboardGuide(),
  );
}

class _ChineseKeyboardGuide extends StatelessWidget {
  const _ChineseKeyboardGuide();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        height: size.height * 0.8,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    '키보드 설정',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '시스템 키보드에 **중국어 (간체, 병음)** 입력기를 추가하면 '
                '앱 안에서 바로 한자를 입력할 수 있어요.',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.textPrimary,
              labelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: '안드로이드 (삼성)'),
                Tab(text: '아이폰'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _SamsungSteps(),
                  _IosSteps(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SamsungSteps extends StatelessWidget {
  const _SamsungSteps();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: const [
        _Section(
          title: '방법 1 — 삼성 키보드에 중국어 추가 (권장)',
          steps: [
            '설정 앱 열기',
            '일반 → 삼성 키보드 설정  (또는 설정 → 일반 → 키보드 목록 및 기본값 → 삼성 키보드)',
            '언어 및 형식 탭',
            '입력 언어 관리 → + 버튼',
            '검색창에 "중국어" 입력 → 중국어 (간체) 선택 → 다운로드',
            '받은 후 목록에서 활성화 ON',
          ],
        ),
        SizedBox(height: 24),
        _Section(
          title: '방법 2 — Gboard (구글 키보드) 사용',
          steps: [
            'Play 스토어에서 Gboard 설치 (이미 설치되어 있으면 건너뛰기)',
            '설정 → 일반 → 키보드 목록 및 기본값 → Gboard 활성화 ON',
            'Gboard 앱 또는 설정 → Gboard → 언어 → 키보드 추가',
            '중국어 (간체) → 병음 (Pinyin) 선택 → 완료',
            '입력 칸을 눌러 키보드를 연 뒤, 스페이스바 옆 🌐 지구본 아이콘을 길게 눌러 중국어로 전환',
          ],
        ),
        SizedBox(height: 24),
        _Tip(
          '입력 방법: 영어 키보드처럼 **병음**을 입력하면 (예: "nihao") 한자 후보가 '
          '표시됩니다. 원하는 한자를 탭해서 선택.',
        ),
      ],
    );
  }
}

class _IosSteps extends StatelessWidget {
  const _IosSteps();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: const [
        _Section(
          title: '기본 iOS 키보드에 중국어 추가',
          steps: [
            '설정 앱 열기',
            '일반 → 키보드 → 키보드',
            '새로운 키보드 추가 탭',
            '중국어(간체) 선택',
            '병음 - QWERTY (Pinyin - QWERTY)에 체크 → 완료',
          ],
        ),
        SizedBox(height: 24),
        _Section(
          title: '키보드 전환 방법',
          steps: [
            '입력하려는 텍스트 칸을 탭해서 키보드 열기',
            '스페이스바 왼쪽의 🌐 지구본 아이콘을 탭하면 다음 키보드로 순환',
            '길게 누르면 설치된 키보드 목록에서 직접 선택 가능',
          ],
        ),
        SizedBox(height: 24),
        _Tip(
          '입력 방법: 영어 키보드처럼 **병음**을 입력하면 (예: "nihao") 상단에 '
          '한자 후보가 뜹니다. 원하는 한자를 탭.',
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> steps;
  const _Section({required this.title, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(right: 10, top: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: GoogleFonts.notoSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: GoogleFonts.notoSans(
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.newHighlight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8, top: 1),
            child: Text('💡', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
