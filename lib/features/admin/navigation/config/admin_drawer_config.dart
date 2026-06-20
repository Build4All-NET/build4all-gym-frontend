// lib/features/admin/navigation/config/admin_drawer_config.dart
//
// Admin drawer navigation, organised into small, focused groups so the admin
// finds things fast. Admin/Owner sees every item; staff visibility is driven
// per-item (trainer / reception flags) — NOT by section — so the grouping can
// change freely without altering what staff are allowed to see.
//
// Preserved staff access (unchanged from before the regroup):
//   TRAINER   → PT Sessions, PT Packages, Training Videos
//   RECEPTION → Check-ins, Notifications, Membership Requests, Classes & PT,
//               Payments, Invoices, Expenses, Reports

import 'package:flutter/material.dart';
import 'navigation_item.dart';

// ─── Overview ────────────────────────────────────────────────────────────────
const _overviewItems = [
  NavigationItem(
    id: 'dashboard',
    iconData: Icons.grid_view_outlined,
    labelKey: 'navDashboard',
    route: '/admin',
  ),
];

// ─── Members ─────────────────────────────────────────────────────────────────
const _membersItems = [
  NavigationItem(
    id: 'members',
    iconData: Icons.people_outline,
    labelKey: 'navMembers',
    route: '/admin/members',
  ),
  NavigationItem(
    id: 'membership_requests',
    iconData: Icons.pending_actions_outlined,
    labelKey: 'navMembershipRequests',
    route: '/admin/membership-requests',
    reception: true,
  ),
];

// ─── Front Desk ──────────────────────────────────────────────────────────────
const _frontDeskItems = [
  NavigationItem(
    id: 'checkins',
    iconData: Icons.how_to_reg_outlined,
    labelKey: 'navCheckins',
    route: '/admin/checkins',
    reception: true,
  ),
  NavigationItem(
    id: 'notifications',
    iconData: Icons.send_outlined,
    labelKey: 'navNotifications',
    route: '/admin/notifications',
    reception: true,
  ),
];

// ─── Training & Classes ──────────────────────────────────────────────────────
const _trainingItems = [
  NavigationItem(
    id: 'classes_pt',
    iconData: Icons.calendar_month_outlined,
    labelKey: 'navClassesPt',
    route: '/admin/classes',
    reception: true,
  ),
  NavigationItem(
    id: 'trainers',
    iconData: Icons.sports_outlined,
    labelKey: 'navTrainers',
    route: '/admin/trainers',
  ),
  NavigationItem(
    id: 'pt_sessions',
    iconData: Icons.fitness_center_outlined,
    labelKey: 'navPtSessions',
    route: '/admin/pt-services',
    trainer: true,
  ),
  NavigationItem(
    id: 'pt_package_bookings',
    iconData: Icons.assignment_turned_in_outlined,
    labelKey: 'navPtPackageBookings',
    route: '/admin/pt-package-bookings',
    trainer: true,
  ),
  NavigationItem(
    id: 'training_videos',
    iconData: Icons.play_circle_outline,
    labelKey: 'navTrainingVideos',
    route: '/admin/training-videos',
    trainer: true,
  ),
];

// ─── Finance ─────────────────────────────────────────────────────────────────
const _financeItems = [
  NavigationItem(
    id: 'payments',
    iconData: Icons.attach_money_outlined,
    labelKey: 'navPayments',
    route: '/admin/payments',
    reception: true,
  ),
  NavigationItem(
    id: 'invoices',
    iconData: Icons.receipt_long_outlined,
    labelKey: 'navInvoices',
    route: '/admin/invoices',
    reception: true,
  ),
  NavigationItem(
    id: 'expenses',
    iconData: Icons.payments_outlined,
    labelKey: 'navExpenses',
    route: '/admin/expenses',
    reception: true,
  ),
  NavigationItem(
    id: 'balance_sheet',
    iconData: Icons.account_balance_outlined,
    labelKey: 'navBalanceSheet',
    route: '/admin/balance-sheet',
  ),
  NavigationItem(
    id: 'reports',
    iconData: Icons.bar_chart_rounded,
    labelKey: 'navReports',
    route: '/admin/reports',
    reception: true,
  ),
];

// ─── Setup ───────────────────────────────────────────────────────────────────
const _setupItems = [
  NavigationItem(
    id: 'plans',
    iconData: Icons.credit_card_outlined,
    labelKey: 'navPlans',
    route: '/admin/plans',
  ),
  NavigationItem(
    id: 'branches',
    iconData: Icons.store_outlined,
    labelKey: 'navBranches',
    route: '/admin/branches',
  ),
  NavigationItem(
    id: 'reception_staff',
    iconData: Icons.person_outline,
    labelKey: 'navReceptionStaff',
    route: '/admin/staff',
  ),
];

// ─── Tools ───────────────────────────────────────────────────────────────────
const _toolsItems = [
  NavigationItem(
    id: 'ai_assistant',
    iconData: Icons.chat_bubble,
    labelKey: 'navGymProfile',
    route: '/admin/ai_assistant',
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
  DrawerSection(labelKey: 'sectionOverview', items: _overviewItems),
  DrawerSection(labelKey: 'sectionMembers', items: _membersItems),
  DrawerSection(labelKey: 'sectionFrontDesk', items: _frontDeskItems),
  DrawerSection(labelKey: 'sectionTrainingClasses', items: _trainingItems),
  DrawerSection(labelKey: 'sectionFinance', items: _financeItems),
  DrawerSection(labelKey: 'sectionSetup', items: _setupItems),
  DrawerSection(labelKey: 'sectionTools', items: _toolsItems),
];

// ─── BOTTOM FIXED items (shown below divider, not in ListView) ────────────────
const List<NavigationItem> adminDrawerBottomItems = _bottomItems;
