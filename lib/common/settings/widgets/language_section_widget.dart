// ─────────────────────────────────────────────────────────────────────────────
// lib/common/settings/widgets/language_section_widget.dart
//
// PURPOSE:
//   Purely presentational widget for the Language & Region settings section.
//
// LOCALIZATION:
//   No hardcoded visible strings.
//   All user-facing labels/subtitles come from AppLocalizations.
//
// COLORS:
//   Existing accent colors are kept as design constants.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_cubit.dart';
import '../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: Colors.purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsLanguageRegionTitle,
                    style: tokens.typography.titleMedium,
                  ),
                  Text(
                    l10n.settingsLanguageRegionSubtitle,
                    style: tokens.typography.bodySmall.copyWith(
                      color: c.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          _LanguageCard(
            locale: const Locale('en'),
            label: l10n.settingsLanguageEnglish,
            subtitle: l10n.settingsLanguageEnglishSubtitle,
            isRtl: false,
            selected: isSelected(const Locale('en')),
            onTap: () => onLocaleChanged(const Locale('en')),
            tokens: tokens,
          ),

          const SizedBox(height: 8),

          _LanguageCard(
            locale: const Locale('ar'),
            label: l10n.settingsLanguageArabic,
            subtitle: l10n.settingsLanguageArabicSubtitle,
            isRtl: false,
            selected: isSelected(const Locale('ar')),
            onTap: () => onLocaleChanged(const Locale('ar')),
            tokens: tokens,
          ),
          const SizedBox(height: 8),

          _LanguageCard(
            locale: null,
            label: l10n.settingsLanguageSystemDefault,
            subtitle: l10n.settingsLanguageSystemDefaultSubtitle,
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

class _LanguageCard extends StatelessWidget {
  final Locale? locale;
  final String label;
  final String subtitle;
  final bool isRtl;
  final bool selected;
  final VoidCallback onTap;
  final dynamic tokens;

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
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? accentColor.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.language_rounded,
                color: selected ? accentColor : Colors.grey,
                size: 18,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: tokens.typography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? accentColor : c.label,
                    ),
                  ),
                  Text(
                    subtitle,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: tokens.typography.bodySmall.copyWith(
                      color: c.muted,
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_rounded,
                color: accentColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}