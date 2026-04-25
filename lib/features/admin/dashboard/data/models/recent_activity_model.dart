import '../../domain/entities/recent_activity.dart';
import 'recent_activity_item_model.dart';

class RecentActivityModel {
  final List<RecentActivityItemModel> activities;
  const RecentActivityModel({required this.activities});

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) => RecentActivityModel(
    activities: ((json['activities'] ?? []) as List)
        .map((e) => RecentActivityItemModel.fromJson(e))
        .toList(),
  );

  RecentActivity toEntity() => RecentActivity(
    activities: activities.map((e) => e.toEntity()).toList(),
  );
}