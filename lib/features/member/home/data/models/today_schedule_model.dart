import 'schedule_item_model.dart';

// This model represents today's schedule section.
// It contains a list of ScheduleItemModel objects.
//
// Example backend JSON:
// {
//   "items": [
//     {
//       "type": "CLASS",
//       "title": "Morning Yoga",
//       "trainerName": "Sara Ahmed",
//       "startTime": "2024-07-15T08:00:00Z",
//       "durationMinutes": 60,
//       "roomName": "Room 1",
//       "status": "booked"
//     },
//     {
//       "type": "PT",
//       "title": "HIIT Training",
//       "trainerName": "Mohamed Ali",
//       "startTime": "2024-07-15T10:00:00Z",
//       "durationMinutes": 45,
//       "roomName": "Room 2",
//       "status": "waitlisted"
//     }
//   ]
// }
//
// After parsing with fromJson, the app can use:
// schedule.items → List<ScheduleItemModel>

class TodayScheduleModel {
  // List of schedule items (classes or PT sessions)
  final List<ScheduleItemModel> items;

  // Creates a typed TodayScheduleModel object
  const TodayScheduleModel({
    required this.items,
  });

  // Converts backend JSON into a TodayScheduleModel object
  factory TodayScheduleModel.fromJson(Map<String, dynamic> json) {
    // Read the list from JSON, or use an empty list if null
    final itemsJson = json['items'] as List<dynamic>? ?? [];

    return TodayScheduleModel(
      // Convert each JSON item into a ScheduleItemModel
      items: itemsJson
          .map((item) =>
          ScheduleItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}