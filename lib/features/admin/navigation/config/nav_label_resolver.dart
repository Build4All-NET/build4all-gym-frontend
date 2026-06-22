// lib/features/admin/navigation/config/nav_label_resolver.dart
//
// Maps a NavigationItem.labelKey to its localized display text. Shared by
// AdminDrawerItemWidget and the Staff Access Control screen so both render
// the exact same label for a given item.

import '../../../../l10n/app_localizations.dart';

String resolveNavLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'navDashboard':           return l10n.navDashboard;
    case 'navMembers':             return l10n.navMembers;
    case 'navPlans':               return l10n.navPlans;
    case 'navTrainers':            return l10n.navTrainers;
    case 'navReceptionStaff':      return l10n.navReceptionStaff;
    case 'navGymProfile':          return l10n.navAiAssistant;
    case 'navBranches':            return l10n.navBranches;
    case 'navEmployees':           return l10n.navEmployees;
    case 'navCheckins':            return l10n.navCheckins;
    case 'navEmployeeCheckins':    return l10n.navEmployeeCheckins;
    case 'navPayments':            return l10n.navPayments;
    case 'navMembershipRequests':  return l10n.navMembershipRequests;
    case 'navInvoices':            return l10n.navInvoices;
    case 'navExpenses':            return l10n.navExpenses;
    case 'navClassesPt':           return l10n.navClassesPt;
    case 'navNotifications':       return l10n.navNotifications;
    case 'navPtSessions':          return l10n.navPtSessions;
    case 'navTrainingVideos':      return l10n.navTrainingVideos;
    case 'navPtPackageBookings':   return l10n.navPtPackageBookings;
    case 'navBalanceSheet':        return l10n.navBalanceSheet;
    case 'navReports':             return l10n.navReports;
    case 'navStaffAccessControl':  return l10n.navStaffAccessControl;
    case 'navSettings':            return l10n.navSettings;
    case 'navLogout':              return l10n.navLogout;
    default:                       return key;
  }
}
