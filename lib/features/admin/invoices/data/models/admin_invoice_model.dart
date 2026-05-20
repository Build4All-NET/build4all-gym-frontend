import '../../domain/entities/admin_invoice_entity.dart';

class AdminInvoiceMember {
  final int userId;
  final String name;
  final String email;
  final String? phone;

  AdminInvoiceMember({
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
  });

  factory AdminInvoiceMember.fromJson(Map<String, dynamic> j) =>
      AdminInvoiceMember(
        userId: (j['userId'] as num).toInt(),
        name:   j['name']  as String? ?? '',
        email:  j['email'] as String? ?? '',
        phone:  j['phone'] as String?,
      );

  AdminInvoiceMemberEntity toEntity() => AdminInvoiceMemberEntity(
        userId: userId,
        name:   name,
        email:  email,
        phone:  phone,
      );
}

class AdminInvoiceItem {
  final String   itemName;
  final String?  description;
  final int      qty;
  final double   unitPrice;
  final double   discountAmount;
  final double   taxAmount;
  final double   lineTotal;

  AdminInvoiceItem({
    required this.itemName,
    this.description,
    required this.qty,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.lineTotal,
  });

  factory AdminInvoiceItem.fromJson(Map<String, dynamic> j) => AdminInvoiceItem(
        itemName:       j['itemName']       as String? ?? '',
        description:    j['description']    as String?,
        qty:            (j['qty']           as num?)?.toInt() ?? 1,
        unitPrice:      (j['unitPrice']     as num?)?.toDouble() ?? 0.0,
        discountAmount: (j['discountAmount'] as num?)?.toDouble() ?? 0.0,
        taxAmount:      (j['taxAmount']     as num?)?.toDouble() ?? 0.0,
        lineTotal:      (j['lineTotal']     as num?)?.toDouble() ?? 0.0,
      );

  AdminInvoiceItemEntity toEntity() => AdminInvoiceItemEntity(
        itemName:       itemName,
        description:    description,
        qty:            qty,
        unitPrice:      unitPrice,
        discountAmount: discountAmount,
        taxAmount:      taxAmount,
        lineTotal:      lineTotal,
      );
}

class AdminInvoicePayment {
  final String   method;
  final double   amount;
  final String?  paidAt;
  final String?  receivedBy;
  final String?  notes;
  final String   status;

  AdminInvoicePayment({
    required this.method,
    required this.amount,
    this.paidAt,
    this.receivedBy,
    this.notes,
    required this.status,
  });

  factory AdminInvoicePayment.fromJson(Map<String, dynamic> j) =>
      AdminInvoicePayment(
        method:     j['method']     as String? ?? 'CASH',
        amount:     (j['amount']    as num?)?.toDouble() ?? 0.0,
        paidAt:     j['paidAt']     as String?,
        receivedBy: j['receivedBy'] as String?,
        notes:      j['notes']      as String?,
        status:     j['status']     as String? ?? 'completed',
      );

  AdminInvoicePaymentEntity toEntity() => AdminInvoicePaymentEntity(
        method:     method,
        amount:     amount,
        paidAt:     paidAt,
        receivedBy: receivedBy,
        notes:      notes,
        status:     status,
      );
}

class AdminInvoiceModel {
  final int    invoiceId;
  final String invoiceNumber;
  final String invoiceDate;
  final String status;

  final String? branchName;
  final String? branchAddress;
  final String? branchPhone;

  final AdminInvoiceMember?       member;
  final List<AdminInvoiceItem>    items;
  final List<AdminInvoicePayment> payments;

  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  AdminInvoiceModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.status,
    this.branchName,
    this.branchAddress,
    this.branchPhone,
    this.member,
    required this.items,
    required this.payments,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
  });

  factory AdminInvoiceModel.fromJson(Map<String, dynamic> j) => AdminInvoiceModel(
        invoiceId:      (j['invoiceId']      as num).toInt(),
        invoiceNumber:  j['invoiceNumber']   as String? ?? '',
        invoiceDate:    j['invoiceDate']     as String? ?? '',
        status:         j['status']          as String? ?? '',
        branchName:     j['branchName']      as String?,
        branchAddress:  j['branchAddress']   as String?,
        branchPhone:    j['branchPhone']     as String?,
        member: j['member'] != null
            ? AdminInvoiceMember.fromJson(j['member'] as Map<String, dynamic>)
            : null,
        items: (j['items'] as List<dynamic>? ?? [])
            .map((e) => AdminInvoiceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        payments: (j['payments'] as List<dynamic>? ?? [])
            .map((e) => AdminInvoicePayment.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal:       (j['subtotal']       as num?)?.toDouble() ?? 0.0,
        discountAmount: (j['discountAmount'] as num?)?.toDouble() ?? 0.0,
        taxAmount:      (j['taxAmount']      as num?)?.toDouble() ?? 0.0,
        totalAmount:    (j['totalAmount']    as num?)?.toDouble() ?? 0.0,
        paidAmount:     (j['paidAmount']     as num?)?.toDouble() ?? 0.0,
        dueAmount:      (j['dueAmount']      as num?)?.toDouble() ?? 0.0,
      );

  AdminInvoiceEntity toEntity() => AdminInvoiceEntity(
        invoiceId:      invoiceId,
        invoiceNumber:  invoiceNumber,
        invoiceDate:    invoiceDate,
        status:         status,
        branchName:     branchName,
        branchAddress:  branchAddress,
        branchPhone:    branchPhone,
        member:         member?.toEntity(),
        items:          items.map((i) => i.toEntity()).toList(),
        payments:       payments.map((p) => p.toEntity()).toList(),
        subtotal:       subtotal,
        discountAmount: discountAmount,
        taxAmount:      taxAmount,
        totalAmount:    totalAmount,
        paidAmount:     paidAmount,
        dueAmount:      dueAmount,
      );
}

class AdminInvoiceSummaryModel {
  final int    invoiceId;
  final String invoiceNumber;
  final String invoiceDate;
  final String status;
  final String memberName;
  final String memberEmail;
  final String? branchName;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  AdminInvoiceSummaryModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.status,
    required this.memberName,
    required this.memberEmail,
    this.branchName,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
  });

  factory AdminInvoiceSummaryModel.fromJson(Map<String, dynamic> j) =>
      AdminInvoiceSummaryModel(
        invoiceId:     (j['invoiceId']     as num).toInt(),
        invoiceNumber: j['invoiceNumber']  as String? ?? '',
        invoiceDate:   j['invoiceDate']    as String? ?? '',
        status:        j['status']         as String? ?? '',
        memberName:    j['memberName']     as String? ?? '',
        memberEmail:   j['memberEmail']    as String? ?? '',
        branchName:    j['branchName']     as String?,
        totalAmount:   (j['totalAmount']   as num?)?.toDouble() ?? 0.0,
        paidAmount:    (j['paidAmount']    as num?)?.toDouble() ?? 0.0,
        dueAmount:     (j['dueAmount']     as num?)?.toDouble() ?? 0.0,
      );

  AdminInvoiceSummaryEntity toEntity() => AdminInvoiceSummaryEntity(
        invoiceId:     invoiceId,
        invoiceNumber: invoiceNumber,
        invoiceDate:   invoiceDate,
        status:        status,
        memberName:    memberName,
        memberEmail:   memberEmail,
        branchName:    branchName,
        totalAmount:   totalAmount,
        paidAmount:    paidAmount,
        dueAmount:     dueAmount,
      );
}
