// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

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
  String get login_continueWithGoogle => 'متابعة باستخدام Google';

  @override
  String get login_continueWithApple => 'متابعة باستخدام Apple';

  @override
  String get login_noAccount => 'ليس لديك حساب؟';

  @override
  String get login_createAccount => 'إنشاء حساب جديد';

  @override
  String get validation_emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get validation_invalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get validation_passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validation_invalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get connection_reconnecting => 'جارٍ الاتصال...';

  @override
  String get connection_offline => 'لا يوجد اتصال بالإنترنت';

  @override
  String get connection_issue => 'مشكلة في الاتصال';
}
