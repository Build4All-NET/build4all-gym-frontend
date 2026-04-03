import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required int id,
    required int ownerProjectLinkId,
    String? username,
    String? fullname,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
  }) : super(
    id: id,
    ownerProjectLinkId: ownerProjectLinkId,
    username: username,
    fullname: fullname,
    email: email,
    phoneNumber: phoneNumber,
    profilePictureUrl: profilePictureUrl,
  );

  factory UserModel.fromLoginJson(Map<String, dynamic> json) {

    final user = json['user'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: (user['id'] as num).toInt(),
      ownerProjectLinkId: (user['ownerProjectLinkId'] as num).toInt(),
      username: user['username'] as String?,
      fullname: user['fullname'] as String?,
      email: user['email'] as String?,
      phoneNumber: user['phoneNumber'] as String?,
      profilePictureUrl: user['profilePictureUrl'] as String?,
    );
  }
}
