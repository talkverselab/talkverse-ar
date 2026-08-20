/// 사알투무니하 (سألتمونيها) — 아랍어 접사 후보 10 글자.
///
/// 이 10 자는 어근으로도 쓰일 수 있는 "이중 역할" 글자. 본 화면은
/// **접사 모드 한정** 으로 학습. 같은 글자가 어근에 등장할 수 있다는 사실은
/// 화면 하단 disclaimer 에 명시.
///
/// 출처: 우리 메모리 project_ar_menu_structure.md ·
/// project_ar_teaching_strategy.md
library;

class ArAffixLetter {
  /// 표준 (격리) 형태. 예: 'س'
  final String letter;

  /// 로마자. 예: 'S'
  final String roman;

  /// 한국어 이름. 예: '사인 (sīn)'
  final String name;

  /// 단어 첫 자리 모양 (initial). 다음 글자와 연결.
  final String initial;

  /// 단어 중간 자리 모양 (medial). 양쪽 모두 연결.
  final String medial;

  /// 단어 끝 자리 모양 (final).
  final String finalForm;

  /// 접사 모드에서의 주요 용법 bullet list.
  final List<String> usages;

  /// 다음 글자와 연결되는지. و, ا 같은 글자는 left-non-connector → false.
  /// false 이면 medial/final 도 사실상 격리 형태와 같음.
  final bool connectsLeft;

  const ArAffixLetter({
    required this.letter,
    required this.roman,
    required this.name,
    required this.initial,
    required this.medial,
    required this.finalForm,
    required this.usages,
    this.connectsLeft = true,
  });
}

class ArAlphabetData {
  ArAlphabetData._();

  /// sa'altumūnīhā 10 자 — 표준 순서 (사알투무니하 발음 순).
  static const List<ArAffixLetter> saal = [
    ArAffixLetter(
      letter: 'س',
      roman: 'S',
      name: '사인 (sīn)',
      initial: 'سـ',
      medial: 'ـسـ',
      finalForm: 'ـس',
      usages: [
        '미래 마커 (sa-) — "~할 것이다"',
        '요청 (ista-, Form X) — "~하기를 구하다"',
      ],
    ),
    ArAffixLetter(
      letter: 'أ',
      roman: 'A',
      name: '함자-알리프 (hamza)',
      initial: 'أ',
      medial: 'ـأ',
      finalForm: 'ـأ',
      connectsLeft: false,
      usages: [
        '1인칭 단수 (a-) — "내가 ~한다"',
        '사역 (Form IV) — "~하게 하다"',
        '의문문 도입 (a-) — "~입니까?"',
      ],
    ),
    ArAffixLetter(
      letter: 'ل',
      roman: 'L',
      name: '람 (lām)',
      initial: 'لـ',
      medial: 'ـلـ',
      finalForm: 'ـل',
      usages: [
        '소유·목적 (li-) — "~를 위해, ~의 것"',
        '강조 (la-) — "정말로 ~이다"',
        '정관사 ال- 의 두 번째 자음',
      ],
    ),
    ArAffixLetter(
      letter: 'ت',
      roman: 'T',
      name: '타 (tā)',
      initial: 'تـ',
      medial: 'ـتـ',
      finalForm: 'ـت',
      usages: [
        '2인칭 / 3인칭 여성 (ta-) — "네가 / 그녀가 ~한다"',
        '재귀·상태 변화 (Form V, VI) — "스스로 ~ 되다"',
        '여성 명사 어미 (-at, ة) — 대부분 여성형 표시',
      ],
    ),
    ArAffixLetter(
      letter: 'م',
      roman: 'M',
      name: '미임 (mīm)',
      initial: 'مـ',
      medial: 'ـمـ',
      finalForm: 'ـم',
      usages: [
        '장소 (ma-) — مَكْتَب maktab "사무실"',
        '도구 (mi-) — مِفْتَاح miftāḥ "열쇠"',
        '능동·수동 분사 (mu-) — مُسْلِم muslim "이슬람 신도"',
        '남성 복수 대명사 어미 (-um) — "그들"',
      ],
    ),
    ArAffixLetter(
      letter: 'و',
      roman: 'W',
      name: '와우 (wāw)',
      initial: 'و',
      medial: 'ـو',
      finalForm: 'ـو',
      connectsLeft: false,
      usages: [
        '접속사 (wa-) — "그리고"',
        '남성 복수 동사 어미 (-ū) — "그들이 ~했다"',
        '장모음 ū',
      ],
    ),
    ArAffixLetter(
      letter: 'ن',
      roman: 'N',
      name: '눈 (nūn)',
      initial: 'نـ',
      medial: 'ـنـ',
      finalForm: 'ـن',
      usages: [
        '1인칭 복수 (na-) — "우리가 ~한다"',
        '비한정 어미 탄윈 (-un / -an / -in) — "어떤 ~"',
        '여성 복수 대명사 어미 (-na)',
      ],
    ),
    ArAffixLetter(
      letter: 'ي',
      roman: 'Y',
      name: '야 (yā)',
      initial: 'يـ',
      medial: 'ـيـ',
      finalForm: 'ـي',
      usages: [
        '3인칭 남성 (ya-) — "그가 ~한다"',
        '소유 접미사 (-ī) — "나의 (my)"',
        '국적·관계 형용사 (-ī) — "~의, ~사람"',
        '장모음 ī',
      ],
    ),
    ArAffixLetter(
      letter: 'ه',
      roman: 'H',
      name: '하 (hā)',
      initial: 'هـ',
      medial: 'ـهـ',
      finalForm: 'ـه',
      usages: [
        '대명사 접미사 -hu — "그의 (his) / 그를 (him)"',
        '대명사 접미사 -hā — "그녀의 (her) / 그녀를"',
      ],
    ),
    ArAffixLetter(
      letter: 'ا',
      roman: 'A',
      name: '알리프 (alif)',
      initial: 'ا',
      medial: 'ـا',
      finalForm: 'ـا',
      connectsLeft: false,
      usages: [
        '정관사 ال- (al-) — "그 (the)"',
        '쌍수 어미 (-ā) — "두 개의 ~"',
        '명령형 도입 — "~ 하라!"',
        '장모음 ā',
      ],
    ),
  ];
}
