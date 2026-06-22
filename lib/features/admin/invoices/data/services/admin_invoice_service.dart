import 'package:dio/dio.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../models/admin_invoice_model.dart';

class AdminInvoiceService {
  Dio get _dio => appDio ?? Dio(BaseOptions(baseUrl: Env.apiProjectBaseUrl));

  String _url(String path) => '${Env.apiProjectBaseUrl}$path';

  Future<AdminInvoiceModel> getInvoice(int invoiceId) async {
    final response = await _dio.get(_url('/api/admin/invoices/$invoiceId'));
    return AdminInvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<AdminInvoiceSummaryModel>> listInvoices({
    int    page   = 0,
    int    size   = 50,
    String? status,
    String? type,
  }) async {
    final Map<String, dynamic> params = {'page': page, 'size': size};
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (type   != null && type.isNotEmpty)   params['type']   = type;
    final response = await _dio.get(
      _url('/api/admin/invoices'),
      queryParameters: params,
    );
    final data    = response.data as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>? ?? [];
    return content
        .map((e) => AdminInvoiceSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Collects more cash toward a partially-paid invoice's due balance. Once the
  // invoice is fully paid the backend flips the owning membership/PT
  // package/class booking back to fully paid automatically.
  Future<AdminInvoiceModel> recordPayment(
      int invoiceId, double amount, {String? notes}) async {
    final response = await _dio.post(
      _url('/api/admin/invoices/$invoiceId/record-payment'),
      data: {
        'amount': amount,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return AdminInvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }
}
