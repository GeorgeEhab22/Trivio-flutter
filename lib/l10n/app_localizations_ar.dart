// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get reEnterPassword => 'أعد إدخال كلمة المرور';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get sendingCode => 'جاري إرسال الرمز...';

  @override
  String registrationSuccess(Object username) {
    return 'أهلاً بك يا $username! تم إنشاء حسابك بنجاح.';
  }

  @override
  String get verificationSuccess => 'تم التحقق بنجاح!';

  @override
  String get codeResent => 'تم إعادة إرسال رمز التحقق!';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get enterDigitsSent => 'أدخل الرمز المكون من 6 أرقام المرسل إلى';

  @override
  String get verifyCode => 'تحقق من الرمز';

  @override
  String get verifying => 'جاري التحقق...';

  @override
  String get otpHeader => 'رمز التحقق (OTP)';

  @override
  String get enterOtpSentTo => 'أدخل رمز التحقق المكون من 6 أرقام المرسل إلى';

  @override
  String get resetting => 'جاري إعادة التعيين...';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get otpVerifiedSuccess => 'تم التحقق من رمز التحقق بنجاح!';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordDesc =>
      'لا تقلق! يحدث هذا دائماً. يرجى إدخال البريد الإلكتروني المرتبط بحسابك.';

  @override
  String get resendCodeTitle => 'إعادة إرسال رمز التحقق';

  @override
  String get resendCodeDesc =>
      'يرجى إعادة إدخال بريدك الإلكتروني. سنرسل لك رمزاً جديداً لتفعيل حسابك.';

  @override
  String get sendOtpBtn => 'إرسال الرمز';

  @override
  String get resendBtn => 'إعادة الإرسال';

  @override
  String get sending => 'جاري الإرسال...';

  @override
  String get resending => 'جاري إعادة الإرسال...';

  @override
  String get passwordResetSent => 'تم إرسال رمز إعادة تعيين كلمة المرور بنجاح!';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signingIn => 'جاري الدخول...';

  @override
  String get welcomeBack => 'حمداً لله على سلامتك!';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get didNotReceiveCode => 'لم يصلك الرمز؟ ';

  @override
  String get didNotReceiveOtp => 'لم يصلك رمز التحقق؟ ';

  @override
  String get changeEmail => 'تغيير البريد الإلكتروني';

  @override
  String canChangeIn(String seconds) {
    return 'يمكنك التغيير خلال $seconds ثانية';
  }

  @override
  String get orDivider => 'أو';

  @override
  String get labelUsernameEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get labelEmail => 'البريد الإلكتروني';

  @override
  String get hintUsernameEmail => 'أدخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get hintEmail => 'أدخل البريد الإلكتروني';

  @override
  String get errEmptyLogin => 'يرجى إدخال اسم المستخدم أو البريد الإلكتروني';

  @override
  String get errEmptyEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get errInvalidLogin => 'يرجى إدخال اسم مستخدم أو بريد إلكتروني صحيح';

  @override
  String get errInvalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get reqNoSpaces => 'غير مسموح بالمسافات';

  @override
  String get reqAtSymbol => 'يحتوي على رمز @';

  @override
  String get reqValidDomain => 'نطاق صحيح (مثال: example.com)';

  @override
  String get reqValidFormat => 'تنسيق بريد إلكتروني صحيح';

  @override
  String get forgotPasswordQuestion => 'نسيت كلمة المرور؟';

  @override
  String get resetIt => 'إعادة تعيين';

  @override
  String get signInWithGoogle => 'تسجيل الدخول بواسطة جوجل';

  @override
  String get notAMember => 'لست عضواً؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get errPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get errConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get errPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get errPasswordComplexity =>
      'يجب أن تشمل أحرف كبيرة، صغيرة، أرقام ورموز';

  @override
  String get reqMinLength => '8 أحرف على الأقل';

  @override
  String get reqUppercase => 'حرف واحد كبير على الأقل';

  @override
  String get reqLowercase => 'حرف واحد صغير على الأقل';

  @override
  String get reqNumber => 'رقم واحد على الأقل';

  @override
  String get reqSpecialChar => 'رمز خاص واحد على الأقل (!@#\$*~)';

  @override
  String get labelUsername => 'اسم المستخدم';

  @override
  String get hintUsername => 'أدخل اسم المستخدم';

  @override
  String get errUsernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get errUsernameTooShort => 'يجب أن يكون اسم المستخدم ٣ أحرف على الأقل';

  @override
  String get errUsernameChars => 'مسموح فقط بالأحرف، الأرقام، والشرطة السفلية';

  @override
  String get reqUsernameMinLength => '٣ أحرف على الأقل';

  @override
  String get reqUsernameChars => 'الأحرف، الأرقام، والشرطة السفلية فقط';
}
