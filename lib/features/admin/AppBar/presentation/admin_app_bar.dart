// =============================================================================
// FILE: lib/features/admin/shared/widgets/admin_app_bar.dart
// CHANGE: Branch pill now reads from BranchCubit — nothing is static
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/branch_option_model.dart';
import 'branch_cubit.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({
    super.key,
    required this.title,
    this.onAddTap,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onBranchChanged,       // called when admin picks a branch
    this.selectedBranchId,      // null = "All Branches"
    this.actions = const [],
  });

  final String            title;
  final VoidCallback?     onAddTap;
  final int               notificationCount;
  final VoidCallback?     onNotificationTap;
  final void Function(int? branchId)? onBranchChanged; // null = All Branches
  final int?              selectedBranchId;
  final List<Widget>      actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color:   Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded),
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
                    branches: branchState.branches,
                    selectedBranchId: selectedBranchId,
                    onSelected: onBranchChanged,
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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
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
            onTap: onNotificationTap,
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// _BranchPill — populated from DB via BranchCubit
// ─────────────────────────────────────────────────────────────────────────────
class _BranchPill extends StatelessWidget {
  const _BranchPill({
    required this.branches,
    required this.selectedBranchId,
    required this.onSelected,
  });

  final List<BranchOptionModel>       branches;
  final int?                          selectedBranchId;
  final void Function(int? branchId)? onSelected;

  String get _selectedName {
    if (selectedBranchId == null) return 'All Branches';

    for (final branch in branches) {
      if (branch.id == selectedBranchId) {
        return branch.name;
      }
    }

    return 'All Branches';
  }

  @override
  Widget build(BuildContext context) {
    const pillBg = Color(0xFFEFF6FF);
    const pillFg = Color(0xFF1D4ED8);

    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:        pillBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded,
              size: 14, color: Color(0xFF3B82F6)),
          const SizedBox(width: 5),

          Expanded(
            child: Text(
              _selectedName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: pillFg,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 3),
          const Icon(Icons.keyboard_arrow_down_rounded,
              size: 16, color: Color(0xFF3B82F6)),
        ],
      ),
    );

    if (onSelected == null) return pill;

    return PopupMenuButton<int?>(
      offset:    const Offset(0, 44),
      shape:     RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      color:     Colors.white,
      elevation: 8,
      onSelected: onSelected,
      itemBuilder: (context) => [
        // "All Branches" option
        PopupMenuItem<int?>(
          value: null,
          child: _BranchMenuItem(
            icon:       Icons.business_rounded,
            name:       'All Branches',
            isSelected: selectedBranchId == null,
          ),
        ),
        // One item per branch from DB
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
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 10),
        Text(name,
            style: TextStyle(
              fontSize:   13,
              fontWeight: isSelected
                  ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF374151),
            )),
        const Spacer(),
        if (isSelected)
          const Icon(Icons.check_rounded,
              size: 16, color: Color(0xFF3B82F6)),
      ],
    );
  }
}

class _BranchPillPlaceholder extends StatelessWidget {
  const _BranchPillPlaceholder({required this.isLoading});
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:        const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      // ← FIX: use Center instead of Row to avoid overflow
      child: isLoading
          ? const SizedBox(
        width:  14,
        height: 14,
        child:  CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Color(0xFF3B82F6),
        ),
      )
          : const Text(
        '...',
        style: TextStyle(
          fontSize:   13,
          fontWeight: FontWeight.w600,
          color:      Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AddButton / _NotificationBell (unchanged)
// ─────────────────────────────────────────────────────────────────────────────
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color:        Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
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
              color:        const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.notifications_none_rounded,
                color: cs.onSurfaceVariant, size: 18),
          ),
          if (count > 0)
            Positioned(
              top: 2, right: 2,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                    color: cs.error, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// =============================================================================
// FILE: lib/app/app_router.dart
// Wrap adminDashboard and all admin routes with BranchCubit
// so branches load once and are available everywhere
// =============================================================================

/*
  In your router, wrap the admin section with BlocProvider<BranchCubit>:

  case adminDashboard:
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => BranchCubit()..loadBranches(), // ← loads once here
        child: AdminDashboardScreen(),
      ),
    );

  For other admin screens that also need the branch pill,
  wrap them the same way:

  case adminClasses:
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BranchCubit()..loadBranches(),
          ),
          BlocProvider(
            create: (_) => AdminClassesBloc(...),
          ),
        ],
        child: const AdminClassesScreen(),
      ),
    );

  OR — better approach — provide BranchCubit at the app level
  in main.dart so it loads once for the entire admin session:

  // In main.dart or MaterialApp builder:
  BlocProvider(
    create: (_) => BranchCubit(), // loaded on-demand when first needed
    child: MaterialApp(...),
  )
*/


// =============================================================================
// HOW TO USE AdminAppBar IN EACH SCREEN
// Each screen manages its own _selectedBranchId in local state
// =============================================================================

/*
  class _AdminPlansScreenState extends State<AdminPlansScreen> {
    int? _selectedBranchId; // null = All Branches

    @override
    void initState() {
      super.initState();
      // Load branches if not yet loaded
      context.read<BranchCubit>().loadBranches();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AdminAppBar(
                title:            'Plans',
                selectedBranchId: _selectedBranchId,
                onBranchChanged:  (branchId) {
                  setState(() => _selectedBranchId = branchId);
                  // Re-fetch plans filtered by the selected branch
                  context.read<AdminPlansBloc>()
                      .add(LoadAdminPlansEvent(branchId: branchId));
                },
                onAddTap: () => PlanFormBottomSheet.show(context, ...),
                notificationCount: 3,
              ),
              // ... rest of screen
            ],
          ),
        ),
      );
    }
  }
*/