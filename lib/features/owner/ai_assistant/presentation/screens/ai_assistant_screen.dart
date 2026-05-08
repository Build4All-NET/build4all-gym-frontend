// =============================================================================
// FILE: AiAssistantScreen.dart
// =============================================================================
// MAIN AI ASSISTANT SCREEN
//
// This screen switches between:
//
// 1) READY MODE (AiAssistantReady)
//    → shows: hero + suggestions + recent queries
//
// 2) CHAT MODE (Querying / Answered)
//    → shows: conversation + loading + follow-ups
//
// Input bar is ALWAYS visible at bottom.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ai_assistant_bloc.dart';
import '../widgets/ai_hero_banner_widget.dart';
import '../widgets/suggested_questions_widget.dart';
import '../widgets/recent_queries_widget.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_input_bar_widget.dart';

import '../../domain/entities/ai_message_entity.dart';
import '../../domain/entities/ai_stat_card_entity.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // SEND QUERY
  // ===========================================================================
  // Reads current conversation from state
  // then dispatches AiQuerySubmitted
  // ===========================================================================
  void _sendQuery() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final state = context.read<AiAssistantBloc>().state;

    final List<AiMessageEntity> history = switch (state) {
      AiAssistantQuerying s => s.conversation.messages,
      AiAssistantAnswered s => s.conversation.messages,
      _ => [],
    };

    context.read<AiAssistantBloc>().add(
      AiQuerySubmitted(
        query: text,
        conversationHistory: history,
      ),
    );

    _inputController.clear();
  }

  // ===========================================================================
  // AUTO SCROLL
  // ===========================================================================
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text('AI Assistant'),

        actions: [

          // Reset conversation button (only in chat mode)
          BlocBuilder<AiAssistantBloc, AiAssistantState>(
            builder: (context, state) {
              if (state is AiAssistantReady ||
                  state is AiAssistantInitial ||
                  state is AiAssistantLoading) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  context.read<AiAssistantBloc>().add(
                    const AiConversationReset(),
                  );
                },
              );
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [

          Expanded(
            child: BlocConsumer<AiAssistantBloc, AiAssistantState>(

              // scroll when AI responds or thinking
              listenWhen: (prev, curr) =>
              curr is AiAssistantQuerying ||
                  curr is AiAssistantAnswered,

              listener: (_, __) => _scrollToBottom(),

              builder: (context, state) {

                // ================= READY MODE =================
                if (state is AiAssistantReady) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const AiHeroBannerWidget(),

                        const SizedBox(height: 20),
                        SuggestedQuestionsWidget(
                          suggestions: state.suggestions,
                        ),

                        const SizedBox(height: 20),

                        // recent queries from bloc state
                        RecentQueriesWidget(
                          queries: state.recentQueries,
                        ),
                      ],
                    ),
                  );
                }

                // ================= CHAT MODE =================
                final messages = switch (state) {
                  AiAssistantQuerying s => s.conversation.messages,
                  AiAssistantAnswered s => s.conversation.messages,
                  _ => [],
                };

                final statCards = state is AiAssistantAnswered
                    ? state.statCards
                    : null;

                final followUps = state is AiAssistantAnswered
                    ? state.suggestedFollowUps
                    : [];

                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),

                  children: [

                    // ================= MESSAGES =================
                    ...messages.asMap().entries.map((entry) {
                      final i = entry.key;
                      final msg = entry.value;
                      final isLast = i == messages.length - 1;

                      return ChatMessageWidget(
                        message: msg,
                        statCards: (isLast && msg.role == 'assistant')
                            ? (statCards ?? [])
                            : const [],
                      );
                    }),

                    // ================= LOADING =================
                    if (state is AiAssistantQuerying)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircularProgressIndicator(strokeWidth: 2),
                            SizedBox(width: 12),
                            Text("AI is thinking..."),
                          ],
                        ),
                      ),

                    // ================= FOLLOW UPS =================
                    if (followUps.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          spacing: 8,
                          children: followUps.map((q) {
                            return ActionChip(
                              label: Text(q),
                              onPressed: () {
                                context.read<AiAssistantBloc>().add(
                                  AiSuggestionTapped(q),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // ================= INPUT BAR =================
          ChatInputBarWidget(
            controller: _inputController,
            onSend: _sendQuery,
          ),
        ],
      ),
    );
  }
}