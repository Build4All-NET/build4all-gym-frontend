import 'member_stats.dart';
import 'membership_card.dart';
import 'motivational_quote.dart';
import 'today_schedule.dart';

class MemberHome {
  // Membership card data
  final MembershipCard membership;

  // Member statistics
  final MemberStats stats;

  // Today's schedule
  final TodaySchedule schedule;

  // Optional motivational quote
  final MotivationalQuote? quote;

  // Creates a clean MemberHome entity
  const MemberHome({
    required this.membership,
    required this.stats,
    required this.schedule,
    this.quote,
  });
}