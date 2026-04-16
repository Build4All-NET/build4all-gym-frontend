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
}
