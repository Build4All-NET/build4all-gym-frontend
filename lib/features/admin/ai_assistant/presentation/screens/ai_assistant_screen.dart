// =============================================================================
// FILE: ai_assistant_screen.dart
// PATH: lib/features/owner/ai_assistant/presentation/screens/ai_assistant_screen.dart
// LAYER: Presentation Layer → Screens
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../admin/AppBar/presentation/admin_app_bar.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/ai_message_entity.dart';
import '../../domain/entities/ai_stat_card_entity.dart';
import '../bloc/ai_assistant_bloc.dart';
import '../widgets/ai_hero_banner_widget.dart';
import '../widgets/ai_stat_card_widget.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/suggested_questions_widget.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _submit(List<AiMessageEntity> history) {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    _controller.clear();
    context.read<AiAssistantBloc>().add(
      AiQuerySubmitted(query: query, conversationHistory: history),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AdminProfileCubit>().state;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: AdminNavigationDrawer(
        gymName:         profile.gymName,
        branchName:      profile.branchName,
        adminName:       profile.adminName,
        adminEmail:      profile.adminEmail,
        avatarUrl:       profile.avatarUrl,
        initialActiveId: 'ai_assistant',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Shared AppBar (handles drawer open + branch pill + bell) ────
            AdminAppBar(
              title: l10n.aiAssistantTitle,
              actions: [
                // Reset button — only visible during an active conversation
                BlocBuilder<AiAssistantBloc, AiAssistantState>(
                  builder: (context, state) {
                    final inChat = state is AiAssistantQuerying ||
                        state is AiAssistantAnswered;
                    if (!inChat) return const SizedBox.shrink();
                    return IconButton(
                      tooltip: l10n.newConversation,
                      icon: Icon(
                        Icons.refresh_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () => context
                          .read<AiAssistantBloc>()
                          .add(const AiConversationReset()),
                    );
                  },
                ),
              ],
            ),

            // ── BLoC-driven body + fixed input bar ───────────────────────
            Expanded(
              child: BlocConsumer<AiAssistantBloc, AiAssistantState>(
                listener: (context, state) {
                  if (state is AiAssistantQuerying ||
                      state is AiAssistantAnswered) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  final history   = _historyFrom(state);
                  final isLoading = state is AiAssistantQuerying;

                  return Column(
                    children: [
                      Expanded(child: _buildBody(context, state)),
                      _InputBar(
                        controller: _controller,
                        isLoading:  isLoading,
                        onSubmit:   () => _submit(history),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── State → widget mapping ─────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, AiAssistantState state) {
    if (state is AiAssistantInitial || state is AiAssistantLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (state is AiAssistantError) {
      return _ErrorView(
        message: state.message,
        onRetry: () =>
            context.read<AiAssistantBloc>().add(const AiAssistantStarted()),
      );
    }

    if (state is AiAssistantReady) {
      return _StartScreen(state: state, scrollCtrl: _scrollCtrl);
    }

    if (state is AiAssistantQuerying) {
      return _ChatView(
        messages:   state.conversation.messages,
        statCards:  const [],
        followUps:  const [],
        isLoading:  true,
        scrollCtrl: _scrollCtrl,
      );
    }

    if (state is AiAssistantAnswered) {
      return _ChatView(
        messages:   state.conversation.messages,
        statCards:  state.statCards,
        followUps:  state.suggestedFollowUps,
        isLoading:  false,
        scrollCtrl: _scrollCtrl,
      );
    }

    return const SizedBox.shrink();
  }

  List<AiMessageEntity> _historyFrom(AiAssistantState state) {
    if (state is AiAssistantAnswered) return state.conversation.messages;
    if (state is AiAssistantQuerying) return state.conversation.messages;
    return const [];
  }
}

// =============================================================================
// _StartScreen — hero + suggested questions + recent queries
// =============================================================================
class _StartScreen extends StatelessWidget {
  final AiAssistantReady state;
  final ScrollController scrollCtrl;

  const _StartScreen({required this.state, required this.scrollCtrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AiHeroBannerWidget(),
          const SizedBox(height: 24),

          SuggestedQuestionsWidget(suggestions: state.suggestions),

          if (state.recentQueries.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text(
              l10n.recentQueries,
              style: TextStyle(
                fontSize:   16,
                fontWeight: FontWeight.bold,
                color:      cs.onSurface,
              ),
            ),
            Divider(color: cs.outlineVariant, height: 24),
            ...state.recentQueries.map(
                  (q) => _RecentQueryRow(
                queryText: q.queryText,
                onTap: () => context
                    .read<AiAssistantBloc>()
                    .add(AiHistoryItemTapped(q.queryText)),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// =============================================================================
// _RecentQueryRow
// =============================================================================
class _RecentQueryRow extends StatelessWidget {
  final String       queryText;
  final VoidCallback onTap;

  const _RecentQueryRow({required this.queryText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                queryText,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.view,
              style: TextStyle(
                color:      cs.onSurfaceVariant,
                fontSize:   13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// _ChatView — chat bubbles + stat cards + follow-up chips
// =============================================================================
class _ChatView extends StatelessWidget {
  final List<AiMessageEntity>  messages;
  final List<AiStatCardEntity> statCards;
  final List<String>           followUps;
  final bool                   isLoading;
  final ScrollController       scrollCtrl;

  const _ChatView({
    required this.messages,
    required this.statCards,
    required this.followUps,
    required this.isLoading,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      children: [
        ...messages.map((m) => ChatMessageWidget(message: m)),

        if (isLoading) const _TypingIndicator(),

        if (statCards.isNotEmpty) ...[
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: statCards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:   2,
              crossAxisSpacing: 12,
              mainAxisSpacing:  12,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (_, i) => AiStatCardWidget(card: statCards[i]),
          ),
        ],

        if (followUps.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.youMightAlsoAsk,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ...followUps.map((q) => _FollowUpChip(question: q)),
        ],

        const SizedBox(height: 8),
      ],
    );
  }
}

// =============================================================================
// _TypingIndicator — animated dots while AI is thinking
// =============================================================================
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius:          16,
            backgroundColor: cs.primary,
            child: const Icon(Icons.smart_toy_outlined,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:        cs.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final t = _ctrl.value;
                  final opacity = ((t + i * 0.33) % 1.0 < 0.5
                      ? (t + i * 0.33) % 1.0 * 2
                      : 2 - (t + i * 0.33) % 1.0 * 2)
                      .clamp(0.25, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Opacity(
                      opacity: opacity,
                      child: CircleAvatar(
                        radius:          4,
                        backgroundColor: cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _FollowUpChip
// =============================================================================
class _FollowUpChip extends StatelessWidget {
  final String question;

  const _FollowUpChip({required this.question});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () =>
          context.read<AiAssistantBloc>().add(AiSuggestionTapped(question)),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color:        cs.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.primary.withOpacity(0.4)),
        ),
        child: Text(
          question,
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
        ),
      ),
    );
  }
}

// =============================================================================
// _InputBar — fixed at the bottom of the screen
// =============================================================================
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool                  isLoading;
  final VoidCallback          onSubmit;

  const _InputBar({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 10, 16, MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color:  cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant, width: 0.8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:      controller,
              enabled:         !isLoading,
              textInputAction: TextInputAction.send,
              style:           TextStyle(color: cs.onSurface, fontSize: 14),
              decoration: InputDecoration(
                hintText:  l10n.askQuestionAboutGym,
                hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                filled:    true,
                fillColor: cs.surfaceVariant,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:   BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                  BorderSide(color: cs.outline.withOpacity(0.5), width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: cs.primary, width: 1.2),
                ),
              ),
              onSubmitted: isLoading ? null : (_) => onSubmit(),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width:  44,
            height: 44,
            decoration: BoxDecoration(
              color:  isLoading ? cs.surfaceVariant : cs.primary,
              shape:  BoxShape.circle,
            ),
            child: isLoading
                ? Padding(
              padding: const EdgeInsets.all(12),
              child: CircularProgressIndicator(
                color:       cs.primary,
                strokeWidth: 2,
              ),
            )
                : IconButton(
              onPressed: onSubmit,
              padding:   EdgeInsets.zero,
              icon: Icon(Icons.send_rounded,
                  color: cs.onPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _ErrorView
// =============================================================================
class _ErrorView extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: cs.error, size: 52),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon:  const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}