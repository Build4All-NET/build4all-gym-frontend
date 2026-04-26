// Example usage:
//
// final json = {
//   "planName": "Active Gold",
//   "planType": "GOLD",
//   "status": "active",
//   "startDate": "2024-06-15",
//   "expirationDate": "2024-07-15",
//   "remainingDays": 23,
//   "canRenew": true,
//   "canFreeze": false
// };
//
// Step 1: Parse JSON into model
// final model = MembershipCardModel.fromJson(json);
//
// Step 2: Convert model into entity (usually inside repositories)
// final entity = MembershipCard(
//   planName: model.planName,
//   planType: model.planType,
//   status: model.status,
//   startDate: model.startDate,
//   expirationDate: model.expirationDate,
//   remainingDays: model.remainingDays,
//   canRenew: model.canRenew,
//   canFreeze: model.canFreeze,
// );
//
// Step 3: Use entity in UI / Bloc
// entity.planName
// entity.remainingDays

class MembershipCard {
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

  // Creates a clean MembershipCard entity
  const MembershipCard({
    required this.planName,
    required this.planType,
    required this.status,
    required this.startDate,
    required this.expirationDate,
    required this.remainingDays,
    required this.canRenew,
    required this.canFreeze,
  });
}