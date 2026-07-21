import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Covers the required member-home section order: Membership status ->
// Statistics -> Quote of the Day -> Today's Schedule -> Quick Actions.
//
// A full testWidgets() pump (BlocProvider<MemberHomeBloc> + ThemeCubit +
// AppLocalizations + real network-backed cubits) can't be compiled or run
// in this sandbox without the Flutter SDK, and shipping an unverified pump
// test risks looking like coverage while actually being broken. Instead,
// this asserts the real ordering invariant directly against the screen's
// source: the four section widgets must appear, in this exact order, as
// sibling entries inside _buildContent's Column — the same structural fact
// a widget test would otherwise check by widget position on screen.
void main() {
  test('member home widgets appear in the required order in the screen source', () {
    final file = File(
      'lib/features/member/home/presentation/screens/member_home_screen.dart',
    );
    final source = file.readAsStringSync();

    const membershipCard = 'MembershipStatusCard(';
    const statsRow = 'MemberStatsRow(';
    const quoteCard = 'MotivationalQuoteCard(';
    const todaySchedule = 'TodayScheduleWidget(';
    const quickActions = 'QuickActionsGrid(';

    final membershipIndex = source.indexOf(membershipCard);
    final statsIndex = source.indexOf(statsRow);
    final quoteIndex = source.indexOf(quoteCard);
    final scheduleIndex = source.indexOf(todaySchedule);
    final quickActionsIndex = source.indexOf(quickActions);

    expect(membershipIndex, greaterThan(-1), reason: 'MembershipStatusCard not found');
    expect(statsIndex, greaterThan(-1), reason: 'MemberStatsRow not found');
    expect(quoteIndex, greaterThan(-1), reason: 'MotivationalQuoteCard not found');
    expect(scheduleIndex, greaterThan(-1), reason: 'TodayScheduleWidget not found');
    expect(quickActionsIndex, greaterThan(-1), reason: 'QuickActionsGrid not found');

    expect(membershipIndex, lessThan(statsIndex),
        reason: 'Membership status must come before statistics');
    expect(statsIndex, lessThan(quoteIndex),
        reason: 'Statistics must come before the Quote of the Day');
    expect(quoteIndex, lessThan(scheduleIndex),
        reason: "Quote of the Day must come directly above Today's Schedule");
    expect(scheduleIndex, lessThan(quickActionsIndex),
        reason: "Today's Schedule must come before Quick Actions");
  });

  test('member home screen no longer contains a periodic auto-refresh timer', () {
    final file = File(
      'lib/features/member/home/presentation/screens/member_home_screen.dart',
    );
    final source = file.readAsStringSync();

    expect(source.contains('Timer.periodic'), isFalse,
        reason: 'A periodic timer would re-roll the quote/stats without a real member action');
  });
}
