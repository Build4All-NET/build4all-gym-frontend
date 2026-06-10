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
  String get general_cancel => 'Cancel';

  @override
  String get general_or => 'or';

  @override
  String get general_optional => 'Optional';

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
  String get validation_passwordNoLetter => 'Password must contain at least one letter';

  @override
  String get validation_passwordNoNumber => 'Password must contain at least one number';

  @override
  String get validation_confirmPasswordRequired => 'Please confirm your password';

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
  String get signup_success => 'Successfully registered. You can now login.';

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
  String remainingDays(Object days) {
    return '$days days remaining';
  }

  @override
  String membershipEndsAt(Object date) {
    return 'Ends at $date';
  }

  @override
  String get memberPlansTitle => 'Membership Plans';

  @override
  String get memberPlansSubtitle => 'Choose the best plan for you';

  @override
  String get memberPlansEmpty => 'No plans available';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get checkoutComingSoon => 'Checkout coming soon';

  @override
  String get planDuration => 'Plan Duration';

  @override
  String get visitLimit => 'Visit Limit';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get freezeDays => 'Freeze Days';

  @override
  String get planFeatures => 'Plan Features';

  @override
  String get couponCode => 'Coupon Code';

  @override
  String get enterCouponCode => 'Enter coupon code';

  @override
  String get apply => 'Apply';

  @override
  String couponAppliedFinalPrice(Object price) {
    return 'Final price: $price';
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
  String sessionDetailSeatsRemaining(Object count) {
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
  String get accountMyInfo => 'My Info';

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
  String get aiHeroBannerTitle => 'AI Assistant';

  @override
  String get aiHeroBannerSubtitle => 'Your intelligent gym management companion';

  @override
  String get aiHeroBannerBody => 'Ask questions about members, revenue, attendance, performance, and business insights.';

  @override
  String get aiSuggestedQuestionsHeader => 'Suggested Questions';

  @override
  String get aiAppBarTitle => 'AI Assistant';

  @override
  String get aiNewConversationTooltip => 'New Conversation';

  @override
  String get aiInputHint => 'Ask anything about your gym...';

  @override
  String get aiRetryButton => 'Try Again';

  @override
  String get aiFollowUpHeader => 'Suggested Follow-up Questions';

  @override
  String get aiRecentQueriesHeader => 'Recent Queries';

  @override
  String get aiRecentQueryViewLabel => 'View';

  @override
  String get aiErrorOffline => 'Unable to get a response. Please try again.';

  @override
  String get checkins_title => 'Check-ins';

  @override
  String get checkins_scanQr => 'Scan QR Code';

  @override
  String get checkins_scanSuccessMsg => 'checked in successfully';

  @override
  String get checkins_scannerTitle => 'Scan Member QR Code';

  @override
  String get checkins_activeNow => 'Active Now';

  @override
  String get checkins_totalToday => 'Total Today';

  @override
  String get checkins_todayTitle => 'Today\'s Check-ins';

  @override
  String get checkins_noCheckins => 'No check-ins found today';

  @override
  String get checkins_searchHint => 'Search members...';

  @override
  String get checkins_out => 'Out';

  @override
  String get checkins_freeze => 'Freeze';

  @override
  String get checkins_block => 'Block';

  @override
  String get checkins_call => 'Call';

  @override
  String get checkins_active => 'Active';

  @override
  String get checkins_checkedOut => 'Checked Out';

  @override
  String get checkins_freezeTitle => 'Freeze Membership';

  @override
  String get checkins_fromDate => 'From Date';

  @override
  String get checkins_toDate => 'To Date';

  @override
  String get checkins_reasonHint => 'Enter reason...';

  @override
  String get checkins_confirm => 'Confirm';

  @override
  String get checkins_blockTitle => 'Block Member';

  @override
  String get checkins_cancel => 'Cancel';

  @override
  String get checkins_blockConfirm => 'Block';
}
