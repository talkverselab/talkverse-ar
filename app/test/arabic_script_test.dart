import 'package:arabic_universe/services/arabic_script.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('بيت — 앞·가운데·끝', () {
    final p = splitWord('بيت');
    expect(p.map((g) => g.letter.ch).join(), 'بيت');
    expect(p.map((g) => g.form).toList(), [GlyphForm.initial, GlyphForm.medial, GlyphForm.finalForm]);
  });

  test('오른쪽만 이어지는 글자 뒤에서는 새로 시작', () {
    // كتاب: ك(앞) ت(가운데) ا(끝) ب(홀로)
    expect(splitWord('كتاب').map((g) => g.form).toList(),
        [GlyphForm.initial, GlyphForm.medial, GlyphForm.finalForm, GlyphForm.isolated]);
    // مدرسة: م(앞) د(끝) ر(홀로) س(앞) ة(끝)
    expect(splitWord('مدرسة').map((g) => g.form).toList(),
        [GlyphForm.initial, GlyphForm.finalForm, GlyphForm.isolated, GlyphForm.initial, GlyphForm.finalForm]);
  });

  test('함자 붙은 알리프는 ا 로 센다', () {
    final p = splitWord('أنا');
    expect(p.map((g) => g.letter.ch).join(), 'انا');
    expect(p.map((g) => g.form).toList(), [GlyphForm.isolated, GlyphForm.initial, GlyphForm.finalForm]);
  });

  test('분모 = 22×4 + 8×2', () => expect(totalGlyphForms, 104));

  test('문장 → 낱말', () => expect(arabicWords('أهلاً! إزيك؟'), ['أهلاً', 'إزيك']));
}
