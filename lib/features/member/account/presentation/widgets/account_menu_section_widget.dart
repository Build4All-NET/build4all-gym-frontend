import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class AccountMenuSectionWidget extends StatelessWidget {
  final String title;
  final List<AccountMenuItem> items;

  const AccountMenuSectionWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: tokens.spacing.sm),
          child: Text(
            title,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: tokens.colors.surface,
            borderRadius: BorderRadius.circular(tokens.card.radius),
            border: Border.all(color: tokens.colors.border.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: tokens.colors.label.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                AccountMenuRowWidget(
                  item: items[i],
                  isFirst: i == 0,
                  isLast: i == items.length - 1,
                ),
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    color: tokens.colors.border.withOpacity(0.1),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AccountMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;
  final Color? iconBgColor;

  const AccountMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.iconBgColor,
  });
}

class AccountMenuRowWidget extends StatelessWidget {
  final AccountMenuItem item;
  final bool isFirst;
  final bool isLast;

  const AccountMenuRowWidget({
    super.key,
    required this.item,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(tokens.card.radius) : Radius.zero,
        bottom: isLast ? Radius.circular(tokens.card.radius) : Radius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.lg,
          vertical: tokens.spacing.md,
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.iconBgColor ??
                    tokens.colors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.iconColor ?? tokens.colors.primary,
                size: 18,
              ),
            ),
            SizedBox(width: tokens.spacing.md),
            Expanded(
              child: Text(
                item.label,
                style: tokens.typography.bodyMedium.copyWith(
                  color: item.labelColor ?? tokens.colors.label,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isRtl ? Icons.chevron_left : Icons.chevron_right,
              color: tokens.colors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}