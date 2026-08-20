/// L2 채팅 dialogue 데이터 모델.
///
/// JSON 구조 (assets/conversation_chat_vi/chat_north.json):
/// ```json
/// {
///   "title": "Level 2 ...",
///   "dialect": "north",
///   "dialogues": [
///     {"id": 1, "title": "...", "tag": "friend-friend",
///      "header": "...", "turns": [{"turn": 1, "speaker": "A", "vi": "...",
///      "pron": "...", "ko": "...", "key": "..."}, ...]},
///     ...
///   ]
/// }
/// ```
class ChatDialogue {
  final int id;
  final String title;
  /// "friend-friend" | "scenario"
  final String tag;
  /// 시나리오 적용 시 호칭 시나리오 번호 (1-5). null = 친구-친구.
  final String? addressScenario;
  final String header;
  final List<ChatTurn> turns;

  const ChatDialogue({
    required this.id,
    required this.title,
    required this.tag,
    this.addressScenario,
    required this.header,
    required this.turns,
  });

  factory ChatDialogue.fromJson(Map<String, dynamic> json) {
    return ChatDialogue(
      id: json['id'] as int,
      title: json['title'] as String,
      tag: json['tag'] as String? ?? 'friend-friend',
      addressScenario: json['address_scenario'] as String?,
      header: json['header'] as String? ?? '',
      turns: (json['turns'] as List)
          .cast<Map<String, dynamic>>()
          .map(ChatTurn.fromJson)
          .toList(),
    );
  }

  bool get hasPlaceholder => tag == 'scenario' && turns.any((t) =>
      t.vi.contains('{ME}') || t.vi.contains('{YOU}'));
}

class ChatTurn {
  final int turn;
  /// "A" (학습자) or "B" (상대).
  final String speaker;
  final String vi;
  final String pron;
  final String ko;
  final String key;

  const ChatTurn({
    required this.turn,
    required this.speaker,
    required this.vi,
    required this.pron,
    required this.ko,
    required this.key,
  });

  factory ChatTurn.fromJson(Map<String, dynamic> json) {
    return ChatTurn(
      turn: json['turn'] as int,
      speaker: json['speaker'] as String,
      vi: json['vi'] as String,
      pron: json['pron'] as String? ?? '',
      ko: json['ko'] as String? ?? '',
      key: json['key'] as String? ?? '',
    );
  }
}
