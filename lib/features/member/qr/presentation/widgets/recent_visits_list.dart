import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/member/qr/domain/entities/visit_record.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'visit_record_tile.dart';

/// Recent visits card shown below the QR card.
///
/// Design unchanged.
/// Only title alignment changes:
/// - English -> left
/// - Arabic  -> right
class RecentVisitsList extends StatelessWidget {
  final List<VisitRecord> visits;

  const RecentVisitsList({
    super.key,
    required this.visits,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: tokens.card.showBorder
            ? Border.all(
          color: tokens.colors.border.withOpacity(0.12),
        )
            : null,
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment:
        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              l10n.memberQrRecentVisits,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: tokens.typography.titleMedium.copyWith(
                color: tokens.colors.label,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          SizedBox(height: tokens.spacing.md),

          if (visits.isEmpty)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: tokens.spacing.lg,
                ),
                child: Text(
                  l10n.memberQrNoRecentVisits,
                  textAlign: TextAlign.center,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            ...List.generate(visits.length, (index) {
              return VisitRecordTile(
                visit: visits[index],
                showDivider: index != visits.length - 1,
              );
            }),
        ],
      ),
    );
  }
}