/// Represents one line/item inside the invoice details.
/// Example:
/// - Membership plan
/// - PT session
/// - Class fee
/// - Daily pass
class MemberInvoiceItemEntity {
  final String itemName;

  /// Optional description coming from backend.
  final String? description;

  /// Quantity of this item.
  /// Usually 1 for membership/class/session.
  final int qty;

  /// Price for one unit before discount/tax.
  final double unitPrice;

  /// Discount applied to this item line.
  final double discountAmount;

  /// Tax applied to this item line.
  final double taxAmount;

  /// Final amount for this item line.
  final double lineTotal;

  const MemberInvoiceItemEntity({
    required this.itemName,
    this.description,
    required this.qty,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.lineTotal,
  });
}

/// Represents one payment linked to an invoice.
/// An invoice can have one payment or multiple partial payments.
class MemberInvoicePaymentEntity {
  /// CASH / CARD / STRIPE / BANK_TRANSFER / WALLET / OTHER
  final String? method;

  /// Amount paid in this payment row.
  final double amount;

  /// Payment date as string.
  /// We keep it as string because UI formatting can be handled later.
  final String? paidAt;

  /// Optional payment note.
  final String? notes;

  /// Payment status:
  /// pending / completed / failed / refunded
  final String status;

  const MemberInvoicePaymentEntity({
    this.method,
    required this.amount,
    this.paidAt,
    this.notes,
    required this.status,
  });
}

/// Full invoice entity.
/// Used in invoice details screen after clicking "عرض التفاصيل".
class MemberInvoiceEntity {
  final int invoiceId;
  final String invoiceNumber;
  final String invoiceDate;

  /// Invoice status:
  /// draft / pending / partial / paid / overdue / cancelled / refunded
  final String status;

  /// Branch information can be null if backend does not return it.
  final String? branchName;
  final String? branchAddress;
  final String? branchPhone;

  /// Invoice item lines.
  final List<MemberInvoiceItemEntity> items;

  /// Payments linked to this invoice.
  final List<MemberInvoicePaymentEntity> payments;

  /// Invoice money summary.
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  const MemberInvoiceEntity({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.status,
    this.branchName,
    this.branchAddress,
    this.branchPhone,
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

/// Small invoice entity used in payment history list.
/// This is lighter than MemberInvoiceEntity.
class MemberInvoiceSummaryEntity {
  final int invoiceId;
  final String invoiceNumber;
  final String invoiceDate;

  /// This is the invoice status from backend:
  /// paid / refunded / cancelled / pending / partial
  final String status;

  final String? branchName;

  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  /// PLAN / CLASS / PT / PT_PACKAGE / DAILY_PASS / OTHER
  final String? type;

  /// CASH / CARD / STRIPE / BANK_TRANSFER / WALLET / OTHER
  final String? paymentMethod;

  /// Refund request status:
  /// null / pending / processed / rejected / failed / cancelled
  ///
  /// Example:
  /// - null: no refund request yet
  /// - pending: member requested refund, admin did not answer yet
  /// - processed: admin accepted refund
  /// - rejected: admin refused refund
  final String? refundStatus;

  /// Backend decides if the refund button should be visible.
  ///
  /// Flutter should NOT recalculate business rules.
  /// It should simply show the button when this is true.
  final bool canRequestRefund;

  const MemberInvoiceSummaryEntity({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.status,
    this.branchName,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    this.type,
    this.paymentMethod,
    this.refundStatus,
    required this.canRequestRefund,
  });
}