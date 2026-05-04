import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class QuickActionsGrid extends StatelessWidget {
  final VoidCallback onBookClass;
  final VoidCallback onBookTrainer;
  final VoidCallback onQrCode;
  final VoidCallback onPaymentHistory;

  const QuickActionsGrid({
    super.key,
    required this.onBookClass,
    required this.onBookTrainer,
    required this.onQrCode,
    required this.onPaymentHistory,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    // Reads the current app direction from MaterialApp.
    // Arabic locale => RTL, English/French => LTR.
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Labels come from localization files, so they update with app language.
    final actions = [
      _QuickAction(
        Icons.fitness_center_rounded,
        l10n.home_bookTrainer,
        tokens.colors.primary,
        onBookTrainer,
      ),
      _QuickAction(
        Icons.calendar_month_rounded,
        l10n.home_bookClass,
        tokens.colors.primary.withOpacity(0.82),
        onBookClass,
      ),
      _QuickAction(
        Icons.trending_up_rounded,
        l10n.home_paymentHistory,
        tokens.colors.danger,
        onPaymentHistory,
      ),
      _QuickAction(
        Icons.flash_on_rounded,
        l10n.home_checkInCode,
        tokens.colors.success,
        onQrCode,
      ),
    ];

    // No manual Directionality here.
    // This widget follows the global direction from MaterialApp.locale.
    return Column(
      crossAxisAlignment:
      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          l10n.home_quickActions,
          textAlign: isRtl ? TextAlign.end : TextAlign.start,
          style: tokens.typography.headlineSmall.copyWith(
            color: tokens.colors.label,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),

        SizedBox(height: tokens.spacing.lg),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: tokens.spacing.md,
            mainAxisSpacing: tokens.spacing.md,
            childAspectRatio: 2.0,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];

            return InkWell(
              onTap: action.onTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.lg,
                  vertical: tokens.spacing.md,
                ),
                decoration: BoxDecoration(
                  color: action.color,
                  borderRadius: BorderRadius.circular(18),
                ),

                // Align card content based on the current language direction.
                child: Column(
                  crossAxisAlignment:
                  isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      action.icon,
                      color: tokens.colors.onPrimary,
                      size: 24,
                    ),

                    Text(
                      action.label,
                      textAlign: isRtl ? TextAlign.end : TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(
      this.icon,
      this.label,
      this.color,
      this.onTap,
      );
}