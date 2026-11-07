import 'package:flutter_test/flutter_test.dart';
import 'package:arabic_universe/services/dialogue_service.dart' show Lemma;
import 'package:arabic_universe/widgets/glyph_sheet.dart';

void main() {
  const lemmas = [Lemma('جنيه', 'جنيه', ''), Lemma('سوق', 'سوق', '')];

  test('꼴이 같은 낱말은 그 레마로 찾는다', () {
    expect(TappableArabicText.lemmaFor('جنيه', lemmas)?.base, 'جنيه');
  });

  test('앞의 و·ب·ال 을 떼고 찾는다', () {
    expect(TappableArabicText.lemmaFor('بالسوق', lemmas)?.base, 'سوق');
    expect(TappableArabicText.lemmaFor('والسوق', lemmas)?.base, 'سوق');
  });

  test('레마에 없는 낱말은 null', () {
    expect(TappableArabicText.lemmaFor('كتاب', lemmas), isNull);
  });
}
