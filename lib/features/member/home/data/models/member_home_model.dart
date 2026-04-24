import 'member_stats_model.dart';
import 'membership_card_model.dart';
import 'motivational_quote_model.dart';
import 'today_schedule_model.dart';
import 'body_progress_model.dart';

// This is the top-level model for the GET /api/member/home response.
// It groups all sections needed by the member home screen into one object.
//
// Example backend JSON:
// {
//   "membership": { ... },
//   "stats": { ... },
//   "schedule": { ... },
//   "quote": { ... }
// }
//
// After parsing with fromJson, the app can use:
// home.membership
// home.stats
// home.schedule
// home.quote

class MemberHomeModel {
  // Membership card section
  final MembershipCardModel membership;

  // Member stats section
  final MemberStatsModel stats;

  // Today's schedule section
  final TodayScheduleModel schedule;

  // Optional motivational quote section
  final MotivationalQuoteModel? quote;
  final BodyProgressModel? bodyProgress;

  // Creates a typed MemberHomeModel object
  const MemberHomeModel({
    required this.membership,
    required this.stats,
    required this.schedule,
    this.quote,
    this.bodyProgress,
  });

  // Converts backend JSON into a MemberHomeModel object
  factory MemberHomeModel.fromJson(Map<String, dynamic> json) {
    return MemberHomeModel(
      // Parse membership object safely, use empty map if null
      membership: MembershipCardModel.fromJson(
        (json['membership'] as Map<String, dynamic>?) ?? {},
      ),

      // Parse stats object safely, use empty map if null
      stats: MemberStatsModel.fromJson(
        (json['stats'] as Map<String, dynamic>?) ?? {},
      ),

      // Parse schedule object safely, use empty map if null
      schedule: TodayScheduleModel.fromJson(
        (json['schedule'] as Map<String, dynamic>?) ?? {},
      ),

      // Parse quote only if it exists, otherwise keep it null
      quote: json['quote'] == null
          ? null
          : MotivationalQuoteModel.fromJson(
        json['quote'] as Map<String, dynamic>,
      ),
      bodyProgress: json['bodyProgress'] == null
          ? null
          : BodyProgressModel.fromJson(
        json['bodyProgress'] as Map<String, dynamic>,
      ),
    );
  }
}