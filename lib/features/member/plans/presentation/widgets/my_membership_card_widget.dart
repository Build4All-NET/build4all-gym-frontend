import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../domain/entities/my_membership_entity.dart';

class MyMembershipCardWidget extends StatelessWidget {
  final MyMembershipEntity membership;

  const MyMembershipCardWidget({
    super.key,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
        margin: EdgeInsets.only(bottom: tokens.spacing.lg),
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tokens.colors.border.withOpacity(0.18),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: tokens.colors.label.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          membership.planName,
                          textAlign: isRtl ? TextAlign.end : TextAlign.start,
                          style: tokens.typography.headlineSmall.copyWith(
                            color: tokens.colors.label,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          l10n.remainingDays(membership.remainingDays),
                          textAlign: isRtl ? TextAlign.end : TextAlign.start,
                          style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          l10n.membershipEndsAt(membership.endDate),
                          textAlign: isRtl ? TextAlign.end : TextAlign.start,
                          style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  _MembershipStatusIcon(
                    status: membership.status,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: const Color(0xFFEAF0F8),
                    disabledForegroundColor: tokens.colors.label,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l10n.renew,
                    style: tokens.typography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _MembershipStatusIcon extends StatelessWidget {
  final String status;

  const _MembershipStatusIcon({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase().trim();

    IconData icon = Icons.star_border_rounded;
    Color color = Colors.blueGrey;

    if (normalized == 'active') {
      icon = Icons.workspace_premium_rounded;
      color = Colors.orange;
    } else if (normalized == 'frozen') {
      icon = Icons.ac_unit_rounded;
      color = Colors.lightBlue;
    } else if (normalized == 'expired') {
      icon = Icons.schedule_rounded;
      color = Colors.redAccent;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}