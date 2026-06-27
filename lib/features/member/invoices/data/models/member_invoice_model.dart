import '../../domain/entities/member_invoice_entity.dart';

/// Converts any backend number safely to double.
///
/// Backend can return:
/// - int
/// - double
/// - null
/// - sometimes string depending on serialization
double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }

  return 0.0;
}

/// Converts backend id safely to int.
int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  return 0;
}

/// Model for one invoice item inside invoice details.
///
/// This extends the domain entity because we want to reuse the same fields
/// while adding JSON parsing logic in the data layer.
class MemberInvoiceItemModel extends MemberInvoiceItemEntity {
  const MemberInvoiceItemModel({
    required super.itemName,
    super.description,
    required super.qty,
    required super.unitPrice,
    required super.discountAmount,
    required super.taxAmount,
    required super.lineTotal,
  });

  factory MemberInvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return MemberInvoiceItemModel(
      itemName: json['itemName']?.toString() ?? '',
      description: json['description']?.toString(),
      qty: _toInt(json['qty']),
      unitPrice: _toDouble(json['unitPrice']),
      discountAmount: _toDouble(json['discountAmount']),
      taxAmount: _toDouble(json['taxAmount']),
      lineTotal: _toDouble(json['lineTotal']),
    );
  }
}

/// Model for one payment row inside invoice details.
class MemberInvoicePaymentModel extends MemberInvoicePaymentEntity {
  const MemberInvoicePaymentModel({
    super.method,
    required super.amount,
    super.paidAt,
    super.notes,
    required super.status,
  });

  factory MemberInvoicePaymentModel.fromJson(Map<String, dynamic> json) {
    return MemberInvoicePaymentModel(
      method: json['method']?.toString(),
      amount: _toDouble(json['amount']),
      paidAt: json['paidAt']?.toString(),
      notes: json['notes']?.toString(),
      status: json['status']?.toString() ?? '',
    );
  }
}

/// Full invoice model.
///
/// Used for:
/// GET /api/member/invoices/{invoiceId}
class MemberInvoiceModel extends MemberInvoiceEntity {
  const MemberInvoiceModel({
    required super.invoiceId,
    required super.invoiceNumber,
    required super.invoiceDate,
    required super.status,
    super.branchName,
    super.branchAddress,
    super.branchPhone,
    required super.items,
    required super.payments,
    required super.subtotal,
    required super.discountAmount,
    required super.taxAmount,
    required super.totalAmount,
    required super.paidAmount,
    required super.dueAmount,
  });

  factory MemberInvoiceModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final paymentsJson = json['payments'];

    return MemberInvoiceModel(
      invoiceId: _toInt(json['invoiceId']),
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      invoiceDate: json['invoiceDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      branchName: json['branchName']?.toString(),
      branchAddress: json['branchAddress']?.toString(),
      branchPhone: json['branchPhone']?.toString(),

      // Backend returns items as a list.
      // If it returns null, we use an empty list to avoid UI crashes.
      items: itemsJson is List
          ? itemsJson
          .whereType<Map<String, dynamic>>()
          .map(MemberInvoiceItemModel.fromJson)
          .toList()
          : const [],

      // Same logic for payments.
      payments: paymentsJson is List
          ? paymentsJson
          .whereType<Map<String, dynamic>>()
          .map(MemberInvoicePaymentModel.fromJson)
          .toList()
          : const [],

      subtotal: _toDouble(json['subtotal']),
      discountAmount: _toDouble(json['discountAmount']),
      taxAmount: _toDouble(json['taxAmount']),
      totalAmount: _toDouble(json['totalAmount']),
      paidAmount: _toDouble(json['paidAmount']),
      dueAmount: _toDouble(json['dueAmount']),
    );
  }
}

/// Lightweight invoice model used in payment history list.
///
/// Used for:
/// GET /api/member/invoices
class MemberInvoiceSummaryModel extends MemberInvoiceSummaryEntity {
  const MemberInvoiceSummaryModel({
    required super.invoiceId,
    required super.invoiceNumber,
    required super.invoiceDate,
    required super.status,
    super.branchName,
    required super.totalAmount,
    required super.paidAmount,
    required super.dueAmount,
    super.type,
    super.paymentMethod,
    super.refundStatus,
    required super.canRequestRefund,
    super.refundWindowEndsAt,
    super.refundedAmount,
    super.deductionAmount,
  });

  factory MemberInvoiceSummaryModel.fromJson(Map<String, dynamic> json) {
    return MemberInvoiceSummaryModel(
      invoiceId: _toInt(json['invoiceId']),
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      invoiceDate: json['invoiceDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      branchName: json['branchName']?.toString(),
      totalAmount: _toDouble(json['totalAmount']),
      paidAmount: _toDouble(json['paidAmount']),
      dueAmount: _toDouble(json['dueAmount']),
      type: json['type']?.toString(),
      paymentMethod: json['paymentMethod']?.toString(),
      refundStatus: json['refundStatus']?.toString(),
      canRequestRefund: json['canRequestRefund'] == true,
      refundWindowEndsAt: json['refundWindowEndsAt']?.toString(),
      refundedAmount: json['refundedAmount'] != null
          ? _toDouble(json['refundedAmount'])
          : null,
      deductionAmount: json['deductionAmount'] != null
          ? _toDouble(json['deductionAmount'])
          : null,
    );
  }
}