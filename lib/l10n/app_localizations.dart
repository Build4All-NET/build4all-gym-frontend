import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get auth_welcomeBack;

  /// Subtitle text on login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your account'**
  String get auth_loginSubtitle;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_emailLabel;

  /// Label for phone number input field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get auth_phoneLabel;

  /// Hint text for email input field
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get auth_emailHint;

  /// Hint text for phone input field
  ///
  /// In en, this message translates to:
  /// **'+961 12 345 678'**
  String get auth_phoneHint;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_passwordLabel;

  /// Hint text for password input field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get auth_passwordHint;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgotPassword;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_loginButton;

  /// Google login button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get auth_continueWithGoogle;

  /// Apple login button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get auth_continueWithApple;

  /// Text asking if user has no account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_noAccount;

  /// Create new account link text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_createAccount;

  /// Title for inactive account dialog
  ///
  /// In en, this message translates to:
  /// **'Account Inactive'**
  String get auth_accountInactiveTitle;

  /// Message for inactive account dialog
  ///
  /// In en, this message translates to:
  /// **'Your account is inactive. Would you like to reactivate it?'**
  String get auth_accountInactiveMessage;

  /// Reactivate account button text
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get auth_reactivate;

  /// Error message for inactive account
  ///
  /// In en, this message translates to:
  /// **'Your account is inactive.'**
  String get auth_accountInactive;

  /// Message when account is deleted but can be restored
  ///
  /// In en, this message translates to:
  /// **'Your account was deleted. Contact support to restore it.'**
  String get auth_accountDeletedRestorableMessage;

  /// Message when account is permanently deleted
  ///
  /// In en, this message translates to:
  /// **'Your account has been permanently deleted.'**
  String get auth_accountDeletedPermanentMessage;

  /// Error message when user account is not found
  ///
  /// In en, this message translates to:
  /// **'No account found with these credentials.'**
  String get auth_userNotFound;

  /// Error message when login is locked due to too many attempts
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please try again later.'**
  String get auth_loginLocked;

  /// No description provided for @login_welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get login_welcomeBack;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your account'**
  String get login_subtitle;

  /// No description provided for @login_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email;

  /// No description provided for @login_emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get login_emailHint;

  /// No description provided for @login_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password;

  /// No description provided for @login_passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get login_passwordHint;

  /// No description provided for @login_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_forgotPassword;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login_button;

  /// No description provided for @login_continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get login_continueWithGoogle;

  /// No description provided for @login_continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get login_continueWithApple;

  /// No description provided for @login_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_noAccount;

  /// No description provided for @login_createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get login_createAccount;

  /// Validation message when email field is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validation_emailRequired;

  /// Validation message when phone field is empty
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validation_phoneRequired;

  /// Validation message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get validation_emailInvalid;

  /// No description provided for @validation_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validation_invalidEmail;

  /// Validation message when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validation_passwordRequired;

  /// Error message for invalid login credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get validation_invalidCredentials;

  /// No description provided for @validation_passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validation_passwordTooShort;

  /// No description provided for @validation_passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validation_passwordsMismatch;

  /// No description provided for @validation_codeRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required'**
  String get validation_codeRequired;

  /// No description provided for @validation_invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code'**
  String get validation_invalidCode;

  /// No description provided for @validation_emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get validation_emailAlreadyExists;

  /// No description provided for @validation_phoneAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Phone number already exists'**
  String get validation_phoneAlreadyExists;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get general_cancel;

  /// Or text for divider
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get general_or;

  /// No description provided for @general_optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get general_optional;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_somethingWentWrong;

  /// No description provided for @error_serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get error_serverError;

  /// No description provided for @connection_reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connection_reconnecting;

  /// Error message when device is offline
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get connection_offline;

  /// No description provided for @connection_issue.
  ///
  /// In en, this message translates to:
  /// **'Connection issue'**
  String get connection_issue;

  /// No description provided for @connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get connection_timeout;

  /// Title for role selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Continue as'**
  String get authGateContinueAs;

  /// Admin role option in role selection
  ///
  /// In en, this message translates to:
  /// **'Admin / Owner'**
  String get authGateRoleAdminOwner;

  /// User role option in role selection
  ///
  /// In en, this message translates to:
  /// **'Regular User'**
  String get authGateRoleUser;

  /// No description provided for @appAccessTitleDeleted.
  ///
  /// In en, this message translates to:
  /// **'App Deleted'**
  String get appAccessTitleDeleted;

  /// No description provided for @appAccessTitleExpired.
  ///
  /// In en, this message translates to:
  /// **'Subscription Expired'**
  String get appAccessTitleExpired;

  /// No description provided for @appAccessTitleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'App Unavailable'**
  String get appAccessTitleUnavailable;

  /// No description provided for @appAccessMessageDeleted.
  ///
  /// In en, this message translates to:
  /// **'This application has been deleted and is no longer available.'**
  String get appAccessMessageDeleted;

  /// No description provided for @appAccessMessageExpired.
  ///
  /// In en, this message translates to:
  /// **'The subscription for this app has expired. Please contact support.'**
  String get appAccessMessageExpired;

  /// No description provided for @appAccessMessageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This application is currently unavailable. Please try again later.'**
  String get appAccessMessageUnavailable;

  /// No description provided for @appAccessRetry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get appAccessRetry;

  /// No description provided for @common_or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get common_or;

  /// No description provided for @forgotPassword_title.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotPassword_title;

  /// No description provided for @forgotPassword_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code.'**
  String get forgotPassword_subtitle;

  /// No description provided for @forgotPassword_sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotPassword_sendCode;

  /// No description provided for @forgotPassword_spamTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: check spam/junk folder too 👀'**
  String get forgotPassword_spamTip;

  /// No description provided for @forgotPassword_verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get forgotPassword_verifyTitle;

  /// Subtitle on verify screen showing which email was used.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {email}'**
  String forgotPassword_codeSentTo(String email);

  /// No description provided for @forgotPassword_codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get forgotPassword_codeLabel;

  /// No description provided for @forgotPassword_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get forgotPassword_verify;

  /// No description provided for @forgotPassword_resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get forgotPassword_resendCode;

  /// No description provided for @forgotPassword_newPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get forgotPassword_newPasswordTitle;

  /// No description provided for @forgotPassword_newPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make it strong — future you will thank you.'**
  String get forgotPassword_newPasswordSubtitle;

  /// No description provided for @forgotPassword_newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get forgotPassword_newPassword;

  /// No description provided for @forgotPassword_confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get forgotPassword_confirmPassword;

  /// No description provided for @forgotPassword_savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get forgotPassword_savePassword;

  /// No description provided for @forgotPassword_enterAllDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all digits'**
  String get forgotPassword_enterAllDigits;

  /// No description provided for @forgotPassword_otpScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get forgotPassword_otpScreenTitle;

  /// No description provided for @forgotPassword_otpScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email or phone'**
  String get forgotPassword_otpScreenSubtitle;

  /// No description provided for @forgotPassword_checkSms.
  ///
  /// In en, this message translates to:
  /// **'Check your SMS'**
  String get forgotPassword_checkSms;

  /// No description provided for @forgotPassword_checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get forgotPassword_checkEmail;

  /// No description provided for @forgotPassword_checkEmailOrSms.
  ///
  /// In en, this message translates to:
  /// **'Check your email or SMS'**
  String get forgotPassword_checkEmailOrSms;

  /// No description provided for @forgotPassword_codeExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in {seconds}s'**
  String forgotPassword_codeExpiresIn(int seconds);

  /// No description provided for @forgotPassword_codeExpired.
  ///
  /// In en, this message translates to:
  /// **'Code has expired'**
  String get forgotPassword_codeExpired;

  /// No description provided for @forgotPassword_verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get forgotPassword_verifyCode;

  /// No description provided for @forgotPassword_didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get forgotPassword_didntReceiveCode;

  /// No description provided for @forgotPassword_emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get forgotPassword_emailOrPhone;

  /// No description provided for @forgotPassword_emailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number'**
  String get forgotPassword_emailOrPhoneHint;

  /// No description provided for @forgotPassword_fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get forgotPassword_fieldRequired;

  /// No description provided for @forgotPassword_invalidEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or phone number'**
  String get forgotPassword_invalidEmailOrPhone;

  /// No description provided for @forgotPassword_sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get forgotPassword_sendOtp;

  /// No description provided for @forgotPassword_newPasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get forgotPassword_newPasswordScreenTitle;

  /// No description provided for @forgotPassword_newPasswordScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below'**
  String get forgotPassword_newPasswordScreenSubtitle;

  /// No description provided for @forgotPassword_passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get forgotPassword_passwordResetSuccess;

  /// No description provided for @validation_passwordNoLetter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one letter'**
  String get validation_passwordNoLetter;

  /// No description provided for @validation_passwordNoNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validation_passwordNoNumber;

  /// No description provided for @validation_confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get validation_confirmPasswordRequired;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get signup_title;

  /// No description provided for @signup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your fitness journey with us'**
  String get signup_subtitle;

  /// No description provided for @signup_step1Label.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get signup_step1Label;

  /// No description provided for @signup_registrationMethod.
  ///
  /// In en, this message translates to:
  /// **'Registration Method'**
  String get signup_registrationMethod;

  /// No description provided for @signup_confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signup_confirmPasswordLabel;

  /// No description provided for @signup_confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get signup_confirmPasswordHint;

  /// No description provided for @signup_continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get signup_continueButton;

  /// No description provided for @signup_alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signup_alreadyHaveAccount;

  /// No description provided for @signup_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signup_signIn;

  /// No description provided for @signup_termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get signup_termsAgreement;

  /// No description provided for @signup_alreadyVerifiedResume.
  ///
  /// In en, this message translates to:
  /// **'Account already verified. Completing your profile.'**
  String get signup_alreadyVerifiedResume;

  /// No description provided for @otp_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account'**
  String get otp_title;

  /// No description provided for @otp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent'**
  String get otp_subtitle;

  /// No description provided for @otp_step2Label.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get otp_step2Label;

  /// No description provided for @otp_sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get otp_sentTo;

  /// No description provided for @otp_enterDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter the {count}-digit verification code'**
  String otp_enterDigits(int count);

  /// No description provided for @otp_didntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get otp_didntReceive;

  /// No description provided for @otp_resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend now'**
  String get otp_resendNow;

  /// No description provided for @otp_verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_verifyButton;

  /// No description provided for @otp_verifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account verified successfully!'**
  String get otp_verifiedSuccess;

  /// No description provided for @otp_codeSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent again'**
  String get otp_codeSentAgain;

  /// No description provided for @otp_enterAllDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all digits'**
  String get otp_enterAllDigits;

  /// No description provided for @otp_backToSignup.
  ///
  /// In en, this message translates to:
  /// **'Back to registration'**
  String get otp_backToSignup;

  /// No description provided for @otp_debugTip.
  ///
  /// In en, this message translates to:
  /// **'For testing use code 1234'**
  String get otp_debugTip;

  /// Header title on sub-step 1 (name fields)
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeProfile_title;

  /// Header subtitle on sub-step 1
  ///
  /// In en, this message translates to:
  /// **'Tell us more about you'**
  String get completeProfile_subtitle;

  /// Header title on sub-step 2 (username + profile type)
  ///
  /// In en, this message translates to:
  /// **'Last Step!'**
  String get completeProfile_lastStepTitle;

  /// Header subtitle on sub-step 2
  ///
  /// In en, this message translates to:
  /// **'Choose a unique username'**
  String get completeProfile_lastStepSubtitle;

  /// Label shown in the step indicator — appended with (1/2) or (2/2)
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get completeProfile_stepLabel;

  /// Helper text shown above the name fields
  ///
  /// In en, this message translates to:
  /// **'We need your name to personalize your experience'**
  String get completeProfile_nameInstruction;

  /// Label for the first name input field
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get completeProfile_firstName;

  /// Hint text inside the first name input
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get completeProfile_firstNameHint;

  /// Validation error when first name is empty
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get completeProfile_firstNameRequired;

  /// Label for the last name input field
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get completeProfile_lastName;

  /// Hint text inside the last name input
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get completeProfile_lastNameHint;

  /// Button label on sub-step 1 to advance to sub-step 2
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get completeProfile_continueButton;

  /// Helper text shown above the username field
  ///
  /// In en, this message translates to:
  /// **'Your username will appear in your profile'**
  String get completeProfile_usernameInstruction;

  /// Label for the username input field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get completeProfile_username;

  /// Validation error when username is empty
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get completeProfile_usernameRequired;

  /// Validation error when username is shorter than 3 characters
  ///
  /// In en, this message translates to:
  /// **'At least 3 characters required'**
  String get completeProfile_usernameTooShort;

  /// Validation error when username contains invalid characters
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, _ and . allowed'**
  String get completeProfile_usernameInvalid;

  /// Error shown when the API returns a username conflict
  ///
  /// In en, this message translates to:
  /// **'This username is already taken'**
  String get completeProfile_usernameTaken;

  /// Label above the public/private profile selection
  ///
  /// In en, this message translates to:
  /// **'Profile Type'**
  String get completeProfile_profileType;

  /// Title of the public profile option card
  ///
  /// In en, this message translates to:
  /// **'Public Account'**
  String get completeProfile_publicTitle;

  /// Description under the public profile option
  ///
  /// In en, this message translates to:
  /// **'Anyone can view your profile and activity'**
  String get completeProfile_publicDescription;

  /// Title of the private profile option card
  ///
  /// In en, this message translates to:
  /// **'Private Account'**
  String get completeProfile_privateTitle;

  /// Description under the private profile option
  ///
  /// In en, this message translates to:
  /// **'Only you can see your information and activity'**
  String get completeProfile_privateDescription;

  /// Info box text below the profile type selector
  ///
  /// In en, this message translates to:
  /// **'You can change these settings later from your profile'**
  String get completeProfile_settingsNote;

  /// Final submit button label on sub-step 2
  ///
  /// In en, this message translates to:
  /// **'Finish & Start'**
  String get completeProfile_finishButton;

  /// Back navigation link shown below the form
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get completeProfile_backButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
