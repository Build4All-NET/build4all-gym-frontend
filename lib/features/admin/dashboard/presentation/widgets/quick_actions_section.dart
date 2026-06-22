// FILE: lib/features/admin/dashboard/presentation/widgets/quick_actions_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onAiAssistant;
  final VoidCallback onRecordPayment;
  final VoidCallback onAddPlan;
  final VoidCallback onSendAnnouncement;

  const QuickActionsSection({
    super.key,
    required this.onAiAssistant,
    required this.onRecordPayment,
    required this.onAddPlan,
    required this.onSendAnnouncement,
  });

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final card    = tokens.card;
    final l10n    = AppLocalizations.of(context)!;

    final accentA = c.primary;
    final accentB = c.success;
    final accentC = Color.lerp(c.primary, c.label, 0.3) ?? c.primary;
    final accentD = Color.lerp(c.danger, c.primary, 0.5) ?? c.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 2, bottom: 14),
          child: Text(
            l10n.admin_dashboard_quickActions,
            style: TextStyle(
                fontSize:   17,
                fontWeight: FontWeight.w700,
                color:      c.label),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color:        c.surface,
            borderRadius: BorderRadius.circular(card.radius),
            boxShadow: [
              BoxShadow(
                color:     Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset:    const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _ActionRow(
                icon:      Icons.psychology_outlined,
                iconColor: accentA,
                iconBg:    accentA.withOpacity(0.1),
                label:     l10n.navAiAssistant,
                onTap:     onAiAssistant,
                isFirst:   true,
                chevronColor: c.border,
                labelColor:   c.body,
                cardRadius:   card.radius,
              ),
              _RowDivider(color: c.border.withOpacity(0.1)),
              _ActionRow(
                icon:        Icons.attach_money_rounded,
                iconColor:   accentB,
                iconBg:      accentB.withOpacity(0.1),
                label:       l10n.admin_dashboard_recordPayment,
                onTap:       onRecordPayment,
                chevronColor: c.border,
                labelColor:  c.body,
                cardRadius:  card.radius,
              ),
              _RowDivider(color: c.border.withOpacity(0.1)),
              _ActionRow(
                icon:        Icons.credit_card_outlined,
                iconColor:   accentC,
                iconBg:      accentC.withOpacity(0.1),
                label:       l10n.admin_dashboard_addPlan,
                onTap:       onAddPlan,
                chevronColor: c.border,
                labelColor:  c.body,
                cardRadius:  card.radius,
              ),
              _RowDivider(color: c.border.withOpacity(0.1)),
              _ActionRow(
                icon:        Icons.send_outlined,
                iconColor:   accentD,
                iconBg:      accentD.withOpacity(0.1),
                label:       l10n.admin_dashboard_sendAnnouncement,
                onTap:       onSendAnnouncement,
                isLast:      true,
                chevronColor: c.border,
                labelColor:  c.body,
                cardRadius:  card.radius,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  final Color color;
  const _RowDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 1, thickness: 1, color: color, indent: 62, endIndent: 0);
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final Color    iconBg;
  final String   label;
  final VoidCallback onTap;
  final bool     isFirst;
  final bool     isLast;
  final Color    chevronColor;
  final Color    labelColor;
  final double   cardRadius;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast  = false,
    required this.chevronColor,
    required this.labelColor,
    required this.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.vertical(
          top:    isFirst ? Radius.circular(cardRadius) : Radius.zero,
          bottom: isLast  ? Radius.circular(cardRadius) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width:  38,
                height: 38,
                decoration: BoxDecoration(
                  color:        iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w600,
                      color:      labelColor),
                ),
              ),
              Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: chevronColor.withOpacity(0.5), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}