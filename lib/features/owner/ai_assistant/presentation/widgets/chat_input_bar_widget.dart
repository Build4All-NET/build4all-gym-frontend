// ─────────────────────────────────────────────────────────────────────────────
// ChatInputBarWidget.dart
// ─────────────────────────────────────────────────────────────────────────────
// The text input + send button fixed at the bottom of the screen.
// Always visible in both Initial and Chat modes.
//
// The send button is disabled when the field is empty — we listen to the
// controller's text changes via a ValueListenableBuilder.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class ChatInputBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBarWidget({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          // ── Text field ─────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:        Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller:  controller,
                maxLines:    null,       // expands vertically for long input
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (controller.text.trim().isNotEmpty) onSend();
                },
                decoration: const InputDecoration(
                  hintText:      'Ask a question about your gym...',
                  border:        InputBorder.none,  // no visible border
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Send button ────────────────────────────────────────────────────
          // ValueListenableBuilder rebuilds ONLY the button when text changes,
          // so we avoid rebuilding the entire widget on each keystroke.
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final hasText = value.text.trim().isNotEmpty;
              return IconButton(
                onPressed: hasText ? onSend : null, // null = visually disabled
                icon: const Icon(Icons.send_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: hasText
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  foregroundColor: hasText
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}