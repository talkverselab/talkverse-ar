import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../data/favorite_words.dart';
import '../data/word_data.dart';
import '../models/word.dart';
import '../theme/app_colors.dart';
import '../widgets/marked_text.dart';
import 'flashcard_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteWords();
    final favIds = favorites.all;
    final items = allItems.where((w) => favIds.contains(w.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('⭐ 다시 외우기',
            style: GoogleFonts.notoSans(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          if (items.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const FlashCardScreen(favoritesMode: true)),
                );
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.play_arrow, size: 18),
              label: Text('학습',
                  style: GoogleFonts.notoSans(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              style: TextButton.styleFrom(
                foregroundColor: AppConfig.brandColor,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📒', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    Text('저장된 단어가 없어요',
                        style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('플래시카드에서 ♡를 눌러 추가하세요',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final w = items[index];
                return _FavoriteCard(
                  word: w,
                  onRemove: () async {
                    await favorites.toggle(w.id);
                    if (mounted) setState(() {});
                  },
                );
              },
            ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Word word;
  final VoidCallback onRemove;

  const _FavoriteCard({required this.word, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final segments = parseMarkers(word.targetForCurrent);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkedText(
                  segments: segments,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2),
                Text(
                  '${word.korean}  ·  ${word.romanizationForCurrent}',
                  style: GoogleFonts.notoSans(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${word.category}  ·  ${AppConfig.courseDisplayName(word.course)}',
                  style: GoogleFonts.notoSans(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.favorite, color: AppColors.danger),
            tooltip: '단어장에서 제거',
          ),
        ],
      ),
    );
  }
}
