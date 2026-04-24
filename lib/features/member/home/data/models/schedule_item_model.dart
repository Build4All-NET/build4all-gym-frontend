// This model converts one schedule item from backend JSON into a typed Dart object.
// It represents a single class session or personal training session shown in today's schedule.
//
// Example backend JSON:
// {
//   "type": "CLASS",
//   "title": "Morning Yoga",
//   "trainerName": "Sara Ahmed",
//   "startTime": "2024-07-15T08:00:00Z",
//   "durationMinutes": 60,
//   "roomName": "Room 1",
//   "status": "booked"
// }
//
// After parsing with fromJson, the app can use:
// item.type
// item.title
// item.trainerName
// item.startTime
// item.durationMinutes
// item.roomName
// item.status

class ScheduleItemModel {
  // Type of session such as CLASS or PT
  final String type;

  // Title of the class or session
  final String title;

  // Trainer name shown in the schedule card
  final String trainerName;

  // Start time as an ISO datetime string
  final String startTime;

  // Duration of the session in minutes
  final int durationMinutes;

  // Optional room name, may be null if backend does not send it
  final String? roomName;

  // Booking status such as booked or waitlisted
  final String status;

  // Creates a typed ScheduleItemModel object
  const ScheduleItemModel({
    required this.type,
    required this.title,
    required this.trainerName,
    required this.startTime,
    required this.durationMinutes,
    this.roomName,
    required this.status,
  });

  // Converts backend JSON into a ScheduleItemModel object
  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      // Safely read the type, fallback to empty string if null
      type: json['type']?.toString() ?? '',

      // Safely read the title, fallback to empty string if null
      title: json['title']?.toString() ?? '',

      // Safely read the trainer name, fallback to empty string if null
      trainerName: json['trainerName']?.toString() ?? '',

      // Safely read the start time, fallback to empty string if null
      startTime: json['startTime']?.toString() ?? '',

      // Safely convert numeric value to int, fallback to 0 if null
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,

      // Room name is optional, so keep it nullable
      roomName: json['roomName']?.toString(),

      // Safely read the status, fallback to empty string if null
      status: json['status']?.toString() ?? '',
    );
  }
}