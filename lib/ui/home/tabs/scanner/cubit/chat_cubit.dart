import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/cubit/chat_state.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/model/message_mode;.dart';

class ChatCubit extends Cubit<CoachState> {
  final _service;
  ChatCubit(this._service) : super(const CoachState());

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.isSending) return;
    emit(
      state.copyWith(
        isSending: true,
        messages: [
          ...state.messages,
          ChatMessage(text: text, role: MessageRole.user),
          const ChatMessage(text: '', role: MessageRole.coach),
        ],
      ),
    );

    final token = await FirebaseAppCheck.instance.getToken(true);
    debugPrint('AppCheck token OK: ${token?.substring(0, 10)}...');

    var gotText = false;
    try {
      await for (final chunk in _service.send(text)) {
        if (isClosed) return;
        gotText = true;
        _updateLast((m) => m.copyWith(text: m.text + chunk));
      }
      if (!gotText && !isClosed) {
        _updateLast(
          (m) =>
              m.copyWith(text: 'No response. Try rephrasing.', isError: true),
        );
      }
    } catch (e) {
      debugPrint('Ai error: $e');
      debugPrint('AppCheck getToken failed: $e');
      if (isClosed) return;
      _updateLast(
        (m) =>
            m.copyWith(text: 'Something went wrong. Try again.', isError: true),
      );
    } finally {
      if (!isClosed) emit(state.copyWith(isSending: false));
    }
  }

  void _updateLast(ChatMessage Function(ChatMessage) update) {
    final list = [...state.messages];
    list[list.length - 1] = update(list.last);
    emit(state.copyWith(messages: list));
  }
}
