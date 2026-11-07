import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/achievement_service.dart';
import '../services/arabic_script.dart';
import '../services/dialogue_service.dart' show Lemma;
import '../services/tts_service.dart';
import '../services/word_lookup.dart';
import 'lemma_chips.dart';

/// 글자 시트 — UX 시안 AR-01 ①(2026-11-03). 낱말을 글자로 풀어 오른쪽→왼쪽으로 놓고,
/// 글자를 누르면 그 글자의 모양(홀로·앞·가운데·끝)과 지금 쓰인 모양을 보여 준다. 본 모양은 성과 「익힌 글자 모양」에 더한다.
class GlyphSheet extends StatefulWidget {
  final String word;
  const GlyphSheet({super.key, required this.word});

  static Future<void> show(BuildContext context, String word) {
    final parts = splitWord(word);
    if (parts.isEmpty) return Future.value();
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.washi,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.45, maxWidth: 640),
      builder: (_) => GlyphSheet(word: word),
    );
  }

  @override
  State<GlyphSheet> createState() => _GlyphSheetState();
}

class _GlyphSheetState extends State<GlyphSheet> {
  late final List<GlyphInWord> parts = splitWord(widget.word);
  int sel = 0;

  @override
  void initState() {
    super.initState();
    _seen(0);
  }

  void _seen(int i) {
    setState(() => sel = i);
    AchievementService.instance.markGlyph(parts[i].key);
  }

  @override
  Widget build(BuildContext context) {
    final cur = parts[sel];
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottomInset(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text(tr('글자 모양'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.muted)),
          const Spacer(),
          Text(widget.word, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.sumi)),
          IconButton(
            tooltip: tr('듣기'),
            icon: const Icon(Icons.volume_up, color: AppColors.beni),
            onPressed: () => TtsService.instance.speak(widget.word),
          ),
        ]),
        const SizedBox(height: 4),
        // 읽는 방향: 오른쪽 → 왼쪽
        Row(children: [
          const Icon(Icons.arrow_back, size: 16, color: AppColors.muted),
          const SizedBox(width: 4),
          Text(tr('오른쪽에서 왼쪽으로 읽어요'), style: const TextStyle(fontSize: 11, color: AppColors.muted)),
        ]),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            for (var i = 0; i < parts.length; i++) _chip(i),
          ]),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.washiDeep, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(trf('{0} · 소리 {1} · 여기서는 「{2}」 모양', [cur.letter.ch, cur.letter.sound, tr(cur.form.ko)]),
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.sumi)),
            if (!cur.letter.dual)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(tr('이 글자는 다음 글자와 이어지지 않아요(모양 2가지)'), style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(spacing: 10, runSpacing: 8, children: [
                for (final f in cur.letter.forms) _form(cur.letter, f, f == cur.form),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _chip(int i) {
    final p = parts[i];
    final on = i == sel;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _seen(i),
      child: Container(
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: on ? AppColors.beni.withValues(alpha: 0.08) : AppColors.washi,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: on ? AppColors.beni : AppColors.line, width: on ? 1.6 : 1),
        ),
        child: Column(children: [
          Text(p.letter.shape(p.form), textDirection: TextDirection.rtl, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: on ? AppColors.beni : AppColors.sumi)),
          Text(p.letter.sound, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
        ]),
      ),
    );
  }

  Widget _form(ArabicLetter l, GlyphForm f, bool on) => Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: on ? AppColors.beni : AppColors.washi,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: on ? AppColors.beni : AppColors.line),
        ),
        child: Column(children: [
          Text(l.shape(f), textDirection: TextDirection.rtl, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: on ? Colors.white : AppColors.sumi)),
          Text(tr(f.ko), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: on ? Colors.white : AppColors.muted)),
        ]),
      );
}

/// 아랍어 줄 — 오른쪽→왼쪽. [lemmas] 가 있으면 낱말 탭 = 단어창, 길게 누름 = 글자 시트(사용자 지시 2026-11-07).
/// 단어장에 있는 낱말은 밑줄 색으로 표시. 없는 낱말·[lemmas] 없는 줄은 탭 = 글자 시트(이전과 같음).
class TappableArabicText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int? maxLines;
  final List<Lemma> lemmas;
  const TappableArabicText(this.text, {super.key, required this.style, this.maxLines, this.lemmas = const []});

  static final _word = RegExp(r'[\u0621-\u0652\u0670-\u06D3\u200C]+');
  static final _prefix = RegExp('^(و|ف)?(ب|ل|ك)?(ال)?');

  /// 문장 속 낱말 → 레마. 꼴이 같으면 그대로, 아니면 앞의 و·ف·ب·ل·ك·ال 를 뗀 꼴로.
  static Lemma? lemmaFor(String token, List<Lemma> lemmas) {
    final k = WordLookup.key(token);
    for (final l in lemmas) {
      if (WordLookup.key(l.surface) == k) return l;
    }
    final bare = k.replaceFirst(_prefix, '');
    for (final l in lemmas) {
      if (WordLookup.key(l.surface) == bare) return l;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (lemmas.isEmpty) return _RichArabic(text, style: style, maxLines: maxLines);
    return FutureBuilder<Map<String, WordEntry>>(
      key: ValueKey(text),
      future: WordLookup.instance.byLemmas(lemmas),
      builder: (context, snap) {
        final found = snap.data ?? const <String, WordEntry>{};
        final parts = text.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            spacing: (style.fontSize ?? 16) * 0.28,
            children: [
              for (final p in parts) _word.hasMatch(p) ? _tile(context, p, found) : Text(p, style: style),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(BuildContext context, String part, Map<String, WordEntry> found) {
    final token = _word.firstMatch(part)!.group(0)!;
    final l = lemmaFor(token, lemmas);
    final e = l == null ? null : found[l.base];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => e != null ? showLemmaWord(context, e, l!) : GlyphSheet.show(context, token),
      onLongPress: () => GlyphSheet.show(context, token),
      child: Text(part,
          style: e == null ? style : style.copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.ai, decorationThickness: 1.4)),
    );
  }
}

class _RichArabic extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int? maxLines;
  const _RichArabic(this.text, {required this.style, this.maxLines});

  @override
  State<_RichArabic> createState() => _RichArabicState();
}

class _RichArabicState extends State<_RichArabic> {
  final _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    final spans = <InlineSpan>[];
    final re = RegExp(r'[\u0621-\u0652\u0670-\u06D3\u200C]+');
    var last = 0;
    for (final m in re.allMatches(widget.text)) {
      if (m.start > last) spans.add(TextSpan(text: widget.text.substring(last, m.start)));
      final w = m.group(0)!;
      final r = TapGestureRecognizer()..onTap = () => GlyphSheet.show(context, w);
      _recognizers.add(r);
      spans.add(TextSpan(text: w, recognizer: r));
      last = m.end;
    }
    if (last < widget.text.length) spans.add(TextSpan(text: widget.text.substring(last)));
    return Text.rich(
      TextSpan(style: widget.style, children: spans),
      textDirection: TextDirection.rtl,
      maxLines: widget.maxLines,
      overflow: widget.maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}
