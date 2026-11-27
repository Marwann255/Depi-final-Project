enum MessageRole { user, coach }

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.role,
    this.isError = false,
  });

  final String text;
  final MessageRole role;
  final bool isError;

  bool get isUser => role == MessageRole.user;

  ChatMessage copyWith({String? text, bool? isError}) => ChatMessage(
    text: text ?? this.text,
    role: role,
    isError: isError ?? this.isError,
  );

  Map<String, dynamic> toMap() => {'text': text, 'role': role.name};

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    text: map['text'] as String,
    role: MessageRole.values.byName(map['role'] as String),
  );
}
