/// 아랍 문자 — 글자 모양(홀로·앞·가운데·끝) 계산. UX 시안 AR-01 §4-A「글자 돋보기」(페르시아어앱 persian_script.dart 이식, 2026-11-03).
///
/// 모양은 표를 따로 두지 않고 유니코드 결합 규칙으로 만든다: 앞 = 글자+ZWJ, 가운데 = ZWJ+글자+ZWJ, 끝 = ZWJ+글자.
/// 소리는 이집트 구어(카이로) 기준 한글 대표 소리 — ج 은 「ㄱ(g)」, ق 은 카이로에서 성문 닫힘(ㅇ)으로 읽는다.
library;

enum GlyphForm { isolated, initial, medial, finalForm }

extension GlyphFormKo on GlyphForm {
  String get ko => switch (this) {
        GlyphForm.isolated => '홀로',
        GlyphForm.initial => '앞',
        GlyphForm.medial => '가운데',
        GlyphForm.finalForm => '끝',
      };
}

class ArabicLetter {
  final String ch;
  final String sound; // 한글 소리
  final bool dual; // 왼쪽(다음 글자)으로도 이어지는가 — ا د ذ ر ز و ة ى 는 이어지지 않는다(ى 는 낱말 끝에만)
  const ArabicLetter(this.ch, this.sound, {this.dual = true});

  List<GlyphForm> get forms => dual ? GlyphForm.values : const [GlyphForm.isolated, GlyphForm.finalForm];

  String shape(GlyphForm f) => switch (f) {
        GlyphForm.isolated => ch,
        GlyphForm.initial => '$ch‍',
        GlyphForm.medial => '‍$ch‍',
        GlyphForm.finalForm => '‍$ch',
      };
}

/// 아랍어 28글자 + 낱말 끝 글자 ة·ى. 순서는 알파벳 순. 함자 붙은 글자(أ إ آ ؤ ئ)는 바탕 글자로 센다.
const arabicLetters = <ArabicLetter>[
  ArabicLetter('ا', '아', dual: false),
  ArabicLetter('ب', 'ㅂ'),
  ArabicLetter('ت', 'ㅌ'),
  ArabicLetter('ث', 'ㅅ·ㅌ'),
  ArabicLetter('ج', 'ㄱ(g)'),
  ArabicLetter('ح', 'ㅎ'),
  ArabicLetter('خ', 'ㅋ(kh)'),
  ArabicLetter('د', 'ㄷ', dual: false),
  ArabicLetter('ذ', 'ㅈ(z)·ㄷ', dual: false),
  ArabicLetter('ر', 'ㄹ', dual: false),
  ArabicLetter('ز', 'ㅈ(z)', dual: false),
  ArabicLetter('س', 'ㅅ'),
  ArabicLetter('ش', '시'),
  ArabicLetter('ص', 'ㅅ'),
  ArabicLetter('ض', 'ㄷ'),
  ArabicLetter('ط', 'ㅌ'),
  ArabicLetter('ظ', 'ㅈ(z)'),
  ArabicLetter('ع', '목 조임(ʿ)'),
  ArabicLetter('غ', 'ㄱ(gh)'),
  ArabicLetter('ف', 'ㅍ(f)'),
  ArabicLetter('ق', 'ㅇ(성문)·ㄱ(q)'),
  ArabicLetter('ك', 'ㅋ'),
  ArabicLetter('ل', 'ㄹ'),
  ArabicLetter('م', 'ㅁ'),
  ArabicLetter('ن', 'ㄴ'),
  ArabicLetter('ه', 'ㅎ'),
  ArabicLetter('و', '우·와(w)', dual: false),
  ArabicLetter('ي', '이·ㅇ(y)'),
  ArabicLetter('ة', '아(끝)', dual: false),
  ArabicLetter('ى', '아(끝)', dual: false),
];

final Map<String, ArabicLetter> _byChar = {
  for (final l in arabicLetters) l.ch: l,
  'أ': arabicLetters.first, 'إ': arabicLetters.first, 'آ': arabicLetters.first, 'ٱ': arabicLetters.first,
  'ؤ': arabicLetters.firstWhere((l) => l.ch == 'و'),
  'ئ': arabicLetters.firstWhere((l) => l.ch == 'ي'),
  'ک': arabicLetters.firstWhere((l) => l.ch == 'ك'), // 페르시아식 카프·야도 같은 글자로
  'ی': arabicLetters.firstWhere((l) => l.ch == 'ي'),
};

ArabicLetter? letterOf(String ch) => _byChar[ch];

/// 성과 「익힌 글자 모양」 분모 — 양쪽으로 이어지는 글자 4모양 + 오른쪽만 이어지는 글자 2모양.
int get totalGlyphForms => arabicLetters.fold(0, (n, l) => n + l.forms.length);

class GlyphInWord {
  final ArabicLetter letter;
  final GlyphForm form;
  const GlyphInWord(this.letter, this.form);
  String get key => '${letter.ch}:${form.name}';
}

/// 낱말 → 글자마다 지금 쓰인 모양(읽는 순서 = 오른쪽부터). ZWNJ(‌)에서 이음이 끊긴다. 모음 부호·숫자 등은 건너뛴다.
List<GlyphInWord> splitWord(String word) {
  final out = <GlyphInWord>[];
  ArabicLetter? prev;
  var brokeAfterPrev = false;
  final chars = word.runes.map(String.fromCharCode).toList();
  for (var i = 0; i < chars.length; i++) {
    final c = chars[i];
    if (c == '‌') {
      brokeAfterPrev = true;
      continue;
    }
    final l = letterOf(c);
    if (l == null) continue;
    final joinPrev = prev != null && prev.dual && !brokeAfterPrev;
    // 다음 글자가 있고 이 글자가 왼쪽으로 이어지면 앞으로 이어진다
    var joinNext = false;
    if (l.dual) {
      for (var j = i + 1; j < chars.length; j++) {
        if (chars[j] == '‌') break;
        if (letterOf(chars[j]) != null) {
          joinNext = true;
          break;
        }
      }
    }
    final form = joinPrev
        ? (joinNext ? GlyphForm.medial : GlyphForm.finalForm)
        : (joinNext ? GlyphForm.initial : GlyphForm.isolated);
    out.add(GlyphInWord(l, form));
    prev = l;
    brokeAfterPrev = false;
  }
  return out;
}

/// 문장 → 아랍 문자 낱말들(문장부호 ، ؛ ؟ 제외 — 같은 유니코드 블록이라 글자·모음 부호 범위만 남긴다).
List<String> arabicWords(String line) =>
    line.split(RegExp(r'[^\u0621-\u0652\u0670-\u06D3\u200C]+')).where((w) => w.isNotEmpty && w.runes.any((r) => letterOf(String.fromCharCode(r)) != null)).toList();
