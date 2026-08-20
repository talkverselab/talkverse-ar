/// 접사게임 초급 — 가장 generative 한 명사 파생 패턴 5 개.
///
/// 동사 10 forms (Form II~X) 는 advanced 메뉴 (조사와변화, 미정) 로 분리.
/// 본 5 패턴 = 한 어근에서 일상 단어 1~2 개를 즉시 생성하는 명사 파생만.
///
/// 출처: 메모리 project_ar_menu_structure.md (사용자 결정)
library;

import 'package:flutter/material.dart';

class ArDerivation {
  /// 어근 자음 3 자 (로마자 ASCII 형). 예: 'K-T-B'
  final String rootRoman;

  /// 어근 자음 3 자 (아랍어). 예: 'ك-ت-ب'
  final String rootArabic;

  /// 어근 의미. 예: '쓰다'
  final String rootMeaning;

  /// 파생 단어 (해라카트 포함). 예: 'مَكْتَب'
  final String derived;

  /// 파생 단어 로마자. 예: 'maktab'
  final String derivedRoman;

  /// 파생 단어 한국어 의미. 예: '사무실'
  final String derivedMeaning;

  const ArDerivation({
    required this.rootRoman,
    required this.rootArabic,
    required this.rootMeaning,
    required this.derived,
    required this.derivedRoman,
    required this.derivedMeaning,
  });
}

class ArAffixPattern {
  /// 식별자. 예: 'place'
  final String id;

  /// 한국어 이름. 예: '장소'
  final String nameKo;

  /// 짧은 부제. 예: '~하는 곳'
  final String subtitle;

  /// 패턴 모양 (해라카트 포함). 예: 'مَفْعَل'
  final String pattern;

  /// 패턴 로마자 (자리표시자 C₁/C₂/C₃ 사용). 예: 'maC₁C₂aC₃'
  final String patternRoman;

  /// 색상 (root=빨강 / pattern·affix=파랑·노랑·초록 등 가짓수)
  final Color color;

  /// 아이콘
  final IconData icon;

  /// 예시 파생어 3 개.
  final List<ArDerivation> examples;

  const ArAffixPattern({
    required this.id,
    required this.nameKo,
    required this.subtitle,
    required this.pattern,
    required this.patternRoman,
    required this.color,
    required this.icon,
    required this.examples,
  });
}

class ArAffixPatterns {
  ArAffixPatterns._();

  /// 초급 5 패턴 — 명사 파생 한정. 한 어근에서 일상 단어 즉시 생성.
  static const List<ArAffixPattern> beginner5 = [
    ArAffixPattern(
      id: 'place',
      nameKo: '장소',
      subtitle: '~하는 곳',
      pattern: 'مَفْعَل',
      patternRoman: 'maC₁C₂aC₃',
      color: Color(0xFFE53935), // red
      icon: Icons.place_outlined,
      examples: [
        ArDerivation(
          rootRoman: 'K-T-B',
          rootArabic: 'ك-ت-ب',
          rootMeaning: '쓰다',
          derived: 'مَكْتَب',
          derivedRoman: 'maktab',
          derivedMeaning: '사무실 / 책상',
        ),
        ArDerivation(
          rootRoman: 'L-ʿ-B',
          rootArabic: 'ل-ع-ب',
          rootMeaning: '놀다',
          derived: 'مَلْعَب',
          derivedRoman: 'malʿab',
          derivedMeaning: '운동장',
        ),
        ArDerivation(
          rootRoman: 'D-Kh-L',
          rootArabic: 'د-خ-ل',
          rootMeaning: '들어가다',
          derived: 'مَدْخَل',
          derivedRoman: 'madkhal',
          derivedMeaning: '입구',
        ),
      ],
    ),
    ArAffixPattern(
      id: 'tool',
      nameKo: '도구',
      subtitle: '~하는 데 쓰는 물건',
      pattern: 'مِفْعَال',
      patternRoman: 'miC₁C₂āC₃',
      color: Color(0xFFF9A825), // amber
      icon: Icons.build_outlined,
      examples: [
        ArDerivation(
          rootRoman: 'F-T-Ḥ',
          rootArabic: 'ف-ت-ح',
          rootMeaning: '열다',
          derived: 'مِفْتَاح',
          derivedRoman: 'miftāḥ',
          derivedMeaning: '열쇠',
        ),
        ArDerivation(
          rootRoman: 'N-Sh-R',
          rootArabic: 'ن-ش-ر',
          rootMeaning: '자르다 / 펴다',
          derived: 'مِنْشَار',
          derivedRoman: 'minshār',
          derivedMeaning: '톱',
        ),
        ArDerivation(
          rootRoman: 'K-N-S',
          rootArabic: 'ك-ن-س',
          rootMeaning: '쓸다',
          derived: 'مِكْنَاس',
          derivedRoman: 'miknās',
          derivedMeaning: '빗자루',
        ),
      ],
    ),
    ArAffixPattern(
      id: 'doer',
      nameKo: '행위자',
      subtitle: '~하는 사람 (능동분사)',
      pattern: 'فَاعِل',
      patternRoman: 'C₁āC₂iC₃',
      color: Color(0xFF1E88E5), // blue
      icon: Icons.person_outline,
      examples: [
        ArDerivation(
          rootRoman: 'K-T-B',
          rootArabic: 'ك-ت-ب',
          rootMeaning: '쓰다',
          derived: 'كَاتِب',
          derivedRoman: 'kātib',
          derivedMeaning: '작가 / 쓰는 사람',
        ),
        ArDerivation(
          rootRoman: 'ʿ-M-L',
          rootArabic: 'ع-م-ل',
          rootMeaning: '일하다',
          derived: 'عَامِل',
          derivedRoman: 'ʿāmil',
          derivedMeaning: '노동자',
        ),
        ArDerivation(
          rootRoman: 'L-ʿ-B',
          rootArabic: 'ل-ع-ب',
          rootMeaning: '놀다',
          derived: 'لَاعِب',
          derivedRoman: 'lāʿib',
          derivedMeaning: '선수 / 노는 사람',
        ),
      ],
    ),
    ArAffixPattern(
      id: 'object',
      nameKo: '대상',
      subtitle: '~된 것 (수동분사)',
      pattern: 'مَفْعُول',
      patternRoman: 'maC₁C₂ūC₃',
      color: Color(0xFF43A047), // green
      icon: Icons.inventory_2_outlined,
      examples: [
        ArDerivation(
          rootRoman: 'K-T-B',
          rootArabic: 'ك-ت-ب',
          rootMeaning: '쓰다',
          derived: 'مَكْتُوب',
          derivedRoman: 'maktūb',
          derivedMeaning: '쓰인 것 / 편지 / 운명',
        ),
        ArDerivation(
          rootRoman: 'F-T-Ḥ',
          rootArabic: 'ف-ت-ح',
          rootMeaning: '열다',
          derived: 'مَفْتُوح',
          derivedRoman: 'maftūḥ',
          derivedMeaning: '열린',
        ),
        ArDerivation(
          rootRoman: 'F-H-M',
          rootArabic: 'ف-ه-م',
          rootMeaning: '이해하다',
          derived: 'مَفْهُوم',
          derivedRoman: 'mafhūm',
          derivedMeaning: '이해된 것 / 개념',
        ),
      ],
    ),
    ArAffixPattern(
      id: 'concept',
      nameKo: '추상명사 / 직업',
      subtitle: '~하기 / ~업',
      pattern: 'فِعَالَة',
      patternRoman: 'C₁iC₂āC₃a',
      color: Color(0xFF8E24AA), // purple
      icon: Icons.psychology_outlined,
      examples: [
        ArDerivation(
          rootRoman: 'K-T-B',
          rootArabic: 'ك-ت-ب',
          rootMeaning: '쓰다',
          derived: 'كِتَابَة',
          derivedRoman: 'kitāba',
          derivedMeaning: '글쓰기 / 필기',
        ),
        ArDerivation(
          rootRoman: 'T-J-R',
          rootArabic: 'ت-ج-ر',
          rootMeaning: '거래하다',
          derived: 'تِجَارَة',
          derivedRoman: 'tijāra',
          derivedMeaning: '무역 / 상업',
        ),
        ArDerivation(
          rootRoman: 'Z-R-ʿ',
          rootArabic: 'ز-ر-ع',
          rootMeaning: '심다',
          derived: 'زِرَاعَة',
          derivedRoman: 'zirāʿa',
          derivedMeaning: '농업',
        ),
      ],
    ),
  ];
}
