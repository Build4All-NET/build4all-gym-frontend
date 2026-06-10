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

  /// No description provided for @sessionDetailMembershipRequired.
  ///
  /// In en, this message translates to:
  /// **'Membership Required'**
  String get sessionDetailMembershipRequired;

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

  /// Admin drawer — Membership Requests item
  String get navMembershipRequests;

  /// Admin drawer — Invoices item
  String get navInvoices;

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
<<<<<<< fixing
=======

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

  /// No description provided for @memberBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get memberBookingsTitle;

  /// No description provided for @memberBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your classes and PT sessions'**
  String get memberBookingsSubtitle;

  /// No description provided for @memberBookingsUpcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get memberBookingsUpcomingTab;

  /// No description provided for @memberBookingsPreviousTab.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get memberBookingsPreviousTab;

  /// No description provided for @memberBookingsEmptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get memberBookingsEmptyUpcoming;

  /// No description provided for @memberBookingsEmptyPrevious.
  ///
  /// In en, this message translates to:
  /// **'No previous bookings'**
  String get memberBookingsEmptyPrevious;

  /// No description provided for @memberBookingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get memberBookingsLoadFailed;

  /// No description provided for @memberBookingsCancelRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Cancel request sent'**
  String get memberBookingsCancelRequestSent;

  /// No description provided for @memberBookingsCancelRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send cancel request'**
  String get memberBookingsCancelRequestFailed;

  /// No description provided for @memberBookingsCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get memberBookingsCancelButton;

  /// No description provided for @memberBookingsReviewButton.
  ///
  /// In en, this message translates to:
  /// **'Rate session'**
  String get memberBookingsReviewButton;

  /// No description provided for @memberBookingsCancelPending.
  ///
  /// In en, this message translates to:
  /// **'Cancel request pending'**
  String get memberBookingsCancelPending;

  /// No description provided for @memberBookingsClassDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Class session'**
  String get memberBookingsClassDefaultTitle;

  /// No description provided for @memberBookingsPtDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'PT session'**
  String get memberBookingsPtDefaultTitle;

  /// No description provided for @memberBookingsSessionProgress.
  ///
  /// In en, this message translates to:
  /// **'Session {current} of {total}'**
  String memberBookingsSessionProgress(int current, int total);

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusWaitlisted.
  ///
  /// In en, this message translates to:
  /// **'Waitlisted'**
  String get bookingStatusWaitlisted;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusCancelRequested.
  ///
  /// In en, this message translates to:
  /// **'Cancel request pending'**
  String get bookingStatusCancelRequested;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get bookingStatusUnknown;

  /// No description provided for @memberBookingsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String memberBookingsMinutes(int count);

  /// No description provided for @memberBookingsRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your opinion matters to us'**
  String get memberBookingsRatingTitle;

  /// No description provided for @memberBookingsRatingLabelLow.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get memberBookingsRatingLabelLow;

  /// No description provided for @memberBookingsRatingLabelHigh.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get memberBookingsRatingLabelHigh;

  /// No description provided for @memberBookingsRateNowButton.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get memberBookingsRateNowButton;

  /// No description provided for @memberBookingsReviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get memberBookingsReviewSubmitted;

  /// No description provided for @memberBookingsReviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit review. Please try again.'**
  String get memberBookingsReviewFailed;

  /// No description provided for @memberInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get memberInvoicesTitle;

  /// No description provided for @memberInvoicesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get memberInvoicesEmptyTitle;

  /// No description provided for @memberInvoicesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your completed payments will appear here.'**
  String get memberInvoicesEmptySubtitle;

  /// No description provided for @memberInvoicesRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get memberInvoicesRetry;

  /// No description provided for @memberInvoicesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get memberInvoicesAll;

  /// No description provided for @memberInvoicesAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get memberInvoicesAllTypes;

  /// No description provided for @memberInvoicesStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get memberInvoicesStatusPaid;

  /// No description provided for @memberInvoicesStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get memberInvoicesStatusPending;

  /// No description provided for @memberInvoicesStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get memberInvoicesStatusRefunded;

  /// No description provided for @memberInvoicesStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get memberInvoicesStatusCancelled;

  /// No description provided for @memberInvoicesStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get memberInvoicesStatusRejected;

  /// No description provided for @memberInvoicesStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get memberInvoicesStatusFailed;

  /// No description provided for @memberInvoicesStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get memberInvoicesStatusUnknown;

  /// No description provided for @memberInvoicesTypePlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get memberInvoicesTypePlans;

  /// No description provided for @memberInvoicesTypeClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get memberInvoicesTypeClasses;

  /// No description provided for @memberInvoicesTypePt.
  ///
  /// In en, this message translates to:
  /// **'PT'**
  String get memberInvoicesTypePt;

  /// No description provided for @memberInvoicesTypePtPackage.
  ///
  /// In en, this message translates to:
  /// **'PT Package'**
  String get memberInvoicesTypePtPackage;

  /// No description provided for @memberInvoicesTypeDailyPass.
  ///
  /// In en, this message translates to:
  /// **'Daily Pass'**
  String get memberInvoicesTypeDailyPass;

  /// No description provided for @memberInvoicesTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get memberInvoicesTypeOther;

  /// No description provided for @memberInvoicesDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get memberInvoicesDetails;

  /// No description provided for @memberInvoicesRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get memberInvoicesRefund;

  /// No description provided for @memberInvoicesRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund Request'**
  String get memberInvoicesRefundTitle;

  /// No description provided for @memberInvoicesRefundMessage.
  ///
  /// In en, this message translates to:
  /// **'A refund request will be sent to the admin. The amount will not be refunded immediately.'**
  String get memberInvoicesRefundMessage;

  /// No description provided for @memberInvoicesRefundReason.
  ///
  /// In en, this message translates to:
  /// **'Reason optional'**
  String get memberInvoicesRefundReason;

  /// No description provided for @memberInvoicesRefundSend.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get memberInvoicesRefundSend;

  /// No description provided for @memberInvoicesRefundStatus.
  ///
  /// In en, this message translates to:
  /// **'Refund Request'**
  String get memberInvoicesRefundStatus;

  /// No description provided for @memberInvoicesDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get memberInvoicesDate;

  /// No description provided for @memberInvoicesBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get memberInvoicesBranch;

  /// No description provided for @memberInvoicesPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get memberInvoicesPaymentMethod;

  /// No description provided for @memberInvoicesPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get memberInvoicesPaid;

  /// No description provided for @memberInvoicesDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get memberInvoicesDue;

  /// No description provided for @memberInvoicesPaymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get memberInvoicesPaymentCash;

  /// No description provided for @memberInvoicesPaymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get memberInvoicesPaymentCard;

  /// No description provided for @memberInvoicesPaymentStripe.
  ///
  /// In en, this message translates to:
  /// **'Stripe'**
  String get memberInvoicesPaymentStripe;

  /// No description provided for @memberInvoicesPaymentBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get memberInvoicesPaymentBankTransfer;

  /// No description provided for @memberInvoicesPaymentWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get memberInvoicesPaymentWallet;

  /// No description provided for @memberInvoicesPaymentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get memberInvoicesPaymentOther;

  /// No description provided for @memberInvoiceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get memberInvoiceDetailsTitle;

  /// No description provided for @memberInvoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get memberInvoiceItems;

  /// No description provided for @memberInvoicePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get memberInvoicePayments;

  /// No description provided for @memberInvoiceSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get memberInvoiceSubtotal;

  /// No description provided for @memberInvoiceDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get memberInvoiceDiscount;

  /// No description provided for @memberInvoiceTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get memberInvoiceTax;

  /// No description provided for @memberInvoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get memberInvoiceTotal;

  /// No description provided for @memberInvoiceInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get memberInvoiceInvoiceNumber;

  /// No description provided for @memberInvoiceBranchAddress.
  ///
  /// In en, this message translates to:
  /// **'Branch Address'**
  String get memberInvoiceBranchAddress;

  /// No description provided for @memberInvoiceBranchPhone.
  ///
  /// In en, this message translates to:
  /// **'Branch Phone'**
  String get memberInvoiceBranchPhone;

  /// No description provided for @memberInvoiceQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get memberInvoiceQty;

  /// No description provided for @memberInvoiceUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get memberInvoiceUnitPrice;

  /// No description provided for @memberInvoicesStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get memberInvoicesStatus;

  /// No description provided for @memberInvoicesType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get memberInvoicesType;

  /// No description provided for @memberInvoiceDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download / Share PDF'**
  String get memberInvoiceDownloadPdf;

  /// No description provided for @memberInvoicePdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get memberInvoicePdfTitle;

  /// No description provided for @memberInvoicePdfFooter.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get memberInvoicePdfFooter;

  /// No description provided for @memberInvoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get memberInvoiceDescription;

  /// No description provided for @admin_dashboard_allBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get admin_dashboard_allBranches;

  /// No description provided for @admin_dashboard_timePeriod.
  ///
  /// In en, this message translates to:
  /// **'Time Period'**
  String get admin_dashboard_timePeriod;

  /// No description provided for @admin_dashboard_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get admin_dashboard_today;

  /// No description provided for @admin_dashboard_thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get admin_dashboard_thisWeek;

  /// No description provided for @admin_dashboard_thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get admin_dashboard_thisMonth;

  /// No description provided for @admin_dashboard_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get admin_dashboard_custom;

  /// No description provided for @admin_dashboard_activeMembers.
  ///
  /// In en, this message translates to:
  /// **'Active Members'**
  String get admin_dashboard_activeMembers;

  /// No description provided for @admin_dashboard_pendingRenewals.
  ///
  /// In en, this message translates to:
  /// **'Pending Renewals'**
  String get admin_dashboard_pendingRenewals;

  /// No description provided for @admin_dashboard_todayCheckins.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Check-ins'**
  String get admin_dashboard_todayCheckins;

  /// No description provided for @admin_dashboard_upcomingPt.
  ///
  /// In en, this message translates to:
  /// **'Upcoming PT'**
  String get admin_dashboard_upcomingPt;

  /// No description provided for @admin_dashboard_dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get admin_dashboard_dueSoon;

  /// No description provided for @admin_dashboard_liveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get admin_dashboard_liveNow;

  /// No description provided for @admin_dashboard_sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get admin_dashboard_sessions;

  /// No description provided for @admin_dashboard_attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get admin_dashboard_attendance;

  /// No description provided for @admin_dashboard_paymentsCollected.
  ///
  /// In en, this message translates to:
  /// **'Payments Collected'**
  String get admin_dashboard_paymentsCollected;

  /// No description provided for @admin_dashboard_expiringPlans.
  ///
  /// In en, this message translates to:
  /// **'Expiring Plans'**
  String get admin_dashboard_expiringPlans;

  /// No description provided for @admin_dashboard_totalMembers.
  ///
  /// In en, this message translates to:
  /// **'Total Members'**
  String get admin_dashboard_totalMembers;

  /// No description provided for @admin_dashboard_next7Days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get admin_dashboard_next7Days;

  /// No description provided for @admin_dashboard_activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String admin_dashboard_activeCount(int count);

  /// No description provided for @admin_dashboard_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get admin_dashboard_quickActions;

  /// No description provided for @admin_dashboard_recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get admin_dashboard_recordPayment;

  /// No description provided for @admin_dashboard_addPlan.
  ///
  /// In en, this message translates to:
  /// **'Add Plan'**
  String get admin_dashboard_addPlan;

  /// No description provided for @admin_dashboard_sendAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Send Announcement'**
  String get admin_dashboard_sendAnnouncement;

  /// No description provided for @admin_dashboard_totalPlans.
  ///
  /// In en, this message translates to:
  /// **'Total Plans'**
  String get admin_dashboard_totalPlans;

  /// No description provided for @admin_dashboard_canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get admin_dashboard_canceled;

  /// No description provided for @admin_dashboard_churnRate.
  ///
  /// In en, this message translates to:
  /// **'Churn Rate'**
  String get admin_dashboard_churnRate;

  /// No description provided for @admin_dashboard_monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get admin_dashboard_monthlyRevenue;

  /// No description provided for @admin_dashboard_last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get admin_dashboard_last7Days;

  /// No description provided for @admin_dashboard_recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get admin_dashboard_recentActivity;

  /// No description provided for @admin_dashboard_viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get admin_dashboard_viewAll;

  /// No description provided for @admin_dashboard_noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get admin_dashboard_noRecentActivity;

  /// No description provided for @admin_members_noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members found.'**
  String get admin_members_noMembers;

  /// No description provided for @admin_members_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by Name, Phone, Member Code'**
  String get admin_members_searchHint;

  /// No description provided for @admin_members_filterAllStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get admin_members_filterAllStatus;

  /// No description provided for @admin_members_filterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_members_filterInactive;

  /// No description provided for @admin_members_filterBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get admin_members_filterBlocked;

  /// No description provided for @admin_members_sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get admin_members_sortNewest;

  /// No description provided for @admin_members_sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get admin_members_sortOldest;

  /// No description provided for @admin_members_sortAlpha.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get admin_members_sortAlpha;

  /// No description provided for @admin_members_filterAllGender.
  ///
  /// In en, this message translates to:
  /// **'All Gender'**
  String get admin_members_filterAllGender;

  /// No description provided for @admin_members_colPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get admin_members_colPlan;

  /// No description provided for @admin_members_colDueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get admin_members_colDueAmount;

  /// No description provided for @admin_members_colExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get admin_members_colExpiry;

  /// No description provided for @admin_members_colBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get admin_members_colBranch;

  /// No description provided for @admin_members_actionWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get admin_members_actionWhatsApp;

  /// No description provided for @admin_members_actionAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get admin_members_actionAttendance;

  /// No description provided for @admin_members_actionRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get admin_members_actionRenew;

  /// No description provided for @admin_members_actionUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get admin_members_actionUnblock;

  /// No description provided for @admin_members_actionBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get admin_members_actionBlock;

  /// No description provided for @admin_members_actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_members_actionDelete;

  /// No description provided for @admin_members_actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_members_actionEdit;

  /// No description provided for @admin_members_actionCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get admin_members_actionCall;

  /// No description provided for @admin_members_actionSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get admin_members_actionSms;

  /// No description provided for @admin_members_blockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block Member'**
  String get admin_members_blockTitle;

  /// No description provided for @admin_members_blockHint.
  ///
  /// In en, this message translates to:
  /// **'Enter reason for blocking'**
  String get admin_members_blockHint;

  /// No description provided for @admin_members_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Member'**
  String get admin_members_deleteTitle;

  /// No description provided for @admin_members_deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete {name}? This cannot be undone.'**
  String admin_members_deleteMessage(String name);

  /// No description provided for @admin_members_statusNoPlan.
  ///
  /// In en, this message translates to:
  /// **'No Plan'**
  String get admin_members_statusNoPlan;

  /// No description provided for @admin_members_statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_members_statusInactive;

  /// No description provided for @admin_members_detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Member Detail'**
  String get admin_members_detailTitle;

  /// No description provided for @admin_members_membershipPackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership Package'**
  String get admin_members_membershipPackageTitle;

  /// No description provided for @admin_members_packagePlanName.
  ///
  /// In en, this message translates to:
  /// **'Plan Name'**
  String get admin_members_packagePlanName;

  /// No description provided for @admin_members_packageTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get admin_members_packageTotalAmount;

  /// No description provided for @admin_members_packageDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get admin_members_packageDiscount;

  /// No description provided for @admin_members_packagePurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get admin_members_packagePurchaseDate;

  /// No description provided for @admin_members_packagePaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get admin_members_packagePaidAmount;

  /// No description provided for @admin_members_packageDueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get admin_members_packageDueAmount;

  /// No description provided for @admin_members_packageRemainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get admin_members_packageRemainingDays;

  /// No description provided for @admin_members_packageDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String admin_members_packageDays(int count);

  /// No description provided for @admin_trainers_removeRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Trainer Role'**
  String get admin_trainers_removeRoleTitle;

  /// No description provided for @admin_trainers_removeRoleMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} will lose the Trainer role and see the Member dashboard on next login.'**
  String admin_trainers_removeRoleMessage(String name);

  /// No description provided for @admin_trainers_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get admin_trainers_remove;

  /// No description provided for @admin_trainers_addTrainer.
  ///
  /// In en, this message translates to:
  /// **'Add Trainer'**
  String get admin_trainers_addTrainer;

  /// No description provided for @admin_trainers_loadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load trainers'**
  String get admin_trainers_loadError;

  /// No description provided for @admin_trainers_emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Trainers Yet'**
  String get admin_trainers_emptyTitle;

  /// No description provided for @admin_trainers_emptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Trainer\" to promote a member to the Trainer role.'**
  String get admin_trainers_emptyMessage;

  /// No description provided for @admin_trainers_badgeLabel.
  ///
  /// In en, this message translates to:
  /// **'TRAINER'**
  String get admin_trainers_badgeLabel;

  /// No description provided for @admin_trainers_removeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove Trainer Role'**
  String get admin_trainers_removeTooltip;

  /// No description provided for @admin_plans_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Plan'**
  String get admin_plans_deleteTitle;

  /// No description provided for @admin_plans_deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this plan?'**
  String get admin_plans_deleteMessage;

  /// No description provided for @admin_plans_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_plans_delete;

  /// No description provided for @admin_plans_allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get admin_plans_allTypes;

  /// No description provided for @admin_plans_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search plans...'**
  String get admin_plans_searchHint;

  /// No description provided for @admin_plans_noPlans.
  ///
  /// In en, this message translates to:
  /// **'No plans found'**
  String get admin_plans_noPlans;

  /// No description provided for @admin_plans_editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get admin_plans_editTitle;

  /// No description provided for @admin_plans_addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Plan'**
  String get admin_plans_addTitle;

  /// No description provided for @admin_plans_createPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get admin_plans_createPlan;

  /// No description provided for @admin_staff_noStaff.
  ///
  /// In en, this message translates to:
  /// **'No staff members found.'**
  String get admin_staff_noStaff;

  /// No description provided for @admin_staff_addedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member added successfully'**
  String get admin_staff_addedSuccess;

  /// No description provided for @admin_staff_updatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member updated successfully'**
  String get admin_staff_updatedSuccess;

  /// No description provided for @admin_staff_removedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member removed successfully'**
  String get admin_staff_removedSuccess;

  /// No description provided for @admin_staff_actionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Action completed successfully'**
  String get admin_staff_actionCompleted;

  /// No description provided for @admin_staff_editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff Member'**
  String get admin_staff_editTitle;

  /// No description provided for @admin_staff_addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Staff'**
  String get admin_staff_addTitle;

  /// No description provided for @admin_staff_fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get admin_staff_fullName;

  /// No description provided for @admin_staff_email.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get admin_staff_email;

  /// No description provided for @admin_staff_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get admin_staff_phone;

  /// No description provided for @admin_staff_role.
  ///
  /// In en, this message translates to:
  /// **'Role *'**
  String get admin_staff_role;

  /// No description provided for @admin_staff_branchAssignment.
  ///
  /// In en, this message translates to:
  /// **'Branch Assignment *'**
  String get admin_staff_branchAssignment;

  /// No description provided for @admin_staff_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get admin_staff_password;

  /// No description provided for @admin_staff_saveStaff.
  ///
  /// In en, this message translates to:
  /// **'Save Staff'**
  String get admin_staff_saveStaff;

  /// No description provided for @admin_staff_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get admin_staff_editProfile;

  /// No description provided for @admin_staff_removeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Staff Member'**
  String get admin_staff_removeTitle;

  /// No description provided for @admin_staff_removeMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}? This action cannot be undone.'**
  String admin_staff_removeMessage(String name);

  /// No description provided for @admin_staff_fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get admin_staff_fullNameHint;

  /// No description provided for @admin_staff_emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get admin_staff_emailHint;

  /// No description provided for @admin_staff_phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get admin_staff_phoneHint;

  /// No description provided for @admin_staff_selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get admin_staff_selectRole;

  /// No description provided for @admin_staff_selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_staff_selectBranch;

  /// No description provided for @admin_staff_autoGeneratePassword.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to auto-generate a secure password'**
  String get admin_staff_autoGeneratePassword;

  /// No description provided for @admin_settings_unsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get admin_settings_unsaved;

  /// No description provided for @admin_settings_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get admin_settings_searchHint;

  /// No description provided for @admin_settings_legalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & Policies'**
  String get admin_settings_legalTitle;

  /// No description provided for @admin_settings_legalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review our policies'**
  String get admin_settings_legalSubtitle;

  /// No description provided for @admin_settings_saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get admin_settings_saveSuccess;

  /// No description provided for @admin_settings_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get admin_settings_saving;

  /// No description provided for @admin_settings_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_settings_saveChanges;

  /// No description provided for @admin_settings_saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get admin_settings_saveFailed;

  /// No description provided for @admin_branches_activeBranches.
  ///
  /// In en, this message translates to:
  /// **'Active Branches'**
  String get admin_branches_activeBranches;

  /// No description provided for @admin_branches_totalMembers.
  ///
  /// In en, this message translates to:
  /// **'Total Members'**
  String get admin_branches_totalMembers;

  /// No description provided for @admin_branches_monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get admin_branches_monthlyRevenue;

  /// No description provided for @admin_branches_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by branch name or location.'**
  String get admin_branches_searchHint;

  /// No description provided for @admin_branches_allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get admin_branches_allStatus;

  /// No description provided for @admin_branches_statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_branches_statusActive;

  /// No description provided for @admin_branches_statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_branches_statusInactive;

  /// No description provided for @admin_branches_noFound.
  ///
  /// In en, this message translates to:
  /// **'No branches found'**
  String get admin_branches_noFound;

  /// No description provided for @admin_trainingVideos_deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Video deleted'**
  String get admin_trainingVideos_deleteSuccess;

  /// No description provided for @admin_trainingVideos_totalVideos.
  ///
  /// In en, this message translates to:
  /// **'Total Videos'**
  String get admin_trainingVideos_totalVideos;

  /// No description provided for @admin_trainingVideos_totalViews.
  ///
  /// In en, this message translates to:
  /// **'Total Views'**
  String get admin_trainingVideos_totalViews;

  /// No description provided for @admin_trainingVideos_noVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos found.'**
  String get admin_trainingVideos_noVideos;

  /// No description provided for @admin_trainingVideos_allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get admin_trainingVideos_allCategories;

  /// No description provided for @admin_classes_noClasses.
  ///
  /// In en, this message translates to:
  /// **'No classes scheduled for this day'**
  String get admin_classes_noClasses;

  /// No description provided for @admin_classes_reactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Reactivate Class'**
  String get admin_classes_reactivateTitle;

  /// No description provided for @admin_classes_reactivateMessage.
  ///
  /// In en, this message translates to:
  /// **'Restore this class to scheduled? Members will be able to book it again.'**
  String get admin_classes_reactivateMessage;

  /// No description provided for @admin_classes_reactivateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Reactivate'**
  String get admin_classes_reactivateConfirm;

  /// No description provided for @admin_classes_cancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Class'**
  String get admin_classes_cancelTitle;

  /// No description provided for @admin_classes_cancelMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this class? All booked members will be notified.'**
  String get admin_classes_cancelMessage;

  /// No description provided for @admin_classes_keepClass.
  ///
  /// In en, this message translates to:
  /// **'Keep Class'**
  String get admin_classes_keepClass;

  /// No description provided for @admin_classes_cancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get admin_classes_cancelConfirm;

  /// No description provided for @admin_classes_createdSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class created successfully'**
  String get admin_classes_createdSuccess;

  /// No description provided for @admin_classes_updatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class updated successfully'**
  String get admin_classes_updatedSuccess;

  /// No description provided for @admin_classes_cancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class cancelled'**
  String get admin_classes_cancelledSuccess;

  /// No description provided for @admin_classes_reactivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class reactivated successfully'**
  String get admin_classes_reactivatedSuccess;

  /// No description provided for @admin_membershipRequests_title.
  ///
  /// In en, this message translates to:
  /// **'Membership Requests'**
  String get admin_membershipRequests_title;

  /// No description provided for @admin_membershipRequests_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_membershipRequests_retry;

  /// No description provided for @admin_membershipRequests_noPending.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get admin_membershipRequests_noPending;

  /// No description provided for @admin_membershipRequests_noPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'New cash payment requests will appear here'**
  String get admin_membershipRequests_noPendingDesc;

  /// No description provided for @admin_membershipRequests_pendingBadge.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admin_membershipRequests_pendingBadge;

  /// No description provided for @admin_membershipRequests_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get admin_membershipRequests_plan;

  /// No description provided for @admin_membershipRequests_branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get admin_membershipRequests_branch;

  /// No description provided for @admin_membershipRequests_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get admin_membershipRequests_amount;

  /// No description provided for @admin_membershipRequests_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get admin_membershipRequests_reject;

  /// No description provided for @admin_membershipRequests_approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get admin_membershipRequests_approve;

  /// No description provided for @admin_membershipRequests_approveTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment Receipt'**
  String get admin_membershipRequests_approveTitle;

  /// No description provided for @admin_membershipRequests_notesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get admin_membershipRequests_notesHint;

  /// No description provided for @admin_membershipRequests_approveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve — Received \$ {amount}'**
  String admin_membershipRequests_approveButton(String amount);

  /// No description provided for @admin_membershipRequests_subscriptionInfo.
  ///
  /// In en, this message translates to:
  /// **'Plan: {plan}\nAmount: \$ {amount}'**
  String admin_membershipRequests_subscriptionInfo(String plan, String amount);

  /// No description provided for @admin_membershipRequests_rejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get admin_membershipRequests_rejectTitle;

  /// No description provided for @admin_membershipRequests_rejectHint.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason (required)'**
  String get admin_membershipRequests_rejectHint;

  /// No description provided for @admin_membershipRequests_rejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get admin_membershipRequests_rejectButton;

  /// No description provided for @admin_membershipRequests_enterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a rejection reason'**
  String get admin_membershipRequests_enterReason;

  /// No description provided for @membershipStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get membershipStatusPending;

  /// No description provided for @membershipStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get membershipStatusBlocked;

  /// No description provided for @membershipStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get membershipStatusInactive;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @admin_invoices_filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get admin_invoices_filterAll;

  /// No description provided for @admin_invoices_filterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get admin_invoices_filterPaid;

  /// No description provided for @admin_invoices_filterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admin_invoices_filterPending;

  /// No description provided for @admin_invoices_filterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get admin_invoices_filterOverdue;

  /// No description provided for @admin_invoices_filterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get admin_invoices_filterCancelled;

  /// No description provided for @admin_invoices_typeAll.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get admin_invoices_typeAll;

  /// No description provided for @admin_invoices_typePlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get admin_invoices_typePlans;

  /// No description provided for @admin_invoices_typeClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get admin_invoices_typeClasses;

  /// No description provided for @admin_invoices_typePt.
  ///
  /// In en, this message translates to:
  /// **'PT'**
  String get admin_invoices_typePt;

  /// No description provided for @admin_invoices_noInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get admin_invoices_noInvoices;

  /// No description provided for @admin_invoices_emptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Invoices appear here after payments are completed.'**
  String get admin_invoices_emptyDesc;

  /// No description provided for @admin_invoices_noFilteredInvoices.
  ///
  /// In en, this message translates to:
  /// **'No {status} invoices.'**
  String admin_invoices_noFilteredInvoices(String status);

  /// No description provided for @admin_invoices_invoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get admin_invoices_invoiceLabel;

  /// No description provided for @admin_invoices_downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download / Share PDF'**
  String get admin_invoices_downloadPdf;

  /// No description provided for @admin_classes_addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Class'**
  String get admin_classes_addTitle;

  /// No description provided for @admin_classes_editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Class'**
  String get admin_classes_editTitle;

  /// No description provided for @admin_classes_nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Class Name *'**
  String get admin_classes_nameLabel;

  /// No description provided for @admin_classes_typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type / Activity *'**
  String get admin_classes_typeLabel;

  /// No description provided for @admin_classes_newTypeButton.
  ///
  /// In en, this message translates to:
  /// **'New Type'**
  String get admin_classes_newTypeButton;

  /// No description provided for @admin_classes_trainerLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainer *'**
  String get admin_classes_trainerLabel;

  /// No description provided for @admin_classes_branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch *'**
  String get admin_classes_branchLabel;

  /// No description provided for @admin_classes_dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get admin_classes_dateLabel;

  /// No description provided for @admin_classes_timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time *'**
  String get admin_classes_timeLabel;

  /// No description provided for @admin_classes_durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes) *'**
  String get admin_classes_durationLabel;

  /// No description provided for @admin_classes_capacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Capacity *'**
  String get admin_classes_capacityLabel;

  /// No description provided for @admin_classes_roomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Name'**
  String get admin_classes_roomLabel;

  /// No description provided for @admin_classes_notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes / Description'**
  String get admin_classes_notesLabel;

  /// No description provided for @admin_classes_saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Class'**
  String get admin_classes_saveButton;

  /// No description provided for @admin_classes_selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get admin_classes_selectType;

  /// No description provided for @admin_classes_selectTrainer.
  ///
  /// In en, this message translates to:
  /// **'Select trainer'**
  String get admin_classes_selectTrainer;

  /// No description provided for @admin_classes_selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_classes_selectBranch;

  /// No description provided for @admin_classes_newTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'New Class Type'**
  String get admin_classes_newTypeTitle;

  /// No description provided for @admin_classes_failedCreateType.
  ///
  /// In en, this message translates to:
  /// **'Failed to create class type'**
  String get admin_classes_failedCreateType;

  /// No description provided for @admin_classes_timePast.
  ///
  /// In en, this message translates to:
  /// **'Time cannot be in the past'**
  String get admin_classes_timePast;

  /// No description provided for @admin_classes_timeReset.
  ///
  /// In en, this message translates to:
  /// **'Previously selected time is now in the past — please re-select'**
  String get admin_classes_timeReset;

  /// No description provided for @admin_classes_selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get admin_classes_selectDateTime;

  /// No description provided for @admin_classes_dateTimePast.
  ///
  /// In en, this message translates to:
  /// **'Class date and time cannot be in the past'**
  String get admin_classes_dateTimePast;

  /// No description provided for @admin_classes_fillRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get admin_classes_fillRequired;

  /// No description provided for @admin_classes_sessionBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Bookings'**
  String get admin_classes_sessionBookingsTitle;

  /// No description provided for @admin_classes_paymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed'**
  String get admin_classes_paymentConfirmed;

  /// No description provided for @admin_classes_bookingRejected.
  ///
  /// In en, this message translates to:
  /// **'Booking rejected'**
  String get admin_classes_bookingRejected;

  /// No description provided for @admin_classes_noBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get admin_classes_noBookings;

  /// No description provided for @admin_classes_noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get admin_classes_noPhone;

  /// No description provided for @admin_classes_statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admin_classes_statusPending;

  /// No description provided for @admin_classes_statusBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get admin_classes_statusBooked;

  /// No description provided for @admin_classes_rejectBooking.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get admin_classes_rejectBooking;

  /// No description provided for @admin_classes_confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pay'**
  String get admin_classes_confirmPayment;

  /// No description provided for @admin_settings_accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get admin_settings_accountTitle;

  /// No description provided for @admin_settings_accountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account security'**
  String get admin_settings_accountSubtitle;

  /// No description provided for @admin_settings_changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get admin_settings_changePassword;

  /// No description provided for @admin_settings_changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get admin_settings_changePasswordSubtitle;

  /// No description provided for @admin_settings_biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get admin_settings_biometricLogin;

  /// No description provided for @admin_settings_biometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID'**
  String get admin_settings_biometricSubtitle;

  /// No description provided for @admin_settings_twoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get admin_settings_twoFactor;

  /// No description provided for @admin_settings_twoFactorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get admin_settings_twoFactorSubtitle;

  /// No description provided for @admin_settings_businessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Rules'**
  String get admin_settings_businessTitle;

  /// No description provided for @admin_settings_adminOnly.
  ///
  /// In en, this message translates to:
  /// **'Admin Only'**
  String get admin_settings_adminOnly;

  /// No description provided for @admin_settings_businessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure membership & class logic'**
  String get admin_settings_businessSubtitle;

  /// No description provided for @admin_settings_subscriptionRules.
  ///
  /// In en, this message translates to:
  /// **'Subscription Rules'**
  String get admin_settings_subscriptionRules;

  /// No description provided for @admin_settings_ownerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the owner can change business rules'**
  String get admin_settings_ownerOnly;

  /// No description provided for @admin_settings_allowClassWithoutMembership.
  ///
  /// In en, this message translates to:
  /// **'Allow class subscription without membership'**
  String get admin_settings_allowClassWithoutMembership;

  /// No description provided for @admin_settings_allowClassWithoutMembershipDesc.
  ///
  /// In en, this message translates to:
  /// **'Users can join classes without buying a plan'**
  String get admin_settings_allowClassWithoutMembershipDesc;

  /// No description provided for @admin_settings_requireMembershipForClass.
  ///
  /// In en, this message translates to:
  /// **'Require membership for class subscription'**
  String get admin_settings_requireMembershipForClass;

  /// No description provided for @admin_settings_requireMembershipForClassDesc.
  ///
  /// In en, this message translates to:
  /// **'Users must have an active membership to subscribe to classes'**
  String get admin_settings_requireMembershipForClassDesc;

  /// No description provided for @admin_settings_allowMembershipWithoutClass.
  ///
  /// In en, this message translates to:
  /// **'Allow membership without class enrollment'**
  String get admin_settings_allowMembershipWithoutClass;

  /// No description provided for @admin_settings_allowMembershipWithoutClassDesc.
  ///
  /// In en, this message translates to:
  /// **'Members can purchase plans without enrolling in any class'**
  String get admin_settings_allowMembershipWithoutClassDesc;

  /// No description provided for @admin_settings_allowBothIndependently.
  ///
  /// In en, this message translates to:
  /// **'Allow both independently'**
  String get admin_settings_allowBothIndependently;

  /// No description provided for @admin_settings_allowBothIndependentlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Memberships and classes can be purchased separately'**
  String get admin_settings_allowBothIndependentlyDesc;

  /// No description provided for @admin_settings_dangerTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get admin_settings_dangerTitle;

  /// No description provided for @admin_settings_dangerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Irreversible actions'**
  String get admin_settings_dangerSubtitle;

  /// No description provided for @admin_settings_logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get admin_settings_logOut;

  /// No description provided for @admin_settings_deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get admin_settings_deleteAccount;

  /// No description provided for @admin_settings_logOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get admin_settings_logOutMessage;

  /// No description provided for @admin_settings_deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account. This action cannot be undone.'**
  String get admin_settings_deleteAccountMessage;

  /// No description provided for @admin_settings_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_settings_delete;

  /// No description provided for @settings_appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearanceTitle;

  /// No description provided for @settings_appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your visual experience'**
  String get settings_appearanceSubtitle;

  /// No description provided for @settings_lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settings_lightMode;

  /// No description provided for @settings_lightModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clean and bright interface'**
  String get settings_lightModeSubtitle;

  /// No description provided for @settings_darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_darkMode;

  /// No description provided for @settings_darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes'**
  String get settings_darkModeSubtitle;

  /// No description provided for @settings_systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settings_systemDefault;

  /// No description provided for @settings_systemDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Match your device settings'**
  String get settings_systemDefaultSubtitle;

  /// No description provided for @trainer_ptDashboardAllTitle.
  ///
  /// In en, this message translates to:
  /// **'PT Dashboard (All Trainers)'**
  String get trainer_ptDashboardAllTitle;

  /// No description provided for @trainer_ptDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainer Dashboard'**
  String get trainer_ptDashboardTitle;

  /// No description provided for @trainer_todaySessions.
  ///
  /// In en, this message translates to:
  /// **'Today Sessions'**
  String get trainer_todaySessions;

  /// No description provided for @trainer_cancelledNoShow.
  ///
  /// In en, this message translates to:
  /// **'Cancelled / No-Show'**
  String get trainer_cancelledNoShow;

  /// No description provided for @trainer_todayScheduleHeader.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get trainer_todayScheduleHeader;

  /// No description provided for @trainer_noServicesScheduled.
  ///
  /// In en, this message translates to:
  /// **'No services scheduled for today.'**
  String get trainer_noServicesScheduled;

  /// No description provided for @trainer_byName.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String trainer_byName(String name);

  /// No description provided for @trainer_confirmedBadge.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get trainer_confirmedBadge;

  /// No description provided for @trainer_createPackage.
  ///
  /// In en, this message translates to:
  /// **'Create Package'**
  String get trainer_createPackage;

  /// No description provided for @trainer_addAvailabilityButton.
  ///
  /// In en, this message translates to:
  /// **'Add Availability'**
  String get trainer_addAvailabilityButton;

  /// No description provided for @trainer_addPtService.
  ///
  /// In en, this message translates to:
  /// **'Add PT Service'**
  String get trainer_addPtService;

  /// No description provided for @trainer_createSession.
  ///
  /// In en, this message translates to:
  /// **'Create Session'**
  String get trainer_createSession;

  /// No description provided for @trainer_pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get trainer_pendingRequests;

  /// No description provided for @trainer_noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.'**
  String get trainer_noPendingRequests;

  /// No description provided for @trainer_declineButton.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get trainer_declineButton;

  /// No description provided for @trainer_acceptButton.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get trainer_acceptButton;

  /// No description provided for @trainer_upcomingClients.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Clients'**
  String get trainer_upcomingClients;

  /// No description provided for @trainer_noUpcomingClients.
  ///
  /// In en, this message translates to:
  /// **'No upcoming clients.'**
  String get trainer_noUpcomingClients;

  /// No description provided for @trainer_sessionOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Session {current}/{total}'**
  String trainer_sessionOfTotal(int current, int total);

  /// No description provided for @trainer_servicesAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All PT Services'**
  String get trainer_servicesAllTitle;

  /// No description provided for @trainer_servicesMyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get trainer_servicesMyTitle;

  /// No description provided for @trainer_noPtServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No PT services found.'**
  String get trainer_noPtServicesFound;

  /// No description provided for @trainer_deleteServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get trainer_deleteServiceTitle;

  /// No description provided for @trainer_deleteServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String trainer_deleteServiceMessage(String name);

  /// No description provided for @trainer_inactiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get trainer_inactiveBadge;

  /// No description provided for @trainer_editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get trainer_editService;

  /// No description provided for @trainer_newPtService.
  ///
  /// In en, this message translates to:
  /// **'New PT Service'**
  String get trainer_newPtService;

  /// No description provided for @trainer_assignToTrainer.
  ///
  /// In en, this message translates to:
  /// **'Assign to Trainer'**
  String get trainer_assignToTrainer;

  /// No description provided for @trainer_selectTrainerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a trainer'**
  String get trainer_selectTrainerRequired;

  /// No description provided for @trainer_serviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get trainer_serviceNameLabel;

  /// No description provided for @trainer_requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get trainer_requiredField;

  /// No description provided for @trainer_descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get trainer_descriptionOptional;

  /// No description provided for @trainer_durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get trainer_durationMinutes;

  /// No description provided for @trainer_enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get trainer_enterNumber;

  /// No description provided for @trainer_priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get trainer_priceLabel;

  /// No description provided for @trainer_enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price'**
  String get trainer_enterPrice;

  /// No description provided for @trainer_activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get trainer_activeLabel;

  /// No description provided for @trainer_inactiveHidden.
  ///
  /// In en, this message translates to:
  /// **'Inactive services are hidden from members'**
  String get trainer_inactiveHidden;

  /// No description provided for @trainer_selectTrainerSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Please select a trainer.'**
  String get trainer_selectTrainerSnackbar;

  /// No description provided for @trainer_packagesAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All Packages'**
  String get trainer_packagesAllTitle;

  /// No description provided for @trainer_packagesMyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Packages'**
  String get trainer_packagesMyTitle;

  /// No description provided for @trainer_showDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Show Deactivated'**
  String get trainer_showDeactivated;

  /// No description provided for @trainer_noPackagesFound.
  ///
  /// In en, this message translates to:
  /// **'No packages found.'**
  String get trainer_noPackagesFound;

  /// No description provided for @trainer_deactivatedPackages.
  ///
  /// In en, this message translates to:
  /// **'Deactivated Packages'**
  String get trainer_deactivatedPackages;

  /// No description provided for @trainer_noDeactivatedPackages.
  ///
  /// In en, this message translates to:
  /// **'No deactivated packages.'**
  String get trainer_noDeactivatedPackages;

  /// No description provided for @trainer_deactivatePackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Package'**
  String get trainer_deactivatePackageTitle;

  /// No description provided for @trainer_deactivatePackageMessage.
  ///
  /// In en, this message translates to:
  /// **'Deactivate \"{name}\"?'**
  String trainer_deactivatePackageMessage(String name);

  /// No description provided for @trainer_deactivateButton.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get trainer_deactivateButton;

  /// No description provided for @trainer_reactivatePackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Reactivate Package'**
  String get trainer_reactivatePackageTitle;

  /// No description provided for @trainer_reactivatePackageMessage.
  ///
  /// In en, this message translates to:
  /// **'Reactivate \"{name}\"? It will become visible to members again.'**
  String trainer_reactivatePackageMessage(String name);

  /// No description provided for @trainer_reactivateButton.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get trainer_reactivateButton;

  /// No description provided for @trainer_maxConcurrent.
  ///
  /// In en, this message translates to:
  /// **'Max {count} concurrent'**
  String trainer_maxConcurrent(int count);

  /// No description provided for @trainer_editPackage.
  ///
  /// In en, this message translates to:
  /// **'Edit Package'**
  String get trainer_editPackage;

  /// No description provided for @trainer_newPackage.
  ///
  /// In en, this message translates to:
  /// **'New Package'**
  String get trainer_newPackage;

  /// No description provided for @trainer_packageNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get trainer_packageNameLabel;

  /// No description provided for @trainer_packageTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Package Type *'**
  String get trainer_packageTypeLabel;

  /// No description provided for @trainer_numberOfSessions.
  ///
  /// In en, this message translates to:
  /// **'Number of Sessions'**
  String get trainer_numberOfSessions;

  /// No description provided for @trainer_sessionDurationMin.
  ///
  /// In en, this message translates to:
  /// **'Session Duration (min)'**
  String get trainer_sessionDurationMin;

  /// No description provided for @trainer_daysAvailable.
  ///
  /// In en, this message translates to:
  /// **'Days Available (validity period) *'**
  String get trainer_daysAvailable;

  /// No description provided for @trainer_minDaysWeek.
  ///
  /// In en, this message translates to:
  /// **'Min Days/Week'**
  String get trainer_minDaysWeek;

  /// No description provided for @trainer_maxDaysWeek.
  ///
  /// In en, this message translates to:
  /// **'Max Days/Week'**
  String get trainer_maxDaysWeek;

  /// No description provided for @trainer_maxConcurrentSessions.
  ///
  /// In en, this message translates to:
  /// **'Max Concurrent Sessions'**
  String get trainer_maxConcurrentSessions;

  /// No description provided for @trainer_salePriceOptional.
  ///
  /// In en, this message translates to:
  /// **'Sale Price (optional)'**
  String get trainer_salePriceOptional;

  /// No description provided for @trainer_linkedPtServiceOptional.
  ///
  /// In en, this message translates to:
  /// **'Linked PT Service (optional)'**
  String get trainer_linkedPtServiceOptional;

  /// No description provided for @trainer_noneOption.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get trainer_noneOption;

  /// No description provided for @trainer_uncheckDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Uncheck to deactivate this package'**
  String get trainer_uncheckDeactivate;

  /// No description provided for @trainer_trainerNumber.
  ///
  /// In en, this message translates to:
  /// **'Trainer #{id}'**
  String trainer_trainerNumber(int id);

  /// No description provided for @trainer_schedulesAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All Schedules'**
  String get trainer_schedulesAllTitle;

  /// No description provided for @trainer_schedulesMyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Availability'**
  String get trainer_schedulesMyTitle;

  /// No description provided for @trainer_noAvailabilityFound.
  ///
  /// In en, this message translates to:
  /// **'No availability slots found.'**
  String get trainer_noAvailabilityFound;

  /// No description provided for @trainer_recurringWeekly.
  ///
  /// In en, this message translates to:
  /// **'Recurring weekly'**
  String get trainer_recurringWeekly;

  /// No description provided for @trainer_oneTimeDate.
  ///
  /// In en, this message translates to:
  /// **'One-time: {date}'**
  String trainer_oneTimeDate(String date);

  /// No description provided for @trainer_oneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get trainer_oneTime;

  /// No description provided for @trainer_deleteSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Slot'**
  String get trainer_deleteSlotTitle;

  /// No description provided for @trainer_deleteSlotMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove {start}–{end} slot?'**
  String trainer_deleteSlotMessage(String start, String end);

  /// No description provided for @trainer_addAvailabilitySlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Availability Slot'**
  String get trainer_addAvailabilitySlotTitle;

  /// No description provided for @trainer_dayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get trainer_dayOfWeek;

  /// No description provided for @trainer_startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get trainer_startTime;

  /// No description provided for @trainer_endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get trainer_endTime;

  /// No description provided for @trainer_recurringWeeklyToggle.
  ///
  /// In en, this message translates to:
  /// **'Recurring (weekly)'**
  String get trainer_recurringWeeklyToggle;

  /// No description provided for @trainer_specificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific Date *'**
  String get trainer_specificDate;

  /// No description provided for @trainer_requiredForOneTime.
  ///
  /// In en, this message translates to:
  /// **'Required for one-time slots'**
  String get trainer_requiredForOneTime;

  /// No description provided for @trainer_pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get trainer_pickDate;

  /// No description provided for @trainer_pickSpecificDate.
  ///
  /// In en, this message translates to:
  /// **'Please pick a specific date for one-time slots.'**
  String get trainer_pickSpecificDate;

  /// No description provided for @trainer_addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get trainer_addButton;

  /// No description provided for @trainer_dayFullMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get trainer_dayFullMonday;

  /// No description provided for @trainer_dayFullTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get trainer_dayFullTuesday;

  /// No description provided for @trainer_dayFullWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get trainer_dayFullWednesday;

  /// No description provided for @trainer_dayFullThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get trainer_dayFullThursday;

  /// No description provided for @trainer_dayFullFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get trainer_dayFullFriday;

  /// No description provided for @trainer_dayFullSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get trainer_dayFullSaturday;

  /// No description provided for @trainer_dayFullSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get trainer_dayFullSunday;

  /// No description provided for @trainer_sessionsAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All Sessions'**
  String get trainer_sessionsAllTitle;

  /// No description provided for @trainer_sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get trainer_sessionsTitle;

  /// No description provided for @trainer_bookSession.
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get trainer_bookSession;

  /// No description provided for @trainer_sessionAccepted.
  ///
  /// In en, this message translates to:
  /// **'✅ Session request accepted.'**
  String get trainer_sessionAccepted;

  /// No description provided for @trainer_sessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'✅ Session marked as completed.'**
  String get trainer_sessionCompleted;

  /// No description provided for @trainer_sessionBooked.
  ///
  /// In en, this message translates to:
  /// **'✅ Session booked successfully.'**
  String get trainer_sessionBooked;

  /// No description provided for @trainer_sessionDeclined.
  ///
  /// In en, this message translates to:
  /// **'Session request declined.'**
  String get trainer_sessionDeclined;

  /// No description provided for @trainer_sessionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Session cancelled.'**
  String get trainer_sessionCancelled;

  /// No description provided for @trainer_sessionNoShow.
  ///
  /// In en, this message translates to:
  /// **'Session marked as no-show.'**
  String get trainer_sessionNoShow;

  /// No description provided for @trainer_sessionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Session updated.'**
  String get trainer_sessionUpdated;

  /// No description provided for @trainer_tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trainer_tabToday;

  /// No description provided for @trainer_tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get trainer_tabUpcoming;

  /// No description provided for @trainer_tabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get trainer_tabCompleted;

  /// No description provided for @trainer_noServicesUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming services.'**
  String get trainer_noServicesUpcoming;

  /// No description provided for @trainer_noServicesCompleted.
  ///
  /// In en, this message translates to:
  /// **'No completed services yet.'**
  String get trainer_noServicesCompleted;

  /// No description provided for @trainer_loadTrainersError.
  ///
  /// In en, this message translates to:
  /// **'Could not load trainers. Please check your connection and retry.'**
  String get trainer_loadTrainersError;

  /// No description provided for @trainer_idNotFound.
  ///
  /// In en, this message translates to:
  /// **'Trainer ID not found in profile.\nPlease log out and log in again.'**
  String get trainer_idNotFound;

  /// No description provided for @trainer_navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get trainer_navDashboard;

  /// No description provided for @trainer_navSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get trainer_navSessions;

  /// No description provided for @trainer_navPackages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get trainer_navPackages;

  /// No description provided for @trainer_navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get trainer_navSchedule;

  /// No description provided for @trainer_navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get trainer_navMore;

  /// No description provided for @trainer_ptSession.
  ///
  /// In en, this message translates to:
  /// **'PT Session'**
  String get trainer_ptSession;

  /// No description provided for @trainer_completeButton.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get trainer_completeButton;

  /// No description provided for @trainer_cancelSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get trainer_cancelSessionButton;

  /// No description provided for @trainer_declineRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get trainer_declineRequestTitle;

  /// No description provided for @trainer_declineRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this session request?'**
  String get trainer_declineRequestMessage;

  /// No description provided for @trainer_keepButton.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get trainer_keepButton;

  /// No description provided for @trainer_cancelSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get trainer_cancelSessionTitle;

  /// No description provided for @trainer_cancelSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this session?'**
  String get trainer_cancelSessionMessage;

  /// No description provided for @trainer_cancelSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get trainer_cancelSessionConfirm;

  /// No description provided for @trainer_statusRequested.
  ///
  /// In en, this message translates to:
  /// **'requested'**
  String get trainer_statusRequested;

  /// No description provided for @trainer_statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get trainer_statusCompleted;

  /// No description provided for @trainer_statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get trainer_statusCancelled;

  /// No description provided for @trainer_statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'no-show'**
  String get trainer_statusNoShow;

  /// No description provided for @trainer_statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'scheduled'**
  String get trainer_statusScheduled;

  /// No description provided for @trainer_sessionProgress.
  ///
  /// In en, this message translates to:
  /// **'Session Progress'**
  String get trainer_sessionProgress;

  /// No description provided for @trainer_selectTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot or set the times manually.'**
  String get trainer_selectTimeSlot;

  /// No description provided for @trainer_enterValidMemberId.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Member ID.'**
  String get trainer_enterValidMemberId;

  /// No description provided for @trainer_noAvailabilityCustomTime.
  ///
  /// In en, this message translates to:
  /// **'No availability set for this day. You can still set a custom time below.'**
  String get trainer_noAvailabilityCustomTime;

  /// No description provided for @trainer_tapSlotToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap a slot to select it.'**
  String get trainer_tapSlotToSelect;

  /// No description provided for @trainer_memberIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Member ID *'**
  String get trainer_memberIdLabel;

  /// No description provided for @trainer_enterMemberUserId.
  ///
  /// In en, this message translates to:
  /// **'Enter member user ID'**
  String get trainer_enterMemberUserId;

  /// No description provided for @trainer_enterValidMemberIdValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid member ID'**
  String get trainer_enterValidMemberIdValidation;

  /// No description provided for @trainer_memberPackageIdOptional.
  ///
  /// In en, this message translates to:
  /// **'Member Package ID (optional)'**
  String get trainer_memberPackageIdOptional;

  /// No description provided for @trainer_linkSessionToPackage.
  ///
  /// In en, this message translates to:
  /// **'Link this session to the member\'s PT package.'**
  String get trainer_linkSessionToPackage;

  /// No description provided for @trainer_selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get trainer_selectDate;

  /// No description provided for @trainer_selectTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get trainer_selectTimeLabel;

  /// No description provided for @trainer_bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get trainer_bookingId;

  /// No description provided for @trainer_paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get trainer_paymentStatusLabel;

  /// No description provided for @trainer_confirmCashPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cash Receipt'**
  String get trainer_confirmCashPayment;

  /// No description provided for @trainer_confirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming...'**
  String get trainer_confirming;

  /// No description provided for @trainer_noPendingCashPayments.
  ///
  /// In en, this message translates to:
  /// **'No pending cash payments'**
  String get trainer_noPendingCashPayments;

  /// No description provided for @trainer_allPtPackagesConfirmed.
  ///
  /// In en, this message translates to:
  /// **'All PT packages payment confirmed'**
  String get trainer_allPtPackagesConfirmed;

  /// No description provided for @trainer_leaveBlankIfNone.
  ///
  /// In en, this message translates to:
  /// **'Leave blank if none'**
  String get trainer_leaveBlankIfNone;

  /// No description provided for @trainer_validNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get trainer_validNumberError;

  /// No description provided for @trainer_serviceOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Service (optional)'**
  String get trainer_serviceOptionalLabel;

  /// No description provided for @trainer_noService.
  ///
  /// In en, this message translates to:
  /// **'No service'**
  String get trainer_noService;

  /// No description provided for @trainer_notesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get trainer_notesOptionalLabel;

  /// No description provided for @trainer_notesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Focus on upper body'**
  String get trainer_notesHint;

  /// No description provided for @trainer_pickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick time'**
  String get trainer_pickTime;

  /// No description provided for @trainer_calendarAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get trainer_calendarAvailable;

  /// No description provided for @trainer_calendarSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get trainer_calendarSelected;

  /// No description provided for @trainer_cashPaymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed and sessions activated.'**
  String get trainer_cashPaymentConfirmed;

  /// No description provided for @trainer_dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get trainer_dateLabel;

  /// No description provided for @myInfoAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get myInfoAddress;

  /// No description provided for @myInfoAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get myInfoAddressHint;
>>>>>>> local
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
