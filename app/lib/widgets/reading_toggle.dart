import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/theme.dart';
import '../services/learner_prefs.dart';

/// 독음 표시/미표시 버튼(앱바용) — 전역 `LearnerPrefs.reading` 하나를 바꾼다. 기본 미표시.
/// 표시로 켤 때 「힘들어도 독음을 보지 않고 익혀보세요」를 알린다(일본어앱 후리가나 토글의 아랍어판, 2026-11-07).
class ReadingToggleAction extends StatelessWidget {
  const ReadingToggleAction({super.key});

  static Future<void> toggle(BuildContext context) async {
    final on = !LearnerPrefs.reading.value;
    await LearnerPrefs.setReading(on);
    if (on && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(tr('힘들어도 독음을 보지 않고 익혀보세요')),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.sumi,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return ValueListenableBuilder<bool>(
      valueListenable: LearnerPrefs.reading,
      builder: (context, on, _) {
        final color = on ? AppColors.ai : base.withValues(alpha: 0.35);
        return IconButton(
          tooltip: on ? tr('독음 숨기기') : tr('독음 표시'),
          onPressed: () => toggle(context),
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: color, width: 1.2), borderRadius: BorderRadius.circular(6)),
            child: Text('가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color, decoration: on ? null : TextDecoration.lineThrough)),
          ),
        );
      },
    );
  }
}
