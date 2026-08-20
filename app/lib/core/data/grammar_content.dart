/// 언어별 문법 Day 콘텐츠 디스패처.
///
/// 2026-04-24 변경: 콘텐츠를 `assets/*.md` 마크다운 파일에서 로드.
/// `GrammarRepository.loadAll()` 이 main 부트스트랩에서 호출되어 캐시됨.
/// 새 언어 추가 = `assets/N-language-Ndays.md` 파일 + GrammarRepository._files 등록.
library;

import '../services/grammar_loader.dart';

class GrammarDayInfo {
  final int day;
  final String title; // Day 칭호 (예: "Day 1: 명사 단수 6격")
  final String shortSubtitle; // 리스트 표시용 한 줄
  final List<GrammarBlock> blocks; // 렌더링용 블록 시퀀스
  const GrammarDayInfo({
    required this.day,
    required this.title,
    required this.shortSubtitle,
    required this.blocks,
  });
}

enum GrammarBlockType {
  heading, // 섹션 제목 (## 느낌)
  subheading, // 소제목 (### 느낌)
  paragraph, // 문단
  note, // 박스형 강조 (인용구)
  divider, // 구분선
  example, // 러시아어 / 독음 / 한국어 3줄 세트
  table, // 표
  placeholder, // "내용은 추후기재"
}

class GrammarBlock {
  final GrammarBlockType type;
  final String? text;
  final List<String>? lines; // example / placeholder 용
  final List<List<String>>? rows; // table 용
  final List<String>? headers; // table 헤더

  const GrammarBlock.heading(this.text)
      : type = GrammarBlockType.heading,
        lines = null,
        rows = null,
        headers = null;
  const GrammarBlock.subheading(this.text)
      : type = GrammarBlockType.subheading,
        lines = null,
        rows = null,
        headers = null;
  const GrammarBlock.paragraph(this.text)
      : type = GrammarBlockType.paragraph,
        lines = null,
        rows = null,
        headers = null;
  const GrammarBlock.note(this.text)
      : type = GrammarBlockType.note,
        lines = null,
        rows = null,
        headers = null;
  const GrammarBlock.divider()
      : type = GrammarBlockType.divider,
        text = null,
        lines = null,
        rows = null,
        headers = null;
  const GrammarBlock.example(this.lines)
      : type = GrammarBlockType.example,
        text = null,
        rows = null,
        headers = null;
  const GrammarBlock.table({required this.headers, required this.rows})
      : type = GrammarBlockType.table,
        text = null,
        lines = null;
  const GrammarBlock.placeholder()
      : type = GrammarBlockType.placeholder,
        text = '내용은 추후기재',
        lines = null,
        rows = null,
        headers = null;
}

/// 언어별 Day 리스트 디스패처. assets/*.md 에서 로드된 캐시 조회.
List<GrammarDayInfo> grammarDays(String langCode) =>
    GrammarRepository.daysFor(langCode);

/// 언어별 총 Day 수 (markdown 파일 안의 `# Day N` 개수).
int grammarTotalDaysFor(String langCode) =>
    GrammarRepository.totalDaysFor(langCode);

/// 언어별 축하(마일스톤) Day. Day 수에 따라 자동 산정.
List<int> grammarCelebrationDaysFor(String langCode) =>
    GrammarRepository.celebrationDaysFor(langCode);

