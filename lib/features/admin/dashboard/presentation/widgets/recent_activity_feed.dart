// FILE: lib/features/admin/dashboard/presentation/widgets/recent_activity_feed.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recent_activity_item.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class RecentActivityFeed extends StatelessWidget {
  final List<RecentActivityItem> activities;
  const RecentActivityFeed({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;
    final l10n   = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 2),
              child: Text(
                l10n.admin_dashboard_recentActivity,
                style: TextStyle(
                    fontSize:   17,
                    fontWeight: FontWeight.w700,
                    color:      c.label),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor:  c.primary,
                padding:          EdgeInsets.zero,
                minimumSize:      const Size(0, 0),
                tapTargetSize:    MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.admin_dashboard_viewAll,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: c.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (activities.isEmpty)
          Container(
            padding:    const EdgeInsets.all(32),
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
            child: Center(
              child: Text(
                l10n.admin_dashboard_noRecentActivity,
                style: TextStyle(color: c.muted, fontSize: 14),
              ),
            ),
          )
        else
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
                for (int i = 0; i < activities.length; i++) ...[
                  _ActivityItem(
                    item:    activities[i],
                    isFirst: i == 0,
                    isLast:  i == activities.length - 1,
                  ),
                  if (i != activities.length - 1)
                    Divider(
                      height:    1,
                      thickness: 1,
                      color:     c.border.withOpacity(0.1),
                      indent:    62,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivityItem item;
  final bool isFirst;
  final bool isLast;

  const _ActivityItem({
    required this.item,
    this.isFirst = false,
    this.isLast  = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    final color = _colorForType(item.activityType, c);
    final bg    = color.withOpacity(0.12);
    final icon  = _iconForType(item.activityType);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 16 : 12,
        16,
        isLast  ? 16 : 12,
      ),
      child: Row(
        children: [
          SizedBox(
            width:  42,
            height: 42,
            child: Stack(
              children: [
                Container(
                  width:  42,
                  height: 42,
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      _initialsFor(item.memberName),
                      style: TextStyle(
                          color:      color,
                          fontSize:   13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 0,
                  end:    0,
                  child: Container(
                    width:  16,
                    height: 16,
                    decoration: BoxDecoration(
                      color:  color,
                      shape:  BoxShape.circle,
                      border: Border.all(color: c.surface, width: 1.5),
                    ),
                    child: Icon(icon, color: Colors.white, size: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.memberName,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:   13,
                      color:      c.label),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: TextStyle(
                      color:      c.body,
                      fontSize:   12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.timeAgo,
            style: TextStyle(
                color:      c.muted,
                fontSize:   11,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Color _colorForType(String type, dynamic c) {
    switch (type.toUpperCase()) {
      case 'JOIN':
      case 'NEW_MEMBER':
        return c.primary as Color;
      case 'RENEWAL':
        return c.success as Color;
      case 'PAYMENT':
        return Color.lerp(c.primary as Color, c.label as Color, 0.3) ?? c.primary as Color;
      case 'CHECKIN':
        return Color.lerp(c.danger as Color, c.primary as Color, 0.5) ?? c.primary as Color;
      default:
        return c.muted as Color;
    }
  }

  IconData _iconForType(String type) {
    switch (type.toUpperCase()) {
      case 'JOIN':
      case 'NEW_MEMBER':
        return Icons.person_add_outlined;
      case 'RENEWAL':
        return Icons.autorenew_rounded;
      case 'PAYMENT':
        return Icons.attach_money_rounded;
      case 'CHECKIN':
        return Icons.directions_run_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}