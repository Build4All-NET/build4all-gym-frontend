import 'package:dio/dio.dart';
import '../models/coupon_validation_response_model.dart';
import '../models/my_membership_model.dart';
import '../models/plan_detail_model.dart';
import '../models/plan_list_item_model.dart';

abstract class MemberPlansRemoteDatasource {
  Future<List<PlanListItemModel>> getActivePlans();

  Future<PlanDetailModel> getPlanDetail(int planId);

  Future<MyMembershipModel> getMyMembership();

  Future<CouponValidationResponseModel> validateCoupon(
    String couponCode,
    int planId,
  );
}

class MemberPlansRemoteDatasourceImpl implements MemberPlansRemoteDatasource {
  final Dio dio;

  MemberPlansRemoteDatasourceImpl({
    required this.dio,
  });

  @override
  Future<List<PlanListItemModel>> getActivePlans() async {
    try {
      final response = await dio.get('/api/member/plans');

      final data = response.data as List;

      return data
          .map(
            (item) => PlanListItemModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<PlanDetailModel> getPlanDetail(int planId) async {
    try {
      final response = await dio.get('/api/member/plans/$planId');

      return PlanDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<MyMembershipModel> getMyMembership() async {
    try {
      final response = await dio.get('/api/member/plans/my-membership');

      return MyMembershipModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw NoActiveMembershipException(
          _extractMessage(e) ?? 'No active membership found',
        );
      }

      throw _handleDioException(e);
    }
  }

  @override
  Future<CouponValidationResponseModel> validateCoupon(
    String couponCode,
    int planId,
  ) async {
    try {
      final response = await dio.post(
        '/api/member/plans/validate-coupon',
        data: {
          'couponCode': couponCode,
          'planId': planId,
        },
      );

      return CouponValidationResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    final message = _extractMessage(e);

    if (e.response != null) {
      return ServerException(
        message ?? 'Server error',
        statusCode: e.response?.statusCode,
      );
    }

    return NetworkException(
      message ?? 'Network error. Please check your connection.',
    );
  }

  String? _extractMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }

      final error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    return e.message;
  }
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}

class NoActiveMembershipException implements Exception {
  final String message;

  NoActiveMembershipException(this.message);

  @override
  String toString() => message;
}