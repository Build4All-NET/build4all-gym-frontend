import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class SessionAboutWidget extends StatelessWidget {
  final String description;

  const SessionAboutWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(tokens.spacing.lg),
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          borderRadius: BorderRadius.circular(tokens.card.radius),
          border: Border.all(color: tokens.colors.border.withOpacity(0.15)),
          boxShadow: tokens.card.showShadow
              ? [
            BoxShadow(
              color: tokens.colors.label.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Column(
          crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sessionDetailAboutTitle,
              style: tokens.typography.titleMedium.copyWith(
                color: tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: tokens.spacing.sm),
            Text(
              description,
              textDirection: _detectTextDirection(description),
              textAlign: _detectTextDirection(description) == TextDirection.rtl
                  ? TextAlign.right
                  : TextAlign.left,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.body,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
TextDirection _detectTextDirection(String text) {
  if (text.isEmpty) return TextDirection.ltr;
  final firstChar = text.trimLeft().characters.first;
  return RegExp(r'[\u0600-\u06FF]').hasMatch(firstChar)
      ? TextDirection.rtl
      : TextDirection.ltr;
}