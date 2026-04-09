// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// English implementation of [AppLocalizations].
/// Flutter loads this automatically when the device locale is 'en'.
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  // ─── LOGIN ──────────────────────────────────────────────────────────────────

  @override
  String get login_welcomeBack => 'Welcome back';

  @override
  String get login_subtitle => 'Sign in to access your account';

  @override
  String get login_email => 'Email';

  @override
  String get login_emailHint => 'example@email.com';

  @override
  String get login_password => 'Password';

  @override
  String get login_passwordHint => 'Enter your password';

  @override
  String get login_forgotPassword => 'Forgot password?';

  @override
  String get login_button => 'Sign In';

  @override
  String get common_or => 'Or';

  @override
  String get login_continueWithGoogle => 'Continue with Google';

  @override
  String get login_continueWithApple => 'Continue with Apple';

  @override
  String get login_noAccount => "Don't have an account?";

  @override
  String get login_createAccount => 'Create new account';

  // ─── VALIDATION ─────────────────────────────────────────────────────────────

  @override
  String get validation_emailRequired => 'Email is required';

  @override
  String get validation_invalidEmail => 'Please enter a valid email';

  @override
  String get validation_passwordRequired => 'Password is required';

  @override
  String get validation_invalidCredentials => 'Invalid email or password';

  @override
  String get validation_passwordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get validation_passwordsMismatch => 'Passwords do not match';

  @override
  String get validation_codeRequired => 'Verification code is required';

  @override
  String get validation_invalidCode => 'Invalid or expired code';

  @override
  String get validation_passwordNoLetter =>
      'Must contain at least one letter';
  // Matches the backend @Pattern rule requiring at least one [A-Za-z]

  @override
  String get validation_passwordNoNumber =>
      'Must contain at least one number';
  // Matches the backend @Pattern rule requiring at least one [0-9]

  @override
  String get validation_confirmPasswordRequired =>
      'Please confirm your password';
  // Shown when the confirm-password field is submitted empty

  // ─── CONNECTION BANNER ───────────────────────────────────────────────────────

  @override
  String get connection_reconnecting => 'Connecting...';

  @override
  String get connection_offline => 'No internet connection';

  @override
  String get connection_issue => 'Connection issue';

  // ─── SCREEN 1: REQUEST RESET ─────────────────────────────────────────────────

  @override
  String get forgotPassword_title => 'Reset your password';
  // Headline passed to AuthCardShell — matches Screenshot 1

  @override
  String get forgotPassword_subtitle =>
      "Enter your email and we'll send you a code.";
  // Subtitle passed to AuthCardShell

  @override
  String get forgotPassword_emailOrPhone => 'Email or Phone';
  // Label above the identifier input field

  @override
  String get forgotPassword_emailOrPhoneHint =>
      'john@gmail.com or +96170123456';
  // Placeholder inside the identifier field

  @override
  String get forgotPassword_fieldRequired => 'This field is required';
  // Validator error when field is empty

  @override
  String get forgotPassword_invalidEmailOrPhone =>
      'Enter a valid email or phone number';
  // Validator error when input doesn't look like email or phone

  @override
  String get forgotPassword_sendOtp => 'Send OTP';
  // Primary CTA button text on Screen 1

  @override
  String get forgotPassword_checkEmailOrSms =>
      'Check your email or SMS for the verification code.';
  // Helper tip shown below the Send OTP button

  // ─── SCREEN 2: VERIFY CODE ───────────────────────────────────────────────────

  @override
  String get forgotPassword_otpScreenTitle => 'Enter OTP';
  // Headline passed to AuthCardShell on Screen 2

  @override
  String get forgotPassword_otpScreenSubtitle =>
      'We sent a 6-digit code.\nEnter it below.';
  // Subtitle passed to AuthCardShell on Screen 2

  @override
  String get forgotPassword_enterAllDigits => 'Please enter all 6 digits';
  // Snackbar shown when user taps Verify with fewer than 6 boxes filled

  @override
  String forgotPassword_checkEmail(String maskedContact) =>
      'Check your email: $maskedContact';
  // Dynamic text — shown when deliveryMethod == "EMAIL"
  // Dart string interpolation inserts the masked address at runtime

  @override
  String forgotPassword_checkSms(String maskedContact) =>
      'Check your SMS: $maskedContact';
  // Dynamic text — shown when deliveryMethod == "PHONE"

  @override
  String forgotPassword_codeExpiresIn(String time) =>
      'Code expires in $time';
  // Dynamic timer text — time is the MM:SS formatted string e.g. "14:35"

  @override
  String get forgotPassword_codeExpired => 'Code expired — please resend';
  // Shown in red when the 15-minute countdown reaches zero

  @override
  String get forgotPassword_verifyCode => 'Verify Code';
  // Primary CTA button text on Screen 2

  @override
  String get forgotPassword_didntReceiveCode =>
      "Didn't receive a code? Resend";
  // TextButton below Verify — triggers the resend API call

  // ─── SCREEN 3: SET NEW PASSWORD ──────────────────────────────────────────────

  @override
  String get forgotPassword_newPasswordScreenTitle => 'New Password';
  // Headline passed to AuthCardShell on Screen 3

  @override
  String get forgotPassword_newPasswordScreenSubtitle =>
      'Set a strong password with at least 8 characters.';
  // Subtitle passed to AuthCardShell on Screen 3

  @override
  String get forgotPassword_newPassword => 'New password';
  // Label above the first password field

  @override
  String get forgotPassword_confirmPassword => 'Confirm password';
  // Label above the confirmation password field

  @override
  String get forgotPassword_savePassword => 'Save password';
  // Primary CTA button text on Screen 3

  @override
  String get forgotPassword_passwordResetSuccess =>
      '✅ Password reset! Please login with new password.';
// Success snackbar shown before navigating back to login
}