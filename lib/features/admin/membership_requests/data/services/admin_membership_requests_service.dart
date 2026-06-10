import 'package:dio/dio.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../models/membership_request_card_model.dart';

class AdminMembershipRequestsService {
  Dio get _dio => appDio ?? Dio(BaseOptions(baseUrl: Env.apiProjectBaseUrl));

  String _url(String path) => '${Env.apiProjectBaseUrl}$path';

  Future<List<MembershipRequestCardModel>> getRequests({String status = 'PENDING'}) async {
    final response = await _dio.get(
      _url('/api/admin/membership-requests'),
      queryParameters: {'status': status, 'size': 50},
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['requests'] as List;
    return list
        .map((e) => MembershipRequestCardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> approveRequest(int requestId, double amountPaid, {String? notes}) async {
    final response = await _dio.post(
      _url('/api/admin/membership-requests/$requestId/approve'),
      data: {
        'amountPaid': amountPaid,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return (data['invoiceId'] as num).toInt();
  }

  Future<void> rejectRequest(int requestId, String reason) async {
    await _dio.post(
      _url('/api/admin/membership-requests/$requestId/reject'),
      data: {'rejectionReason': reason},
    );
  }
}
