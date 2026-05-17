// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auth_welcomeBack => 'Welcome back';

  @override
  String get auth_loginSubtitle => 'Sign in to access your account';

  @override
  String get auth_emailLabel => 'Email Address';

  @override
  String get auth_phoneLabel => 'Phone Number';

  @override
  String get auth_emailHint => 'example@email.com';

  @override
  String get auth_phoneHint => '+961 12 345 678';

  @override
  String get auth_passwordLabel => 'Password';

  @override
  String get auth_passwordHint => 'Enter your password';

  @override
  String get auth_forgotPassword => 'Forgot Password?';

  @override
  String get auth_loginButton => 'Sign In';

  @override
  String get auth_continueWithGoogle => 'Continue with Google';

  @override
  String get auth_continueWithApple => 'Continue with Apple';

  @override
  String get auth_noAccount => 'Don\'t have an account?';

  @override
  String get auth_createAccount => 'Create Account';

  @override
  String get auth_accountInactiveTitle => 'Account Inactive';

  @override
  String get auth_accountInactiveMessage => 'Your account is inactive. Would you like to reactivate it?';

  @override
  String get auth_reactivate => 'Reactivate';

  @override
  String get auth_accountInactive => 'Your account is inactive.';

  @override
  String get auth_accountDeletedRestorableMessage => 'Your account was deleted. Contact support to restore it.';

  @override
  String get auth_accountDeletedPermanentMessage => 'Your account has been permanently deleted.';

  @override
  String get auth_userNotFound => 'No account found with these credentials.';

  @override
  String get auth_loginLocked => 'Too many failed attempts. Please try again later.';

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
  String get login_continueWithGoogle => 'Continue with Google';

  @override
  String get login_continueWithApple => 'Continue with Apple';

  @override
  String get login_noAccount => 'Don\'t have an account?';

  @override
  String get login_createAccount => 'Create new account';

  @override
  String get validation_emailRequired => 'Email is required';

  @override
  String get validation_phoneRequired => 'Phone number is required';

  @override
  String get validation_emailInvalid => 'Invalid email address';

  @override
  String get validation_invalidEmail => 'Please enter a valid email';

  @override
  String get validation_passwordRequired => 'Password is required';

  @override
  String get validation_invalidCredentials => 'Invalid email or password';

  @override
  String get validation_passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get validation_passwordsMismatch => 'Passwords do not match';

  @override
  String get validation_codeRequired => 'Verification code is required';

  @override
  String get validation_invalidCode => 'Invalid or expired code';

  @override
  String get validation_emailAlreadyExists => 'Email already exists';

  @override
  String get validation_phoneAlreadyExists => 'Phone number already exists';

  @override
  String get validation_passwordNoLetter => 'Password must contain at least one letter';

  @override
  String get validation_passwordNoNumber => 'Password must contain at least one number';

  @override
  String get validation_confirmPasswordRequired => 'Please confirm your password';

  @override
  String get general_cancel => 'Cancel';

  @override
  String get general_or => 'or';

  @override
  String get general_optional => 'Optional';

  @override
  String get general_retry => 'Retry';

  @override
  String get general_save => 'Save';

  @override
  String get general_edit => 'Edit';

  @override
  String get general_delete => 'Delete';

  @override
  String get general_back => 'Back';

  @override
  String get general_done => 'Done';

  @override
  String get general_required => 'Required';

  @override
  String get general_active => 'Active';

  @override
  String get general_inactive => 'Inactive';

  @override
  String get general_search => 'Search';

  @override
  String get general_noPhone => 'No phone';

  @override
  String get error_somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get error_serverError => 'Server error. Please try again later.';

  @override
  String get connection_reconnecting => 'Connecting...';

  @override
  String get connection_offline => 'No internet connection';

  @override
  String get connection_issue => 'Connection issue';

  @override
  String get connection_timeout => 'Request timed out. Please try again.';

  @override
  String get authGateContinueAs => 'Continue as';

  @override
  String get authGateRoleAdminOwner => 'Admin / Owner';

  @override
  String get authGateRoleUser => 'Regular User';

  @override
  String get appAccessTitleDeleted => 'App Deleted';

  @override
  String get appAccessTitleExpired => 'Subscription Expired';

  @override
  String get appAccessTitleUnavailable => 'App Unavailable';

  @override
  String get appAccessMessageDeleted => 'This application has been deleted and is no longer available.';

  @override
  String get appAccessMessageExpired => 'The subscription for this app has expired. Please contact support.';

  @override
  String get appAccessMessageUnavailable => 'This application is currently unavailable. Please try again later.';

  @override
  String get appAccessRetry => 'Try Again';

  @override
  String get common_or => 'Or';

  @override
  String get forgotPassword_title => 'Reset your password';

  @override
  String get forgotPassword_subtitle => 'Enter your email and we\'ll send you a code.';

  @override
  String get forgotPassword_sendCode => 'Send code';

  @override
  String get forgotPassword_spamTip => 'Tip: check spam/junk folder too 👀';

  @override
  String get forgotPassword_verifyTitle => 'Enter verification code';

  @override
  String forgotPassword_codeSentTo(String email) {
    return 'We sent a code to $email';
  }

  @override
  String get forgotPassword_codeLabel => 'Code';

  @override
  String get forgotPassword_verify => 'Verify';

  @override
  String get forgotPassword_resendCode => 'Resend code';

  @override
  String get forgotPassword_newPasswordTitle => 'Set a new password';

  @override
  String get forgotPassword_newPasswordSubtitle => 'Make it strong — future you will thank you.';

  @override
  String get forgotPassword_newPassword => 'New password';

  @override
  String get forgotPassword_confirmPassword => 'Confirm password';

  @override
  String get forgotPassword_savePassword => 'Save password';

  @override
  String get forgotPassword_enterAllDigits => 'Please enter all digits';

  @override
  String get forgotPassword_otpScreenTitle => 'Enter Verification Code';

  @override
  String get forgotPassword_otpScreenSubtitle => 'Enter the code sent to your email or phone';

  @override
  String get forgotPassword_checkSms => 'Check your SMS';

  @override
  String get forgotPassword_checkEmail => 'Check your email';

  @override
  String get forgotPassword_checkEmailOrSms => 'Check your email or SMS';

  @override
  String forgotPassword_codeExpiresIn(int seconds) {
    return 'Code expires in ${seconds}s';
  }

  @override
  String get forgotPassword_codeExpired => 'Code has expired';

  @override
  String get forgotPassword_verifyCode => 'Verify code';

  @override
  String get forgotPassword_didntReceiveCode => 'Didn\'t receive the code?';

  @override
  String get forgotPassword_emailOrPhone => 'Email or phone';

  @override
  String get forgotPassword_emailOrPhoneHint => 'Enter your email or phone number';

  @override
  String get forgotPassword_fieldRequired => 'This field is required';

  @override
  String get forgotPassword_invalidEmailOrPhone => 'Invalid email or phone number';

  @override
  String get forgotPassword_sendOtp => 'Send OTP';

  @override
  String get forgotPassword_newPasswordScreenTitle => 'Set New Password';

  @override
  String get forgotPassword_newPasswordScreenSubtitle => 'Enter your new password below';

  @override
  String get forgotPassword_passwordResetSuccess => 'Password reset successfully';

  @override
  String get signup_title => 'Create New Account';

  @override
  String get signup_subtitle => 'Start your fitness journey with us';

  @override
  String get signup_step1Label => 'Account Information';

  @override
  String get signup_registrationMethod => 'Registration Method';

  @override
  String get signup_confirmPasswordLabel => 'Confirm Password';

  @override
  String get signup_confirmPasswordHint => 'Re-enter your password';

  @override
  String get signup_continueButton => 'Continue';

  @override
  String get signup_alreadyHaveAccount => 'Already have an account?';

  @override
  String get signup_signIn => 'Sign In';

  @override
  String get signup_termsAgreement => 'By continuing, you agree to our Terms of Service and Privacy Policy';

  @override
  String get signup_alreadyVerifiedResume => 'Account already verified. Completing your profile.';

  @override
  String get signup_success => 'Successfully registered. You can now login.';

  @override
  String get otp_title => 'Confirm Account';

  @override
  String get otp_subtitle => 'Enter the verification code sent';

  @override
  String get otp_step2Label => 'Identity Verification';

  @override
  String get otp_sentTo => 'Sent to';

  @override
  String otp_enterDigits(int count) {
    return 'Enter the $count-digit verification code';
  }

  @override
  String get otp_didntReceive => 'Didn\'t receive the code?';

  @override
  String get otp_resendNow => 'Resend now';

  @override
  String get otp_verifyButton => 'Verify';

  @override
  String get otp_verifiedSuccess => 'Account verified successfully!';

  @override
  String get otp_codeSentAgain => 'Verification code sent again';

  @override
  String get otp_enterAllDigits => 'Please enter all digits';

  @override
  String get otp_backToSignup => 'Back to registration';

  @override
  String get otp_debugTip => 'For testing use code 1234';

  @override
  String get completeProfile_title => 'Complete Your Profile';

  @override
  String get completeProfile_subtitle => 'Tell us more about you';

  @override
  String get completeProfile_lastStepTitle => 'Last Step!';

  @override
  String get completeProfile_lastStepSubtitle => 'Choose a unique username';

  @override
  String get completeProfile_stepLabel => 'Personal Information';

  @override
  String get completeProfile_nameInstruction => 'We need your name to personalize your experience';

  @override
  String get completeProfile_firstName => 'First Name';

  @override
  String get completeProfile_firstNameHint => 'Enter your first name';

  @override
  String get completeProfile_firstNameRequired => 'First name is required';

  @override
  String get completeProfile_lastName => 'Last Name';

  @override
  String get completeProfile_lastNameHint => 'Enter your last name';

  @override
  String get completeProfile_continueButton => 'Continue';

  @override
  String get completeProfile_usernameInstruction => 'Your username will appear in your profile';

  @override
  String get completeProfile_username => 'Username';

  @override
  String get completeProfile_usernameRequired => 'Username is required';

  @override
  String get completeProfile_usernameTooShort => 'At least 3 characters required';

  @override
  String get completeProfile_usernameInvalid => 'Only letters, numbers, _ and . allowed';

  @override
  String get completeProfile_usernameTaken => 'This username is already taken';

  @override
  String get completeProfile_profileType => 'Profile Type';

  @override
  String get completeProfile_publicTitle => 'Public Account';

  @override
  String get completeProfile_publicDescription => 'Anyone can view your profile and activity';

  @override
  String get completeProfile_privateTitle => 'Private Account';

  @override
  String get completeProfile_privateDescription => 'Only you can see your information and activity';

  @override
  String get completeProfile_settingsNote => 'You can change these settings later from your profile';

  @override
  String get completeProfile_finishButton => 'Finish & Start';

  @override
  String get completeProfile_backButton => 'Back';

  @override
  String get home_welcome => 'Welcome';

  @override
  String get home_weightUpdated => 'Your weight was updated successfully ✅';

  @override
  String get home_noData => 'No data available';

  @override
  String get home_sessions => 'Sessions';

  @override
  String get home_kgLost => 'kg lost';

  @override
  String get home_workouts => 'Workouts';

  @override
  String get home_minutes => 'min';

  @override
  String get home_quickActions => 'Quick Actions';

  @override
  String get home_bookClass => 'Book Class';

  @override
  String get home_myProgress => 'My Progress';

  @override
  String get home_membership => 'Membership';

  @override
  String get home_support => 'Support';

  @override
  String get home_updateWeight => 'Update your weight';

  @override
  String get home_save => 'Save';

  @override
  String get home_weightHint => '75.5';

  @override
  String get home_navHome => 'Home';

  @override
  String get home_navActivities => 'Activities';

  @override
  String get home_navProfile => 'Profile';

  @override
  String get home_membershipStatus => 'Membership Status';

  @override
  String get home_expiresOn => 'Expires on';

  @override
  String get home_renewNow => 'Renew Now';

  @override
  String get memberBottomNavHome => 'Home';

  @override
  String get memberBottomNavPlans => 'Plans';

  @override
  String get memberBottomNavQr => 'QR';

  @override
  String get memberBottomNavClasses => 'Classes';

  @override
  String get memberBottomNavAccount => 'My Account';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get memberHomeTodaySchedule => 'Today\'s Schedule';

  @override
  String get memberHomeViewAll => 'View All';

  @override
  String memberHomeWithTrainer(Object trainerName) {
    return 'With coach $trainerName';
  }

  @override
  String memberHomeDurationMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String get memberHomeNoScheduleToday => 'No classes today — enjoy your rest day! 💪';

  @override
  String get home_quoteOfTheDay => 'Quote of the day';

  @override
  String get home_progressTracking => 'Progress tracking';

  @override
  String get home_weightTrackerSubtitle => 'How was your week? Take a moment to update your weight and track your progress.';

  @override
  String get home_updateWeightNow => 'Update my weight';

  @override
  String get home_bookTrainer => 'Book Trainer';

  @override
  String get home_checkInCode => 'Check-in Code';

  @override
  String get home_paymentHistory => 'Payment History';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get selectThisPlan => 'Select This Plan';

  @override
  String get renew => 'Renew';

  @override
  String get planTypeGym => 'Gym';

  @override
  String get planTypeClasses => 'Classes';

  @override
  String get planTypeMixed => 'Mixed';

  @override
  String get billingMonthly => 'Monthly';

  @override
  String get billingYearly => 'Yearly';

  @override
  String get billingWeekly => 'Weekly';

  @override
  String get membershipStatusActive => 'Active';

  @override
  String get membershipStatusFrozen => 'Frozen';

  @override
  String get membershipStatusExpired => 'Expired';

  @override
  String remainingDays(int days) {
    return '$days days remaining';
  }

  @override
  String membershipEndsAt(String date) {
    return 'Ends on $date';
  }

  @override
  String get memberPlansTitle => 'Membership Plans';

  @override
  String get memberPlansSubtitle => 'Choose the plan that fits your goals';

  @override
  String get memberPlansEmpty => 'No plans available right now';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get checkoutComingSoon => 'Coming soon — checkout is under development';

  @override
  String get planDuration => 'Duration';

  @override
  String get visitLimit => 'Visit limit';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get freezeDays => 'Freeze days';

  @override
  String get planFeatures => 'Features';

  @override
  String get couponCode => 'Coupon code';

  @override
  String get enterCouponCode => 'Enter coupon code';

  @override
  String get apply => 'Apply';

  @override
  String couponAppliedFinalPrice(String price) {
    return '✓ Coupon applied — final price: $price \$';
  }

  @override
  String get selectedPlan => 'Selected Plan';

  @override
  String get baseAmount => 'Base Amount';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get planDetails => 'Plan Details';

  @override
  String get dayMonday => 'Mon';

  @override
  String get dayTuesday => 'Tue';

  @override
  String get dayWednesday => 'Wed';

  @override
  String get dayThursday => 'Thu';

  @override
  String get dayFriday => 'Fri';

  @override
  String get daySaturday => 'Sat';

  @override
  String get daySunday => 'Sun';

  @override
  String get memberSessionsDifficultyBeginner => 'Beginner';

  @override
  String get memberSessionsDifficultyIntermediate => 'Intermediate';

  @override
  String get memberSessionsDifficultyAdvanced => 'Advanced';

  @override
  String get memberSessionsBookNow => 'Book Now';

  @override
  String get memberSessionsTitle => 'Sports Classes';

  @override
  String get memberSessionsSubtitle => 'Book your spot in your favorite class';

  @override
  String memberSessionsRoom(String roomName) {
    return 'Room $roomName';
  }

  @override
  String memberSessionsMinute(int minutes) {
    return '$minutes min';
  }

  @override
  String memberSessionsSeatsAvailable(int count) {
    return '$count seats';
  }

  @override
  String get memberSessionsLoading => 'Loading sessions...';

  @override
  String get memberSessionsEmpty => 'No sessions available';

  @override
  String get memberSessionsError => 'Failed to load sessions';

  @override
  String get memberSessionsFilterTitle => 'Filter classes';

  @override
  String get memberSessionsFilterClassType => 'Class type';

  @override
  String get memberSessionsFilterTrainer => 'Trainer';

  @override
  String get memberSessionsFilterBranch => 'Branch';

  @override
  String get memberSessionsFilterReset => 'Reset';

  @override
  String get memberSessionsFilterApply => 'Apply filter';

  @override
  String get sessionDetailTimeLabel => 'Time';

  @override
  String get sessionDetailDateLabel => 'Date';

  @override
  String get sessionDetailSeatsLabel => 'Seats';

  @override
  String sessionDetailSeatsRemaining(int count) {
    return '$count remaining';
  }

  @override
  String get sessionDetailLocationLabel => 'Location';

  @override
  String get sessionDetailAboutTitle => 'About the Class';

  @override
  String get sessionDetailBenefitsTitle => 'Benefits';

  @override
  String get sessionDetailEquipmentTitle => 'Required Equipment';

  @override
  String get sessionDetailBookNow => 'Book Now';

  @override
  String get sessionDetailAlreadyBooked => 'Already Booked';

  @override
  String get sessionDetailWaitlisted => 'On Waitlist';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navMembers => 'Members';

  @override
  String get navPlans => 'Plans';

  @override
  String get navStaff => 'Staff';

  @override
  String get navPayments => 'Payments';

  @override
  String get navClasses => 'Classes';

  @override
  String get navAiAssistant => 'AI Assistant';

  @override
  String get navSettings => 'Settings';

  @override
  String get navLogout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get sectionCoreOwner => 'CORE OWNER';

  @override
  String get sectionOperationsReception => 'OPERATIONS / RECEPTION';

  @override
  String get sectionTrainingPt => 'TRAINING / PT';

  @override
  String get navTrainers => 'Trainers / PT';

  @override
  String get navReceptionStaff => 'Reception Staff';

  @override
  String get navGymProfile => 'Gym Profile';

  @override
  String get navBranches => 'Branches';

  @override
  String get navCheckins => 'Check-ins';

  @override
  String get navClassesPt => 'Classes & PT';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navPtSessions => 'PT Sessions';

  @override
  String get navTrainingVideos => 'Training Videos';

  @override
  String get accountProfileUpdateSuccess => 'Profile updated successfully';

  @override
  String get accountStatExercises => 'Exercises';

  @override
  String get accountStatSessions => 'Sessions';

  @override
  String get accountStatAchievements => 'Achievements';

  @override
  String get accountMyBookings => 'My Bookings';

  @override
  String get accountLoyaltyPoints => 'Loyalty Points';

  @override
  String get accountReferralTitle => 'Your Referral Code';

  @override
  String get accountReferralSubtitle => 'Share and earn rewards';

  @override
  String get accountReferralCodeLabel => 'Your code';

  @override
  String get accountReferralCopied => 'Code copied';

  @override
  String get accountReferralShare => 'Share Code';

  @override
  String get accountPersonalInfo => 'Personal Information';

  @override
  String get accountEmail => 'Email';

  @override
  String get accountPhone => 'Phone';

  @override
  String get accountDateOfBirth => 'Date of Birth';

  @override
  String get accountAddress => 'Address';

  @override
  String get accountEditProfile => 'Edit Profile';

  @override
  String get accountSectionAccount => 'Account';

  @override
  String get accountSectionSettings => 'Settings';

  @override
  String get accountPaymentMethods => 'Payment Methods';

  @override
  String get accountMyMembership => 'My Membership';

  @override
  String get accountNotifications => 'Notifications';

  @override
  String get accountSettings => 'Settings';

  @override
  String get accountHelpSupport => 'Help & Support';

  @override
  String get appVersion => 'Version';

  @override
  String get ptAll => 'All';

  @override
  String get ptFavorites => 'Favorites';

  @override
  String ptFavoritesWithCount(int count) {
    return 'Favorites $count';
  }

  @override
  String get ptPerSession => '/session';

  @override
  String ptYearsExperience(int years) {
    return '$years years exp';
  }

  @override
  String ptReviews(int count) {
    return '$count reviews';
  }

  @override
  String get ptScreenTitle => 'Personal Trainers';

  @override
  String get ptScreenSubtitle => 'Choose the right trainer for your goals';

  @override
  String get ptBookSession => 'Book Session';

  @override
  String get ptNoTrainers => 'No trainers available';

  @override
  String accountMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get ptBookingChooseDate => 'Choose Date';

  @override
  String get ptBookingChooseTime => 'Choose Time';

  @override
  String get ptBookingNoSlotsForDate => 'No available slots for this date.';

  @override
  String get ptDetailSession => 'session';

  @override
  String get ptTrainingVideosTitle => 'Training Videos';

  @override
  String get ptTrainingVideosEmpty => 'No training videos yet.';

  @override
  String get ptTrainingVideosMissingUrl => 'Video URL is missing.';

  @override
  String get ptTrainingVideosOpenError => 'Could not open this video.';

  @override
  String get ptTrainerDetailsNotFound => 'Trainer details not found.';

  @override
  String get ptFavoriteUpdateFailed => 'Failed to update favorite.';

  @override
  String get ptConfirmBooking => 'Confirm Booking';

  @override
  String ptBookingSelected(String date, String time) {
    return 'Booking selected: $date at $time';
  }

  @override
  String get ptBookingSummary => 'Booking summary';

  @override
  String get ptBookingTrainer => 'Trainer:';

  @override
  String get ptBookingDate => 'Date:';

  @override
  String get ptBookingTime => 'Time:';

  @override
  String get ptBookingTotalAmount => 'Total amount:';

  @override
  String get ptBookingSuccess => 'Booking confirmed successfully.';

  @override
  String get ptSlotAlreadyBooked => 'You already booked this time slot.';

  @override
  String get ptPackageChoosePackage => 'Choose package';

  @override
  String get ptPackageChooseDays => 'Choose days';

  @override
  String get ptPackageChooseTime => 'Choose time';

  @override
  String get ptPackageBookingSummary => 'Booking summary';

  @override
  String get ptPackageConfirmBooking => 'Confirm booking';

  @override
  String get ptPackageBookingSuccess => 'Package booking confirmed successfully.';

  @override
  String get ptPackageBookingFailed => 'Could not confirm package booking.';

  @override
  String get ptPackageNoPackages => 'No packages available right now';

  @override
  String get ptPackageSessions => 'sessions';

  @override
  String get ptPackageDays => 'days';

  @override
  String get ptPackageFinalPrice => 'Final price';

  @override
  String get ptPackageOriginalPrice => 'Original price';

  @override
  String get ptPackageSalePrice => 'Sale price';

  @override
  String get ptPackageSelectedPackage => 'Selected package';

  @override
  String get ptPackageSelectedDays => 'Selected days';

  @override
  String get ptPackageSelectedTime => 'Selected time';

  @override
  String get ptPackageMaxSessionsReached => 'You cannot select more days than the package sessions';

  @override
  String ptPackageDaysPerWeekRange(int min, int max) {
    return 'Choose $min to $max days per week';
  }

  @override
  String ptPackageDaysPerWeekExact(int count) {
    return 'Choose $count day(s) per week';
  }

  @override
  String ptPackageMaxDaysReached(int max) {
    return 'You cannot select more than $max days per week';
  }

  @override
  String get ptPackageNoAvailableSlots => 'No available times';

  @override
  String get ptWeeklySlotsFailed => 'Could not load available times';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileSubtitle => 'Update your personal information';

  @override
  String get editProfileFullName => 'Full Name';

  @override
  String get editProfileEmail => 'Email';

  @override
  String get editProfilePhone => 'Phone Number';

  @override
  String get editProfileDateOfBirth => 'Date of Birth';

  @override
  String get editProfileAddress => 'Address';

  @override
  String get editProfileGender => 'Gender';

  @override
  String get editProfileMale => 'Male';

  @override
  String get editProfileFemale => 'Female';

  @override
  String get editProfileSave => 'Save Changes';

  @override
  String get editProfileCancel => 'Cancel';

  @override
  String get editProfileNameRequired => 'Name is required';

  @override
  String get editProfileEmailRequired => 'Email is required';

  @override
  String get editProfileInvalidEmail => 'Invalid email address';

  @override
  String get accountGender => 'Gender';

  @override
  String get accountGenderMale => 'Male';

  @override
  String get accountGenderFemale => 'Female';

  @override
  String get editProfileFirstName => 'First Name';

  @override
  String get editProfileLastName => 'Last Name';

  @override
  String get editProfileUsername => 'Username';

  @override
  String get editProfileChangePassword => 'Change Password';

  @override
  String get editProfileCurrentPassword => 'Current Password';

  @override
  String get editProfileNewPassword => 'New Password';

  @override
  String get editProfileRequired => 'Required.';

  @override
  String get editProfileUsernameRequired => 'Username is required.';

  @override
  String get editProfileEmailRequiredMessage => 'Email is required.';

  @override
  String get editProfileInvalidEmailMessage => 'Invalid email address.';

  @override
  String get editProfilePhoneRequired => 'Phone number is required.';

  @override
  String get editProfileCurrentPasswordRequired => 'Current password is required.';

  @override
  String get editProfileNewPasswordRequired => 'New password is required.';

  @override
  String get editProfilePasswordTooShort => 'New password must be at least 6 characters.';

  @override
  String get editProfilePasswordSameAsCurrent => 'New password must be different from current password.';

  @override
  String get editProfileInvalidOwnerProject => 'Invalid owner project link id.';

  @override
  String get editProfileEmailVerified => 'Email verified successfully.';

  @override
  String get editProfilePasswordUpdated => 'Password updated successfully.';

  @override
  String get editProfileOnlyLetters => 'Only letters and spaces are allowed.';

  @override
  String get editProfileVerifyNewEmail => 'Verify new email';

  @override
  String get editProfileVerifyPasswordChange => 'Verify password change';

  @override
  String get editProfileCodeSentTo => 'Code sent to';

  @override
  String get editProfileVerificationCode => 'Verification code';

  @override
  String get editProfileResend => 'Resend';

  @override
  String get editProfileVerify => 'Verify';

  @override
  String get editProfileCodeRequired => 'Verification code is required.';

  @override
  String get admin_allBranches => 'All Branches';

  @override
  String get admin_aiTitle => 'AI Assistant';

  @override
  String get admin_aiNewConversation => 'New conversation';

  @override
  String get admin_aiRecentQueries => 'Recent Queries';

  @override
  String get admin_aiView => 'View';

  @override
  String get admin_aiYouMightAlsoAsk => 'You might also ask:';

  @override
  String get admin_aiInputHint => 'Ask a question about your gym...';

  @override
  String get admin_aiRetry => 'Retry';

  @override
  String get admin_aiHeroBannerTitle => 'AI Insights Assistant';

  @override
  String get admin_aiHeroBannerSubtitle => 'Ask me anything about your gym';

  @override
  String get admin_aiHeroBannerDesc => 'Get instant analytics, insights, and\nrecommendations based on your gym\'s data.';

  @override
  String get admin_aiSuggestedQuestions => 'Suggested Questions';

  @override
  String get admin_aiQueryFailed => 'Sorry, I could not process your request. Please try again.';

  @override
  String get admin_branchesTitle => 'Branches';

  @override
  String get admin_addBranchTitle => 'Add Branch';

  @override
  String get admin_branchCreatedSuccess => 'Branch created successfully';

  @override
  String get admin_branchBasicInfo => 'Basic Information';

  @override
  String get admin_branchName => 'Branch Name';

  @override
  String get admin_branchNameRequired => 'Branch name is required';

  @override
  String get admin_branchCity => 'City / Location';

  @override
  String get admin_branchCityRequired => 'City is required';

  @override
  String get admin_branchContactInfo => 'Contact Information';

  @override
  String get admin_branchPhone => 'Phone';

  @override
  String get admin_branchPhoneRequired => 'Phone is required';

  @override
  String get admin_branchEmail => 'Email';

  @override
  String get admin_branchEmailRequired => 'Email is required';

  @override
  String get admin_branchEmailInvalid => 'Enter a valid email';

  @override
  String get admin_branchAddress => 'Address';

  @override
  String get admin_branchAddressRequired => 'Address is required';

  @override
  String get admin_branchOperatingHours => 'Operating Hours';

  @override
  String get admin_branchOpeningTime => 'Opening Time';

  @override
  String get admin_branchClosingTime => 'Closing Time';

  @override
  String get admin_branchTimeError => 'Closing time must be after opening time';

  @override
  String get admin_branchStatus => 'Status';

  @override
  String get admin_branchActive => 'Active';

  @override
  String get admin_branchInactive => 'Inactive';

  @override
  String get admin_branchCreate => 'Create Branch';

  @override
  String get admin_branchOpeningRequired => 'Please select an opening time';

  @override
  String get admin_branchClosingRequired => 'Please select a closing time';

  @override
  String get admin_branchDetailTitle => 'Branch Detail';

  @override
  String get admin_branchMembers => 'Members';

  @override
  String get admin_branchTrainers => 'Trainers';

  @override
  String get admin_branchStaff => 'Staff';

  @override
  String get admin_branchMonthlyRevenue => 'Monthly Revenue';

  @override
  String get admin_branchActiveStat => 'Active Branches';

  @override
  String get admin_branchTotalMembers => 'Total Members';

  @override
  String get admin_branchSearchHint => 'Search by branch name or location.';

  @override
  String get admin_branchAllStatus => 'All Status';

  @override
  String get admin_branchNoFound => 'No branches found';

  @override
  String get admin_branchRetry => 'Retry';

  @override
  String get admin_classesTitle => 'Classes';

  @override
  String get admin_classTodayLabel => 'Today\'s Classes';

  @override
  String get admin_classCancelTitle => 'Cancel Class';

  @override
  String get admin_classCancelConfirm => 'Are you sure you want to cancel this class? All booked members will be notified.';

  @override
  String get admin_classKeep => 'Keep Class';

  @override
  String get admin_classYesCancel => 'Yes, Cancel';

  @override
  String get admin_classCreatedSuccess => 'Class created successfully';

  @override
  String get admin_classUpdatedSuccess => 'Class updated successfully';

  @override
  String get admin_classCancelledSuccess => 'Class cancelled';

  @override
  String get admin_classDone => 'Done';

  @override
  String get admin_classRetry => 'Retry';

  @override
  String get admin_classNoneToday => 'No classes scheduled for this day';

  @override
  String get admin_classNewTypeLabel => 'New Class Type';

  @override
  String get admin_classNameField => 'Name *';

  @override
  String get admin_classRequired => 'Required';

  @override
  String get admin_classDurationField => 'Duration (minutes) *';

  @override
  String get admin_classMustBeNumber => 'Must be a number';

  @override
  String get admin_classDifficulty => 'Difficulty Level';

  @override
  String get admin_classBeginner => 'Beginner';

  @override
  String get admin_classIntermediate => 'Intermediate';

  @override
  String get admin_classAdvanced => 'Advanced';

  @override
  String get admin_classPrice => 'Price';

  @override
  String get admin_classCancel => 'Cancel';

  @override
  String get admin_classFailedCreate => 'Failed to create class type';

  @override
  String get admin_classCreate => 'Create';

  @override
  String get admin_classSelectDatetime => 'Please select date and time';

  @override
  String get admin_classFillRequired => 'Please fill all required fields';

  @override
  String get admin_classEditTitle => 'Edit Class';

  @override
  String get admin_classAddTitle => 'Add New Class';

  @override
  String get admin_classNameLabel => 'Class Name *';

  @override
  String get admin_classTypeActivity => 'Type / Activity *';

  @override
  String get admin_classNewType => 'New Type';

  @override
  String get admin_classSelectType => 'Select type';

  @override
  String get admin_classTrainer => 'Trainer *';

  @override
  String get admin_classSelectTrainer => 'Select trainer';

  @override
  String get admin_classBranch => 'Branch *';

  @override
  String get admin_classSelectBranch => 'Select branch';

  @override
  String get admin_classDate => 'Date *';

  @override
  String get admin_classTime => 'Time *';

  @override
  String get admin_classCapacity => 'Capacity *';

  @override
  String get admin_classMaxParticipants => 'Maximum participants';

  @override
  String get admin_classRoomName => 'Room Name';

  @override
  String get admin_classNotesDesc => 'Notes / Description';

  @override
  String get admin_classSave => 'Save Class';

  @override
  String get admin_classNearlyFull => 'Nearly Full';

  @override
  String get admin_classBookings => 'Bookings';

  @override
  String get admin_classEdit => 'Edit';

  @override
  String get admin_classToday => 'Today';

  @override
  String get admin_sessionBookingsTitle => 'Session Bookings';

  @override
  String get admin_sessionNoBookings => 'No bookings yet';

  @override
  String get admin_sessionBooked => 'Booked';

  @override
  String get admin_dashboardTitle => 'Dashboard';

  @override
  String get admin_dashboardToday => 'Today';

  @override
  String get admin_dashboardThisWeek => 'This Week';

  @override
  String get admin_dashboardThisMonth => 'This Month';

  @override
  String get admin_dashboardCustom => 'Custom';

  @override
  String get admin_dashboardTimePeriod => 'Time Period';

  @override
  String get admin_dashboardRetry => 'Retry';

  @override
  String get admin_dashboardComingSoon => 'Coming soon';

  @override
  String get admin_dashboardActiveMembers => 'Active Members';

  @override
  String get admin_dashboardDueSoon => 'Due soon';

  @override
  String get admin_dashboardPendingRenewals => 'Pending Renewals';

  @override
  String get admin_dashboardLiveNow => 'Live now';

  @override
  String get admin_dashboardTodayCheckins => 'Today\'s Check-ins';

  @override
  String get admin_dashboardSessions => 'Sessions';

  @override
  String get admin_dashboardUpcomingPt => 'Upcoming PT';

  @override
  String get admin_dashboardQuickActions => 'Quick Actions';

  @override
  String get admin_dashboardAddMember => 'Add Member';

  @override
  String get admin_dashboardRecordPayment => 'Record Payment';

  @override
  String get admin_dashboardAddPlan => 'Add Plan';

  @override
  String get admin_dashboardSendAnnouncement => 'Send Announcement';

  @override
  String get admin_dashboardRecentActivity => 'Recent Activity';

  @override
  String get admin_dashboardViewAll => 'View all';

  @override
  String get admin_dashboardNoActivity => 'No recent activity';

  @override
  String get admin_dashboardAttendance => 'Attendance';

  @override
  String get admin_dashboardPaymentsCollected => 'Payments Collected';

  @override
  String get admin_dashboardExpiringPlans => 'Expiring Plans';

  @override
  String get admin_dashboardNext7Days => 'Next 7 days';

  @override
  String get admin_dashboardTotalMembersLabel => 'Total Members';

  @override
  String get admin_dashboardTotalPlans => 'Total Plans';

  @override
  String get admin_dashboardCanceled => 'Canceled';

  @override
  String get admin_dashboardLast7Days => 'Last 7 days';

  @override
  String get admin_dashboardChurnRate => 'Churn Rate';

  @override
  String get admin_dashboardMonthlyRevenue => 'Monthly Revenue';

  @override
  String get admin_membersTitle => 'Members';

  @override
  String get admin_memberDetailTitle => 'Member Detail';

  @override
  String get admin_memberNoFound => 'No members found.';

  @override
  String get admin_memberRetry => 'Retry';

  @override
  String get admin_memberPlan => 'Plan';

  @override
  String get admin_memberDueAmount => 'Due Amount';

  @override
  String get admin_memberExpiry => 'Expiry';

  @override
  String get admin_memberBranch => 'Branch';

  @override
  String get admin_memberWhatsApp => 'WhatsApp';

  @override
  String get admin_memberAttendance => 'Attendance';

  @override
  String get admin_memberRenew => 'Renew';

  @override
  String get admin_memberPlanRenewal => 'Plan Renewal';

  @override
  String get admin_memberUnblock => 'Unblock';

  @override
  String get admin_memberBlock => 'Block';

  @override
  String get admin_memberDelete => 'Delete';

  @override
  String get admin_memberEdit => 'Edit';

  @override
  String get admin_memberEditTitle => 'Edit Member';

  @override
  String get admin_memberBlockTitle => 'Block Member';

  @override
  String get admin_memberBlockReasonHint => 'Enter reason for blocking';

  @override
  String get admin_memberDeleteTitle => 'Delete Member';

  @override
  String admin_memberDeleteConfirm(String name) {
    return 'Permanently delete $name? This cannot be undone.';
  }

  @override
  String get admin_memberCancel => 'Cancel';

  @override
  String get admin_memberActive => 'Active';

  @override
  String get admin_memberPending => 'Pending';

  @override
  String get admin_memberBlocked => 'Blocked';

  @override
  String get admin_memberNoPlan => 'No Plan';

  @override
  String get admin_memberInactive => 'Inactive';

  @override
  String get admin_memberAllStatus => 'All Status';

  @override
  String get admin_memberNewest => 'Newest';

  @override
  String get admin_memberOldest => 'Oldest';

  @override
  String get admin_memberAlphabetical => 'Alphabetical';

  @override
  String get admin_memberAllGender => 'All Gender';

  @override
  String get admin_memberMale => 'Male';

  @override
  String get admin_memberFemale => 'Female';

  @override
  String get admin_memberOther => 'Other';

  @override
  String get admin_memberSearchHint => 'Search by Name, Phone, Member Code';

  @override
  String get admin_membershipPackageTitle => 'Membership Package';

  @override
  String get admin_memberPlanName => 'Plan Name';

  @override
  String get admin_memberTotalAmount => 'Total Amount';

  @override
  String get admin_memberDiscount => 'Discount';

  @override
  String get admin_memberPurchaseDate => 'Purchase Date';

  @override
  String get admin_memberPaidAmount => 'Paid Amount';

  @override
  String get admin_memberDueAmountLabel => 'Due Amount';

  @override
  String get admin_memberRemainingDays => 'Remaining Days';

  @override
  String get admin_memberQuickActions => 'Quick Actions';

  @override
  String get admin_memberCall => 'Call';

  @override
  String get admin_memberSms => 'SMS';

  @override
  String get admin_memberRenewPlan => 'Renew Plan';

  @override
  String get admin_plansTitle => 'Plans';

  @override
  String get admin_plansDeleteTitle => 'Delete Plan';

  @override
  String get admin_plansDeleteConfirm => 'Are you sure you want to delete this plan?';

  @override
  String get admin_plansCancel => 'Cancel';

  @override
  String get admin_plansDelete => 'Delete';

  @override
  String get admin_plansRetry => 'Retry';

  @override
  String get admin_plansAllTypes => 'All Types';

  @override
  String get admin_plansSearch => 'Search plans...';

  @override
  String get admin_plansNoFound => 'No plans found';

  @override
  String get admin_planActive => 'Active';

  @override
  String get admin_planInactive => 'Inactive';

  @override
  String get admin_planPrice => 'Price';

  @override
  String get admin_planDurationLabel => 'Duration';

  @override
  String get admin_planMembersLabel => 'Members';

  @override
  String get admin_planVisitLimitLabel => 'Visit Limit';

  @override
  String get admin_planUnlimitedLabel => 'Unlimited';

  @override
  String get admin_planAvailableAt => 'Available at:';

  @override
  String get admin_planEdit => 'Edit';

  @override
  String get admin_planDeleting => 'Deleting...';

  @override
  String get admin_planDeleteLabel => 'Delete';

  @override
  String get admin_planOneTime => 'One time';

  @override
  String get admin_planEditTitle => 'Edit Plan';

  @override
  String get admin_planAddTitle => 'Add New Plan';

  @override
  String get admin_planNameField => 'Plan Name *';

  @override
  String get admin_planTypeField => 'Type / Activity *';

  @override
  String get admin_planSelectType => 'Select type';

  @override
  String get admin_planPriceField => 'Price *';

  @override
  String get admin_planDurationField => 'Duration *';

  @override
  String get admin_planSelectDuration => 'Select duration';

  @override
  String get admin_planDescription => 'Description';

  @override
  String get admin_planOptionalDesc => 'Optional description';

  @override
  String get admin_planPromotion => 'Promotion';

  @override
  String get admin_planStatus => 'Status *';

  @override
  String get admin_planSelectStatus => 'Select status';

  @override
  String get admin_planAvailableBranches => 'Available Branches *';

  @override
  String get admin_planSelectBranch => 'Select branch';

  @override
  String get admin_planMultiSelectNote => 'Note: Multi-select support coming soon';

  @override
  String get admin_planSaveChanges => 'Save Changes';

  @override
  String get admin_planCreateLabel => 'Create Plan';

  @override
  String get admin_planRequired => 'Required';

  @override
  String get admin_planEnterValidNumber => 'Enter a valid number';

  @override
  String get admin_planTotalPlans => 'Total Plans';

  @override
  String get admin_planTotalMembersLabel => 'Members';

  @override
  String get admin_planActiveCount => 'Active';

  @override
  String get admin_planCreatedSuccess => 'Plan created successfully';

  @override
  String get admin_planUpdatedSuccess => 'Plan updated successfully';

  @override
  String get admin_trainerDashboardTitle => 'Trainer Dashboard';

  @override
  String get admin_trainerTodaySessions => 'Today Sessions';

  @override
  String get admin_trainerCompleted => 'Completed';

  @override
  String get admin_trainerUpcoming => 'Upcoming';

  @override
  String get admin_trainerCancelledNoShow => 'Cancelled / No-Show';

  @override
  String get admin_trainerTodaySchedule => 'Today\'s Schedule';

  @override
  String get admin_trainerNoSessionsToday => 'No sessions scheduled for today.';

  @override
  String get admin_trainerPtSession => 'PT Session';

  @override
  String get admin_trainerCheckIn => 'Check In';

  @override
  String get admin_trainerComplete => 'Complete';

  @override
  String get admin_trainerCreatePackage => 'Create Package';

  @override
  String get admin_trainerAddAvailability => 'Add Availability';

  @override
  String get admin_trainerAddPtService => 'Add PT Service';

  @override
  String get admin_trainerCreateSession => 'Create Session';

  @override
  String get admin_trainerQuickActionsTitle => 'Quick Actions';

  @override
  String get admin_trainerUpcomingClients => 'Upcoming Clients';

  @override
  String get admin_trainerViewAll => 'View All';

  @override
  String get admin_trainerNoUpcomingClients => 'No upcoming clients.';

  @override
  String get admin_trainerMainDashboard => 'Dashboard';

  @override
  String get admin_trainerMainSessions => 'Sessions';

  @override
  String get admin_trainerMainPackages => 'Packages';

  @override
  String get admin_trainerMainSchedule => 'Schedule';

  @override
  String get admin_trainerMainMore => 'More';

  @override
  String get admin_trainerLoading => 'Loading trainers…';

  @override
  String get admin_packagesTitle => 'Packages';

  @override
  String get admin_packagesNew => 'New Package';

  @override
  String get admin_packagesActive => 'Active';

  @override
  String get admin_packagesSessions => 'Sessions';

  @override
  String get admin_packagesDaysWeek => 'Days/Week';

  @override
  String get admin_packagesDays => 'Days';

  @override
  String get admin_packagesEditTitle => 'Edit Package';

  @override
  String get admin_packagesCreateTitle => 'Create PT Package';

  @override
  String get admin_packagesBack => 'Back';

  @override
  String get admin_packagesCreate => 'Create Package';

  @override
  String get admin_packagesContinue => 'Continue';

  @override
  String get admin_packagesBasicInfo => 'Basic\nInfo';

  @override
  String get admin_packagesTrainingRules => 'Training\nRules';

  @override
  String get admin_packagesPricing => 'Pricing';

  @override
  String get admin_packagesPreview => 'Preview';

  @override
  String get admin_packagesName => 'Package Name';

  @override
  String get admin_packagesType => 'Package Type';

  @override
  String get admin_packagesSelectType => 'Select type';

  @override
  String get admin_packagesWeightLoss => 'Weight Loss';

  @override
  String get admin_packagesStrength => 'Strength Building';

  @override
  String get admin_packagesCardio => 'Cardio';

  @override
  String get admin_packagesGeneral => 'General Fitness';

  @override
  String get admin_packagesLinkedService => 'Linked PT Service';

  @override
  String get admin_packagesSelectService => 'Select service';

  @override
  String get admin_packagesPersonalTraining => 'Personal Training';

  @override
  String get admin_packagesStrengthTraining => 'Strength Training';

  @override
  String get admin_packagesWeightLossProgram => 'Weight Loss Program';

  @override
  String get admin_packagesTotalSessions => 'Total Sessions';

  @override
  String get admin_packagesMinDays => 'Min Days/Week';

  @override
  String get admin_packagesMaxDays => 'Max Days/Week';

  @override
  String get admin_packagesValidity => 'Validity (Days)';

  @override
  String get admin_packagesRegularPrice => 'Regular Price (\$)';

  @override
  String get admin_packagesSalePrice => 'Sale Price (\$) - Optional';

  @override
  String get admin_packagesSummary => 'Package Summary';

  @override
  String get admin_packagesNameLabel => 'Name:';

  @override
  String get admin_packagesSessionsLabel => 'Sessions:';

  @override
  String get admin_packagesFrequency => 'Frequency:';

  @override
  String get admin_packagesValidityLabel => 'Validity:';

  @override
  String get admin_packagesNaDays => 'N/A days';

  @override
  String get admin_packagesPriceLabel => 'Price:';

  @override
  String get admin_sessionsTitle => 'Sessions';

  @override
  String get admin_sessionsBook => 'Book Session';

  @override
  String get admin_sessionCancelled => 'Session cancelled.';

  @override
  String get admin_sessionNoShow => 'Session marked as no-show.';

  @override
  String get admin_sessionUpdated => 'Session updated.';

  @override
  String get admin_sessionFilterToday => 'Today';

  @override
  String get admin_sessionFilterUpcoming => 'Upcoming';

  @override
  String get admin_sessionFilterCompleted => 'Completed';

  @override
  String get admin_sessionNoSessionsToday => 'No sessions scheduled for today.';

  @override
  String get admin_sessionNoUpcoming => 'No upcoming sessions.';

  @override
  String get admin_sessionNoCompleted => 'No completed sessions yet.';

  @override
  String get admin_sessionRetry => 'Retry';

  @override
  String get admin_sessionCardPt => 'PT Session';

  @override
  String get admin_sessionCardComplete => 'Complete';

  @override
  String get admin_sessionCardCancel => 'Cancel';

  @override
  String get admin_sessionCardCancelTitle => 'Cancel Session';

  @override
  String get admin_sessionCardCancelConfirm => 'Are you sure you want to cancel this session?';

  @override
  String get admin_sessionCardKeep => 'Keep';

  @override
  String get admin_sessionCardProgress => 'Session Progress';

  @override
  String get admin_scheduleTitle => 'Availability';

  @override
  String get admin_scheduleAddSlot => 'Add Slot';

  @override
  String get admin_scheduleNoAvailability => 'No availability set yet.';

  @override
  String get admin_scheduleMonday => 'Monday';

  @override
  String get admin_scheduleTuesday => 'Tuesday';

  @override
  String get admin_scheduleWednesday => 'Wednesday';

  @override
  String get admin_scheduleThursday => 'Thursday';

  @override
  String get admin_scheduleFriday => 'Friday';

  @override
  String get admin_scheduleSaturday => 'Saturday';

  @override
  String get admin_scheduleSunday => 'Sunday';

  @override
  String get admin_scheduleRecurring => 'Recurring weekly';

  @override
  String get admin_scheduleAddAvailability => 'Add Availability';

  @override
  String get admin_scheduleDayOfWeek => 'Day of Week';

  @override
  String get admin_scheduleSelectDay => 'Select day';

  @override
  String get admin_scheduleStartTime => 'Start Time';

  @override
  String get admin_scheduleEndTime => 'End Time';

  @override
  String get admin_scheduleRecurringWeekly => 'Recurring Weekly';

  @override
  String get admin_scheduleRepeatHint => 'Repeat this slot every week';

  @override
  String get admin_scheduleCancel => 'Cancel';

  @override
  String get admin_servicesTitle => 'Services';

  @override
  String get admin_servicesNew => 'New Service';

  @override
  String get admin_servicesGeneral => 'General';

  @override
  String get admin_servicesSpecialized => 'Specialized';

  @override
  String get admin_servicesElite => 'Elite';

  @override
  String get admin_servicesActive => 'Active';

  @override
  String get admin_servicesEditTitle => 'Edit Service';

  @override
  String get admin_servicesCreateTitle => 'Create PT Service';

  @override
  String get admin_servicesName => 'Service Name';

  @override
  String get admin_servicesCategory => 'Category';

  @override
  String get admin_servicesDuration => 'Duration (min)';

  @override
  String get admin_servicesPrice => 'Price (\$)';

  @override
  String get admin_servicesDescription => 'Description';

  @override
  String get admin_servicesDescHint => 'Describe the service...';

  @override
  String get admin_servicesCancel => 'Cancel';

  @override
  String get admin_servicesCreate => 'Create Service';

  @override
  String get admin_bookSessionTitle => 'Book Session';

  @override
  String get admin_bookSelectTime => 'Please select start and end time.';

  @override
  String get admin_bookInvalidMember => 'Invalid Member ID.';

  @override
  String get admin_bookMemberId => 'Member ID';

  @override
  String get admin_bookMemberIdHint => 'Enter a valid member ID';

  @override
  String get admin_bookServiceId => 'Service ID (optional)';

  @override
  String get admin_bookStartTime => 'Start Time';

  @override
  String get admin_bookEndTime => 'End Time';

  @override
  String get admin_bookNotes => 'Notes (optional)';

  @override
  String get admin_settingsTitle => 'Settings';

  @override
  String get admin_settingsUnsaved => 'Unsaved';

  @override
  String get admin_settingsSearch => 'Search settings...';

  @override
  String get admin_settingsSaved => 'Settings saved successfully';

  @override
  String get admin_settingsSaveFailed => 'Failed to save settings';

  @override
  String get admin_settingsSaving => 'Saving...';

  @override
  String get admin_settingsSave => 'Save Changes';

  @override
  String get admin_settingsLegal => 'Legal & Policies';

  @override
  String get admin_settingsLegalReview => 'Review our policies';

  @override
  String get admin_settingsAccountSecurity => 'Account & Security';

  @override
  String get admin_settingsAccountSecuritySub => 'Manage your account security';

  @override
  String get admin_settingsChangePassword => 'Change Password';

  @override
  String get admin_settingsChangePasswordSub => 'Update your account password';

  @override
  String get admin_settingsBiometric => 'Biometric Login';

  @override
  String get admin_settingsBiometricSub => 'Use fingerprint or face ID';

  @override
  String get admin_settings2fa => 'Two-Factor Authentication';

  @override
  String get admin_settings2faSub => 'Add an extra layer of security';

  @override
  String get admin_settingsBusinessRules => 'Business Rules';

  @override
  String get admin_settingsAdminOnly => 'Admin Only';

  @override
  String get admin_settingsBusinessRulesSub => 'Configure membership & class logic';

  @override
  String get admin_settingsSubscriptionRules => 'Subscription Rules';

  @override
  String get admin_settingsRule1Title => 'Allow class subscription without membership';

  @override
  String get admin_settingsRule1Sub => 'Users can join classes without buying a plan';

  @override
  String get admin_settingsRule2Title => 'Require membership for class subscription';

  @override
  String get admin_settingsRule2Sub => 'Users must have an active membership to subscribe to classes';

  @override
  String get admin_settingsRule3Title => 'Allow membership without class enrollment';

  @override
  String get admin_settingsRule3Sub => 'Members can purchase plans without enrolling in any class';

  @override
  String get admin_settingsRule4Title => 'Allow both independently';

  @override
  String get admin_settingsRule4Sub => 'Memberships and classes can be purchased separately';

  @override
  String get admin_settingsOwnerOnly => 'Only the owner can change business rules';

  @override
  String get admin_settingsDangerZone => 'Danger Zone';

  @override
  String get admin_settingsDangerSub => 'Irreversible actions';

  @override
  String get admin_settingsLogOut => 'Log Out';

  @override
  String get admin_settingsDeleteAccount => 'Delete Account';

  @override
  String get admin_settingsLogOutTitle => 'Log Out';

  @override
  String get admin_settingsLogOutConfirm => 'Are you sure you want to log out?';

  @override
  String get admin_settingsCancel => 'Cancel';

  @override
  String get admin_settingsDeleteTitle => 'Delete Account';

  @override
  String get admin_settingsDeleteMsg1 => 'This will permanently delete your account. ';

  @override
  String get admin_settingsDeleteMsg2 => 'This action cannot be undone.';

  @override
  String admin_settingsDeleteFailed(String error) {
    return 'Failed to delete account: $error';
  }

  @override
  String get admin_staffTitle => 'Staff';

  @override
  String get admin_staffRetry => 'Retry';

  @override
  String get admin_staffNoFound => 'No staff members found.';

  @override
  String get admin_staffAdded => 'Staff member added successfully';

  @override
  String get admin_staffUpdated => 'Staff member updated successfully';

  @override
  String get admin_staffRemoved => 'Staff member removed successfully';

  @override
  String get admin_staffDone => 'Action completed successfully';

  @override
  String get admin_staffReception => 'Reception';

  @override
  String get admin_staffAdmin => 'Admin';

  @override
  String get admin_staffAssistant => 'Assistant';

  @override
  String get admin_staffEditTitle => 'Edit Staff Member';

  @override
  String get admin_staffAddTitle => 'Add New Staff Member';

  @override
  String get admin_staffAddDesc => 'Fill in the details to add a new\nreception staff member to your gym';

  @override
  String get admin_staffPersonalInfo => 'Personal Information';

  @override
  String get admin_staffFullName => 'Full Name';

  @override
  String get admin_staffFullNameHint => 'Enter full name';

  @override
  String get admin_staffFullNameRequired => 'Full name is required';

  @override
  String get admin_staffEmail => 'Email Address';

  @override
  String get admin_staffEmailRequired => 'Email is required';

  @override
  String get admin_staffEmailInvalid => 'Enter a valid email address';

  @override
  String get admin_staffPhone => 'Phone Number';

  @override
  String get admin_staffPhoneRequired => 'Phone number is required';

  @override
  String get admin_staffRole => 'Role';

  @override
  String get admin_staffSelectRole => 'Select role';

  @override
  String get admin_staffRoleRequired => 'Role is required';

  @override
  String get admin_staffBranchAssignment => 'Branch Assignment';

  @override
  String get admin_staffSelectBranch => 'Select branch';

  @override
  String get admin_staffBranchRequired => 'Branch is required';

  @override
  String get admin_staffPassword => 'Password';

  @override
  String get admin_staffPasswordHint => 'Auto-generate or enter';

  @override
  String get admin_staffPasswordNote => 'Leave empty to auto-generate a secure password';

  @override
  String get admin_staffCancel => 'Cancel';

  @override
  String get admin_staffSaveChanges => 'Save Changes';

  @override
  String get admin_staffAddMember => 'Add Staff Member';

  @override
  String get admin_staffEditProfile => 'Edit Profile';

  @override
  String get admin_staffRemove => 'Remove';

  @override
  String get admin_staffRemoveTitle => 'Remove Staff Member';

  @override
  String admin_staffRemoveConfirm(String name) {
    return 'Are you sure you want to remove $name? ';
  }

  @override
  String get admin_staffCannotUndo => 'This action cannot be undone.';

  @override
  String get admin_staffTotalLabel => 'Total Staff';

  @override
  String get admin_staffActiveLabel => 'Active';

  @override
  String get admin_staffSearchHint => 'Search staff by name';

  @override
  String get admin_trainersTitle => 'Trainers / PT';

  @override
  String get admin_trainersLoading => 'Loading trainer form options...';

  @override
  String get admin_trainersFormNotReady => 'Trainer form options are not ready yet';

  @override
  String get admin_trainersNoFound => 'No trainers found';

  @override
  String get admin_trainerAdded => 'Trainer added successfully ✓';

  @override
  String get admin_trainerUpdatedSuccess => 'Trainer updated ✓';

  @override
  String get admin_trainerBlockedSuccess => 'Trainer blocked';

  @override
  String get admin_trainerUnblockedSuccess => 'Trainer unblocked ✓';

  @override
  String get admin_trainerActionDone => 'Done';

  @override
  String get admin_trainersRetry => 'Retry';

  @override
  String get admin_trainerSelectBranch => 'Please select a branch';

  @override
  String get admin_trainerEditTitle => 'Edit Trainer';

  @override
  String get admin_trainerAddTitle => 'Add New Trainer';

  @override
  String get admin_trainerFullName => 'Full Name *';

  @override
  String get admin_trainerFullNameHint => 'Enter full name';

  @override
  String get admin_trainerRequired => 'Required';

  @override
  String get admin_trainerEmail => 'Email';

  @override
  String get admin_trainerEmailInvalid => 'Invalid email';

  @override
  String get admin_trainerPhone => 'Phone Number';

  @override
  String get admin_trainerPassword => 'Password *';

  @override
  String get admin_trainerMinChars => 'Min 6 characters';

  @override
  String get admin_trainerSpecialties => 'Specialties';

  @override
  String get admin_trainerBranchAssignment => 'Branch Assignment *';

  @override
  String get admin_trainerSelectBranchHint => 'Select branch';

  @override
  String get admin_trainerExperience => 'Years of Experience';

  @override
  String get admin_trainerNotesBio => 'Notes / Bio';

  @override
  String get admin_trainerNotesBioHint => 'Optional bio or notes';

  @override
  String get admin_trainerAvailability => 'Availability Schedule';

  @override
  String get admin_trainerAddSlot => 'Add Slot';

  @override
  String get admin_trainerNoSlots => 'No availability slots yet.';

  @override
  String get admin_trainerCancel => 'Cancel';

  @override
  String get admin_trainerSaveChanges => 'Save Changes';

  @override
  String get admin_trainerSave => 'Save Trainer';

  @override
  String get admin_trainerSpecialtyHint => 'Type a specialty and press + or Enter to add';

  @override
  String get admin_trainerUnblockConfirm => 'They will be able to log in again.';

  @override
  String get admin_trainerBlockConfirm => 'They will not be able to log in.';

  @override
  String get admin_trainerUnblockTitle => 'Unblock';

  @override
  String get admin_trainerBlockTitle => 'Block';

  @override
  String get admin_trainerCancelAction => 'Cancel';

  @override
  String get admin_trainerBlockedStatus => 'Blocked';

  @override
  String get admin_trainerActiveStatus => 'Active';

  @override
  String get admin_trainerScheduleLabel => 'Schedule';

  @override
  String get admin_trainerEditLabel => 'Edit';

  @override
  String get admin_trainerSearchHint => 'Search by name or specialty';

  @override
  String get admin_videoNewCategory => 'New Category';

  @override
  String get admin_videoCategoryName => 'Category name';

  @override
  String get admin_videoCancel => 'Cancel';

  @override
  String get admin_videoSelectCategory => 'Please select or create a category';

  @override
  String get admin_videoDurationInvalid => 'Duration must be greater than 0';

  @override
  String get admin_videoAdded => 'Video added successfully';

  @override
  String admin_videoCategoryCreated(String name) {
    return 'Category \"$name\" created and selected';
  }

  @override
  String admin_videoFailed(String message) {
    return 'Failed: $message';
  }

  @override
  String get admin_videoAddTitle => 'Add Training Video';

  @override
  String get admin_videoTitleField => 'Title *';

  @override
  String get admin_videoTitleRequired => 'Title is required';

  @override
  String get admin_videoDescriptionField => 'Description (optional)';

  @override
  String get admin_videoCategoryField => 'Category *';

  @override
  String get admin_videoSelectCategoryHint => 'Select a category';

  @override
  String get admin_videoSelectCategoryRequired => 'Please select a category';

  @override
  String get admin_videoAddNewCategory => 'Add new category';

  @override
  String get admin_videoAssignTrainer => 'Assign to Trainer *';

  @override
  String get admin_videoSelectTrainer => 'Select a trainer';

  @override
  String get admin_videoTrainerRequired => 'Please assign a trainer';

  @override
  String get admin_videoPickFromPhone => 'Pick Video From Phone';

  @override
  String get admin_videoDurationField => 'Duration *';

  @override
  String get admin_videoMinutes => 'Minutes';

  @override
  String get admin_videoRequired => 'Required';

  @override
  String get admin_videoInvalid => 'Invalid';

  @override
  String get admin_videoSeconds => 'Seconds';

  @override
  String get admin_videoPublished => 'Published';

  @override
  String get admin_videoVisibleToMembers => 'Visible to members immediately';

  @override
  String get admin_videoAdd => 'Add Video';

  @override
  String get admin_videoListTitle => 'Training Videos';

  @override
  String get admin_videoRetry => 'Retry';

  @override
  String get admin_videoTotalVideos => 'Total Videos';

  @override
  String get admin_videoTotalViews => 'Total Views';

  @override
  String get admin_videoNoVideos => 'No videos found.';

  @override
  String get admin_videoAllCategories => 'All Categories';

  @override
  String get admin_videoCategory => 'Category';
}
