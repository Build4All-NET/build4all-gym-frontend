// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auth_welcomeBack => 'Welcome Back';

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
  String get validation_emailRequired => 'Email is required';

  @override
  String get validation_phoneRequired => 'Phone number is required';

  @override
  String get validation_emailInvalid => 'Invalid email address';

  @override
  String get validation_passwordRequired => 'Password is required';

  @override
  String get validation_invalidCredentials => 'Invalid email or password';

  @override
  String get general_cancel => 'Cancel';

  @override
  String get general_or => 'or';

  @override
  String get error_somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get connection_offline => 'No internet connection';

  @override
  String get authGateContinueAs => 'Continue as';

  @override
  String get authGateRoleAdminOwner => 'Admin / Owner';

  @override
  String get authGateRoleUser => 'Regular User';

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
  String get common_or => 'Or';

  @override
  String get login_noAccount => 'Don\'t have an account?';

  @override
  String get login_createAccount => 'Create new account';

  @override
  String get validation_invalidEmail => 'Please enter a valid email';

  @override
  String get connection_reconnecting => 'Connecting...';

  @override
  String get connection_issue => 'Connection issue';

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
}
