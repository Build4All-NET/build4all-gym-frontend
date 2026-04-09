// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// Arabic implementation of [AppLocalizations].
/// Flutter loads this automatically when the device locale is 'ar'.
/// Arabic is RTL — GlobalWidgetsLocalizations.delegate (in the delegate list)
/// handles the layout direction flip automatically. No extra code needed.
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  // ─── LOGIN ──────────────────────────────────────────────────────────────────

  @override
  String get login_welcomeBack => 'مرحباً بعودتك';
  // "Welcome back"

  @override
  String get login_subtitle => 'سجل دخولك للوصول إلى حسابك';
  // "Sign in to access your account"

  @override
  String get login_email => 'البريد الإلكتروني';
  // "Email"

  @override
  String get login_emailHint => 'example@email.com';
  // Email format stays in Latin characters — universal across languages

  @override
  String get login_password => 'كلمة المرور';
  // "Password"

  @override
  String get login_passwordHint => 'أدخل كلمة المرور';
  // "Enter your password"

  @override
  String get login_forgotPassword => 'نسيت كلمة المرور؟';
  // "Forgot password?"

  @override
  String get login_button => 'تسجيل الدخول';
  // "Sign In"

  @override
  String get common_or => 'أو';
  // "Or"

  @override
  String get login_continueWithGoogle => 'متابعة باستخدام Google';
  // Brand name "Google" stays in English even in Arabic context

  @override
  String get login_continueWithApple => 'متابعة باستخدام Apple';
  // Brand name "Apple" stays in English

  @override
  String get login_noAccount => 'ليس لديك حساب؟';
  // "Don't have an account?"

  @override
  String get login_createAccount => 'إنشاء حساب جديد';
  // "Create new account"

  // ─── VALIDATION ─────────────────────────────────────────────────────────────

  @override
  String get validation_emailRequired => 'البريد الإلكتروني مطلوب';
  // "Email is required"

  @override
  String get validation_invalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';
  // "Please enter a valid email"

  @override
  String get validation_passwordRequired => 'كلمة المرور مطلوبة';
  // "Password is required"

  @override
  String get validation_invalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  // "Invalid email or password"

  @override
  String get validation_passwordTooShort =>
      'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
  // "Password must be at least 8 characters"

  @override
  String get validation_passwordsMismatch => 'كلمتا المرور غير متطابقتين';
  // "Passwords do not match"

  @override
  String get validation_codeRequired => 'رمز التحقق مطلوب';
  // "Verification code is required"

  @override
  String get validation_invalidCode => 'الرمز غير صحيح أو منتهي الصلاحية';
  // "Invalid or expired code"

  @override
  String get validation_passwordNoLetter => 'يجب أن تحتوي على حرف واحد على الأقل';
  // "Must contain at least one letter"

  @override
  String get validation_passwordNoNumber => 'يجب أن تحتوي على رقم واحد على الأقل';
  // "Must contain at least one number"

  @override
  String get validation_confirmPasswordRequired => 'الرجاء تأكيد كلمة المرور';
  // "Please confirm your password"

  // ─── CONNECTION BANNER ───────────────────────────────────────────────────────

  @override
  String get connection_reconnecting => 'جارٍ الاتصال...';
  // "Connecting..."

  @override
  String get connection_offline => 'لا يوجد اتصال بالإنترنت';
  // "No internet connection"

  @override
  String get connection_issue => 'مشكلة في الاتصال';
  // "Connection issue"

  // ─── SCREEN 1: REQUEST RESET ─────────────────────────────────────────────────

  @override
  String get forgotPassword_title => 'إعادة تعيين كلمة المرور';
  // "Reset your password"

  @override
  String get forgotPassword_subtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمزاً.';
  // "Enter your email and we'll send you a code."

  @override
  String get forgotPassword_emailOrPhone => 'البريد الإلكتروني أو الهاتف';
  // "Email or Phone"

  @override
  String get forgotPassword_emailOrPhoneHint =>
      'john@gmail.com أو +96170123456';
  // Arabic version keeps the email/phone format in Latin characters

  @override
  String get forgotPassword_fieldRequired => 'هذا الحقل مطلوب';
  // "This field is required"

  @override
  String get forgotPassword_invalidEmailOrPhone =>
      'أدخل بريداً إلكترونياً أو رقم هاتف صحيح';
  // "Enter a valid email or phone number"

  @override
  String get forgotPassword_sendOtp => 'إرسال الرمز';
  // "Send OTP"

  @override
  String get forgotPassword_checkEmailOrSms =>
      'تحقق من بريدك الإلكتروني أو رسائل SMS للحصول على رمز التحقق.';
  // "Check your email or SMS for the verification code."

  // ─── SCREEN 2: VERIFY CODE ───────────────────────────────────────────────────

  @override
  String get forgotPassword_otpScreenTitle => 'أدخل رمز التحقق';
  // "Enter OTP"

  @override
  String get forgotPassword_otpScreenSubtitle =>
      'أرسلنا رمزاً مكوناً من 6 أرقام.\nأدخله أدناه.';
  // "We sent a 6-digit code.\nEnter it below."

  @override
  String get forgotPassword_enterAllDigits => 'الرجاء إدخال جميع الأرقام الستة';
  // "Please enter all 6 digits"

  @override
  String forgotPassword_checkEmail(String maskedContact) =>
      'تحقق من بريدك الإلكتروني: $maskedContact';
  // "Check your email: {maskedContact}"
  // Dart interpolation works the same — the email stays in Latin characters

  @override
  String forgotPassword_checkSms(String maskedContact) =>
      'تحقق من رسائل SMS لديك: $maskedContact';
  // "Check your SMS: {maskedContact}"

  @override
  String forgotPassword_codeExpiresIn(String time) =>
      'ينتهي الرمز خلال $time';
  // "Code expires in {time}" — time is MM:SS format e.g. "14:35"

  @override
  String get forgotPassword_codeExpired => 'انتهت صلاحية الرمز — أعد الإرسال';
  // "Code expired — please resend"

  @override
  String get forgotPassword_verifyCode => 'تحقق من الرمز';
  // "Verify Code"

  @override
  String get forgotPassword_didntReceiveCode =>
      'لم تستلم الرمز؟ أعد الإرسال';
  // "Didn't receive a code? Resend"

  // ─── SCREEN 3: SET NEW PASSWORD ──────────────────────────────────────────────

  @override
  String get forgotPassword_newPasswordScreenTitle => 'كلمة مرور جديدة';
  // "New Password"

  @override
  String get forgotPassword_newPasswordScreenSubtitle =>
      'أنشئ كلمة مرور قوية تحتوي على 8 أحرف على الأقل.';
  // "Set a strong password with at least 8 characters."

  @override
  String get forgotPassword_newPassword => 'كلمة المرور الجديدة';
  // "New password"

  @override
  String get forgotPassword_confirmPassword => 'تأكيد كلمة المرور';
  // "Confirm password"

  @override
  String get forgotPassword_savePassword => 'حفظ كلمة المرور';
  // "Save password"

  @override
  String get forgotPassword_passwordResetSuccess =>
      '✅ تم إعادة تعيين كلمة المرور! يرجى تسجيل الدخول بكلمة المرور الجديدة.';
// "✅ Password reset! Please login with new password."
}