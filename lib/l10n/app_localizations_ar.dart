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
  String get validation_phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get validation_emailInvalid => 'البريد الإلكتروني غير صالح';

  @override
  String get validation_invalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get validation_passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validation_invalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get validation_passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get validation_passwordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validation_codeRequired => 'رمز التحقق مطلوب';

  @override
  String get validation_invalidCode => 'الرمز غير صحيح أو منتهي الصلاحية';

  @override
  String get validation_emailAlreadyExists => 'البريد الإلكتروني مسجل مسبقاً';

  @override
  String get validation_phoneAlreadyExists => 'رقم الهاتف مسجل مسبقاً';

  @override
  String get general_cancel => 'إلغاء';

  @override
  String get general_or => 'أو';

  @override
  String get general_optional => 'اختياري';

  @override
  String get error_somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get error_serverError => 'خطأ في الخادم. يرجى المحاولة لاحقاً.';

  @override
  String get connection_reconnecting => 'جارٍ الاتصال...';

  @override
  String get connection_offline => 'لا يوجد اتصال بالإنترنت';

  @override
  String get connection_issue => 'مشكلة في الاتصال';

  @override
  String get connection_timeout => 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get authGateContinueAs => 'تابع كـ';

  @override
  String get authGateRoleAdminOwner => 'مدير / مالك';

  @override
  String get authGateRoleUser => 'مستخدم عادي';

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

  @override
  String get common_or => 'أو';

  @override
  String get forgotPassword_title => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPassword_subtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رمزاً.';

  @override
  String get forgotPassword_sendCode => 'إرسال الرمز';

  @override
  String get forgotPassword_spamTip => 'تلميح: تحقق من مجلد البريد غير الهام أيضاً 👀';

  @override
  String get forgotPassword_verifyTitle => 'أدخل رمز التحقق';

  @override
  String forgotPassword_codeSentTo(String email) {
    return 'أرسلنا رمزاً إلى $email';
  }

  @override
  String get forgotPassword_codeLabel => 'الرمز';

  @override
  String get forgotPassword_verify => 'تحقق';

  @override
  String get forgotPassword_resendCode => 'إعادة إرسال الرمز';

  @override
  String get forgotPassword_newPasswordTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get forgotPassword_newPasswordSubtitle => 'اجعلها قوية — نسختك المستقبلية ستشكرك.';

  @override
  String get forgotPassword_newPassword => 'كلمة المرور الجديدة';

  @override
  String get forgotPassword_confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword_savePassword => 'حفظ كلمة المرور';

  @override
  String get forgotPassword_enterAllDigits => 'يرجى إدخال جميع الأرقام';

  @override
  String get forgotPassword_otpScreenTitle => 'أدخل رمز التحقق';

  @override
  String get forgotPassword_otpScreenSubtitle => 'أدخل الرمز المرسل إلى بريدك الإلكتروني أو هاتفك';

  @override
  String get forgotPassword_checkSms => 'تحقق من الرسائل النصية';

  @override
  String get forgotPassword_checkEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get forgotPassword_checkEmailOrSms => 'تحقق من بريدك الإلكتروني أو الرسائل';

  @override
  String forgotPassword_codeExpiresIn(int seconds) {
    return 'ينتهي الرمز خلال $seconds ثانية';
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

  @override
  String get home_welcome => 'مرحباً بك';

  @override
  String get home_weightUpdated => 'تم تحديث وزنك بنجاح';

  @override
  String get home_noData => 'لا توجد بيانات';

  @override
  String get home_sessions => 'حصة';

  @override
  String get home_kgLost => 'كجم فقدان';

  @override
  String get home_workouts => 'تمرين';

  @override
  String get home_minutes => 'دقيقة';

  @override
  String get home_quickActions => 'إجراءات سريعة';

  @override
  String get home_bookClass => 'حجز حصة';

  @override
  String get home_myProgress => 'تقدمي';

  @override
  String get home_membership => 'العضوية';

  @override
  String get home_support => 'الدعم';

  @override
  String get home_updateWeight => 'حدّث وزنك';

  @override
  String get home_save => 'حفظ';

  @override
  String get home_weightHint => '75.5';

  @override
  String get home_navHome => 'الرئيسية';

  @override
  String get home_navActivities => 'الأنشطة';

  @override
  String get home_navProfile => 'الملف الشخصي';

  @override
  String get home_membershipStatus => 'حالة العضوية';

  @override
  String get home_expiresOn => 'تنتهي في';

  @override
  String get home_renewNow => 'تجديد الآن';

  @override
  String get memberBottomNavHome => 'الرئيسية';

  @override
  String get memberBottomNavPlans => 'الخطط';

  @override
  String get memberBottomNavQr => 'QR';

  @override
  String get memberBottomNavClasses => 'الحصص';

  @override
  String get memberBottomNavAccount => 'حسابي';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get memberHomeTodaySchedule => 'جدول اليوم';

  @override
  String get memberHomeViewAll => 'عرض الكل';

  @override
  String memberHomeWithTrainer(Object trainerName) {
    return 'مع $trainerName';
  }

  @override
  String memberHomeDurationMinutes(Object minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get memberHomeNoScheduleToday => 'لا توجد حصص اليوم — استمتع بيوم راحة! 💪';

  @override
  String get home_quoteOfTheDay => 'مقولة اليوم';

  @override
  String get home_progressTracking => 'متابعة التقدم';

  @override
  String get home_weightTrackerSubtitle => 'كيف كان أسبوعك؟ خذ لحظة لتحديث وزنك وتتبع تقدمك نحو هدفك';

  @override
  String get home_updateWeightNow => 'تحديث وزني الآن';

  @override
  String get home_bookTrainer => 'حجز مدرب';

  @override
  String get home_checkInCode => 'رمز الدخول';

  @override
  String get home_paymentHistory => 'سجل الدفعات';

  @override
  String get signup_success => 'تم التسجيل بنجاح يمكنك تسجيل الدخول الان';

  @override
  String get mostPopular => 'الأكثر شيوعاً';

  @override
  String get selectThisPlan => 'اختيار هذه الخطة';

  @override
  String get renew => 'تجديد';

  @override
  String get planTypeGym => 'جيم';

  @override
  String get planTypeClasses => 'حصص';

  @override
  String get planTypeMixed => 'مختلط';

  @override
  String get billingMonthly => 'شهري';

  @override
  String get billingYearly => 'سنوي';

  @override
  String get billingWeekly => 'أسبوعي';

  @override
  String get membershipStatusActive => 'نشط';

  @override
  String get membershipStatusFrozen => 'مجمّد';

  @override
  String get membershipStatusExpired => 'منتهي';

  @override
  String remainingDays(Object days) {
    return 'متبقي $days يوم';
  }

  @override
  String membershipEndsAt(Object date) {
    return 'تنتهي في $date';
  }

  @override
  String get memberPlansTitle => 'خطط العضوية';

  @override
  String get memberPlansSubtitle => 'اختر الخطة المناسبة لك';

  @override
  String get memberPlansEmpty => 'لا توجد خطط متاحة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get back => 'رجوع';

  @override
  String get checkoutComingSoon => 'الدفع قريباً';

  @override
  String get planDuration => 'مدة الخطة';

  @override
  String get visitLimit => 'حد الزيارات';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get freezeDays => 'أيام التجميد';

  @override
  String get planFeatures => 'مميزات الخطة';

  @override
  String get couponCode => 'رمز الخصم';

  @override
  String get enterCouponCode => 'أدخل رمز الخصم';

  @override
  String get apply => 'تطبيق';

  @override
  String couponAppliedFinalPrice(Object price) {
    return 'السعر النهائي: $price';
  }

  @override
  String get selectedPlan => 'الخطة المختارة';

  @override
  String get baseAmount => 'المبلغ الأساسي';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get planDetails => 'تفاصيل الخطة';

  @override
  String get dayMonday => 'الإثنين';

  @override
  String get dayTuesday => 'الثلاثاء';

  @override
  String get dayWednesday => 'الأربعاء';

  @override
  String get dayThursday => 'الخميس';

  @override
  String get dayFriday => 'الجمعة';

  @override
  String get daySaturday => 'السبت';

  @override
  String get daySunday => 'الأحد';

  @override
  String get memberSessionsDifficultyBeginner => 'مبتدئ';

  @override
  String get memberSessionsDifficultyIntermediate => 'متوسط';

  @override
  String get memberSessionsDifficultyAdvanced => 'متقدم';

  @override
  String get memberSessionsBookNow => 'احجز الآن';

  @override
  String get memberSessionsTitle => 'الحصص الرياضية';

  @override
  String get memberSessionsSubtitle => 'احجز مكانك في الحصة المفضلة';

  @override
  String memberSessionsRoom(String roomName) {
    return 'قاعة $roomName';
  }

  @override
  String memberSessionsMinute(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String memberSessionsSeatsAvailable(int count) {
    return '$count مقاعد';
  }

  @override
  String get memberSessionsLoading => 'جارٍ تحميل الحصص...';

  @override
  String get memberSessionsEmpty => 'لا توجد حصص متاحة';

  @override
  String get memberSessionsError => 'تعذر تحميل الحصص';

  @override
  String get memberSessionsFilterTitle => 'تصفية الحصص';

  @override
  String get memberSessionsFilterClassType => 'نوع الحصة';

  @override
  String get memberSessionsFilterTrainer => 'المدرب';

  @override
  String get memberSessionsFilterBranch => 'الفرع';

  @override
  String get memberSessionsFilterReset => 'إعادة تعيين';

  @override
  String get memberSessionsFilterApply => 'تطبيق الفلتر';

  @override
  String get sessionDetailTimeLabel => 'الوقت';

  @override
  String get sessionDetailDateLabel => 'التاريخ';

  @override
  String get sessionDetailSeatsLabel => 'المقاعد';

  @override
  String sessionDetailSeatsRemaining(Object count) {
    return '$count متبقي';
  }

  @override
  String get sessionDetailLocationLabel => 'المكان';

  @override
  String get sessionDetailAboutTitle => 'عن الحصة';

  @override
  String get sessionDetailBenefitsTitle => 'الفوائد';

  @override
  String get sessionDetailEquipmentTitle => 'المعدات المطلوبة';

  @override
  String get sessionDetailBookNow => 'احجز الآن';

  @override
  String get sessionDetailAlreadyBooked => 'تم الحجز';

  @override
  String get sessionDetailWaitlisted => 'في قائمة الانتظار';

  @override
  String get monthJanuary => 'يناير';

  @override
  String get monthFebruary => 'فبراير';

  @override
  String get monthMarch => 'مارس';

  @override
  String get monthApril => 'أبريل';

  @override
  String get monthMay => 'مايو';

  @override
  String get monthJune => 'يونيو';

  @override
  String get monthJuly => 'يوليو';

  @override
  String get monthAugust => 'أغسطس';

  @override
  String get monthSeptember => 'سبتمبر';

  @override
  String get monthOctober => 'أكتوبر';

  @override
  String get monthNovember => 'نوفمبر';

  @override
  String get monthDecember => 'ديسمبر';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navMembers => 'الأعضاء';

  @override
  String get navPlans => 'الخطط';

  @override
  String get navStaff => 'الموظفون';

  @override
  String get navPayments => 'المدفوعات';

  @override
  String get navClasses => 'الحصص';

  @override
  String get navAiAssistant => 'المساعد الذكي';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navLogout => 'تسجيل الخروج';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get sectionCoreOwner => 'القسم الرئيسي';

  @override
  String get sectionOperationsReception => 'العمليات / الاستقبال';

  @override
  String get sectionTrainingPt => 'التدريب / PT';

  @override
  String get navTrainers => 'المدربون / PT';

  @override
  String get navReceptionStaff => 'موظفو الاستقبال';

  @override
  String get navGymProfile => 'ملف الصالة';

  @override
  String get navBranches => 'الفروع';

  @override
  String get navCheckins => 'تسجيل الحضور';

  @override
  String get navClassesPt => 'الحصص والتدريب';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get navPtSessions => 'جلسات PT';

  @override
  String get navTrainingVideos => 'فيديوهات التدريب';
}
