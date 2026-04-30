// lib/features/admin/navigation/config/navigation_item.dart

import 'package:flutter/material.dart';

/// A single row entry in the Admin Navigation Drawer.
class NavigationItem {
  final String id;
  final IconData iconData;
  final String labelKey;
  final String route;
  final bool isDestructive; // true → red color (used for Logout)

  const NavigationItem({
    required this.id,
    required this.iconData,
    required this.labelKey,
    required this.route,
    this.isDestructive = false,
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