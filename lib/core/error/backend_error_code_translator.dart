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
    default:
      return l10n.backendErrorGeneric;
  }
}
