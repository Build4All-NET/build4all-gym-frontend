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

  /// No description provided for @common_or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get common_or;

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

  /// No description provided for @signup_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered. You can now login.'**
  String get signup_success;

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

  /// Label shown in the step indicator
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

  /// No description provided for @home_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get home_welcome;

  /// No description provided for @home_weightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your weight was updated successfully ✅'**
  String get home_weightUpdated;

  /// No description provided for @home_noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get home_noData;

  /// No description provided for @home_sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get home_sessions;

  /// No description provided for @home_kgLost.
  ///
  /// In en, this message translates to:
  /// **'kg lost'**
  String get home_kgLost;

  /// No description provided for @home_workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get home_workouts;

  /// No description provided for @home_minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get home_minutes;

  /// No description provided for @home_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get home_quickActions;

  /// No description provided for @home_bookClass.
  ///
  /// In en, this message translates to:
  /// **'Book Class'**
  String get home_bookClass;

  /// No description provided for @home_myProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get home_myProgress;

  /// No description provided for @home_membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get home_membership;

  /// No description provided for @home_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get home_support;

  /// No description provided for @home_updateWeight.
  ///
  /// In en, this message translates to:
  /// **'Update your weight'**
  String get home_updateWeight;

  /// No description provided for @home_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get home_save;

  /// No description provided for @home_weightHint.
  ///
  /// In en, this message translates to:
  /// **'75.5'**
  String get home_weightHint;

  /// No description provided for @home_navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_navHome;

  /// No description provided for @home_navActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get home_navActivities;

  /// No description provided for @home_navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get home_navProfile;

  /// No description provided for @home_membershipStatus.
  ///
  /// In en, this message translates to:
  /// **'Membership Status'**
  String get home_membershipStatus;

  /// No description provided for @home_expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on'**
  String get home_expiresOn;

  /// No description provided for @home_renewNow.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get home_renewNow;

  /// No description provided for @home_quoteOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Quote of the day'**
  String get home_quoteOfTheDay;

  /// No description provided for @home_progressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress tracking'**
  String get home_progressTracking;

  /// No description provided for @home_weightTrackerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How was your week? Take a moment to update your weight and track your progress.'**
  String get home_weightTrackerSubtitle;

  /// No description provided for @home_updateWeightNow.
  ///
  /// In en, this message translates to:
  /// **'Update my weight'**
  String get home_updateWeightNow;

  /// No description provided for @home_bookTrainer.
  ///
  /// In en, this message translates to:
  /// **'Book Trainer'**
  String get home_bookTrainer;

  /// No description provided for @home_checkInCode.
  ///
  /// In en, this message translates to:
  /// **'Check-in Code'**
  String get home_checkInCode;

  /// No description provided for @home_paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get home_paymentHistory;

  /// No description provided for @memberBottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get memberBottomNavHome;

  /// No description provided for @memberBottomNavPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get memberBottomNavPlans;

  /// No description provided for @memberBottomNavQr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get memberBottomNavQr;

  /// No description provided for @memberBottomNavClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get memberBottomNavClasses;

  /// No description provided for @memberBottomNavAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get memberBottomNavAccount;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @memberHomeTodaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get memberHomeTodaySchedule;

  /// No description provided for @memberHomeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get memberHomeViewAll;

  /// No description provided for @memberHomeWithTrainer.
  ///
  /// In en, this message translates to:
  /// **'With coach {trainerName}'**
  String memberHomeWithTrainer(Object trainerName);

  /// No description provided for @memberHomeDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String memberHomeDurationMinutes(Object minutes);

  /// No description provided for @memberHomeNoScheduleToday.
  ///
  /// In en, this message translates to:
  /// **'No classes today — enjoy your rest day! 💪'**
  String get memberHomeNoScheduleToday;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @selectThisPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose this plan'**
  String get selectThisPlan;

  /// No description provided for @renew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get renew;

  /// No description provided for @planTypeGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get planTypeGym;

  /// No description provided for @planTypeClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get planTypeClasses;

  /// No description provided for @planTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get planTypeMixed;

  /// No description provided for @billingMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get billingMonthly;

  /// No description provided for @billingYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get billingYearly;

  /// No description provided for @billingWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get billingWeekly;

  /// No description provided for @membershipStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get membershipStatusActive;

  /// No description provided for @membershipStatusFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get membershipStatusFrozen;

  /// No description provided for @membershipStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get membershipStatusExpired;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String remainingDays(int days);

  /// No description provided for @membershipEndsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends on {date}'**
  String membershipEndsAt(String date);

  /// No description provided for @memberPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership Plans'**
  String get memberPlansTitle;

  /// No description provided for @memberPlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that fits your goals'**
  String get memberPlansSubtitle;

  /// No description provided for @memberPlansEmpty.
  ///
  /// In en, this message translates to:
  /// **'No plans available right now'**
  String get memberPlansEmpty;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @checkoutComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon — checkout is under development'**
  String get checkoutComingSoon;

  /// No description provided for @planDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get planDuration;

  /// No description provided for @visitLimit.
  ///
  /// In en, this message translates to:
  /// **'Visit limit'**
  String get visitLimit;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @freezeDays.
  ///
  /// In en, this message translates to:
  /// **'Freeze days'**
  String get freezeDays;

  /// No description provided for @planFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get planFeatures;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get couponCode;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @couponAppliedFinalPrice.
  ///
  /// In en, this message translates to:
  /// **'✓ Coupon applied — final price: {price} \$'**
  String couponAppliedFinalPrice(String price);

  /// No description provided for @selectedPlan.
  ///
  /// In en, this message translates to:
  /// **'Selected plan'**
  String get selectedPlan;

  /// No description provided for @baseAmount.
  ///
  /// In en, this message translates to:
  /// **'Base amount'**
  String get baseAmount;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @planDetails.
  ///
  /// In en, this message translates to:
  /// **'Plan details'**
  String get planDetails;

  /// No description provided for @dayMonday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySaturday;

  /// No description provided for @daySunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySunday;

  /// No description provided for @memberSessionsDifficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get memberSessionsDifficultyBeginner;

  /// No description provided for @memberSessionsDifficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get memberSessionsDifficultyIntermediate;

  /// No description provided for @memberSessionsDifficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get memberSessionsDifficultyAdvanced;

  /// No description provided for @memberSessionsBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get memberSessionsBookNow;

  /// No description provided for @memberSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sports Classes'**
  String get memberSessionsTitle;

  /// No description provided for @memberSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book your spot in your favorite class'**
  String get memberSessionsSubtitle;

  /// No description provided for @memberSessionsRoom.
  ///
  /// In en, this message translates to:
  /// **'Room {roomName}'**
  String memberSessionsRoom(String roomName);

  /// No description provided for @memberSessionsMinute.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String memberSessionsMinute(int minutes);

  /// No description provided for @memberSessionsSeatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} seats'**
  String memberSessionsSeatsAvailable(int count);

  /// No description provided for @memberSessionsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading sessions...'**
  String get memberSessionsLoading;

  /// No description provided for @memberSessionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions available'**
  String get memberSessionsEmpty;

  /// No description provided for @memberSessionsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load sessions'**
  String get memberSessionsError;

  /// No description provided for @memberSessionsFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter classes'**
  String get memberSessionsFilterTitle;

  /// No description provided for @memberSessionsFilterClassType.
  ///
  /// In en, this message translates to:
  /// **'Class type'**
  String get memberSessionsFilterClassType;

  /// No description provided for @memberSessionsFilterTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get memberSessionsFilterTrainer;

  /// No description provided for @memberSessionsFilterBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get memberSessionsFilterBranch;

  /// No description provided for @memberSessionsFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get memberSessionsFilterReset;

  /// No description provided for @memberSessionsFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filter'**
  String get memberSessionsFilterApply;

  /// No description provided for @sessionDetailTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get sessionDetailTimeLabel;

  /// No description provided for @sessionDetailDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sessionDetailDateLabel;

  /// No description provided for @sessionDetailSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get sessionDetailSeatsLabel;

  /// No description provided for @sessionDetailSeatsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String sessionDetailSeatsRemaining(int count);

  /// No description provided for @sessionDetailLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sessionDetailLocationLabel;

  /// No description provided for @sessionDetailAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Class'**
  String get sessionDetailAboutTitle;

  /// No description provided for @sessionDetailBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get sessionDetailBenefitsTitle;

  /// No description provided for @sessionDetailEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Required Equipment'**
  String get sessionDetailEquipmentTitle;

  /// No description provided for @sessionDetailBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get sessionDetailBookNow;

  /// No description provided for @sessionDetailAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'Already Booked'**
  String get sessionDetailAlreadyBooked;

  /// No description provided for @sessionDetailWaitlisted.
  ///
  /// In en, this message translates to:
  /// **'On Waitlist'**
  String get sessionDetailWaitlisted;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// Admin drawer — Dashboard item
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// Admin drawer — Members item
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get navMembers;

  /// Admin drawer — Plans item
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get navPlans;

  /// Admin drawer — Staff item
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// Admin drawer — Payments item
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// Admin drawer — Classes item
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get navClasses;

  /// Admin drawer — AI Assistant item
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get navAiAssistant;

  /// Admin drawer — Settings item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Admin drawer — Logout item
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get navLogout;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// Logout confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// Drawer section label
  ///
  /// In en, this message translates to:
  /// **'CORE OWNER'**
  String get sectionCoreOwner;

  /// Drawer section label
  ///
  /// In en, this message translates to:
  /// **'OPERATIONS / RECEPTION'**
  String get sectionOperationsReception;

  /// Drawer section label
  ///
  /// In en, this message translates to:
  /// **'TRAINING / PT'**
  String get sectionTrainingPt;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Trainers / PT'**
  String get navTrainers;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Reception Staff'**
  String get navReceptionStaff;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Gym Profile'**
  String get navGymProfile;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get navBranches;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get navCheckins;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Classes & PT'**
  String get navClassesPt;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'PT Sessions'**
  String get navPtSessions;

  /// Drawer nav item
  ///
  /// In en, this message translates to:
  /// **'Training Videos'**
  String get navTrainingVideos;

  /// No description provided for @accountProfileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get accountProfileUpdateSuccess;

  /// No description provided for @accountStatExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get accountStatExercises;

  /// No description provided for @accountStatSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get accountStatSessions;

  /// No description provided for @accountStatAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get accountStatAchievements;

  /// No description provided for @accountMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get accountMyBookings;

  /// No description provided for @accountLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get accountLoyaltyPoints;

  /// No description provided for @accountReferralTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get accountReferralTitle;

  /// No description provided for @accountReferralSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share and earn rewards'**
  String get accountReferralSubtitle;

  /// No description provided for @accountReferralCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Your code'**
  String get accountReferralCodeLabel;

  /// No description provided for @accountReferralCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get accountReferralCopied;

  /// No description provided for @accountReferralShare.
  ///
  /// In en, this message translates to:
  /// **'Share Code'**
  String get accountReferralShare;

  /// No description provided for @accountPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get accountPersonalInfo;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmail;

  /// No description provided for @accountPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get accountPhone;

  /// No description provided for @accountDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get accountDateOfBirth;

  /// No description provided for @accountAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get accountAddress;

  /// No description provided for @accountEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get accountEditProfile;

  /// No description provided for @accountSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionAccount;

  /// No description provided for @accountSectionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get accountSectionSettings;

  /// No description provided for @accountPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get accountPaymentMethods;

  /// No description provided for @accountMyMembership.
  ///
  /// In en, this message translates to:
  /// **'My Membership'**
  String get accountMyMembership;

  /// No description provided for @accountNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get accountNotifications;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get accountSettings;

  /// No description provided for @accountHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get accountHelpSupport;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @accountGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get accountGender;

  /// No description provided for @accountGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get accountGenderMale;

  /// No description provided for @accountGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get accountGenderFemale;

  /// No description provided for @accountMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String accountMemberSince(String date);

  /// No description provided for @accountMyInfo.
  ///
  /// In en, this message translates to:
  /// **'My Info'**
  String get accountMyInfo;

  /// No description provided for @ptAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ptAll;

  /// No description provided for @ptFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get ptFavorites;

  /// No description provided for @ptFavoritesWithCount.
  ///
  /// In en, this message translates to:
  /// **'Favorites {count}'**
  String ptFavoritesWithCount(int count);

  /// No description provided for @ptPerSession.
  ///
  /// In en, this message translates to:
  /// **'/session'**
  String get ptPerSession;

  /// No description provided for @ptYearsExperience.
  ///
  /// In en, this message translates to:
  /// **'{years} years exp'**
  String ptYearsExperience(int years);

  /// No description provided for @ptReviews.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String ptReviews(int count);

  /// No description provided for @ptScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Trainers'**
  String get ptScreenTitle;

  /// No description provided for @ptScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the right trainer for your goals'**
  String get ptScreenSubtitle;

  /// No description provided for @ptBookSession.
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get ptBookSession;

  /// No description provided for @ptNoTrainers.
  ///
  /// In en, this message translates to:
  /// **'No trainers available'**
  String get ptNoTrainers;

  /// No description provided for @ptBookingChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get ptBookingChooseDate;

  /// No description provided for @ptBookingChooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Time'**
  String get ptBookingChooseTime;

  /// No description provided for @ptBookingNoSlotsForDate.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this date.'**
  String get ptBookingNoSlotsForDate;

  /// No description provided for @ptDetailSession.
  ///
  /// In en, this message translates to:
  /// **'session'**
  String get ptDetailSession;

  /// No description provided for @ptTrainingVideosTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Videos'**
  String get ptTrainingVideosTitle;

  /// No description provided for @ptTrainingVideosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No training videos yet.'**
  String get ptTrainingVideosEmpty;

  /// No description provided for @ptTrainingVideosMissingUrl.
  ///
  /// In en, this message translates to:
  /// **'Video URL is missing.'**
  String get ptTrainingVideosMissingUrl;

  /// No description provided for @ptTrainingVideosOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open this video.'**
  String get ptTrainingVideosOpenError;

  /// No description provided for @ptTrainerDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Trainer details not found.'**
  String get ptTrainerDetailsNotFound;

  /// No description provided for @ptFavoriteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorite.'**
  String get ptFavoriteUpdateFailed;

  /// No description provided for @ptConfirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get ptConfirmBooking;

  /// No description provided for @ptBookingSelected.
  ///
  /// In en, this message translates to:
  /// **'Booking selected: {date} at {time}'**
  String ptBookingSelected(String date, String time);

  /// No description provided for @ptBookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking summary'**
  String get ptBookingSummary;

  /// No description provided for @ptBookingTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer:'**
  String get ptBookingTrainer;

  /// No description provided for @ptBookingDate.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get ptBookingDate;

  /// No description provided for @ptBookingTime.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get ptBookingTime;

  /// No description provided for @ptBookingTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount:'**
  String get ptBookingTotalAmount;

  /// No description provided for @ptBookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed successfully.'**
  String get ptBookingSuccess;

  /// No description provided for @ptSlotAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'You already booked this time slot.'**
  String get ptSlotAlreadyBooked;

  /// No description provided for @ptPackageChoosePackage.
  ///
  /// In en, this message translates to:
  /// **'Choose package'**
  String get ptPackageChoosePackage;

  /// No description provided for @ptPackageChooseDays.
  ///
  /// In en, this message translates to:
  /// **'Choose days'**
  String get ptPackageChooseDays;

  /// No description provided for @ptPackageChooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose time'**
  String get ptPackageChooseTime;

  /// No description provided for @ptPackageBookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking summary'**
  String get ptPackageBookingSummary;

  /// No description provided for @ptPackageConfirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get ptPackageConfirmBooking;

  /// No description provided for @ptPackageBookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Package booking confirmed successfully.'**
  String get ptPackageBookingSuccess;

  /// No description provided for @ptPackageBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm package booking.'**
  String get ptPackageBookingFailed;

  /// No description provided for @ptPackageNoPackages.
  ///
  /// In en, this message translates to:
  /// **'No packages available right now'**
  String get ptPackageNoPackages;

  /// No description provided for @ptPackageSessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get ptPackageSessions;

  /// No description provided for @ptPackageDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get ptPackageDays;

  /// No description provided for @ptPackageFinalPrice.
  ///
  /// In en, this message translates to:
  /// **'Final price'**
  String get ptPackageFinalPrice;

  /// No description provided for @ptPackageOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original price'**
  String get ptPackageOriginalPrice;

  /// No description provided for @ptPackageSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get ptPackageSalePrice;

  /// No description provided for @ptPackageSelectedPackage.
  ///
  /// In en, this message translates to:
  /// **'Selected package'**
  String get ptPackageSelectedPackage;

  /// No description provided for @ptPackageSelectedDays.
  ///
  /// In en, this message translates to:
  /// **'Selected days'**
  String get ptPackageSelectedDays;

  /// No description provided for @ptPackageSelectedTime.
  ///
  /// In en, this message translates to:
  /// **'Selected time'**
  String get ptPackageSelectedTime;

  /// No description provided for @ptPackageMaxSessionsReached.
  ///
  /// In en, this message translates to:
  /// **'You cannot select more days than the package sessions'**
  String get ptPackageMaxSessionsReached;

  /// No description provided for @ptPackageDaysPerWeekRange.
  ///
  /// In en, this message translates to:
  /// **'Choose {min} to {max} days per week'**
  String ptPackageDaysPerWeekRange(int min, int max);

  /// No description provided for @ptPackageDaysPerWeekExact.
  ///
  /// In en, this message translates to:
  /// **'Choose {count} day(s) per week'**
  String ptPackageDaysPerWeekExact(int count);

  /// No description provided for @ptPackageMaxDaysReached.
  ///
  /// In en, this message translates to:
  /// **'You cannot select more than {max} days per week'**
  String ptPackageMaxDaysReached(int max);

  /// No description provided for @ptPackageNoAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'No available times'**
  String get ptPackageNoAvailableSlots;

  /// No description provided for @ptWeeklySlotsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load available times'**
  String get ptWeeklySlotsFailed;

  /// No description provided for @ptBookingRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request sent to PT. Waiting for approval.'**
  String get ptBookingRequestSuccess;

  /// No description provided for @ptBookingRequestThisTime.
  ///
  /// In en, this message translates to:
  /// **'Request this time'**
  String get ptBookingRequestThisTime;

  /// No description provided for @ptBookingBookSession.
  ///
  /// In en, this message translates to:
  /// **'Book session'**
  String get ptBookingBookSession;

  /// No description provided for @ptBookingRequestNote.
  ///
  /// In en, this message translates to:
  /// **'Member requested unavailable/full PT time'**
  String get ptBookingRequestNote;

  /// No description provided for @ptBookingFullOrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This slot is full or unavailable. Send a request instead.'**
  String get ptBookingFullOrUnavailable;

  /// No description provided for @ptBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to confirm booking.'**
  String get ptBookingFailed;

  /// No description provided for @ptBookingRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to send request.'**
  String get ptBookingRequestFailed;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfileFullName;

  /// No description provided for @editProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editProfileEmail;

  /// No description provided for @editProfilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editProfilePhone;

  /// No description provided for @editProfileDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get editProfileDateOfBirth;

  /// No description provided for @editProfileAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get editProfileAddress;

  /// No description provided for @editProfileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get editProfileGender;

  /// No description provided for @editProfileMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get editProfileMale;

  /// No description provided for @editProfileFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get editProfileFemale;

  /// No description provided for @editProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfileSave;

  /// No description provided for @editProfileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editProfileCancel;

  /// No description provided for @editProfileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get editProfileNameRequired;

  /// No description provided for @editProfileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get editProfileEmailRequired;

  /// No description provided for @editProfileInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get editProfileInvalidEmail;

  /// No description provided for @editProfileFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get editProfileFirstName;

  /// No description provided for @editProfileLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get editProfileLastName;

  /// No description provided for @editProfileUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editProfileUsername;

  /// No description provided for @editProfileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get editProfileChangePassword;

  /// No description provided for @editProfileCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get editProfileCurrentPassword;

  /// No description provided for @editProfileNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get editProfileNewPassword;

  /// No description provided for @editProfileRequired.
  ///
  /// In en, this message translates to:
  /// **'Required.'**
  String get editProfileRequired;

  /// No description provided for @editProfileUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required.'**
  String get editProfileUsernameRequired;

  /// No description provided for @editProfileEmailRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get editProfileEmailRequiredMessage;

  /// No description provided for @editProfileInvalidEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get editProfileInvalidEmailMessage;

  /// No description provided for @editProfilePhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get editProfilePhoneRequired;

  /// No description provided for @editProfileCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required.'**
  String get editProfileCurrentPasswordRequired;

  /// No description provided for @editProfileNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required.'**
  String get editProfileNewPasswordRequired;

  /// No description provided for @editProfilePasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters.'**
  String get editProfilePasswordTooShort;

  /// No description provided for @editProfilePasswordSameAsCurrent.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from current password.'**
  String get editProfilePasswordSameAsCurrent;

  /// No description provided for @editProfileInvalidOwnerProject.
  ///
  /// In en, this message translates to:
  /// **'Invalid owner project link id.'**
  String get editProfileInvalidOwnerProject;

  /// No description provided for @editProfileEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully.'**
  String get editProfileEmailVerified;

  /// No description provided for @editProfilePasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get editProfilePasswordUpdated;

  /// No description provided for @editProfileOnlyLetters.
  ///
  /// In en, this message translates to:
  /// **'Only letters and spaces are allowed.'**
  String get editProfileOnlyLetters;

  /// No description provided for @editProfileVerifyNewEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify new email'**
  String get editProfileVerifyNewEmail;

  /// No description provided for @editProfileVerifyPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Verify password change'**
  String get editProfileVerifyPasswordChange;

  /// No description provided for @editProfileCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to'**
  String get editProfileCodeSentTo;

  /// No description provided for @editProfileVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get editProfileVerificationCode;

  /// No description provided for @editProfileResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get editProfileResend;

  /// No description provided for @editProfileVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get editProfileVerify;

  /// No description provided for @editProfileCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required.'**
  String get editProfileCodeRequired;

  /// No description provided for @memberQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Entry QR Code'**
  String get memberQrTitle;

  /// No description provided for @memberQrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan this code at the gym entrance'**
  String get memberQrSubtitle;

  /// No description provided for @memberQrActiveMembership.
  ///
  /// In en, this message translates to:
  /// **'Active membership'**
  String get memberQrActiveMembership;

  /// No description provided for @memberQrInactiveMembership.
  ///
  /// In en, this message translates to:
  /// **'Inactive membership'**
  String get memberQrInactiveMembership;

  /// No description provided for @memberQrMemberCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Member code'**
  String get memberQrMemberCodeLabel;

  /// No description provided for @memberQrPackageFallback.
  ///
  /// In en, this message translates to:
  /// **'No package'**
  String get memberQrPackageFallback;

  /// No description provided for @memberQrValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get memberQrValidUntil;

  /// No description provided for @memberQrExpiresSoon.
  ///
  /// In en, this message translates to:
  /// **'QR expires soon'**
  String get memberQrExpiresSoon;

  /// No description provided for @memberQrRecentVisits.
  ///
  /// In en, this message translates to:
  /// **'Recent visits'**
  String get memberQrRecentVisits;

  /// No description provided for @memberQrNoRecentVisits.
  ///
  /// In en, this message translates to:
  /// **'No previous visits'**
  String get memberQrNoRecentVisits;

  /// No description provided for @memberQrDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get memberQrDurationLabel;

  /// No description provided for @memberQrToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get memberQrToday;

  /// No description provided for @memberQrYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get memberQrYesterday;

  /// No description provided for @memberQrMinute.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String memberQrMinute(int count);

  /// No description provided for @memberQrHour.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String memberQrHour(String count);

  /// No description provided for @memberQrLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load QR data'**
  String get memberQrLoadError;

  /// No description provided for @memberQrRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get memberQrRetry;

  /// No description provided for @myInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'My Info'**
  String get myInfoTitle;

  /// No description provided for @myInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your gym profile information'**
  String get myInfoSubtitle;

  /// No description provided for @myInfoPreferredBranch.
  ///
  /// In en, this message translates to:
  /// **'Preferred Branch'**
  String get myInfoPreferredBranch;

  /// No description provided for @myInfoSelectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get myInfoSelectBranch;

  /// No description provided for @myInfoGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get myInfoGender;

  /// No description provided for @myInfoGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get myInfoGenderMale;

  /// No description provided for @myInfoGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get myInfoGenderFemale;

  /// No description provided for @myInfoGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get myInfoGenderOther;

  /// No description provided for @myInfoGenderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get myInfoGenderPreferNotToSay;

  /// No description provided for @myInfoDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get myInfoDateOfBirth;

  /// No description provided for @myInfoSelectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get myInfoSelectDateOfBirth;

  /// No description provided for @myInfoHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get myInfoHeightCm;

  /// No description provided for @myInfoWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get myInfoWeightKg;

  /// No description provided for @myInfoEmergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get myInfoEmergencyContactName;

  /// No description provided for @myInfoEmergencyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone'**
  String get myInfoEmergencyContactPhone;

  /// No description provided for @myInfoFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get myInfoFullNameHint;

  /// No description provided for @myInfoPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get myInfoPhoneNumberHint;

  /// No description provided for @myInfoSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get myInfoSaveChanges;

  /// No description provided for @myInfoUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'My Info updated successfully'**
  String get myInfoUpdatedSuccessfully;

  /// No description provided for @myInfoLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load your info. Please try again.'**
  String get myInfoLoadError;

  /// No description provided for @myInfoSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save your info. Please try again.'**
  String get myInfoSaveError;

  /// No description provided for @myInfoRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Preferred branch, gender and date of birth are required.'**
  String get myInfoRequiredError;

  /// AI assistant screen — AppBar title
  ///
  /// In en, this message translates to:
  /// **'AI Insights Assistant'**
  String get aiAppBarTitle;

  /// Tooltip on the reset/refresh icon button
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get aiNewConversationTooltip;

  /// Hero banner main title
  ///
  /// In en, this message translates to:
  /// **'AI Insights Assistant'**
  String get aiHeroBannerTitle;

  /// Hero banner subtitle
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your gym'**
  String get aiHeroBannerSubtitle;

  /// Hero banner body text
  ///
  /// In en, this message translates to:
  /// **'Get instant analytics, insights and recommendations\nbased on your gym data.'**
  String get aiHeroBannerBody;

  /// Section header above suggested question chips
  ///
  /// In en, this message translates to:
  /// **'Suggested questions'**
  String get aiSuggestedQuestionsHeader;

  /// Section header above recent query list
  ///
  /// In en, this message translates to:
  /// **'Recent queries'**
  String get aiRecentQueriesHeader;

  /// Trailing label on a recent query row
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get aiRecentQueryViewLabel;

  /// Placeholder text in the chat input field
  ///
  /// In en, this message translates to:
  /// **'Ask a question about your gym...'**
  String get aiInputHint;

  /// Label above the follow-up question chips after an AI answer
  ///
  /// In en, this message translates to:
  /// **'You might also ask:'**
  String get aiFollowUpHeader;

  /// Retry button in the error view
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get aiRetryButton;

  /// Generic error message shown in the error view
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get aiErrorGeneric;

  /// Error appended to the conversation when a query call fails
  ///
  /// In en, this message translates to:
  /// **'Sorry, I couldn\'t process your request. Please try again.'**
  String get aiErrorOffline;

  /// No description provided for @checkins_title.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get checkins_title;

  /// No description provided for @checkins_scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get checkins_scanQr;

  /// No description provided for @checkins_scanSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'checked in successfully'**
  String get checkins_scanSuccessMsg;

  /// No description provided for @checkins_activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get checkins_activeNow;

  /// No description provided for @checkins_totalToday.
  ///
  /// In en, this message translates to:
  /// **'Total Today'**
  String get checkins_totalToday;

  /// No description provided for @checkins_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search members...'**
  String get checkins_searchHint;

  /// No description provided for @checkins_todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Check-ins'**
  String get checkins_todayTitle;

  /// No description provided for @checkins_noCheckins.
  ///
  /// In en, this message translates to:
  /// **'No check-ins today'**
  String get checkins_noCheckins;

  /// No description provided for @checkins_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get checkins_active;

  /// No description provided for @checkins_checkedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked Out'**
  String get checkins_checkedOut;

  /// No description provided for @checkins_out.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get checkins_out;

  /// No description provided for @checkins_freeze.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get checkins_freeze;

  /// No description provided for @checkins_block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get checkins_block;

  /// No description provided for @checkins_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get checkins_call;

  /// No description provided for @checkins_freezeTitle.
  ///
  /// In en, this message translates to:
  /// **'Freeze Membership'**
  String get checkins_freezeTitle;

  /// No description provided for @checkins_fromDate.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get checkins_fromDate;

  /// No description provided for @checkins_toDate.
  ///
  /// In en, this message translates to:
  /// **'To date'**
  String get checkins_toDate;

  /// No description provided for @checkins_reasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get checkins_reasonHint;

  /// No description provided for @checkins_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get checkins_confirm;

  /// No description provided for @checkins_blockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block Member'**
  String get checkins_blockTitle;

  /// No description provided for @checkins_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get checkins_cancel;

  /// No description provided for @checkins_blockConfirm.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get checkins_blockConfirm;

  /// No description provided for @checkins_scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Member QR'**
  String get checkins_scannerTitle;

  /// No description provided for @sessionDetailBookingClosed.
  ///
  /// In en, this message translates to:
  /// **'Booking closed'**
  String get sessionDetailBookingClosed;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @noActiveMembership.
  ///
  /// In en, this message translates to:
  /// **'No active membership'**
  String get noActiveMembership;

  /// No description provided for @membershipStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get membershipStatusCancelled;

  /// No description provided for @editProfileVerifyNewPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify new phone number'**
  String get editProfileVerifyNewPhone;

  /// No description provided for @editProfilePhoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully'**
  String get editProfilePhoneVerified;
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
