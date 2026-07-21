import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/error/backend_error_code_translator.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../data/models/member_ai_query_response_model.dart';
import '../../data/services/member_ai_assistant_service.dart';

class _ChatTurn {
  final String question;
  // Null while the answer is loading.
  final String? answer;
  final bool isError;

  const _ChatTurn({required this.question, this.answer, this.isError = false});

  _ChatTurn copyWith({String? answer, bool? isError}) => _ChatTurn(
        question: question,
        answer: answer ?? this.answer,
        isError: isError ?? this.isError,
      );
}

class MemberAiAssistantScreen extends StatefulWidget {
  const MemberAiAssistantScreen({super.key});

  @override
  State<MemberAiAssistantScreen> createState() => _MemberAiAssistantScreenState();
}

class _MemberAiAssistantScreenState extends State<MemberAiAssistantScreen> {
  final MemberAiAssistantService _service = MemberAiAssistantService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatTurn> _turns = [];
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || _sending) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _turns.add(_ChatTurn(question: trimmed));
      _sending = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final MemberAiQueryResponseModel response = await _service.sendQuery(trimmed);

      if (!mounted) return;

      if (!response.dataAvailable) {
        setState(() {
          _turns[_turns.length - 1] = _turns.last.copyWith(
            answer: translateBackendErrorCode(l10n, response.errorCode),
            isError: true,
          );
          _sending = false;
        });
      } else {
        setState(() {
          _turns[_turns.length - 1] = _turns.last.copyWith(
            answer: response.answer ?? '',
          );
          _sending = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _turns[_turns.length - 1] = _turns.last.copyWith(
          answer: l10n.backendErrorGeneric,
          isError: true,
        );
        _sending = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.label),
        title: Text(
          l10n.memberAiTitle,
          style: TextStyle(color: colors.label, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _turns.isEmpty
                  ? _EmptyState(onQuickQuestion: _submit)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(tokens.spacing.lg),
                      itemCount: _turns.length,
                      itemBuilder: (context, index) => _TurnBubble(turn: _turns[index]),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(tokens.spacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_sending,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _submit,
                      style: TextStyle(color: colors.label),
                      decoration: InputDecoration(
                        hintText: l10n.memberAiInputHint,
                        hintStyle: TextStyle(color: colors.muted),
                        filled: true,
                        fillColor: colors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.border.withOpacity(0.25)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.border.withOpacity(0.25)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: colors.primary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spacing.sm),
                  _sending
                      ? SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () => _submit(_controller.text),
                          icon: Icon(Icons.send_rounded, color: colors.primary),
                          tooltip: l10n.memberAiSendButton,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ValueChanged<String> onQuickQuestion;

  const _EmptyState({required this.onQuickQuestion});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    final quickQuestions = [
      l10n.memberAiQuickQuestionSessionsThisWeek,
      l10n.memberAiQuickQuestionRemainingSessions,
      l10n.memberAiQuickQuestionRecommendation,
    ];

    return Padding(
      padding: EdgeInsets.all(tokens.spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 48, color: colors.primary),
          SizedBox(height: tokens.spacing.md),
          Text(
            l10n.memberAiEmptyState,
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(color: colors.muted),
          ),
          SizedBox(height: tokens.spacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: quickQuestions
                .map((q) => ActionChip(
                      label: Text(q),
                      onPressed: () => onQuickQuestion(q),
                      backgroundColor: colors.surface,
                      side: BorderSide(color: colors.border.withOpacity(0.3)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TurnBubble extends StatelessWidget {
  final _ChatTurn turn;

  const _TurnBubble({required this.turn});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(turn.question, style: TextStyle(color: colors.onPrimary)),
          ),
          SizedBox(height: tokens.spacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: turn.isError
                    ? colors.danger.withOpacity(0.12)
                    : colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: turn.isError
                    ? Border.all(color: colors.danger.withOpacity(0.4))
                    : null,
              ),
              child: turn.answer == null
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                    )
                  : Text(
                      turn.answer!,
                      style: TextStyle(
                        color: turn.isError ? colors.danger : colors.label,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
