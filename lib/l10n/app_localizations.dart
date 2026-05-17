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

  /// No description provided for @general_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get general_retry;

  /// No description provided for @general_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get general_save;

  /// No description provided for @general_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get general_edit;

  /// No description provided for @general_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get general_delete;

  /// No description provided for @general_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get general_back;

  /// No description provided for @general_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get general_done;

  /// No description provided for @general_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get general_required;

  /// No description provided for @general_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get general_active;

  /// No description provided for @general_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get general_inactive;

  /// No description provided for @general_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get general_search;

  /// No description provided for @general_noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get general_noPhone;

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

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @selectThisPlan.
  ///
  /// In en, this message translates to:
  /// **'Select This Plan'**
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
  /// **'Selected Plan'**
  String get selectedPlan;

  /// No description provided for @baseAmount.
  ///
  /// In en, this message translates to:
  /// **'Base Amount'**
  String get baseAmount;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @planDetails.
  ///
  /// In en, this message translates to:
  /// **'Plan Details'**
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

  /// No description provided for @accountMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String accountMemberSince(String date);

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

  /// Label shown in branch selector when no branch is selected
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get admin_allBranches;

  /// AI Assistant screen title in AppBar
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get admin_aiTitle;

  /// Tooltip for the reset/new conversation button
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get admin_aiNewConversation;

  /// Section header for recent AI queries
  ///
  /// In en, this message translates to:
  /// **'Recent Queries'**
  String get admin_aiRecentQueries;

  /// View link next to recent query items
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get admin_aiView;

  /// Label above follow-up question chips
  ///
  /// In en, this message translates to:
  /// **'You might also ask:'**
  String get admin_aiYouMightAlsoAsk;

  /// Hint text inside the AI chat input field
  ///
  /// In en, this message translates to:
  /// **'Ask a question about your gym...'**
  String get admin_aiInputHint;

  /// Retry button on AI error screen
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_aiRetry;

  /// Title text on the AI hero banner
  ///
  /// In en, this message translates to:
  /// **'AI Insights Assistant'**
  String get admin_aiHeroBannerTitle;

  /// Subtitle on the AI hero banner
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your gym'**
  String get admin_aiHeroBannerSubtitle;

  /// Description text on the AI hero banner
  ///
  /// In en, this message translates to:
  /// **'Get instant analytics, insights, and\nrecommendations based on your gym\'s data.'**
  String get admin_aiHeroBannerDesc;

  /// Header for the suggested questions list
  ///
  /// In en, this message translates to:
  /// **'Suggested Questions'**
  String get admin_aiSuggestedQuestions;

  /// Error message shown when AI query fails
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not process your request. Please try again.'**
  String get admin_aiQueryFailed;

  /// Branches screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get admin_branchesTitle;

  /// Add branch page AppBar title
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get admin_addBranchTitle;

  /// Snackbar message after branch is created
  ///
  /// In en, this message translates to:
  /// **'Branch created successfully'**
  String get admin_branchCreatedSuccess;

  /// Section title for basic branch info form
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get admin_branchBasicInfo;

  /// Label for branch name field
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get admin_branchName;

  /// Validation for branch name field
  ///
  /// In en, this message translates to:
  /// **'Branch name is required'**
  String get admin_branchNameRequired;

  /// Label for city field
  ///
  /// In en, this message translates to:
  /// **'City / Location'**
  String get admin_branchCity;

  /// Validation for city field
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get admin_branchCityRequired;

  /// Section title for contact info form
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get admin_branchContactInfo;

  /// Label for phone field in add branch
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get admin_branchPhone;

  /// Validation for branch phone field
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get admin_branchPhoneRequired;

  /// Label for email field in add branch
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get admin_branchEmail;

  /// Validation for branch email field
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get admin_branchEmailRequired;

  /// Validation for invalid branch email
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get admin_branchEmailInvalid;

  /// Label for address field in add branch
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get admin_branchAddress;

  /// Validation for branch address field
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get admin_branchAddressRequired;

  /// Section title for operating hours
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get admin_branchOperatingHours;

  /// Label for opening time picker
  ///
  /// In en, this message translates to:
  /// **'Opening Time'**
  String get admin_branchOpeningTime;

  /// Label for closing time picker
  ///
  /// In en, this message translates to:
  /// **'Closing Time'**
  String get admin_branchClosingTime;

  /// Validation error when closing time is before opening time
  ///
  /// In en, this message translates to:
  /// **'Closing time must be after opening time'**
  String get admin_branchTimeError;

  /// Section label for branch status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get admin_branchStatus;

  /// Active status option in branch form
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_branchActive;

  /// Inactive status option in branch form
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_branchInactive;

  /// Submit button on add branch page
  ///
  /// In en, this message translates to:
  /// **'Create Branch'**
  String get admin_branchCreate;

  /// Snackbar when opening time not selected
  ///
  /// In en, this message translates to:
  /// **'Please select an opening time'**
  String get admin_branchOpeningRequired;

  /// Snackbar when closing time not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a closing time'**
  String get admin_branchClosingRequired;

  /// Branch detail page AppBar title
  ///
  /// In en, this message translates to:
  /// **'Branch Detail'**
  String get admin_branchDetailTitle;

  /// Members stat label in branch detail
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get admin_branchMembers;

  /// Trainers stat label in branch detail
  ///
  /// In en, this message translates to:
  /// **'Trainers'**
  String get admin_branchTrainers;

  /// Staff stat label in branch detail
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get admin_branchStaff;

  /// Monthly revenue label in branch detail
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get admin_branchMonthlyRevenue;

  /// Active branches stat label in branch list
  ///
  /// In en, this message translates to:
  /// **'Active Branches'**
  String get admin_branchActiveStat;

  /// Total members stat label in branch list
  ///
  /// In en, this message translates to:
  /// **'Total Members'**
  String get admin_branchTotalMembers;

  /// Hint text in branch search field
  ///
  /// In en, this message translates to:
  /// **'Search by branch name or location.'**
  String get admin_branchSearchHint;

  /// Default option in branch status filter dropdown
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get admin_branchAllStatus;

  /// Empty state message for branch list
  ///
  /// In en, this message translates to:
  /// **'No branches found'**
  String get admin_branchNoFound;

  /// Retry button on branch list error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_branchRetry;

  /// Classes screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get admin_classesTitle;

  /// Section header label when selected date is today
  ///
  /// In en, this message translates to:
  /// **'Today\'s Classes'**
  String get admin_classTodayLabel;

  /// Title of cancel class confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel Class'**
  String get admin_classCancelTitle;

  /// Body of cancel class confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this class? All booked members will be notified.'**
  String get admin_classCancelConfirm;

  /// Keep class button in cancel confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Keep Class'**
  String get admin_classKeep;

  /// Confirm cancel button in cancel class dialog
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get admin_classYesCancel;

  /// Snackbar after class is created
  ///
  /// In en, this message translates to:
  /// **'Class created successfully'**
  String get admin_classCreatedSuccess;

  /// Snackbar after class is updated
  ///
  /// In en, this message translates to:
  /// **'Class updated successfully'**
  String get admin_classUpdatedSuccess;

  /// Snackbar after class is cancelled
  ///
  /// In en, this message translates to:
  /// **'Class cancelled'**
  String get admin_classCancelledSuccess;

  /// Fallback snackbar message for class action
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get admin_classDone;

  /// Retry button on classes error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_classRetry;

  /// Empty state message when no classes for selected date
  ///
  /// In en, this message translates to:
  /// **'No classes scheduled for this day'**
  String get admin_classNoneToday;

  /// Title of create new class type sheet
  ///
  /// In en, this message translates to:
  /// **'New Class Type'**
  String get admin_classNewTypeLabel;

  /// Name field label in new class type form
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get admin_classNameField;

  /// Generic required validation in class forms
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_classRequired;

  /// Duration field label in class form
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes) *'**
  String get admin_classDurationField;

  /// Validation when non-numeric value entered in class form
  ///
  /// In en, this message translates to:
  /// **'Must be a number'**
  String get admin_classMustBeNumber;

  /// Difficulty level dropdown label in class type form
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level'**
  String get admin_classDifficulty;

  /// Beginner difficulty option
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get admin_classBeginner;

  /// Intermediate difficulty option
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get admin_classIntermediate;

  /// Advanced difficulty option
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get admin_classAdvanced;

  /// Price field label in class type form
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get admin_classPrice;

  /// Cancel button in class forms
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_classCancel;

  /// Error snackbar when creating class type fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create class type'**
  String get admin_classFailedCreate;

  /// Create button in class type form
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get admin_classCreate;

  /// Validation when date/time not selected in class form
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get admin_classSelectDatetime;

  /// Validation when required fields missing in class form
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get admin_classFillRequired;

  /// Title of edit class bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Class'**
  String get admin_classEditTitle;

  /// Title of add new class bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add New Class'**
  String get admin_classAddTitle;

  /// Class name field label in add/edit form
  ///
  /// In en, this message translates to:
  /// **'Class Name *'**
  String get admin_classNameLabel;

  /// Type/activity field label in class form
  ///
  /// In en, this message translates to:
  /// **'Type / Activity *'**
  String get admin_classTypeActivity;

  /// Option to create a new class type in the dropdown
  ///
  /// In en, this message translates to:
  /// **'New Type'**
  String get admin_classNewType;

  /// Hint for type dropdown in class form
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get admin_classSelectType;

  /// Trainer dropdown label in class form
  ///
  /// In en, this message translates to:
  /// **'Trainer *'**
  String get admin_classTrainer;

  /// Hint for trainer dropdown in class form
  ///
  /// In en, this message translates to:
  /// **'Select trainer'**
  String get admin_classSelectTrainer;

  /// Branch dropdown label in class form
  ///
  /// In en, this message translates to:
  /// **'Branch *'**
  String get admin_classBranch;

  /// Hint for branch dropdown in class form
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_classSelectBranch;

  /// Date field label in class form
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get admin_classDate;

  /// Time field label in class form
  ///
  /// In en, this message translates to:
  /// **'Time *'**
  String get admin_classTime;

  /// Capacity field label in class form
  ///
  /// In en, this message translates to:
  /// **'Capacity *'**
  String get admin_classCapacity;

  /// Hint for capacity field in class form
  ///
  /// In en, this message translates to:
  /// **'Maximum participants'**
  String get admin_classMaxParticipants;

  /// Room name field label in class form
  ///
  /// In en, this message translates to:
  /// **'Room Name'**
  String get admin_classRoomName;

  /// Notes field label in class form
  ///
  /// In en, this message translates to:
  /// **'Notes / Description'**
  String get admin_classNotesDesc;

  /// Save button in add/edit class form
  ///
  /// In en, this message translates to:
  /// **'Save Class'**
  String get admin_classSave;

  /// Badge shown when class is almost at capacity
  ///
  /// In en, this message translates to:
  /// **'Nearly Full'**
  String get admin_classNearlyFull;

  /// Bookings label on class date filter card
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get admin_classBookings;

  /// Edit action label on class card
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_classEdit;

  /// Today label in class date filter
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get admin_classToday;

  /// Title of session bookings bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Session Bookings'**
  String get admin_sessionBookingsTitle;

  /// Empty state in session bookings sheet
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get admin_sessionNoBookings;

  /// Status label for booked sessions
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get admin_sessionBooked;

  /// Dashboard screen title in AppBar
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get admin_dashboardTitle;

  /// Today option in period selector
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get admin_dashboardToday;

  /// This Week option in period selector
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get admin_dashboardThisWeek;

  /// This Month option in period selector
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get admin_dashboardThisMonth;

  /// Custom option in period selector
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get admin_dashboardCustom;

  /// Label for the period selector row
  ///
  /// In en, this message translates to:
  /// **'Time Period'**
  String get admin_dashboardTimePeriod;

  /// Retry button on dashboard error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_dashboardRetry;

  /// Snackbar for unimplemented quick actions
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get admin_dashboardComingSoon;

  /// Active members stat card title
  ///
  /// In en, this message translates to:
  /// **'Active Members'**
  String get admin_dashboardActiveMembers;

  /// Sublabel on pending renewals card
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get admin_dashboardDueSoon;

  /// Pending renewals stat card title
  ///
  /// In en, this message translates to:
  /// **'Pending Renewals'**
  String get admin_dashboardPendingRenewals;

  /// Sublabel on today's check-ins card
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get admin_dashboardLiveNow;

  /// Today's check-ins stat card title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Check-ins'**
  String get admin_dashboardTodayCheckins;

  /// Sublabel on upcoming PT card
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get admin_dashboardSessions;

  /// Upcoming PT stat card title
  ///
  /// In en, this message translates to:
  /// **'Upcoming PT'**
  String get admin_dashboardUpcomingPt;

  /// Section header for quick actions
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get admin_dashboardQuickActions;

  /// Add member quick action label
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get admin_dashboardAddMember;

  /// Record payment quick action label
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get admin_dashboardRecordPayment;

  /// Add plan quick action label
  ///
  /// In en, this message translates to:
  /// **'Add Plan'**
  String get admin_dashboardAddPlan;

  /// Send announcement quick action label
  ///
  /// In en, this message translates to:
  /// **'Send Announcement'**
  String get admin_dashboardSendAnnouncement;

  /// Section header for recent activity feed
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get admin_dashboardRecentActivity;

  /// View all link next to recent activity header
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get admin_dashboardViewAll;

  /// Empty state for recent activity feed
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get admin_dashboardNoActivity;

  /// Attendance metric card label
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get admin_dashboardAttendance;

  /// Payments collected metric card label
  ///
  /// In en, this message translates to:
  /// **'Payments Collected'**
  String get admin_dashboardPaymentsCollected;

  /// Expiring plans metric card label
  ///
  /// In en, this message translates to:
  /// **'Expiring Plans'**
  String get admin_dashboardExpiringPlans;

  /// Sublabel on expiring plans card
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get admin_dashboardNext7Days;

  /// Total members metric card label
  ///
  /// In en, this message translates to:
  /// **'Total Members'**
  String get admin_dashboardTotalMembersLabel;

  /// Total plans row label in text metrics
  ///
  /// In en, this message translates to:
  /// **'Total Plans'**
  String get admin_dashboardTotalPlans;

  /// Canceled row label in text metrics
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get admin_dashboardCanceled;

  /// Sublabel on canceled row
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get admin_dashboardLast7Days;

  /// Churn rate row label in text metrics
  ///
  /// In en, this message translates to:
  /// **'Churn Rate'**
  String get admin_dashboardChurnRate;

  /// Monthly revenue row label in text metrics
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get admin_dashboardMonthlyRevenue;

  /// Members screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get admin_membersTitle;

  /// Member detail page title
  ///
  /// In en, this message translates to:
  /// **'Member Detail'**
  String get admin_memberDetailTitle;

  /// Empty state message in members list
  ///
  /// In en, this message translates to:
  /// **'No members found.'**
  String get admin_memberNoFound;

  /// Retry button in members error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_memberRetry;

  /// Plan label on member card info grid
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get admin_memberPlan;

  /// Due amount label on member card info grid
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get admin_memberDueAmount;

  /// Expiry label on member card info grid
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get admin_memberExpiry;

  /// Branch label on member card info grid
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get admin_memberBranch;

  /// WhatsApp action label on member card
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get admin_memberWhatsApp;

  /// Attendance action label on member card
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get admin_memberAttendance;

  /// Renew action label on member card
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get admin_memberRenew;

  /// Coming soon label for plan renewal feature
  ///
  /// In en, this message translates to:
  /// **'Plan Renewal'**
  String get admin_memberPlanRenewal;

  /// Unblock action label on member card
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get admin_memberUnblock;

  /// Block action label on member card
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get admin_memberBlock;

  /// Delete action label on member card
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_memberDelete;

  /// Edit action label on member card
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_memberEdit;

  /// Coming soon label for edit member feature
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get admin_memberEditTitle;

  /// Title of block member dialog
  ///
  /// In en, this message translates to:
  /// **'Block Member'**
  String get admin_memberBlockTitle;

  /// Hint text in block member reason field
  ///
  /// In en, this message translates to:
  /// **'Enter reason for blocking'**
  String get admin_memberBlockReasonHint;

  /// Title of delete member confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Member'**
  String get admin_memberDeleteTitle;

  /// Body of delete member confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Permanently delete {name}? This cannot be undone.'**
  String admin_memberDeleteConfirm(String name);

  /// Cancel button in member dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_memberCancel;

  /// Active status badge on member card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_memberActive;

  /// Pending status badge on member card
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admin_memberPending;

  /// Blocked status badge on member card
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get admin_memberBlocked;

  /// Default status label when no plan assigned
  ///
  /// In en, this message translates to:
  /// **'No Plan'**
  String get admin_memberNoPlan;

  /// Inactive status badge on member info section
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_memberInactive;

  /// Default option in member status filter
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get admin_memberAllStatus;

  /// Newest sort option in member filter
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get admin_memberNewest;

  /// Oldest sort option in member filter
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get admin_memberOldest;

  /// Alphabetical sort option in member filter
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get admin_memberAlphabetical;

  /// Default option in member gender filter
  ///
  /// In en, this message translates to:
  /// **'All Gender'**
  String get admin_memberAllGender;

  /// Male gender filter option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get admin_memberMale;

  /// Female gender filter option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get admin_memberFemale;

  /// Other gender filter option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get admin_memberOther;

  /// Hint text in members search bar
  ///
  /// In en, this message translates to:
  /// **'Search by Name, Phone, Member Code'**
  String get admin_memberSearchHint;

  /// Title of membership package widget
  ///
  /// In en, this message translates to:
  /// **'Membership Package'**
  String get admin_membershipPackageTitle;

  /// Plan name row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Plan Name'**
  String get admin_memberPlanName;

  /// Total amount row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get admin_memberTotalAmount;

  /// Discount row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get admin_memberDiscount;

  /// Purchase date row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get admin_memberPurchaseDate;

  /// Paid amount row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get admin_memberPaidAmount;

  /// Due amount row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get admin_memberDueAmountLabel;

  /// Remaining days row label in membership package widget
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get admin_memberRemainingDays;

  /// Title of quick actions widget in member detail
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get admin_memberQuickActions;

  /// Call action button label in quick actions
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get admin_memberCall;

  /// SMS action button label in quick actions
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get admin_memberSms;

  /// Renew plan action button label in quick actions
  ///
  /// In en, this message translates to:
  /// **'Renew Plan'**
  String get admin_memberRenewPlan;

  /// Plans screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get admin_plansTitle;

  /// Title of delete plan confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Plan'**
  String get admin_plansDeleteTitle;

  /// Body of delete plan confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this plan?'**
  String get admin_plansDeleteConfirm;

  /// Cancel button in plan dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_plansCancel;

  /// Delete button in plan confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_plansDelete;

  /// Retry button on plans error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_plansRetry;

  /// Default option in plans type filter
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get admin_plansAllTypes;

  /// Hint text in plans search field
  ///
  /// In en, this message translates to:
  /// **'Search plans...'**
  String get admin_plansSearch;

  /// Empty state message for plans list
  ///
  /// In en, this message translates to:
  /// **'No plans found'**
  String get admin_plansNoFound;

  /// Active status badge on plan card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_planActive;

  /// Inactive status badge on plan card
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_planInactive;

  /// Price detail label on plan card
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get admin_planPrice;

  /// Duration detail label on plan card
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get admin_planDurationLabel;

  /// Members detail label on plan card
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get admin_planMembersLabel;

  /// Visit limit detail label on plan card
  ///
  /// In en, this message translates to:
  /// **'Visit Limit'**
  String get admin_planVisitLimitLabel;

  /// Unlimited value shown when no visit cap
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get admin_planUnlimitedLabel;

  /// Label above branch list on plan card
  ///
  /// In en, this message translates to:
  /// **'Available at:'**
  String get admin_planAvailableAt;

  /// Edit button on plan card
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_planEdit;

  /// Loading label on delete button while deleting
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get admin_planDeleting;

  /// Delete button label on plan card
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_planDeleteLabel;

  /// Formatted billing cycle for one-time plans
  ///
  /// In en, this message translates to:
  /// **'One time'**
  String get admin_planOneTime;

  /// Title of the edit plan bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get admin_planEditTitle;

  /// Title of the add new plan bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add New Plan'**
  String get admin_planAddTitle;

  /// Plan name field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Plan Name *'**
  String get admin_planNameField;

  /// Type/activity field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Type / Activity *'**
  String get admin_planTypeField;

  /// Hint for type dropdown in plan form
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get admin_planSelectType;

  /// Price field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Price *'**
  String get admin_planPriceField;

  /// Duration field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Duration *'**
  String get admin_planDurationField;

  /// Hint for duration dropdown in plan form
  ///
  /// In en, this message translates to:
  /// **'Select duration'**
  String get admin_planSelectDuration;

  /// Description field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admin_planDescription;

  /// Hint text in plan description field
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get admin_planOptionalDesc;

  /// Promotion field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get admin_planPromotion;

  /// Status field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Status *'**
  String get admin_planStatus;

  /// Hint for status dropdown in plan form
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get admin_planSelectStatus;

  /// Branch assignment field label in plan form
  ///
  /// In en, this message translates to:
  /// **'Available Branches *'**
  String get admin_planAvailableBranches;

  /// Hint for branch dropdown in plan form
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_planSelectBranch;

  /// Info note below branch selector in plan form
  ///
  /// In en, this message translates to:
  /// **'Note: Multi-select support coming soon'**
  String get admin_planMultiSelectNote;

  /// Save button label in edit plan form
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_planSaveChanges;

  /// Create button label in add plan form
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get admin_planCreateLabel;

  /// Generic required validation in plan form
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_planRequired;

  /// Validation when non-numeric value entered in plan price
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get admin_planEnterValidNumber;

  /// Total plans label in plan stats card
  ///
  /// In en, this message translates to:
  /// **'Total Plans'**
  String get admin_planTotalPlans;

  /// Members label in plan stats card
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get admin_planTotalMembersLabel;

  /// Active label in plan stats card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_planActiveCount;

  /// Snackbar after plan is created
  ///
  /// In en, this message translates to:
  /// **'Plan created successfully'**
  String get admin_planCreatedSuccess;

  /// Snackbar after plan is updated
  ///
  /// In en, this message translates to:
  /// **'Plan updated successfully'**
  String get admin_planUpdatedSuccess;

  /// Trainer dashboard screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Trainer Dashboard'**
  String get admin_trainerDashboardTitle;

  /// Today sessions stat label on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Today Sessions'**
  String get admin_trainerTodaySessions;

  /// Completed sessions stat label on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get admin_trainerCompleted;

  /// Upcoming sessions stat label on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get admin_trainerUpcoming;

  /// Cancelled/no-show sessions stat label on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Cancelled / No-Show'**
  String get admin_trainerCancelledNoShow;

  /// Today's schedule section header on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get admin_trainerTodaySchedule;

  /// Empty state message when no sessions today
  ///
  /// In en, this message translates to:
  /// **'No sessions scheduled for today.'**
  String get admin_trainerNoSessionsToday;

  /// Label for PT session type
  ///
  /// In en, this message translates to:
  /// **'PT Session'**
  String get admin_trainerPtSession;

  /// Check in button label on session card
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get admin_trainerCheckIn;

  /// Complete button label on session card
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get admin_trainerComplete;

  /// Create package quick action label
  ///
  /// In en, this message translates to:
  /// **'Create Package'**
  String get admin_trainerCreatePackage;

  /// Add availability quick action label
  ///
  /// In en, this message translates to:
  /// **'Add Availability'**
  String get admin_trainerAddAvailability;

  /// Add PT service quick action label
  ///
  /// In en, this message translates to:
  /// **'Add PT Service'**
  String get admin_trainerAddPtService;

  /// Create session quick action label
  ///
  /// In en, this message translates to:
  /// **'Create Session'**
  String get admin_trainerCreateSession;

  /// Quick actions section header on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get admin_trainerQuickActionsTitle;

  /// Upcoming clients section header on trainer dashboard
  ///
  /// In en, this message translates to:
  /// **'Upcoming Clients'**
  String get admin_trainerUpcomingClients;

  /// View all link on trainer dashboard sections
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get admin_trainerViewAll;

  /// Empty state for upcoming clients section
  ///
  /// In en, this message translates to:
  /// **'No upcoming clients.'**
  String get admin_trainerNoUpcomingClients;

  /// Dashboard tab label in trainer main screen
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get admin_trainerMainDashboard;

  /// Sessions tab label in trainer main screen
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get admin_trainerMainSessions;

  /// Packages tab label in trainer main screen
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get admin_trainerMainPackages;

  /// Schedule tab label in trainer main screen
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get admin_trainerMainSchedule;

  /// More tab label in trainer main screen
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get admin_trainerMainMore;

  /// Loading message while trainer data loads
  ///
  /// In en, this message translates to:
  /// **'Loading trainers…'**
  String get admin_trainerLoading;

  /// Packages screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get admin_packagesTitle;

  /// New package button label
  ///
  /// In en, this message translates to:
  /// **'New Package'**
  String get admin_packagesNew;

  /// Active badge on package card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_packagesActive;

  /// Sessions label on package card stats
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get admin_packagesSessions;

  /// Days per week label on package card
  ///
  /// In en, this message translates to:
  /// **'Days/Week'**
  String get admin_packagesDaysWeek;

  /// Days label on package card validity
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get admin_packagesDays;

  /// Title of edit package bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Package'**
  String get admin_packagesEditTitle;

  /// Title of create package screen
  ///
  /// In en, this message translates to:
  /// **'Create PT Package'**
  String get admin_packagesCreateTitle;

  /// Back button in package creation flow
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get admin_packagesBack;

  /// Create package submit button
  ///
  /// In en, this message translates to:
  /// **'Create Package'**
  String get admin_packagesCreate;

  /// Continue button in package creation steps
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get admin_packagesContinue;

  /// Step 1 label in package creation stepper
  ///
  /// In en, this message translates to:
  /// **'Basic\nInfo'**
  String get admin_packagesBasicInfo;

  /// Step 2 label in package creation stepper
  ///
  /// In en, this message translates to:
  /// **'Training\nRules'**
  String get admin_packagesTrainingRules;

  /// Step 3 label in package creation stepper
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get admin_packagesPricing;

  /// Step 4 label in package creation stepper
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get admin_packagesPreview;

  /// Package name field label
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get admin_packagesName;

  /// Package type field label
  ///
  /// In en, this message translates to:
  /// **'Package Type'**
  String get admin_packagesType;

  /// Hint for package type dropdown
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get admin_packagesSelectType;

  /// Weight loss package type option
  ///
  /// In en, this message translates to:
  /// **'Weight Loss'**
  String get admin_packagesWeightLoss;

  /// Strength building package type option
  ///
  /// In en, this message translates to:
  /// **'Strength Building'**
  String get admin_packagesStrength;

  /// Cardio package type option
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get admin_packagesCardio;

  /// General fitness package type option
  ///
  /// In en, this message translates to:
  /// **'General Fitness'**
  String get admin_packagesGeneral;

  /// Linked PT service field label in package form
  ///
  /// In en, this message translates to:
  /// **'Linked PT Service'**
  String get admin_packagesLinkedService;

  /// Hint for service dropdown in package form
  ///
  /// In en, this message translates to:
  /// **'Select service'**
  String get admin_packagesSelectService;

  /// Personal training service option
  ///
  /// In en, this message translates to:
  /// **'Personal Training'**
  String get admin_packagesPersonalTraining;

  /// Strength training service option
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get admin_packagesStrengthTraining;

  /// Weight loss program service option
  ///
  /// In en, this message translates to:
  /// **'Weight Loss Program'**
  String get admin_packagesWeightLossProgram;

  /// Total sessions field label in package form
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get admin_packagesTotalSessions;

  /// Min days per week field label in package form
  ///
  /// In en, this message translates to:
  /// **'Min Days/Week'**
  String get admin_packagesMinDays;

  /// Max days per week field label in package form
  ///
  /// In en, this message translates to:
  /// **'Max Days/Week'**
  String get admin_packagesMaxDays;

  /// Validity field label in package form
  ///
  /// In en, this message translates to:
  /// **'Validity (Days)'**
  String get admin_packagesValidity;

  /// Regular price field label in package form
  ///
  /// In en, this message translates to:
  /// **'Regular Price (\$)'**
  String get admin_packagesRegularPrice;

  /// Sale price field label in package form
  ///
  /// In en, this message translates to:
  /// **'Sale Price (\$) - Optional'**
  String get admin_packagesSalePrice;

  /// Package summary section title in preview step
  ///
  /// In en, this message translates to:
  /// **'Package Summary'**
  String get admin_packagesSummary;

  /// Name label in package summary
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get admin_packagesNameLabel;

  /// Sessions label in package summary
  ///
  /// In en, this message translates to:
  /// **'Sessions:'**
  String get admin_packagesSessionsLabel;

  /// Frequency label in package summary
  ///
  /// In en, this message translates to:
  /// **'Frequency:'**
  String get admin_packagesFrequency;

  /// Validity label in package summary
  ///
  /// In en, this message translates to:
  /// **'Validity:'**
  String get admin_packagesValidityLabel;

  /// Fallback when validity is not set in package summary
  ///
  /// In en, this message translates to:
  /// **'N/A days'**
  String get admin_packagesNaDays;

  /// Price label in package summary
  ///
  /// In en, this message translates to:
  /// **'Price:'**
  String get admin_packagesPriceLabel;

  /// Sessions screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get admin_sessionsTitle;

  /// Book session button label
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get admin_sessionsBook;

  /// Snackbar after session is cancelled
  ///
  /// In en, this message translates to:
  /// **'Session cancelled.'**
  String get admin_sessionCancelled;

  /// Snackbar after session is marked as no-show
  ///
  /// In en, this message translates to:
  /// **'Session marked as no-show.'**
  String get admin_sessionNoShow;

  /// Snackbar after session is updated
  ///
  /// In en, this message translates to:
  /// **'Session updated.'**
  String get admin_sessionUpdated;

  /// Today filter tab in sessions screen
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get admin_sessionFilterToday;

  /// Upcoming filter tab in sessions screen
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get admin_sessionFilterUpcoming;

  /// Completed filter tab in sessions screen
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get admin_sessionFilterCompleted;

  /// Empty state for today sessions tab
  ///
  /// In en, this message translates to:
  /// **'No sessions scheduled for today.'**
  String get admin_sessionNoSessionsToday;

  /// Empty state for upcoming sessions tab
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions.'**
  String get admin_sessionNoUpcoming;

  /// Empty state for completed sessions tab
  ///
  /// In en, this message translates to:
  /// **'No completed sessions yet.'**
  String get admin_sessionNoCompleted;

  /// Retry button on sessions error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_sessionRetry;

  /// PT session label on session card
  ///
  /// In en, this message translates to:
  /// **'PT Session'**
  String get admin_sessionCardPt;

  /// Complete button on session card
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get admin_sessionCardComplete;

  /// Cancel button on session card
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_sessionCardCancel;

  /// Title of cancel session dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get admin_sessionCardCancelTitle;

  /// Body of cancel session dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this session?'**
  String get admin_sessionCardCancelConfirm;

  /// Keep button in cancel session dialog
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get admin_sessionCardKeep;

  /// Session progress section label on session card
  ///
  /// In en, this message translates to:
  /// **'Session Progress'**
  String get admin_sessionCardProgress;

  /// Trainer schedule screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get admin_scheduleTitle;

  /// Add slot button in schedule screen
  ///
  /// In en, this message translates to:
  /// **'Add Slot'**
  String get admin_scheduleAddSlot;

  /// Empty state in schedule screen
  ///
  /// In en, this message translates to:
  /// **'No availability set yet.'**
  String get admin_scheduleNoAvailability;

  /// Monday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get admin_scheduleMonday;

  /// Tuesday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get admin_scheduleTuesday;

  /// Wednesday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get admin_scheduleWednesday;

  /// Thursday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get admin_scheduleThursday;

  /// Friday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get admin_scheduleFriday;

  /// Saturday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get admin_scheduleSaturday;

  /// Sunday day label in schedule
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get admin_scheduleSunday;

  /// Recurring label on availability slot card
  ///
  /// In en, this message translates to:
  /// **'Recurring weekly'**
  String get admin_scheduleRecurring;

  /// Title of add availability bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add Availability'**
  String get admin_scheduleAddAvailability;

  /// Day of week field label in add availability form
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get admin_scheduleDayOfWeek;

  /// Hint for day dropdown in add availability form
  ///
  /// In en, this message translates to:
  /// **'Select day'**
  String get admin_scheduleSelectDay;

  /// Start time field label in add availability form
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get admin_scheduleStartTime;

  /// End time field label in add availability form
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get admin_scheduleEndTime;

  /// Recurring weekly toggle label in add availability form
  ///
  /// In en, this message translates to:
  /// **'Recurring Weekly'**
  String get admin_scheduleRecurringWeekly;

  /// Subtitle for recurring weekly toggle
  ///
  /// In en, this message translates to:
  /// **'Repeat this slot every week'**
  String get admin_scheduleRepeatHint;

  /// Cancel button in add availability form
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_scheduleCancel;

  /// Trainer services screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get admin_servicesTitle;

  /// New service button label
  ///
  /// In en, this message translates to:
  /// **'New Service'**
  String get admin_servicesNew;

  /// General service category option
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get admin_servicesGeneral;

  /// Specialized service category option
  ///
  /// In en, this message translates to:
  /// **'Specialized'**
  String get admin_servicesSpecialized;

  /// Elite service category option
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get admin_servicesElite;

  /// Active badge on service card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_servicesActive;

  /// Title of edit service bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get admin_servicesEditTitle;

  /// Title of create service bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Create PT Service'**
  String get admin_servicesCreateTitle;

  /// Service name field label
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get admin_servicesName;

  /// Category field label in service form
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get admin_servicesCategory;

  /// Duration field label in service form
  ///
  /// In en, this message translates to:
  /// **'Duration (min)'**
  String get admin_servicesDuration;

  /// Price field label in service form
  ///
  /// In en, this message translates to:
  /// **'Price (\$)'**
  String get admin_servicesPrice;

  /// Description field label in service form
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admin_servicesDescription;

  /// Hint text in service description field
  ///
  /// In en, this message translates to:
  /// **'Describe the service...'**
  String get admin_servicesDescHint;

  /// Cancel button in service form
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_servicesCancel;

  /// Create button in service form
  ///
  /// In en, this message translates to:
  /// **'Create Service'**
  String get admin_servicesCreate;

  /// Title of book session bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get admin_bookSessionTitle;

  /// Validation when time not selected in book session form
  ///
  /// In en, this message translates to:
  /// **'Please select start and end time.'**
  String get admin_bookSelectTime;

  /// Validation for invalid member ID in book session form
  ///
  /// In en, this message translates to:
  /// **'Invalid Member ID.'**
  String get admin_bookInvalidMember;

  /// Member ID field label in book session form
  ///
  /// In en, this message translates to:
  /// **'Member ID'**
  String get admin_bookMemberId;

  /// Hint text for member ID field in book session form
  ///
  /// In en, this message translates to:
  /// **'Enter a valid member ID'**
  String get admin_bookMemberIdHint;

  /// Service ID field label in book session form
  ///
  /// In en, this message translates to:
  /// **'Service ID (optional)'**
  String get admin_bookServiceId;

  /// Start time field label in book session form
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get admin_bookStartTime;

  /// End time field label in book session form
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get admin_bookEndTime;

  /// Notes field label in book session form
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get admin_bookNotes;

  /// Settings screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get admin_settingsTitle;

  /// Unsaved badge label in settings AppBar
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get admin_settingsUnsaved;

  /// Hint text in settings search bar
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get admin_settingsSearch;

  /// Snackbar after settings are saved
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get admin_settingsSaved;

  /// Snackbar when saving settings fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get admin_settingsSaveFailed;

  /// Label on save button while saving
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get admin_settingsSaving;

  /// Save changes button label in settings
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_settingsSave;

  /// Legal & Policies section title in settings
  ///
  /// In en, this message translates to:
  /// **'Legal & Policies'**
  String get admin_settingsLegal;

  /// Subtitle for legal & policies section
  ///
  /// In en, this message translates to:
  /// **'Review our policies'**
  String get admin_settingsLegalReview;

  /// Account & security section title
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get admin_settingsAccountSecurity;

  /// Subtitle for account & security section
  ///
  /// In en, this message translates to:
  /// **'Manage your account security'**
  String get admin_settingsAccountSecuritySub;

  /// Change password row label
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get admin_settingsChangePassword;

  /// Subtitle for change password row
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get admin_settingsChangePasswordSub;

  /// Biometric login row label
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get admin_settingsBiometric;

  /// Subtitle for biometric login row
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID'**
  String get admin_settingsBiometricSub;

  /// 2FA row label
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get admin_settings2fa;

  /// Subtitle for 2FA row
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get admin_settings2faSub;

  /// Business rules section title
  ///
  /// In en, this message translates to:
  /// **'Business Rules'**
  String get admin_settingsBusinessRules;

  /// Admin only badge in business rules section
  ///
  /// In en, this message translates to:
  /// **'Admin Only'**
  String get admin_settingsAdminOnly;

  /// Subtitle for business rules section
  ///
  /// In en, this message translates to:
  /// **'Configure membership & class logic'**
  String get admin_settingsBusinessRulesSub;

  /// Subscription rules collapsible group title
  ///
  /// In en, this message translates to:
  /// **'Subscription Rules'**
  String get admin_settingsSubscriptionRules;

  /// Business rule 1 title
  ///
  /// In en, this message translates to:
  /// **'Allow class subscription without membership'**
  String get admin_settingsRule1Title;

  /// Business rule 1 subtitle
  ///
  /// In en, this message translates to:
  /// **'Users can join classes without buying a plan'**
  String get admin_settingsRule1Sub;

  /// Business rule 2 title
  ///
  /// In en, this message translates to:
  /// **'Require membership for class subscription'**
  String get admin_settingsRule2Title;

  /// Business rule 2 subtitle
  ///
  /// In en, this message translates to:
  /// **'Users must have an active membership to subscribe to classes'**
  String get admin_settingsRule2Sub;

  /// Business rule 3 title
  ///
  /// In en, this message translates to:
  /// **'Allow membership without class enrollment'**
  String get admin_settingsRule3Title;

  /// Business rule 3 subtitle
  ///
  /// In en, this message translates to:
  /// **'Members can purchase plans without enrolling in any class'**
  String get admin_settingsRule3Sub;

  /// Business rule 4 title
  ///
  /// In en, this message translates to:
  /// **'Allow both independently'**
  String get admin_settingsRule4Title;

  /// Business rule 4 subtitle
  ///
  /// In en, this message translates to:
  /// **'Memberships and classes can be purchased separately'**
  String get admin_settingsRule4Sub;

  /// Message shown to non-owners in business rules section
  ///
  /// In en, this message translates to:
  /// **'Only the owner can change business rules'**
  String get admin_settingsOwnerOnly;

  /// Danger zone section title
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get admin_settingsDangerZone;

  /// Subtitle for danger zone section
  ///
  /// In en, this message translates to:
  /// **'Irreversible actions'**
  String get admin_settingsDangerSub;

  /// Log out row label in danger zone
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get admin_settingsLogOut;

  /// Delete account row label in danger zone
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get admin_settingsDeleteAccount;

  /// Title of log out confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get admin_settingsLogOutTitle;

  /// Body of log out confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get admin_settingsLogOutConfirm;

  /// Cancel button in settings dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_settingsCancel;

  /// Title of delete account confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get admin_settingsDeleteTitle;

  /// First line of delete account dialog body
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account. '**
  String get admin_settingsDeleteMsg1;

  /// Second line of delete account dialog body
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get admin_settingsDeleteMsg2;

  /// Snackbar when account deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String admin_settingsDeleteFailed(String error);

  /// Staff screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get admin_staffTitle;

  /// Retry button on staff error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_staffRetry;

  /// Empty state message in staff list
  ///
  /// In en, this message translates to:
  /// **'No staff members found.'**
  String get admin_staffNoFound;

  /// Snackbar after staff member is added
  ///
  /// In en, this message translates to:
  /// **'Staff member added successfully'**
  String get admin_staffAdded;

  /// Snackbar after staff member is updated
  ///
  /// In en, this message translates to:
  /// **'Staff member updated successfully'**
  String get admin_staffUpdated;

  /// Snackbar after staff member is removed
  ///
  /// In en, this message translates to:
  /// **'Staff member removed successfully'**
  String get admin_staffRemoved;

  /// Fallback snackbar for staff actions
  ///
  /// In en, this message translates to:
  /// **'Action completed successfully'**
  String get admin_staffDone;

  /// Reception role option in staff form
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get admin_staffReception;

  /// Admin role option in staff form
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin_staffAdmin;

  /// Assistant role option in staff form
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get admin_staffAssistant;

  /// Title of edit staff bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Staff Member'**
  String get admin_staffEditTitle;

  /// Title of add staff bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add New Staff Member'**
  String get admin_staffAddTitle;

  /// Description text in add staff sheet
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to add a new\nreception staff member to your gym'**
  String get admin_staffAddDesc;

  /// Section title in staff form
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get admin_staffPersonalInfo;

  /// Full name field label in staff form
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get admin_staffFullName;

  /// Hint for full name field in staff form
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get admin_staffFullNameHint;

  /// Validation for full name field in staff form
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get admin_staffFullNameRequired;

  /// Email field label in staff form
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get admin_staffEmail;

  /// Validation for email field in staff form
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get admin_staffEmailRequired;

  /// Email format validation in staff form
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get admin_staffEmailInvalid;

  /// Phone field label in staff form
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get admin_staffPhone;

  /// Validation for phone field in staff form
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get admin_staffPhoneRequired;

  /// Role field label in staff form
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get admin_staffRole;

  /// Hint for role dropdown in staff form
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get admin_staffSelectRole;

  /// Validation for role field in staff form
  ///
  /// In en, this message translates to:
  /// **'Role is required'**
  String get admin_staffRoleRequired;

  /// Branch assignment field label in staff form
  ///
  /// In en, this message translates to:
  /// **'Branch Assignment'**
  String get admin_staffBranchAssignment;

  /// Hint for branch dropdown in staff form
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_staffSelectBranch;

  /// Validation for branch field in staff form
  ///
  /// In en, this message translates to:
  /// **'Branch is required'**
  String get admin_staffBranchRequired;

  /// Password field label in staff form
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get admin_staffPassword;

  /// Hint for password field in staff form
  ///
  /// In en, this message translates to:
  /// **'Auto-generate or enter'**
  String get admin_staffPasswordHint;

  /// Info note below password field in staff form
  ///
  /// In en, this message translates to:
  /// **'Leave empty to auto-generate a secure password'**
  String get admin_staffPasswordNote;

  /// Cancel button in staff form
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_staffCancel;

  /// Save changes button in edit staff form
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_staffSaveChanges;

  /// Add staff member button in add staff form
  ///
  /// In en, this message translates to:
  /// **'Add Staff Member'**
  String get admin_staffAddMember;

  /// Edit profile action on staff card
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get admin_staffEditProfile;

  /// Remove action on staff card
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get admin_staffRemove;

  /// Title of remove staff confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Remove Staff Member'**
  String get admin_staffRemoveTitle;

  /// Body of remove staff confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}? '**
  String admin_staffRemoveConfirm(String name);

  /// Cannot undo warning in staff remove dialog
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get admin_staffCannotUndo;

  /// Total staff stat label in staff stats row
  ///
  /// In en, this message translates to:
  /// **'Total Staff'**
  String get admin_staffTotalLabel;

  /// Active staff stat label in staff stats row
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_staffActiveLabel;

  /// Hint text in staff search bar
  ///
  /// In en, this message translates to:
  /// **'Search staff by name'**
  String get admin_staffSearchHint;

  /// Trainers screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Trainers / PT'**
  String get admin_trainersTitle;

  /// Loading message while trainer form options load
  ///
  /// In en, this message translates to:
  /// **'Loading trainer form options...'**
  String get admin_trainersLoading;

  /// Error message when trainer form options not loaded
  ///
  /// In en, this message translates to:
  /// **'Trainer form options are not ready yet'**
  String get admin_trainersFormNotReady;

  /// Empty state message in trainers list
  ///
  /// In en, this message translates to:
  /// **'No trainers found'**
  String get admin_trainersNoFound;

  /// Snackbar after trainer is added
  ///
  /// In en, this message translates to:
  /// **'Trainer added successfully ✓'**
  String get admin_trainerAdded;

  /// Snackbar after trainer is updated
  ///
  /// In en, this message translates to:
  /// **'Trainer updated ✓'**
  String get admin_trainerUpdatedSuccess;

  /// Snackbar after trainer is blocked
  ///
  /// In en, this message translates to:
  /// **'Trainer blocked'**
  String get admin_trainerBlockedSuccess;

  /// Snackbar after trainer is unblocked
  ///
  /// In en, this message translates to:
  /// **'Trainer unblocked ✓'**
  String get admin_trainerUnblockedSuccess;

  /// Fallback snackbar for trainer actions
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get admin_trainerActionDone;

  /// Retry button on trainers error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_trainersRetry;

  /// Validation when no branch selected in trainer form
  ///
  /// In en, this message translates to:
  /// **'Please select a branch'**
  String get admin_trainerSelectBranch;

  /// Title of edit trainer bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Trainer'**
  String get admin_trainerEditTitle;

  /// Title of add trainer bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add New Trainer'**
  String get admin_trainerAddTitle;

  /// Full name field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get admin_trainerFullName;

  /// Hint for full name field in trainer form
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get admin_trainerFullNameHint;

  /// Generic required validation in trainer form
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_trainerRequired;

  /// Email field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get admin_trainerEmail;

  /// Email validation in trainer form
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get admin_trainerEmailInvalid;

  /// Phone field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get admin_trainerPhone;

  /// Password field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get admin_trainerPassword;

  /// Password minimum length validation in trainer form
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get admin_trainerMinChars;

  /// Specialties section label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Specialties'**
  String get admin_trainerSpecialties;

  /// Branch assignment field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Branch Assignment *'**
  String get admin_trainerBranchAssignment;

  /// Hint for branch dropdown in trainer form
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get admin_trainerSelectBranchHint;

  /// Experience field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get admin_trainerExperience;

  /// Notes/bio field label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Notes / Bio'**
  String get admin_trainerNotesBio;

  /// Hint for notes/bio field in trainer form
  ///
  /// In en, this message translates to:
  /// **'Optional bio or notes'**
  String get admin_trainerNotesBioHint;

  /// Availability section label in trainer form
  ///
  /// In en, this message translates to:
  /// **'Availability Schedule'**
  String get admin_trainerAvailability;

  /// Add slot button in trainer availability section
  ///
  /// In en, this message translates to:
  /// **'Add Slot'**
  String get admin_trainerAddSlot;

  /// Empty state for availability slots in trainer form
  ///
  /// In en, this message translates to:
  /// **'No availability slots yet.'**
  String get admin_trainerNoSlots;

  /// Cancel button in trainer form
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_trainerCancel;

  /// Save changes button in edit trainer form
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_trainerSaveChanges;

  /// Save button in add trainer form
  ///
  /// In en, this message translates to:
  /// **'Save Trainer'**
  String get admin_trainerSave;

  /// Hint text for specialty input field
  ///
  /// In en, this message translates to:
  /// **'Type a specialty and press + or Enter to add'**
  String get admin_trainerSpecialtyHint;

  /// Confirmation message body for unblock trainer dialog
  ///
  /// In en, this message translates to:
  /// **'They will be able to log in again.'**
  String get admin_trainerUnblockConfirm;

  /// Confirmation message body for block trainer dialog
  ///
  /// In en, this message translates to:
  /// **'They will not be able to log in.'**
  String get admin_trainerBlockConfirm;

  /// Title of unblock trainer dialog
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get admin_trainerUnblockTitle;

  /// Title of block trainer dialog
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get admin_trainerBlockTitle;

  /// Cancel button in trainer block/unblock dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_trainerCancelAction;

  /// Blocked status badge on trainer card
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get admin_trainerBlockedStatus;

  /// Active status badge on trainer card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_trainerActiveStatus;

  /// Schedule action label on trainer card
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get admin_trainerScheduleLabel;

  /// Edit action label on trainer card
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get admin_trainerEditLabel;

  /// Hint text in trainer search bar
  ///
  /// In en, this message translates to:
  /// **'Search by name or specialty'**
  String get admin_trainerSearchHint;

  /// New category option in category dropdown
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get admin_videoNewCategory;

  /// Hint for new category name input
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get admin_videoCategoryName;

  /// Cancel button in video forms
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_videoCancel;

  /// Validation when no category selected for video
  ///
  /// In en, this message translates to:
  /// **'Please select or create a category'**
  String get admin_videoSelectCategory;

  /// Validation for video duration
  ///
  /// In en, this message translates to:
  /// **'Duration must be greater than 0'**
  String get admin_videoDurationInvalid;

  /// Snackbar after video is added
  ///
  /// In en, this message translates to:
  /// **'Video added successfully'**
  String get admin_videoAdded;

  /// Snackbar after new category is created
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" created and selected'**
  String admin_videoCategoryCreated(String name);

  /// Snackbar for video operation failure
  ///
  /// In en, this message translates to:
  /// **'Failed: {message}'**
  String admin_videoFailed(String message);

  /// Add training video screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Add Training Video'**
  String get admin_videoAddTitle;

  /// Title field label in add video form
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get admin_videoTitleField;

  /// Validation for title field in add video form
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get admin_videoTitleRequired;

  /// Description field label in add video form
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get admin_videoDescriptionField;

  /// Category field label in add video form
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get admin_videoCategoryField;

  /// Hint for category dropdown in add video form
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get admin_videoSelectCategoryHint;

  /// Validation for category field in add video form
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get admin_videoSelectCategoryRequired;

  /// Option to add a new category in add video form
  ///
  /// In en, this message translates to:
  /// **'Add new category'**
  String get admin_videoAddNewCategory;

  /// Trainer assignment field label in add video form
  ///
  /// In en, this message translates to:
  /// **'Assign to Trainer *'**
  String get admin_videoAssignTrainer;

  /// Hint for trainer dropdown in add video form
  ///
  /// In en, this message translates to:
  /// **'Select a trainer'**
  String get admin_videoSelectTrainer;

  /// Validation for trainer field in add video form
  ///
  /// In en, this message translates to:
  /// **'Please assign a trainer'**
  String get admin_videoTrainerRequired;

  /// Button to pick video from device
  ///
  /// In en, this message translates to:
  /// **'Pick Video From Phone'**
  String get admin_videoPickFromPhone;

  /// Duration section label in add video form
  ///
  /// In en, this message translates to:
  /// **'Duration *'**
  String get admin_videoDurationField;

  /// Minutes label in video duration input
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get admin_videoMinutes;

  /// Required validation in video form
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_videoRequired;

  /// Invalid validation in video form
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get admin_videoInvalid;

  /// Seconds label in video duration input
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get admin_videoSeconds;

  /// Published toggle label in add video form
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get admin_videoPublished;

  /// Subtitle for published toggle in add video form
  ///
  /// In en, this message translates to:
  /// **'Visible to members immediately'**
  String get admin_videoVisibleToMembers;

  /// Submit button in add video form
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get admin_videoAdd;

  /// Training videos list screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Training Videos'**
  String get admin_videoListTitle;

  /// Retry button on video list error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get admin_videoRetry;

  /// Total videos stat label in video list
  ///
  /// In en, this message translates to:
  /// **'Total Videos'**
  String get admin_videoTotalVideos;

  /// Total views stat label in video list
  ///
  /// In en, this message translates to:
  /// **'Total Views'**
  String get admin_videoTotalViews;

  /// Empty state message in video list
  ///
  /// In en, this message translates to:
  /// **'No videos found.'**
  String get admin_videoNoVideos;

  /// Default option in video category filter
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get admin_videoAllCategories;

  /// Category label on video card
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get admin_videoCategory;
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
