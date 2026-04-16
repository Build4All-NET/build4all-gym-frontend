// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override String get auth_welcomeBack => 'مرحباً بعودتك';
  @override String get auth_loginSubtitle => 'سجل دخولك للوصول إلى حسابك';
  @override String get auth_emailLabel => 'البريد الإلكتروني';
  @override String get auth_phoneLabel => 'رقم الهاتف';
  @override String get auth_emailHint => 'example@email.com';
  @override String get auth_phoneHint => '+961 12 345 678';
  @override String get auth_passwordLabel => 'كلمة المرور';
  @override String get auth_passwordHint => 'أدخل كلمة المرور';
  @override String get auth_forgotPassword => 'نسيت كلمة المرور؟';
  @override String get auth_loginButton => 'تسجيل الدخول';
  @override String get auth_continueWithGoogle => 'متابعة باستخدام Google';
  @override String get auth_continueWithApple => 'متابعة باستخدام Apple';
  @override String get auth_noAccount => 'ليس لديك حساب؟';
  @override String get auth_createAccount => 'إنشاء حساب جديد';
  @override String get auth_accountInactiveTitle => 'الحساب غير نشط';
  @override String get auth_accountInactiveMessage => 'حسابك غير نشط. هل تريد إعادة تنشيطه؟';
  @override String get auth_reactivate => 'إعادة التنشيط';
  @override String get auth_accountInactive => 'حسابك غير نشط.';
  @override String get auth_accountDeletedRestorableMessage => 'تم حذف حسابك. اتصل بالدعم لاستعادته.';
  @override String get auth_accountDeletedPermanentMessage => 'تم حذف حسابك بشكل دائم.';
  @override String get auth_userNotFound => 'لم يتم العثور على حساب بهذه البيانات.';
  @override String get auth_loginLocked => 'محاولات فاشلة كثيرة. يرجى المحاولة لاحقاً.';

  @override String get login_welcomeBack => 'مرحباً بعودتك';
  @override String get login_subtitle => 'سجل دخولك للوصول إلى حسابك';
  @override String get login_email => 'البريد الإلكتروني';
  @override String get login_emailHint => 'example@email.com';
  @override String get login_password => 'كلمة المرور';
  @override String get login_passwordHint => 'أدخل كلمة المرور';
  @override String get login_forgotPassword => 'نسيت كلمة المرور؟';
  @override String get login_button => 'تسجيل الدخول';
  @override String get login_continueWithGoogle => 'متابعة باستخدام Google';
  @override String get login_continueWithApple => 'متابعة باستخدام Apple';
  @override String get login_noAccount => 'ليس لديك حساب؟';
  @override String get login_createAccount => 'إنشاء حساب جديد';

  @override String get validation_emailRequired => 'البريد الإلكتروني مطلوب';
  @override String get validation_phoneRequired => 'رقم الهاتف مطلوب';
  @override String get validation_emailInvalid => 'البريد الإلكتروني غير صالح';
  @override String get validation_invalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';
  @override String get validation_passwordRequired => 'كلمة المرور مطلوبة';
  @override String get validation_invalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  @override String get validation_passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
  @override String get validation_passwordsMismatch => 'كلمتا المرور غير متطابقتين';
  @override String get validation_codeRequired => 'رمز التحقق مطلوب';
  @override String get validation_invalidCode => 'الرمز غير صحيح أو منتهي الصلاحية';

  // ✅ Fixed: was returning English placeholder text
  @override String get validation_emailAlreadyExists => 'البريد الإلكتروني مسجل مسبقاً';
  @override String get validation_phoneAlreadyExists => 'رقم الهاتف مسجل مسبقاً';

  @override String get general_cancel => 'إلغاء';
  @override String get general_or => 'أو';

  // ✅ Fixed: was returning English placeholder text
  @override String get general_optional => 'اختياري';

  @override String get error_somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  // ✅ Fixed: was returning English placeholder text
  @override String get error_serverError => 'خطأ في الخادم. يرجى المحاولة لاحقاً.';

  @override String get connection_reconnecting => 'جارٍ الاتصال...';
  @override String get connection_offline => 'لا يوجد اتصال بالإنترنت';
  @override String get connection_issue => 'مشكلة في الاتصال';

  // ✅ Fixed: was returning English placeholder text
  @override String get connection_timeout => 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override String get authGateContinueAs => 'تابع كـ';
  @override String get authGateRoleAdminOwner => 'مدير / مالك';
  @override String get authGateRoleUser => 'مستخدم عادي';

  @override String get appAccessTitleDeleted => 'التطبيق محذوف';
  @override String get appAccessTitleExpired => 'انتهى الاشتراك';
  @override String get appAccessTitleUnavailable => 'التطبيق غير متاح';
  @override String get appAccessMessageDeleted => 'هذا التطبيق تم حذفه ولم يعد متاحاً.';
  @override String get appAccessMessageExpired => 'انتهى اشتراك هذا التطبيق. يرجى التواصل مع الدعم.';
  @override String get appAccessMessageUnavailable => 'هذا التطبيق غير متاح حالياً. يرجى المحاولة لاحقاً.';
  @override String get appAccessRetry => 'حاول مجدداً';

  @override String get common_or => 'أو';

  @override String get forgotPassword_title => 'إعادة تعيين كلمة المرور';
  @override String get forgotPassword_subtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رمزاً.';
  @override String get forgotPassword_sendCode => 'إرسال الرمز';
  @override String get forgotPassword_spamTip => 'تلميح: تحقق من مجلد البريد غير الهام أيضاً 👀';
  @override String get forgotPassword_verifyTitle => 'أدخل رمز التحقق';

  @override String forgotPassword_codeSentTo(String email) {
    return 'أرسلنا رمزاً إلى $email';
  }

  @override String get forgotPassword_codeLabel => 'الرمز';
  @override String get forgotPassword_verify => 'تحقق';
  @override String get forgotPassword_resendCode => 'إعادة إرسال الرمز';
  @override String get forgotPassword_newPasswordTitle => 'تعيين كلمة مرور جديدة';
  @override String get forgotPassword_newPasswordSubtitle => 'اجعلها قوية — نسختك المستقبلية ستشكرك.';
  @override String get forgotPassword_newPassword => 'كلمة المرور الجديدة';
  @override String get forgotPassword_confirmPassword => 'تأكيد كلمة المرور';
  @override String get forgotPassword_savePassword => 'حفظ كلمة المرور';
  @override String get forgotPassword_enterAllDigits => 'يرجى إدخال جميع الأرقام';
  @override String get forgotPassword_otpScreenTitle => 'أدخل رمز التحقق';
  @override String get forgotPassword_otpScreenSubtitle => 'أدخل الرمز المرسل إلى بريدك الإلكتروني أو هاتفك';
  @override String get forgotPassword_checkSms => 'تحقق من الرسائل النصية';
  @override String get forgotPassword_checkEmail => 'تحقق من بريدك الإلكتروني';
  @override String get forgotPassword_checkEmailOrSms => 'تحقق من بريدك الإلكتروني أو الرسائل';

  @override String forgotPassword_codeExpiresIn(int seconds) {
    return 'ينتهي الرمز خلال $seconds ثانية';
  }

  @override String get forgotPassword_codeExpired => 'انتهت صلاحية الرمز';
  @override String get forgotPassword_verifyCode => 'تحقق من الرمز';
  @override String get forgotPassword_didntReceiveCode => 'لم تستلم الرمز؟';
  @override String get forgotPassword_emailOrPhone => 'البريد الإلكتروني أو رقم الهاتف';
  @override String get forgotPassword_emailOrPhoneHint => 'أدخل بريدك الإلكتروني أو رقم هاتفك';
  @override String get forgotPassword_fieldRequired => 'هذا الحقل مطلوب';
  @override String get forgotPassword_invalidEmailOrPhone => 'البريد الإلكتروني أو رقم الهاتف غير صالح';
  @override String get forgotPassword_sendOtp => 'إرسال رمز التحقق';
  @override String get forgotPassword_newPasswordScreenTitle => 'تعيين كلمة مرور جديدة';
  @override String get forgotPassword_newPasswordScreenSubtitle => 'أدخل كلمة المرور الجديدة أدناه';
  @override String get forgotPassword_passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح';

  @override String get validation_passwordNoLetter => 'يجب أن تحتوي كلمة المرور على حرف واحد على الأقل';
  @override String get validation_passwordNoNumber => 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
  @override String get validation_confirmPasswordRequired => 'يرجى تأكيد كلمة المرور';
}
  @override
  String get forgotPassword_codeExpired => 'انتهت صلاحية الرمز';

  @override
  String get forgotPassword_verifyCode => 'تحقق من الرمز';

  @override
  String get forgotPassword_didntReceiveCode => 'لم تستلم الرمز؟';

  @override
  String get forgotPassword_emailOrPhone => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get forgotPassword_emailOrPhoneHint => 'أدخل بريدك الإلكتروني أو رقم هاتفك';

  @override
  String get forgotPassword_fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get forgotPassword_invalidEmailOrPhone => 'البريد الإلكتروني أو رقم الهاتف غير صالح';

  @override
  String get forgotPassword_sendOtp => 'إرسال رمز التحقق';

  @override
  String get forgotPassword_newPasswordScreenTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get forgotPassword_newPasswordScreenSubtitle => 'أدخل كلمة المرور الجديدة أدناه';

  @override
  String get forgotPassword_passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح';

  @override
  String get validation_passwordNoLetter => 'يجب أن تحتوي كلمة المرور على حرف واحد على الأقل';

  @override
  String get validation_passwordNoNumber => 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get validation_confirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get signup_title => 'إنشاء حساب جديد';

  @override
  String get signup_subtitle => 'ابدأ رحلتك الرياضية معنا';

  @override
  String get signup_step1Label => 'معلومات الحساب';

  @override
  String get signup_registrationMethod => 'طريقة التسجيل';

  @override
  String get signup_confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get signup_confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get signup_continueButton => 'متابعة';

  @override
  String get signup_alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signup_signIn => 'تسجيل الدخول';

  @override
  String get signup_termsAgreement => 'بالمتابعة، أنت توافق على شروط الخدمة وسياسة الخصوصية';

  @override
  String get signup_alreadyVerifiedResume => 'تم التحقق من الحساب مسبقاً. جارٍ استكمال ملفك الشخصي.';

  @override
  String get otp_title => 'تأكيد الحساب';

  @override
  String get otp_subtitle => 'أدخل رمز التحقق المُرسل';

  @override
  String get otp_step2Label => 'التحقق من الهوية';

  @override
  String get otp_sentTo => 'تم الإرسال إلى';

  @override
  String otp_enterDigits(int count) {
    return 'أدخل رمز التحقق المكون من $count أرقام';
  }

  @override
  String get otp_didntReceive => 'لم تستلم الرمز؟';

  @override
  String get otp_resendNow => 'إعادة الإرسال الآن';

  @override
  String get otp_verifyButton => 'تحقق';

  @override
  String get otp_verifiedSuccess => 'تم التحقق من الحساب بنجاح!';

  @override
  String get otp_codeSentAgain => 'تم إرسال رمز التحقق مجدداً';

  @override
  String get otp_enterAllDigits => 'يرجى إدخال جميع الأرقام';

  @override
  String get otp_backToSignup => 'العودة للتسجيل';

  @override
  String get otp_debugTip => 'للتجربة استخدم الرمز 1234';

  @override
  String get completeProfile_title => 'أكمل ملفك الشخصي';

  @override
  String get completeProfile_subtitle => 'أخبرنا المزيد عنك';

  @override
  String get completeProfile_lastStepTitle => 'آخر خطوة!';

  @override
  String get completeProfile_lastStepSubtitle => 'اختر اسم مستخدم فريد';

  @override
  String get completeProfile_stepLabel => 'المعلومات الشخصية';

  @override
  String get completeProfile_nameInstruction => 'نحتاج إلى معرفة اسمك لتخصيص تجربتك';

  @override
  String get completeProfile_firstName => 'الاسم الأول';

  @override
  String get completeProfile_firstNameHint => 'أدخل اسمك الأول';

  @override
  String get completeProfile_firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get completeProfile_lastName => 'اسم العائلة';

  @override
  String get completeProfile_lastNameHint => 'أدخل اسم العائلة';

  @override
  String get completeProfile_continueButton => 'متابعة';

  @override
  String get completeProfile_usernameInstruction => 'اسمك المستخدم سيظهر في ملفك الشخصي';

  @override
  String get completeProfile_username => 'اسم المستخدم';

  @override
  String get completeProfile_usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get completeProfile_usernameTooShort => 'يجب أن يكون 3 أحرف على الأقل';

  @override
  String get completeProfile_usernameInvalid => 'أحرف وأرقام و _ و . فقط';

  @override
  String get completeProfile_usernameTaken => 'اسم المستخدم هذا محجوز بالفعل';

  @override
  String get completeProfile_profileType => 'نوع الملف الشخصي';

  @override
  String get completeProfile_publicTitle => 'حساب عام';

  @override
  String get completeProfile_publicDescription => 'يمكن لأي شخص رؤية ملفك الشخصي ونشاطك';

  @override
  String get completeProfile_privateTitle => 'حساب خاص';

  @override
  String get completeProfile_privateDescription => 'فقط أنت يمكنك رؤية معلوماتك ونشاطك';

  @override
  String get completeProfile_settingsNote => 'يمكنك تغيير هذه الإعدادات لاحقاً من الملف الشخصي';

  @override
  String get completeProfile_finishButton => 'إنهاء وبدء الاستخدام';

  @override
  String get completeProfile_backButton => 'العودة';
}
