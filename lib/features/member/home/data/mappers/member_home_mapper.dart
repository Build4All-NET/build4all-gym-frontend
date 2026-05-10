import '../../domain/entities/body_metric.dart';
import '../../domain/entities/member_home.dart';
import '../../domain/entities/member_stats.dart';
import '../../domain/entities/membership_card.dart';
import '../../domain/entities/motivational_quote.dart';
import '../../domain/entities/schedule_item.dart';
import '../../domain/entities/today_schedule.dart';

import '../models/body_metric_model.dart';
import '../models/member_home_model.dart';
import '../models/member_stats_model.dart';
import '../models/membership_card_model.dart';
import '../models/motivational_quote_model.dart';
import '../models/schedule_item_model.dart';
import '../models/today_schedule_model.dart';

/// This file converts data models into domain entities.
///
/// Why this file exists:
/// - Models belong to the data layer and know about backend JSON.
/// - Entities belong to the domain layer and should stay clean.
/// - The repositories uses these mappers before returning data to usecases/BLoC.
///
/// Example:
/// Backend JSON -> MemberHomeModel -> MemberHome entity
/// The UI should work with MemberHome, not raw JSON or backend models.
extension BodyMetricModelMapper on BodyMetricModel {
  /// Converts the saved weight response into a clean BodyMetric entity.
  ///
  /// Example:
  /// BodyMetricModel(weight: 75.5, recordedAt: '2024-07-15T10:30:00Z')
  /// becomes:
  /// BodyMetric(weight: 75.5, recordedAt: '2024-07-15T10:30:00Z')
  BodyMetric toEntity() {
    return BodyMetric(
      weight: weight,
      recordedAt: recordedAt,
    );
  }
}

extension MemberHomeModelMapper on MemberHomeModel {
  /// Converts the full home response model into the domain entity.
  ///
  /// Example:
  /// MemberHomeModel(
  ///   membership: MembershipCardModel(...),
  ///   stats: MemberStatsModel(...),
  ///   schedule: TodayScheduleModel(...),
  ///   quote: MotivationalQuoteModel(...),
  /// )
  ///
  /// becomes:
  /// MemberHome(
  ///   membership: MembershipCard(...),
  ///   stats: MemberStats(...),
  ///   schedule: TodaySchedule(...),
  ///   quote: MotivationalQuote(...),
  /// )
  MemberHome toEntity() {
    return MemberHome(
      membership: membership.toEntity(),
      stats: stats.toEntity(),
      schedule: schedule.toEntity(),
      quote: quote?.toEntity(),
    );
  }
}

extension MembershipCardModelMapper on MembershipCardModel {
  /// Converts membership JSON model into a clean MembershipCard entity.
  ///
  /// Example:
  /// planName: 'ذهبية نشطة'
  /// remainingDays: 23
  MembershipCard toEntity() {
    return MembershipCard(
      planName: planName,
      planType: planType,
      status: status,
      startDate: startDate,
      expirationDate: expirationDate,
      remainingDays: remainingDays,
      canRenew: canRenew,
      canFreeze: canFreeze,
    );
  }
}

extension MemberStatsModelMapper on MemberStatsModel {
  /// Converts the 3-stat row model into a clean MemberStats entity.
  ///
  /// Example:
  /// sessionsCount = 12
  /// kgLost = 8.5
  /// workoutsCount = 24
  MemberStats toEntity() {
    return MemberStats(
      sessionsCount: sessionsCount,
      kgLost: kgLost,
      workoutsCount: workoutsCount,
      referralCode: referralCode,
    );
  }
}

extension TodayScheduleModelMapper on TodayScheduleModel {
  /// Converts today's schedule model into a clean TodaySchedule entity.
  ///
  /// Example:
  /// items: [ScheduleItemModel(...), ScheduleItemModel(...)]
  /// becomes:
  /// items: [ScheduleItem(...), ScheduleItem(...)]
  TodaySchedule toEntity() {
    return TodaySchedule(
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}

extension ScheduleItemModelMapper on ScheduleItemModel {
  /// Converts one class/PT session model into a clean ScheduleItem entity.
  ///
  /// Example:
  /// title = 'يوغا صباحية'
  /// trainerName = 'سارة أحمد'
  /// durationMinutes = 60
  ScheduleItem toEntity() {
    return ScheduleItem(
      type: type,
      title: title,
      trainerName: trainerName,
      startTime: startTime,
      durationMinutes: durationMinutes,
      roomName: roomName,
      status: status,
    );
  }
}

extension MotivationalQuoteModelMapper on MotivationalQuoteModel {
  /// Converts quote model into a clean MotivationalQuote entity.
  ///
  /// Example:
  /// text = 'لا تتوقف عندما تتعب، توقف عندما تنتهي'
  /// languageCode = 'ar'
  MotivationalQuote toEntity() {
    return MotivationalQuote(
      text: text,
      languageCode: languageCode,
    );
  }
}