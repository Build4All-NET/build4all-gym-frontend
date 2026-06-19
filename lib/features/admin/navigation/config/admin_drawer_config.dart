// lib/features/admin/navigation/config/admin_drawer_config.dart

import 'package:flutter/material.dart';
import 'navigation_item.dart';

// ─── CORE OWNER items ────────────────────────────────────────────────────────
const _coreOwnerItems = [
  NavigationItem(
    id: 'dashboard',
    iconData: Icons.grid_view_outlined,
    labelKey: 'navDashboard',
    route: '/admin',
  ),
  NavigationItem(
    id: 'members',
    iconData: Icons.people_outline,
    labelKey: 'navMembers',
    route: '/admin/members',
  ),
  NavigationItem(
    id: 'plans',
    iconData: Icons.credit_card_outlined,
    labelKey: 'navPlans',
    route: '/admin/plans',
  ),
  NavigationItem(
    id: 'trainers',
    iconData: Icons.sports_outlined,
    labelKey: 'navTrainers',
    route: '/admin/trainers',
  ),
  NavigationItem(
    id: 'reception_staff',
    iconData: Icons.person_outline,
    labelKey: 'navReceptionStaff',
    route: '/admin/staff',
  ),
  NavigationItem(
    id: 'ai_assistant',
    iconData: Icons.chat_bubble,
    labelKey: 'navGymProfile',
    route: '/admin/ai_assistant',
  ),
  NavigationItem(
    id: 'branches',
    iconData: Icons.store_outlined,
    labelKey: 'navBranches',
    route: '/admin/branches',
  ),
];

// ─── OPERATIONS / RECEPTION items ────────────────────────────────────────────
const _operationsItems = [
  NavigationItem(
    id: 'checkins',
    iconData: Icons.how_to_reg_outlined,
    labelKey: 'navCheckins',
    route: '/admin/checkins',
  ),
  NavigationItem(
    id: 'payments',
    iconData: Icons.attach_money_outlined,
    labelKey: 'navPayments',
    route: '/admin/payments',
  ),
  NavigationItem(
    id: 'membership_requests',
    iconData: Icons.pending_actions_outlined,
    labelKey: 'navMembershipRequests',
    route: '/admin/membership-requests',
  ),
  NavigationItem(
    id: 'invoices',
    iconData: Icons.receipt_long_outlined,
    labelKey: 'navInvoices',
    route: '/admin/invoices',
  ),
  NavigationItem(
    id: 'expenses',
    iconData: Icons.payments_outlined,
    labelKey: 'navExpenses',
    route: '/admin/expenses',
  ),
  NavigationItem(
    id: 'reports',
    iconData: Icons.bar_chart_rounded,
    labelKey: 'navReports',
    route: '/admin/reports',
  ),
  NavigationItem(
    id: 'classes_pt',
    iconData: Icons.calendar_month_outlined,
    labelKey: 'navClassesPt',
    route: '/admin/classes',
  ),
  NavigationItem(
    id: 'notifications',
    iconData: Icons.send_outlined,
    labelKey: 'navNotifications',
    route: '/admin/notifications',
  ),
];

// ─── TRAINING / PT items ─────────────────────────────────────────────────────
const _trainingItems = [
  NavigationItem(
    id: 'pt_sessions',
    iconData: Icons.fitness_center_outlined,
    labelKey: 'navPtSessions',
    route: '/admin/pt-services',
  ),
  NavigationItem(
    id: 'pt_package_bookings',
    iconData: Icons.assignment_turned_in_outlined,
    labelKey: 'navPtPackageBookings',
    route: '/admin/pt-package-bookings',
  ),
  NavigationItem(
    id: 'training_videos',
    iconData: Icons.play_circle_outline,
    labelKey: 'navTrainingVideos',
    route: '/admin/training-videos',
  ),
];

// ─── BOTTOM FIXED items (no section label) ────────────────────────────────────
const _bottomItems = [
  NavigationItem(
    id: 'settings',
    iconData: Icons.settings_outlined,
    labelKey: 'navSettings',
    route: '/admin/settings',
  ),
  NavigationItem(
    id: 'logout',
    iconData: Icons.logout,
    labelKey: 'navLogout',
    route: '/logout',
  ),
];

// ─── SCROLLABLE sections (shown in ListView) ──────────────────────────────────
const List<DrawerSection> adminDrawerSections = [
  DrawerSection(labelKey: 'sectionCoreOwner', items: _coreOwnerItems),
  DrawerSection(labelKey: 'sectionOperationsReception', items: _operationsItems),
  DrawerSection(labelKey: 'sectionTrainingPt', items: _trainingItems),
];

// ─── BOTTOM FIXED items (shown below divider, not in ListView) ────────────────
const List<NavigationItem> adminDrawerBottomItems = _bottomItems;