import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class SessionEquipmentWidget extends StatelessWidget {
  final List<String> equipment;

  const SessionEquipmentWidget({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    if (equipment.isEmpty) return const SizedBox.shrink();

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
              l10n.sessionDetailEquipmentTitle,
              style: tokens.typography.titleMedium.copyWith(
                color: tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            Wrap(
              spacing: tokens.spacing.sm,
              runSpacing: tokens.spacing.sm,
              alignment: isRtl ? WrapAlignment.end : WrapAlignment.start,
              children: equipment
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: tokens.colors.background,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: tokens.colors.border.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        item,
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.body,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}