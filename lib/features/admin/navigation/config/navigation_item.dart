// lib/features/admin/navigation/config/navigation_item.dart

import 'package:flutter/material.dart';

/// A single row entry in the Admin Navigation Drawer.
class NavigationItem {
  final String id;
  final IconData iconData;
  final String labelKey;
  final String route;
  final bool isDestructive; // true → red color (used for Logout)

  // ── Role visibility ─────────────────────────────────────────────────────────
  // Admin/Owner always sees every item. Once the owner's nav-permission matrix
  // has loaded (AdminProfile.gymRolesLoaded), staff visibility is driven by
  // AdminProfile.allowedNavItemIds (see admin_navigation_drawer.dart's canSee).
  // These two flags now only serve as the fallback shown briefly while that
  // matrix is still being fetched, so nav doesn't flash empty on login.
  final bool trainer;   // visible to TRAINER staff while loading
  final bool reception; // visible to RECEPTION staff while loading

  /// False for items the owner can never delegate to staff (e.g. staff role
  /// assignment) — excludes them from the Staff Access Control editor screen.
  /// Does not affect canSee(); those items simply never appear in the
  /// backend-resolved allowedNavItemIds either.
  final bool configurable;

  const NavigationItem({
    required this.id,
    required this.iconData,
    required this.labelKey,
    required this.route,
    this.isDestructive = false,
    this.trainer = false,
    this.reception = false,
    this.configurable = true,
  });
}

/// A labelled group of NavigationItems shown under a section header
/// (e.g. "CORE OWNER", "OPERATIONS / RECEPTION").
/// [labelKey] is null for bottom fixed items (Settings, Logout) — no header shown.
class DrawerSection {
  final String? labelKey;
  final List<NavigationItem> items;

  const DrawerSection({
    this.labelKey,
    required this.items,
  });
}