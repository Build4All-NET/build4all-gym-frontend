import '../../domain/entities/member_invoice_entity.dart';

/// States for the member invoice details screen.
abstract class MemberInvoiceState {
  const MemberInvoiceState();
}

/// Initial state before loading starts.
class MemberInvoiceInitial extends MemberInvoiceState {
  const MemberInvoiceInitial();
}

/// Loading full invoice details from backend.
class MemberInvoiceLoading extends MemberInvoiceState {
  const MemberInvoiceLoading();
}

/// Invoice details loaded successfully.
class MemberInvoiceLoaded extends MemberInvoiceState {
  final MemberInvoiceEntity invoice;

  const MemberInvoiceLoaded({
    required this.invoice,
  });
}

/// Error state.
///
/// We use an errorKey instead of hardcoded visible text.
/// The screen maps this key to AppLocalizations.
class MemberInvoiceError extends MemberInvoiceState {
  final String errorKey;

  const MemberInvoiceError(this.errorKey);
}