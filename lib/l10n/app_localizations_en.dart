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
  String get common_or => 'Or';

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
  String get mostPopular => 'Most Popular';

  @override
  String get selectThisPlan => 'Choose this plan';

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
  String get membershipStatusActive => 'Active Membership';

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
  String get selectedPlan => 'Selected plan';

  @override
  String get baseAmount => 'Base amount';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get planDetails => 'Plan details';

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
  String get sessionDetailMembershipRequired => 'Membership Required';

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
  String get navMembershipRequests => 'Membership Requests';

  @override
  String get navInvoices => 'Invoices';

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
  String get navPtPackageBookings => 'PT Package Payments';

  @override
  String get ptPkgPayments_cashTab => 'Cash Payments';

  @override
  String get ptPkgPayments_refundTab => 'Refund Requests';

  @override
  String get ptPkgPayments_noPendingRefunds => 'No pending PT package refund requests';

  @override
  String get ptPkgPayments_noPendingRefundsDesc => 'PT package refund requests will appear here';

  @override
  String get ptPkgPayments_refundBadge => 'PT Refund';

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
  String get accountGender => 'Gender';

  @override
  String get accountGenderMale => 'Male';

  @override
  String get accountGenderFemale => 'Female';

  @override
  String accountMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get accountMyInfo => 'My Info';

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
  String get ptRequestTimePickerHint => 'Request a time from the trainer';

  @override
  String get ptTimeRequestSuccess => 'Your time request has been sent to the trainer.';

  @override
  String get ptTimeRequestFailed => 'Could not send time request. Please try again.';

  @override
  String get ptBookingRequestSuccess => 'Request sent to PT. Waiting for approval.';

  @override
  String get ptBookingRequestThisTime => 'Request this time';

  @override
  String get ptBookingBookSession => 'Book session';

  @override
  String get ptBookingRequestNote => 'Member requested unavailable/full PT time';

  @override
  String get ptBookingFullOrUnavailable => 'This slot is full or unavailable. Send a request instead.';

  @override
  String get ptBookingFailed => 'Unable to confirm booking.';

  @override
  String get ptBookingRequestFailed => 'Unable to send request.';

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
  String get memberQrTitle => 'Entry QR Code';

  @override
  String get memberQrSubtitle => 'Scan this code at the gym entrance';

  @override
  String get memberQrActiveMembership => 'Active membership';

  @override
  String get memberQrInactiveMembership => 'Inactive membership';

  @override
  String get memberQrMemberCodeLabel => 'Member code';

  @override
  String get memberQrPackageFallback => 'No package';

  @override
  String get memberQrValidUntil => 'Valid until';

  @override
  String get memberQrExpiresSoon => 'QR expires soon';

  @override
  String get memberQrRecentVisits => 'Recent visits';

  @override
  String get memberQrNoRecentVisits => 'No previous visits';

  @override
  String get memberQrDurationLabel => 'Duration';

  @override
  String get memberQrToday => 'Today';

  @override
  String get memberQrYesterday => 'Yesterday';

  @override
  String memberQrMinute(int count) {
    return '$count min';
  }

  @override
  String memberQrHour(String count) {
    return '$count h';
  }

  @override
  String get memberQrLoadError => 'Could not load QR data';

  @override
  String get memberQrRetry => 'Retry';

  @override
  String get myInfoTitle => 'My Info';

  @override
  String get myInfoSubtitle => 'Update your gym profile information';

  @override
  String get myInfoPreferredBranch => 'Preferred Branch';

  @override
  String get myInfoSelectBranch => 'Select branch';

  @override
  String get myInfoGender => 'Gender';

  @override
  String get myInfoGenderMale => 'Male';

  @override
  String get myInfoGenderFemale => 'Female';

  @override
  String get myInfoGenderOther => 'Other';

  @override
  String get myInfoGenderPreferNotToSay => 'Prefer not to say';

  @override
  String get myInfoAddress => 'Address';

  @override
  String get myInfoAddressHint => 'Enter your address';

  @override
  String get myInfoDateOfBirth => 'Date of Birth';

  @override
  String get myInfoSelectDateOfBirth => 'Select date of birth';

  @override
  String get myInfoHeightCm => 'Height (cm)';

  @override
  String get myInfoWeightKg => 'Weight (kg)';

  @override
  String get myInfoEmergencyContactName => 'Emergency Contact Name';

  @override
  String get myInfoEmergencyContactPhone => 'Emergency Contact Phone';

  @override
  String get myInfoFullNameHint => 'Full name';

  @override
  String get myInfoPhoneNumberHint => 'Phone number';

  @override
  String get myInfoSaveChanges => 'Save Changes';

  @override
  String get myInfoUpdatedSuccessfully => 'My Info updated successfully';

  @override
  String get myInfoLoadError => 'Failed to load your info. Please try again.';

  @override
  String get myInfoSaveError => 'Failed to save your info. Please try again.';

  @override
  String get myInfoRequiredError => 'Preferred branch, gender and date of birth are required.';

  @override
  String get aiHeroBannerTitle => 'AI Insights Assistant';

  @override
  String get aiHeroBannerSubtitle => 'Ask me anything about your gym';

  @override
  String get aiHeroBannerBody => 'Get instant analytics, insights and recommendations\nbased on your gym data.';

  @override
  String get aiSuggestedQuestionsHeader => 'Suggested questions';

  @override
  String get aiAppBarTitle => 'AI Insights Assistant';

  @override
  String get aiNewConversationTooltip => 'New conversation';

  @override
  String get aiInputHint => 'Ask a question about your gym...';

  @override
  String get aiRetryButton => 'Retry';

  @override
  String get aiFollowUpHeader => 'You might also ask:';

  @override
  String get aiRecentQueriesHeader => 'Recent queries';

  @override
  String get aiRecentQueryViewLabel => 'View';

  @override
  String get aiErrorOffline => 'Sorry, I couldn\'t process your request. Please try again.';

  @override
  String get checkins_title => 'Check-ins';

  @override
  String get checkins_scanQr => 'Scan QR';

  @override
  String get checkins_scanSuccessMsg => 'checked in successfully';

  @override
  String get checkins_scannerTitle => 'Scan Member QR';

  @override
  String get checkins_activeNow => 'Active Now';

  @override
  String get checkins_totalToday => 'Total Today';

  @override
  String get checkins_todayTitle => 'Today\'s Check-ins';

  @override
  String get checkins_noCheckins => 'No check-ins today';

  @override
  String get checkins_searchHint => 'Search members...';

  @override
  String get aiErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get checkins_active => 'Active';

  @override
  String get checkins_checkedOut => 'Checked Out';

  @override
  String get checkins_out => 'Out';

  @override
  String get checkins_freeze => 'Freeze';

  @override
  String get checkins_block => 'Block';

  @override
  String get checkins_call => 'Call';

  @override
  String get checkins_freezeTitle => 'Freeze Membership';

  @override
  String get checkins_fromDate => 'From date';

  @override
  String get checkins_toDate => 'To date';

  @override
  String get checkins_reasonHint => 'Reason (optional)';

  @override
  String get checkins_confirm => 'Confirm';

  @override
  String get checkins_blockTitle => 'Block Member';

  @override
  String get checkins_cancel => 'Cancel';

  @override
  String get checkins_blockConfirm => 'Block';

  @override
  String get sessionDetailBookingClosed => 'Booking closed';

  @override
  String get booked => 'Booked';

  @override
  String get noActiveMembership => 'No active membership';

  @override
  String get membershipStatusCancelled => 'cancelled';

  @override
  String get editProfileVerifyNewPhone => 'Verify new phone number';

  @override
  String get editProfilePhoneVerified => 'Phone number verified successfully';

  @override
  String get memberBookingsTitle => 'My Bookings';

  @override
  String get memberBookingsSubtitle => 'Your classes and PT sessions';

  @override
  String get memberBookingsUpcomingTab => 'Upcoming';

  @override
  String get memberBookingsPreviousTab => 'Previous';

  @override
  String get memberBookingsEmptyUpcoming => 'No upcoming bookings';

  @override
  String get memberBookingsEmptyPrevious => 'No previous bookings';

  @override
  String get memberBookingsLoadFailed => 'Failed to load bookings';

  @override
  String get memberBookingsCancelRequestSent => 'Cancel request sent';

  @override
  String get memberBookingsCancelRequestFailed => 'Failed to send cancel request';

  @override
  String get memberBookingsCancelButton => 'Cancel booking';

  @override
  String get memberBookingsReviewButton => 'Rate session';

  @override
  String get memberBookingsCancelPending => 'Cancel request pending';

  @override
  String get memberBookingsClassDefaultTitle => 'Class session';

  @override
  String get memberBookingsPtDefaultTitle => 'PT session';

  @override
  String memberBookingsSessionProgress(int current, int total) {
    return 'Session $current of $total';
  }

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusWaitlisted => 'Waitlisted';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusCancelRequested => 'Cancel request pending';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusUnknown => 'Unknown';

  @override
  String memberBookingsMinutes(int count) {
    return '$count min';
  }

  @override
  String get memberBookingsRatingTitle => 'Your opinion matters to us';

  @override
  String get memberBookingsRatingLabelLow => 'Terrible';

  @override
  String get memberBookingsRatingLabelHigh => 'Excellent';

  @override
  String get memberBookingsRateNowButton => 'Rate Now';

  @override
  String get memberBookingsReviewSubmitted => 'Thank you for your review!';

  @override
  String get memberBookingsReviewFailed => 'Failed to submit review. Please try again.';

  @override
  String get memberBookingsCancelOptionsTitle => 'Session Options';

  @override
  String get memberBookingsCancelOnlyOption => 'Cancel session';

  @override
  String get memberBookingsCancelOnlyDesc => 'Cancel this session without rescheduling';

  @override
  String get memberBookingsRescheduleOption => 'Request reschedule';

  @override
  String get memberBookingsRescheduleDesc => 'Cancel and propose a new date';

  @override
  String get memberBookingsSelectNewDate => 'Select preferred date';

  @override
  String get memberBookingsRescheduleRequestSent => 'Reschedule request sent';

  @override
  String get memberInvoicesTitle => 'Payment History';

  @override
  String get memberInvoicesEmptyTitle => 'No payments found';

  @override
  String get memberInvoicesEmptySubtitle => 'Your completed payments will appear here.';

  @override
  String get memberInvoicesRetry => 'Retry';

  @override
  String get memberInvoicesAll => 'All';

  @override
  String get memberInvoicesAllTypes => 'All Types';

  @override
  String get memberInvoicesStatusPaid => 'Paid';

  @override
  String get memberInvoicesStatusPending => 'Pending';

  @override
  String get memberInvoicesStatusRefunded => 'Refunded';

  @override
  String get memberInvoicesStatusCancelled => 'Cancelled';

  @override
  String get memberInvoicesStatusRejected => 'Rejected';

  @override
  String get memberInvoicesStatusFailed => 'Failed';

  @override
  String get memberInvoicesStatusUnknown => 'Unknown';

  @override
  String get memberInvoicesTypePlans => 'Plans';

  @override
  String get memberInvoicesTypeClasses => 'Classes';

  @override
  String get memberInvoicesTypePt => 'PT';

  @override
  String get memberInvoicesTypePtPackage => 'PT Package';

  @override
  String get memberInvoicesTypeDailyPass => 'Daily Pass';

  @override
  String get memberInvoicesTypeOther => 'Other';

  @override
  String get memberInvoicesDetails => 'View Details';

  @override
  String get memberInvoicesRefund => 'Refund';

  @override
  String get memberInvoicesRefundTitle => 'Refund Request';

  @override
  String get memberInvoicesRefundMessage => 'A refund request will be sent to the admin. The amount will not be refunded immediately.';

  @override
  String get memberInvoicesRefundReason => 'Reason optional';

  @override
  String get memberInvoicesRefundSend => 'Send Request';

  @override
  String get memberInvoicesRefundStatus => 'Refund Request';

  @override
  String get memberInvoicesDate => 'Date';

  @override
  String get memberInvoicesBranch => 'Branch';

  @override
  String get memberInvoicesPaymentMethod => 'Payment Method';

  @override
  String get memberInvoicesPaid => 'Paid';

  @override
  String get memberInvoicesDue => 'Due';

  @override
  String get memberInvoicesPaymentCash => 'Cash';

  @override
  String get memberInvoicesPaymentCard => 'Card';

  @override
  String get memberInvoicesPaymentStripe => 'Stripe';

  @override
  String get memberInvoicesPaymentBankTransfer => 'Bank Transfer';

  @override
  String get memberInvoicesPaymentWallet => 'Wallet';

  @override
  String get memberInvoicesPaymentOther => 'Other';

  @override
  String get memberInvoiceDetailsTitle => 'Invoice Details';

  @override
  String get memberInvoiceItems => 'Items';

  @override
  String get memberInvoicePayments => 'Payments';

  @override
  String get memberInvoiceSubtotal => 'Subtotal';

  @override
  String get memberInvoiceDiscount => 'Discount';

  @override
  String get memberInvoiceTax => 'Tax';

  @override
  String get memberInvoiceTotal => 'Total';

  @override
  String get memberInvoiceInvoiceNumber => 'Invoice Number';

  @override
  String get memberInvoiceBranchAddress => 'Branch Address';

  @override
  String get memberInvoiceBranchPhone => 'Branch Phone';

  @override
  String get memberInvoiceQty => 'Qty';

  @override
  String get memberInvoiceUnitPrice => 'Unit Price';

  @override
  String get memberInvoicesStatus => 'Status';

  @override
  String get memberInvoicesType => 'Type';

  @override
  String get memberInvoiceDownloadPdf => 'Download / Share PDF';

  @override
  String get memberInvoicePdfTitle => 'Invoice';

  @override
  String get memberInvoicePdfFooter => 'Thank you';

  @override
  String get memberInvoiceDescription => 'Description';

  @override
  String get admin_dashboard_allBranches => 'All Branches';

  @override
  String get admin_dashboard_timePeriod => 'Time Period';

  @override
  String get admin_dashboard_today => 'Today';

  @override
  String get admin_dashboard_thisWeek => 'This Week';

  @override
  String get admin_dashboard_thisMonth => 'This Month';

  @override
  String get admin_dashboard_custom => 'Custom';

  @override
  String get admin_dashboard_tabMembership => 'Membership';

  @override
  String get admin_dashboard_tabPayments => 'Payments';

  @override
  String get admin_dashboard_tabAttendance => 'Attendance';

  @override
  String get admin_dashboard_cardHint => 'Tap the card for additional information.';

  @override
  String get admin_dashboard_comingSoon => 'coming soon';

  @override
  String get admin_dashboard_lastMonth => 'Last Month';

  @override
  String get admin_dashboard_last3Months => 'Last 3 Months';

  @override
  String get admin_dashboard_sectionToday => 'Today';

  @override
  String get admin_dashboard_sectionAttendance => 'Attendance';

  @override
  String get admin_dashboard_sectionMembershipExpiry => 'Membership Expiry';

  @override
  String get admin_dashboard_sectionPtPlanExpiry => 'PT Plan Expiry';

  @override
  String get admin_dashboard_sectionTodaysCollection => 'Today\'s Collection';

  @override
  String get admin_dashboard_attendance => 'Attendance';

  @override
  String get admin_dashboard_birthdays => 'Birthdays';

  @override
  String get admin_dashboard_expiresToday => 'Expires Today';

  @override
  String get admin_dashboard_ptExpiringToday => 'PT Plan Expiring Today';

  @override
  String get admin_dashboard_monthlyCheckins => 'Monthly Check-ins';

  @override
  String get admin_dashboard_uniqueMembersAttended => 'Unique Members Attended';

  @override
  String get admin_dashboard_expiring1to3 => 'Expiring (1–3d)';

  @override
  String get admin_dashboard_expiring4to7 => 'Expiring (4–7d)';

  @override
  String get admin_dashboard_expiring8to15 => 'Expiring (8–15d)';

  @override
  String get admin_dashboard_ptExpiring1to7 => 'PT Expiring (1–7d)';

  @override
  String get admin_dashboard_ptExpiring8to15 => 'PT Expiring (8–15d)';

  @override
  String get admin_dashboard_recordAttendance => 'Record Attendance';

  @override
  String get admin_dashboard_membershipCollectedToday => 'Membership Collected Today';

  @override
  String get admin_dashboard_admissionFees => 'Admission Fees';

  @override
  String get admin_dashboard_membershipCollected => 'Membership Collected';

  @override
  String get admin_dashboard_membershipDue => 'Membership Due';

  @override
  String get admin_dashboard_ptDue => 'PT Due';

  @override
  String get admin_dashboard_servicePaid => 'Service Paid';

  @override
  String get admin_dashboard_serviceDue => 'Service Due';

  @override
  String get admin_dashboard_expense => 'Expense';

  @override
  String get admin_dashboard_upcomingPtSessions => 'Upcoming PT Sessions';

  @override
  String get admin_dashboard_attendanceGrowth => 'Attendance Growth';

  @override
  String get admin_dashboard_absentMembers => 'Absent Members';

  @override
  String get admin_dashboard_activeMembers => 'Active Members';

  @override
  String get admin_dashboard_pendingRenewals => 'Pending Renewals';

  @override
  String get admin_dashboard_todayCheckins => 'Today\'s Check-ins';

  @override
  String get admin_dashboard_upcomingPt => 'Upcoming PT';

  @override
  String get admin_dashboard_dueSoon => 'Due soon';

  @override
  String get admin_dashboard_liveNow => 'Live now';

  @override
  String get admin_dashboard_sessions => 'Sessions';

  @override
  String get admin_dashboard_attendance => 'Attendance';

  @override
  String get admin_dashboard_paymentsCollected => 'Payments Collected';

  @override
  String get admin_dashboard_expiringPlans => 'Expiring Plans';

  @override
  String get admin_dashboard_totalMembers => 'Total Members';

  @override
  String get admin_dashboard_next7Days => 'Next 7 days';

  @override
  String admin_dashboard_activeCount(int count) {
    return '$count Active';
  }

  @override
  String get admin_dashboard_quickActions => 'Quick Actions';

  @override
  String get admin_dashboard_recordPayment => 'Record Payment';

  @override
  String get admin_dashboard_addPlan => 'Add Plan';

  @override
  String get admin_dashboard_sendAnnouncement => 'Send Announcement';

  @override
  String get admin_dashboard_totalPlans => 'Total Plans';

  @override
  String get admin_dashboard_canceled => 'Canceled';

  @override
  String get admin_dashboard_churnRate => 'Churn Rate';

  @override
  String get admin_dashboard_monthlyRevenue => 'Monthly Revenue';

  @override
  String get admin_dashboard_last7Days => 'Last 7 days';

  @override
  String get admin_dashboard_recentActivity => 'Recent Activity';

  @override
  String get admin_dashboard_viewAll => 'View all';

  @override
  String get admin_dashboard_noRecentActivity => 'No recent activity';

  @override
  String get admin_members_noMembers => 'No members found.';

  @override
  String get admin_members_searchHint => 'Search by Name, Phone, Member Code';

  @override
  String get admin_members_filterAllStatus => 'All Status';

  @override
  String get admin_members_filterInactive => 'Inactive';

  @override
  String get admin_members_filterBlocked => 'Blocked';

  @override
  String get admin_members_sortNewest => 'Newest';

  @override
  String get admin_members_sortOldest => 'Oldest';

  @override
  String get admin_members_sortAlpha => 'Alphabetical';

  @override
  String get admin_members_filterAllGender => 'All Gender';

  @override
  String get admin_members_colPlan => 'Plan';

  @override
  String get admin_members_colDueAmount => 'Due Amount';

  @override
  String get admin_members_colExpiry => 'Expiry';

  @override
  String get admin_members_colBranch => 'Branch';

  @override
  String get admin_members_actionWhatsApp => 'WhatsApp';

  @override
  String get admin_members_actionAttendance => 'Attendance';

  @override
  String get admin_members_actionRenew => 'Renew';

  @override
  String get admin_members_actionUnblock => 'Unblock';

  @override
  String get admin_members_actionBlock => 'Block';

  @override
  String get admin_members_actionDelete => 'Delete';

  @override
  String get admin_members_actionEdit => 'Edit';

  @override
  String get admin_members_actionCall => 'Call';

  @override
  String get admin_members_actionSms => 'SMS';

  @override
  String get admin_members_blockTitle => 'Block Member';

  @override
  String get admin_members_blockHint => 'Enter reason for blocking';

  @override
  String get admin_members_deleteTitle => 'Delete Member';

  @override
  String admin_members_deleteMessage(String name) {
    return 'Permanently delete $name? This cannot be undone.';
  }

  @override
  String get admin_members_statusNoPlan => 'No Plan';

  @override
  String get admin_members_statusInactive => 'Inactive';

  @override
  String get admin_members_detailTitle => 'Member Detail';

  @override
  String get admin_members_membershipPackageTitle => 'Membership Package';

  @override
  String get admin_members_packagePlanName => 'Plan Name';

  @override
  String get admin_members_packageTotalAmount => 'Total Amount';

  @override
  String get admin_members_packageDiscount => 'Discount';

  @override
  String get admin_members_packagePurchaseDate => 'Purchase Date';

  @override
  String get admin_members_packagePaidAmount => 'Paid Amount';

  @override
  String get admin_members_packageDueAmount => 'Due Amount';

  @override
  String get admin_members_packageRemainingDays => 'Remaining Days';

  @override
  String admin_members_packageDays(int count) {
    return '$count days';
  }

  @override
  String get admin_trainers_removeRoleTitle => 'Remove Trainer Role';

  @override
  String admin_trainers_removeRoleMessage(String name) {
    return '$name will lose the Trainer role and see the Member dashboard on next login.';
  }

  @override
  String get admin_trainers_remove => 'Remove';

  @override
  String get admin_trainers_addTrainer => 'Add Trainer';

  @override
  String get admin_trainers_loadError => 'Could not load trainers';

  @override
  String get admin_trainers_emptyTitle => 'No Trainers Yet';

  @override
  String get admin_trainers_emptyMessage => 'Tap \"Add Trainer\" to promote a member to the Trainer role.';

  @override
  String get admin_trainers_badgeLabel => 'TRAINER';

  @override
  String get admin_trainers_removeTooltip => 'Remove Trainer Role';

  @override
  String get admin_plans_deleteTitle => 'Delete Plan';

  @override
  String get admin_plans_deleteMessage => 'Are you sure you want to delete this plan?';

  @override
  String get admin_plans_delete => 'Delete';

  @override
  String get admin_plans_allTypes => 'All Types';

  @override
  String get admin_plans_searchHint => 'Search plans...';

  @override
  String get admin_plans_noPlans => 'No plans found';

  @override
  String get admin_plans_editTitle => 'Edit Plan';

  @override
  String get admin_plans_addTitle => 'Add New Plan';

  @override
  String get admin_plans_createPlan => 'Create Plan';

  @override
  String get admin_staff_noStaff => 'No staff members found.';

  @override
  String get admin_staff_addedSuccess => 'Staff member added successfully';

  @override
  String get admin_staff_updatedSuccess => 'Staff member updated successfully';

  @override
  String get admin_staff_removedSuccess => 'Staff member removed successfully';

  @override
  String get admin_staff_actionCompleted => 'Action completed successfully';

  @override
  String get admin_staff_editTitle => 'Edit Staff Member';

  @override
  String get admin_staff_addTitle => 'Add New Staff';

  @override
  String get admin_staff_fullName => 'Full Name *';

  @override
  String get admin_staff_email => 'Email *';

  @override
  String get admin_staff_phone => 'Phone Number *';

  @override
  String get admin_staff_role => 'Role *';

  @override
  String get admin_staff_branchAssignment => 'Branch Assignment *';

  @override
  String get admin_staff_password => 'Password';

  @override
  String get admin_staff_saveStaff => 'Save Staff';

  @override
  String get admin_staff_editProfile => 'Edit Profile';

  @override
  String get admin_staff_removeTitle => 'Remove Staff Member';

  @override
  String admin_staff_removeMessage(String name) {
    return 'Are you sure you want to remove $name? This action cannot be undone.';
  }

  @override
  String get admin_staff_fullNameHint => 'Enter full name';

  @override
  String get admin_staff_emailHint => 'Enter email';

  @override
  String get admin_staff_phoneHint => 'Enter phone number';

  @override
  String get admin_staff_selectRole => 'Select role';

  @override
  String get admin_staff_selectBranch => 'Select branch';

  @override
  String get admin_staff_autoGeneratePassword => 'Leave empty to auto-generate a secure password';

  @override
  String get admin_settings_unsaved => 'Unsaved';

  @override
  String get admin_settings_searchHint => 'Search settings...';

  @override
  String get admin_settings_legalTitle => 'Legal & Policies';

  @override
  String get admin_settings_legalSubtitle => 'Review our policies';

  @override
  String get admin_settings_saveSuccess => 'Settings saved successfully';

  @override
  String get admin_settings_saving => 'Saving...';

  @override
  String get admin_settings_saveChanges => 'Save Changes';

  @override
  String get admin_settings_saveFailed => 'Failed to save settings';

  @override
  String get admin_branches_activeBranches => 'Active Branches';

  @override
  String get admin_branches_totalMembers => 'Total Members';

  @override
  String get admin_branches_monthlyRevenue => 'Monthly Revenue';

  @override
  String get admin_branches_searchHint => 'Search by branch name or location.';

  @override
  String get admin_branches_allStatus => 'All Status';

  @override
  String get admin_branches_statusActive => 'Active';

  @override
  String get admin_branches_statusInactive => 'Inactive';

  @override
  String get admin_branches_noFound => 'No branches found';

  @override
  String get admin_trainingVideos_deleteSuccess => 'Video deleted';

  @override
  String get admin_trainingVideos_totalVideos => 'Total Videos';

  @override
  String get admin_trainingVideos_totalViews => 'Total Views';

  @override
  String get admin_trainingVideos_noVideos => 'No videos found.';

  @override
  String get admin_trainingVideos_allCategories => 'All Categories';

  @override
  String get admin_classes_noClasses => 'No classes scheduled for this day';

  @override
  String get admin_classes_reactivateTitle => 'Reactivate Class';

  @override
  String get admin_classes_reactivateMessage => 'Restore this class to scheduled? Members will be able to book it again.';

  @override
  String get admin_classes_reactivateConfirm => 'Yes, Reactivate';

  @override
  String get admin_classes_cancelTitle => 'Cancel Class';

  @override
  String get admin_classes_cancelMessage => 'Are you sure you want to cancel this class? All booked members will be notified.';

  @override
  String get admin_classes_keepClass => 'Keep Class';

  @override
  String get admin_classes_cancelConfirm => 'Yes, Cancel';

  @override
  String get admin_classes_createdSuccess => 'Class created successfully';

  @override
  String get admin_classes_updatedSuccess => 'Class updated successfully';

  @override
  String get admin_classes_cancelledSuccess => 'Class cancelled';

  @override
  String get admin_classes_reactivatedSuccess => 'Class reactivated successfully';

  @override
  String get admin_membershipRequests_title => 'Membership Requests';

  @override
  String get admin_membershipRequests_retry => 'Retry';

  @override
  String get admin_membershipRequests_noPending => 'No pending requests';

  @override
  String get admin_membershipRequests_noPendingDesc => 'New cash payment requests will appear here';

  @override
  String get admin_membershipRequests_pendingBadge => 'Pending';

  @override
  String get admin_membershipRequests_plan => 'Plan';

  @override
  String get admin_membershipRequests_branch => 'Branch';

  @override
  String get admin_membershipRequests_amount => 'Amount';

  @override
  String get admin_membershipRequests_reject => 'Reject';

  @override
  String get admin_membershipRequests_approve => 'Approve';

  @override
  String get admin_membershipRequests_approveTitle => 'Confirm Payment Receipt';

  @override
  String get admin_membershipRequests_notesHint => 'Notes (optional)';

  @override
  String admin_membershipRequests_approveButton(String amount) {
    return 'Approve — Received \$ $amount';
  }

  @override
  String admin_membershipRequests_subscriptionInfo(String plan, String amount) {
    return 'Plan: $plan\nAmount: \$ $amount';
  }

  @override
  String get admin_membershipRequests_rejectTitle => 'Reject Request';

  @override
  String get admin_membershipRequests_rejectHint => 'Rejection reason (required)';

  @override
  String get admin_membershipRequests_rejectButton => 'Reject Request';

  @override
  String get admin_membershipRequests_enterReason => 'Please enter a rejection reason';

  @override
  String get admin_membershipRequests_tab => 'Membership Requests';

  @override
  String get admin_refundRequests_tab => 'Refund Requests';

  @override
  String get admin_refundRequests_noPending => 'No pending refund requests';

  @override
  String get admin_refundRequests_noPendingDesc => 'Member refund requests will appear here';

  @override
  String get admin_refundRequests_pendingBadge => 'Pending Refund';

  @override
  String get admin_refundRequests_requestedAmount => 'Requested Amount';

  @override
  String get admin_refundRequests_reason => 'Member Reason';

  @override
  String get admin_refundRequests_reject => 'Reject';

  @override
  String get admin_refundRequests_process => 'Process';

  @override
  String get admin_refundRequests_processTitle => 'Process Refund';

  @override
  String get admin_refundRequests_refundAmount => 'Refund Amount';

  @override
  String get admin_refundRequests_refundAmountHint => 'Amount to refund';

  @override
  String get admin_refundRequests_deductionAmount => 'Deduction (Fee)';

  @override
  String get admin_refundRequests_deductionHint => 'Deduction amount (optional)';

  @override
  String get admin_refundRequests_adminNoteHint => 'Admin note (optional)';

  @override
  String admin_refundRequests_approveButton(String amount) {
    return 'Approve Refund — \$ $amount';
  }

  @override
  String get admin_refundRequests_rejectTitle => 'Reject Refund Request';

  @override
  String get admin_refundRequests_rejectHint => 'Rejection reason (required)';

  @override
  String get admin_refundRequests_rejectButton => 'Reject Request';

  @override
  String get admin_refundRequests_enterReason => 'Please enter a rejection reason';

  @override
  String get admin_refundRequests_enterAmount => 'Please enter a valid refund amount';

  @override
  String get membershipStatusPending => 'Pending';

  @override
  String get membershipStatusBlocked => 'Blocked';

  @override
  String get membershipStatusInactive => 'Inactive Membership';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get admin_invoices_filterAll => 'All';

  @override
  String get admin_invoices_filterPaid => 'Paid';

  @override
  String get admin_invoices_filterPending => 'Pending';

  @override
  String get admin_invoices_filterOverdue => 'Overdue';

  @override
  String get admin_invoices_filterCancelled => 'Cancelled';

  @override
  String get admin_invoices_typeAll => 'All Types';

  @override
  String get admin_invoices_typePlans => 'Plans';

  @override
  String get admin_invoices_typeClasses => 'Classes';

  @override
  String get admin_invoices_typePt => 'PT';

  @override
  String get admin_invoices_noInvoices => 'No invoices found';

  @override
  String get admin_invoices_emptyDesc => 'Invoices appear here after payments are completed.';

  @override
  String admin_invoices_noFilteredInvoices(String status) {
    return 'No $status invoices.';
  }

  @override
  String get admin_invoices_invoiceLabel => 'Invoice';

  @override
  String get admin_invoices_downloadPdf => 'Download / Share PDF';

  @override
  String get admin_classes_addTitle => 'Add New Class';

  @override
  String get admin_classes_editTitle => 'Edit Class';

  @override
  String get admin_classes_nameLabel => 'Class Name *';

  @override
  String get admin_classes_typeLabel => 'Type / Activity *';

  @override
  String get admin_classes_newTypeButton => 'New Type';

  @override
  String get admin_classes_trainerLabel => 'Trainer *';

  @override
  String get admin_classes_branchLabel => 'Branch *';

  @override
  String get admin_classes_dateLabel => 'Date *';

  @override
  String get admin_classes_timeLabel => 'Time *';

  @override
  String get admin_classes_durationLabel => 'Duration (minutes) *';

  @override
  String get admin_classes_capacityLabel => 'Capacity *';

  @override
  String get admin_classes_roomLabel => 'Room Name';

  @override
  String get admin_classes_notesLabel => 'Notes / Description';

  @override
  String get admin_classes_saveButton => 'Save Class';

  @override
  String get admin_classes_selectType => 'Select type';

  @override
  String get admin_classes_selectTrainer => 'Select trainer';

  @override
  String get admin_classes_selectBranch => 'Select branch';

  @override
  String get admin_classes_newTypeTitle => 'New Class Type';

  @override
  String get admin_classes_failedCreateType => 'Failed to create class type';

  @override
  String get admin_classes_timePast => 'Time cannot be in the past';

  @override
  String get admin_classes_timeReset => 'Previously selected time is now in the past — please re-select';

  @override
  String get admin_classes_selectDateTime => 'Please select date and time';

  @override
  String get admin_classes_dateTimePast => 'Class date and time cannot be in the past';

  @override
  String get admin_classes_fillRequired => 'Please fill all required fields';

  @override
  String get admin_classes_sessionBookingsTitle => 'Session Bookings';

  @override
  String get admin_classes_paymentConfirmed => 'Payment confirmed';

  @override
  String get admin_classes_bookingRejected => 'Booking rejected';

  @override
  String get admin_classes_noBookings => 'No bookings yet';

  @override
  String get admin_classes_noPhone => 'No phone';

  @override
  String get admin_classes_statusPending => 'Pending';

  @override
  String get admin_classes_statusBooked => 'Booked';

  @override
  String get admin_classes_rejectBooking => 'Reject';

  @override
  String get admin_classes_confirmPayment => 'Confirm Pay';

  @override
  String get admin_classes_statusCancelRequested => 'Cancel Requested';

  @override
  String get admin_classes_approveCancellation => 'Approve';

  @override
  String get admin_classes_declineCancellation => 'Keep';

  @override
  String get admin_classes_cancellationApproved => 'Cancellation approved';

  @override
  String get admin_classes_cancellationDeclined => 'Cancellation declined';

  @override
  String get admin_settings_accountTitle => 'Account & Security';

  @override
  String get admin_settings_accountSubtitle => 'Manage your account security';

  @override
  String get admin_settings_changePassword => 'Change Password';

  @override
  String get admin_settings_changePasswordSubtitle => 'Update your account password';

  @override
  String get admin_settings_biometricLogin => 'Biometric Login';

  @override
  String get admin_settings_biometricSubtitle => 'Use fingerprint or face ID';

  @override
  String get admin_settings_twoFactor => 'Two-Factor Authentication';

  @override
  String get admin_settings_twoFactorSubtitle => 'Add an extra layer of security';

  @override
  String get admin_settings_businessTitle => 'Business Rules';

  @override
  String get admin_settings_adminOnly => 'Admin Only';

  @override
  String get admin_settings_businessSubtitle => 'Configure membership & class logic';

  @override
  String get admin_settings_subscriptionRules => 'Subscription Rules';

  @override
  String get admin_settings_ownerOnly => 'Only the owner can change business rules';

  @override
  String get admin_settings_allowClassWithoutMembership => 'Allow class subscription without membership';

  @override
  String get admin_settings_allowClassWithoutMembershipDesc => 'Users can join classes without buying a plan';

  @override
  String get admin_settings_requireMembershipForClass => 'Require membership for class subscription';

  @override
  String get admin_settings_requireMembershipForClassDesc => 'Users must have an active membership to subscribe to classes';

  @override
  String get admin_settings_allowMembershipWithoutClass => 'Allow membership without class enrollment';

  @override
  String get admin_settings_allowMembershipWithoutClassDesc => 'Members can purchase plans without enrolling in any class';

  @override
  String get admin_settings_allowBothIndependently => 'Allow both independently';

  @override
  String get admin_settings_allowBothIndependentlyDesc => 'Memberships and classes can be purchased separately';

  @override
  String get admin_settings_allowPtBookingWithoutMembership => 'Allow PT booking without membership';

  @override
  String get admin_settings_allowPtBookingWithoutMembershipDesc => 'Members can book personal training sessions without an active membership plan';

  @override
  String get admin_settings_dangerTitle => 'Danger Zone';

  @override
  String get admin_settings_dangerSubtitle => 'Irreversible actions';

  @override
  String get admin_settings_logOut => 'Log Out';

  @override
  String get admin_settings_deleteAccount => 'Delete Account';

  @override
  String get admin_settings_logOutMessage => 'Are you sure you want to log out?';

  @override
  String get admin_settings_deleteAccountMessage => 'This will permanently delete your account. This action cannot be undone.';

  @override
  String get admin_settings_delete => 'Delete';

  @override
  String get settings_appearanceTitle => 'Appearance';

  @override
  String get settings_appearanceSubtitle => 'Customize your visual experience';

  @override
  String get settings_lightMode => 'Light Mode';

  @override
  String get settings_lightModeSubtitle => 'Clean and bright interface';

  @override
  String get settings_darkMode => 'Dark Mode';

  @override
  String get settings_darkModeSubtitle => 'Easy on the eyes';

  @override
  String get settings_systemDefault => 'System Default';

  @override
  String get settings_systemDefaultSubtitle => 'Match your device settings';

  @override
  String get trainer_ptDashboardAllTitle => 'PT Dashboard (All Trainers)';

  @override
  String get trainer_ptDashboardTitle => 'Trainer Dashboard';

  @override
  String get trainer_todaySessions => 'Today Sessions';

  @override
  String get trainer_cancelledNoShow => 'Cancelled / No-Show';

  @override
  String get trainer_todayScheduleHeader => 'Today\'s Schedule';

  @override
  String get trainer_noServicesScheduled => 'No services scheduled for today.';

  @override
  String trainer_byName(String name) {
    return 'By $name';
  }

  @override
  String get trainer_confirmedBadge => 'CONFIRMED';

  @override
  String get trainer_createPackage => 'Create Package';

  @override
  String get trainer_addAvailabilityButton => 'Add Availability';

  @override
  String get trainer_addPtService => 'Add PT Service';

  @override
  String get trainer_createSession => 'Create Session';

  @override
  String get trainer_pendingRequests => 'Pending Requests';

  @override
  String get trainer_noPendingRequests => 'No pending requests.';

  @override
  String get trainer_declineButton => 'Decline';

  @override
  String get trainer_acceptButton => 'Accept';

  @override
  String get trainer_upcomingClients => 'Upcoming Clients';

  @override
  String get trainer_noUpcomingClients => 'No upcoming clients.';

  @override
  String trainer_sessionOfTotal(int current, int total) {
    return 'Session $current/$total';
  }

  @override
  String get trainer_servicesAllTitle => 'All PT Services';

  @override
  String get trainer_servicesMyTitle => 'My Services';

  @override
  String get trainer_noPtServicesFound => 'No PT services found.';

  @override
  String get trainer_deleteServiceTitle => 'Delete Service';

  @override
  String trainer_deleteServiceMessage(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get trainer_inactiveBadge => 'Inactive';

  @override
  String get trainer_editService => 'Edit Service';

  @override
  String get trainer_newPtService => 'New PT Service';

  @override
  String get trainer_assignToTrainer => 'Assign to Trainer';

  @override
  String get trainer_selectTrainerRequired => 'Please select a trainer';

  @override
  String get trainer_serviceNameLabel => 'Service Name';

  @override
  String get trainer_requiredField => 'Required';

  @override
  String get trainer_descriptionOptional => 'Description (optional)';

  @override
  String get trainer_durationMinutes => 'Duration (minutes)';

  @override
  String get trainer_enterNumber => 'Enter a number';

  @override
  String get trainer_priceLabel => 'Price';

  @override
  String get trainer_enterPrice => 'Enter a price';

  @override
  String get trainer_activeLabel => 'Active';

  @override
  String get trainer_inactiveHidden => 'Inactive services are hidden from members';

  @override
  String get trainer_selectTrainerSnackbar => 'Please select a trainer.';

  @override
  String get trainer_packagesAllTitle => 'All Packages';

  @override
  String get trainer_packagesMyTitle => 'My Packages';

  @override
  String get trainer_showDeactivated => 'Show Deactivated';

  @override
  String get trainer_noPackagesFound => 'No packages found.';

  @override
  String get trainer_deactivatedPackages => 'Deactivated Packages';

  @override
  String get trainer_noDeactivatedPackages => 'No deactivated packages.';

  @override
  String get trainer_deactivatePackageTitle => 'Deactivate Package';

  @override
  String trainer_deactivatePackageMessage(String name) {
    return 'Deactivate \"$name\"?';
  }

  @override
  String get trainer_deactivateButton => 'Deactivate';

  @override
  String get trainer_reactivatePackageTitle => 'Reactivate Package';

  @override
  String trainer_reactivatePackageMessage(String name) {
    return 'Reactivate \"$name\"? It will become visible to members again.';
  }

  @override
  String get trainer_reactivateButton => 'Reactivate';

  @override
  String trainer_maxConcurrent(int count) {
    return 'Max $count concurrent';
  }

  @override
  String get trainer_editPackage => 'Edit Package';

  @override
  String get trainer_newPackage => 'New Package';

  @override
  String get trainer_packageNameLabel => 'Package Name';

  @override
  String get trainer_packageTypeLabel => 'Package Type *';

  @override
  String get trainer_numberOfSessions => 'Number of Sessions';

  @override
  String get trainer_sessionDurationMin => 'Session Duration (min)';

  @override
  String get trainer_daysAvailable => 'Days Available (validity period) *';

  @override
  String get trainer_minDaysWeek => 'Min Days/Week';

  @override
  String get trainer_maxDaysWeek => 'Max Days/Week';

  @override
  String get trainer_maxConcurrentSessions => 'Max Concurrent Sessions';

  @override
  String get trainer_salePriceOptional => 'Sale Price (optional)';

  @override
  String get trainer_linkedPtServiceOptional => 'Linked PT Service (optional)';

  @override
  String get trainer_noneOption => 'None';

  @override
  String get trainer_uncheckDeactivate => 'Uncheck to deactivate this package';

  @override
  String trainer_trainerNumber(int id) {
    return 'Trainer #$id';
  }

  @override
  String get trainer_schedulesAllTitle => 'All Schedules';

  @override
  String get trainer_schedulesMyTitle => 'My Availability';

  @override
  String get trainer_noAvailabilityFound => 'No availability slots found.';

  @override
  String get trainer_recurringWeekly => 'Recurring weekly';

  @override
  String trainer_oneTimeDate(String date) {
    return 'One-time: $date';
  }

  @override
  String get trainer_oneTime => 'One-time';

  @override
  String get trainer_deleteSlotTitle => 'Delete Slot';

  @override
  String trainer_deleteSlotMessage(String start, String end) {
    return 'Remove $start–$end slot?';
  }

  @override
  String get trainer_addAvailabilitySlotTitle => 'Add Availability Slot';

  @override
  String get trainer_dayOfWeek => 'Day of Week';

  @override
  String get trainer_startTime => 'Start Time';

  @override
  String get trainer_endTime => 'End Time';

  @override
  String get trainer_recurringWeeklyToggle => 'Recurring (weekly)';

  @override
  String get trainer_specificDate => 'Specific Date *';

  @override
  String get trainer_requiredForOneTime => 'Required for one-time slots';

  @override
  String get trainer_pickDate => 'Pick a date';

  @override
  String get trainer_pickSpecificDate => 'Please pick a specific date for one-time slots.';

  @override
  String get trainer_addButton => 'Add';

  @override
  String get trainer_dayFullMonday => 'Monday';

  @override
  String get trainer_dayFullTuesday => 'Tuesday';

  @override
  String get trainer_dayFullWednesday => 'Wednesday';

  @override
  String get trainer_dayFullThursday => 'Thursday';

  @override
  String get trainer_dayFullFriday => 'Friday';

  @override
  String get trainer_dayFullSaturday => 'Saturday';

  @override
  String get trainer_dayFullSunday => 'Sunday';

  @override
  String get trainer_sessionsAllTitle => 'All Sessions';

  @override
  String get trainer_sessionsTitle => 'Sessions';

  @override
  String get trainer_bookSession => 'Book Session';

  @override
  String get trainer_sessionAccepted => '✅ Session request accepted.';

  @override
  String get trainer_sessionCompleted => '✅ Session marked as completed.';

  @override
  String get trainer_sessionBooked => '✅ Session booked successfully.';

  @override
  String get trainer_sessionDeclined => 'Session request declined.';

  @override
  String get trainer_sessionCancelled => 'Session cancelled.';

  @override
  String get trainer_sessionNoShow => 'Session marked as no-show.';

  @override
  String get trainer_sessionUpdated => 'Session updated.';

  @override
  String get trainer_tabToday => 'Today';

  @override
  String get trainer_tabUpcoming => 'Upcoming';

  @override
  String get trainer_tabCompleted => 'Completed';

  @override
  String get trainer_noServicesUpcoming => 'No upcoming services.';

  @override
  String get trainer_noServicesCompleted => 'No completed services yet.';

  @override
  String get trainer_loadTrainersError => 'Could not load trainers. Please check your connection and retry.';

  @override
  String get trainer_idNotFound => 'Trainer ID not found in profile.\nPlease log out and log in again.';

  @override
  String get trainer_navDashboard => 'Dashboard';

  @override
  String get trainer_navSessions => 'Sessions';

  @override
  String get trainer_navPackages => 'Packages';

  @override
  String get trainer_navSchedule => 'Schedule';

  @override
  String get trainer_navMore => 'More';

  @override
  String get trainer_ptSession => 'PT Session';

  @override
  String get trainer_completeButton => 'Complete';

  @override
  String get trainer_cancelSessionButton => 'Cancel';

  @override
  String get trainer_declineRequestTitle => 'Decline Request';

  @override
  String get trainer_declineRequestMessage => 'Are you sure you want to decline this session request?';

  @override
  String get trainer_keepButton => 'Keep';

  @override
  String get trainer_cancelSessionTitle => 'Cancel Session';

  @override
  String get trainer_cancelSessionMessage => 'Are you sure you want to cancel this session?';

  @override
  String get trainer_cancelSessionConfirm => 'Cancel Session';

  @override
  String get trainer_statusRequested => 'requested';

  @override
  String get trainer_statusCompleted => 'completed';

  @override
  String get trainer_statusCancelled => 'cancelled';

  @override
  String get trainer_statusNoShow => 'no-show';

  @override
  String get trainer_statusScheduled => 'scheduled';

  @override
  String get trainer_statusCancelRequested => 'cancel requested';

  @override
  String get trainer_approveCancelButton => 'Approve';

  @override
  String get trainer_keepSessionButton => 'Keep Session';

  @override
  String get trainer_cancelRequestApproved => 'Cancellation approved';

  @override
  String get trainer_cancelRequestDeclined => 'Session kept, request declined';

  @override
  String get trainer_approveCancelTitle => 'Approve Cancellation';

  @override
  String get trainer_approveCancelMessage => 'The session will be cancelled and the member will be notified.';

  @override
  String get trainer_declineCancelTitle => 'Decline Cancellation';

  @override
  String get trainer_declineCancelMessage => 'The session will remain scheduled and the member\'s request will be declined.';

  @override
  String trainer_memberRequestedDate(String date) {
    return 'Member proposed: $date';
  }

  @override
  String get trainer_sessionProgress => 'Session Progress';

  @override
  String get trainer_selectTimeSlot => 'Please select a time slot or set the times manually.';

  @override
  String get trainer_enterValidMemberId => 'Enter a valid Member ID.';

  @override
  String get trainer_noAvailabilityCustomTime => 'No availability set for this day. You can still set a custom time below.';

  @override
  String get trainer_tapSlotToSelect => 'Tap a slot to select it.';

  @override
  String get trainer_memberIdLabel => 'Member ID *';

  @override
  String get trainer_enterMemberUserId => 'Enter member user ID';

  @override
  String get trainer_enterValidMemberIdValidation => 'Enter a valid member ID';

  @override
  String get trainer_memberPackageIdOptional => 'Member Package ID (optional)';

  @override
  String get trainer_linkSessionToPackage => 'Link this session to the member\'s PT package.';

  @override
  String get trainer_selectDate => 'Select Date';

  @override
  String get trainer_selectTimeLabel => 'Select Time';

  @override
  String get trainer_bookingId => 'Booking ID';

  @override
  String get trainer_paymentStatusLabel => 'Payment Status';

  @override
  String get trainer_confirmCashPayment => 'Confirm Cash Receipt';

  @override
  String get trainer_confirming => 'Confirming...';

  @override
  String get trainer_noPendingCashPayments => 'No pending cash payments';

  @override
  String get trainer_allPtPackagesConfirmed => 'All PT packages payment confirmed';

  @override
  String get trainer_leaveBlankIfNone => 'Leave blank if none';

  @override
  String get trainer_validNumberError => 'Enter a valid number';

  @override
  String get trainer_serviceOptionalLabel => 'Service (optional)';

  @override
  String get trainer_noService => 'No service';

  @override
  String get trainer_notesOptionalLabel => 'Notes (optional)';

  @override
  String get trainer_notesHint => 'e.g. Focus on upper body';

  @override
  String get trainer_pickTime => 'Pick time';

  @override
  String get trainer_calendarAvailable => 'Available';

  @override
  String get trainer_calendarSelected => 'Selected';

  @override
  String get trainer_cashPaymentConfirmed => 'Payment confirmed and sessions activated.';

  @override
  String get trainer_rejectCashPayment => 'Reject';

  @override
  String get trainer_rejecting => 'Rejecting...';

  @override
  String get trainer_cashPaymentRejected => 'Payment rejected.';

  @override
  String get trainer_rejectPaymentTitle => 'Reject Payment';

  @override
  String get trainer_rejectPaymentHint => 'Reason for rejection';

  @override
  String get trainer_rejectPaymentReasonRequired => 'Please enter a reason';

  @override
  String get trainer_dateLabel => 'Date';

  @override
  String get promotionPrice => 'Promotion price';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsUnsaved => 'Unsaved';

  @override
  String get settingsUnexpectedError => 'Unexpected error occurred';

  @override
  String get settingsTryAgain => 'Try Again';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully';

  @override
  String get settingsSaveFailed => 'Failed to save settings';

  @override
  String get settingsSaving => 'Saving...';

  @override
  String get settingsSaveChanges => 'Save Changes';

  @override
  String get settingsLanguageRegionTitle => 'Language & Region';

  @override
  String get settingsLanguageRegionSubtitle => 'Choose your preferred language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageEnglishSubtitle => 'Default language';

  @override
  String get settingsLanguageArabic => 'Arabic';

  @override
  String get settingsLanguageArabicSubtitle => 'Arabic language';

  @override
  String get settingsLanguageSystemDefault => 'System Default';

  @override
  String get settingsLanguageSystemDefaultSubtitle => 'Use device language';

  @override
  String get branchDialog_setupTitle => 'Set Up Your First Branch';

  @override
  String get branchDialog_setupSubtitle => 'Create your main gym location to start managing members, plans, check-ins, and more.';

  @override
  String get branchDialog_sectionBasic => 'Basic Information';

  @override
  String get branchDialog_name => 'Branch Name';

  @override
  String get branchDialog_nameHint => 'e.g. Main Gym – Downtown';

  @override
  String get branchDialog_nameRequired => 'Branch name is required';

  @override
  String get branchDialog_city => 'City';

  @override
  String get branchDialog_cityHint => 'e.g. Cairo';

  @override
  String get branchDialog_cityRequired => 'City is required';

  @override
  String get branchDialog_sectionContact => 'Contact';

  @override
  String get branchDialog_phone => 'Phone';

  @override
  String get branchDialog_phoneHint => '+20 100 000 0000';

  @override
  String get branchDialog_phoneRequired => 'Phone is required';

  @override
  String get branchDialog_email => 'Email';

  @override
  String get branchDialog_emailHint => 'branch@yourgym.com';

  @override
  String get branchDialog_emailRequired => 'Email is required';

  @override
  String get branchDialog_emailInvalid => 'Enter a valid email address';

  @override
  String get branchDialog_address => 'Address';

  @override
  String get branchDialog_addressHint => '123 Main St, Downtown';

  @override
  String get branchDialog_addressRequired => 'Address is required';

  @override
  String get branchDialog_sectionHours => 'Operating Hours';

  @override
  String get branchDialog_open24 => 'Open 24 Hours';

  @override
  String get branchDialog_open24Sub => 'Branch is always open';

  @override
  String get branchDialog_opening => 'Opening';

  @override
  String get branchDialog_closing => 'Closing';

  @override
  String get branchDialog_tapToSet => 'Tap to set';

  @override
  String get branchDialog_closingAfterOpening => 'Closing time must be after opening time';

  @override
  String get branchDialog_selectOpening => 'Please select an opening time';

  @override
  String get branchDialog_selectClosing => 'Please select a closing time';

  @override
  String get branchDialog_create => 'Create Branch';

  @override
  String get branchDialog_createdSuccess => 'Branch created successfully!';
}
