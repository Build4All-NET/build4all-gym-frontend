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

  /// No description provided for @home_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get home_upcoming;

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

  /// No description provided for @memberBottomNavBookTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get memberBottomNavBookTrainer;

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
  /// **'Active Membership'**
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

  /// No description provided for @memberSessionsWithTrainer.
  ///
  /// In en, this message translates to:
  /// **'with {name}'**
  String memberSessionsWithTrainer(String name);

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
  ///
  /// In en, this message translates to:
  /// **'Membership Requests'**
  String get navMembershipRequests;

  /// Admin drawer — Invoices item
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get navInvoices;

  /// Admin drawer — Expenses item
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// Admin drawer — Balance Sheet item
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet'**
  String get navBalanceSheet;

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

  /// Drawer nav item — owner-only screen to configure what trainer/reception roles can see
  ///
  /// In en, this message translates to:
  /// **'Staff Access Control'**
  String get navStaffAccessControl;

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

  /// Admin drawer — Employees (payroll) item
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get navEmployees;

  /// Admin drawer — Employee Check-Ins (attendance) item
  ///
  /// In en, this message translates to:
  /// **'Employee Check-Ins'**
  String get navEmployeeCheckins;

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

  /// Drawer nav item — pending cash PT package bookings
  ///
  /// In en, this message translates to:
  /// **'PT Package Payments'**
  String get navPtPackageBookings;

  /// No description provided for @ptPkgPayments_cashTab.
  ///
  /// In en, this message translates to:
  /// **'Cash Payments'**
  String get ptPkgPayments_cashTab;

  /// No description provided for @ptPkgPayments_refundTab.
  ///
  /// In en, this message translates to:
  /// **'Refund Requests'**
  String get ptPkgPayments_refundTab;

  /// No description provided for @ptPkgPayments_noPendingRefunds.
  ///
  /// In en, this message translates to:
  /// **'No pending PT package refund requests'**
  String get ptPkgPayments_noPendingRefunds;

  /// No description provided for @ptPkgPayments_noPendingRefundsDesc.
  ///
  /// In en, this message translates to:
  /// **'PT package refund requests will appear here'**
  String get ptPkgPayments_noPendingRefundsDesc;

  /// No description provided for @ptPkgPayments_refundBadge.
  ///
  /// In en, this message translates to:
  /// **'PT Refund'**
  String get ptPkgPayments_refundBadge;

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

  /// No description provided for @accountAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get accountAskAi;

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

  /// No description provided for @ptTrainingVideosPipUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Picture-in-Picture is not available on this device.'**
  String get ptTrainingVideosPipUnavailable;

  /// No description provided for @ptVideosLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Members Only'**
  String get ptVideosLockedTitle;

  /// No description provided for @ptVideosLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to a PT package with this trainer to unlock training videos.'**
  String get ptVideosLockedSubtitle;

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

  /// No description provided for @ptSlotsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load available times'**
  String get ptSlotsFailed;

  /// No description provided for @ptRequestTimePickerHint.
  ///
  /// In en, this message translates to:
  /// **'Request a time from the trainer'**
  String get ptRequestTimePickerHint;

  /// No description provided for @ptTimeRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your time request has been sent to the trainer.'**
  String get ptTimeRequestSuccess;

  /// No description provided for @ptTimeRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send time request. Please try again.'**
  String get ptTimeRequestFailed;

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

  /// No description provided for @memberQrEntryWindow.
  ///
  /// In en, this message translates to:
  /// **'Entry: {start} – {end}'**
  String memberQrEntryWindow(String start, String end);

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

  /// Placeholder text in the chat input field
  ///
  /// In en, this message translates to:
  /// **'Ask a question about your gym...'**
  String get aiInputHint;

  /// Retry button in the error view
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get aiRetryButton;

  /// Label above the follow-up question chips after an AI answer
  ///
  /// In en, this message translates to:
  /// **'You might also ask:'**
  String get aiFollowUpHeader;

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

  /// Error appended to the conversation when a query call fails
  ///
  /// In en, this message translates to:
  /// **'Sorry, I couldn\'t process your request. Please try again.'**
  String get aiErrorOffline;

  /// No description provided for @backendErrorAiProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant is currently unavailable. Please try again later.'**
  String get backendErrorAiProviderDisabled;

  /// No description provided for @backendErrorAiContextUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your gym\'s data right now. Please try again shortly.'**
  String get backendErrorAiContextUnavailable;

  /// No description provided for @backendErrorAiProviderTimeout.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant took too long to respond. Please try again.'**
  String get backendErrorAiProviderTimeout;

  /// No description provided for @backendErrorAiInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant returned an unexpected response. Please try again.'**
  String get backendErrorAiInvalidResponse;

  /// No description provided for @backendErrorAiProviderError.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant ran into a problem. Please try again.'**
  String get backendErrorAiProviderError;

  /// No description provided for @backendErrorAiProviderRateLimited.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant is busy right now. Please wait a moment and try again.'**
  String get backendErrorAiProviderRateLimited;

  /// No description provided for @backendErrorRefundProviderNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Automatic refunds aren\'t available yet for this payment method. Our team will process it manually.'**
  String get backendErrorRefundProviderNotSupported;

  /// No description provided for @backendErrorRefundProviderIntegrationRequired.
  ///
  /// In en, this message translates to:
  /// **'This refund needs manual processing. Our team will follow up shortly.'**
  String get backendErrorRefundProviderIntegrationRequired;

  /// No description provided for @backendErrorPaymentVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t verify the refund with the payment provider. Please try again or contact support.'**
  String get backendErrorPaymentVerificationFailed;

  /// No description provided for @backendErrorInvalidRequestBody.
  ///
  /// In en, this message translates to:
  /// **'Something in your request wasn\'t valid. Please check your input and try again.'**
  String get backendErrorInvalidRequestBody;

  /// No description provided for @backendErrorInvalidFitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Please choose one of the listed fitness goals.'**
  String get backendErrorInvalidFitnessGoal;

  /// No description provided for @backendErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get backendErrorGeneric;

  /// No description provided for @myInfoFitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goal'**
  String get myInfoFitnessGoal;

  /// No description provided for @fitnessGoalMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle Gain'**
  String get fitnessGoalMuscleGain;

  /// No description provided for @fitnessGoalWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight Loss'**
  String get fitnessGoalWeightLoss;

  /// No description provided for @fitnessGoalGeneralFitness.
  ///
  /// In en, this message translates to:
  /// **'General Fitness'**
  String get fitnessGoalGeneralFitness;

  /// No description provided for @fitnessGoalEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get fitnessGoalEndurance;

  /// No description provided for @fitnessGoalFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get fitnessGoalFlexibility;

  /// No description provided for @fitnessGoalConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get fitnessGoalConsistency;

  /// No description provided for @fitnessGoalWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get fitnessGoalWellness;

  /// No description provided for @myInfoFitnessGoalSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update fitness goal. Please try again.'**
  String get myInfoFitnessGoalSaveError;

  /// No description provided for @memberAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask About Your Gym'**
  String get memberAiTitle;

  /// No description provided for @memberAiInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about your sessions, classes, or membership...'**
  String get memberAiInputHint;

  /// No description provided for @memberAiEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your PT sessions, classes, or membership — I\'ll check your real data first.'**
  String get memberAiEmptyState;

  /// No description provided for @memberAiSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get memberAiSendButton;

  /// No description provided for @memberAiQuickQuestionSessionsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'How many PT sessions do I have this week?'**
  String get memberAiQuickQuestionSessionsThisWeek;

  /// No description provided for @memberAiQuickQuestionRemainingSessions.
  ///
  /// In en, this message translates to:
  /// **'How many PT package sessions do I have left?'**
  String get memberAiQuickQuestionRemainingSessions;

  /// No description provided for @memberAiQuickQuestionRecommendation.
  ///
  /// In en, this message translates to:
  /// **'What should I focus on based on my goal?'**
  String get memberAiQuickQuestionRecommendation;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found.'**
  String get routeNotFound;

  /// No description provided for @profileFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileFallbackLabel;

  /// No description provided for @genericHomeDataNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Home data is not loaded yet.'**
  String get genericHomeDataNotLoaded;

  /// No description provided for @paymentNotYetConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment not yet confirmed. Please try again in a moment.'**
  String get paymentNotYetConfirmed;

  /// No description provided for @planCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plan created successfully'**
  String get planCreatedSuccessfully;

  /// No description provided for @planUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plan updated successfully'**
  String get planUpdatedSuccessfully;

  /// No description provided for @classFilterBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get classFilterBookings;

  /// No description provided for @classFilterReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get classFilterReactivate;

  /// No description provided for @classFilterCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get classFilterCancel;

  /// No description provided for @classFilterEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get classFilterEdit;

  /// Generic error message shown in the error view
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get aiErrorGeneric;

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

  /// No description provided for @checkins_scanCheckedOutMsg.
  ///
  /// In en, this message translates to:
  /// **'checked out successfully'**
  String get checkins_scanCheckedOutMsg;

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

  /// No description provided for @checkins_noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number on file for this member.'**
  String get checkins_noPhoneNumber;

  /// No description provided for @checkins_callFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the call on this device.'**
  String get checkins_callFailed;

  /// No description provided for @checkins_entryPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get checkins_entryPlan;

  /// No description provided for @checkins_entryClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get checkins_entryClass;

  /// No description provided for @checkins_entryPt.
  ///
  /// In en, this message translates to:
  /// **'PT Session'**
  String get checkins_entryPt;

  /// No description provided for @checkins_reasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get checkins_reasonHint;

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

  /// No description provided for @checkins_visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get checkins_visits;

  /// No description provided for @checkins_durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String checkins_durationMinutes(Object minutes);

  /// No description provided for @checkins_filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get checkins_filterByDate;

  /// No description provided for @checkins_clearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Back to today'**
  String get checkins_clearDateFilter;

  /// No description provided for @checkins_allBranchesScanBlocked.
  ///
  /// In en, this message translates to:
  /// **'Select a specific branch to scan QR codes.'**
  String get checkins_allBranchesScanBlocked;

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

  /// No description provided for @memberBookingsCancelOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Options'**
  String get memberBookingsCancelOptionsTitle;

  /// No description provided for @memberBookingsCancelOnlyOption.
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get memberBookingsCancelOnlyOption;

  /// No description provided for @memberBookingsCancelOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Cancel this session without rescheduling'**
  String get memberBookingsCancelOnlyDesc;

  /// No description provided for @memberBookingsRescheduleOption.
  ///
  /// In en, this message translates to:
  /// **'Request reschedule'**
  String get memberBookingsRescheduleOption;

  /// No description provided for @memberBookingsRescheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'Cancel and propose a new date'**
  String get memberBookingsRescheduleDesc;

  /// No description provided for @memberBookingsSelectNewDate.
  ///
  /// In en, this message translates to:
  /// **'Select preferred date'**
  String get memberBookingsSelectNewDate;

  /// No description provided for @memberBookingsRescheduleRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Reschedule request sent'**
  String get memberBookingsRescheduleRequestSent;

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

  /// No description provided for @memberInvoicesRefundDeadline.
  ///
  /// In en, this message translates to:
  /// **'Refund by'**
  String get memberInvoicesRefundDeadline;

  /// No description provided for @memberInvoicesRefundedAmount.
  ///
  /// In en, this message translates to:
  /// **'Refunded Amount'**
  String get memberInvoicesRefundedAmount;

  /// No description provided for @memberInvoicesDeductedAmount.
  ///
  /// In en, this message translates to:
  /// **'Deducted Amount'**
  String get memberInvoicesDeductedAmount;

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

  /// No description provided for @admin_dashboard_tabMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get admin_dashboard_tabMembership;

  /// No description provided for @admin_dashboard_tabPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get admin_dashboard_tabPayments;

  /// No description provided for @admin_dashboard_tabAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get admin_dashboard_tabAttendance;

  /// No description provided for @admin_dashboard_cardHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the card for additional information.'**
  String get admin_dashboard_cardHint;

  /// No description provided for @admin_dashboard_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'coming soon'**
  String get admin_dashboard_comingSoon;

  /// No description provided for @admin_dashboard_lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get admin_dashboard_lastMonth;

  /// No description provided for @admin_dashboard_last3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 Months'**
  String get admin_dashboard_last3Months;

  /// No description provided for @admin_dashboard_sectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get admin_dashboard_sectionToday;

  /// No description provided for @admin_dashboard_sectionAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get admin_dashboard_sectionAttendance;

  /// No description provided for @admin_dashboard_sectionMembershipExpiry.
  ///
  /// In en, this message translates to:
  /// **'Membership Expiry'**
  String get admin_dashboard_sectionMembershipExpiry;

  /// No description provided for @admin_dashboard_sectionPtPlanExpiry.
  ///
  /// In en, this message translates to:
  /// **'PT Plan Expiry'**
  String get admin_dashboard_sectionPtPlanExpiry;

  /// No description provided for @admin_dashboard_sectionTodaysCollection.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Collection'**
  String get admin_dashboard_sectionTodaysCollection;

  /// No description provided for @admin_dashboard_birthdays.
  ///
  /// In en, this message translates to:
  /// **'Birthdays'**
  String get admin_dashboard_birthdays;

  /// No description provided for @admin_dashboard_expiresToday.
  ///
  /// In en, this message translates to:
  /// **'Expires Today'**
  String get admin_dashboard_expiresToday;

  /// No description provided for @admin_dashboard_ptExpiringToday.
  ///
  /// In en, this message translates to:
  /// **'PT Plan Expiring Today'**
  String get admin_dashboard_ptExpiringToday;

  /// No description provided for @admin_dashboard_monthlyCheckins.
  ///
  /// In en, this message translates to:
  /// **'Monthly Check-ins'**
  String get admin_dashboard_monthlyCheckins;

  /// No description provided for @admin_dashboard_uniqueMembersAttended.
  ///
  /// In en, this message translates to:
  /// **'Unique Members Attended'**
  String get admin_dashboard_uniqueMembersAttended;

  /// No description provided for @admin_dashboard_expiring1to3.
  ///
  /// In en, this message translates to:
  /// **'Expiring (1–3d)'**
  String get admin_dashboard_expiring1to3;

  /// No description provided for @admin_dashboard_expiring4to7.
  ///
  /// In en, this message translates to:
  /// **'Expiring (4–7d)'**
  String get admin_dashboard_expiring4to7;

  /// No description provided for @admin_dashboard_expiring8to15.
  ///
  /// In en, this message translates to:
  /// **'Expiring (8–15d)'**
  String get admin_dashboard_expiring8to15;

  /// No description provided for @admin_dashboard_ptExpiring1to7.
  ///
  /// In en, this message translates to:
  /// **'PT Expiring (1–7d)'**
  String get admin_dashboard_ptExpiring1to7;

  /// No description provided for @admin_dashboard_ptExpiring8to15.
  ///
  /// In en, this message translates to:
  /// **'PT Expiring (8–15d)'**
  String get admin_dashboard_ptExpiring8to15;

  /// No description provided for @admin_dashboard_recordAttendance.
  ///
  /// In en, this message translates to:
  /// **'Record Attendance'**
  String get admin_dashboard_recordAttendance;

  /// No description provided for @admin_dashboard_membershipCollectedToday.
  ///
  /// In en, this message translates to:
  /// **'Total Collected Today'**
  String get admin_dashboard_membershipCollectedToday;

  /// No description provided for @admin_dashboard_admissionFees.
  ///
  /// In en, this message translates to:
  /// **'Membership Collected'**
  String get admin_dashboard_admissionFees;

  /// No description provided for @admin_dashboard_membershipCollected.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue Collected'**
  String get admin_dashboard_membershipCollected;

  /// No description provided for @admin_dashboard_membershipDue.
  ///
  /// In en, this message translates to:
  /// **'Membership Due'**
  String get admin_dashboard_membershipDue;

  /// No description provided for @admin_dashboard_ptDue.
  ///
  /// In en, this message translates to:
  /// **'PT Due'**
  String get admin_dashboard_ptDue;

  /// No description provided for @admin_dashboard_servicePaid.
  ///
  /// In en, this message translates to:
  /// **'Service Paid'**
  String get admin_dashboard_servicePaid;

  /// No description provided for @admin_dashboard_serviceDue.
  ///
  /// In en, this message translates to:
  /// **'Service Due'**
  String get admin_dashboard_serviceDue;

  /// No description provided for @admin_dashboard_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get admin_dashboard_expense;

  /// No description provided for @admin_dashboard_upcomingPtSessions.
  ///
  /// In en, this message translates to:
  /// **'Upcoming PT Sessions'**
  String get admin_dashboard_upcomingPtSessions;

  /// No description provided for @admin_dashboard_attendanceGrowth.
  ///
  /// In en, this message translates to:
  /// **'Attendance Growth'**
  String get admin_dashboard_attendanceGrowth;

  /// No description provided for @admin_dashboard_absentMembers.
  ///
  /// In en, this message translates to:
  /// **'Absent Members'**
  String get admin_dashboard_absentMembers;

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

  /// No description provided for @admin_expenses_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get admin_expenses_deleteTitle;

  /// No description provided for @admin_expenses_deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense?'**
  String get admin_expenses_deleteMessage;

  /// No description provided for @admin_expenses_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_expenses_delete;

  /// No description provided for @admin_expenses_allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Transaction Types'**
  String get admin_expenses_allCategories;

  /// No description provided for @admin_expenses_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search expenses...'**
  String get admin_expenses_searchHint;

  /// No description provided for @admin_expenses_noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get admin_expenses_noExpenses;

  /// No description provided for @admin_expenses_confirmPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Commission Payout'**
  String get admin_expenses_confirmPaidTitle;

  /// No description provided for @admin_expenses_confirmPaidMessage.
  ///
  /// In en, this message translates to:
  /// **'Confirm that you have paid this commission to the trainer? It will then be added to the trainer\'s income and counted in gym expenses.'**
  String get admin_expenses_confirmPaidMessage;

  /// No description provided for @admin_expenses_confirmPaid.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get admin_expenses_confirmPaid;

  /// No description provided for @balance_sheet_netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get balance_sheet_netProfit;

  /// No description provided for @balance_sheet_collection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get balance_sheet_collection;

  /// No description provided for @balance_sheet_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get balance_sheet_expense;

  /// No description provided for @balance_sheet_collectionTab.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get balance_sheet_collectionTab;

  /// No description provided for @balance_sheet_expenseTab.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get balance_sheet_expenseTab;

  /// No description provided for @balance_sheet_filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get balance_sheet_filterToday;

  /// No description provided for @balance_sheet_filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get balance_sheet_filterThisWeek;

  /// No description provided for @balance_sheet_filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get balance_sheet_filterThisMonth;

  /// No description provided for @balance_sheet_filterThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get balance_sheet_filterThisYear;

  /// No description provided for @balance_sheet_filterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get balance_sheet_filterAllTime;

  /// No description provided for @balance_sheet_filterCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get balance_sheet_filterCustom;

  /// No description provided for @balance_sheet_noCollections.
  ///
  /// In en, this message translates to:
  /// **'No collections in this period'**
  String get balance_sheet_noCollections;

  /// No description provided for @balance_sheet_noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses in this period'**
  String get balance_sheet_noExpenses;

  /// No description provided for @balance_sheet_selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get balance_sheet_selectDateRange;

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

  /// No description provided for @roleAccess_title.
  ///
  /// In en, this message translates to:
  /// **'Staff Access Control'**
  String get roleAccess_title;

  /// No description provided for @roleAccess_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what Trainers and Reception staff can see and access in their navigation menu.'**
  String get roleAccess_subtitle;

  /// No description provided for @roleAccess_trainerColumn.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get roleAccess_trainerColumn;

  /// No description provided for @roleAccess_receptionColumn.
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get roleAccess_receptionColumn;

  /// No description provided for @roleAccess_unsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get roleAccess_unsaved;

  /// No description provided for @roleAccess_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get roleAccess_saving;

  /// No description provided for @roleAccess_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get roleAccess_saveChanges;

  /// No description provided for @roleAccess_saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Permissions saved successfully'**
  String get roleAccess_saveSuccess;

  /// No description provided for @roleAccess_saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save permissions'**
  String get roleAccess_saveFailed;

  /// No description provided for @roleAccess_notAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Only the gym owner can manage staff access permissions.'**
  String get roleAccess_notAuthorized;

  /// No description provided for @roleAccess_modeAllStaff.
  ///
  /// In en, this message translates to:
  /// **'All Staff'**
  String get roleAccess_modeAllStaff;

  /// No description provided for @roleAccess_modeSpecificAccount.
  ///
  /// In en, this message translates to:
  /// **'Specific Account'**
  String get roleAccess_modeSpecificAccount;

  /// No description provided for @roleAccess_pickStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Select a staff member'**
  String get roleAccess_pickStaffMember;

  /// No description provided for @roleAccess_noStaffAccounts.
  ///
  /// In en, this message translates to:
  /// **'No trainer or reception accounts yet.'**
  String get roleAccess_noStaffAccounts;

  /// No description provided for @roleAccess_selectAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pick a trainer or reception account above to edit their specific permissions.'**
  String get roleAccess_selectAccountPrompt;

  /// No description provided for @roleAccess_useDefault.
  ///
  /// In en, this message translates to:
  /// **'Use Default'**
  String get roleAccess_useDefault;

  /// No description provided for @roleAccess_alwaysAllow.
  ///
  /// In en, this message translates to:
  /// **'Always Allow'**
  String get roleAccess_alwaysAllow;

  /// No description provided for @roleAccess_alwaysDeny.
  ///
  /// In en, this message translates to:
  /// **'Always Deny'**
  String get roleAccess_alwaysDeny;

  /// No description provided for @roleAccess_defaultOn.
  ///
  /// In en, this message translates to:
  /// **'(default: on)'**
  String get roleAccess_defaultOn;

  /// No description provided for @roleAccess_defaultOff.
  ///
  /// In en, this message translates to:
  /// **'(default: off)'**
  String get roleAccess_defaultOff;

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

  /// No description provided for @admin_membershipRequests_approveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Membership request approved'**
  String get admin_membershipRequests_approveSuccess;

  /// No description provided for @admin_membershipRequests_rejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Membership request rejected'**
  String get admin_membershipRequests_rejectSuccess;

  /// No description provided for @admin_membershipRequests_tab.
  ///
  /// In en, this message translates to:
  /// **'Membership Requests'**
  String get admin_membershipRequests_tab;

  /// No description provided for @admin_refundRequests_tab.
  ///
  /// In en, this message translates to:
  /// **'Refund Requests'**
  String get admin_refundRequests_tab;

  /// No description provided for @admin_refundRequests_noPending.
  ///
  /// In en, this message translates to:
  /// **'No pending refund requests'**
  String get admin_refundRequests_noPending;

  /// No description provided for @admin_refundRequests_noPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Member refund requests will appear here'**
  String get admin_refundRequests_noPendingDesc;

  /// No description provided for @admin_refundRequests_pendingBadge.
  ///
  /// In en, this message translates to:
  /// **'Pending Refund'**
  String get admin_refundRequests_pendingBadge;

  /// No description provided for @admin_refundRequests_requestedAmount.
  ///
  /// In en, this message translates to:
  /// **'Requested Amount'**
  String get admin_refundRequests_requestedAmount;

  /// No description provided for @admin_refundRequests_reason.
  ///
  /// In en, this message translates to:
  /// **'Member Reason'**
  String get admin_refundRequests_reason;

  /// No description provided for @admin_refundRequests_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get admin_refundRequests_reject;

  /// No description provided for @admin_refundRequests_process.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get admin_refundRequests_process;

  /// No description provided for @admin_refundRequests_processTitle.
  ///
  /// In en, this message translates to:
  /// **'Process Refund'**
  String get admin_refundRequests_processTitle;

  /// No description provided for @admin_refundRequests_refundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund Amount'**
  String get admin_refundRequests_refundAmount;

  /// No description provided for @admin_refundRequests_refundAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount to refund'**
  String get admin_refundRequests_refundAmountHint;

  /// No description provided for @admin_refundRequests_deductionAmount.
  ///
  /// In en, this message translates to:
  /// **'Deduction (Fee)'**
  String get admin_refundRequests_deductionAmount;

  /// No description provided for @admin_refundRequests_deductionHint.
  ///
  /// In en, this message translates to:
  /// **'Deduction amount (optional)'**
  String get admin_refundRequests_deductionHint;

  /// No description provided for @admin_refundRequests_adminNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Admin note (optional)'**
  String get admin_refundRequests_adminNoteHint;

  /// No description provided for @admin_refundRequests_approveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve Refund — \$ {amount}'**
  String admin_refundRequests_approveButton(String amount);

  /// No description provided for @admin_refundRequests_rejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Refund Request'**
  String get admin_refundRequests_rejectTitle;

  /// No description provided for @admin_refundRequests_rejectHint.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason (required)'**
  String get admin_refundRequests_rejectHint;

  /// No description provided for @admin_refundRequests_rejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get admin_refundRequests_rejectButton;

  /// No description provided for @admin_refundRequests_enterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a rejection reason'**
  String get admin_refundRequests_enterReason;

  /// No description provided for @admin_refundRequests_enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid refund amount'**
  String get admin_refundRequests_enterAmount;

  /// No description provided for @admin_refundRequests_approveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Refund request approved'**
  String get admin_refundRequests_approveSuccess;

  /// No description provided for @admin_refundRequests_rejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Refund request rejected'**
  String get admin_refundRequests_rejectSuccess;

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
  /// **'Inactive Membership'**
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

  /// No description provided for @admin_invoices_recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get admin_invoices_recordPayment;

  /// No description provided for @admin_invoices_paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded.'**
  String get admin_invoices_paymentRecorded;

  /// No description provided for @admin_invoices_balanceDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance due: \$ {amount}'**
  String admin_invoices_balanceDueLabel(String amount);

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

  /// No description provided for @admin_classes_selectTrainerFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a trainer first'**
  String get admin_classes_selectTrainerFirst;

  /// No description provided for @admin_classes_noServicesForTrainer.
  ///
  /// In en, this message translates to:
  /// **'No services for this trainer'**
  String get admin_classes_noServicesForTrainer;

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

  /// No description provided for @admin_classes_statusCancelRequested.
  ///
  /// In en, this message translates to:
  /// **'Cancel Requested'**
  String get admin_classes_statusCancelRequested;

  /// No description provided for @admin_classes_approveCancellation.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get admin_classes_approveCancellation;

  /// No description provided for @admin_classes_declineCancellation.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get admin_classes_declineCancellation;

  /// No description provided for @admin_classes_cancellationApproved.
  ///
  /// In en, this message translates to:
  /// **'Cancellation approved'**
  String get admin_classes_cancellationApproved;

  /// No description provided for @admin_classes_cancellationDeclined.
  ///
  /// In en, this message translates to:
  /// **'Cancellation declined'**
  String get admin_classes_cancellationDeclined;

  /// No description provided for @admin_classes_collectBalance.
  ///
  /// In en, this message translates to:
  /// **'Collect Balance'**
  String get admin_classes_collectBalance;

  /// Shows the class price inside the confirm-payment dialog so the admin knows how much to collect.
  ///
  /// In en, this message translates to:
  /// **'Class price: {price}'**
  String admin_classes_classPriceLabel(String price);

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

  /// No description provided for @admin_settings_biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available or was cancelled.'**
  String get admin_settings_biometricUnavailable;

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

  /// No description provided for @admin_settings_allowPtBookingWithoutMembership.
  ///
  /// In en, this message translates to:
  /// **'Allow PT booking without membership'**
  String get admin_settings_allowPtBookingWithoutMembership;

  /// No description provided for @admin_settings_allowPtBookingWithoutMembershipDesc.
  ///
  /// In en, this message translates to:
  /// **'Members can book personal training sessions without an active membership plan'**
  String get admin_settings_allowPtBookingWithoutMembershipDesc;

  /// No description provided for @admin_settings_refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get admin_settings_refundPolicy;

  /// No description provided for @admin_settings_refundPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure time window for refund eligibility per purchase type'**
  String get admin_settings_refundPolicyDesc;

  /// No description provided for @admin_settings_planRefundWindow.
  ///
  /// In en, this message translates to:
  /// **'Plan Refund Window (hours)'**
  String get admin_settings_planRefundWindow;

  /// No description provided for @admin_settings_planRefundWindowDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for no limit · Enter 0 to disable plan refunds'**
  String get admin_settings_planRefundWindowDesc;

  /// No description provided for @admin_settings_classRefundWindow.
  ///
  /// In en, this message translates to:
  /// **'Class Booking Refund Window (hours)'**
  String get admin_settings_classRefundWindow;

  /// No description provided for @admin_settings_classRefundWindowDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for no limit · Enter 0 to disable class refunds'**
  String get admin_settings_classRefundWindowDesc;

  /// No description provided for @admin_settings_ptPackageRefundWindow.
  ///
  /// In en, this message translates to:
  /// **'PT Package Refund Window (hours)'**
  String get admin_settings_ptPackageRefundWindow;

  /// No description provided for @admin_settings_ptPackageRefundWindowDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for no limit · Enter 0 to disable PT package refunds'**
  String get admin_settings_ptPackageRefundWindowDesc;

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

  /// No description provided for @trainer_newServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a personal training service'**
  String get trainer_newServiceSubtitle;

  /// No description provided for @trainer_editServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update this service\'s details'**
  String get trainer_editServiceSubtitle;

  /// No description provided for @trainer_sectionBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get trainer_sectionBasicInfo;

  /// No description provided for @trainer_sectionPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get trainer_sectionPricing;

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

  /// No description provided for @trainer_newPackageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Define sessions, pricing & validity'**
  String get trainer_newPackageSubtitle;

  /// No description provided for @trainer_editPackageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update this package\'s details'**
  String get trainer_editPackageSubtitle;

  /// No description provided for @trainer_sectionSessionsSchedule.
  ///
  /// In en, this message translates to:
  /// **'Sessions & Schedule'**
  String get trainer_sectionSessionsSchedule;

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

  /// No description provided for @trainer_addSlotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a recurring or one-time time slot'**
  String get trainer_addSlotSubtitle;

  /// No description provided for @trainer_sectionTiming.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get trainer_sectionTiming;

  /// No description provided for @trainer_sectionAvailabilityType.
  ///
  /// In en, this message translates to:
  /// **'Availability Type'**
  String get trainer_sectionAvailabilityType;

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

  /// No description provided for @trainer_navIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get trainer_navIncome;

  String get trainer_compensationTypeLabel;
  String get trainer_compensationSalary;
  String get trainer_compensationCommission;
  String get trainer_commissionPercentageHint;

  /// No description provided for @trainer_commissionPercentageLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainer Commission %'**
  String get trainer_commissionPercentageLabel;

  /// No description provided for @trainer_commissionValue.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String trainer_commissionValue(String percent);

  /// No description provided for @trainer_commissionRangeError.
  ///
  /// In en, this message translates to:
  /// **'Must be between 0 and 100'**
  String get trainer_commissionRangeError;

  /// No description provided for @trainer_linkedPtServiceRequired.
  ///
  /// In en, this message translates to:
  /// **'Linked PT Service'**
  String get trainer_linkedPtServiceRequired;

  /// No description provided for @trainer_selectServiceRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get trainer_selectServiceRequired;

  /// No description provided for @trainer_incomeAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainer Income'**
  String get trainer_incomeAllTitle;

  /// No description provided for @trainer_incomeMyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Income'**
  String get trainer_incomeMyTitle;

  /// No description provided for @trainer_incomeSelectTrainer.
  ///
  /// In en, this message translates to:
  /// **'Select a trainer to view their income.'**
  String get trainer_incomeSelectTrainer;

  /// No description provided for @trainer_incomeTotalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get trainer_incomeTotalSessions;

  /// No description provided for @trainer_incomeTotalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get trainer_incomeTotalEarning;

  /// No description provided for @trainer_incomeNoData.
  ///
  /// In en, this message translates to:
  /// **'No paid sessions in this date range.'**
  String get trainer_incomeNoData;

  /// No description provided for @trainer_incomeSalaryPayment.
  ///
  /// In en, this message translates to:
  /// **'Salary payment'**
  String get trainer_incomeSalaryPayment;

  /// No description provided for @trainer_incomeCommissionPayment.
  ///
  /// In en, this message translates to:
  /// **'Commission payment'**
  String get trainer_incomeCommissionPayment;

  /// No description provided for @trainer_incomeClassSession.
  ///
  /// In en, this message translates to:
  /// **'Class session'**
  String get trainer_incomeClassSession;

  /// No description provided for @trainer_commissionOfPrice.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of \${price}'**
  String trainer_commissionOfPrice(String percent, String price);

  /// No description provided for @trainer_markAsPaidButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get trainer_markAsPaidButton;

  /// No description provided for @trainer_ptSession.
  ///
  /// In en, this message translates to:
  /// **'PT Session'**
  String get trainer_ptSession;

  /// No description provided for @trainer_gymClass.
  ///
  /// In en, this message translates to:
  /// **'Gym Class'**
  String get trainer_gymClass;

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

  /// No description provided for @trainer_statusCancelRequested.
  ///
  /// In en, this message translates to:
  /// **'cancel requested'**
  String get trainer_statusCancelRequested;

  /// No description provided for @trainer_approveCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get trainer_approveCancelButton;

  /// No description provided for @trainer_keepSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Keep Session'**
  String get trainer_keepSessionButton;

  /// No description provided for @trainer_cancelRequestApproved.
  ///
  /// In en, this message translates to:
  /// **'Cancellation approved'**
  String get trainer_cancelRequestApproved;

  /// No description provided for @trainer_cancelRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Session kept, request declined'**
  String get trainer_cancelRequestDeclined;

  /// No description provided for @trainer_approveCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve Cancellation'**
  String get trainer_approveCancelTitle;

  /// No description provided for @trainer_approveCancelMessage.
  ///
  /// In en, this message translates to:
  /// **'The session will be cancelled and the member will be notified.'**
  String get trainer_approveCancelMessage;

  /// No description provided for @trainer_declineCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline Cancellation'**
  String get trainer_declineCancelTitle;

  /// No description provided for @trainer_declineCancelMessage.
  ///
  /// In en, this message translates to:
  /// **'The session will remain scheduled and the member\'s request will be declined.'**
  String get trainer_declineCancelMessage;

  /// No description provided for @trainer_memberRequestedDate.
  ///
  /// In en, this message translates to:
  /// **'Member proposed: {date}'**
  String trainer_memberRequestedDate(String date);

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

  /// No description provided for @trainer_rejectCashPayment.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get trainer_rejectCashPayment;

  /// No description provided for @trainer_rejecting.
  ///
  /// In en, this message translates to:
  /// **'Rejecting...'**
  String get trainer_rejecting;

  /// No description provided for @trainer_cashPaymentRejected.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected.'**
  String get trainer_cashPaymentRejected;

  /// No description provided for @trainer_rejectPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Payment'**
  String get trainer_rejectPaymentTitle;

  /// No description provided for @trainer_rejectPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Reason for rejection'**
  String get trainer_rejectPaymentHint;

  /// No description provided for @trainer_rejectPaymentReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get trainer_rejectPaymentReasonRequired;

  /// No description provided for @trainer_dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get trainer_dateLabel;

  /// No description provided for @trainer_partialPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter less than the full amount to record a partial payment — the trainer\'s commission won\'t count until the balance is paid in full.'**
  String get trainer_partialPaymentHint;

  /// No description provided for @trainer_amountToCollectLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount to collect'**
  String get trainer_amountToCollectLabel;

  /// No description provided for @trainer_invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get trainer_invalidAmount;

  /// No description provided for @trainer_amountExceedsTotal.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed the total'**
  String get trainer_amountExceedsTotal;

  /// No description provided for @promotionPrice.
  ///
  /// In en, this message translates to:
  /// **'Promotion price'**
  String get promotionPrice;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get settingsUnsaved;

  /// No description provided for @settingsUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get settingsUnexpectedError;

  /// No description provided for @settingsTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get settingsTryAgain;

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSavedSuccessfully;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get settingsSaveFailed;

  /// No description provided for @settingsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get settingsSaving;

  /// No description provided for @settingsSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get settingsSaveChanges;

  /// No description provided for @settingsLanguageRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get settingsLanguageRegionTitle;

  /// No description provided for @settingsLanguageRegionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settingsLanguageRegionSubtitle;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageEnglishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default language'**
  String get settingsLanguageEnglishSubtitle;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageArabicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arabic language'**
  String get settingsLanguageArabicSubtitle;

  /// No description provided for @settingsLanguageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsLanguageSystemDefault;

  /// No description provided for @settingsLanguageSystemDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get settingsLanguageSystemDefaultSubtitle;

  /// No description provided for @branchDialog_setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Up Your First Branch'**
  String get branchDialog_setupTitle;

  /// No description provided for @branchDialog_setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your main gym location to start managing members, plans, check-ins, and more.'**
  String get branchDialog_setupSubtitle;

  /// No description provided for @branchDialog_sectionBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get branchDialog_sectionBasic;

  /// No description provided for @branchDialog_name.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchDialog_name;

  /// No description provided for @branchDialog_nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Gym – Downtown'**
  String get branchDialog_nameHint;

  /// No description provided for @branchDialog_nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch name is required'**
  String get branchDialog_nameRequired;

  /// No description provided for @branchDialog_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get branchDialog_city;

  /// No description provided for @branchDialog_cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cairo'**
  String get branchDialog_cityHint;

  /// No description provided for @branchDialog_cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get branchDialog_cityRequired;

  /// No description provided for @branchDialog_sectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get branchDialog_sectionContact;

  /// No description provided for @branchDialog_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get branchDialog_phone;

  /// No description provided for @branchDialog_phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+20 100 000 0000'**
  String get branchDialog_phoneHint;

  /// No description provided for @branchDialog_phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get branchDialog_phoneRequired;

  /// No description provided for @branchDialog_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get branchDialog_email;

  /// No description provided for @branchDialog_emailHint.
  ///
  /// In en, this message translates to:
  /// **'branch@yourgym.com'**
  String get branchDialog_emailHint;

  /// No description provided for @branchDialog_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get branchDialog_emailRequired;

  /// No description provided for @branchDialog_emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get branchDialog_emailInvalid;

  /// No description provided for @branchDialog_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get branchDialog_address;

  /// No description provided for @branchDialog_addressHint.
  ///
  /// In en, this message translates to:
  /// **'123 Main St, Downtown'**
  String get branchDialog_addressHint;

  /// No description provided for @branchDialog_addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get branchDialog_addressRequired;

  /// No description provided for @branchDialog_sectionHours.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get branchDialog_sectionHours;

  /// No description provided for @branchDialog_open24.
  ///
  /// In en, this message translates to:
  /// **'Open 24 Hours'**
  String get branchDialog_open24;

  /// No description provided for @branchDialog_open24Sub.
  ///
  /// In en, this message translates to:
  /// **'Branch is always open'**
  String get branchDialog_open24Sub;

  /// No description provided for @branchDialog_opening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get branchDialog_opening;

  /// No description provided for @branchDialog_closing.
  ///
  /// In en, this message translates to:
  /// **'Closing'**
  String get branchDialog_closing;

  /// No description provided for @branchDialog_tapToSet.
  ///
  /// In en, this message translates to:
  /// **'Tap to set'**
  String get branchDialog_tapToSet;

  /// No description provided for @branchDialog_closingAfterOpening.
  ///
  /// In en, this message translates to:
  /// **'Closing time must be after opening time'**
  String get branchDialog_closingAfterOpening;

  /// No description provided for @branchDialog_selectOpening.
  ///
  /// In en, this message translates to:
  /// **'Please select an opening time'**
  String get branchDialog_selectOpening;

  /// No description provided for @branchDialog_selectClosing.
  ///
  /// In en, this message translates to:
  /// **'Please select a closing time'**
  String get branchDialog_selectClosing;

  /// No description provided for @branchDialog_create.
  ///
  /// In en, this message translates to:
  /// **'Create Branch'**
  String get branchDialog_create;

  /// No description provided for @branchDialog_createdSuccess.
  ///
  /// In en, this message translates to:
  /// **'Branch created successfully!'**
  String get branchDialog_createdSuccess;

  /// No description provided for @branchDialog_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get branchDialog_next;

  /// No description provided for @branchDialog_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get branchDialog_back;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @reports_tabFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get reports_tabFinancial;

  /// No description provided for @reports_tabAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get reports_tabAttendance;

  /// No description provided for @reports_collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get reports_collected;

  /// No description provided for @reports_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get reports_expense;

  /// No description provided for @reports_net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get reports_net;

  /// No description provided for @reports_totalCheckins.
  ///
  /// In en, this message translates to:
  /// **'Total Check-ins'**
  String get reports_totalCheckins;

  /// No description provided for @reports_uniqueMembers.
  ///
  /// In en, this message translates to:
  /// **'Unique Members'**
  String get reports_uniqueMembers;

  /// No description provided for @reports_avgPerDay.
  ///
  /// In en, this message translates to:
  /// **'Avg / Day'**
  String get reports_avgPerDay;

  /// No description provided for @reports_collectedOverTime.
  ///
  /// In en, this message translates to:
  /// **'Collected Over Time'**
  String get reports_collectedOverTime;

  /// No description provided for @reports_expenseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense by Category'**
  String get reports_expenseByCategory;

  /// No description provided for @reports_checkinsOverTime.
  ///
  /// In en, this message translates to:
  /// **'Check-ins Over Time'**
  String get reports_checkinsOverTime;

  /// No description provided for @reports_noData.
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get reports_noData;

  /// No description provided for @sectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get sectionOverview;

  /// No description provided for @sectionMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get sectionMembers;

  /// No description provided for @sectionFrontDesk.
  ///
  /// In en, this message translates to:
  /// **'Front Desk'**
  String get sectionFrontDesk;

  /// No description provided for @sectionTrainingClasses.
  ///
  /// In en, this message translates to:
  /// **'Training & Classes'**
  String get sectionTrainingClasses;

  /// No description provided for @sectionFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get sectionFinance;

  /// No description provided for @sectionSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get sectionSetup;

  /// No description provided for @sectionTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get sectionTools;

  /// No description provided for @admin_classes_sectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Class Details'**
  String get admin_classes_sectionDetails;

  /// No description provided for @admin_classes_sectionSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get admin_classes_sectionSchedule;

  /// No description provided for @admin_classes_sectionCapacityRoom.
  ///
  /// In en, this message translates to:
  /// **'Capacity & Room'**
  String get admin_classes_sectionCapacityRoom;

  /// No description provided for @admin_classes_sectionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get admin_classes_sectionNotes;

  /// No description provided for @admin_classes_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_classes_required;

  /// No description provided for @admin_classes_mustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'Must be a number'**
  String get admin_classes_mustBeNumber;

  /// No description provided for @admin_classes_nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Morning Yoga Flow'**
  String get admin_classes_nameHint;

  /// No description provided for @admin_classes_durationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 60'**
  String get admin_classes_durationHint;

  /// No description provided for @admin_classes_capacityHint.
  ///
  /// In en, this message translates to:
  /// **'Maximum participants'**
  String get admin_classes_capacityHint;

  /// No description provided for @admin_classes_roomHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hall 1, 2nd Floor'**
  String get admin_classes_roomHint;

  /// No description provided for @admin_classes_commissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainer Commission % (optional)'**
  String get admin_classes_commissionLabel;

  /// No description provided for @admin_classes_commissionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get admin_classes_commissionHint;

  /// No description provided for @admin_classes_removeCommission.
  ///
  /// In en, this message translates to:
  /// **'Remove the existing commission % for this class'**
  String get admin_classes_removeCommission;

  /// No description provided for @admin_classes_notesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Additional class notes'**
  String get admin_classes_notesHint;

  /// No description provided for @admin_classes_createTypeButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get admin_classes_createTypeButton;

  /// No description provided for @admin_classes_typeExists.
  ///
  /// In en, this message translates to:
  /// **'This type already exists — select it from the list'**
  String get admin_classes_typeExists;

  /// No description provided for @admin_classes_typeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get admin_classes_typeNameLabel;

  /// No description provided for @admin_classes_typeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Yoga, CrossFit'**
  String get admin_classes_typeNameHint;

  /// No description provided for @admin_classes_typeDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes) *'**
  String get admin_classes_typeDurationLabel;

  /// No description provided for @admin_classes_typeDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level'**
  String get admin_classes_typeDifficultyLabel;

  /// No description provided for @admin_classes_typePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get admin_classes_typePriceLabel;

  /// No description provided for @admin_classes_diffBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get admin_classes_diffBeginner;

  /// No description provided for @admin_classes_diffIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get admin_classes_diffIntermediate;

  /// No description provided for @admin_classes_diffAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get admin_classes_diffAdvanced;

  /// No description provided for @admin_expenses_addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get admin_expenses_addTitle;

  /// No description provided for @admin_expenses_editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get admin_expenses_editTitle;

  /// No description provided for @admin_expenses_sectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get admin_expenses_sectionDetails;

  /// No description provided for @admin_expenses_titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get admin_expenses_titleLabel;

  /// No description provided for @admin_expenses_titleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Electricity bill'**
  String get admin_expenses_titleHint;

  /// No description provided for @admin_expenses_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_expenses_required;

  /// No description provided for @admin_expenses_descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admin_expenses_descriptionLabel;

  /// No description provided for @admin_expenses_descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes'**
  String get admin_expenses_descriptionHint;

  /// No description provided for @admin_expenses_amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount *'**
  String get admin_expenses_amountLabel;

  /// No description provided for @admin_expenses_invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get admin_expenses_invalidAmount;

  /// No description provided for @admin_expenses_dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get admin_expenses_dateLabel;

  /// No description provided for @admin_expenses_categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get admin_expenses_categoryLabel;

  /// No description provided for @admin_expenses_selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get admin_expenses_selectCategory;

  /// No description provided for @admin_expenses_branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch *'**
  String get admin_expenses_branchLabel;

  /// No description provided for @admin_expenses_selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_expenses_selectBranch;

  /// No description provided for @admin_expenses_selectBranchError.
  ///
  /// In en, this message translates to:
  /// **'Please select a branch'**
  String get admin_expenses_selectBranchError;

  /// No description provided for @admin_expenses_addedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get admin_expenses_addedSuccess;

  /// No description provided for @admin_expenses_updatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense updated successfully'**
  String get admin_expenses_updatedSuccess;

  /// No description provided for @admin_expenses_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_expenses_saveChanges;

  /// No description provided for @admin_staff_addSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to add a new staff member to your gym'**
  String get admin_staff_addSubtitle;

  /// No description provided for @admin_staff_sectionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get admin_staff_sectionPersonal;

  /// No description provided for @admin_staff_fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get admin_staff_fullNameLabel;

  /// No description provided for @admin_staff_fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get admin_staff_fullNameRequired;

  /// No description provided for @admin_staff_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get admin_staff_emailLabel;

  /// No description provided for @admin_staff_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get admin_staff_emailRequired;

  /// No description provided for @admin_staff_emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get admin_staff_emailInvalid;

  /// No description provided for @admin_staff_phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get admin_staff_phoneLabel;

  /// No description provided for @admin_staff_phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get admin_staff_phoneRequired;

  /// No description provided for @admin_staff_roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get admin_staff_roleLabel;

  /// No description provided for @admin_staff_roleRequired.
  ///
  /// In en, this message translates to:
  /// **'Role is required'**
  String get admin_staff_roleRequired;

  /// No description provided for @admin_staff_branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch Assignment'**
  String get admin_staff_branchLabel;

  /// No description provided for @admin_staff_branchRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch is required'**
  String get admin_staff_branchRequired;

  /// No description provided for @admin_staff_passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get admin_staff_passwordLabel;

  /// No description provided for @admin_staff_passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Auto-generate or enter'**
  String get admin_staff_passwordHint;

  /// No description provided for @admin_staff_passwordHelp.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to auto-generate a secure password'**
  String get admin_staff_passwordHelp;

  /// No description provided for @admin_staff_addButton.
  ///
  /// In en, this message translates to:
  /// **'Add Staff Member'**
  String get admin_staff_addButton;

  /// No description provided for @admin_staff_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_staff_saveChanges;

  /// No description provided for @admin_plans_sectionBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get admin_plans_sectionBasic;

  /// No description provided for @admin_plans_sectionMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership Settings'**
  String get admin_plans_sectionMembership;

  /// No description provided for @admin_plans_sectionAccessHours.
  ///
  /// In en, this message translates to:
  /// **'Access Hours'**
  String get admin_plans_sectionAccessHours;

  /// No description provided for @admin_plans_sectionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Plan Features'**
  String get admin_plans_sectionFeatures;

  /// No description provided for @admin_plans_sectionPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get admin_plans_sectionPromotion;

  /// No description provided for @admin_plans_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_plans_required;

  /// No description provided for @admin_plans_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get admin_plans_invalid;

  /// No description provided for @admin_plans_nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan Name *'**
  String get admin_plans_nameLabel;

  /// No description provided for @admin_plans_typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type / Activity *'**
  String get admin_plans_typeLabel;

  /// No description provided for @admin_plans_typeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter type (e.g. Yoga)'**
  String get admin_plans_typeHint;

  /// No description provided for @admin_plans_selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get admin_plans_selectType;

  /// No description provided for @admin_plans_addNewType.
  ///
  /// In en, this message translates to:
  /// **'Add new type…'**
  String get admin_plans_addNewType;

  /// No description provided for @admin_plans_priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get admin_plans_priceLabel;

  /// No description provided for @admin_plans_durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration *'**
  String get admin_plans_durationLabel;

  /// No description provided for @admin_plans_customDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Duration (days) *'**
  String get admin_plans_customDurationLabel;

  /// No description provided for @admin_plans_enterDays.
  ///
  /// In en, this message translates to:
  /// **'Enter number of days'**
  String get admin_plans_enterDays;

  /// No description provided for @admin_plans_mustBeWhole.
  ///
  /// In en, this message translates to:
  /// **'Must be a whole number'**
  String get admin_plans_mustBeWhole;

  /// No description provided for @admin_plans_statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status *'**
  String get admin_plans_statusLabel;

  /// No description provided for @admin_plans_descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admin_plans_descriptionLabel;

  /// No description provided for @admin_plans_descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional plan description'**
  String get admin_plans_descriptionHint;

  /// No description provided for @admin_plans_allowedVisits.
  ///
  /// In en, this message translates to:
  /// **'Allowed Visits'**
  String get admin_plans_allowedVisits;

  /// No description provided for @admin_plans_unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get admin_plans_unlimited;

  /// No description provided for @admin_plans_limited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get admin_plans_limited;

  /// No description provided for @admin_plans_numberOfVisits.
  ///
  /// In en, this message translates to:
  /// **'Number of visits'**
  String get admin_plans_numberOfVisits;

  /// No description provided for @admin_plans_enterVisitCount.
  ///
  /// In en, this message translates to:
  /// **'Enter visit count'**
  String get admin_plans_enterVisitCount;

  /// No description provided for @admin_plans_gracePeriod.
  ///
  /// In en, this message translates to:
  /// **'Grace Period (Days)'**
  String get admin_plans_gracePeriod;

  /// No description provided for @admin_plans_gracePeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Days after expiry before suspension'**
  String get admin_plans_gracePeriodHint;

  /// No description provided for @admin_plans_autoRenew.
  ///
  /// In en, this message translates to:
  /// **'Auto Renew'**
  String get admin_plans_autoRenew;

  /// No description provided for @admin_plans_autoRenewSub.
  ///
  /// In en, this message translates to:
  /// **'Renew automatically on expiry'**
  String get admin_plans_autoRenewSub;

  /// No description provided for @admin_plans_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Plan'**
  String get admin_plans_featured;

  /// No description provided for @admin_plans_featuredSub.
  ///
  /// In en, this message translates to:
  /// **'Highlight on member browse screen'**
  String get admin_plans_featuredSub;

  /// No description provided for @admin_plans_restrictHours.
  ///
  /// In en, this message translates to:
  /// **'Restrict Entry Hours'**
  String get admin_plans_restrictHours;

  /// No description provided for @admin_plans_restrictOn.
  ///
  /// In en, this message translates to:
  /// **'Members can only enter between the times below'**
  String get admin_plans_restrictOn;

  /// No description provided for @admin_plans_restrictOff.
  ///
  /// In en, this message translates to:
  /// **'Members can enter at any time'**
  String get admin_plans_restrictOff;

  /// No description provided for @admin_plans_entryWindow.
  ///
  /// In en, this message translates to:
  /// **'Allowed Entry Window'**
  String get admin_plans_entryWindow;

  /// No description provided for @admin_plans_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get admin_plans_from;

  /// No description provided for @admin_plans_until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get admin_plans_until;

  /// No description provided for @admin_plans_accessNote.
  ///
  /// In en, this message translates to:
  /// **'Members with booked sessions or PT can always enter during their session window.'**
  String get admin_plans_accessNote;

  /// No description provided for @admin_plans_featuresHint.
  ///
  /// In en, this message translates to:
  /// **'Add features members will see on this plan (e.g. Pool Access, WiFi)'**
  String get admin_plans_featuresHint;

  /// No description provided for @admin_plans_featureHint.
  ///
  /// In en, this message translates to:
  /// **'Feature (e.g. WiFi)'**
  String get admin_plans_featureHint;

  /// No description provided for @admin_plans_valueOptional.
  ///
  /// In en, this message translates to:
  /// **'Value (optional)'**
  String get admin_plans_valueOptional;

  /// No description provided for @admin_plans_addFeature.
  ///
  /// In en, this message translates to:
  /// **'Add Feature'**
  String get admin_plans_addFeature;

  /// No description provided for @admin_plans_hasPromotion.
  ///
  /// In en, this message translates to:
  /// **'Has Active Promotion'**
  String get admin_plans_hasPromotion;

  /// No description provided for @admin_plans_promoTitle.
  ///
  /// In en, this message translates to:
  /// **'Promotion Title *'**
  String get admin_plans_promoTitle;

  /// No description provided for @admin_plans_titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title required'**
  String get admin_plans_titleRequired;

  /// No description provided for @admin_plans_promoDescription.
  ///
  /// In en, this message translates to:
  /// **'Promotion Description'**
  String get admin_plans_promoDescription;

  /// No description provided for @admin_plans_optionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Optional details'**
  String get admin_plans_optionalDetails;

  /// No description provided for @admin_plans_promoTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Summer Special'**
  String get admin_plans_promoTitleHint;

  /// No description provided for @admin_plans_discountType.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get admin_plans_discountType;

  /// No description provided for @admin_plans_fixedAmount.
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount'**
  String get admin_plans_fixedAmount;

  /// No description provided for @admin_plans_percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage %'**
  String get admin_plans_percentage;

  /// No description provided for @admin_plans_discountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get admin_plans_discountPercent;

  /// No description provided for @admin_plans_discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get admin_plans_discountAmount;

  /// No description provided for @admin_plans_startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get admin_plans_startDate;

  /// No description provided for @admin_plans_noStartDate.
  ///
  /// In en, this message translates to:
  /// **'No start date'**
  String get admin_plans_noStartDate;

  /// No description provided for @admin_plans_endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get admin_plans_endDate;

  /// No description provided for @admin_plans_noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get admin_plans_noEndDate;

  /// No description provided for @admin_plans_noEndDateNote.
  ///
  /// In en, this message translates to:
  /// **'No end date = promotion stays active until manually deactivated'**
  String get admin_plans_noEndDateNote;

  /// No description provided for @admin_plans_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_plans_saveChanges;

  /// No description provided for @admin_plans_durOneTime.
  ///
  /// In en, this message translates to:
  /// **'One Time'**
  String get admin_plans_durOneTime;

  /// No description provided for @admin_plans_durCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get admin_plans_durCustom;

  /// No description provided for @admin_plans_nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Gold Monthly'**
  String get admin_plans_nameHint;

  /// No description provided for @admin_plans_customDurationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 45'**
  String get admin_plans_customDurationHint;

  /// No description provided for @admin_dashboard_viewReports.
  ///
  /// In en, this message translates to:
  /// **'View detailed reports'**
  String get admin_dashboard_viewReports;

  /// No description provided for @paymentSheetNoMethodsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available'**
  String get paymentSheetNoMethodsAvailable;

  /// No description provided for @paymentSheetPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentSheetPaymentFailed;

  /// No description provided for @paymentSheetCompleteInBrowserTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete payment in browser'**
  String get paymentSheetCompleteInBrowserTitle;

  /// No description provided for @paymentSheetCompleteInBrowserMessage.
  ///
  /// In en, this message translates to:
  /// **'The payment page opened in your browser. Complete the payment, then come back here and tap \"Done\".'**
  String get paymentSheetCompleteInBrowserMessage;

  /// No description provided for @paymentSheetDoneVerifyPayment.
  ///
  /// In en, this message translates to:
  /// **'Done — Verify Payment'**
  String get paymentSheetDoneVerifyPayment;

  /// No description provided for @paymentSheetReopenPaymentPage.
  ///
  /// In en, this message translates to:
  /// **'Reopen payment page'**
  String get paymentSheetReopenPaymentPage;

  /// No description provided for @paymentSheetOkButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get paymentSheetOkButton;

  /// No description provided for @paymentSheetPendingConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending payment confirmation'**
  String get paymentSheetPendingConfirmationTitle;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get bookingSuccessTitle;

  /// No description provided for @ptPackagePendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent to the administration. Sessions will be activated once payment is confirmed.'**
  String get ptPackagePendingMessage;

  /// No description provided for @sessionBookingPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent to the administration. Your booking will be confirmed once payment is confirmed.'**
  String get sessionBookingPendingMessage;

  /// No description provided for @sessionBookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking for this class has been confirmed.'**
  String get sessionBookingSuccessMessage;

  /// No description provided for @planSubscriptionSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribed Successfully'**
  String get planSubscriptionSuccessTitle;

  /// No description provided for @planSubscriptionPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent to the administration. Your subscription will be activated once payment is confirmed.'**
  String get planSubscriptionPendingMessage;

  /// No description provided for @planSubscriptionActivatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your subscription to \"{planName}\" has been activated.'**
  String planSubscriptionActivatedMessage(String planName);

  /// No description provided for @planLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planLabel;

  /// No description provided for @profileCompletionStepBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Branch'**
  String get profileCompletionStepBranchTitle;

  /// No description provided for @profileCompletionStepAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About You'**
  String get profileCompletionStepAboutTitle;

  /// No description provided for @profileCompletionStepBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Metrics'**
  String get profileCompletionStepBodyTitle;

  /// No description provided for @profileCompletionStepEmergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get profileCompletionStepEmergencyTitle;

  /// No description provided for @profileCompletionStepBranchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the branch you\'ll usually train at.'**
  String get profileCompletionStepBranchSubtitle;

  /// No description provided for @profileCompletionStepAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few details to personalise your plan.'**
  String get profileCompletionStepAboutSubtitle;

  /// No description provided for @profileCompletionStepBodySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — helps us tailor your experience.'**
  String get profileCompletionStepBodySubtitle;

  /// No description provided for @profileCompletionStepEmergencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — who should we contact if needed?'**
  String get profileCompletionStepEmergencySubtitle;

  /// No description provided for @profileCompletionGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileCompletionGenderMale;

  /// No description provided for @profileCompletionGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileCompletionGenderFemale;

  /// No description provided for @profileCompletionGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get profileCompletionGenderOther;

  /// No description provided for @profileCompletionGenderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get profileCompletionGenderPreferNotToSay;

  /// No description provided for @profileCompletionSelectBranchError.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred branch.'**
  String get profileCompletionSelectBranchError;

  /// No description provided for @profileCompletionSelectGenderDobError.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender and date of birth.'**
  String get profileCompletionSelectGenderDobError;

  /// No description provided for @profileCompletionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Please try again.'**
  String get profileCompletionSaveFailed;

  /// No description provided for @profileCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get profileCompletionTitle;

  /// No description provided for @profileCompletionPreferredBranch.
  ///
  /// In en, this message translates to:
  /// **'Preferred Branch *'**
  String get profileCompletionPreferredBranch;

  /// No description provided for @profileCompletionGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender *'**
  String get profileCompletionGenderLabel;

  /// No description provided for @profileCompletionDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth *'**
  String get profileCompletionDobLabel;

  /// No description provided for @profileCompletionSelectDob.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get profileCompletionSelectDob;

  /// No description provided for @profileCompletionHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get profileCompletionHeightLabel;

  /// No description provided for @profileCompletionWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get profileCompletionWeightLabel;

  /// No description provided for @profileCompletionHeightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 175'**
  String get profileCompletionHeightHint;

  /// No description provided for @profileCompletionWeightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 70'**
  String get profileCompletionWeightHint;

  /// No description provided for @profileCompletionEmergencyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get profileCompletionEmergencyNameLabel;

  /// No description provided for @profileCompletionEmergencyPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone'**
  String get profileCompletionEmergencyPhoneLabel;

  /// No description provided for @profileCompletionFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileCompletionFullNameHint;

  /// No description provided for @profileCompletionPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileCompletionPhoneNumberHint;

  /// No description provided for @profileCompletionSaveContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get profileCompletionSaveContinueButton;

  /// No description provided for @profileCompletionSelectBranchHint.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get profileCompletionSelectBranchHint;

  /// No description provided for @editProfileCodeResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code resent successfully'**
  String get editProfileCodeResentSuccess;

  /// No description provided for @ptVideoPipUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Picture-in-Picture is not available on this device.'**
  String get ptVideoPipUnavailable;

  /// No description provided for @sessionCardWithTrainer.
  ///
  /// In en, this message translates to:
  /// **'with {trainerName}'**
  String sessionCardWithTrainer(String trainerName);

  /// No description provided for @general_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get general_confirm;

  /// No description provided for @adminMemberPicker_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone…'**
  String get adminMemberPicker_searchHint;

  /// No description provided for @adminMemberPicker_couldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load members'**
  String get adminMemberPicker_couldNotLoad;

  /// No description provided for @adminMemberPicker_noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get adminMemberPicker_noMembersFound;

  /// No description provided for @adminMemberPicker_assignRoleFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to assign role. Please try again.'**
  String get adminMemberPicker_assignRoleFailed;

  /// No description provided for @admin_staff_assignReceptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Reception Role'**
  String get admin_staff_assignReceptionTitle;

  /// No description provided for @admin_staff_assignReceptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a member to assign the Reception role'**
  String get admin_staff_assignReceptionSubtitle;

  /// No description provided for @admin_staff_receptionDashboardNotice.
  ///
  /// In en, this message translates to:
  /// **'The member will see the Operations dashboard the next time they log in.'**
  String get admin_staff_receptionDashboardNotice;

  /// No description provided for @admin_staff_assignedReceptionSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} is now Reception Staff. They\'ll see the operations dashboard on next login.'**
  String admin_staff_assignedReceptionSuccess(String name);

  /// No description provided for @admin_staff_confirmAssignReception.
  ///
  /// In en, this message translates to:
  /// **'Assign Reception role to {name}?'**
  String admin_staff_confirmAssignReception(String name);

  /// No description provided for @admin_staff_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search staff by name'**
  String get admin_staff_searchHint;

  /// No description provided for @admin_staff_totalStaffLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Staff'**
  String get admin_staff_totalStaffLabel;

  /// No description provided for @admin_staff_activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_staff_activeLabel;

  /// No description provided for @admin_trainers_promoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Promote Member to Trainer'**
  String get admin_trainers_promoteTitle;

  /// No description provided for @admin_trainers_promoteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a member to assign the Trainer role'**
  String get admin_trainers_promoteSubtitle;

  /// No description provided for @admin_trainers_trainerDashboardNotice.
  ///
  /// In en, this message translates to:
  /// **'The member will see the Trainer dashboard the next time they log in.'**
  String get admin_trainers_trainerDashboardNotice;

  /// No description provided for @admin_trainers_confirmAssignTrainer.
  ///
  /// In en, this message translates to:
  /// **'Assign Trainer role to {name}?'**
  String admin_trainers_confirmAssignTrainer(String name);

  /// No description provided for @admin_trainers_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or specialty'**
  String get admin_trainers_searchHint;

  /// No description provided for @admin_trainers_allSpecialties.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get admin_trainers_allSpecialties;

  /// No description provided for @admin_trainers_blockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Block Trainer'**
  String get admin_trainers_blockConfirmTitle;

  /// No description provided for @admin_trainers_unblockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Unblock Trainer'**
  String get admin_trainers_unblockConfirmTitle;

  /// No description provided for @admin_trainers_blockConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Block {name}? They will not be able to log in.'**
  String admin_trainers_blockConfirmMessage(String name);

  /// No description provided for @admin_trainers_unblockConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Unblock {name}? They will be able to log in again.'**
  String admin_trainers_unblockConfirmMessage(String name);

  /// No description provided for @admin_trainers_blockAction.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get admin_trainers_blockAction;

  /// No description provided for @admin_trainers_unblockAction.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get admin_trainers_unblockAction;

  /// No description provided for @admin_trainers_scheduleAction.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get admin_trainers_scheduleAction;

  /// No description provided for @admin_trainers_editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_trainers_editAction;

  /// No description provided for @admin_trainers_blockedBadge.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get admin_trainers_blockedBadge;

  /// No description provided for @admin_trainers_activeBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_trainers_activeBadge;

  /// No description provided for @configureTrainer_title.
  ///
  /// In en, this message translates to:
  /// **'Set Up Trainer Profile'**
  String get configureTrainer_title;

  /// No description provided for @configureTrainer_selectBranchError.
  ///
  /// In en, this message translates to:
  /// **'Select at least one branch.'**
  String get configureTrainer_selectBranchError;

  /// No description provided for @configureTrainer_saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Please try again.'**
  String get configureTrainer_saveFailed;

  /// No description provided for @configureTrainer_setupSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} is fully set up as a trainer.'**
  String configureTrainer_setupSuccess(String name);

  /// No description provided for @configureTrainer_branchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Branches *'**
  String get configureTrainer_branchesLabel;

  /// No description provided for @configureTrainer_noBranchesFound.
  ///
  /// In en, this message translates to:
  /// **'No branches found.'**
  String get configureTrainer_noBranchesFound;

  /// No description provided for @configureTrainer_specialtiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialties'**
  String get configureTrainer_specialtiesLabel;

  /// No description provided for @configureTrainer_specialtyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Fat Loss, Strength…'**
  String get configureTrainer_specialtyHint;

  /// No description provided for @configureTrainer_yearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get configureTrainer_yearsLabel;

  /// No description provided for @configureTrainer_yearsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get configureTrainer_yearsHint;

  /// No description provided for @configureTrainer_notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio / Notes (optional)'**
  String get configureTrainer_notesLabel;

  /// No description provided for @configureTrainer_notesHint.
  ///
  /// In en, this message translates to:
  /// **'Brief bio or admin notes…'**
  String get configureTrainer_notesHint;

  /// No description provided for @configureTrainer_saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save & Finish'**
  String get configureTrainer_saveButton;

  /// No description provided for @admin_employees_defaultName.
  ///
  /// In en, this message translates to:
  /// **'this employee'**
  String get admin_employees_defaultName;

  /// No description provided for @admin_employees_paymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get admin_employees_paymentHistoryTitle;

  /// No description provided for @admin_employees_noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded yet'**
  String get admin_employees_noPaymentsYet;

  /// No description provided for @admin_employees_qrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the Gym Check-In QR'**
  String get admin_employees_qrScanTitle;

  /// No description provided for @admin_employees_qrScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR poster at the entrance to check in or out.'**
  String get admin_employees_qrScanSubtitle;

  /// No description provided for @admin_employees_payDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay {name}'**
  String admin_employees_payDialogTitle(String name);

  /// No description provided for @admin_employees_invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get admin_employees_invalidAmount;

  /// No description provided for @admin_employees_workedDaysThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{Worked {days} day this month} other{Worked {days} days this month}}'**
  String admin_employees_workedDaysThisMonth(int days);

  /// No description provided for @admin_employees_amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount *'**
  String get admin_employees_amountLabel;

  /// No description provided for @admin_employees_paymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get admin_employees_paymentDateLabel;

  /// No description provided for @admin_employees_noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get admin_employees_noteLabel;

  /// No description provided for @admin_employees_confirmPayButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pay'**
  String get admin_employees_confirmPayButton;

  /// No description provided for @admin_plans_membersLabel.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get admin_plans_membersLabel;

  /// No description provided for @admin_plans_activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_plans_activeLabel;

  /// No description provided for @admin_plans_totalPlansLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Plans'**
  String get admin_plans_totalPlansLabel;

  /// No description provided for @admin_plans_inactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_plans_inactiveLabel;

  /// No description provided for @admin_plans_featuredBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get admin_plans_featuredBadge;

  /// No description provided for @admin_plans_durationCellLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get admin_plans_durationCellLabel;

  /// No description provided for @admin_plans_visitLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Visit Limit'**
  String get admin_plans_visitLimitLabel;

  /// No description provided for @admin_plans_freezeDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Freeze Days'**
  String get admin_plans_freezeDaysLabel;

  /// No description provided for @admin_plans_maxFreezesLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Freezes'**
  String get admin_plans_maxFreezesLabel;

  /// No description provided for @admin_plans_entryHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Entry Hours'**
  String get admin_plans_entryHoursLabel;

  /// No description provided for @admin_plans_gracePeriodCellLabel.
  ///
  /// In en, this message translates to:
  /// **'Grace Period'**
  String get admin_plans_gracePeriodCellLabel;

  /// No description provided for @admin_plans_onLabel.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get admin_plans_onLabel;

  /// No description provided for @admin_plans_includedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Included Features'**
  String get admin_plans_includedFeatures;

  /// No description provided for @admin_plans_availableAt.
  ///
  /// In en, this message translates to:
  /// **'Available at:'**
  String get admin_plans_availableAt;

  /// No description provided for @admin_plans_editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_plans_editAction;

  /// No description provided for @admin_plans_deletingAction.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get admin_plans_deletingAction;

  /// No description provided for @admin_plans_cycleMonthly.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get admin_plans_cycleMonthly;

  /// No description provided for @admin_plans_cycleQuarterly.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get admin_plans_cycleQuarterly;

  /// No description provided for @admin_plans_cycleYearly.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get admin_plans_cycleYearly;

  /// No description provided for @admin_plans_cycleOneTime.
  ///
  /// In en, this message translates to:
  /// **'One time'**
  String get admin_plans_cycleOneTime;

  /// No description provided for @admin_plans_untilDate.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String admin_plans_untilDate(String date);

  /// No description provided for @admin_plans_openEnded.
  ///
  /// In en, this message translates to:
  /// **'Open-ended'**
  String get admin_plans_openEnded;

  /// No description provided for @trainer_cashBadge.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get trainer_cashBadge;

  /// No description provided for @trainer_navCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get trainer_navCheckIn;

  /// No description provided for @trainer_dayNumberFallback.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String trainer_dayNumberFallback(int day);

  /// No description provided for @trainer_packageSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String trainer_packageSessionsCount(int count);

  /// No description provided for @trainer_packageDaysPerWeekRange.
  ///
  /// In en, this message translates to:
  /// **'{min}-{max} days/week'**
  String trainer_packageDaysPerWeekRange(int min, int max);

  /// No description provided for @trainer_packageDaysValid.
  ///
  /// In en, this message translates to:
  /// **'Valid for {days} days'**
  String trainer_packageDaysValid(int days);

  /// No description provided for @trainer_packagePriceWasPrice.
  ///
  /// In en, this message translates to:
  /// **'\${salePrice} (was \${price})'**
  String trainer_packagePriceWasPrice(String salePrice, String price);

  /// No description provided for @admin_members_attendanceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get admin_members_attendanceHistoryTitle;

  /// No description provided for @admin_members_noAttendanceRecords.
  ///
  /// In en, this message translates to:
  /// **'No attendance records'**
  String get admin_members_noAttendanceRecords;

  /// No description provided for @admin_members_inGym.
  ///
  /// In en, this message translates to:
  /// **'In Gym'**
  String get admin_members_inGym;

  /// No description provided for @admin_members_checkedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked Out'**
  String get admin_members_checkedOut;

  /// No description provided for @admin_members_renewFeatureName.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get admin_members_renewFeatureName;

  /// No description provided for @admin_members_editFeatureName.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_members_editFeatureName;

  /// No description provided for @admin_members_whatsAppNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not installed'**
  String get admin_members_whatsAppNotInstalled;

  /// No description provided for @admin_members_featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} is coming soon'**
  String admin_members_featureComingSoon(String feature);

  /// No description provided for @admin_members_defaultMemberName.
  ///
  /// In en, this message translates to:
  /// **'this member'**
  String get admin_members_defaultMemberName;

  /// No description provided for @admin_members_couldNotOpenDialler.
  ///
  /// In en, this message translates to:
  /// **'Could not open dialler'**
  String get admin_members_couldNotOpenDialler;

  /// No description provided for @admin_members_couldNotOpenSms.
  ///
  /// In en, this message translates to:
  /// **'Could not open SMS'**
  String get admin_members_couldNotOpenSms;

  /// No description provided for @admin_expenses_autoRecorded.
  ///
  /// In en, this message translates to:
  /// **'Auto-recorded'**
  String get admin_expenses_autoRecorded;

  /// No description provided for @admin_expenses_pendingTrainerPayout.
  ///
  /// In en, this message translates to:
  /// **'Pending trainer payout'**
  String get admin_expenses_pendingTrainerPayout;

  /// No description provided for @admin_expenses_confirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming...'**
  String get admin_expenses_confirming;

  /// No description provided for @admin_expenses_confirmPaidToTrainer.
  ///
  /// In en, this message translates to:
  /// **'Confirm Paid to Trainer'**
  String get admin_expenses_confirmPaidToTrainer;

  /// No description provided for @admin_expenses_commissionForTrainer.
  ///
  /// In en, this message translates to:
  /// **'Commission for {name}'**
  String admin_expenses_commissionForTrainer(String name);

  /// No description provided for @admin_expenses_commissionAllTrainers.
  ///
  /// In en, this message translates to:
  /// **'Commission — All Trainers'**
  String get admin_expenses_commissionAllTrainers;

  /// No description provided for @admin_expenses_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get admin_expenses_total;

  /// No description provided for @admin_expenses_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get admin_expenses_paid;

  /// No description provided for @admin_expenses_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get admin_expenses_remaining;

  /// No description provided for @admin_expenses_allTrainers.
  ///
  /// In en, this message translates to:
  /// **'All Trainers'**
  String get admin_expenses_allTrainers;

  /// No description provided for @admin_expenses_thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get admin_expenses_thisMonth;

  /// No description provided for @admin_expenses_allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get admin_expenses_allTime;

  /// No description provided for @admin_expenses_entriesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Entries This Month'**
  String get admin_expenses_entriesThisMonth;

  /// No description provided for @admin_expenses_enterTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Please enter a transaction type'**
  String get admin_expenses_enterTransactionType;

  /// No description provided for @admin_expenses_selectTrainerError.
  ///
  /// In en, this message translates to:
  /// **'Please select a trainer'**
  String get admin_expenses_selectTrainerError;

  /// No description provided for @admin_expenses_transactionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get admin_expenses_transactionTypeLabel;

  /// No description provided for @admin_expenses_customCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Equipment Repair'**
  String get admin_expenses_customCategoryHint;

  /// No description provided for @admin_expenses_selectTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Select transaction type'**
  String get admin_expenses_selectTransactionType;

  /// No description provided for @admin_expenses_addNewTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Add new transaction type'**
  String get admin_expenses_addNewTransactionType;

  /// No description provided for @admin_expenses_payTo.
  ///
  /// In en, this message translates to:
  /// **'Pay To'**
  String get admin_expenses_payTo;

  /// No description provided for @admin_expenses_payToTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get admin_expenses_payToTrainer;

  /// No description provided for @admin_expenses_payToOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get admin_expenses_payToOther;

  /// No description provided for @admin_expenses_trainerLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get admin_expenses_trainerLabel;

  /// No description provided for @admin_expenses_selectTrainer.
  ///
  /// In en, this message translates to:
  /// **'Select a trainer'**
  String get admin_expenses_selectTrainer;

  /// No description provided for @admin_employees_thisEmployee.
  ///
  /// In en, this message translates to:
  /// **'this employee'**
  String get admin_employees_thisEmployee;

  /// No description provided for @admin_employees_removeEmployeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Employee'**
  String get admin_employees_removeEmployeeTitle;

  /// No description provided for @admin_employees_removeEmployeeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}? This cannot be undone.'**
  String admin_employees_removeEmployeeConfirm(String name);

  /// No description provided for @admin_employees_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get admin_employees_remove;

  /// No description provided for @admin_employees_allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get admin_employees_allTypes;

  /// No description provided for @admin_employees_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search employees...'**
  String get admin_employees_searchHint;

  /// No description provided for @admin_employees_filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get admin_employees_filterAll;

  /// No description provided for @admin_employees_filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_employees_filterActive;

  /// No description provided for @admin_employees_filterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_employees_filterInactive;

  /// No description provided for @admin_employees_noEmployeesYet.
  ///
  /// In en, this message translates to:
  /// **'No employees yet'**
  String get admin_employees_noEmployeesYet;

  /// No description provided for @admin_employees_checkinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Check-ins'**
  String get admin_employees_checkinsTitle;

  /// No description provided for @admin_employees_showGymQr.
  ///
  /// In en, this message translates to:
  /// **'Show gym check-in QR'**
  String get admin_employees_showGymQr;

  /// No description provided for @admin_employees_scanToCheckInOut.
  ///
  /// In en, this message translates to:
  /// **'Scan to check in/out'**
  String get admin_employees_scanToCheckInOut;

  /// No description provided for @admin_employees_noActiveEmployeesYet.
  ///
  /// In en, this message translates to:
  /// **'No active employees yet'**
  String get admin_employees_noActiveEmployeesYet;

  /// No description provided for @admin_employees_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get admin_employees_unknown;

  /// No description provided for @admin_employees_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_employees_inactive;

  /// No description provided for @admin_employees_appAccount.
  ///
  /// In en, this message translates to:
  /// **'App Account'**
  String get admin_employees_appAccount;

  /// No description provided for @admin_employees_daysThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{days} days this month'**
  String admin_employees_daysThisMonth(int days);

  /// No description provided for @admin_employees_lastPaid.
  ///
  /// In en, this message translates to:
  /// **'Last paid {date}'**
  String admin_employees_lastPaid(String date);

  /// No description provided for @admin_employees_neverPaid.
  ///
  /// In en, this message translates to:
  /// **'Never paid'**
  String get admin_employees_neverPaid;

  /// No description provided for @admin_employees_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_employees_edit;

  /// No description provided for @admin_employees_removing.
  ///
  /// In en, this message translates to:
  /// **'Removing...'**
  String get admin_employees_removing;

  /// No description provided for @admin_employees_paying.
  ///
  /// In en, this message translates to:
  /// **'Paying...'**
  String get admin_employees_paying;

  /// No description provided for @admin_employees_pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get admin_employees_pay;

  /// No description provided for @admin_employees_overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get admin_employees_overdue;

  /// No description provided for @admin_employees_dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get admin_employees_dueSoon;

  /// No description provided for @admin_employees_upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get admin_employees_upToDate;

  /// No description provided for @admin_employees_freqWeek.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get admin_employees_freqWeek;

  /// No description provided for @admin_employees_freqDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get admin_employees_freqDay;

  /// No description provided for @admin_employees_freqMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get admin_employees_freqMonth;

  /// No description provided for @admin_employees_gymCheckinQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Gym Check-In QR'**
  String get admin_employees_gymCheckinQrTitle;

  /// No description provided for @admin_employees_couldNotLoadQr.
  ///
  /// In en, this message translates to:
  /// **'Could not load QR: {error}'**
  String admin_employees_couldNotLoadQr(String error);

  /// No description provided for @admin_employees_qrPosterInstructions.
  ///
  /// In en, this message translates to:
  /// **'Print and display this QR code at the entrance for employees to scan when checking in or out.'**
  String get admin_employees_qrPosterInstructions;

  /// No description provided for @admin_employees_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get admin_employees_close;

  /// No description provided for @admin_employees_checkedInAt.
  ///
  /// In en, this message translates to:
  /// **'Checked in at {time}'**
  String admin_employees_checkedInAt(String time);

  /// No description provided for @admin_employees_checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get admin_employees_checkedIn;

  /// No description provided for @admin_employees_checkedOutAt.
  ///
  /// In en, this message translates to:
  /// **'Checked out at {time}'**
  String admin_employees_checkedOutAt(String time);

  /// No description provided for @admin_employees_checkedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked out'**
  String get admin_employees_checkedOut;

  /// No description provided for @admin_employees_notCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in'**
  String get admin_employees_notCheckedIn;

  /// No description provided for @admin_employees_selfCheckin.
  ///
  /// In en, this message translates to:
  /// **'Self check-in'**
  String get admin_employees_selfCheckin;

  /// No description provided for @admin_employees_checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get admin_employees_checkOut;

  /// No description provided for @admin_employees_checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get admin_employees_checkIn;

  /// No description provided for @admin_employees_checkedInNow.
  ///
  /// In en, this message translates to:
  /// **'Checked In Now'**
  String get admin_employees_checkedInNow;

  /// No description provided for @admin_employees_totalStaff.
  ///
  /// In en, this message translates to:
  /// **'Total Staff'**
  String get admin_employees_totalStaff;

  /// No description provided for @admin_employees_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get admin_employees_manual;

  /// No description provided for @admin_employees_pleaseSelectBranch.
  ///
  /// In en, this message translates to:
  /// **'Please select a branch'**
  String get admin_employees_pleaseSelectBranch;

  /// No description provided for @admin_employees_pleaseSelectStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Please select a staff member'**
  String get admin_employees_pleaseSelectStaffMember;

  /// No description provided for @admin_employees_pleaseEnterEmployeeType.
  ///
  /// In en, this message translates to:
  /// **'Please enter an employee type'**
  String get admin_employees_pleaseEnterEmployeeType;

  /// No description provided for @admin_employees_updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Employee updated successfully'**
  String get admin_employees_updatedSuccessfully;

  /// No description provided for @admin_employees_addedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Employee added successfully'**
  String get admin_employees_addedSuccessfully;

  /// No description provided for @admin_employees_editEmployee.
  ///
  /// In en, this message translates to:
  /// **'Edit Employee'**
  String get admin_employees_editEmployee;

  /// No description provided for @admin_employees_addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get admin_employees_addEmployee;

  /// No description provided for @admin_employees_whoIsThis.
  ///
  /// In en, this message translates to:
  /// **'Who is this?'**
  String get admin_employees_whoIsThis;

  /// No description provided for @admin_employees_newEmployee.
  ///
  /// In en, this message translates to:
  /// **'New Employee'**
  String get admin_employees_newEmployee;

  /// No description provided for @admin_employees_existingStaff.
  ///
  /// In en, this message translates to:
  /// **'Existing Staff'**
  String get admin_employees_existingStaff;

  /// No description provided for @admin_employees_trainerReceptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainer / Reception Staff'**
  String get admin_employees_trainerReceptionLabel;

  /// No description provided for @admin_employees_allStaffHavePayroll.
  ///
  /// In en, this message translates to:
  /// **'All staff already have payroll records'**
  String get admin_employees_allStaffHavePayroll;

  /// No description provided for @admin_employees_selectStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Select a staff member'**
  String get admin_employees_selectStaffMember;

  /// No description provided for @admin_employees_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_employees_required;

  /// No description provided for @admin_employees_thisPerson.
  ///
  /// In en, this message translates to:
  /// **'This person'**
  String get admin_employees_thisPerson;

  /// No description provided for @admin_employees_identityManagedNote.
  ///
  /// In en, this message translates to:
  /// **'{name} ({type}) — identity is managed via the app account.'**
  String admin_employees_identityManagedNote(String name, String type);

  /// No description provided for @admin_employees_sectionEmployeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Employee Details'**
  String get admin_employees_sectionEmployeeDetails;

  /// No description provided for @admin_employees_sectionPay.
  ///
  /// In en, this message translates to:
  /// **'Salary & Pay'**
  String get admin_employees_sectionPay;

  /// No description provided for @admin_employees_fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get admin_employees_fullNameLabel;

  /// No description provided for @admin_employees_fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get admin_employees_fullNameHint;

  /// No description provided for @admin_employees_phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get admin_employees_phoneLabel;

  /// No description provided for @admin_employees_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get admin_employees_emailLabel;

  /// No description provided for @admin_employees_optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get admin_employees_optional;

  /// No description provided for @admin_employees_employeeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee Type'**
  String get admin_employees_employeeTypeLabel;

  /// No description provided for @admin_employees_employeeTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Trainer, Receptionist…'**
  String get admin_employees_employeeTypeHint;

  /// No description provided for @admin_employees_selectEmployeeType.
  ///
  /// In en, this message translates to:
  /// **'Select type…'**
  String get admin_employees_selectEmployeeType;

  /// No description provided for @admin_employees_salaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get admin_employees_salaryLabel;

  /// No description provided for @admin_employees_payFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Pay Frequency'**
  String get admin_employees_payFrequencyLabel;

  /// No description provided for @admin_employees_branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get admin_employees_branchLabel;

  /// No description provided for @admin_employees_selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get admin_employees_selectBranch;

  /// No description provided for @admin_employees_hireDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Hire Date'**
  String get admin_employees_hireDateLabel;

  /// No description provided for @admin_employees_statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get admin_employees_statusLabel;

  /// No description provided for @admin_employees_statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_employees_statusActive;

  /// No description provided for @admin_employees_notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get admin_employees_notesLabel;

  /// No description provided for @admin_employees_optionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Optional notes…'**
  String get admin_employees_optionalNotes;

  /// No description provided for @admin_employees_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_employees_saveChanges;

  /// No description provided for @admin_dashboard_growthPercent.
  ///
  /// In en, this message translates to:
  /// **'{value} vs last month'**
  String admin_dashboard_growthPercent(String value);

  /// No description provided for @admin_dashboard_vsLastMonthPercent.
  ///
  /// In en, this message translates to:
  /// **'{value} vs last month'**
  String admin_dashboard_vsLastMonthPercent(String value);

  /// No description provided for @admin_dashboard_notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get admin_dashboard_notAvailable;

  /// No description provided for @admin_settings_deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String admin_settings_deleteAccountFailed(String error);

  /// No description provided for @admin_payments_sectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get admin_payments_sectionTitle;

  /// No description provided for @admin_payments_sectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable payment options visible to your members.'**
  String get admin_payments_sectionSubtitle;

  /// No description provided for @admin_payments_noMethodsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available on this platform.'**
  String get admin_payments_noMethodsAvailable;

  /// No description provided for @admin_payments_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_payments_active;

  /// No description provided for @admin_payments_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get admin_payments_disabled;

  /// No description provided for @admin_payments_configured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get admin_payments_configured;

  /// No description provided for @admin_payments_notConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get admin_payments_notConfigured;

  /// No description provided for @admin_payments_configure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get admin_payments_configure;

  /// No description provided for @admin_payments_testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get admin_payments_testConnection;

  /// No description provided for @admin_payments_couldNotUpdate.
  ///
  /// In en, this message translates to:
  /// **'Could not update {name}: {error}'**
  String admin_payments_couldNotUpdate(String name, String error);

  /// No description provided for @admin_payments_testingConnection.
  ///
  /// In en, this message translates to:
  /// **'Testing connection…'**
  String get admin_payments_testingConnection;

  /// No description provided for @admin_payments_connectionOk.
  ///
  /// In en, this message translates to:
  /// **'Connection OK'**
  String get admin_payments_connectionOk;

  /// No description provided for @admin_payments_connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get admin_payments_connectionFailed;

  /// No description provided for @admin_payments_credentialsVerified.
  ///
  /// In en, this message translates to:
  /// **'Credentials verified successfully with {name}.'**
  String admin_payments_credentialsVerified(String name);

  /// No description provided for @admin_payments_unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get admin_payments_unknownError;

  /// No description provided for @admin_payments_okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get admin_payments_okButton;

  /// No description provided for @admin_payments_testFailed.
  ///
  /// In en, this message translates to:
  /// **'Test failed: {error}'**
  String admin_payments_testFailed(String error);

  /// No description provided for @admin_payments_credentialsSaved.
  ///
  /// In en, this message translates to:
  /// **'Credentials saved successfully'**
  String get admin_payments_credentialsSaved;

  /// No description provided for @admin_payments_credentialsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save credentials'**
  String get admin_payments_credentialsSaveFailed;

  /// No description provided for @admin_payments_credentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Credentials'**
  String admin_payments_credentialsTitle(String name);

  /// No description provided for @admin_payments_credentialsSecureNotice.
  ///
  /// In en, this message translates to:
  /// **'These credentials are stored securely and used by the payment gateway.'**
  String get admin_payments_credentialsSecureNotice;

  /// No description provided for @admin_payments_connectionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection successful — credentials are valid.'**
  String get admin_payments_connectionSuccessful;

  /// No description provided for @admin_payments_connectionFailedShort.
  ///
  /// In en, this message translates to:
  /// **'Connection failed.'**
  String get admin_payments_connectionFailedShort;

  /// No description provided for @admin_payments_saveCredentials.
  ///
  /// In en, this message translates to:
  /// **'Save Credentials'**
  String get admin_payments_saveCredentials;

  /// No description provided for @admin_payments_testingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get admin_payments_testingEllipsis;

  /// No description provided for @admin_payments_configureFirst.
  ///
  /// In en, this message translates to:
  /// **'Configure {name} before enabling it.'**
  String admin_payments_configureFirst(String name);

  /// No description provided for @admin_invoice_title.
  ///
  /// In en, this message translates to:
  /// **'INVOICE'**
  String get admin_invoice_title;

  /// No description provided for @admin_invoice_invoiceNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice No.'**
  String get admin_invoice_invoiceNoLabel;

  /// No description provided for @admin_invoice_dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get admin_invoice_dateLabel;

  /// No description provided for @admin_invoice_billTo.
  ///
  /// In en, this message translates to:
  /// **'BILL TO'**
  String get admin_invoice_billTo;

  /// No description provided for @admin_invoice_items.
  ///
  /// In en, this message translates to:
  /// **'ITEMS'**
  String get admin_invoice_items;

  /// No description provided for @admin_invoice_subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get admin_invoice_subtotal;

  /// No description provided for @admin_invoice_discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get admin_invoice_discount;

  /// No description provided for @admin_invoice_tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get admin_invoice_tax;

  /// No description provided for @admin_invoice_total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get admin_invoice_total;

  /// No description provided for @admin_invoice_balanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get admin_invoice_balanceDue;

  /// No description provided for @admin_invoice_paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT DETAILS'**
  String get admin_invoice_paymentDetails;

  /// No description provided for @admin_invoice_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admin_invoice_description;

  /// No description provided for @admin_invoice_qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get admin_invoice_qty;

  /// No description provided for @admin_invoice_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get admin_invoice_price;

  /// No description provided for @admin_invoice_itemTotalColumn.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get admin_invoice_itemTotalColumn;

  /// No description provided for @admin_invoice_receivedBy.
  ///
  /// In en, this message translates to:
  /// **'Received by: {name}'**
  String admin_invoice_receivedBy(String name);

  /// No description provided for @admin_invoice_dueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due: {amount}'**
  String admin_invoice_dueAmount(String amount);

  /// No description provided for @admin_classes_capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get admin_classes_capacity;

  /// No description provided for @admin_classes_statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get admin_classes_statusCancelled;

  /// No description provided for @admin_classes_statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get admin_classes_statusCompleted;

  /// No description provided for @admin_classes_nearlyFull.
  ///
  /// In en, this message translates to:
  /// **'Nearly Full'**
  String get admin_classes_nearlyFull;

  /// No description provided for @adminAppBar_allBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get adminAppBar_allBranches;

  /// No description provided for @admin_branches_editBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get admin_branches_editBranchTitle;

  /// No description provided for @admin_branches_addBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get admin_branches_addBranchTitle;

  /// No description provided for @admin_branches_updatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Branch updated successfully'**
  String get admin_branches_updatedSuccess;

  /// No description provided for @admin_branches_createdSuccess.
  ///
  /// In en, this message translates to:
  /// **'Branch created successfully'**
  String get admin_branches_createdSuccess;

  /// No description provided for @admin_branches_sectionBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get admin_branches_sectionBasicInfo;

  /// No description provided for @admin_branches_nameHintAlt.
  ///
  /// In en, this message translates to:
  /// **'e.g. Downtown Branch'**
  String get admin_branches_nameHintAlt;

  /// No description provided for @admin_branches_cityLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'City / Location'**
  String get admin_branches_cityLocationLabel;

  /// No description provided for @admin_branches_cityHintAlt.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mumbai'**
  String get admin_branches_cityHintAlt;

  /// No description provided for @admin_branches_enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get admin_branches_enterValidEmail;

  /// No description provided for @admin_branches_openingTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Opening Time'**
  String get admin_branches_openingTimeLabel;

  /// No description provided for @admin_branches_closingTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Closing Time'**
  String get admin_branches_closingTimeLabel;

  /// No description provided for @admin_branches_statusSection.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get admin_branches_statusSection;

  /// No description provided for @admin_branches_open24Hours.
  ///
  /// In en, this message translates to:
  /// **'Open 24 Hours'**
  String get admin_branches_open24Hours;

  /// No description provided for @admin_branches_createBranchButton.
  ///
  /// In en, this message translates to:
  /// **'Create Branch'**
  String get admin_branches_createBranchButton;

  /// No description provided for @admin_branches_selectOpeningTime.
  ///
  /// In en, this message translates to:
  /// **'Please select an opening time'**
  String get admin_branches_selectOpeningTime;

  /// No description provided for @admin_branches_selectClosingTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a closing time'**
  String get admin_branches_selectClosingTime;

  /// No description provided for @admin_branches_detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Branch Details'**
  String get admin_branches_detailTitle;

  /// No description provided for @admin_branches_deletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Branch deleted successfully'**
  String get admin_branches_deletedSuccess;

  /// No description provided for @admin_branches_phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get admin_branches_phoneLabel;

  /// No description provided for @admin_branches_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get admin_branches_emailLabel;

  /// No description provided for @admin_branches_addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get admin_branches_addressLabel;

  /// No description provided for @admin_branches_trainers.
  ///
  /// In en, this message translates to:
  /// **'Trainers'**
  String get admin_branches_trainers;

  /// No description provided for @admin_branches_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Branch'**
  String get admin_branches_deleteTitle;

  /// No description provided for @admin_branches_deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}? This cannot be undone.'**
  String admin_branches_deleteConfirmMessage(String name);

  /// No description provided for @admin_branches_deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_branches_deleteAction;

  /// No description provided for @admin_reception_removeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Staff'**
  String get admin_reception_removeTitle;

  /// No description provided for @admin_reception_removeMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from reception staff?'**
  String admin_reception_removeMessage(String name);

  /// No description provided for @admin_reception_addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get admin_reception_addStaff;

  /// No description provided for @admin_reception_removeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove staff. Please try again.'**
  String get admin_reception_removeError;

  /// No description provided for @admin_reception_loadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load reception staff'**
  String get admin_reception_loadError;

  /// No description provided for @admin_reception_noStaffYet.
  ///
  /// In en, this message translates to:
  /// **'No Reception Staff Yet'**
  String get admin_reception_noStaffYet;

  /// No description provided for @admin_reception_noStaffHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to assign a member to the reception role.'**
  String get admin_reception_noStaffHint;

  /// No description provided for @admin_reception_staffSince.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String admin_reception_staffSince(String date);

  /// No description provided for @admin_reception_badge.
  ///
  /// In en, this message translates to:
  /// **'RECEPTION'**
  String get admin_reception_badge;

  /// No description provided for @admin_plans_percentOffLabel.
  ///
  /// In en, this message translates to:
  /// **'{value}% off'**
  String admin_plans_percentOffLabel(String value);

  /// No description provided for @admin_plans_amountOffLabel.
  ///
  /// In en, this message translates to:
  /// **'₹{value} off'**
  String admin_plans_amountOffLabel(String value);

  /// No description provided for @trainingVideos_newCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get trainingVideos_newCategoryTitle;

  /// No description provided for @trainingVideos_categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cardio, Strength, Yoga...'**
  String get trainingVideos_categoryNameHint;

  /// No description provided for @trainingVideos_categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get trainingVideos_categoryNameLabel;

  /// No description provided for @trainingVideos_addCategoryAction.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get trainingVideos_addCategoryAction;

  /// No description provided for @trainingVideos_selectOrCreateCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select or create a category'**
  String get trainingVideos_selectOrCreateCategoryError;

  /// No description provided for @trainingVideos_selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get trainingVideos_selectCategoryError;

  /// No description provided for @trainingVideos_durationMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Duration must be greater than 0'**
  String get trainingVideos_durationMustBePositive;

  /// No description provided for @trainingVideos_addedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Video added successfully'**
  String get trainingVideos_addedSuccess;

  /// No description provided for @trainingVideos_updatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Video updated successfully'**
  String get trainingVideos_updatedSuccess;

  /// No description provided for @trainingVideos_categoryCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" created and selected'**
  String trainingVideos_categoryCreatedSuccess(String name);

  /// No description provided for @trainingVideos_categoryCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {message}'**
  String trainingVideos_categoryCreateFailed(String message);

  /// No description provided for @trainingVideos_basicInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get trainingVideos_basicInfoSection;

  /// No description provided for @trainingVideos_titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get trainingVideos_titleLabel;

  /// No description provided for @trainingVideos_titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get trainingVideos_titleRequired;

  /// No description provided for @trainingVideos_descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get trainingVideos_descriptionLabel;

  /// No description provided for @trainingVideos_categorySection.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get trainingVideos_categorySection;

  /// No description provided for @trainingVideos_categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get trainingVideos_categoryLabel;

  /// No description provided for @trainingVideos_selectCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get trainingVideos_selectCategoryHint;

  /// No description provided for @trainingVideos_addNewCategoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add new category'**
  String get trainingVideos_addNewCategoryTooltip;

  /// No description provided for @trainingVideos_trainerSection.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get trainingVideos_trainerSection;

  /// No description provided for @trainingVideos_assignTrainerLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign to Trainer *'**
  String get trainingVideos_assignTrainerLabel;

  /// No description provided for @trainingVideos_selectTrainerHint.
  ///
  /// In en, this message translates to:
  /// **'Select a trainer'**
  String get trainingVideos_selectTrainerHint;

  /// No description provided for @trainingVideos_assignTrainerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please assign a trainer'**
  String get trainingVideos_assignTrainerRequired;

  /// No description provided for @trainingVideos_postedByYou.
  ///
  /// In en, this message translates to:
  /// **'Posted by you (Trainer ID: {id})'**
  String trainingVideos_postedByYou(String id);

  /// No description provided for @trainingVideos_videoSection.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get trainingVideos_videoSection;

  /// No description provided for @trainingVideos_pickVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Pick Video From Phone'**
  String get trainingVideos_pickVideoButton;

  /// No description provided for @trainingVideos_videoUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Video URL (YouTube / Vimeo)'**
  String get trainingVideos_videoUrlLabel;

  /// No description provided for @trainingVideos_durationSection.
  ///
  /// In en, this message translates to:
  /// **'Duration *'**
  String get trainingVideos_durationSection;

  /// No description provided for @trainingVideos_readingDuration.
  ///
  /// In en, this message translates to:
  /// **'Reading duration from video…'**
  String get trainingVideos_readingDuration;

  /// No description provided for @trainingVideos_autoFilledNotice.
  ///
  /// In en, this message translates to:
  /// **'Auto-filled from video — you can edit below'**
  String get trainingVideos_autoFilledNotice;

  /// No description provided for @trainingVideos_minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get trainingVideos_minutesLabel;

  /// No description provided for @trainingVideos_secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get trainingVideos_secondsLabel;

  /// No description provided for @trainingVideos_requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get trainingVideos_requiredField;

  /// No description provided for @trainingVideos_invalidField.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get trainingVideos_invalidField;

  /// No description provided for @trainingVideos_secondsRangeError.
  ///
  /// In en, this message translates to:
  /// **'0–59'**
  String get trainingVideos_secondsRangeError;

  /// No description provided for @trainingVideos_thumbnailSection.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail (optional)'**
  String get trainingVideos_thumbnailSection;

  /// No description provided for @trainingVideos_fromVideoOption.
  ///
  /// In en, this message translates to:
  /// **'From Video'**
  String get trainingVideos_fromVideoOption;

  /// No description provided for @trainingVideos_customOption.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get trainingVideos_customOption;

  /// No description provided for @trainingVideos_pickVideoFirstNotice.
  ///
  /// In en, this message translates to:
  /// **'Pick a video above to auto-extract a thumbnail'**
  String get trainingVideos_pickVideoFirstNotice;

  /// No description provided for @trainingVideos_extractingThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Extracting thumbnail…'**
  String get trainingVideos_extractingThumbnail;

  /// No description provided for @trainingVideos_reextractButton.
  ///
  /// In en, this message translates to:
  /// **'Re-extract'**
  String get trainingVideos_reextractButton;

  /// No description provided for @trainingVideos_extractFailedNotice.
  ///
  /// In en, this message translates to:
  /// **'Could not extract thumbnail'**
  String get trainingVideos_extractFailedNotice;

  /// No description provided for @trainingVideos_pickFromGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get trainingVideos_pickFromGalleryButton;

  /// No description provided for @trainingVideos_orEnterUrl.
  ///
  /// In en, this message translates to:
  /// **'or enter URL'**
  String get trainingVideos_orEnterUrl;

  /// No description provided for @trainingVideos_thumbnailUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail URL'**
  String get trainingVideos_thumbnailUrlLabel;

  /// No description provided for @trainingVideos_publishedLabel.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get trainingVideos_publishedLabel;

  /// No description provided for @trainingVideos_publishedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible to members immediately'**
  String get trainingVideos_publishedSubtitle;

  /// No description provided for @trainingVideos_addVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get trainingVideos_addVideoButton;

  /// No description provided for @trainingVideos_saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get trainingVideos_saveChangesButton;

  /// No description provided for @trainingVideos_editPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Video'**
  String get trainingVideos_editPageTitle;

  /// No description provided for @trainingVideos_addPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Training Video'**
  String get trainingVideos_addPageTitle;

  /// No description provided for @trainingVideos_reassignTrainerLabel.
  ///
  /// In en, this message translates to:
  /// **'Reassign Trainer (optional)'**
  String get trainingVideos_reassignTrainerLabel;

  /// No description provided for @trainingVideos_keepCurrentTrainerHint.
  ///
  /// In en, this message translates to:
  /// **'Keep current trainer'**
  String get trainingVideos_keepCurrentTrainerHint;

  /// No description provided for @trainingVideos_replaceVideoButton.
  ///
  /// In en, this message translates to:
  /// **'Replace Video File (optional)'**
  String get trainingVideos_replaceVideoButton;

  /// No description provided for @trainingVideos_noAuthToken.
  ///
  /// In en, this message translates to:
  /// **'No auth token found. Please log in again.'**
  String get trainingVideos_noAuthToken;

  /// No description provided for @trainingVideos_deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Video'**
  String get trainingVideos_deleteTitle;

  /// No description provided for @trainingVideos_deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? This cannot be undone.'**
  String trainingVideos_deleteConfirm(String title);

  /// No description provided for @trainingVideos_categoryFallback.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get trainingVideos_categoryFallback;

  /// No description provided for @trainingVideos_playAction.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get trainingVideos_playAction;

  /// No description provided for @trainingVideos_editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get trainingVideos_editAction;

  /// No description provided for @trainingVideos_draftBadge.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get trainingVideos_draftBadge;

  /// No description provided for @trainingVideos_noVideoUrl.
  ///
  /// In en, this message translates to:
  /// **'No video URL available'**
  String get trainingVideos_noVideoUrl;

  /// No description provided for @memberMembershipEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No memberships found'**
  String get memberMembershipEmptyTitle;

  /// No description provided for @memberMembershipEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your memberships will appear here after you subscribe to a plan.'**
  String get memberMembershipEmptySubtitle;

  /// No description provided for @memberMembershipLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load memberships'**
  String get memberMembershipLoadFailed;

  /// No description provided for @memberMembershipLoadFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get memberMembershipLoadFailedSubtitle;

  /// No description provided for @memberMembershipPlanType.
  ///
  /// In en, this message translates to:
  /// **'Plan Type'**
  String get memberMembershipPlanType;

  /// No description provided for @memberMembershipPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get memberMembershipPaymentStatus;

  /// No description provided for @memberMembershipStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get memberMembershipStartDate;

  /// No description provided for @memberMembershipEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get memberMembershipEndDate;

  /// No description provided for @memberMembershipRemainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get memberMembershipRemainingDays;

  /// No description provided for @memberMembershipRemainingVisits.
  ///
  /// In en, this message translates to:
  /// **'Remaining Visits'**
  String get memberMembershipRemainingVisits;

  /// No description provided for @memberMembershipDuration.
  ///
  /// In en, this message translates to:
  /// **'Plan Duration'**
  String get memberMembershipDuration;

  /// No description provided for @memberMembershipBillingCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing Cycle'**
  String get memberMembershipBillingCycle;

  /// No description provided for @memberMembershipPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get memberMembershipPrice;

  /// No description provided for @memberMembershipBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get memberMembershipBranch;

  /// No description provided for @memberMembershipAutoRenew.
  ///
  /// In en, this message translates to:
  /// **'Auto Renew'**
  String get memberMembershipAutoRenew;

  /// No description provided for @memberMembershipNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get memberMembershipNotAvailable;

  /// No description provided for @memberMembershipEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get memberMembershipEnabled;

  /// No description provided for @memberMembershipDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get memberMembershipDisabled;

  /// Displays the membership plan duration in days
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String memberMembershipDurationDays(int days);

  /// No description provided for @memberMembershipStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get memberMembershipStatusActive;

  /// No description provided for @memberMembershipStatusFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get memberMembershipStatusFrozen;

  /// No description provided for @memberMembershipStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get memberMembershipStatusExpired;

  /// No description provided for @memberMembershipStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get memberMembershipStatusCancelled;

  /// No description provided for @memberMembershipStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get memberMembershipStatusPending;

  /// No description provided for @memberMembershipPaymentPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get memberMembershipPaymentPaid;

  /// No description provided for @memberMembershipPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get memberMembershipPaymentPending;

  /// No description provided for @memberMembershipPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get memberMembershipPaymentFailed;

  /// No description provided for @memberMembershipPaymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get memberMembershipPaymentRefunded;

  /// No description provided for @memberMembershipPaymentUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get memberMembershipPaymentUnpaid;

  /// No description provided for @memberMembershipPlanTypeGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get memberMembershipPlanTypeGym;

  /// No description provided for @memberMembershipPlanTypeClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get memberMembershipPlanTypeClasses;

  /// No description provided for @memberMembershipPlanTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get memberMembershipPlanTypeMixed;

  /// No description provided for @memberMembershipPlanTypeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get memberMembershipPlanTypeMonthly;

  /// No description provided for @memberMembershipPlanTypeYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get memberMembershipPlanTypeYearly;

  /// No description provided for @memberMembershipBillingDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get memberMembershipBillingDaily;

  /// No description provided for @memberMembershipBillingWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get memberMembershipBillingWeekly;

  /// No description provided for @memberMembershipBillingMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get memberMembershipBillingMonthly;

  /// No description provided for @memberMembershipBillingYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get memberMembershipBillingYearly;

  /// No description provided for @memberMembershipBillingOneTime.
  ///
  /// In en, this message translates to:
  /// **'One Time'**
  String get memberMembershipBillingOneTime;

  /// No description provided for @planPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get planPendingApproval;

  /// No description provided for @sessionDetailPending.
  ///
  /// In en, this message translates to:
  /// **'Pending confirmation'**
  String get sessionDetailPending;

  /// No description provided for @sessionDetailCancelRequested.
  ///
  /// In en, this message translates to:
  /// **'Cancellation requested'**
  String get sessionDetailCancelRequested;
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
