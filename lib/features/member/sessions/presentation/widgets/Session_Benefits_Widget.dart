import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:characters/characters.dart';

class SessionBenefitsWidget extends StatelessWidget {
  final List<String> benefits;

  const SessionBenefitsWidget({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    if (benefits.isEmpty) return const SizedBox.shrink();

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
              color: Colors.black.withOpacity(0.05),
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
              l10n.sessionDetailBenefitsTitle,
              style: tokens.typography.titleMedium.copyWith(
                color: tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            ...benefits.map(
                  (benefit) => Padding(
                padding: EdgeInsets.only(bottom: tokens.spacing.sm),
                child: Row(
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tokens.colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: tokens.spacing.sm),
                    Expanded(
                      child: Text(
                        benefit,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.body,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}