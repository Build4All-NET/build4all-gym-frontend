import 'package:dio/dio.dart';

import '../models/member_account_model.dart';
import '../models/update_profile_request_model.dart';

class MemberAccountService {
  final Dio _dio;

  MemberAccountService(this._dio);

  // GET /api/member/account
  // Returns the full account summary for the authenticated member.
  Future<MemberAccountModel> getMemberAccount() async {
    final response = await _dio.get('/api/member/account');

    return MemberAccountModel.fromJson(response.data);
  }

  // PATCH /api/member/account/profile
  // Updates the authenticated member's profile.
  // Throws DioException with status 409 if phone is already taken.
  Future<void> updateProfile(UpdateProfileRequestModel request) async {
    await _dio.patch(
      '/api/member/account/profile',
      data: request.toJson(),
    );
  }
}