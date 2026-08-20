import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/word_data.dart' as word_data;
import '../models/word.dart';
import '../services/subscription_service.dart';
import '../services/sync_service.dart';
import '../supabase/supabase_service.dart';
import '../theme/app_colors.dart';

/// 관리자 전용 — 항목의 dev `comment` 메모 편집기.
///
/// long-press 콜백에서 [showMemoEditor]를 호출하면:
///   1) [SubscriptionService.isAdmin] 체크 (false면 조용히 no-op)
///   2) 다이얼로그 표시 (현재 comment 초기값)
///   3) 저장 시: Drift 업데이트 → Supabase update → in-memory cache 갱신
///
/// 출시 전엔 Supabase 한 줄로 일괄 삭제:
///   `update public.items set comment = '' where language_code = 'ru';`
Future<void> showMemoEditor(BuildContext context, Word word) async {
  if (!SubscriptionService.instance.isAdmin) return;

  final controller = TextEditingController(text: word.comment);
  final newComment = await showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.sticky_note_2_outlined,
                size: 20, color: AppColors.warning),
            const SizedBox(width: 8),
            Text('개발자 메모',
                style: GoogleFonts.notoSans(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.targetPlainForCurrent,
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              word.korean,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 4,
              minLines: 2,
              decoration: InputDecoration(
                hintText: '검수 사항, 톤 메모, TODO 등 (출시 전 일괄 삭제)',
                hintStyle: GoogleFonts.notoSans(
                    fontSize: 12, color: AppColors.textMuted),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              style: GoogleFonts.notoSans(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              'id: ${word.id}',
              style: GoogleFonts.notoSans(
                  fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('저장'),
          ),
        ],
      );
    },
  );

  if (newComment == null) return; // cancelled
  if (newComment == word.comment) return; // unchanged

  // Local first (instant), Supabase after.
  try {
    await SupabaseService.instance.db.updateItemComment(word.id, newComment);
    word_data.updateLocalComment(word.id, newComment);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('로컬 저장 실패: $e',
            style: GoogleFonts.notoSans(color: Colors.white)),
        backgroundColor: AppColors.danger,
      ),
    );
    return;
  }

  try {
    await SyncService.instance.pushItemComment(word.id, newComment);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('메모 저장 완료',
            style: GoogleFonts.notoSans(color: Colors.white)),
        backgroundColor: AppColors.successDark,
        duration: const Duration(seconds: 1),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    // Local kept, Supabase failed — surface so admin can retry.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Supabase 동기화 실패 (로컬은 저장됨): $e',
            style: GoogleFonts.notoSans(color: Colors.white)),
        backgroundColor: AppColors.warning,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
