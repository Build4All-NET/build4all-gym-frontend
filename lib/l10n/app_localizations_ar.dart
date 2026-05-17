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
  String get validation_invalidCode => 'الرمز غير صالح أو منتهي الصلاحية';

  @override
  String get validation_emailAlreadyExists => 'البريد الإلكتروني مستخدم مسبقاً';

  @override
  String get validation_phoneAlreadyExists => 'رقم الهاتف مستخدم مسبقاً';

  @override
  String get validation_passwordNoLetter => 'يجب أن تحتوي كلمة المرور على حرف واحد على الأقل';

  @override
  String get validation_passwordNoNumber => 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get validation_confirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get general_cancel => 'إلغاء';

  @override
  String get general_or => 'أو';

  @override
  String get general_optional => 'اختياري';

  @override
  String get general_retry => 'إعادة المحاولة';

  @override
  String get general_save => 'حفظ';

  @override
  String get general_edit => 'تعديل';

  @override
  String get general_delete => 'حذف';

  @override
  String get general_back => 'رجوع';

  @override
  String get general_done => 'تم';

  @override
  String get general_required => 'مطلوب';

  @override
  String get general_active => 'نشط';

  @override
  String get general_inactive => 'غير نشط';

  @override
  String get general_search => 'بحث';

  @override
  String get general_noPhone => 'لا يوجد هاتف';

  @override
  String get error_somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مجدداً.';

  @override
  String get error_serverError => 'خطأ في الخادم. يرجى المحاولة لاحقاً.';

  @override
  String get connection_reconnecting => 'جارٍ الاتصال...';

  @override
  String get connection_offline => 'لا يوجد اتصال بالإنترنت';

  @override
  String get connection_issue => 'مشكلة في الاتصال';

  @override
  String get connection_timeout => 'انتهت مهلة الطلب. يرجى المحاولة مجدداً.';

  @override
  String get authGateContinueAs => 'المتابعة كـ';

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
  String get appAccessMessageDeleted => 'تم حذف هذا التطبيق ولم يعد متاحاً.';

  @override
  String get appAccessMessageExpired => 'انتهى اشتراك هذا التطبيق. يرجى التواصل مع الدعم.';

  @override
  String get appAccessMessageUnavailable => 'هذا التطبيق غير متاح حالياً. يرجى المحاولة لاحقاً.';

  @override
  String get appAccessRetry => 'إعادة المحاولة';

  @override
  String get common_or => 'أو';

  @override
  String get forgotPassword_title => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPassword_subtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رمزاً.';

  @override
  String get forgotPassword_sendCode => 'إرسال الرمز';

  @override
  String get forgotPassword_spamTip => 'تلميح: تحقق من مجلد البريد غير المرغوب فيه 👀';

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
  String get forgotPassword_newPasswordSubtitle => 'اجعلها قوية — ستشكر نفسك لاحقاً.';

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
  String get forgotPassword_checkSms => 'تحقق من رسائلك النصية';

  @override
  String get forgotPassword_checkEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get forgotPassword_checkEmailOrSms => 'تحقق من بريدك الإلكتروني أو رسائلك النصية';

  @override
  String forgotPassword_codeExpiresIn(int seconds) {
    return 'ينتهي الرمز خلال $secondsث';
  }

  @override
  String get forgotPassword_codeExpired => 'انتهت صلاحية الرمز';

  @override
  String get forgotPassword_verifyCode => 'التحقق من الرمز';

  @override
  String get forgotPassword_didntReceiveCode => 'لم تستلم الرمز؟';

  @override
  String get forgotPassword_emailOrPhone => 'البريد الإلكتروني أو الهاتف';

  @override
  String get forgotPassword_emailOrPhoneHint => 'أدخل بريدك الإلكتروني أو رقم هاتفك';

  @override
  String get forgotPassword_fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get forgotPassword_invalidEmailOrPhone => 'بريد إلكتروني أو رقم هاتف غير صالح';

  @override
  String get forgotPassword_sendOtp => 'إرسال رمز التحقق';

  @override
  String get forgotPassword_newPasswordScreenTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get forgotPassword_newPasswordScreenSubtitle => 'أدخل كلمة المرور الجديدة أدناه';

  @override
  String get forgotPassword_passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح';

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
  String get signup_alreadyVerifiedResume => 'الحساب محقق بالفعل. جارٍ إكمال ملفك الشخصي.';

  @override
  String get signup_success => 'تم التسجيل بنجاح. يمكنك الآن تسجيل الدخول.';

  @override
  String get otp_title => 'تأكيد الحساب';

  @override
  String get otp_subtitle => 'أدخل رمز التحقق المرسل';

  @override
  String get otp_step2Label => 'التحقق من الهوية';

  @override
  String get otp_sentTo => 'أُرسل إلى';

  @override
  String otp_enterDigits(int count) {
    return 'أدخل رمز التحقق المكوّن من $count أرقام';
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
  String get otp_backToSignup => 'العودة إلى التسجيل';

  @override
  String get otp_debugTip => 'للاختبار استخدم الرمز 1234';

  @override
  String get completeProfile_title => 'أكمل ملفك الشخصي';

  @override
  String get completeProfile_subtitle => 'أخبرنا المزيد عنك';

  @override
  String get completeProfile_lastStepTitle => 'الخطوة الأخيرة!';

  @override
  String get completeProfile_lastStepSubtitle => 'اختر اسم مستخدم فريداً';

  @override
  String get completeProfile_stepLabel => 'المعلومات الشخصية';

  @override
  String get completeProfile_nameInstruction => 'نحتاج اسمك لتخصيص تجربتك';

  @override
  String get completeProfile_firstName => 'الاسم الأول';

  @override
  String get completeProfile_firstNameHint => 'أدخل اسمك الأول';

  @override
  String get completeProfile_firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get completeProfile_lastName => 'اسم العائلة';

  @override
  String get completeProfile_lastNameHint => 'أدخل اسم عائلتك';

  @override
  String get completeProfile_continueButton => 'متابعة';

  @override
  String get completeProfile_usernameInstruction => 'سيظهر اسم المستخدم في ملفك الشخصي';

  @override
  String get completeProfile_username => 'اسم المستخدم';

  @override
  String get completeProfile_usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get completeProfile_usernameTooShort => 'يجب أن يكون 3 أحرف على الأقل';

  @override
  String get completeProfile_usernameInvalid => 'يُسمح بالحروف والأرقام و _ و . فقط';

  @override
  String get completeProfile_usernameTaken => 'اسم المستخدم هذا محجوز مسبقاً';

  @override
  String get completeProfile_profileType => 'نوع الملف الشخصي';

  @override
  String get completeProfile_publicTitle => 'حساب عام';

  @override
  String get completeProfile_publicDescription => 'يمكن لأي شخص عرض ملفك ونشاطك';

  @override
  String get completeProfile_privateTitle => 'حساب خاص';

  @override
  String get completeProfile_privateDescription => 'أنت فقط يمكنه رؤية معلوماتك ونشاطك';

  @override
  String get completeProfile_settingsNote => 'يمكنك تغيير هذه الإعدادات لاحقاً من ملفك الشخصي';

  @override
  String get completeProfile_finishButton => 'إنهاء والبدء';

  @override
  String get completeProfile_backButton => 'رجوع';

  @override
  String get home_welcome => 'مرحباً';

  @override
  String get home_weightUpdated => 'تم تحديث وزنك بنجاح ✅';

  @override
  String get home_noData => 'لا توجد بيانات متاحة';

  @override
  String get home_sessions => 'الجلسات';

  @override
  String get home_kgLost => 'كغ مفقودة';

  @override
  String get home_workouts => 'التمارين';

  @override
  String get home_minutes => 'دقيقة';

  @override
  String get home_quickActions => 'الإجراءات السريعة';

  @override
  String get home_bookClass => 'احجز فصلاً';

  @override
  String get home_myProgress => 'تقدمي';

  @override
  String get home_membership => 'العضوية';

  @override
  String get home_support => 'الدعم';

  @override
  String get home_updateWeight => 'تحديث وزنك';

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
  String get home_renewNow => 'جدد الآن';

  @override
  String get memberBottomNavHome => 'الرئيسية';

  @override
  String get memberBottomNavPlans => 'الخطط';

  @override
  String get memberBottomNavQr => 'QR';

  @override
  String get memberBottomNavClasses => 'الفصول';

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
    return 'مع المدرب $trainerName';
  }

  @override
  String memberHomeDurationMinutes(Object minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get memberHomeNoScheduleToday => 'لا توجد فصول اليوم — استمتع بيوم الراحة! 💪';

  @override
  String get home_quoteOfTheDay => 'اقتباس اليوم';

  @override
  String get home_progressTracking => 'تتبع التقدم';

  @override
  String get home_weightTrackerSubtitle => 'كيف كانت أسبوعك؟ خذ لحظة لتحديث وزنك وتتبع تقدمك.';

  @override
  String get home_updateWeightNow => 'تحديث وزني';

  @override
  String get home_bookTrainer => 'احجز مدرباً';

  @override
  String get home_checkInCode => 'رمز تسجيل الحضور';

  @override
  String get home_paymentHistory => 'سجل المدفوعات';

  @override
  String get mostPopular => 'الأكثر شعبية';

  @override
  String get selectThisPlan => 'اختر هذه الخطة';

  @override
  String get renew => 'تجديد';

  @override
  String get planTypeGym => 'صالة';

  @override
  String get planTypeClasses => 'فصول';

  @override
  String get planTypeMixed => 'مختلطة';

  @override
  String get billingMonthly => 'شهري';

  @override
  String get billingYearly => 'سنوي';

  @override
  String get billingWeekly => 'أسبوعي';

  @override
  String get membershipStatusActive => 'نشطة';

  @override
  String get membershipStatusFrozen => 'مجمدة';

  @override
  String get membershipStatusExpired => 'منتهية';

  @override
  String remainingDays(int days) {
    return 'متبقي $days يوم';
  }

  @override
  String membershipEndsAt(String date) {
    return 'تنتهي في $date';
  }

  @override
  String get memberPlansTitle => 'خطط العضوية';

  @override
  String get memberPlansSubtitle => 'اختر الخطة التي تناسب أهدافك';

  @override
  String get memberPlansEmpty => 'لا توجد خطط متاحة الآن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get back => 'رجوع';

  @override
  String get checkoutComingSoon => 'قريباً — الدفع قيد التطوير';

  @override
  String get planDuration => 'المدة';

  @override
  String get visitLimit => 'حد الزيارات';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get freezeDays => 'أيام التجميد';

  @override
  String get planFeatures => 'المميزات';

  @override
  String get couponCode => 'رمز الكوبون';

  @override
  String get enterCouponCode => 'أدخل رمز الكوبون';

  @override
  String get apply => 'تطبيق';

  @override
  String couponAppliedFinalPrice(String price) {
    return '✓ تم تطبيق الكوبون — السعر النهائي: $price \$';
  }

  @override
  String get selectedPlan => 'الخطة المحددة';

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
  String get memberSessionsTitle => 'الفصول الرياضية';

  @override
  String get memberSessionsSubtitle => 'احجز مقعدك في فصلك المفضل';

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
  String get memberSessionsLoading => 'جارٍ تحميل الجلسات...';

  @override
  String get memberSessionsEmpty => 'لا توجد جلسات متاحة';

  @override
  String get memberSessionsError => 'فشل تحميل الجلسات';

  @override
  String get memberSessionsFilterTitle => 'تصفية الفصول';

  @override
  String get memberSessionsFilterClassType => 'نوع الفصل';

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
  String sessionDetailSeatsRemaining(int count) {
    return 'متبقي $count';
  }

  @override
  String get sessionDetailLocationLabel => 'الموقع';

  @override
  String get sessionDetailAboutTitle => 'عن الفصل';

  @override
  String get sessionDetailBenefitsTitle => 'الفوائد';

  @override
  String get sessionDetailEquipmentTitle => 'المعدات المطلوبة';

  @override
  String get sessionDetailBookNow => 'احجز الآن';

  @override
  String get sessionDetailAlreadyBooked => 'محجوز مسبقاً';

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
  String get navClasses => 'الفصول';

  @override
  String get navAiAssistant => 'المساعد الذكي';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navLogout => 'تسجيل الخروج';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get sectionCoreOwner => 'المالك الأساسي';

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
  String get navClassesPt => 'الفصول والتدريب';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get navPtSessions => 'جلسات PT';

  @override
  String get navTrainingVideos => 'مقاطع التدريب';

  @override
  String get accountProfileUpdateSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get accountStatExercises => 'التمارين';

  @override
  String get accountStatSessions => 'الجلسات';

  @override
  String get accountStatAchievements => 'الإنجازات';

  @override
  String get accountMyBookings => 'حجوزاتي';

  @override
  String get accountLoyaltyPoints => 'نقاط الولاء';

  @override
  String get accountReferralTitle => 'رمز الإحالة الخاص بك';

  @override
  String get accountReferralSubtitle => 'شارك واكسب مكافآت';

  @override
  String get accountReferralCodeLabel => 'رمزك';

  @override
  String get accountReferralCopied => 'تم نسخ الرمز';

  @override
  String get accountReferralShare => 'مشاركة الرمز';

  @override
  String get accountPersonalInfo => 'المعلومات الشخصية';

  @override
  String get accountEmail => 'البريد الإلكتروني';

  @override
  String get accountPhone => 'الهاتف';

  @override
  String get accountDateOfBirth => 'تاريخ الميلاد';

  @override
  String get accountAddress => 'العنوان';

  @override
  String get accountEditProfile => 'تعديل الملف الشخصي';

  @override
  String get accountSectionAccount => 'الحساب';

  @override
  String get accountSectionSettings => 'الإعدادات';

  @override
  String get accountPaymentMethods => 'طرق الدفع';

  @override
  String get accountMyMembership => 'عضويتي';

  @override
  String get accountNotifications => 'الإشعارات';

  @override
  String get accountSettings => 'الإعدادات';

  @override
  String get accountHelpSupport => 'المساعدة والدعم';

  @override
  String get appVersion => 'الإصدار';

  @override
  String get ptAll => 'الكل';

  @override
  String get ptFavorites => 'المفضلة';

  @override
  String ptFavoritesWithCount(int count) {
    return 'المفضلة $count';
  }

  @override
  String get ptPerSession => '/جلسة';

  @override
  String ptYearsExperience(int years) {
    return '$years سنوات خبرة';
  }

  @override
  String ptReviews(int count) {
    return '$count تقييم';
  }

  @override
  String get ptScreenTitle => 'المدربون الشخصيون';

  @override
  String get ptScreenSubtitle => 'اختر المدرب المناسب لأهدافك';

  @override
  String get ptBookSession => 'احجز جلسة';

  @override
  String get ptNoTrainers => 'لا يوجد مدربون متاحون';

  @override
  String accountMemberSince(String date) {
    return 'عضو منذ $date';
  }

  @override
  String get ptBookingChooseDate => 'اختر التاريخ';

  @override
  String get ptBookingChooseTime => 'اختر الوقت';

  @override
  String get ptBookingNoSlotsForDate => 'لا توجد مواعيد متاحة لهذا التاريخ.';

  @override
  String get ptDetailSession => 'جلسة';

  @override
  String get ptTrainingVideosTitle => 'مقاطع التدريب';

  @override
  String get ptTrainingVideosEmpty => 'لا توجد مقاطع تدريبية بعد.';

  @override
  String get ptTrainingVideosMissingUrl => 'رابط الفيديو مفقود.';

  @override
  String get ptTrainingVideosOpenError => 'تعذر فتح هذا الفيديو.';

  @override
  String get ptTrainerDetailsNotFound => 'تفاصيل المدرب غير موجودة.';

  @override
  String get ptFavoriteUpdateFailed => 'فشل تحديث المفضلة.';

  @override
  String get ptConfirmBooking => 'تأكيد الحجز';

  @override
  String ptBookingSelected(String date, String time) {
    return 'تم اختيار الحجز: $date في $time';
  }

  @override
  String get ptBookingSummary => 'ملخص الحجز';

  @override
  String get ptBookingTrainer => 'المدرب:';

  @override
  String get ptBookingDate => 'التاريخ:';

  @override
  String get ptBookingTime => 'الوقت:';

  @override
  String get ptBookingTotalAmount => 'المبلغ الإجمالي:';

  @override
  String get ptBookingSuccess => 'تم تأكيد الحجز بنجاح.';

  @override
  String get ptSlotAlreadyBooked => 'لقد حجزت هذا الموعد مسبقاً.';

  @override
  String get ptPackageChoosePackage => 'اختر الباقة';

  @override
  String get ptPackageChooseDays => 'اختر الأيام';

  @override
  String get ptPackageChooseTime => 'اختر الوقت';

  @override
  String get ptPackageBookingSummary => 'ملخص الحجز';

  @override
  String get ptPackageConfirmBooking => 'تأكيد الحجز';

  @override
  String get ptPackageBookingSuccess => 'تم تأكيد حجز الباقة بنجاح.';

  @override
  String get ptPackageBookingFailed => 'تعذر تأكيد حجز الباقة.';

  @override
  String get ptPackageNoPackages => 'لا توجد باقات متاحة الآن';

  @override
  String get ptPackageSessions => 'جلسات';

  @override
  String get ptPackageDays => 'أيام';

  @override
  String get ptPackageFinalPrice => 'السعر النهائي';

  @override
  String get ptPackageOriginalPrice => 'السعر الأصلي';

  @override
  String get ptPackageSalePrice => 'سعر العرض';

  @override
  String get ptPackageSelectedPackage => 'الباقة المحددة';

  @override
  String get ptPackageSelectedDays => 'الأيام المحددة';

  @override
  String get ptPackageSelectedTime => 'الوقت المحدد';

  @override
  String get ptPackageMaxSessionsReached => 'لا يمكنك اختيار أيام أكثر من جلسات الباقة';

  @override
  String ptPackageDaysPerWeekRange(int min, int max) {
    return 'اختر من $min إلى $max يوم في الأسبوع';
  }

  @override
  String ptPackageDaysPerWeekExact(int count) {
    return 'اختر $count يوم/أيام في الأسبوع';
  }

  @override
  String ptPackageMaxDaysReached(int max) {
    return 'لا يمكنك اختيار أكثر من $max يوم في الأسبوع';
  }

  @override
  String get ptPackageNoAvailableSlots => 'لا توجد أوقات متاحة';

  @override
  String get ptWeeklySlotsFailed => 'تعذر تحميل الأوقات المتاحة';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfileSubtitle => 'تحديث معلوماتك الشخصية';

  @override
  String get editProfileFullName => 'الاسم الكامل';

  @override
  String get editProfileEmail => 'البريد الإلكتروني';

  @override
  String get editProfilePhone => 'رقم الهاتف';

  @override
  String get editProfileDateOfBirth => 'تاريخ الميلاد';

  @override
  String get editProfileAddress => 'العنوان';

  @override
  String get editProfileGender => 'الجنس';

  @override
  String get editProfileMale => 'ذكر';

  @override
  String get editProfileFemale => 'أنثى';

  @override
  String get editProfileSave => 'حفظ التغييرات';

  @override
  String get editProfileCancel => 'إلغاء';

  @override
  String get editProfileNameRequired => 'الاسم مطلوب';

  @override
  String get editProfileEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get editProfileInvalidEmail => 'البريد الإلكتروني غير صالح';

  @override
  String get accountGender => 'الجنس';

  @override
  String get accountGenderMale => 'ذكر';

  @override
  String get accountGenderFemale => 'أنثى';

  @override
  String get editProfileFirstName => 'الاسم الأول';

  @override
  String get editProfileLastName => 'اسم العائلة';

  @override
  String get editProfileUsername => 'اسم المستخدم';

  @override
  String get editProfileChangePassword => 'تغيير كلمة المرور';

  @override
  String get editProfileCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get editProfileNewPassword => 'كلمة المرور الجديدة';

  @override
  String get editProfileRequired => 'مطلوب.';

  @override
  String get editProfileUsernameRequired => 'اسم المستخدم مطلوب.';

  @override
  String get editProfileEmailRequiredMessage => 'البريد الإلكتروني مطلوب.';

  @override
  String get editProfileInvalidEmailMessage => 'البريد الإلكتروني غير صالح.';

  @override
  String get editProfilePhoneRequired => 'رقم الهاتف مطلوب.';

  @override
  String get editProfileCurrentPasswordRequired => 'كلمة المرور الحالية مطلوبة.';

  @override
  String get editProfileNewPasswordRequired => 'كلمة المرور الجديدة مطلوبة.';

  @override
  String get editProfilePasswordTooShort => 'يجب أن تكون كلمة المرور الجديدة 6 أحرف على الأقل.';

  @override
  String get editProfilePasswordSameAsCurrent => 'يجب أن تختلف كلمة المرور الجديدة عن الحالية.';

  @override
  String get editProfileInvalidOwnerProject => 'معرف رابط مشروع المالك غير صالح.';

  @override
  String get editProfileEmailVerified => 'تم التحقق من البريد الإلكتروني بنجاح.';

  @override
  String get editProfilePasswordUpdated => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get editProfileOnlyLetters => 'يُسمح بالحروف والمسافات فقط.';

  @override
  String get editProfileVerifyNewEmail => 'تحقق من البريد الإلكتروني الجديد';

  @override
  String get editProfileVerifyPasswordChange => 'تحقق من تغيير كلمة المرور';

  @override
  String get editProfileCodeSentTo => 'تم إرسال الرمز إلى';

  @override
  String get editProfileVerificationCode => 'رمز التحقق';

  @override
  String get editProfileResend => 'إعادة الإرسال';

  @override
  String get editProfileVerify => 'تحقق';

  @override
  String get editProfileCodeRequired => 'رمز التحقق مطلوب.';

  @override
  String get admin_allBranches => 'جميع الفروع';

  @override
  String get admin_aiTitle => 'المساعد الذكي';

  @override
  String get admin_aiNewConversation => 'محادثة جديدة';

  @override
  String get admin_aiRecentQueries => 'الاستفسارات الأخيرة';

  @override
  String get admin_aiView => 'عرض';

  @override
  String get admin_aiYouMightAlsoAsk => 'قد تسأل أيضاً:';

  @override
  String get admin_aiInputHint => 'اسأل سؤالاً عن صالتك...';

  @override
  String get admin_aiRetry => 'إعادة المحاولة';

  @override
  String get admin_aiHeroBannerTitle => 'مساعد التحليلات الذكي';

  @override
  String get admin_aiHeroBannerSubtitle => 'اسألني أي شيء عن صالتك';

  @override
  String get admin_aiHeroBannerDesc => 'احصل على تحليلات ورؤى وتوصيات فورية بناءً على بيانات صالتك.';

  @override
  String get admin_aiSuggestedQuestions => 'أسئلة مقترحة';

  @override
  String get admin_aiQueryFailed => 'عذراً، لم أتمكن من معالجة طلبك. يرجى المحاولة مجدداً.';

  @override
  String get admin_branchesTitle => 'الفروع';

  @override
  String get admin_addBranchTitle => 'إضافة فرع';

  @override
  String get admin_branchCreatedSuccess => 'تم إنشاء الفرع بنجاح';

  @override
  String get admin_branchBasicInfo => 'المعلومات الأساسية';

  @override
  String get admin_branchName => 'اسم الفرع';

  @override
  String get admin_branchNameRequired => 'اسم الفرع مطلوب';

  @override
  String get admin_branchCity => 'المدينة / الموقع';

  @override
  String get admin_branchCityRequired => 'المدينة مطلوبة';

  @override
  String get admin_branchContactInfo => 'معلومات التواصل';

  @override
  String get admin_branchPhone => 'الهاتف';

  @override
  String get admin_branchPhoneRequired => 'الهاتف مطلوب';

  @override
  String get admin_branchEmail => 'البريد الإلكتروني';

  @override
  String get admin_branchEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get admin_branchEmailInvalid => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get admin_branchAddress => 'العنوان';

  @override
  String get admin_branchAddressRequired => 'العنوان مطلوب';

  @override
  String get admin_branchOperatingHours => 'ساعات العمل';

  @override
  String get admin_branchOpeningTime => 'وقت الفتح';

  @override
  String get admin_branchClosingTime => 'وقت الإغلاق';

  @override
  String get admin_branchTimeError => 'يجب أن يكون وقت الإغلاق بعد وقت الفتح';

  @override
  String get admin_branchStatus => 'الحالة';

  @override
  String get admin_branchActive => 'نشط';

  @override
  String get admin_branchInactive => 'غير نشط';

  @override
  String get admin_branchCreate => 'إنشاء الفرع';

  @override
  String get admin_branchOpeningRequired => 'يرجى تحديد وقت الفتح';

  @override
  String get admin_branchClosingRequired => 'يرجى تحديد وقت الإغلاق';

  @override
  String get admin_branchDetailTitle => 'تفاصيل الفرع';

  @override
  String get admin_branchMembers => 'الأعضاء';

  @override
  String get admin_branchTrainers => 'المدربون';

  @override
  String get admin_branchStaff => 'الموظفون';

  @override
  String get admin_branchMonthlyRevenue => 'الإيراد الشهري';

  @override
  String get admin_branchActiveStat => 'الفروع النشطة';

  @override
  String get admin_branchTotalMembers => 'إجمالي الأعضاء';

  @override
  String get admin_branchSearchHint => 'البحث باسم الفرع أو الموقع.';

  @override
  String get admin_branchAllStatus => 'جميع الحالات';

  @override
  String get admin_branchNoFound => 'لم يتم العثور على فروع';

  @override
  String get admin_branchRetry => 'إعادة المحاولة';

  @override
  String get admin_classesTitle => 'الفصول';

  @override
  String get admin_classTodayLabel => 'فصول اليوم';

  @override
  String get admin_classCancelTitle => 'إلغاء الفصل';

  @override
  String get admin_classCancelConfirm => 'هل أنت متأكد من إلغاء هذا الفصل؟ سيتم إشعار جميع الأعضاء المحجوزين.';

  @override
  String get admin_classKeep => 'الإبقاء على الفصل';

  @override
  String get admin_classYesCancel => 'نعم، إلغاء';

  @override
  String get admin_classCreatedSuccess => 'تم إنشاء الفصل بنجاح';

  @override
  String get admin_classUpdatedSuccess => 'تم تحديث الفصل بنجاح';

  @override
  String get admin_classCancelledSuccess => 'تم إلغاء الفصل';

  @override
  String get admin_classDone => 'تم';

  @override
  String get admin_classRetry => 'إعادة المحاولة';

  @override
  String get admin_classNoneToday => 'لا توجد فصول مجدولة لهذا اليوم';

  @override
  String get admin_classNewTypeLabel => 'نوع فصل جديد';

  @override
  String get admin_classNameField => 'الاسم *';

  @override
  String get admin_classRequired => 'مطلوب';

  @override
  String get admin_classDurationField => 'المدة (بالدقائق) *';

  @override
  String get admin_classMustBeNumber => 'يجب أن يكون رقماً';

  @override
  String get admin_classDifficulty => 'مستوى الصعوبة';

  @override
  String get admin_classBeginner => 'مبتدئ';

  @override
  String get admin_classIntermediate => 'متوسط';

  @override
  String get admin_classAdvanced => 'متقدم';

  @override
  String get admin_classPrice => 'السعر';

  @override
  String get admin_classCancel => 'إلغاء';

  @override
  String get admin_classFailedCreate => 'فشل إنشاء نوع الفصل';

  @override
  String get admin_classCreate => 'إنشاء';

  @override
  String get admin_classSelectDatetime => 'يرجى تحديد التاريخ والوقت';

  @override
  String get admin_classFillRequired => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get admin_classEditTitle => 'تعديل الفصل';

  @override
  String get admin_classAddTitle => 'إضافة فصل جديد';

  @override
  String get admin_classNameLabel => 'اسم الفصل *';

  @override
  String get admin_classTypeActivity => 'النوع / النشاط *';

  @override
  String get admin_classNewType => 'نوع جديد';

  @override
  String get admin_classSelectType => 'اختر النوع';

  @override
  String get admin_classTrainer => 'المدرب *';

  @override
  String get admin_classSelectTrainer => 'اختر المدرب';

  @override
  String get admin_classBranch => 'الفرع *';

  @override
  String get admin_classSelectBranch => 'اختر الفرع';

  @override
  String get admin_classDate => 'التاريخ *';

  @override
  String get admin_classTime => 'الوقت *';

  @override
  String get admin_classCapacity => 'السعة *';

  @override
  String get admin_classMaxParticipants => 'الحد الأقصى للمشاركين';

  @override
  String get admin_classRoomName => 'اسم القاعة';

  @override
  String get admin_classNotesDesc => 'ملاحظات / وصف';

  @override
  String get admin_classSave => 'حفظ الفصل';

  @override
  String get admin_classNearlyFull => 'شبه ممتلئ';

  @override
  String get admin_classBookings => 'الحجوزات';

  @override
  String get admin_classEdit => 'تعديل';

  @override
  String get admin_classToday => 'اليوم';

  @override
  String get admin_sessionBookingsTitle => 'حجوزات الجلسة';

  @override
  String get admin_sessionNoBookings => 'لا توجد حجوزات بعد';

  @override
  String get admin_sessionBooked => 'محجوز';

  @override
  String get admin_dashboardTitle => 'لوحة التحكم';

  @override
  String get admin_dashboardToday => 'اليوم';

  @override
  String get admin_dashboardThisWeek => 'هذا الأسبوع';

  @override
  String get admin_dashboardThisMonth => 'هذا الشهر';

  @override
  String get admin_dashboardCustom => 'مخصص';

  @override
  String get admin_dashboardTimePeriod => 'الفترة الزمنية';

  @override
  String get admin_dashboardRetry => 'إعادة المحاولة';

  @override
  String get admin_dashboardComingSoon => 'قريباً';

  @override
  String get admin_dashboardActiveMembers => 'الأعضاء النشطون';

  @override
  String get admin_dashboardDueSoon => 'مستحق قريباً';

  @override
  String get admin_dashboardPendingRenewals => 'التجديدات المعلقة';

  @override
  String get admin_dashboardLiveNow => 'مباشر الآن';

  @override
  String get admin_dashboardTodayCheckins => 'تسجيلات حضور اليوم';

  @override
  String get admin_dashboardSessions => 'الجلسات';

  @override
  String get admin_dashboardUpcomingPt => 'جلسات PT القادمة';

  @override
  String get admin_dashboardQuickActions => 'الإجراءات السريعة';

  @override
  String get admin_dashboardAddMember => 'إضافة عضو';

  @override
  String get admin_dashboardRecordPayment => 'تسجيل دفعة';

  @override
  String get admin_dashboardAddPlan => 'إضافة خطة';

  @override
  String get admin_dashboardSendAnnouncement => 'إرسال إعلان';

  @override
  String get admin_dashboardRecentActivity => 'النشاط الأخير';

  @override
  String get admin_dashboardViewAll => 'عرض الكل';

  @override
  String get admin_dashboardNoActivity => 'لا يوجد نشاط حديث';

  @override
  String get admin_dashboardAttendance => 'الحضور';

  @override
  String get admin_dashboardPaymentsCollected => 'المدفوعات المحصّلة';

  @override
  String get admin_dashboardExpiringPlans => 'الخطط المنتهية';

  @override
  String get admin_dashboardNext7Days => 'الـ 7 أيام القادمة';

  @override
  String get admin_dashboardTotalMembersLabel => 'إجمالي الأعضاء';

  @override
  String get admin_dashboardTotalPlans => 'إجمالي الخطط';

  @override
  String get admin_dashboardCanceled => 'الملغاة';

  @override
  String get admin_dashboardLast7Days => 'آخر 7 أيام';

  @override
  String get admin_dashboardChurnRate => 'معدل الإلغاء';

  @override
  String get admin_dashboardMonthlyRevenue => 'الإيراد الشهري';

  @override
  String get admin_membersTitle => 'الأعضاء';

  @override
  String get admin_memberDetailTitle => 'تفاصيل العضو';

  @override
  String get admin_memberNoFound => 'لم يتم العثور على أعضاء.';

  @override
  String get admin_memberRetry => 'إعادة المحاولة';

  @override
  String get admin_memberPlan => 'الخطة';

  @override
  String get admin_memberDueAmount => 'المبلغ المستحق';

  @override
  String get admin_memberExpiry => 'تاريخ الانتهاء';

  @override
  String get admin_memberBranch => 'الفرع';

  @override
  String get admin_memberWhatsApp => 'واتساب';

  @override
  String get admin_memberAttendance => 'الحضور';

  @override
  String get admin_memberRenew => 'تجديد';

  @override
  String get admin_memberPlanRenewal => 'تجديد الخطة';

  @override
  String get admin_memberUnblock => 'إلغاء الحظر';

  @override
  String get admin_memberBlock => 'حظر';

  @override
  String get admin_memberDelete => 'حذف';

  @override
  String get admin_memberEdit => 'تعديل';

  @override
  String get admin_memberEditTitle => 'تعديل العضو';

  @override
  String get admin_memberBlockTitle => 'حظر العضو';

  @override
  String get admin_memberBlockReasonHint => 'أدخل سبب الحظر';

  @override
  String get admin_memberDeleteTitle => 'حذف العضو';

  @override
  String admin_memberDeleteConfirm(String name) {
    return 'هل تريد حذف $name نهائياً؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get admin_memberCancel => 'إلغاء';

  @override
  String get admin_memberActive => 'نشط';

  @override
  String get admin_memberPending => 'معلق';

  @override
  String get admin_memberBlocked => 'محظور';

  @override
  String get admin_memberNoPlan => 'بلا خطة';

  @override
  String get admin_memberInactive => 'غير نشط';

  @override
  String get admin_memberAllStatus => 'جميع الحالات';

  @override
  String get admin_memberNewest => 'الأحدث';

  @override
  String get admin_memberOldest => 'الأقدم';

  @override
  String get admin_memberAlphabetical => 'أبجدي';

  @override
  String get admin_memberAllGender => 'جميع الأجناس';

  @override
  String get admin_memberMale => 'ذكر';

  @override
  String get admin_memberFemale => 'أنثى';

  @override
  String get admin_memberOther => 'آخر';

  @override
  String get admin_memberSearchHint => 'البحث بالاسم أو الهاتف أو رمز العضو';

  @override
  String get admin_membershipPackageTitle => 'باقة العضوية';

  @override
  String get admin_memberPlanName => 'اسم الخطة';

  @override
  String get admin_memberTotalAmount => 'المبلغ الإجمالي';

  @override
  String get admin_memberDiscount => 'الخصم';

  @override
  String get admin_memberPurchaseDate => 'تاريخ الشراء';

  @override
  String get admin_memberPaidAmount => 'المبلغ المدفوع';

  @override
  String get admin_memberDueAmountLabel => 'المبلغ المستحق';

  @override
  String get admin_memberRemainingDays => 'الأيام المتبقية';

  @override
  String get admin_memberQuickActions => 'الإجراءات السريعة';

  @override
  String get admin_memberCall => 'اتصال';

  @override
  String get admin_memberSms => 'رسالة نصية';

  @override
  String get admin_memberRenewPlan => 'تجديد الخطة';

  @override
  String get admin_plansTitle => 'الخطط';

  @override
  String get admin_plansDeleteTitle => 'حذف الخطة';

  @override
  String get admin_plansDeleteConfirm => 'هل أنت متأكد من حذف هذه الخطة؟';

  @override
  String get admin_plansCancel => 'إلغاء';

  @override
  String get admin_plansDelete => 'حذف';

  @override
  String get admin_plansRetry => 'إعادة المحاولة';

  @override
  String get admin_plansAllTypes => 'جميع الأنواع';

  @override
  String get admin_plansSearch => 'البحث في الخطط...';

  @override
  String get admin_plansNoFound => 'لم يتم العثور على خطط';

  @override
  String get admin_planActive => 'نشطة';

  @override
  String get admin_planInactive => 'غير نشطة';

  @override
  String get admin_planPrice => 'السعر';

  @override
  String get admin_planDurationLabel => 'المدة';

  @override
  String get admin_planMembersLabel => 'الأعضاء';

  @override
  String get admin_planVisitLimitLabel => 'حد الزيارات';

  @override
  String get admin_planUnlimitedLabel => 'غير محدود';

  @override
  String get admin_planAvailableAt => 'متاح في:';

  @override
  String get admin_planEdit => 'تعديل';

  @override
  String get admin_planDeleting => 'جارٍ الحذف...';

  @override
  String get admin_planDeleteLabel => 'حذف';

  @override
  String get admin_planOneTime => 'مرة واحدة';

  @override
  String get admin_planEditTitle => 'تعديل الخطة';

  @override
  String get admin_planAddTitle => 'إضافة خطة جديدة';

  @override
  String get admin_planNameField => 'اسم الخطة *';

  @override
  String get admin_planTypeField => 'النوع / النشاط *';

  @override
  String get admin_planSelectType => 'اختر النوع';

  @override
  String get admin_planPriceField => 'السعر *';

  @override
  String get admin_planDurationField => 'المدة *';

  @override
  String get admin_planSelectDuration => 'اختر المدة';

  @override
  String get admin_planDescription => 'الوصف';

  @override
  String get admin_planOptionalDesc => 'وصف اختياري';

  @override
  String get admin_planPromotion => 'العرض الترويجي';

  @override
  String get admin_planStatus => 'الحالة *';

  @override
  String get admin_planSelectStatus => 'اختر الحالة';

  @override
  String get admin_planAvailableBranches => 'الفروع المتاحة *';

  @override
  String get admin_planSelectBranch => 'اختر الفرع';

  @override
  String get admin_planMultiSelectNote => 'ملاحظة: دعم التحديد المتعدد قريباً';

  @override
  String get admin_planSaveChanges => 'حفظ التغييرات';

  @override
  String get admin_planCreateLabel => 'إنشاء الخطة';

  @override
  String get admin_planRequired => 'مطلوب';

  @override
  String get admin_planEnterValidNumber => 'أدخل رقماً صحيحاً';

  @override
  String get admin_planTotalPlans => 'إجمالي الخطط';

  @override
  String get admin_planTotalMembersLabel => 'الأعضاء';

  @override
  String get admin_planActiveCount => 'نشطة';

  @override
  String get admin_planCreatedSuccess => 'تم إنشاء الخطة بنجاح';

  @override
  String get admin_planUpdatedSuccess => 'تم تحديث الخطة بنجاح';

  @override
  String get admin_trainerDashboardTitle => 'لوحة تحكم المدرب';

  @override
  String get admin_trainerTodaySessions => 'جلسات اليوم';

  @override
  String get admin_trainerCompleted => 'مكتملة';

  @override
  String get admin_trainerUpcoming => 'القادمة';

  @override
  String get admin_trainerCancelledNoShow => 'ملغاة / غياب';

  @override
  String get admin_trainerTodaySchedule => 'جدول اليوم';

  @override
  String get admin_trainerNoSessionsToday => 'لا توجد جلسات مجدولة اليوم.';

  @override
  String get admin_trainerPtSession => 'جلسة PT';

  @override
  String get admin_trainerCheckIn => 'تسجيل الحضور';

  @override
  String get admin_trainerComplete => 'إتمام';

  @override
  String get admin_trainerCreatePackage => 'إنشاء باقة';

  @override
  String get admin_trainerAddAvailability => 'إضافة توفر';

  @override
  String get admin_trainerAddPtService => 'إضافة خدمة PT';

  @override
  String get admin_trainerCreateSession => 'إنشاء جلسة';

  @override
  String get admin_trainerQuickActionsTitle => 'الإجراءات السريعة';

  @override
  String get admin_trainerUpcomingClients => 'العملاء القادمون';

  @override
  String get admin_trainerViewAll => 'عرض الكل';

  @override
  String get admin_trainerNoUpcomingClients => 'لا يوجد عملاء قادمون.';

  @override
  String get admin_trainerMainDashboard => 'لوحة التحكم';

  @override
  String get admin_trainerMainSessions => 'الجلسات';

  @override
  String get admin_trainerMainPackages => 'الباقات';

  @override
  String get admin_trainerMainSchedule => 'الجدول';

  @override
  String get admin_trainerMainMore => 'المزيد';

  @override
  String get admin_trainerLoading => 'جارٍ تحميل المدربين…';

  @override
  String get admin_packagesTitle => 'الباقات';

  @override
  String get admin_packagesNew => 'باقة جديدة';

  @override
  String get admin_packagesActive => 'نشطة';

  @override
  String get admin_packagesSessions => 'جلسات';

  @override
  String get admin_packagesDaysWeek => 'أيام/أسبوع';

  @override
  String get admin_packagesDays => 'أيام';

  @override
  String get admin_packagesEditTitle => 'تعديل الباقة';

  @override
  String get admin_packagesCreateTitle => 'إنشاء باقة PT';

  @override
  String get admin_packagesBack => 'رجوع';

  @override
  String get admin_packagesCreate => 'إنشاء الباقة';

  @override
  String get admin_packagesContinue => 'متابعة';

  @override
  String get admin_packagesBasicInfo => 'معلومات\nأساسية';

  @override
  String get admin_packagesTrainingRules => 'قواعد\nالتدريب';

  @override
  String get admin_packagesPricing => 'التسعير';

  @override
  String get admin_packagesPreview => 'معاينة';

  @override
  String get admin_packagesName => 'اسم الباقة';

  @override
  String get admin_packagesType => 'نوع الباقة';

  @override
  String get admin_packagesSelectType => 'اختر النوع';

  @override
  String get admin_packagesWeightLoss => 'إنقاص الوزن';

  @override
  String get admin_packagesStrength => 'بناء القوة';

  @override
  String get admin_packagesCardio => 'كارديو';

  @override
  String get admin_packagesGeneral => 'اللياقة العامة';

  @override
  String get admin_packagesLinkedService => 'خدمة PT المرتبطة';

  @override
  String get admin_packagesSelectService => 'اختر الخدمة';

  @override
  String get admin_packagesPersonalTraining => 'التدريب الشخصي';

  @override
  String get admin_packagesStrengthTraining => 'تدريب القوة';

  @override
  String get admin_packagesWeightLossProgram => 'برنامج إنقاص الوزن';

  @override
  String get admin_packagesTotalSessions => 'إجمالي الجلسات';

  @override
  String get admin_packagesMinDays => 'الحد الأدنى للأيام/أسبوع';

  @override
  String get admin_packagesMaxDays => 'الحد الأقصى للأيام/أسبوع';

  @override
  String get admin_packagesValidity => 'الصلاحية (بالأيام)';

  @override
  String get admin_packagesRegularPrice => 'السعر الاعتيادي (\$)';

  @override
  String get admin_packagesSalePrice => 'سعر العرض (\$) - اختياري';

  @override
  String get admin_packagesSummary => 'ملخص الباقة';

  @override
  String get admin_packagesNameLabel => 'الاسم:';

  @override
  String get admin_packagesSessionsLabel => 'الجلسات:';

  @override
  String get admin_packagesFrequency => 'التكرار:';

  @override
  String get admin_packagesValidityLabel => 'الصلاحية:';

  @override
  String get admin_packagesNaDays => 'غير محدد';

  @override
  String get admin_packagesPriceLabel => 'السعر:';

  @override
  String get admin_sessionsTitle => 'الجلسات';

  @override
  String get admin_sessionsBook => 'حجز جلسة';

  @override
  String get admin_sessionCancelled => 'تم إلغاء الجلسة.';

  @override
  String get admin_sessionNoShow => 'تم تسجيل الجلسة كغياب.';

  @override
  String get admin_sessionUpdated => 'تم تحديث الجلسة.';

  @override
  String get admin_sessionFilterToday => 'اليوم';

  @override
  String get admin_sessionFilterUpcoming => 'القادمة';

  @override
  String get admin_sessionFilterCompleted => 'المكتملة';

  @override
  String get admin_sessionNoSessionsToday => 'لا توجد جلسات مجدولة اليوم.';

  @override
  String get admin_sessionNoUpcoming => 'لا توجد جلسات قادمة.';

  @override
  String get admin_sessionNoCompleted => 'لا توجد جلسات مكتملة بعد.';

  @override
  String get admin_sessionRetry => 'إعادة المحاولة';

  @override
  String get admin_sessionCardPt => 'جلسة PT';

  @override
  String get admin_sessionCardComplete => 'إتمام';

  @override
  String get admin_sessionCardCancel => 'إلغاء';

  @override
  String get admin_sessionCardCancelTitle => 'إلغاء الجلسة';

  @override
  String get admin_sessionCardCancelConfirm => 'هل أنت متأكد من إلغاء هذه الجلسة؟';

  @override
  String get admin_sessionCardKeep => 'إبقاء';

  @override
  String get admin_sessionCardProgress => 'تقدم الجلسة';

  @override
  String get admin_scheduleTitle => 'التوفر';

  @override
  String get admin_scheduleAddSlot => 'إضافة موعد';

  @override
  String get admin_scheduleNoAvailability => 'لم يتم تحديد توفر بعد.';

  @override
  String get admin_scheduleMonday => 'الإثنين';

  @override
  String get admin_scheduleTuesday => 'الثلاثاء';

  @override
  String get admin_scheduleWednesday => 'الأربعاء';

  @override
  String get admin_scheduleThursday => 'الخميس';

  @override
  String get admin_scheduleFriday => 'الجمعة';

  @override
  String get admin_scheduleSaturday => 'السبت';

  @override
  String get admin_scheduleSunday => 'الأحد';

  @override
  String get admin_scheduleRecurring => 'أسبوعي متكرر';

  @override
  String get admin_scheduleAddAvailability => 'إضافة توفر';

  @override
  String get admin_scheduleDayOfWeek => 'يوم الأسبوع';

  @override
  String get admin_scheduleSelectDay => 'اختر اليوم';

  @override
  String get admin_scheduleStartTime => 'وقت البداية';

  @override
  String get admin_scheduleEndTime => 'وقت النهاية';

  @override
  String get admin_scheduleRecurringWeekly => 'تكرار أسبوعي';

  @override
  String get admin_scheduleRepeatHint => 'تكرار هذا الموعد كل أسبوع';

  @override
  String get admin_scheduleCancel => 'إلغاء';

  @override
  String get admin_servicesTitle => 'الخدمات';

  @override
  String get admin_servicesNew => 'خدمة جديدة';

  @override
  String get admin_servicesGeneral => 'عامة';

  @override
  String get admin_servicesSpecialized => 'متخصصة';

  @override
  String get admin_servicesElite => 'نخبة';

  @override
  String get admin_servicesActive => 'نشطة';

  @override
  String get admin_servicesEditTitle => 'تعديل الخدمة';

  @override
  String get admin_servicesCreateTitle => 'إنشاء خدمة PT';

  @override
  String get admin_servicesName => 'اسم الخدمة';

  @override
  String get admin_servicesCategory => 'الفئة';

  @override
  String get admin_servicesDuration => 'المدة (دقيقة)';

  @override
  String get admin_servicesPrice => 'السعر (\$)';

  @override
  String get admin_servicesDescription => 'الوصف';

  @override
  String get admin_servicesDescHint => 'صف الخدمة...';

  @override
  String get admin_servicesCancel => 'إلغاء';

  @override
  String get admin_servicesCreate => 'إنشاء الخدمة';

  @override
  String get admin_bookSessionTitle => 'حجز جلسة';

  @override
  String get admin_bookSelectTime => 'يرجى تحديد وقت البداية والنهاية.';

  @override
  String get admin_bookInvalidMember => 'معرف العضو غير صالح.';

  @override
  String get admin_bookMemberId => 'معرف العضو';

  @override
  String get admin_bookMemberIdHint => 'أدخل معرفاً صحيحاً للعضو';

  @override
  String get admin_bookServiceId => 'معرف الخدمة (اختياري)';

  @override
  String get admin_bookStartTime => 'وقت البداية';

  @override
  String get admin_bookEndTime => 'وقت النهاية';

  @override
  String get admin_bookNotes => 'ملاحظات (اختياري)';

  @override
  String get admin_settingsTitle => 'الإعدادات';

  @override
  String get admin_settingsUnsaved => 'غير محفوظ';

  @override
  String get admin_settingsSearch => 'البحث في الإعدادات...';

  @override
  String get admin_settingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get admin_settingsSaveFailed => 'فشل حفظ الإعدادات';

  @override
  String get admin_settingsSaving => 'جارٍ الحفظ...';

  @override
  String get admin_settingsSave => 'حفظ التغييرات';

  @override
  String get admin_settingsLegal => 'القانونية والسياسات';

  @override
  String get admin_settingsLegalReview => 'راجع سياساتنا';

  @override
  String get admin_settingsAccountSecurity => 'الحساب والأمان';

  @override
  String get admin_settingsAccountSecuritySub => 'إدارة أمان حسابك';

  @override
  String get admin_settingsChangePassword => 'تغيير كلمة المرور';

  @override
  String get admin_settingsChangePasswordSub => 'تحديث كلمة مرور حسابك';

  @override
  String get admin_settingsBiometric => 'تسجيل الدخول بالبيومترية';

  @override
  String get admin_settingsBiometricSub => 'استخدم بصمة الإصبع أو التعرف على الوجه';

  @override
  String get admin_settings2fa => 'المصادقة الثنائية';

  @override
  String get admin_settings2faSub => 'أضف طبقة أمان إضافية';

  @override
  String get admin_settingsBusinessRules => 'قواعد العمل';

  @override
  String get admin_settingsAdminOnly => 'للمدير فقط';

  @override
  String get admin_settingsBusinessRulesSub => 'ضبط منطق العضوية والفصول';

  @override
  String get admin_settingsSubscriptionRules => 'قواعد الاشتراك';

  @override
  String get admin_settingsRule1Title => 'السماح بالاشتراك في الفصول بدون عضوية';

  @override
  String get admin_settingsRule1Sub => 'يمكن للمستخدمين الانضمام إلى الفصول بدون شراء خطة';

  @override
  String get admin_settingsRule2Title => 'اشتراط العضوية للاشتراك في الفصول';

  @override
  String get admin_settingsRule2Sub => 'يجب أن يكون للمستخدمين عضوية نشطة للاشتراك في الفصول';

  @override
  String get admin_settingsRule3Title => 'السماح بالعضوية بدون الانتساب لفصل';

  @override
  String get admin_settingsRule3Sub => 'يمكن للأعضاء شراء خطط بدون الانتساب لأي فصل';

  @override
  String get admin_settingsRule4Title => 'السماح بكليهما باستقلالية';

  @override
  String get admin_settingsRule4Sub => 'يمكن شراء العضويات والفصول بشكل منفصل';

  @override
  String get admin_settingsOwnerOnly => 'المالك فقط يمكنه تغيير قواعد العمل';

  @override
  String get admin_settingsDangerZone => 'المنطقة الخطرة';

  @override
  String get admin_settingsDangerSub => 'إجراءات لا رجعة فيها';

  @override
  String get admin_settingsLogOut => 'تسجيل الخروج';

  @override
  String get admin_settingsDeleteAccount => 'حذف الحساب';

  @override
  String get admin_settingsLogOutTitle => 'تسجيل الخروج';

  @override
  String get admin_settingsLogOutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get admin_settingsCancel => 'إلغاء';

  @override
  String get admin_settingsDeleteTitle => 'حذف الحساب';

  @override
  String get admin_settingsDeleteMsg1 => 'سيؤدي هذا إلى حذف حسابك نهائياً. ';

  @override
  String get admin_settingsDeleteMsg2 => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String admin_settingsDeleteFailed(String error) {
    return 'فشل حذف الحساب: $error';
  }

  @override
  String get admin_staffTitle => 'الموظفون';

  @override
  String get admin_staffRetry => 'إعادة المحاولة';

  @override
  String get admin_staffNoFound => 'لم يتم العثور على موظفين.';

  @override
  String get admin_staffAdded => 'تمت إضافة الموظف بنجاح';

  @override
  String get admin_staffUpdated => 'تم تحديث بيانات الموظف بنجاح';

  @override
  String get admin_staffRemoved => 'تمت إزالة الموظف بنجاح';

  @override
  String get admin_staffDone => 'تمت العملية بنجاح';

  @override
  String get admin_staffReception => 'استقبال';

  @override
  String get admin_staffAdmin => 'مدير';

  @override
  String get admin_staffAssistant => 'مساعد';

  @override
  String get admin_staffEditTitle => 'تعديل بيانات الموظف';

  @override
  String get admin_staffAddTitle => 'إضافة موظف جديد';

  @override
  String get admin_staffAddDesc => 'أدخل البيانات لإضافة موظف استقبال\nجديد إلى صالتك';

  @override
  String get admin_staffPersonalInfo => 'المعلومات الشخصية';

  @override
  String get admin_staffFullName => 'الاسم الكامل';

  @override
  String get admin_staffFullNameHint => 'أدخل الاسم الكامل';

  @override
  String get admin_staffFullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get admin_staffEmail => 'البريد الإلكتروني';

  @override
  String get admin_staffEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get admin_staffEmailInvalid => 'أدخل عنوان بريد إلكتروني صحيحاً';

  @override
  String get admin_staffPhone => 'رقم الهاتف';

  @override
  String get admin_staffPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get admin_staffRole => 'الدور';

  @override
  String get admin_staffSelectRole => 'اختر الدور';

  @override
  String get admin_staffRoleRequired => 'الدور مطلوب';

  @override
  String get admin_staffBranchAssignment => 'تعيين الفرع';

  @override
  String get admin_staffSelectBranch => 'اختر الفرع';

  @override
  String get admin_staffBranchRequired => 'الفرع مطلوب';

  @override
  String get admin_staffPassword => 'كلمة المرور';

  @override
  String get admin_staffPasswordHint => 'توليد تلقائي أو إدخال يدوي';

  @override
  String get admin_staffPasswordNote => 'اتركه فارغاً لتوليد كلمة مرور آمنة تلقائياً';

  @override
  String get admin_staffCancel => 'إلغاء';

  @override
  String get admin_staffSaveChanges => 'حفظ التغييرات';

  @override
  String get admin_staffAddMember => 'إضافة موظف';

  @override
  String get admin_staffEditProfile => 'تعديل الملف الشخصي';

  @override
  String get admin_staffRemove => 'إزالة';

  @override
  String get admin_staffRemoveTitle => 'إزالة الموظف';

  @override
  String admin_staffRemoveConfirm(String name) {
    return 'هل أنت متأكد من إزالة $name? ';
  }

  @override
  String get admin_staffCannotUndo => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get admin_staffTotalLabel => 'إجمالي الموظفين';

  @override
  String get admin_staffActiveLabel => 'نشطون';

  @override
  String get admin_staffSearchHint => 'البحث عن موظف بالاسم';

  @override
  String get admin_trainersTitle => 'المدربون / PT';

  @override
  String get admin_trainersLoading => 'جارٍ تحميل بيانات المدربين...';

  @override
  String get admin_trainersFormNotReady => 'خيارات نموذج المدرب غير جاهزة بعد';

  @override
  String get admin_trainersNoFound => 'لم يتم العثور على مدربين';

  @override
  String get admin_trainerAdded => 'تمت إضافة المدرب بنجاح ✓';

  @override
  String get admin_trainerUpdatedSuccess => 'تم تحديث المدرب ✓';

  @override
  String get admin_trainerBlockedSuccess => 'تم حظر المدرب';

  @override
  String get admin_trainerUnblockedSuccess => 'تم إلغاء حظر المدرب ✓';

  @override
  String get admin_trainerActionDone => 'تم';

  @override
  String get admin_trainersRetry => 'إعادة المحاولة';

  @override
  String get admin_trainerSelectBranch => 'يرجى اختيار فرع';

  @override
  String get admin_trainerEditTitle => 'تعديل المدرب';

  @override
  String get admin_trainerAddTitle => 'إضافة مدرب جديد';

  @override
  String get admin_trainerFullName => 'الاسم الكامل *';

  @override
  String get admin_trainerFullNameHint => 'أدخل الاسم الكامل';

  @override
  String get admin_trainerRequired => 'مطلوب';

  @override
  String get admin_trainerEmail => 'البريد الإلكتروني';

  @override
  String get admin_trainerEmailInvalid => 'بريد إلكتروني غير صالح';

  @override
  String get admin_trainerPhone => 'رقم الهاتف';

  @override
  String get admin_trainerPassword => 'كلمة المرور *';

  @override
  String get admin_trainerMinChars => '6 أحرف على الأقل';

  @override
  String get admin_trainerSpecialties => 'التخصصات';

  @override
  String get admin_trainerBranchAssignment => 'تعيين الفرع *';

  @override
  String get admin_trainerSelectBranchHint => 'اختر الفرع';

  @override
  String get admin_trainerExperience => 'سنوات الخبرة';

  @override
  String get admin_trainerNotesBio => 'ملاحظات / سيرة ذاتية';

  @override
  String get admin_trainerNotesBioHint => 'سيرة ذاتية أو ملاحظات اختيارية';

  @override
  String get admin_trainerAvailability => 'جدول التوفر';

  @override
  String get admin_trainerAddSlot => 'إضافة موعد';

  @override
  String get admin_trainerNoSlots => 'لا توجد مواعيد توفر بعد.';

  @override
  String get admin_trainerCancel => 'إلغاء';

  @override
  String get admin_trainerSaveChanges => 'حفظ التغييرات';

  @override
  String get admin_trainerSave => 'حفظ المدرب';

  @override
  String get admin_trainerSpecialtyHint => 'اكتب تخصصاً واضغط + أو Enter للإضافة';

  @override
  String get admin_trainerUnblockConfirm => 'سيتمكن من تسجيل الدخول مجدداً.';

  @override
  String get admin_trainerBlockConfirm => 'لن يتمكن من تسجيل الدخول.';

  @override
  String get admin_trainerUnblockTitle => 'إلغاء الحظر';

  @override
  String get admin_trainerBlockTitle => 'حظر';

  @override
  String get admin_trainerCancelAction => 'إلغاء';

  @override
  String get admin_trainerBlockedStatus => 'محظور';

  @override
  String get admin_trainerActiveStatus => 'نشط';

  @override
  String get admin_trainerScheduleLabel => 'الجدول';

  @override
  String get admin_trainerEditLabel => 'تعديل';

  @override
  String get admin_trainerSearchHint => 'البحث بالاسم أو التخصص';

  @override
  String get admin_videoNewCategory => 'فئة جديدة';

  @override
  String get admin_videoCategoryName => 'اسم الفئة';

  @override
  String get admin_videoCancel => 'إلغاء';

  @override
  String get admin_videoSelectCategory => 'يرجى اختيار أو إنشاء فئة';

  @override
  String get admin_videoDurationInvalid => 'يجب أن تكون المدة أكبر من صفر';

  @override
  String get admin_videoAdded => 'تمت إضافة الفيديو بنجاح';

  @override
  String admin_videoCategoryCreated(String name) {
    return 'تم إنشاء الفئة \"$name\" وتحديدها';
  }

  @override
  String admin_videoFailed(String message) {
    return 'فشل: $message';
  }

  @override
  String get admin_videoAddTitle => 'إضافة مقطع تدريبي';

  @override
  String get admin_videoTitleField => 'العنوان *';

  @override
  String get admin_videoTitleRequired => 'العنوان مطلوب';

  @override
  String get admin_videoDescriptionField => 'الوصف (اختياري)';

  @override
  String get admin_videoCategoryField => 'الفئة *';

  @override
  String get admin_videoSelectCategoryHint => 'اختر فئة';

  @override
  String get admin_videoSelectCategoryRequired => 'يرجى اختيار فئة';

  @override
  String get admin_videoAddNewCategory => 'إضافة فئة جديدة';

  @override
  String get admin_videoAssignTrainer => 'تعيين إلى مدرب *';

  @override
  String get admin_videoSelectTrainer => 'اختر مدرباً';

  @override
  String get admin_videoTrainerRequired => 'يرجى تعيين مدرب';

  @override
  String get admin_videoPickFromPhone => 'اختيار فيديو من الهاتف';

  @override
  String get admin_videoDurationField => 'المدة *';

  @override
  String get admin_videoMinutes => 'دقائق';

  @override
  String get admin_videoRequired => 'مطلوب';

  @override
  String get admin_videoInvalid => 'غير صالح';

  @override
  String get admin_videoSeconds => 'ثوان';

  @override
  String get admin_videoPublished => 'منشور';

  @override
  String get admin_videoVisibleToMembers => 'مرئي للأعضاء فوراً';

  @override
  String get admin_videoAdd => 'إضافة الفيديو';

  @override
  String get admin_videoListTitle => 'مقاطع التدريب';

  @override
  String get admin_videoRetry => 'إعادة المحاولة';

  @override
  String get admin_videoTotalVideos => 'إجمالي المقاطع';

  @override
  String get admin_videoTotalViews => 'إجمالي المشاهدات';

  @override
  String get admin_videoNoVideos => 'لم يتم العثور على مقاطع.';

  @override
  String get admin_videoAllCategories => 'جميع الفئات';

  @override
  String get admin_videoCategory => 'الفئة';
}
