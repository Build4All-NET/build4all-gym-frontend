import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/core/error/backend_error_code_translator.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

// Covers spec section 6: backend errors must return stable codes, and the
// app must translate them instead of ever showing raw backend exception
// text — especially "no raw English fallback in Arabic mode".
void main() {
  late AppLocalizations en;
  late AppLocalizations ar;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
    ar = await AppLocalizations.delegate.load(const Locale('ar'));
  });

  group('translateBackendErrorCode', () {
    const knownCodes = [
      'AI_PROVIDER_DISABLED',
      'AI_CONTEXT_UNAVAILABLE',
      'AI_PROVIDER_TIMEOUT',
      'AI_INVALID_RESPONSE',
      'AI_PROVIDER_ERROR',
      'AI_PROVIDER_RATE_LIMITED',
      'REFUND_PROVIDER_NOT_SUPPORTED',
      'REFUND_PROVIDER_INTEGRATION_REQUIRED',
      'PAYMENT_VERIFICATION_FAILED',
      'INVALID_REQUEST_BODY',
      'INVALID_FITNESS_GOAL',
    ];

    for (final code in knownCodes) {
      test('$code has a non-empty English translation', () {
        final message = translateBackendErrorCode(en, code);
        expect(message, isNotEmpty);
      });

      test('$code has a non-empty Arabic translation, never falling back to English', () {
        final message = translateBackendErrorCode(ar, code);
        expect(message, isNotEmpty);
        // A very loose Arabic-script check: at least one character in the
        // main Arabic Unicode block. Guards against silently returning the
        // English string when called with the Arabic AppLocalizations.
        final hasArabicChar = message.runes.any((r) => r >= 0x0600 && r <= 0x06FF);
        expect(hasArabicChar, isTrue, reason: 'Expected Arabic text for $code, got: $message');
      });
    }

    test('unknown/null error codes fall back to a generic localized message', () {
      expect(translateBackendErrorCode(en, null), en.backendErrorGeneric);
      expect(translateBackendErrorCode(en, 'SOME_UNMAPPED_CODE'), en.backendErrorGeneric);
      expect(translateBackendErrorCode(ar, null), ar.backendErrorGeneric);
    });
  });
}
