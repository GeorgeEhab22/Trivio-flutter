// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get createAccount => 'Create Account';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get reEnterPassword => 'Re-enter your password';

  @override
  String get sendCode => 'Send code';

  @override
  String get sendingCode => 'Sending code...';

  @override
  String registrationSuccess(Object username) {
    return 'Welcome, $username! Your account has been created.';
  }

  @override
  String get verificationSuccess => 'Verification successful!';

  @override
  String get codeResent => 'Verification code sent!';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get enterDigitsSent => 'Enter the 6-digit code sent to';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get verifying => 'Verifying...';

  @override
  String get otpHeader => 'OTP';

  @override
  String get enterOtpSentTo => 'Enter the 6-digit OTP sent to';

  @override
  String get resetting => 'Resetting...';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get otpVerifiedSuccess => 'OTP verified successfully!';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordDesc =>
      'Don\'t worry! It happens. Please enter the email address associated with your account.';

  @override
  String get resendCodeTitle => 'Resend Verification Code';

  @override
  String get resendCodeDesc =>
      'Please re-enter your email address. We’ll resend a new verification code to help you activate your account.';

  @override
  String get sendOtpBtn => 'Send OTP';

  @override
  String get resendBtn => 'Resend Code';

  @override
  String get sending => 'Sending...';

  @override
  String get resending => 'Resending...';

  @override
  String get passwordResetSent => 'Password reset OTP sent successfully!';

  @override
  String get signIn => 'Sign in';

  @override
  String get signingIn => 'Signing In...';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get didNotReceiveCode => 'Didn\'t receive the code? ';

  @override
  String get didNotReceiveOtp => 'Didn\'t receive the OTP? ';

  @override
  String get changeEmail => 'Change email';

  @override
  String canChangeIn(String seconds) {
    return 'Can change in ${seconds}s';
  }

  @override
  String get orDivider => 'Or';

  @override
  String get labelUsernameEmail => 'Username or Email';

  @override
  String get labelEmail => 'Email';

  @override
  String get hintUsernameEmail => 'Enter username or email';

  @override
  String get hintEmail => 'Enter email';

  @override
  String get errEmptyLogin => 'Please enter your username or email';

  @override
  String get errEmptyEmail => 'Please enter your email';

  @override
  String get errInvalidLogin =>
      'Please enter a valid username or email address';

  @override
  String get errInvalidEmail => 'Please enter a valid email address';

  @override
  String get reqNoSpaces => 'No spaces allowed';

  @override
  String get reqAtSymbol => 'Contains @ symbol';

  @override
  String get reqValidDomain => 'Valid domain (e.g., example.com)';

  @override
  String get reqValidFormat => 'Valid email format';

  @override
  String get forgotPasswordQuestion => 'Forgot your password?';

  @override
  String get resetIt => 'Reset it';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get notAMember => 'Not A Member?';

  @override
  String get registerNow => 'Register Now';

  @override
  String get errPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errConfirmPassword => 'Please confirm your password';

  @override
  String get errPasswordRequired => 'Password is required';

  @override
  String get errPasswordComplexity =>
      'Must include upper, lower, number & symbol';

  @override
  String get reqMinLength => 'At least 8 characters';

  @override
  String get reqUppercase => 'One uppercase letter';

  @override
  String get reqLowercase => 'One lowercase letter';

  @override
  String get reqNumber => 'One number';

  @override
  String get reqSpecialChar => 'One special character (!@#\$*~)';

  @override
  String get labelUsername => 'Username';

  @override
  String get hintUsername => 'Enter your username';

  @override
  String get errUsernameRequired => 'Username is required';

  @override
  String get errUsernameTooShort => 'Username must be at least 3 characters';

  @override
  String get errUsernameChars =>
      'Only letters, numbers, and underscores are allowed';

  @override
  String get reqUsernameMinLength => 'At least 3 characters';

  @override
  String get reqUsernameChars => 'Only letters, numbers, and underscores';
}
