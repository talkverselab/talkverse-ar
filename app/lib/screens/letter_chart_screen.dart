import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/arabic_phonetics.dart';
import '../services/arabic_script.dart';
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
        Expanded(child: _set == 6 ? _affixes() : (_set == 5 ? _marks() : _grid())),
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

  /// 접사 글자 10 — 사알투무니하(옛 앱 메뉴를 이집트 구어로). 글자마다 모양 4가지 + 붙는 쓰임과 예.
  Widget _affixes() => ListView(
        padding: EdgeInsets.fromLTRB(12, 4, 12, 24 + bottomInset(context)),
        children: [
          InkWell(
            onTap: () => TtsService.instance.speak(affixWord),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                const Icon(Icons.volume_up, color: AppColors.beni),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(tr('이 10자는 낱말 앞뒤에 붙어 「나·너·그」, 시제, 「그리고」 같은 뜻을 더해요. 외우는 말: 사알투무니하'),
                      style: const TextStyle(fontSize: 12, color: AppColors.sumiLight, height: 1.5)),
                ),
                const SizedBox(width: 8),
                const Text(affixWord, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.sumi)),
              ]),
            ),
          ),
          for (final a in affixLetters) _affixCard(a),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(tr('※ 같은 글자가 낱말 뿌리(어근)에도 쓰여요 — 앞뒤에 있다고 늘 접사는 아니에요. 진행형 بـ(비)는 10자에 없지만 구어에서 가장 자주 붙어요.'),
                style: const TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5)),
          ),
        ],
      );

  Widget _affixCard(AffixLetter a) {
    final letter = letterOf(a.ch);
    return Card(
      color: AppColors.washi,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.line), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Text(a.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.beni)),
            const Spacer(),
            if (letter != null)
              Directionality(
                textDirection: TextDirection.rtl,
                child: Wrap(spacing: 6, children: [
                  for (final f in letter.forms)
                    Text(letter.shape(f), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.sumiLight)),
                ]),
              ),
            const SizedBox(width: 10),
            Text(a.ch, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.sumi)),
          ]),
          const SizedBox(height: 6),
          for (final u in a.uses)
            InkWell(
              onTap: () => TtsService.instance.speak(u.ex),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(u.how, style: const TextStyle(fontSize: 12.5, color: AppColors.sumi, height: 1.4)),
                      Text('${u.exRd} · ${u.exKo}', style: const TextStyle(fontSize: 11.5, color: AppColors.sumiLight)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Text(u.ex, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.sumi)),
                ]),
              ),
            ),
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
