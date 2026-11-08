import 'dart:async';

import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../screens/letter_chart_screen.dart' show letterGroupColor;
import '../services/achievement_service.dart';
import '../services/arabic_phonetics.dart';
import '../services/arabic_script.dart';
import '../services/tts_service.dart';

/// 글자 탭 → 발음 시트. 열리면 1초 뒤 자동 재생(글자 + 짧은 「아」), IPA·소리 나는 곳·한국어 비교·글자 모양 4가지·예시 낱말.
/// 일본어앱 kana_sound_sheet 의 아랍어판(사용자 지시 2026-11-08).
Future<void> showLetterSoundSheet(BuildContext context, LetterSound l) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.washi,
      constraints: const BoxConstraints(maxWidth: 680),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _LetterSoundSheet(l: l),
    );

/// 소리 낼 음절 — 자음은 짧은 「아」를 붙이고(بَ), 모음 글자는 그대로.
String letterSyllable(LetterSound l) => l.vowelOnly ? (l.ch == 'ا' ? 'آ' : l.example) : '${l.ch}َ';

class _LetterSoundSheet extends StatefulWidget {
  final LetterSound l;
  const _LetterSoundSheet({required this.l});
  @override
  State<_LetterSoundSheet> createState() => _LetterSoundSheetState();
}

class _LetterSoundSheetState extends State<_LetterSoundSheet> {
  Timer? _auto;
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    _auto = Timer(const Duration(seconds: 1), () => TtsService.instance.speak(letterSyllable(widget.l)));
    // 기초 화면에서 본 글자 모양도 성과 「익힌 글자 모양」에 센다(홀로 모양)
    final letter = letterOf(widget.l.ch);
    if (letter != null) AchievementService.instance.markGlyph('${letter.ch}:${GlyphForm.isolated.name}');
  }

  @override
  void dispose() {
    _auto?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    final color = letterGroupColor(l.group);
    final letter = letterOf(l.ch);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scroll) => SafeArea(
        top: false,
        child: ListView(
          controller: scroll,
          padding: EdgeInsets.fromLTRB(20, 12, 20, 32 + bottomInset(context)),
          children: [
            Center(
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.sumiLight.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                width: 84,
                height: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                child: Text(l.ch, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w800, color: AppColors.washi)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${l.name} · ${l.korSim}', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: color)),
                  const SizedBox(height: 4),
                  Text('IPA [${l.ipa}]', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.sumi)),
                  if (l.msa != null)
                    Text(trf('표준어 [{0}]', [l.msa!]), style: const TextStyle(fontSize: 12, color: AppColors.sumiLight)),
                ]),
              ),
              IconButton(
                iconSize: 44,
                color: color,
                tooltip: tr('다시 듣기'),
                icon: const Icon(Icons.play_circle_fill),
                onPressed: () => TtsService.instance.speak(letterSyllable(l)),
              ),
            ]),
            const SizedBox(height: 18),
            _section(tr('👄 소리 나는 곳'), l.place, color),
            if (!l.vowelOnly) ...[
              InkWell(
                onTap: () => setState(() => _showChart = !_showChart),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Icon(_showChart ? Icons.expand_less : Icons.expand_more, size: 18, color: color),
                    Text(tr('자음 조음 위치 그림 보기'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                  ]),
                ),
              ),
              if (_showChart) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: Image.asset('assets/images/ipa/places_of_articulation.png', fit: BoxFit.contain),
                  ),
                ),
                // 임시 그림 — 출시 전에 자체 그림으로 바꾼다(사용자 지시 2026-11-08: 출처 표기 넣지 않음)
                const SizedBox(height: 6),
              ],
            ] else
              const SizedBox(height: 14),
            _section(tr('🇰🇷 한국어와 비교'), trf('비슷한 소리: {0}\n\n{1}', [l.korSim, l.korDiff]), color),
            if (letter != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.washiDeep, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.35))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(letter.dual ? tr('✍️ 글자 모양 4가지') : tr('✍️ 글자 모양 2가지 — 다음 글자와 이어지지 않아요'),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
                  const SizedBox(height: 10),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Wrap(spacing: 10, runSpacing: 8, children: [
                      for (final f in letter.forms)
                        Container(
                          width: 64,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(color: AppColors.washi, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.line)),
                          child: Column(children: [
                            Text(letter.shape(f), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.sumi)),
                            Text(tr(f.ko), style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.muted)),
                          ]),
                        ),
                    ]),
                  ),
                ]),
              ),
            ],
            const SizedBox(height: 14),
            InkWell(
              onTap: () => TtsService.instance.speak(l.example),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.washiDeep, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.35))),
                child: Row(children: [
                  Icon(Icons.volume_up, color: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(trf('예: {0} · {1}', [l.exampleRd, l.exampleKo]), style: const TextStyle(fontSize: 13.5, color: AppColors.sumi)),
                  ),
                  Text(l.example, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.sumi)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body, Color color) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.washiDeep, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 13.5, height: 1.55, color: AppColors.sumi)),
        ]),
      );
}
