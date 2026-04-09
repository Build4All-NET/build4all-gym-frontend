// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get auth_welcomeBack => 'مرحباً بعودتك';

  @override
  String get auth_loginSubtitle => 'سجل دخولك للوصول إلى حسابك';

  @override
  String get auth_emailLabel => 'البريد الإلكتروني';

  @override
  String get auth_phoneLabel => 'رقم الهاتف';

  @override
  String get auth_emailHint => 'example@email.com';

  @override
  String get auth_phoneHint => '+961 12 345 678';

  @override
  String get auth_passwordLabel => 'كلمة المرور';

  @override
  String get auth_passwordHint => 'أدخل كلمة المرور';

  @override
  String get auth_forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get auth_loginButton => 'تسجيل الدخول';

  @override
  String get auth_continueWithGoogle => 'متابعة باستخدام Google';

  @override
  String get auth_continueWithApple => 'متابعة باستخدام Apple';

  @override
  String get auth_noAccount => 'ليس لديك حساب؟';

  @override
  String get auth_createAccount => 'إنشاء حساب جديد';

  @override
  String get auth_accountInactiveTitle => 'الحساب غير نشط';

  @override
  String get auth_accountInactiveMessage => 'حسابك غير نشط. هل تريد إعادة تنشيطه؟';

  @override
  String get auth_reactivate => 'إعادة التنشيط';

  @override
  String get auth_accountInactive => 'حسابك غير نشط.';

  @override
  String get auth_accountDeletedRestorableMessage => 'تم حذف حسابك. اتصل بالدعم لاستعادته.';

  @override
  String get auth_accountDeletedPermanentMessage => 'تم حذف حسابك بشكل دائم.';

  @override
  String get auth_userNotFound => 'لم يتم العثور على حساب بهذه البيانات.';

  @override
  String get auth_loginLocked => 'محاولات فاشلة كثيرة. يرجى المحاولة لاحقاً.';

  @override
  String get validation_emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get validation_phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get validation_emailInvalid => 'البريد الإلكتروني غير صالح';

  @override
  String get validation_passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validation_invalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get general_cancel => 'إلغاء';

  @override
  String get general_or => 'أو';

  @override
  String get error_somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get connection_offline => 'لا يوجد اتصال بالإنترنت';

  @override
  String get authGateContinueAs => 'تابع كـ';

  @override
  String get authGateRoleAdminOwner => 'مدير / مالك';

  @override
  String get authGateRoleUser => 'مستخدم عادي';

  @override
  String get login_welcomeBack => 'مرحباً بعودتك';

  @override
  String get login_subtitle => 'سجل دخولك للوصول إلى حسابك';

  @override
  String get login_email => 'البريد الإلكتروني';

  @override
  String get login_emailHint => 'example@email.com';

  @override
  String get login_password => 'كلمة المرور';

  @override
  String get login_passwordHint => 'أدخل كلمة المرور';

  @override
  String get login_forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get login_button => 'تسجيل الدخول';

  @override
  String get common_or => 'أو';

  @override
  String get login_noAccount => 'ليس لديك حساب؟';

  @override
  String get login_createAccount => 'إنشاء حساب جديد';

  @override
  String get validation_invalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get connection_reconnecting => 'جارٍ الاتصال...';

  @override
  String get connection_issue => 'مشكلة في الاتصال';

  @override
  String get appAccessTitleDeleted => 'التطبيق محذوف';

  @override
  String get appAccessTitleExpired => 'انتهى الاشتراك';

  @override
  String get appAccessTitleUnavailable => 'التطبيق غير متاح';

  @override
  String get appAccessMessageDeleted => 'هذا التطبيق تم حذفه ولم يعد متاحاً.';

  @override
  String get appAccessMessageExpired => 'انتهى اشتراك هذا التطبيق. يرجى التواصل مع الدعم.';

  @override
  String get appAccessMessageUnavailable => 'هذا التطبيق غير متاح حالياً. يرجى المحاولة لاحقاً.';

  @override
  String get appAccessRetry => 'حاول مجدداً';
}
