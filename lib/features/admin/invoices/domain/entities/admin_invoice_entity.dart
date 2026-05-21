class AdminInvoiceMemberEntity {
  final int     userId;
  final String  name;
  final String  email;
  final String? phone;

  const AdminInvoiceMemberEntity({
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
  });
}

class AdminInvoiceItemEntity {
  final String  itemName;
  final String? description;
  final int     qty;
  final double  unitPrice;
  final double  discountAmount;
  final double  taxAmount;
  final double  lineTotal;

  const AdminInvoiceItemEntity({
    required this.itemName,
    this.description,
    required this.qty,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.lineTotal,
  });
}

class AdminInvoicePaymentEntity {
  final String  method;
  final double  amount;
  final String? paidAt;
  final String? receivedBy;
  final String? notes;
  final String  status;

  const AdminInvoicePaymentEntity({
    required this.method,
    required this.amount,
    this.paidAt,
    this.receivedBy,
    this.notes,
    required this.status,
  });
}

class AdminInvoiceEntity {
  final int    invoiceId;
  final String invoiceNumber;
  final String invoiceDate;
  final String status;

  final String? branchName;
  final String? branchAddress;
  final String? branchPhone;

  final AdminInvoiceMemberEntity?       member;
  final List<AdminInvoiceItemEntity>    items;
  final List<AdminInvoicePaymentEntity> payments;

  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  const AdminInvoiceEntity({
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
}

class AdminInvoiceSummaryEntity {
  final int     invoiceId;
  final String  invoiceNumber;
  final String  invoiceDate;
  final String  status;
  final String  memberName;
  final String  memberEmail;
  final String? branchName;
  final double  totalAmount;
  final double  paidAmount;
  final double  dueAmount;

  const AdminInvoiceSummaryEntity({
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
}
