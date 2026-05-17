import '../../domain/entities/gym_profile_entity.dart';

class GymProfileModel {
  final int    userId;
  final String gymRole;
  final String fullName;
  final List<String> gymRoles;

  const GymProfileModel({
    required this.userId,
    required this.gymRole,
    required this.fullName,
    this.gymRoles = const [],
  });

  factory GymProfileModel.fromJson(Map<String, dynamic> json) {
    final rolesList = (json['gymRoles'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [];

    return GymProfileModel(
      userId:   (json['userId']   as num?)?.toInt() ?? 0,
      gymRole:  (json['gymRole']  as String?)        ?? 'MEMBER',
      fullName: (json['fullName'] as String?)        ?? '',
      gymRoles: rolesList,
    );
  }

  GymProfileEntity toEntity() => GymProfileEntity(
    userId:   userId,
    gymRole:  gymRole,
    fullName: fullName,
    gymRoles: gymRoles,
  );
}
