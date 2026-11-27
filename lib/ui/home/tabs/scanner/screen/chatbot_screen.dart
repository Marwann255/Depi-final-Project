import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharoh_lense/core/service/ai_service.dart';
import 'package:pharoh_lense/core/utils/buildcontext_extensions.dart';
import 'package:pharoh_lense/core/widgets/custome_text_form_field.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/cubit/chat_cubit.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/cubit/chat_state.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/widgets/bouncing_dots.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _CatbotScreenState();
}

class _CatbotScreenState extends State<ChatbotScreen> {
  late final ChatCubit _cubit = ChatCubit(AiService());
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _scroll.dispose();
    _cubit.close();
    super.dispose();
  }

  void _scrollToEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  });
  void _submit() {
    _cubit.send(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: context.theme.colorScheme.secondary,
            ),
          ),
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                context.theme.colorScheme.primary,
                context.theme.colorScheme.secondary,
              ],
              begin: AlignmentGeometry.topRight,
              end: AlignmentGeometry.bottomLeft,
            ).createShader(bounds),
            child: Text('Ai Tour Guide', style: context.texttheme.titleLarge),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, CoachState>(
                listenWhen: (p, c) => p.messages != c.messages,
                listener: (_, __) => _scrollToEnd(),
                builder: (context, state) => ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (_, i) {
                    final m = state.messages[i];
                    return Align(
                      alignment: m.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: m.isError
                              ? Colors.red
                              : m.isUser
                              ? context.theme.colorScheme.primary
                              : context.theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: m.text.isEmpty
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: BouncingDots(
                                  size: 3.5,
                                  color: context.theme.colorScheme.primary,
                                ),
                                // CircularProgressIndicator(
                                //   strokeWidth: 2,
                                // ),
                              )
                            : Text(
                                m.text,
                                style: TextStyle(
                                  color: m.isUser
                                      ? context.theme.colorScheme.onPrimary
                                      : context
                                            .theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: BlocSelector<ChatCubit, CoachState, bool>(
                  selector: (s) => s.isSending,
                  builder: (context, sending) => Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          hintText: 'Ask your Coach',
                          onSubmitted: (p0) => _submit(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: sending ? null : _submit,
                            icon: Icon(
                              Icons.send,
                              color:
                                  context.theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
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
