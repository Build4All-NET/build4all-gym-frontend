import 'schedule_item.dart';

// Pure domain entity for today's schedule.
// This file belongs to the domain layer, so it does not contain JSON parsing.
// It only represents clean business data used by the app.
//
// It contains a list of schedule items for the current day.

class TodaySchedule {
  // List of class or PT schedule items shown in today's schedule section
  final List<ScheduleItem> items;

  // Creates a clean TodaySchedule entity
  const TodaySchedule({
    required this.items,
  });
}