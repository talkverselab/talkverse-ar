import 'package:flutter/services.dart' show rootBundle;

import '../data/grammar_content.dart';

/// 언어별 markdown 문법 파일을 로드·파싱해 [GrammarDayInfo] 리스트로 캐싱.
///
/// 사용 흐름:
///   1. main() 부트스트랩에서 [loadAll] 호출 (앱 시작 시 1회).
///   2. [daysFor] 로 sync 조회 (UI는 FutureBuilder 불필요).
///
/// 마크다운 규칙:
///   * `# Day N — Title` → 새 day 시작 (N 추출, Title 캡처)
///   * 첫 `# Day` 이전 내용은 preamble (현재 무시)
///   * `## ...` → heading / `### ...` → subheading
///   * `> text` → note (연속 줄 합침)
///   * `---` → divider
///   * `| h1 | h2 |` + `|---|---|` + `| r1 | r2 |` → table
///   * 그 외 텍스트 = paragraph (연속 줄 합침)
class GrammarRepository {
  GrammarRepository._();

  static final Map<String, List<GrammarDayInfo>> _cache = {};

  /// 언어 코드 → asset 파일명. 새 언어 추가 시 여기에만 등록.
  static const Map<String, String> _files = {
    'ru': '01-russian-10day.md',
    'de': '02-german-6day.md',
    'vi': '03-vietnamese-5day.md',
    'es': '04-spanish-6day.md',
    'ja': '05-japanese-6day.md',
    'id': '06-indonesian-6day.md',
    'fr': '07-french-6day.md',
    'tr': '08-turkish-6day.md',
    'ar': '09-arabic-8day.md',
    'pt': '10-portuguese-6day.md',
    'th': '11-thai-5day.md',
    'uk': '12-ukrainian-5day.md',
    'pl': '13-polish-8day.md',
    'zh': '14-chinese-6day.md',
  };

  /// 특정 언어의 markdown 하나만 로드·파싱. 부트스트랩에서 현재 언어만 호출.
  /// 나머지 언어는 [ensureLoaded]로 lazy load (언어 전환 시).
  ///
  /// 14개 파일을 동시에 파싱하면 main thread 블록 (ANR) 위험.
  static Future<void> loadForLanguage(String langCode) async {
    if (_cache.containsKey(langCode)) return; // 이미 로드됨
    final file = _files[langCode];
    if (file == null) {
      _cache[langCode] = const [];
      return;
    }
    try {
      final content = await rootBundle.loadString('assets/$file');
      _cache[langCode] = _parseMarkdown(content);
    } catch (_) {
      _cache[langCode] = const [];
    }
  }

  /// 특정 언어가 로드됐는지 확인·필요하면 로드. 언어 전환 시점에 호출.
  static Future<void> ensureLoaded(String langCode) =>
      loadForLanguage(langCode);

  /// 동기 조회. 로드 안 된 언어는 빈 리스트 반환.
  /// UI가 이 함수를 호출하기 전에 [loadForLanguage] 완료됐어야 함.
  static List<GrammarDayInfo> daysFor(String langCode) =>
      _cache[langCode] ?? const [];

  /// 총 Day 수 (UI 진행률 계산용).
  static int totalDaysFor(String langCode) => daysFor(langCode).length;

  /// 마일스톤 축하 day. Day 수에 따라 자동 결정 (1/3, 2/3 지점).
  static List<int> celebrationDaysFor(String langCode) {
    final n = totalDaysFor(langCode);
    if (n <= 0) return const [];
    if (n <= 4) return [n]; // 마지막만
    if (n == 5) return const [3, 5];
    if (n == 6) return const [3, 6];
    if (n <= 8) return [(n / 2).round(), n];
    return [3, (n * 0.6).round(), n - 1];
  }
}

// ============================================================
// Markdown parser — 단순 라인 베이스. 날짜 헤더 1개만 인식.
// ============================================================

final RegExp _dayHeaderRegex = RegExp(r'^#\s+Day\s+(\d+)\s*[—\-:]?\s*(.*)$');
final RegExp _h2Regex = RegExp(r'^##\s+(.+)$');
final RegExp _h3Regex = RegExp(r'^###\s+(.+)$');
final RegExp _noteRegex = RegExp(r'^>\s?(.*)$');
final RegExp _dividerRegex = RegExp(r'^---+$');
final RegExp _tableRowRegex = RegExp(r'^\|.+\|$');
final RegExp _tableSepRegex = RegExp(r'^\|[\s\-:|]+\|$');

List<GrammarDayInfo> _parseMarkdown(String text) {
  final lines = text.split('\n').map((l) => l.trimRight()).toList();

  // 1단계: Day 경계 추출.
  final dayStarts = <_DayStart>[];
  for (int i = 0; i < lines.length; i++) {
    final m = _dayHeaderRegex.firstMatch(lines[i]);
    if (m != null) {
      dayStarts.add(_DayStart(
        lineIndex: i,
        dayNumber: int.parse(m.group(1)!),
        rawTitle: m.group(2)!.trim(),
      ));
    }
  }

  if (dayStarts.isEmpty) return const [];

  // 2단계: 각 Day 구간을 파싱.
  final result = <GrammarDayInfo>[];
  for (int d = 0; d < dayStarts.length; d++) {
    final start = dayStarts[d].lineIndex + 1;
    final end =
        d + 1 < dayStarts.length ? dayStarts[d + 1].lineIndex : lines.length;
    final blocks = _parseBlocks(lines.sublist(start, end));
    final shortTitle = dayStarts[d].rawTitle.isEmpty
        ? '진행'
        : dayStarts[d].rawTitle;
    result.add(GrammarDayInfo(
      day: dayStarts[d].dayNumber,
      title:
          'Day ${dayStarts[d].dayNumber.toString().padLeft(2, '0')}: ${dayStarts[d].rawTitle}',
      shortSubtitle: shortTitle,
      blocks: blocks,
    ));
  }
  return result;
}

class _DayStart {
  final int lineIndex;
  final int dayNumber;
  final String rawTitle;
  _DayStart({
    required this.lineIndex,
    required this.dayNumber,
    required this.rawTitle,
  });
}

List<GrammarBlock> _parseBlocks(List<String> lines) {
  final blocks = <GrammarBlock>[];
  int i = 0;
  while (i < lines.length) {
    final line = lines[i];
    if (line.isEmpty) {
      i++;
      continue;
    }

    // Divider
    if (_dividerRegex.hasMatch(line)) {
      blocks.add(const GrammarBlock.divider());
      i++;
      continue;
    }

    // H3 subheading
    final m3 = _h3Regex.firstMatch(line);
    if (m3 != null) {
      blocks.add(GrammarBlock.subheading(_clean(m3.group(1)!)));
      i++;
      continue;
    }

    // H2 heading
    final m2 = _h2Regex.firstMatch(line);
    if (m2 != null) {
      blocks.add(GrammarBlock.heading(_clean(m2.group(1)!)));
      i++;
      continue;
    }

    // Note (>): consume consecutive > lines.
    if (_noteRegex.hasMatch(line)) {
      final buf = <String>[];
      while (i < lines.length && _noteRegex.hasMatch(lines[i])) {
        buf.add(_noteRegex.firstMatch(lines[i])!.group(1)!.trim());
        i++;
      }
      blocks.add(GrammarBlock.note(_clean(buf.join(' '))));
      continue;
    }

    // Table: header row + separator + body rows.
    if (_tableRowRegex.hasMatch(line) &&
        i + 1 < lines.length &&
        _tableSepRegex.hasMatch(lines[i + 1])) {
      final headers = _splitRow(line);
      i += 2; // skip header + separator
      final rows = <List<String>>[];
      while (i < lines.length && _tableRowRegex.hasMatch(lines[i])) {
        rows.add(_splitRow(lines[i]));
        i++;
      }
      blocks.add(GrammarBlock.table(headers: headers, rows: rows));
      continue;
    }

    // Paragraph: consume consecutive non-empty non-special lines.
    final pBuf = <String>[];
    final startI = i;
    while (i < lines.length &&
        lines[i].isNotEmpty &&
        !_dividerRegex.hasMatch(lines[i]) &&
        !_h2Regex.hasMatch(lines[i]) &&
        !_h3Regex.hasMatch(lines[i]) &&
        !_noteRegex.hasMatch(lines[i]) &&
        !_tableRowRegex.hasMatch(lines[i])) {
      pBuf.add(lines[i].trim());
      i++;
    }
    if (pBuf.isNotEmpty) {
      blocks.add(GrammarBlock.paragraph(_clean(pBuf.join(' '))));
    }
    // 무한 루프 방어: paragraph도 아니고 어떤 분기도 안 먹은 라인이면 강제 진행.
    // (예: '|col|' 형태인데 다음 줄이 separator 아닌 경우 — 표 안 됨.)
    if (i == startI) {
      // 현재 라인을 paragraph로 강제 변환하고 진행.
      blocks.add(GrammarBlock.paragraph(_clean(lines[i].trim())));
      i++;
    }
  }
  return blocks;
}

List<String> _splitRow(String line) {
  // Strip leading/trailing | and split.
  final trimmed = line.trim();
  final inner = trimmed.substring(1, trimmed.length - 1);
  return inner.split('|').map((c) => _clean(c.trim())).toList();
}

/// Markdown emphasis 제거 — `**bold**`, `*italic*`, `` `code` `` 정도만.
/// 본격 마크다운 렌더는 안 하고 평문화. UI 위젯이 단순.
String _clean(String s) {
  return s
      .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1')
      .replaceAll(RegExp(r'(?<!\*)\*([^*]+)\*(?!\*)'), r'$1')
      .replaceAll(RegExp(r'`([^`]+)`'), r'$1');
}
