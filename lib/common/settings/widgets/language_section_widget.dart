// ─────────────────────────────────────────────────────────────────────────────
// lib/common/settings/widgets/language_section_widget.dart
//
// PURPOSE:
//   Purely presentational widget for the Language & Region settings section.
//   Displays 3 selectable cards: English, العربية, System Default.
//
// WHY SHARED (lib/common/):
//   Same reason as AppearanceSectionWidget — LocaleCubit is app-root-level.
//   Both admin and member settings screens reuse this.
//
// DESIGN (matches Figma):
//   Selected card → purple border + purple checkmark
//   Arabic card   → text is right-aligned (RTL visual), globe icon on the LEFT
//                   We do NOT use Directionality wrapper — only the Text widgets
//                   are right-aligned, keeping the overall card layout intact.
//
// HOW SAVE WORKS:
//   This widget does NOT call LocaleCubit directly.
//   It calls onLocaleChanged, which stores the pending value in the parent cubit.
//   On "Save Changes", the parent cubit calls LocaleCubit.setLocale(pendingLocale).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';

class LanguageSectionWidget extends StatelessWidget {
  /// Currently selected locale — null means "System Default".
  final Locale? selectedLocale;

  /// Called when the user taps a language card.
  /// null = system default. Parent marks dirty and stores pending value.
  final ValueChanged<Locale?> onLocaleChanged;

  const LanguageSectionWidget({
    super.key,
    required this.selectedLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    // Helper: is this locale currently selected?
    bool isSelected(Locale? locale) {
      if (locale == null && selectedLocale == null) return true;
      return selectedLocale?.languageCode == locale?.languageCode;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.language_rounded,
                    color: Colors.purple, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Language & Region',
                      style: tokens.typography.titleMedium),
                  Text('Choose your preferred language',
                      style: tokens.typography.bodySmall.copyWith(color: c.muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── English card (LTR) ────────────────────────────────────────────
          _LanguageCard(
            locale: const Locale('en'),
            label: 'English',
            subtitle: 'Default language',
            isRtl: false,
            selected: isSelected(const Locale('en')),
            onTap: () => onLocaleChanged(const Locale('en')),
            tokens: tokens,
          ),
          const SizedBox(height: 8),

          // ── Arabic card (RTL text layout — NOT a Directionality wrapper) ──
          _LanguageCard(
            locale: const Locale('ar'),
            label: 'العربية',
            subtitle: 'اللغة العربية',
            isRtl: true, // tells the card to right-align text
            selected: isSelected(const Locale('ar')),
            onTap: () => onLocaleChanged(const Locale('ar')),
            tokens: tokens,
          ),
          const SizedBox(height: 8),

          // ── System Default card ───────────────────────────────────────────
          _LanguageCard(
            locale: null,
            label: 'System Default',
            subtitle: 'Use device language',
            isRtl: false,
            selected: isSelected(null),
            onTap: () => onLocaleChanged(null),
            tokens: tokens,
          ),
        ],
      ),
    );
  }
}

// ─── Private card widget ──────────────────────────────────────────────────────

class _LanguageCard extends StatelessWidget {
  final Locale? locale;
  final String label;
  final String subtitle;
  final bool isRtl;     // true only for Arabic — right-aligns text inside the card
  final bool selected;
  final VoidCallback onTap;
  final dynamic tokens; // AppThemeTokens

  const _LanguageCard({
    required this.locale,
    required this.label,
    required this.subtitle,
    required this.isRtl,
    required this.selected,
    required this.onTap,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    const accentColor = Colors.purple;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? accentColor.withOpacity(0.06) : c.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? accentColor : c.border.withOpacity(0.2),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          // For Arabic: globe icon is on the LEFT, text is RIGHT-aligned.
          // The Row direction is always LTR — we only flip the text alignment.
          children: [
            // Globe icon — always on the left side of the row
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? accentColor.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.language_rounded,
                  color: selected ? accentColor : Colors.grey, size: 18),
            ),
            const SizedBox(width: 12),

            // Text block — right-aligned for Arabic, left-aligned for others
            Expanded(
              child: Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.end  // Right-align Arabic text
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    // textDirection RTL only for the Arabic text widget itself
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: tokens.typography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? accentColor : c.label,
                    ),
                  ),
                  Text(
                    subtitle,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: tokens.typography.bodySmall.copyWith(color: c.muted),
                  ),
                ],
              ),
            ),

            // Purple checkmark — visible only when selected
            if (selected)
              const Icon(Icons.check_rounded, color: accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}
