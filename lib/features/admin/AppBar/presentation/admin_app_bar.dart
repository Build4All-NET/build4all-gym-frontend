import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/app/app_router.dart';
import '../data/models/branch_option_model.dart';
import 'branch_cubit.dart';
import '../../../../l10n/app_localizations.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({
    super.key,
    required this.title,
    this.onAddTap,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onBranchChanged,
    this.selectedBranchId,
    this.actions = const [],
  });

  final String            title;
  final VoidCallback?     onAddTap;
  final int               notificationCount;
  final VoidCallback?     onNotificationTap;
  final void Function(int? branchId)? onBranchChanged;
  final int?              selectedBranchId;
  final List<Widget>      actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color:   cs.surface,                              // ← was Colors.white
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => IconButton(
              icon:  const Icon(Icons.menu_rounded),
              color: cs.onSurface,
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: BlocBuilder<BranchCubit, BranchState>(
              builder: (context, branchState) {
                if (branchState is BranchLoaded) {
                  return _BranchPill(
                    branches:         branchState.branches,
                    selectedBranchId: selectedBranchId,
                    onSelected:       onBranchChanged,
                    allBranchesLabel: AppLocalizations.of(context)!.adminAppBar_allBranches,
                  );
                }
                return _BranchPillPlaceholder(
                  isLoading: branchState is BranchLoading,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize:   15,
                fontWeight: FontWeight.w700,
                color:      cs.onSurface,              // ← was hardcoded
              ),
            ),
          ),
          const SizedBox(width: 6),
          ...actions,
          if (onAddTap != null) ...[
            const SizedBox(width: 6),
            _AddButton(onTap: onAddTap!),
          ],
          const SizedBox(width: 6),
          _NotificationBell(
            count: notificationCount,
            onTap: onNotificationTap ??
                () => Navigator.of(context).pushNamed(AppRouter.adminNotifications),
          ),
        ],
      ),
    );
  }
}

class _BranchPill extends StatelessWidget {
  const _BranchPill({
    required this.branches,
    required this.selectedBranchId,
    required this.onSelected,
    required this.allBranchesLabel,
  });

  final List<BranchOptionModel>        branches;
  final int?                           selectedBranchId;
  final void Function(int? branchId)?  onSelected;
  final String                         allBranchesLabel;

  String get _selectedName {
    if (selectedBranchId == null) return allBranchesLabel;
    for (final b in branches) {
      if (b.id == selectedBranchId) return b.name;
    }
    return allBranchesLabel;
  }

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final pillBg  = cs.primary.withOpacity(0.08);   // ← was Color(0xFFEFF6FF)
    final pillFg  = cs.primary;                       // ← was Color(0xFF1D4ED8)

    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:        pillBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 14, color: pillFg),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              _selectedName,
              style: TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      pillFg,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: pillFg),
        ],
      ),
    );

    if (onSelected == null) return pill;

    return PopupMenuButton<int?>(
      offset:    const Offset(0, 44),
      shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:     cs.surface,
      elevation: 8,
      onSelected: onSelected,
      itemBuilder: (context) => [
        PopupMenuItem<int?>(
          value: null,
          child: _BranchMenuItem(
            icon:       Icons.business_rounded,
            name:       allBranchesLabel,
            isSelected: selectedBranchId == null,
          ),
        ),
        ...branches.map((b) => PopupMenuItem<int?>(
          value: b.id,
          child: _BranchMenuItem(
            icon:       Icons.location_on_rounded,
            name:       b.name,
            isSelected: b.id == selectedBranchId,
          ),
        )),
      ],
      child: pill,
    );
  }
}

class _BranchMenuItem extends StatelessWidget {
  const _BranchMenuItem({
    required this.icon,
    required this.name,
    required this.isSelected,
  });

  final IconData icon;
  final String   name;
  final bool     isSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(width: 10),
        Text(name,
            style: TextStyle(
              fontSize:   13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color:      cs.onSurface,
            )),
        const Spacer(),
        if (isSelected) Icon(Icons.check_rounded, size: 16, color: cs.primary),
      ],
    );
  }
}

class _BranchPillPlaceholder extends StatelessWidget {
  const _BranchPillPlaceholder({required this.isLoading});
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:        cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading
          ? SizedBox(
        width: 14, height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: cs.primary,
        ),
      )
          : Text('...',
          style: TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w600,
            color:      cs.primary,
          )),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color:        cs.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.add_rounded, color: cs.onPrimary, size: 20),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({this.count = 0, this.onTap});
  final int           count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color:        cs.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.notifications_none_rounded,
                color: cs.onSurfaceVariant, size: 18),
          ),
          if (count > 0)
            PositionedDirectional(
              top: 2, end: 2,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(color: cs.error, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: TextStyle(
                      color: cs.onError,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}