import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arabic_universe/screens/curriculum_screen.dart';
import 'package:arabic_universe/services/curriculum_service.dart';

void main() {
  for (final (name, w) in [('폰 390', 390.0), ('좁은 칸 300', 300.0)]) {
    testWidgets('코스 고르기 줄이 넘치지 않음 · $name', (t) async {
      SharedPreferences.setMockInitialValues({});
      await t.binding.setSurfaceSize(Size(w, 800));
      addTearDown(() => t.binding.setSurfaceSize(null));
      await t.runAsync(() => CurriculumService.instance.ensureLoaded());
      CurriculumService.instance.state = CurriculumState(level: 'R1');
      await t.pumpWidget(const MaterialApp(home: CurriculumScreen()));
      await t.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
      await t.pump();
      expect(find.text('추천으로 채우기'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  }
}
