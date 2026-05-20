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
  }) async {
    final Map<String, dynamic> params = {'page': page, 'size': size};
    if (status != null && status.isNotEmpty) params['status'] = status;
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
}
