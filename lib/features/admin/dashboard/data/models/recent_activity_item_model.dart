import '../../domain/entities/recent_activity_item.dart';

class RecentActivityItemModel {
  final String memberName;
  final String activityType;
  final String description;
  final String timeAgo;

  const RecentActivityItemModel({required this.memberName, required this.activityType,
    required this.description, required this.timeAgo});

  factory RecentActivityItemModel.fromJson(Map<String, dynamic> json) => RecentActivityItemModel(
    memberName: json['memberName'] ?? '',
    activityType: json['activityType'] ?? '',
    description: json['description'] ?? '',
    timeAgo: json['timeAgo'] ?? '',
  );

  RecentActivityItem toEntity() => RecentActivityItem(memberName: memberName,
      activityType: activityType, description: description, timeAgo: timeAgo);
}