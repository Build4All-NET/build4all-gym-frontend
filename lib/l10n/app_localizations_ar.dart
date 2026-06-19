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
  String get common_or => 'أو';

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
  String get signup_success => 'تم التسجيل بنجاح. يمكنك الآن تسجيل الدخول.';

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
  String get membershipStatusActive => 'عضوية نشطة';

  @override
  String get membershipStatusFrozen => 'مجمّد';

  @override
  String get membershipStatusExpired => 'منتهي';

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
  String couponAppliedFinalPrice(String price) {
    return '✓ تم تطبيق الكوبون — السعر النهائي: $price \$';
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
  String sessionDetailSeatsRemaining(int count) {
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
  String get sessionDetailMembershipRequired => 'يلزم الاشتراك';

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
  String get navMembershipRequests => 'طلبات الاشتراك';

  @override
  String get navInvoices => 'الفواتير';

  @override
  String get navExpenses => 'المصروفات';

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

  @override
  String get navPtPackageBookings => 'مدفوعات باقات PT';

  @override
  String get ptPkgPayments_cashTab => 'المدفوعات النقدية';

  @override
  String get ptPkgPayments_refundTab => 'طلبات الاسترداد';

  @override
  String get ptPkgPayments_noPendingRefunds => 'لا توجد طلبات استرداد معلقة للباقات';

  @override
  String get ptPkgPayments_noPendingRefundsDesc => 'ستظهر طلبات استرداد باقات PT هنا';

  @override
  String get ptPkgPayments_refundBadge => 'استرداد PT';

  @override
  String get accountProfileUpdateSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get accountStatExercises => 'التمارين';

  @override
  String get accountStatSessions => 'الحصص';

  @override
  String get accountStatAchievements => 'الإنجازات';

  @override
  String get accountMyBookings => 'حجوزاتي';

  @override
  String get accountLoyaltyPoints => 'نقاط الولاء';

  @override
  String get accountReferralTitle => 'كود الإحالة الخاص بك';

  @override
  String get accountReferralSubtitle => 'شارك واحصل على مكافآت';

  @override
  String get accountReferralCodeLabel => 'الكود الخاص بك';

  @override
  String get accountReferralCopied => 'تم نسخ الكود';

  @override
  String get accountReferralShare => 'مشاركة الكود';

  @override
  String get accountPersonalInfo => 'المعلومات الشخصية';

  @override
  String get accountEmail => 'البريد الإلكتروني';

  @override
  String get accountPhone => 'رقم الجوال';

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
  String get appVersion => 'النسخة';

  @override
  String get accountGender => 'الجنس';

  @override
  String get accountGenderMale => 'ذكر';

  @override
  String get accountGenderFemale => 'أنثى';

  @override
  String accountMemberSince(String date) {
    return 'عضو منذ $date';
  }

  @override
  String get accountMyInfo => 'معلوماتي';

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
  String get ptBookSession => 'حجز جلسة';

  @override
  String get ptNoTrainers => 'لا يوجد مدربون متاحون';

  @override
  String get ptBookingChooseDate => 'اختر التاريخ';

  @override
  String get ptBookingChooseTime => 'اختر الوقت';

  @override
  String get ptBookingNoSlotsForDate => 'لا توجد أوقات متاحة لهذا التاريخ.';

  @override
  String get ptDetailSession => 'جلسة';

  @override
  String get ptTrainingVideosTitle => 'فيديوهات تدريبية';

  @override
  String get ptTrainingVideosEmpty => 'لا توجد فيديوهات تدريبية بعد.';

  @override
  String get ptTrainingVideosMissingUrl => 'رابط الفيديو غير موجود.';

  @override
  String get ptTrainingVideosOpenError => 'تعذر فتح هذا الفيديو.';

  @override
  String get ptTrainerDetailsNotFound => 'لم يتم العثور على تفاصيل المدرب.';

  @override
  String get ptFavoriteUpdateFailed => 'تعذر تحديث المفضلة.';

  @override
  String get ptConfirmBooking => 'تأكيد الحجز';

  @override
  String ptBookingSelected(String date, String time) {
    return 'تم اختيار الحجز: $date الساعة $time';
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
  String get ptPackageNoPackages => 'لا توجد باقات متاحة حالياً';

  @override
  String get ptPackageSessions => 'جلسات';

  @override
  String get ptPackageDays => 'أيام';

  @override
  String get ptPackageFinalPrice => 'السعر النهائي';

  @override
  String get ptPackageOriginalPrice => 'السعر الأصلي';

  @override
  String get ptPackageSalePrice => 'سعر الخصم';

  @override
  String get ptPackageSelectedPackage => 'الباقة المختارة';

  @override
  String get ptPackageSelectedDays => 'الأيام المختارة';

  @override
  String get ptPackageSelectedTime => 'الوقت المختار';

  @override
  String get ptPackageMaxSessionsReached => 'لا يمكنك اختيار أيام أكثر من عدد جلسات الباقة';

  @override
  String ptPackageDaysPerWeekRange(int min, int max) {
    return 'اختر من $min إلى $max أيام في الأسبوع';
  }

  @override
  String ptPackageDaysPerWeekExact(int count) {
    return 'اختر $count يوم في الأسبوع';
  }

  @override
  String ptPackageMaxDaysReached(int max) {
    return 'لا يمكنك اختيار أكثر من $max أيام في الأسبوع';
  }

  @override
  String get ptPackageNoAvailableSlots => 'لا توجد أوقات متاحة';

  @override
  String get ptWeeklySlotsFailed => 'تعذر تحميل الأوقات المتاحة';

  @override
  String get ptRequestTimePickerHint => 'اطلب وقتاً من المدرب';

  @override
  String get ptTimeRequestSuccess => 'تم إرسال طلب الوقت إلى المدرب.';

  @override
  String get ptTimeRequestFailed => 'تعذر إرسال طلب الوقت. يرجى المحاولة مجدداً.';

  @override
  String get ptBookingRequestSuccess => 'تم إرسال الطلب إلى المدرب. بانتظار الموافقة.';

  @override
  String get ptBookingRequestThisTime => 'طلب هذا الوقت';

  @override
  String get ptBookingBookSession => 'حجز الجلسة';

  @override
  String get ptBookingRequestNote => 'طلب العضو وقت تدريب غير متاح أو ممتلئ';

  @override
  String get ptBookingFullOrUnavailable => 'هذا الوقت ممتلئ أو غير متاح. أرسل طلبًا بدلًا من الحجز المباشر.';

  @override
  String get ptBookingFailed => 'تعذر تأكيد الحجز.';

  @override
  String get ptBookingRequestFailed => 'تعذر إرسال الطلب.';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfileSubtitle => 'قم بتحديث معلوماتك الشخصية';

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
  String get editProfileRequired => 'هذا الحقل مطلوب.';

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
  String get editProfilePasswordSameAsCurrent => 'يجب أن تكون كلمة المرور الجديدة مختلفة عن الحالية.';

  @override
  String get editProfileInvalidOwnerProject => 'معرّف التطبيق غير صالح.';

  @override
  String get editProfileEmailVerified => 'تم تأكيد البريد الإلكتروني بنجاح.';

  @override
  String get editProfilePasswordUpdated => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get editProfileOnlyLetters => 'يسمح فقط بالأحرف والمسافات.';

  @override
  String get editProfileVerifyNewEmail => 'تأكيد البريد الإلكتروني الجديد';

  @override
  String get editProfileVerifyPasswordChange => 'تأكيد تغيير كلمة المرور';

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
  String get memberQrTitle => 'رمز الدخول';

  @override
  String get memberQrSubtitle => 'امسح الرمز عند الدخول للنادي';

  @override
  String get memberQrActiveMembership => 'عضوية نشطة';

  @override
  String get memberQrInactiveMembership => 'عضوية غير نشطة';

  @override
  String get memberQrMemberCodeLabel => 'رقم العضوية';

  @override
  String get memberQrPackageFallback => 'لا توجد باقة';

  @override
  String get memberQrValidUntil => 'صالح حتى';

  @override
  String get memberQrExpiresSoon => 'سينتهي الرمز قريباً';

  @override
  String get memberQrRecentVisits => 'آخر الزيارات';

  @override
  String get memberQrNoRecentVisits => 'لا توجد زيارات سابقة';

  @override
  String get memberQrDurationLabel => 'المدة';

  @override
  String get memberQrToday => 'اليوم';

  @override
  String get memberQrYesterday => 'أمس';

  @override
  String memberQrMinute(int count) {
    return '$count دقيقة';
  }

  @override
  String memberQrHour(String count) {
    return '$count ساعة';
  }

  @override
  String get memberQrLoadError => 'تعذر تحميل رمز الدخول';

  @override
  String get memberQrRetry => 'إعادة المحاولة';

  @override
  String get myInfoTitle => 'معلوماتي';

  @override
  String get myInfoSubtitle => 'حدّث معلومات ملفك الرياضي';

  @override
  String get myInfoPreferredBranch => 'الفرع المفضل';

  @override
  String get myInfoSelectBranch => 'اختر الفرع';

  @override
  String get myInfoGender => 'الجنس';

  @override
  String get myInfoGenderMale => 'ذكر';

  @override
  String get myInfoGenderFemale => 'أنثى';

  @override
  String get myInfoGenderOther => 'آخر';

  @override
  String get myInfoGenderPreferNotToSay => 'أفضل عدم الإجابة';

  @override
  String get myInfoAddress => 'العنوان';

  @override
  String get myInfoAddressHint => 'أدخل عنوانك';

  @override
  String get myInfoDateOfBirth => 'تاريخ الميلاد';

  @override
  String get myInfoSelectDateOfBirth => 'اختر تاريخ الميلاد';

  @override
  String get myInfoHeightCm => 'الطول (سم)';

  @override
  String get myInfoWeightKg => 'الوزن (كغ)';

  @override
  String get myInfoEmergencyContactName => 'اسم جهة الاتصال للطوارئ';

  @override
  String get myInfoEmergencyContactPhone => 'رقم جهة الاتصال للطوارئ';

  @override
  String get myInfoFullNameHint => 'الاسم الكامل';

  @override
  String get myInfoPhoneNumberHint => 'رقم الهاتف';

  @override
  String get myInfoSaveChanges => 'حفظ التغييرات';

  @override
  String get myInfoUpdatedSuccessfully => 'تم تحديث معلوماتي بنجاح';

  @override
  String get myInfoLoadError => 'فشل تحميل معلوماتك. حاول مرة أخرى.';

  @override
  String get myInfoSaveError => 'فشل حفظ معلوماتك. حاول مرة أخرى.';

  @override
  String get myInfoRequiredError => 'الفرع المفضل والجنس وتاريخ الميلاد مطلوبة.';

  @override
  String get aiHeroBannerTitle => 'المساعد الذكي';

  @override
  String get aiHeroBannerSubtitle => 'مساعدك الذكي لإدارة النادي';

  @override
  String get aiHeroBannerBody => 'اسأل عن الأعضاء والإيرادات والحضور والأداء وتحليلات الأعمال.';

  @override
  String get aiSuggestedQuestionsHeader => 'الأسئلة المقترحة';

  @override
  String get aiAppBarTitle => 'المساعد الذكي';

  @override
  String get aiNewConversationTooltip => 'محادثة جديدة';

  @override
  String get aiInputHint => 'اسأل أي شيء عن النادي...';

  @override
  String get aiRetryButton => 'إعادة المحاولة';

  @override
  String get aiFollowUpHeader => 'أسئلة متابعة مقترحة';

  @override
  String get aiRecentQueriesHeader => 'الاستفسارات الأخيرة';

  @override
  String get aiRecentQueryViewLabel => 'عرض';

  @override
  String get aiErrorOffline => 'تعذر الحصول على رد. يرجى المحاولة مرة أخرى.';

  @override
  String get checkins_title => 'تسجيلات الدخول';

  @override
  String get checkins_scanQr => 'مسح رمز QR';

  @override
  String get checkins_scanSuccessMsg => 'تم تسجيل دخوله بنجاح';

  @override
  String get checkins_scannerTitle => 'مسح رمز العضو';

  @override
  String get checkins_activeNow => 'النشطون الآن';

  @override
  String get checkins_totalToday => 'إجمالي اليوم';

  @override
  String get checkins_todayTitle => 'تسجيلات دخول اليوم';

  @override
  String get checkins_noCheckins => 'لا توجد تسجيلات دخول اليوم';

  @override
  String get checkins_searchHint => 'ابحث عن عضو...';

  @override
  String get aiErrorGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get checkins_active => 'نشط';

  @override
  String get checkins_checkedOut => 'تم تسجيل الخروج';

  @override
  String get checkins_out => 'تسجيل خروج';

  @override
  String get checkins_freeze => 'تجميد';

  @override
  String get checkins_block => 'حظر';

  @override
  String get checkins_call => 'اتصال';

  @override
  String get checkins_freezeTitle => 'تجميد الاشتراك';

  @override
  String get checkins_fromDate => 'من تاريخ';

  @override
  String get checkins_toDate => 'إلى تاريخ';

  @override
  String get checkins_reasonHint => 'أدخل السبب...';

  @override
  String get checkins_confirm => 'تأكيد';

  @override
  String get checkins_blockTitle => 'حظر العضو';

  @override
  String get checkins_cancel => 'إلغاء';

  @override
  String get checkins_blockConfirm => 'حظر';

  @override
  String get sessionDetailBookingClosed => 'انتهى وقت الحجز';

  @override
  String get booked => 'محجوز';

  @override
  String get noActiveMembership => 'لا توجد عضوية نشطة';

  @override
  String get membershipStatusCancelled => 'الغاء';

  @override
  String get editProfileVerifyNewPhone => 'تحقق من رقم الهاتف الجديد';

  @override
  String get editProfilePhoneVerified => 'تم التحقق من رقم الهاتف بنجاح';

  @override
  String get memberBookingsTitle => 'حجوزاتي';

  @override
  String get memberBookingsSubtitle => 'حصصك وجلسات التدريب الشخصية';

  @override
  String get memberBookingsUpcomingTab => 'الحصص القادمة';

  @override
  String get memberBookingsPreviousTab => 'الحصص السابقة';

  @override
  String get memberBookingsEmptyUpcoming => 'لا توجد حجوزات قادمة';

  @override
  String get memberBookingsEmptyPrevious => 'لا توجد حجوزات سابقة';

  @override
  String get memberBookingsLoadFailed => 'تعذر تحميل الحجوزات';

  @override
  String get memberBookingsCancelRequestSent => 'تم إرسال طلب الإلغاء';

  @override
  String get memberBookingsCancelRequestFailed => 'تعذر إرسال طلب الإلغاء';

  @override
  String get memberBookingsCancelButton => 'إلغاء الحجز';

  @override
  String get memberBookingsReviewButton => 'قيّم الحصة';

  @override
  String get memberBookingsCancelPending => 'طلب الإلغاء قيد المراجعة';

  @override
  String get memberBookingsClassDefaultTitle => 'حصة تدريبية';

  @override
  String get memberBookingsPtDefaultTitle => 'جلسة تدريب شخصية';

  @override
  String memberBookingsSessionProgress(int current, int total) {
    return 'الجلسة $current من $total';
  }

  @override
  String get bookingStatusConfirmed => 'مؤكد';

  @override
  String get bookingStatusWaitlisted => 'قائمة الانتظار';

  @override
  String get bookingStatusPending => 'قيد المراجعة';

  @override
  String get bookingStatusCancelRequested => 'طلب الإلغاء قيد المراجعة';

  @override
  String get bookingStatusCancelled => 'ملغاة';

  @override
  String get bookingStatusCompleted => 'مكتمل';

  @override
  String get bookingStatusUnknown => 'غير معروف';

  @override
  String memberBookingsMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get memberBookingsRatingTitle => 'رأيك يهمنا';

  @override
  String get memberBookingsRatingLabelLow => 'سيئة';

  @override
  String get memberBookingsRatingLabelHigh => 'ممتازة';

  @override
  String get memberBookingsRateNowButton => 'قيّم الآن';

  @override
  String get memberBookingsReviewSubmitted => 'شكراً على تقييمك!';

  @override
  String get memberBookingsReviewFailed => 'فشل إرسال التقييم. حاول مجدداً.';

  @override
  String get memberBookingsCancelOptionsTitle => 'خيارات الجلسة';

  @override
  String get memberBookingsCancelOnlyOption => 'إلغاء الجلسة';

  @override
  String get memberBookingsCancelOnlyDesc => 'إلغاء هذه الجلسة دون إعادة الجدولة';

  @override
  String get memberBookingsRescheduleOption => 'طلب إعادة الجدولة';

  @override
  String get memberBookingsRescheduleDesc => 'إلغاء واقتراح تاريخ جديد';

  @override
  String get memberBookingsSelectNewDate => 'اختر التاريخ المفضل';

  @override
  String get memberBookingsRescheduleRequestSent => 'تم إرسال طلب إعادة الجدولة';

  @override
  String get memberInvoicesTitle => 'سجل المدفوعات';

  @override
  String get memberInvoicesEmptyTitle => 'لا توجد مدفوعات';

  @override
  String get memberInvoicesEmptySubtitle => 'ستظهر دفعاتك المكتملة هنا.';

  @override
  String get memberInvoicesRetry => 'إعادة المحاولة';

  @override
  String get memberInvoicesAll => 'الكل';

  @override
  String get memberInvoicesAllTypes => 'كل الأنواع';

  @override
  String get memberInvoicesStatusPaid => 'مدفوع';

  @override
  String get memberInvoicesStatusPending => 'معلّق';

  @override
  String get memberInvoicesStatusRefunded => 'مسترجع';

  @override
  String get memberInvoicesStatusCancelled => 'ملغي';

  @override
  String get memberInvoicesStatusRejected => 'مرفوض';

  @override
  String get memberInvoicesStatusFailed => 'فشل';

  @override
  String get memberInvoicesStatusUnknown => 'غير معروف';

  @override
  String get memberInvoicesTypePlans => 'اشتراكات';

  @override
  String get memberInvoicesTypeClasses => 'حصص';

  @override
  String get memberInvoicesTypePt => 'مدرب خاص';

  @override
  String get memberInvoicesTypePtPackage => 'باقة تدريب';

  @override
  String get memberInvoicesTypeDailyPass => 'دخول يومي';

  @override
  String get memberInvoicesTypeOther => 'أخرى';

  @override
  String get memberInvoicesDetails => 'عرض التفاصيل';

  @override
  String get memberInvoicesRefund => 'استرجاع المبلغ';

  @override
  String get memberInvoicesRefundTitle => 'طلب استرجاع';

  @override
  String get memberInvoicesRefundMessage => 'سيتم إرسال طلب استرجاع إلى الإدارة. لن يتم استرجاع المبلغ مباشرة.';

  @override
  String get memberInvoicesRefundReason => 'سبب الاسترجاع اختياري';

  @override
  String get memberInvoicesRefundSend => 'إرسال الطلب';

  @override
  String get memberInvoicesRefundStatus => 'طلب الاسترجاع';

  @override
  String get memberInvoicesDate => 'التاريخ';

  @override
  String get memberInvoicesBranch => 'الفرع';

  @override
  String get memberInvoicesPaymentMethod => 'طريقة الدفع';

  @override
  String get memberInvoicesPaid => 'المدفوع';

  @override
  String get memberInvoicesDue => 'المتبقي';

  @override
  String get memberInvoicesPaymentCash => 'نقداً';

  @override
  String get memberInvoicesPaymentCard => 'بطاقة';

  @override
  String get memberInvoicesPaymentStripe => 'Stripe';

  @override
  String get memberInvoicesPaymentBankTransfer => 'تحويل مصرفي';

  @override
  String get memberInvoicesPaymentWallet => 'محفظة';

  @override
  String get memberInvoicesPaymentOther => 'أخرى';

  @override
  String get memberInvoiceDetailsTitle => 'تفاصيل الفاتورة';

  @override
  String get memberInvoiceItems => 'العناصر';

  @override
  String get memberInvoicePayments => 'الدفعات';

  @override
  String get memberInvoiceSubtotal => 'المجموع الفرعي';

  @override
  String get memberInvoiceDiscount => 'الخصم';

  @override
  String get memberInvoiceTax => 'الضريبة';

  @override
  String get memberInvoiceTotal => 'المجموع';

  @override
  String get memberInvoiceInvoiceNumber => 'رقم الفاتورة';

  @override
  String get memberInvoiceBranchAddress => 'عنوان الفرع';

  @override
  String get memberInvoiceBranchPhone => 'هاتف الفرع';

  @override
  String get memberInvoiceQty => 'الكمية';

  @override
  String get memberInvoiceUnitPrice => 'سعر الوحدة';

  @override
  String get memberInvoicesStatus => 'الحالة';

  @override
  String get memberInvoicesType => 'النوع';

  @override
  String get memberInvoiceDownloadPdf => 'Download / Share PDF';

  @override
  String get memberInvoicePdfTitle => 'Invoice';

  @override
  String get memberInvoicePdfFooter => 'Thank you';

  @override
  String get memberInvoiceDescription => 'Description';

  @override
  String get admin_dashboard_allBranches => 'جميع الفروع';

  @override
  String get admin_dashboard_timePeriod => 'الفترة الزمنية';

  @override
  String get admin_dashboard_today => 'اليوم';

  @override
  String get admin_dashboard_thisWeek => 'هذا الأسبوع';

  @override
  String get admin_dashboard_thisMonth => 'هذا الشهر';

  @override
  String get admin_dashboard_custom => 'مخصص';

  @override
  String get admin_dashboard_tabMembership => 'العضوية';

  @override
  String get admin_dashboard_tabPayments => 'المدفوعات';

  @override
  String get admin_dashboard_tabAttendance => 'الحضور';

  @override
  String get admin_dashboard_cardHint => 'اضغط على البطاقة لمزيد من المعلومات.';

  @override
  String get admin_dashboard_comingSoon => 'قريباً';

  @override
  String get admin_dashboard_lastMonth => 'الشهر الماضي';

  @override
  String get admin_dashboard_last3Months => 'آخر 3 أشهر';

  @override
  String get admin_dashboard_sectionToday => 'اليوم';

  @override
  String get admin_dashboard_sectionAttendance => 'الحضور';

  @override
  String get admin_dashboard_sectionMembershipExpiry => 'انتهاء العضوية';

  @override
  String get admin_dashboard_sectionPtPlanExpiry => 'انتهاء خطة التدريب';

  @override
  String get admin_dashboard_sectionTodaysCollection => 'تحصيل اليوم';

  @override
  String get admin_dashboard_birthdays => 'أعياد الميلاد';

  @override
  String get admin_dashboard_expiresToday => 'تنتهي اليوم';

  @override
  String get admin_dashboard_ptExpiringToday => 'خطة تدريب تنتهي اليوم';

  @override
  String get admin_dashboard_monthlyCheckins => 'تسجيلات الدخول الشهرية';

  @override
  String get admin_dashboard_uniqueMembersAttended => 'أعضاء فريدون حضروا';

  @override
  String get admin_dashboard_expiring1to3 => 'تنتهي (1–3 أيام)';

  @override
  String get admin_dashboard_expiring4to7 => 'تنتهي (4–7 أيام)';

  @override
  String get admin_dashboard_expiring8to15 => 'تنتهي (8–15 يوم)';

  @override
  String get admin_dashboard_ptExpiring1to7 => 'تدريب ينتهي (1–7 أيام)';

  @override
  String get admin_dashboard_ptExpiring8to15 => 'تدريب ينتهي (8–15 يوم)';

  @override
  String get admin_dashboard_recordAttendance => 'تسجيل الحضور';

  @override
  String get admin_dashboard_membershipCollectedToday => 'اشتراكات محصّلة اليوم';

  @override
  String get admin_dashboard_admissionFees => 'رسوم التسجيل';

  @override
  String get admin_dashboard_membershipCollected => 'اشتراكات محصّلة';

  @override
  String get admin_dashboard_membershipDue => 'اشتراكات مستحقة';

  @override
  String get admin_dashboard_ptDue => 'تدريب مستحق';

  @override
  String get admin_dashboard_servicePaid => 'خدمات مدفوعة';

  @override
  String get admin_dashboard_serviceDue => 'خدمات مستحقة';

  @override
  String get admin_dashboard_expense => 'المصاريف';

  @override
  String get admin_dashboard_upcomingPtSessions => 'جلسات تدريب قادمة';

  @override
  String get admin_dashboard_attendanceGrowth => 'نمو الحضور';

  @override
  String get admin_dashboard_absentMembers => 'أعضاء غائبون';

  @override
  String get admin_dashboard_activeMembers => 'الأعضاء النشطون';

  @override
  String get admin_dashboard_pendingRenewals => 'التجديدات المعلقة';

  @override
  String get admin_dashboard_todayCheckins => 'تسجيلات الدخول اليوم';

  @override
  String get admin_dashboard_upcomingPt => 'جلسات PT القادمة';

  @override
  String get admin_dashboard_dueSoon => 'مستحق قريباً';

  @override
  String get admin_dashboard_liveNow => 'مباشر الآن';

  @override
  String get admin_dashboard_sessions => 'الجلسات';

  @override
  String get admin_dashboard_attendance => 'الحضور';

  @override
  String get admin_dashboard_paymentsCollected => 'المدفوعات المحصلة';

  @override
  String get admin_dashboard_expiringPlans => 'الخطط المنتهية';

  @override
  String get admin_dashboard_totalMembers => 'إجمالي الأعضاء';

  @override
  String get admin_dashboard_next7Days => 'الأيام السبعة القادمة';

  @override
  String admin_dashboard_activeCount(int count) {
    return '$count نشط';
  }

  @override
  String get admin_dashboard_quickActions => 'الإجراءات السريعة';

  @override
  String get admin_dashboard_recordPayment => 'تسجيل دفعة';

  @override
  String get admin_dashboard_addPlan => 'إضافة خطة';

  @override
  String get admin_dashboard_sendAnnouncement => 'إرسال إشعار';

  @override
  String get admin_dashboard_totalPlans => 'إجمالي الخطط';

  @override
  String get admin_dashboard_canceled => 'ملغى';

  @override
  String get admin_dashboard_churnRate => 'معدل الإلغاء';

  @override
  String get admin_dashboard_monthlyRevenue => 'الإيرادات الشهرية';

  @override
  String get admin_dashboard_last7Days => 'آخر 7 أيام';

  @override
  String get admin_dashboard_recentActivity => 'النشاط الأخير';

  @override
  String get admin_dashboard_viewAll => 'عرض الكل';

  @override
  String get admin_dashboard_noRecentActivity => 'لا يوجد نشاط حديث';

  @override
  String get admin_members_noMembers => 'لا يوجد أعضاء.';

  @override
  String get admin_members_searchHint => 'البحث بالاسم أو الهاتف أو رقم العضو';

  @override
  String get admin_members_filterAllStatus => 'جميع الحالات';

  @override
  String get admin_members_filterInactive => 'غير نشط';

  @override
  String get admin_members_filterBlocked => 'محظور';

  @override
  String get admin_members_sortNewest => 'الأحدث';

  @override
  String get admin_members_sortOldest => 'الأقدم';

  @override
  String get admin_members_sortAlpha => 'أبجدياً';

  @override
  String get admin_members_filterAllGender => 'جميع الأجناس';

  @override
  String get admin_members_colPlan => 'الخطة';

  @override
  String get admin_members_colDueAmount => 'المبلغ المستحق';

  @override
  String get admin_members_colExpiry => 'تاريخ الانتهاء';

  @override
  String get admin_members_colBranch => 'الفرع';

  @override
  String get admin_members_actionWhatsApp => 'واتساب';

  @override
  String get admin_members_actionAttendance => 'الحضور';

  @override
  String get admin_members_actionRenew => 'تجديد';

  @override
  String get admin_members_actionUnblock => 'إلغاء الحظر';

  @override
  String get admin_members_actionBlock => 'حظر';

  @override
  String get admin_members_actionDelete => 'حذف';

  @override
  String get admin_members_actionEdit => 'تعديل';

  @override
  String get admin_members_actionCall => 'اتصال';

  @override
  String get admin_members_actionSms => 'رسالة';

  @override
  String get admin_members_blockTitle => 'حظر العضو';

  @override
  String get admin_members_blockHint => 'أدخل سبب الحظر';

  @override
  String get admin_members_deleteTitle => 'حذف العضو';

  @override
  String admin_members_deleteMessage(String name) {
    return 'حذف $name نهائياً؟ لا يمكن التراجع عن هذا.';
  }

  @override
  String get admin_members_statusNoPlan => 'لا توجد خطة';

  @override
  String get admin_members_statusInactive => 'غير نشط';

  @override
  String get admin_members_detailTitle => 'تفاصيل العضو';

  @override
  String get admin_members_membershipPackageTitle => 'باقة العضوية';

  @override
  String get admin_members_packagePlanName => 'اسم الخطة';

  @override
  String get admin_members_packageTotalAmount => 'المبلغ الإجمالي';

  @override
  String get admin_members_packageDiscount => 'الخصم';

  @override
  String get admin_members_packagePurchaseDate => 'تاريخ الشراء';

  @override
  String get admin_members_packagePaidAmount => 'المبلغ المدفوع';

  @override
  String get admin_members_packageDueAmount => 'المبلغ المستحق';

  @override
  String get admin_members_packageRemainingDays => 'الأيام المتبقية';

  @override
  String admin_members_packageDays(int count) {
    return '$count أيام';
  }

  @override
  String get admin_trainers_removeRoleTitle => 'إزالة دور المدرب';

  @override
  String admin_trainers_removeRoleMessage(String name) {
    return 'سيفقد $name دور المدرب وسيرى لوحة العضو عند الدخول التالي.';
  }

  @override
  String get admin_trainers_remove => 'إزالة';

  @override
  String get admin_trainers_addTrainer => 'إضافة مدرب';

  @override
  String get admin_trainers_loadError => 'لا يمكن تحميل المدربين';

  @override
  String get admin_trainers_emptyTitle => 'لا يوجد مدربون بعد';

  @override
  String get admin_trainers_emptyMessage => 'اضغط على \"إضافة مدرب\" لترقية عضو إلى دور المدرب.';

  @override
  String get admin_trainers_badgeLabel => 'مدرب';

  @override
  String get admin_trainers_removeTooltip => 'إزالة دور المدرب';

  @override
  String get admin_plans_deleteTitle => 'حذف الخطة';

  @override
  String get admin_plans_deleteMessage => 'هل أنت متأكد من حذف هذه الخطة؟';

  @override
  String get admin_plans_delete => 'حذف';

  @override
  String get admin_plans_allTypes => 'جميع الأنواع';

  @override
  String get admin_plans_searchHint => 'البحث عن خطط...';

  @override
  String get admin_plans_noPlans => 'لا توجد خطط';

  @override
  String get admin_plans_editTitle => 'تعديل الخطة';

  @override
  String get admin_plans_addTitle => 'إضافة خطة جديدة';

  @override
  String get admin_plans_createPlan => 'إنشاء خطة';

  @override
  String get admin_expenses_deleteTitle => 'حذف المصروف';

  @override
  String get admin_expenses_deleteMessage => 'هل أنت متأكد أنك تريد حذف هذا المصروف؟';

  @override
  String get admin_expenses_delete => 'حذف';

  @override
  String get admin_expenses_allCategories => 'جميع الفئات';

  @override
  String get admin_expenses_searchHint => 'البحث عن المصروفات...';

  @override
  String get admin_expenses_noExpenses => 'لا توجد مصروفات';

  @override
  String get admin_staff_noStaff => 'لا يوجد موظفون.';

  @override
  String get admin_staff_addedSuccess => 'تمت إضافة الموظف بنجاح';

  @override
  String get admin_staff_updatedSuccess => 'تم تحديث الموظف بنجاح';

  @override
  String get admin_staff_removedSuccess => 'تم إزالة الموظف بنجاح';

  @override
  String get admin_staff_actionCompleted => 'تم تنفيذ الإجراء بنجاح';

  @override
  String get admin_staff_editTitle => 'تعديل الموظف';

  @override
  String get admin_staff_addTitle => 'إضافة موظف جديد';

  @override
  String get admin_staff_fullName => 'الاسم الكامل *';

  @override
  String get admin_staff_email => 'البريد الإلكتروني *';

  @override
  String get admin_staff_phone => 'رقم الهاتف *';

  @override
  String get admin_staff_role => 'الدور *';

  @override
  String get admin_staff_branchAssignment => 'تعيين الفرع *';

  @override
  String get admin_staff_password => 'كلمة المرور';

  @override
  String get admin_staff_saveStaff => 'حفظ الموظف';

  @override
  String get admin_staff_editProfile => 'تعديل الملف الشخصي';

  @override
  String get admin_staff_removeTitle => 'إزالة الموظف';

  @override
  String admin_staff_removeMessage(String name) {
    return 'هل أنت متأكد من إزالة $name؟ لا يمكن التراجع عن هذا.';
  }

  @override
  String get admin_staff_fullNameHint => 'أدخل الاسم الكامل';

  @override
  String get admin_staff_emailHint => 'أدخل البريد الإلكتروني';

  @override
  String get admin_staff_phoneHint => 'أدخل رقم الهاتف';

  @override
  String get admin_staff_selectRole => 'اختر الدور';

  @override
  String get admin_staff_selectBranch => 'اختر الفرع';

  @override
  String get admin_staff_autoGeneratePassword => 'اتركه فارغاً لإنشاء كلمة مرور آمنة تلقائياً';

  @override
  String get admin_settings_unsaved => 'غير محفوظ';

  @override
  String get admin_settings_searchHint => 'البحث في الإعدادات...';

  @override
  String get admin_settings_legalTitle => 'القانونية والسياسات';

  @override
  String get admin_settings_legalSubtitle => 'راجع سياساتنا';

  @override
  String get admin_settings_saveSuccess => 'تم حفظ الإعدادات بنجاح';

  @override
  String get admin_settings_saving => 'جارٍ الحفظ...';

  @override
  String get admin_settings_saveChanges => 'حفظ التغييرات';

  @override
  String get admin_settings_saveFailed => 'فشل في حفظ الإعدادات';

  @override
  String get admin_branches_activeBranches => 'الفروع النشطة';

  @override
  String get admin_branches_totalMembers => 'إجمالي الأعضاء';

  @override
  String get admin_branches_monthlyRevenue => 'الإيرادات الشهرية';

  @override
  String get admin_branches_searchHint => 'البحث باسم الفرع أو الموقع.';

  @override
  String get admin_branches_allStatus => 'جميع الحالات';

  @override
  String get admin_branches_statusActive => 'نشط';

  @override
  String get admin_branches_statusInactive => 'غير نشط';

  @override
  String get admin_branches_noFound => 'لا توجد فروع';

  @override
  String get admin_trainingVideos_deleteSuccess => 'تم حذف الفيديو';

  @override
  String get admin_trainingVideos_totalVideos => 'إجمالي الفيديوهات';

  @override
  String get admin_trainingVideos_totalViews => 'إجمالي المشاهدات';

  @override
  String get admin_trainingVideos_noVideos => 'لا توجد فيديوهات.';

  @override
  String get admin_trainingVideos_allCategories => 'جميع الفئات';

  @override
  String get admin_classes_noClasses => 'لا توجد حصص مجدولة لهذا اليوم';

  @override
  String get admin_classes_reactivateTitle => 'إعادة تفعيل الحصة';

  @override
  String get admin_classes_reactivateMessage => 'استعادة هذه الحصة للجدول؟ سيتمكن الأعضاء من حجزها مجدداً.';

  @override
  String get admin_classes_reactivateConfirm => 'نعم، إعادة التفعيل';

  @override
  String get admin_classes_cancelTitle => 'إلغاء الحصة';

  @override
  String get admin_classes_cancelMessage => 'هل أنت متأكد من إلغاء هذه الحصة؟ سيتم إشعار جميع الأعضاء المحجوزين.';

  @override
  String get admin_classes_keepClass => 'إبقاء الحصة';

  @override
  String get admin_classes_cancelConfirm => 'نعم، إلغاء';

  @override
  String get admin_classes_createdSuccess => 'تم إنشاء الحصة بنجاح';

  @override
  String get admin_classes_updatedSuccess => 'تم تحديث الحصة بنجاح';

  @override
  String get admin_classes_cancelledSuccess => 'تم إلغاء الحصة';

  @override
  String get admin_classes_reactivatedSuccess => 'تم إعادة تفعيل الحصة بنجاح';

  @override
  String get admin_membershipRequests_title => 'طلبات الاشتراك';

  @override
  String get admin_membershipRequests_retry => 'إعادة المحاولة';

  @override
  String get admin_membershipRequests_noPending => 'لا توجد طلبات معلقة';

  @override
  String get admin_membershipRequests_noPendingDesc => 'سيظهر هنا أي طلب دفع نقدي جديد';

  @override
  String get admin_membershipRequests_pendingBadge => 'معلق';

  @override
  String get admin_membershipRequests_plan => 'الخطة';

  @override
  String get admin_membershipRequests_branch => 'الفرع';

  @override
  String get admin_membershipRequests_amount => 'المبلغ';

  @override
  String get admin_membershipRequests_reject => 'رفض';

  @override
  String get admin_membershipRequests_approve => 'موافقة';

  @override
  String get admin_membershipRequests_approveTitle => 'تأكيد استلام الدفع';

  @override
  String get admin_membershipRequests_notesHint => 'ملاحظة (اختياري)';

  @override
  String admin_membershipRequests_approveButton(String amount) {
    return 'موافقة — تم استلام $amount';
  }

  @override
  String admin_membershipRequests_subscriptionInfo(String plan, String amount) {
    return 'الاشتراك: $plan\nالمبلغ:\$ $amount';
  }

  @override
  String get admin_membershipRequests_rejectTitle => 'رفض الطلب';

  @override
  String get admin_membershipRequests_rejectHint => 'سبب الرفض (إلزامي)';

  @override
  String get admin_membershipRequests_rejectButton => 'رفض الطلب';

  @override
  String get admin_membershipRequests_enterReason => 'يرجى إدخال سبب الرفض';

  @override
  String get admin_membershipRequests_tab => 'طلبات الاشتراك';

  @override
  String get admin_refundRequests_tab => 'طلبات الاسترداد';

  @override
  String get admin_refundRequests_noPending => 'لا توجد طلبات استرداد معلقة';

  @override
  String get admin_refundRequests_noPendingDesc => 'ستظهر طلبات استرداد الأعضاء هنا';

  @override
  String get admin_refundRequests_pendingBadge => 'استرداد معلق';

  @override
  String get admin_refundRequests_requestedAmount => 'المبلغ المطلوب';

  @override
  String get admin_refundRequests_reason => 'سبب العضو';

  @override
  String get admin_refundRequests_reject => 'رفض';

  @override
  String get admin_refundRequests_process => 'معالجة';

  @override
  String get admin_refundRequests_processTitle => 'معالجة طلب الاسترداد';

  @override
  String get admin_refundRequests_refundAmount => 'مبلغ الاسترداد';

  @override
  String get admin_refundRequests_refundAmountHint => 'المبلغ المراد استرداده';

  @override
  String get admin_refundRequests_deductionAmount => 'الخصم (رسوم الإلغاء)';

  @override
  String get admin_refundRequests_deductionHint => 'مبلغ الخصم (اختياري)';

  @override
  String get admin_refundRequests_adminNoteHint => 'ملاحظة الإدارة (اختيارية)';

  @override
  String admin_refundRequests_approveButton(String amount) {
    return 'الموافقة على الاسترداد — \$ $amount';
  }

  @override
  String get admin_refundRequests_rejectTitle => 'رفض طلب الاسترداد';

  @override
  String get admin_refundRequests_rejectHint => 'سبب الرفض (مطلوب)';

  @override
  String get admin_refundRequests_rejectButton => 'رفض الطلب';

  @override
  String get admin_refundRequests_enterReason => 'يرجى إدخال سبب الرفض';

  @override
  String get admin_refundRequests_enterAmount => 'يرجى إدخال مبلغ استرداد صحيح';

  @override
  String get membershipStatusPending => 'قيد الانتظار';

  @override
  String get membershipStatusBlocked => 'محظور';

  @override
  String get membershipStatusInactive => 'عضوية غير نشطة';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get genderOther => 'آخر';

  @override
  String get admin_invoices_filterAll => 'الكل';

  @override
  String get admin_invoices_filterPaid => 'مدفوع';

  @override
  String get admin_invoices_filterPending => 'معلق';

  @override
  String get admin_invoices_filterOverdue => 'متأخر';

  @override
  String get admin_invoices_filterCancelled => 'ملغى';

  @override
  String get admin_invoices_typeAll => 'كل الأنواع';

  @override
  String get admin_invoices_typePlans => 'الخطط';

  @override
  String get admin_invoices_typeClasses => 'الدروس';

  @override
  String get admin_invoices_typePt => 'PT';

  @override
  String get admin_invoices_noInvoices => 'لا توجد فواتير';

  @override
  String get admin_invoices_emptyDesc => 'ستظهر الفواتير هنا بعد اكتمال المدفوعات.';

  @override
  String admin_invoices_noFilteredInvoices(String status) {
    return 'لا توجد فواتير $status.';
  }

  @override
  String get admin_invoices_invoiceLabel => 'فاتورة';

  @override
  String get admin_invoices_downloadPdf => 'تنزيل / مشاركة PDF';

  @override
  String get admin_classes_addTitle => 'إضافة درس جديد';

  @override
  String get admin_classes_editTitle => 'تعديل الدرس';

  @override
  String get admin_classes_nameLabel => 'اسم الدرس *';

  @override
  String get admin_classes_typeLabel => 'النوع / النشاط *';

  @override
  String get admin_classes_newTypeButton => 'نوع جديد';

  @override
  String get admin_classes_trainerLabel => 'المدرب *';

  @override
  String get admin_classes_branchLabel => 'الفرع *';

  @override
  String get admin_classes_dateLabel => 'التاريخ *';

  @override
  String get admin_classes_timeLabel => 'الوقت *';

  @override
  String get admin_classes_durationLabel => 'المدة (بالدقائق) *';

  @override
  String get admin_classes_capacityLabel => 'السعة *';

  @override
  String get admin_classes_roomLabel => 'اسم القاعة';

  @override
  String get admin_classes_notesLabel => 'ملاحظات / وصف';

  @override
  String get admin_classes_saveButton => 'حفظ الدرس';

  @override
  String get admin_classes_selectType => 'اختر النوع';

  @override
  String get admin_classes_selectTrainer => 'اختر المدرب';

  @override
  String get admin_classes_selectBranch => 'اختر الفرع';

  @override
  String get admin_classes_newTypeTitle => 'نوع درس جديد';

  @override
  String get admin_classes_failedCreateType => 'فشل في إنشاء نوع الدرس';

  @override
  String get admin_classes_timePast => 'لا يمكن اختيار وقت مضى';

  @override
  String get admin_classes_timeReset => 'الوقت المحدد سابقاً مضى — يرجى إعادة الاختيار';

  @override
  String get admin_classes_selectDateTime => 'يرجى تحديد التاريخ والوقت';

  @override
  String get admin_classes_dateTimePast => 'لا يمكن أن يكون تاريخ ووقت الدرس في الماضي';

  @override
  String get admin_classes_fillRequired => 'يرجى تعبئة جميع الحقول المطلوبة';

  @override
  String get admin_classes_sessionBookingsTitle => 'حجوزات الجلسة';

  @override
  String get admin_classes_paymentConfirmed => 'تم تأكيد الدفع';

  @override
  String get admin_classes_bookingRejected => 'تم رفض الحجز';

  @override
  String get admin_classes_noBookings => 'لا توجد حجوزات بعد';

  @override
  String get admin_classes_noPhone => 'لا يوجد هاتف';

  @override
  String get admin_classes_statusPending => 'معلق';

  @override
  String get admin_classes_statusBooked => 'محجوز';

  @override
  String get admin_classes_rejectBooking => 'رفض';

  @override
  String get admin_classes_confirmPayment => 'تأكيد الدفع';

  @override
  String get admin_classes_statusCancelRequested => 'طلب إلغاء';

  @override
  String get admin_classes_approveCancellation => 'موافقة';

  @override
  String get admin_classes_declineCancellation => 'رفض';

  @override
  String get admin_classes_cancellationApproved => 'تم قبول الإلغاء';

  @override
  String get admin_classes_cancellationDeclined => 'تم رفض الإلغاء';

  @override
  String get admin_settings_accountTitle => 'الحساب والأمان';

  @override
  String get admin_settings_accountSubtitle => 'إدارة أمان حسابك';

  @override
  String get admin_settings_changePassword => 'تغيير كلمة المرور';

  @override
  String get admin_settings_changePasswordSubtitle => 'تحديث كلمة مرور حسابك';

  @override
  String get admin_settings_biometricLogin => 'تسجيل الدخول البيومتري';

  @override
  String get admin_settings_biometricSubtitle => 'استخدام بصمة الإصبع أو التعرف على الوجه';

  @override
  String get admin_settings_twoFactor => 'التحقق الثنائي';

  @override
  String get admin_settings_twoFactorSubtitle => 'إضافة طبقة أمان إضافية';

  @override
  String get admin_settings_businessTitle => 'قواعد العمل';

  @override
  String get admin_settings_adminOnly => 'للمشرف فقط';

  @override
  String get admin_settings_businessSubtitle => 'تهيئة منطق العضوية والدروس';

  @override
  String get admin_settings_subscriptionRules => 'قواعد الاشتراك';

  @override
  String get admin_settings_ownerOnly => 'فقط المالك يمكنه تغيير قواعد العمل';

  @override
  String get admin_settings_allowClassWithoutMembership => 'السماح بالاشتراك في الدروس بدون عضوية';

  @override
  String get admin_settings_allowClassWithoutMembershipDesc => 'يمكن للمستخدمين الانضمام إلى الدروس بدون شراء خطة';

  @override
  String get admin_settings_requireMembershipForClass => 'اشتراط العضوية للاشتراك في الدروس';

  @override
  String get admin_settings_requireMembershipForClassDesc => 'يجب أن يكون لدى المستخدمين عضوية نشطة للاشتراك في الدروس';

  @override
  String get admin_settings_allowMembershipWithoutClass => 'السماح بالعضوية بدون التسجيل في الدروس';

  @override
  String get admin_settings_allowMembershipWithoutClassDesc => 'يمكن للأعضاء شراء الخطط دون التسجيل في أي درس';

  @override
  String get admin_settings_allowBothIndependently => 'السماح بكليهما بشكل مستقل';

  @override
  String get admin_settings_allowBothIndependentlyDesc => 'يمكن شراء العضويات والدروس بشكل منفصل';

  @override
  String get admin_settings_allowPtBookingWithoutMembership => 'السماح بحجز التدريب الشخصي بدون عضوية';

  @override
  String get admin_settings_allowPtBookingWithoutMembershipDesc => 'يمكن للأعضاء حجز جلسات التدريب الشخصي بدون خطة عضوية نشطة';

  @override
  String get admin_settings_dangerTitle => 'المنطقة الخطرة';

  @override
  String get admin_settings_dangerSubtitle => 'إجراءات لا يمكن التراجع عنها';

  @override
  String get admin_settings_logOut => 'تسجيل الخروج';

  @override
  String get admin_settings_deleteAccount => 'حذف الحساب';

  @override
  String get admin_settings_logOutMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get admin_settings_deleteAccountMessage => 'سيتم حذف حسابك نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get admin_settings_delete => 'حذف';

  @override
  String get settings_appearanceTitle => 'المظهر';

  @override
  String get settings_appearanceSubtitle => 'تخصيص تجربتك البصرية';

  @override
  String get settings_lightMode => 'الوضع الفاتح';

  @override
  String get settings_lightModeSubtitle => 'واجهة نظيفة ومضيئة';

  @override
  String get settings_darkMode => 'الوضع الداكن';

  @override
  String get settings_darkModeSubtitle => 'مريح للعيون';

  @override
  String get settings_systemDefault => 'افتراضي النظام';

  @override
  String get settings_systemDefaultSubtitle => 'يطابق إعدادات جهازك';

  @override
  String get trainer_ptDashboardAllTitle => 'لوحة تحكم PT (جميع المدربين)';

  @override
  String get trainer_ptDashboardTitle => 'لوحة تحكم المدرب';

  @override
  String get trainer_todaySessions => 'جلسات اليوم';

  @override
  String get trainer_cancelledNoShow => 'ملغى / لم يحضر';

  @override
  String get trainer_todayScheduleHeader => 'جدول اليوم';

  @override
  String get trainer_noServicesScheduled => 'لا توجد خدمات مجدولة لليوم.';

  @override
  String trainer_byName(String name) {
    return 'بواسطة $name';
  }

  @override
  String get trainer_confirmedBadge => 'مؤكد';

  @override
  String get trainer_createPackage => 'إنشاء باقة';

  @override
  String get trainer_addAvailabilityButton => 'إضافة توفر';

  @override
  String get trainer_addPtService => 'إضافة خدمة PT';

  @override
  String get trainer_createSession => 'إنشاء جلسة';

  @override
  String get trainer_pendingRequests => 'الطلبات المعلقة';

  @override
  String get trainer_noPendingRequests => 'لا توجد طلبات معلقة.';

  @override
  String get trainer_declineButton => 'رفض';

  @override
  String get trainer_acceptButton => 'قبول';

  @override
  String get trainer_upcomingClients => 'العملاء القادمون';

  @override
  String get trainer_noUpcomingClients => 'لا يوجد عملاء قادمون.';

  @override
  String trainer_sessionOfTotal(int current, int total) {
    return 'جلسة $current/$total';
  }

  @override
  String get trainer_servicesAllTitle => 'جميع خدمات PT';

  @override
  String get trainer_servicesMyTitle => 'خدماتي';

  @override
  String get trainer_noPtServicesFound => 'لا توجد خدمات PT.';

  @override
  String get trainer_deleteServiceTitle => 'حذف الخدمة';

  @override
  String trainer_deleteServiceMessage(String name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get trainer_inactiveBadge => 'غير نشط';

  @override
  String get trainer_editService => 'تعديل الخدمة';

  @override
  String get trainer_newPtService => 'خدمة PT جديدة';

  @override
  String get trainer_assignToTrainer => 'تعيين للمدرب';

  @override
  String get trainer_selectTrainerRequired => 'يرجى اختيار مدرب';

  @override
  String get trainer_serviceNameLabel => 'اسم الخدمة';

  @override
  String get trainer_requiredField => 'مطلوب';

  @override
  String get trainer_descriptionOptional => 'الوصف (اختياري)';

  @override
  String get trainer_durationMinutes => 'المدة (بالدقائق)';

  @override
  String get trainer_enterNumber => 'أدخل رقماً';

  @override
  String get trainer_priceLabel => 'السعر';

  @override
  String get trainer_enterPrice => 'أدخل سعراً';

  @override
  String get trainer_activeLabel => 'نشط';

  @override
  String get trainer_inactiveHidden => 'الخدمات غير النشطة مخفية عن الأعضاء';

  @override
  String get trainer_selectTrainerSnackbar => 'يرجى اختيار مدرب.';

  @override
  String get trainer_packagesAllTitle => 'جميع الباقات';

  @override
  String get trainer_packagesMyTitle => 'باقاتي';

  @override
  String get trainer_showDeactivated => 'عرض المعطلة';

  @override
  String get trainer_noPackagesFound => 'لا توجد باقات.';

  @override
  String get trainer_deactivatedPackages => 'الباقات المعطلة';

  @override
  String get trainer_noDeactivatedPackages => 'لا توجد باقات معطلة.';

  @override
  String get trainer_deactivatePackageTitle => 'تعطيل الباقة';

  @override
  String trainer_deactivatePackageMessage(String name) {
    return 'تعطيل \"$name\"؟';
  }

  @override
  String get trainer_deactivateButton => 'تعطيل';

  @override
  String get trainer_reactivatePackageTitle => 'إعادة تفعيل الباقة';

  @override
  String trainer_reactivatePackageMessage(String name) {
    return 'إعادة تفعيل \"$name\"؟ ستصبح مرئية للأعضاء مجدداً.';
  }

  @override
  String get trainer_reactivateButton => 'إعادة تفعيل';

  @override
  String trainer_maxConcurrent(int count) {
    return 'حد أقصى $count متزامن';
  }

  @override
  String get trainer_editPackage => 'تعديل الباقة';

  @override
  String get trainer_newPackage => 'باقة جديدة';

  @override
  String get trainer_packageNameLabel => 'اسم الباقة';

  @override
  String get trainer_packageTypeLabel => 'نوع الباقة *';

  @override
  String get trainer_numberOfSessions => 'عدد الجلسات';

  @override
  String get trainer_sessionDurationMin => 'مدة الجلسة (دقيقة)';

  @override
  String get trainer_daysAvailable => 'الأيام المتاحة (فترة الصلاحية) *';

  @override
  String get trainer_minDaysWeek => 'الحد الأدنى للأيام/الأسبوع';

  @override
  String get trainer_maxDaysWeek => 'الحد الأقصى للأيام/الأسبوع';

  @override
  String get trainer_maxConcurrentSessions => 'الحد الأقصى للجلسات المتزامنة';

  @override
  String get trainer_salePriceOptional => 'سعر الخصم (اختياري)';

  @override
  String get trainer_linkedPtServiceOptional => 'خدمة PT المرتبطة (اختياري)';

  @override
  String get trainer_noneOption => 'لا شيء';

  @override
  String get trainer_uncheckDeactivate => 'قم بإلغاء التحديد لتعطيل هذه الباقة';

  @override
  String trainer_trainerNumber(int id) {
    return 'المدرب #$id';
  }

  @override
  String get trainer_schedulesAllTitle => 'جميع الجداول';

  @override
  String get trainer_schedulesMyTitle => 'توفري';

  @override
  String get trainer_noAvailabilityFound => 'لا توجد خانات توفر.';

  @override
  String get trainer_recurringWeekly => 'أسبوعي متكرر';

  @override
  String trainer_oneTimeDate(String date) {
    return 'مرة واحدة: $date';
  }

  @override
  String get trainer_oneTime => 'مرة واحدة';

  @override
  String get trainer_deleteSlotTitle => 'حذف الخانة';

  @override
  String trainer_deleteSlotMessage(String start, String end) {
    return 'إزالة خانة $start–$end؟';
  }

  @override
  String get trainer_addAvailabilitySlotTitle => 'إضافة خانة توفر';

  @override
  String get trainer_dayOfWeek => 'يوم الأسبوع';

  @override
  String get trainer_startTime => 'وقت البداية';

  @override
  String get trainer_endTime => 'وقت النهاية';

  @override
  String get trainer_recurringWeeklyToggle => 'متكرر (أسبوعياً)';

  @override
  String get trainer_specificDate => 'تاريخ محدد *';

  @override
  String get trainer_requiredForOneTime => 'مطلوب للخانات الفردية';

  @override
  String get trainer_pickDate => 'اختر تاريخاً';

  @override
  String get trainer_pickSpecificDate => 'يرجى اختيار تاريخ محدد للخانات الفردية.';

  @override
  String get trainer_addButton => 'إضافة';

  @override
  String get trainer_dayFullMonday => 'الاثنين';

  @override
  String get trainer_dayFullTuesday => 'الثلاثاء';

  @override
  String get trainer_dayFullWednesday => 'الأربعاء';

  @override
  String get trainer_dayFullThursday => 'الخميس';

  @override
  String get trainer_dayFullFriday => 'الجمعة';

  @override
  String get trainer_dayFullSaturday => 'السبت';

  @override
  String get trainer_dayFullSunday => 'الأحد';

  @override
  String get trainer_sessionsAllTitle => 'جميع الجلسات';

  @override
  String get trainer_sessionsTitle => 'الجلسات';

  @override
  String get trainer_bookSession => 'حجز جلسة';

  @override
  String get trainer_sessionAccepted => '✅ تم قبول طلب الجلسة.';

  @override
  String get trainer_sessionCompleted => '✅ تم تسجيل الجلسة كمكتملة.';

  @override
  String get trainer_sessionBooked => '✅ تم حجز الجلسة بنجاح.';

  @override
  String get trainer_sessionDeclined => 'تم رفض طلب الجلسة.';

  @override
  String get trainer_sessionCancelled => 'تم إلغاء الجلسة.';

  @override
  String get trainer_sessionNoShow => 'تم تسجيل الجلسة كغياب.';

  @override
  String get trainer_sessionUpdated => 'تم تحديث الجلسة.';

  @override
  String get trainer_tabToday => 'اليوم';

  @override
  String get trainer_tabUpcoming => 'القادمة';

  @override
  String get trainer_tabCompleted => 'المكتملة';

  @override
  String get trainer_noServicesUpcoming => 'لا توجد خدمات قادمة.';

  @override
  String get trainer_noServicesCompleted => 'لا توجد خدمات مكتملة بعد.';

  @override
  String get trainer_loadTrainersError => 'تعذر تحميل المدربين. يرجى التحقق من الاتصال والمحاولة مجدداً.';

  @override
  String get trainer_idNotFound => 'لم يُعثر على معرف المدرب في الملف الشخصي.\nيرجى تسجيل الخروج وإعادة الدخول.';

  @override
  String get trainer_navDashboard => 'لوحة التحكم';

  @override
  String get trainer_navSessions => 'الجلسات';

  @override
  String get trainer_navPackages => 'الباقات';

  @override
  String get trainer_navSchedule => 'الجدول';

  @override
  String get trainer_navMore => 'المزيد';

  @override
  String get trainer_ptSession => 'جلسة PT';

  @override
  String get trainer_completeButton => 'إكمال';

  @override
  String get trainer_cancelSessionButton => 'إلغاء';

  @override
  String get trainer_declineRequestTitle => 'رفض الطلب';

  @override
  String get trainer_declineRequestMessage => 'هل أنت متأكد أنك تريد رفض طلب الجلسة هذا؟';

  @override
  String get trainer_keepButton => 'الاحتفاظ';

  @override
  String get trainer_cancelSessionTitle => 'إلغاء الجلسة';

  @override
  String get trainer_cancelSessionMessage => 'هل أنت متأكد أنك تريد إلغاء هذه الجلسة؟';

  @override
  String get trainer_cancelSessionConfirm => 'إلغاء الجلسة';

  @override
  String get trainer_statusRequested => 'مطلوب';

  @override
  String get trainer_statusCompleted => 'مكتمل';

  @override
  String get trainer_statusCancelled => 'ملغى';

  @override
  String get trainer_statusNoShow => 'غائب';

  @override
  String get trainer_statusScheduled => 'مجدول';

  @override
  String get trainer_statusCancelRequested => 'طلب إلغاء';

  @override
  String get trainer_approveCancelButton => 'موافقة';

  @override
  String get trainer_keepSessionButton => 'الاحتفاظ بالجلسة';

  @override
  String get trainer_cancelRequestApproved => 'تمت الموافقة على الإلغاء';

  @override
  String get trainer_cancelRequestDeclined => 'تم رفض الإلغاء، ستبقى الجلسة مجدولة';

  @override
  String get trainer_approveCancelTitle => 'الموافقة على الإلغاء';

  @override
  String get trainer_approveCancelMessage => 'سيتم إلغاء الجلسة وإشعار العضو.';

  @override
  String get trainer_declineCancelTitle => 'رفض الإلغاء';

  @override
  String get trainer_declineCancelMessage => 'ستبقى الجلسة مجدولة وسيتم رفض طلب العضو.';

  @override
  String trainer_memberRequestedDate(String date) {
    return 'اقتراح العضو: $date';
  }

  @override
  String get trainer_sessionProgress => 'تقدم الجلسة';

  @override
  String get trainer_selectTimeSlot => 'يرجى اختيار خانة وقت أو تحديد الوقت يدوياً.';

  @override
  String get trainer_enterValidMemberId => 'أدخل معرف عضو صحيح.';

  @override
  String get trainer_noAvailabilityCustomTime => 'لا يوجد توفر لهذا اليوم. يمكنك تحديد وقت مخصص أدناه.';

  @override
  String get trainer_tapSlotToSelect => 'اضغط على خانة لاختيارها.';

  @override
  String get trainer_memberIdLabel => 'معرف العضو *';

  @override
  String get trainer_enterMemberUserId => 'أدخل معرف المستخدم للعضو';

  @override
  String get trainer_enterValidMemberIdValidation => 'أدخل معرف عضو صحيح';

  @override
  String get trainer_memberPackageIdOptional => 'معرف باقة العضو (اختياري)';

  @override
  String get trainer_linkSessionToPackage => 'ربط هذه الجلسة بباقة PT الخاصة بالعضو.';

  @override
  String get trainer_selectDate => 'اختر تاريخاً';

  @override
  String get trainer_selectTimeLabel => 'اختر وقتاً';

  @override
  String get trainer_bookingId => 'معرف الحجز';

  @override
  String get trainer_paymentStatusLabel => 'حالة الدفع';

  @override
  String get trainer_confirmCashPayment => 'تأكيد استلام الدفع النقدي';

  @override
  String get trainer_confirming => 'جاري التأكيد...';

  @override
  String get trainer_noPendingCashPayments => 'لا توجد مدفوعات نقدية معلقة';

  @override
  String get trainer_allPtPackagesConfirmed => 'جميع باقات PT تم تأكيد دفعها';

  @override
  String get trainer_leaveBlankIfNone => 'اتركه فارغاً إن لم يكن هناك';

  @override
  String get trainer_validNumberError => 'أدخل رقماً صحيحاً';

  @override
  String get trainer_serviceOptionalLabel => 'الخدمة (اختياري)';

  @override
  String get trainer_noService => 'بدون خدمة';

  @override
  String get trainer_notesOptionalLabel => 'ملاحظات (اختياري)';

  @override
  String get trainer_notesHint => 'مثل: التركيز على الجزء العلوي';

  @override
  String get trainer_pickTime => 'اختر وقتاً';

  @override
  String get trainer_calendarAvailable => 'متاح';

  @override
  String get trainer_calendarSelected => 'محدد';

  @override
  String get trainer_cashPaymentConfirmed => 'تم تأكيد الدفع وتفعيل الحصص.';

  @override
  String get trainer_rejectCashPayment => 'رفض';

  @override
  String get trainer_rejecting => 'جاري الرفض...';

  @override
  String get trainer_cashPaymentRejected => 'تم رفض الدفع.';

  @override
  String get trainer_rejectPaymentTitle => 'رفض الدفع';

  @override
  String get trainer_rejectPaymentHint => 'سبب الرفض';

  @override
  String get trainer_rejectPaymentReasonRequired => 'يرجى إدخال السبب';

  @override
  String get trainer_dateLabel => 'التاريخ';

  @override
  String get promotionPrice => 'بعد العرض';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsUnsaved => 'غير محفوظ';

  @override
  String get settingsUnexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get settingsTryAgain => 'حاول مرة أخرى';

  @override
  String get settingsSavedSuccessfully => 'تم حفظ الإعدادات بنجاح';

  @override
  String get settingsSaveFailed => 'فشل حفظ الإعدادات';

  @override
  String get settingsSaving => 'جارٍ الحفظ...';

  @override
  String get settingsSaveChanges => 'حفظ التغييرات';

  @override
  String get settingsLanguageRegionTitle => 'اللغة والمنطقة';

  @override
  String get settingsLanguageRegionSubtitle => 'اختر لغتك المفضلة';

  @override
  String get settingsLanguageEnglish => 'الإنجليزية';

  @override
  String get settingsLanguageEnglishSubtitle => 'اللغة الافتراضية';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageArabicSubtitle => 'اللغة العربية';

  @override
  String get settingsLanguageSystemDefault => 'لغة الجهاز';

  @override
  String get settingsLanguageSystemDefaultSubtitle => 'استخدام لغة الجهاز';

  @override
  String get branchDialog_setupTitle => 'أنشئ فرعك الأول';

  @override
  String get branchDialog_setupSubtitle => 'أنشئ موقع الجيم الرئيسي لتبدأ إدارة الأعضاء والخطط وتسجيلات الدخول والمزيد.';

  @override
  String get branchDialog_sectionBasic => 'المعلومات الأساسية';

  @override
  String get branchDialog_name => 'اسم الفرع';

  @override
  String get branchDialog_nameHint => 'مثال: الجيم الرئيسي – وسط المدينة';

  @override
  String get branchDialog_nameRequired => 'اسم الفرع مطلوب';

  @override
  String get branchDialog_city => 'المدينة';

  @override
  String get branchDialog_cityHint => 'مثال: بيروت';

  @override
  String get branchDialog_cityRequired => 'المدينة مطلوبة';

  @override
  String get branchDialog_sectionContact => 'معلومات التواصل';

  @override
  String get branchDialog_phone => 'الهاتف';

  @override
  String get branchDialog_phoneHint => '+961 70 000 000';

  @override
  String get branchDialog_phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get branchDialog_email => 'البريد الإلكتروني';

  @override
  String get branchDialog_emailHint => 'branch@yourgym.com';

  @override
  String get branchDialog_emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get branchDialog_emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get branchDialog_address => 'العنوان';

  @override
  String get branchDialog_addressHint => 'شارع الرئيسي، وسط المدينة';

  @override
  String get branchDialog_addressRequired => 'العنوان مطلوب';

  @override
  String get branchDialog_sectionHours => 'ساعات العمل';

  @override
  String get branchDialog_open24 => 'مفتوح 24 ساعة';

  @override
  String get branchDialog_open24Sub => 'الفرع مفتوح دائماً';

  @override
  String get branchDialog_opening => 'الافتتاح';

  @override
  String get branchDialog_closing => 'الإغلاق';

  @override
  String get branchDialog_tapToSet => 'اضغط للتحديد';

  @override
  String get branchDialog_closingAfterOpening => 'وقت الإغلاق يجب أن يكون بعد وقت الافتتاح';

  @override
  String get branchDialog_selectOpening => 'الرجاء تحديد وقت الافتتاح';

  @override
  String get branchDialog_selectClosing => 'الرجاء تحديد وقت الإغلاق';

  @override
  String get branchDialog_create => 'إنشاء الفرع';

  @override
  String get branchDialog_createdSuccess => 'تم إنشاء الفرع بنجاح!';

  @override
  String get branchDialog_next => 'التالي';

  @override
  String get branchDialog_back => 'رجوع';
}
