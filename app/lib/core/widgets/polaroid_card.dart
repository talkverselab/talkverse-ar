import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 사용자 결정 2026-05-09: 플래시카드 성조 표시 제거 — vi_tone / tone_curve import 미사용.
// import '../utils/vi_tone.dart';
// import 'tone_curve.dart';

/// 폴라로이드 플래시카드 (시안 Variant C — `assets/UXUI/flashcard/flashcard-variants.jsx`).
///
/// 흰색 폴라로이드 프레임 + 안쪽 cream 사진 영역. 한국어 → 베트남어 학습 카드.
/// Front: 큰 따옴표 + 한국어 텍스트 + "TAP TO REVEAL"
/// Back: tone curves + 큰 VI + 독음 + 점선 위 note + 독음 토글 버튼
const _fcInk = Color(0xFF1F3A6E);
const _fcCream = Color(0xFFFBF6EE);
const _fcCreamDeep = Color(0xFFF4EDE0);

class PolaroidFront extends StatelessWidget {
  final String text; // 한국어
  final VoidCallback? onTap;
  const PolaroidFront({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _PolaroidFrame(
        bottomPadding: 64,
        child: Container(
          decoration: BoxDecoration(
            color: _fcCream,
            borderRadius: BorderRadius.circular(2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Stack(
            children: [
              // 좌상단 큰 따옴표
              Positioned(
                left: 0,
                top: 0,
                child: Text(
                  '“',
                  style: GoogleFonts.notoSerif(
                    fontSize: 42,
                    height: 0.8,
                    color: _fcInk.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // 우하단 닫는 따옴표
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  '”',
                  style: GoogleFonts.notoSerif(
                    fontSize: 42,
                    height: 0.8,
                    color: _fcInk.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // 사용자 결정 2026-05-09: FittedBox 제거 + 한국어 글꼴 24→36, 자동 줄바꿈.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.notoSans(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: _fcInk,
                      height: 1.4,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: -22,
                child: Text(
                  'TAP TO REVEAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0x801F3A6E), // _fcInk @ 0.5
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PolaroidBack extends StatelessWidget {
  final String vi;
  final String pron;
  final String note;
  final String dialect; // 'north' | 'south'
  final bool showReading;
  final bool showTones;
  final VoidCallback? onTap;
  final VoidCallback? onToggleReading;
  const PolaroidBack({
    super.key,
    required this.vi,
    required this.pron,
    required this.note,
    required this.dialect,
    this.showReading = true,
    this.showTones = true,
    this.onTap,
    this.onToggleReading,
  });

  @override
  Widget build(BuildContext context) {
    // 사용자 결정 2026-05-09: 플래시카드에서 성조 표시 일단 제거.
    // 이유: 문장 길어지면 곡선 줄이 엉망 — 차후 줄별 표시 등 재설계 필요.

    return GestureDetector(
      onTap: onTap,
      child: _PolaroidFrame(
        bottomPadding: 56,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _fcCreamDeep,
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 사용자 결정 2026-05-09: 글꼴 2.5배 (20→50), FittedBox 제거,
                  // 자동 줄바꿈 (softWrap=true, maxLines unlimited) + 카드 자동 확장.
                  Text(
                    vi,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.notoSans(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: _fcInk,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (showReading && pron.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      pron,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _fcInk.withValues(alpha: 0.55),
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (note.isNotEmpty) const SizedBox(height: 16),
                  // dashed border 위 note
                  if (note.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0x331F3A6E), // _fcInk @ 0.2
                            width: 1,
                            style: BorderStyle.solid, // Flutter 단점: dashed 미지원, solid로
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                      child: Text(
                        note,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _fcInk.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 우하단 독음 토글 버튼
            if (onToggleReading != null)
              Positioned(
                right: 0,
                bottom: -28,
                child: GestureDetector(
                  onTap: () => onToggleReading!(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: _fcInk.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      showReading ? '독음 끄기' : '독음 켜기',
                      style: GoogleFonts.notoSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _fcInk.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PolaroidFrame extends StatelessWidget {
  final Widget child;
  final double bottomPadding;
  const _PolaroidFrame({required this.child, this.bottomPadding = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x241F3A6E),
            offset: Offset(0, 6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Color(0x2D1F3A6E),
            offset: Offset(0, 20),
            blurRadius: 40,
          ),
          BoxShadow(
            color: Color(0x1A1F3A6E),
            offset: Offset(0, 32),
            blurRadius: 64,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(18, 18, 18, bottomPadding),
      child: child,
    );
  }
}
