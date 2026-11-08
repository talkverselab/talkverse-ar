import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/arabic_phonetics.dart';
import '../services/tts_service.dart';
import '../widgets/letter_sound_sheet.dart';

/// 글자와 발음 — 아랍 문자 28자 + ة·ى 격자(오른쪽 → 왼쪽) + 묶음 칩 + 한글 소리 토글, 모음 부호 6개.
/// 글자를 누르면 소리 시트(1초 뒤 자동 재생·IPA·소리 나는 곳·한국어 비교·글자 모양 4가지).
/// 일본어앱 「50음도와 발음」(kana_chart_screen) 과 같은 구성(사용자 지시 2026-11-08). 로마자 대신 한글 소리(이 앱은 로마자 없음).
class LetterChartScreen extends StatefulWidget {
  const LetterChartScreen({super.key});

  @override
  State<LetterChartScreen> createState() => _LetterChartScreenState();
}

/// 묶음별 색 — 1 쉬운 소리 · 2 닮았지만 다른 소리 · 3 목 소리 · 4 강조음
Color letterGroupColor(int g) => switch (g) {
      2 => AppColors.ai,
      3 => AppColors.kinDeep,
      4 => AppColors.matcha,
      _ => AppColors.beni,
    };

class _LetterChartScreenState extends State<LetterChartScreen> {
  int _set = 0;
  bool _showKo = true;

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(tr('글자와 발음'), style: const TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(tr('28자 · 오른쪽에서 왼쪽 · 누르면 소리'), style: const TextStyle(color: AppColors.sumiLight, fontSize: 10, letterSpacing: 2)),
        ]),
        actions: [
          TextButton(
            onPressed: () => setState(() => _showKo = !_showKo),
            child: Text(_showKo ? tr('한글 소리 끄기') : tr('한글 소리'),
                style: const TextStyle(color: AppColors.beni, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ],
      ),
      body: Column(children: [
        _chips(),
        Expanded(child: _set == 5 ? _marks() : _grid()),
      ]),
    );
  }

  Widget _chips() => SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          children: List.generate(letterGroups.length, (i) {
            final selected = _set == i;
            final color = i >= 1 && i <= 4 ? letterGroupColor(i) : AppColors.sumi;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _set = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? color : AppColors.washi,
                    border: Border.all(color: color, width: selected ? 1.5 : 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(tr(letterGroups[i]),
                      style: TextStyle(color: selected ? AppColors.washi : color, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
            );
          }),
        ),
      );

  Widget _grid() {
    final list = _set == 0 ? letterSounds : letterSounds.where((l) => l.group == _set).toList();
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth / 84).floor().clamp(4, 8);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(12, 4, 12, 24 + bottomInset(context)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 92),
          itemCount: list.length,
          itemBuilder: (context, i) => _tile(list[i]),
        ),
      );
    });
  }

  Widget _tile(LetterSound l) {
    final color = letterGroupColor(l.group);
    return InkWell(
      onTap: () => showLetterSoundSheet(context, l),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.washi,
          border: Border.all(color: color.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(l.ch, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.sumi, height: 1.15)),
          Text(l.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.sumiLight)),
          if (_showKo)
            Text(l.korSim, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }

  Widget _marks() => ListView(
        padding: EdgeInsets.fromLTRB(12, 4, 12, 24 + bottomInset(context)),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(tr('이 앱의 문장에는 모음 부호를 달지 않아요 — 모음은 한글 독음이 보여 줍니다. 사전·간판에서 만날 때를 위해 한 번 봐 두세요.'),
                style: const TextStyle(fontSize: 12, color: AppColors.sumiLight, height: 1.5)),
          ),
          for (final m in markSounds)
            Card(
              color: AppColors.washi,
              elevation: 0,
              shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.line), borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                onTap: () => TtsService.instance.speak(m.mark),
                leading: SizedBox(
                  width: 48,
                  child: Text(m.mark, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.sumi)),
                ),
                title: Text('${m.name} · [${m.ipa}]', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.sumi)),
                subtitle: Text(m.how, style: const TextStyle(fontSize: 12, color: AppColors.sumiLight, height: 1.4)),
                trailing: const Icon(Icons.volume_up, color: AppColors.beni),
              ),
            ),
        ],
      );
}
