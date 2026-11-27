// cubit/coach_state.dart
import 'package:pharoh_lense/ui/home/tabs/scanner/model/message_mode;.dart';

class CoachState {
  const CoachState({this.messages = const [], this.isSending = false});

  final List<ChatMessage> messages;
  final bool isSending;

  CoachState copyWith({List<ChatMessage>? messages, bool? isSending}) =>
      CoachState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
      );
}
