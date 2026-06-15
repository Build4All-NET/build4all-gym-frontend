import 'package:dio/dio.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../../domain/entities/admin_refund_request_entity.dart';
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

  Future<List<AdminRefundRequestEntity>> getRefundRequests({String status = 'pending'}) async {
    final response = await _dio.get(
      _url('/api/admin/refund-requests'),
      queryParameters: {'status': status},
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['requests'] as List;
    return list.map((e) => _parseRefundRequest(e as Map<String, dynamic>)).toList();
  }

  Future<void> approveRefundRequest(
    int refundId,
    double refundAmount, {
    double? deductionAmount,
    String? adminNote,
  }) async {
    await _dio.post(
      _url('/api/admin/refund-requests/$refundId/approve'),
      data: {
        'refundAmount': refundAmount,
        if (deductionAmount != null) 'deductionAmount': deductionAmount,
        if (adminNote != null && adminNote.isNotEmpty) 'adminNote': adminNote,
      },
    );
  }

  Future<void> rejectRefundRequest(int refundId, String reason) async {
    await _dio.post(
      _url('/api/admin/refund-requests/$refundId/reject'),
      data: {'reason': reason},
    );
  }

  AdminRefundRequestEntity _parseRefundRequest(Map<String, dynamic> json) {
    return AdminRefundRequestEntity(
      refundId: (json['refundId'] as num).toInt(),
      memberName: json['memberName'] as String? ?? '',
      memberEmail: json['memberEmail'] as String? ?? '',
      planName: json['planName'] as String? ?? '',
      requestedAmount: (json['requestedAmount'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      type: json['type'] as String?,
    );
  }
}
