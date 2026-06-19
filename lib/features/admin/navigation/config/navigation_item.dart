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
  // Admin/Owner always sees every item. These flags additionally expose an item
  // to staff gym-roles, so display grouping can change freely without affecting
  // what TRAINER / RECEPTION users are allowed to see.
  final bool trainer;   // visible to TRAINER staff
  final bool reception; // visible to RECEPTION staff

  const NavigationItem({
    required this.id,
    required this.iconData,
    required this.labelKey,
    required this.route,
    this.isDestructive = false,
    this.trainer = false,
    this.reception = false,
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