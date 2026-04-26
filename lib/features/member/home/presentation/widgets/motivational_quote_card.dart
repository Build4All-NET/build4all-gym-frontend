import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../domain/entities/motivational_quote.dart';

class MotivationalQuoteCard extends StatelessWidget {
  // Nullable because the backend may return no quote.
  // If quote is null or empty, we hide the card completely.
  final MotivationalQuote? quote;

  const MotivationalQuoteCard({
    super.key,
    this.quote,
  });

  @override
  Widget build(BuildContext context) {
    final q = quote;

    // Do not show an empty card if there is no quote.
    if (q == null || q.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    // Theme tokens come from the admin-selected template.
    final tokens = context.read<ThemeCubit>().state.tokens;

    // Text comes from l10n, so it changes with app language.
    final l10n = AppLocalizations.of(context)!;

    // Quote direction depends on the quote language from backend.
    final isArabic = q.languageCode.toLowerCase().trim() == 'ar';
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    // Add quotes only if backend did not already send them.
    final rawText = q.text.trim();
    final displayText =
    rawText.startsWith('"') ||
        rawText.startsWith('“') ||
        rawText.startsWith('«')
        ? rawText
        : '"$rawText"';

    return Directionality(
      textDirection: textDirection,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          tokens.spacing.lg,
          tokens.spacing.lg,
          tokens.spacing.lg,
          tokens.spacing.lg,
        ),
        decoration: BoxDecoration(
          // Dark warm orange/brown feel using dynamic theme danger color.
          color: tokens.colors.danger.withOpacity(0.10),
          borderRadius: BorderRadius.circular(22),

          // Keeps your existing side accent design.
          border: Border(
            right: BorderSide(
              color: tokens.colors.danger,
              width: 4,
            ),
          ),

          // Shadow depends on selected theme settings.
          boxShadow: tokens.card.showShadow
              ? [
            BoxShadow(
              color: tokens.colors.label.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sparkle icon container.
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: tokens.colors.danger.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: tokens.colors.onPrimary,
                size: 25,
              ),
            ),

            SizedBox(width: tokens.spacing.lg),

            // Quote label + quote text.
            Expanded(
              child: Column(
                crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.home_quoteOfTheDay,
                    textAlign: isArabic ? TextAlign.end : TextAlign.start,
                    style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: tokens.spacing.sm),

                  Text(
                    displayText,
                    textAlign: isArabic ? TextAlign.end : TextAlign.start,
                    style: tokens.typography.titleMedium.copyWith(
                      color: tokens.colors.label,
                      fontWeight: FontWeight.w900,
                      height: 1.45,
                    ),
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