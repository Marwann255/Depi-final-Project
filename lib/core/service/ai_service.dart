import 'package:firebase_ai/firebase_ai.dart';

class AiService {
  AiService()
    : _chat = FirebaseAI.googleAI()
          .generativeModel(
            model: 'gemini-3.5-flash-lite',
            generationConfig: GenerationConfig(
              thinkingConfig: ThinkingConfig.withThinkingLevel(
                ThinkingLevel.medium,
              ),
              // maxOutputTokens: 600,
            ),
            systemInstruction: Content.system(
              'You are an ancient Egyptian statues and artifacts guide. '
              'reply to the user within the chat context of his choice.'
              '(dynasty, date, material, museum, objectId). '
              'never guess a pharaoh, name, or date. '
              'Mention scholarly disagreement when dating or attribution is uncertain. '
              'Discuss only ancient Egypt and the object in the photo; politely decline anything else. '
              'Do not advise on buying, selling, or exporting antiquities, and do not promote other apps. '
              'Reply in the user\'s language (Arabic or English). '
              'Keep answers short (3-5 sentences) and end with "Source: The Met, objectId <id>" when you used a record.',
            ),
          )
          .startChat();

  final ChatSession _chat;

  /// Yields text chunks as the model generates them.
  Stream<String> send(String text) async* {
    await for (final chunk in _chat.sendMessageStream(Content.text(text))) {
      final t = chunk.text;
      if (t != null && t.isNotEmpty) yield t;
    }
  }
}
