import 'package:build4allgym/l10n/app_localizations.dart';

/// Translates a stable backend `errorCode` (e.g. `"AI_PROVIDER_DISABLED"`,
/// `"REFUND_PROVIDER_NOT_SUPPORTED"`) into a localized, member-facing
/// message.
///
/// The backend returns these codes instead of raw exception text so the
/// app never has to display an untranslated English message in Arabic
/// mode. Unknown/null codes fall back to a generic localized message
/// rather than surfacing backend internals to the user.
String translateBackendErrorCode(AppLocalizations l10n, String? errorCode) {
  switch (errorCode) {
    case 'AI_PROVIDER_DISABLED':
      return l10n.backendErrorAiProviderDisabled;
    case 'AI_CONTEXT_UNAVAILABLE':
      return l10n.backendErrorAiContextUnavailable;
    case 'AI_PROVIDER_TIMEOUT':
      return l10n.backendErrorAiProviderTimeout;
    case 'AI_INVALID_RESPONSE':
      return l10n.backendErrorAiInvalidResponse;
    case 'AI_PROVIDER_ERROR':
      return l10n.backendErrorAiProviderError;
    case 'AI_PROVIDER_RATE_LIMITED':
      return l10n.backendErrorAiProviderRateLimited;
    case 'REFUND_PROVIDER_NOT_SUPPORTED':
      return l10n.backendErrorRefundProviderNotSupported;
    case 'REFUND_PROVIDER_INTEGRATION_REQUIRED':
      return l10n.backendErrorRefundProviderIntegrationRequired;
    case 'PAYMENT_VERIFICATION_FAILED':
      return l10n.backendErrorPaymentVerificationFailed;
    case 'INVALID_REQUEST_BODY':
      return l10n.backendErrorInvalidRequestBody;
    case 'INVALID_FITNESS_GOAL':
      return l10n.backendErrorInvalidFitnessGoal;
    case 'CHECKINS_LOAD_FAILED':
      return l10n.backendErrorCheckinsLoadFailed;
    case 'CHECKIN_CREATE_FAILED':
      return l10n.backendErrorCheckinCreateFailed;
    case 'CHECKIN_UPDATE_FAILED':
      return l10n.backendErrorCheckinUpdateFailed;
    case 'CHECKIN_DELETE_FAILED':
      return l10n.backendErrorCheckinDeleteFailed;
    case 'CHECKIN_NOT_FOUND':
      return l10n.backendErrorCheckinNotFound;
    case 'CHECKIN_TENANT_INVALID':
      return l10n.backendErrorCheckinTenantInvalid;
    case 'CHECKIN_QR_EXPIRED':
      return l10n.backendErrorCheckinQrExpired;
    case 'CHECKIN_QR_ALREADY_USED':
      return l10n.backendErrorCheckinQrAlreadyUsed;
    case 'CHECKIN_ACCESS_WINDOW':
      return l10n.backendErrorCheckinAccessWindow;
    case 'CHECKIN_NOT_ELIGIBLE':
      return l10n.backendErrorCheckinNotEligible;
    case 'CHECKIN_BRANCH_MISMATCH':
      return l10n.backendErrorCheckinBranchMismatch;
    case 'CHECKIN_ALREADY_CHECKED_OUT':
      return l10n.backendErrorCheckinAlreadyCheckedOut;
    case 'MEMBERS_LOAD_FAILED':
      return l10n.backendErrorMembersLoadFailed;
    case 'MEMBER_CREATE_FAILED':
      return l10n.backendErrorMemberCreateFailed;
    case 'MEMBER_UPDATE_FAILED':
      return l10n.backendErrorMemberUpdateFailed;
    case 'MEMBER_DELETE_FAILED':
      return l10n.backendErrorMemberDeleteFailed;
    case 'MEMBER_NOT_FOUND':
      return l10n.backendErrorMemberNotFound;
    case 'MEMBER_ALREADY_EXISTS':
      return l10n.backendErrorMemberAlreadyExists;
    case 'MEMBER_BRANCH_INVALID':
      return l10n.backendErrorMemberBranchInvalid;
    case 'MEMBER_TENANT_INVALID':
      return l10n.backendErrorMemberTenantInvalid;
    case 'MEMBER_ACCESS_FORBIDDEN':
      return l10n.backendErrorMemberAccessForbidden;
    case 'MEMBER_BLOCKED':
      return l10n.backendErrorMemberBlocked;
    case 'MEMBER_NO_ACTIVE_MEMBERSHIP':
      return l10n.backendErrorMemberNoActiveMembership;
    // Locally-synthesized UI-guard codes (not from the backend) — this
    // translator is just a stable-code -> localized-string lookup, so it's
    // the natural place for these too rather than a parallel mechanism.
    case 'CHECKIN_NO_BRANCH_SCAN':
      return l10n.checkins_allBranchesScanBlocked;
    case 'CHECKIN_NO_BRANCH_CHECKOUT':
      return l10n.checkins_allBranchesCheckoutBlocked;
    default:
      return l10n.backendErrorGeneric;
  }
}
