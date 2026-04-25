// This model converts raw backend JSON into a typed Dart object.
// It is the data contract between the HTTP/API layer and the rest of the app.
// Instead of using raw JSON keys across the app, we parse the response here once
// and then work with a clean structured object.
//
// Why this model exists:
// - Keeps JSON parsing inside the data layer
// - Gives the app type-safe fields
// - Prevents crashes when backend values are null
// - Makes repositories and domain mapping cleaner
//
// Example backend JSON:
// {
//   "planName": "Active Gold",
//   "planType": "GOLD",
//   "status": "active",
//   "startDate": "2024-06-15",
//   "expirationDate": "2024-07-15",
//   "remainingDays": 23,
//   "canRenew": true,
//   "canFreeze": false
// }
//
// After parsing with fromJson, the app can use:
// membership.planName
// membership.status
// membership.remainingDays
// instead of raw access like json['planName']

class MembershipCardModel {
  // The display name of the membership plan shown in the UI
  final String planName;

  // The internal plan type returned by the backend
  final String planType;

  // Membership status such as active, frozen, expired, or cancelled
  final String status;

  // Membership start date as an ISO string
  final String startDate;

  // Membership expiration date as an ISO string
  final String expirationDate;

  // Number of days remaining before the membership expires
  final int remainingDays;

  // Controls whether the user can renew the membership
  final bool canRenew;

  // Controls whether the user can freeze the membership
  final bool canFreeze;

  // Creates a typed MembershipCardModel object
  const MembershipCardModel({
    required this.planName,
    required this.planType,
    required this.status,
    required this.startDate,
    required this.expirationDate,
    required this.remainingDays,
    required this.canRenew,
    required this.canFreeze,
  });

  // Converts backend JSON into a MembershipCardModel object
  factory MembershipCardModel.fromJson(Map<String, dynamic> json) {
    return MembershipCardModel(
      // Safely read the value as String, fallback to empty string if null
      planName: json['planName']?.toString() ?? '',

      // Safely read the plan type, fallback to empty string if null
      planType: json['planType']?.toString() ?? '',

      // Safely read the membership status, fallback to empty string if null
      status: json['status']?.toString() ?? '',

      // Safely read the start date, fallback to empty string if null
      startDate: json['startDate']?.toString() ?? '',

      // Safely read the expiration date, fallback to empty string if null
      expirationDate: json['expirationDate']?.toString() ?? '',

      // Safely convert numeric values to int, fallback to 0 if null
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 0,

      // Safely read bool value, fallback to false if null
      canRenew: json['canRenew'] as bool? ?? false,

      // Safely read bool value, fallback to false if null
      canFreeze: json['canFreeze'] as bool? ?? false,
    );
  }
}