// lib/features/admin/navigation/presentation/widgets/admin_navigation_drawer.dart

import 'package:build4allgym/features/auth/data/services/admin_token_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../../../../features/auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../config/admin_drawer_config.dart';
import '../../config/navigation_item.dart';
import '../cubit/drawer_cubit.dart';
import '../cubit/drawer_state.dart';
import 'admin_drawer_header_widget.dart';
import 'admin_drawer_item_widget.dart';

class AdminNavigationDrawer extends StatelessWidget {
  final String  gymName;
  final String  branchName;
  final String  adminName;
  final String  adminEmail;
  final String? avatarUrl;
  final String  initialActiveId;

  const AdminNavigationDrawer({
    super.key,
    required this.gymName,
    required this.branchName,
    required this.adminName,
    required this.adminEmail,
    required this.initialActiveId,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DrawerCubit>(
      create: (_) => DrawerCubit(initialActiveId: initialActiveId),
      child: _DrawerBody(
        gymName:    gymName,
        branchName: branchName,
        adminName:  adminName,
        adminEmail: adminEmail,
        avatarUrl:  avatarUrl,
      ),
    );
  }
}

// ─── Internal body ────────────────────────────────────────────────────────────

class _DrawerBody extends StatelessWidget {
  final String  gymName;
  final String  branchName;
  final String  adminName;
  final String  adminEmail;
  final String? avatarUrl;

  const _DrawerBody({
    required this.gymName,
    required this.branchName,
    required this.adminName,
    required this.adminEmail,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final profile = context.watch<AdminProfileCubit>().state;
    debugPrint('🎯 Drawer → role: ${profile.role}, gymRoles: ${profile.gymRoles}, isTrainer: ${profile.isTrainerRole}');

    // ── Filter sections by role ──────────────────────────────────────────────
    // isAdminRole (OWNER/ADMIN/MANAGER JWT role) → all sections.
    // Staff gym roles (TRAINER / RECEPTION) → only their section(s)

    final visibleSections = adminDrawerSections.where((section) {
      if (profile.isAdminRole) return true;
      if (section.labelKey == 'sectionCoreOwner') return false;
      if (section.labelKey == 'sectionTrainingPt') return profile.isTrainerRole;
      if (section.labelKey == 'sectionOperationsReception') return profile.isReceptionRole;
      return false;
    }).toList();

    return Drawer(
      width: 255,
      backgroundColor: theme.colorScheme.surface,
      elevation: 8,
      child: BlocBuilder<DrawerCubit, DrawerState>(
        builder: (context, state) {
          return Column(
            children: [
              // ── HEADER ─────────────────────────────────────────────────────
              AdminDrawerHeaderWidget(
                gymName:    gymName,
                branchName: branchName,
                adminName:  adminName,
                adminEmail: adminEmail,
                avatarUrl:  avatarUrl,
                onClose:    () => Navigator.of(context).pop(),
                onProfileTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/admin/settings');
                },
              ),

              // ── SCROLLABLE NAV SECTIONS ─────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  children: [
                    for (final section in visibleSections) ...[
                      if (section.labelKey != null)
                        _SectionLabel(labelKey: section.labelKey!),
                      for (final item in section.items)
                        AdminDrawerItemWidget(
                          item:     item,
                          isActive: state.activeItemId == item.id,
                          onTap:    () => _navigate(context, item),
                        ),
                    ],
                  ],
                ),
              ),

              // ── FIXED BOTTOM (Settings + Logout) ───────────────────────────
              const Divider(height: 1, thickness: 1),
              SafeArea(
                top: false,
                child: Column(
                  children: [
                    for (final item in adminDrawerBottomItems)
                      AdminDrawerItemWidget(
                        item:     item,
                        isActive: state.activeItemId == item.id,
                        onTap:    () => item.isDestructive
                            ? _confirmLogout(context)
                            : _navigate(context, item),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, NavigationItem item) {
    context.read<DrawerCubit>().selectItem(item.id);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(item.route);
  }

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pop();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title:   Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.navLogout),
          ),
        ],
      ),
    );
  }
}

// ─── Section label widget ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String labelKey;
  const _SectionLabel({required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n  = AppLocalizations.of(context)!;

    final label = switch (labelKey) {
      'sectionCoreOwner'           => l10n.sectionCoreOwner,
      'sectionOperationsReception' => l10n.sectionOperationsReception,
      'sectionTrainingPt'          => l10n.sectionTrainingPt,
      _                            => labelKey,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color:         theme.colorScheme.onSurface.withOpacity(0.40),
          fontWeight:    FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}