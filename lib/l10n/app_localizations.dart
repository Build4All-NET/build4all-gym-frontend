import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// The abstract contract for all app localization strings.
///
/// Usage in any widget's build():
///   final l10n = AppLocalizations.of(context)!;
///   Text(l10n.forgotPassword_title)
///
/// Flutter resolves to AppLocalizationsEn or AppLocalizationsAr
/// automatically based on the device locale — you never instantiate this.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  /// Pass this list to MaterialApp.localizationsDelegates.
  /// Includes our strings + Flutter's built-in Material/Cupertino/RTL delegates.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
  <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,  // Material widget strings
    GlobalCupertinoLocalizations.delegate, // iOS widget strings
    GlobalWidgetsLocalizations.delegate,   // RTL/LTR text direction
  ];

  /// The two locales this app supports.
  /// Arabic is automatically RTL — no extra code needed in screens.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  // ═══════════════════════════════════════════════════════════════════
  // LOGIN SCREEN
  // ═══════════════════════════════════════════════════════════════════

  /// Headline: "Welcome back"
  String get login_welcomeBack;

  /// Subtitle: "Sign in to access your account"
  String get login_subtitle;

  /// Email field label: "Email"
  String get login_email;

  /// Email field placeholder: "example@email.com"
  String get login_emailHint;

  /// Password field label: "Password"
  String get login_password;

  /// Password field placeholder: "Enter your password"
  String get login_passwordHint;

  /// Link that starts the forgot-password flow: "Forgot password?"
  String get login_forgotPassword;

  /// Primary CTA button: "Sign In"
  String get login_button;

  /// Divider between login methods: "Or"
  String get common_or;

  /// Google OAuth button: "Continue with Google"
  String get login_continueWithGoogle;

  /// Apple Sign-In button: "Continue with Apple"
  String get login_continueWithApple;

  /// Before registration link: "Don't have an account?"
  String get login_noAccount;

  /// Registration link: "Create new account"
  String get login_createAccount;

  // ═══════════════════════════════════════════════════════════════════
  // VALIDATION — shown as inline red field errors
  // ═══════════════════════════════════════════════════════════════════

  /// Empty email on submit: "Email is required"
  String get validation_emailRequired;

  /// Bad email format: "Please enter a valid email"
  String get validation_invalidEmail;

  /// Empty password on login submit: "Password is required"
  String get validation_passwordRequired;

  /// Bad credentials from API: "Invalid email or password"
  String get validation_invalidCredentials;

  /// Password too short on Screen 3: "Password must be at least 8 characters"
  String get validation_passwordTooShort;

  /// Passwords don't match on Screen 3: "Passwords do not match"
  String get validation_passwordsMismatch;

  /// Empty OTP field on Screen 2 submit: "Verification code is required"
  String get validation_codeRequired;

  /// OTP rejected by API on Screen 2: "Invalid or expired code"
  String get validation_invalidCode;

  /// Password has no letter on Screen 3: "Must contain at least one letter"
  String get validation_passwordNoLetter;

  /// Password has no number on Screen 3: "Must contain at least one number"
  String get validation_passwordNoNumber;

  /// Empty confirm-password field: "Please confirm your password"
  String get validation_confirmPasswordRequired;

  // ═══════════════════════════════════════════════════════════════════
  // CONNECTION BANNER
  // Drives the orange reconnecting banner at the top of the screen
  // ═══════════════════════════════════════════════════════════════════

  /// While reconnecting: "Connecting..."
  String get connection_reconnecting;

  /// No internet: "No internet connection"
  String get connection_offline;

  /// Generic network error: "Connection issue"
  String get connection_issue;

  // ═══════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD — SCREEN 1: REQUEST RESET (ForgotPasswordScreen)
  // ═══════════════════════════════════════════════════════════════════

  /// Headline: "Reset your password"
  String get forgotPassword_title;

  /// Subtitle: "Enter your email and we'll send you a code."
  String get forgotPassword_subtitle;

  /// Email or phone field label: "Email or Phone"
  String get forgotPassword_emailOrPhone;

  /// Email or phone field placeholder: "john@gmail.com or +96170123456"
  String get forgotPassword_emailOrPhoneHint;

  /// Empty field error: "This field is required"
  String get forgotPassword_fieldRequired;

  /// Invalid input error: "Enter a valid email or phone number"
  String get forgotPassword_invalidEmailOrPhone;

  /// CTA button: "Send OTP"
  String get forgotPassword_sendOtp;

  /// Helper tip below button: "Check your email or SMS for the verification code."
  String get forgotPassword_checkEmailOrSms;

  // ═══════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD — SCREEN 2: VERIFY CODE (VerifyOtpScreen)
  // ═══════════════════════════════════════════════════════════════════

  /// Headline: "Enter OTP"
  String get forgotPassword_otpScreenTitle;

  /// Subtitle: "We sent a 6-digit code.\nEnter it below."
  String get forgotPassword_otpScreenSubtitle;

  /// Snackbar when < 6 digits entered: "Please enter all 6 digits"
  String get forgotPassword_enterAllDigits;

  /// Dynamic subtitle for email delivery.
  /// Method (not getter) because it accepts a runtime parameter.
  /// Usage: l10n.forgotPassword_checkEmail("jo***@gmail.com")
  /// Result: "Check your email: jo***@gmail.com"
  String forgotPassword_checkEmail(String maskedContact);

  /// Dynamic subtitle for SMS delivery.
  /// Usage: l10n.forgotPassword_checkSms("+961***456")
  /// Result: "Check your SMS: +961***456"
  String forgotPassword_checkSms(String maskedContact);

  /// Timer active — method because it injects the MM:SS value at runtime.
  /// Usage: l10n.forgotPassword_codeExpiresIn("14:35")
  /// Result: "Code expires in 14:35"
  String forgotPassword_codeExpiresIn(String time);

  /// Timer expired: "Code expired — please resend"
  String get forgotPassword_codeExpired;

  /// CTA button: "Verify Code"
  String get forgotPassword_verifyCode;

  /// Resend TextButton: "Didn't receive a code? Resend"
  String get forgotPassword_didntReceiveCode;

  // ═══════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD — SCREEN 3: SET NEW PASSWORD (ResetPasswordScreen)
  // ═══════════════════════════════════════════════════════════════════

  /// Headline: "New Password"
  String get forgotPassword_newPasswordScreenTitle;

  /// Subtitle: "Set a strong password with at least 8 characters."
  String get forgotPassword_newPasswordScreenSubtitle;

  /// New password field label: "New password"
  String get forgotPassword_newPassword;

  /// Confirm password field label: "Confirm password"
  String get forgotPassword_confirmPassword;

  /// Save button: "Save password"
  String get forgotPassword_savePassword;

  /// Success snackbar after reset: "✅ Password reset! Please login with new password."
  String get forgotPassword_passwordResetSuccess;
}

// ─────────────────────────────────────────────────────────────────────────────
// DELEGATE — internal, not used directly by screens.
// SynchronousFuture means there's no async loading gap — strings are compiled
// into the app and available immediately on first frame.
// ─────────────────────────────────────────────────────────────────────────────
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      lookupAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) =>
      false; // strings don't change at runtime
}

/// Routes a Locale to the correct concrete class.
/// Add a new case here when you add a new language (e.g. French).
AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }
  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}