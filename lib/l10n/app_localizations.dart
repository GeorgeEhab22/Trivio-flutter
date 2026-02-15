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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @sendingCode.
  ///
  /// In en, this message translates to:
  /// **'Sending code...'**
  String get sendingCode;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {username}! Your account has been created.'**
  String registrationSuccess(Object username);

  /// No description provided for @verificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification successful!'**
  String get verificationSuccess;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent!'**
  String get codeResent;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterDigitsSent.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get enterDigitsSent;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @otpHeader.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otpHeader;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP sent to'**
  String get enterOtpSentTo;

  /// No description provided for @resetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting...'**
  String get resetting;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully!'**
  String get otpVerifiedSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! It happens. Please enter the email address associated with your account.'**
  String get forgotPasswordDesc;

  /// No description provided for @resendCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Code'**
  String get resendCodeTitle;

  /// No description provided for @resendCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your email address. We’ll resend a new verification code to help you activate your account.'**
  String get resendCodeDesc;

  /// No description provided for @sendOtpBtn.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtpBtn;

  /// No description provided for @resendBtn.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendBtn;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @resending.
  ///
  /// In en, this message translates to:
  /// **'Resending...'**
  String get resending;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset OTP sent successfully!'**
  String get passwordResetSent;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didNotReceiveCode;

  /// No description provided for @didNotReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the OTP? '**
  String get didNotReceiveOtp;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @canChangeIn.
  ///
  /// In en, this message translates to:
  /// **'Can change in {seconds}s'**
  String canChangeIn(String seconds);

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orDivider;

  /// No description provided for @labelUsernameEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get labelUsernameEmail;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @hintUsernameEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter username or email'**
  String get hintUsernameEmail;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get hintEmail;

  /// No description provided for @errEmptyLogin.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username or email'**
  String get errEmptyLogin;

  /// No description provided for @errEmptyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errEmptyEmail;

  /// No description provided for @errInvalidLogin.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid username or email address'**
  String get errInvalidLogin;

  /// No description provided for @errInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get errInvalidEmail;

  /// No description provided for @reqNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'No spaces allowed'**
  String get reqNoSpaces;

  /// No description provided for @reqAtSymbol.
  ///
  /// In en, this message translates to:
  /// **'Contains @ symbol'**
  String get reqAtSymbol;

  /// No description provided for @reqValidDomain.
  ///
  /// In en, this message translates to:
  /// **'Valid domain (e.g., example.com)'**
  String get reqValidDomain;

  /// No description provided for @reqValidFormat.
  ///
  /// In en, this message translates to:
  /// **'Valid email format'**
  String get reqValidFormat;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @resetIt.
  ///
  /// In en, this message translates to:
  /// **'Reset it'**
  String get resetIt;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @notAMember.
  ///
  /// In en, this message translates to:
  /// **'Not A Member?'**
  String get notAMember;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @errPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errPasswordsDoNotMatch;

  /// No description provided for @errConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get errConfirmPassword;

  /// No description provided for @errPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errPasswordRequired;

  /// No description provided for @errPasswordComplexity.
  ///
  /// In en, this message translates to:
  /// **'Must include upper, lower, number & symbol'**
  String get errPasswordComplexity;

  /// No description provided for @reqMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get reqMinLength;

  /// No description provided for @reqUppercase.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get reqUppercase;

  /// No description provided for @reqLowercase.
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter'**
  String get reqLowercase;

  /// No description provided for @reqNumber.
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get reqNumber;

  /// No description provided for @reqSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'One special character (!@#\$*~)'**
  String get reqSpecialChar;

  /// No description provided for @labelUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get labelUsername;

  /// No description provided for @hintUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get hintUsername;

  /// No description provided for @errUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get errUsernameRequired;

  /// No description provided for @errUsernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get errUsernameTooShort;

  /// No description provided for @errUsernameChars.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, and underscores are allowed'**
  String get errUsernameChars;

  /// No description provided for @reqUsernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 3 characters'**
  String get reqUsernameMinLength;

  /// No description provided for @reqUsernameChars.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, and underscores'**
  String get reqUsernameChars;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
