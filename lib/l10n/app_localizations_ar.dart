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
    return 'أهلاً بك يا $username! تم إنشاء حسابك بنجاح';
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
      'لا تقلق! يحدث هذا دائماً. يرجى إدخال البريد الإلكتروني المرتبط بحسابك';

  @override
  String get resendCodeTitle => 'إعادة إرسال رمز التحقق';

  @override
  String get resendCodeDesc =>
      'يرجى إعادة إدخال بريدك الإلكتروني. سنرسل لك رمزاً جديداً لتفعيل حسابك';

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

  @override
  String get postDeletedSuccess => 'تم حذف المنشور بنجاح';

  @override
  String get homeTitle => 'تريفيو';

  @override
  String get loadMore => 'جاري تحميل المزيد...';

  @override
  String get refreshSuccess => 'تم تحديث المنشورات';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get showLess => 'عرض أقل';

  @override
  String get defaultGroupName => 'اسم المجموعة';

  @override
  String get shareAction => 'نشر';

  @override
  String get shareHint => 'اكتب شيئاً عن هذا المنشور...';

  @override
  String get shareSuccess => 'تمت المشاركة بنجاح!';

  @override
  String get errEmptyShare => 'اكتب شيئاً أولاً!';

  @override
  String get defaultUserName => 'اسم المستخدم';

  @override
  String get reactionGoal => 'هدف';

  @override
  String get reactionOffside => 'تسلل';

  @override
  String get skeletonLoadingText =>
      'جاري تحميل المحتوى للمنشورات.\nسطر إضافي لتحسين المظهر';

  @override
  String get errNoPosts => 'لا توجد منشورات في الجدول الزمني الخاص بك';

  @override
  String get reportPostSuccess => 'تم الإبلاغ عن المنشور بنجاح';

  @override
  String get follow => 'متابعة';

  @override
  String get following => 'متابع';

  @override
  String get save => 'حفظ';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get copyLink => 'نسخ الرابط';

  @override
  String get noLink => 'لا يوجد رابط';

  @override
  String get notInterested => 'غير مهتم';

  @override
  String get report => 'إبلاغ';

  @override
  String get delete => 'حذف';

  @override
  String get deletePostTitle => 'حذف المنشور';

  @override
  String get deletePostConfirm => 'هل أنت متأكد من رغبتك في حذف هذا المنشور؟';

  @override
  String get reportQuestion => 'لماذا تبلغ عن هذا المنشور؟';

  @override
  String get reportDisclaimer =>
      'تساعدنا ملاحظاتك في الحفاظ على أمان مجتمع كرة القدم.';

  @override
  String get reportReasonSpam => 'محتوى غير مرغوب فيه';

  @override
  String get reportReasonToxic => 'سلوك مسيء أو سام';

  @override
  String get reportReasonFalse => 'معلومات كاذبة أو مضللة';

  @override
  String get reportReasonAds => 'ترويج / إعلانات غير مسموح بها';

  @override
  String get reportReasonOther => 'سبب آخر';

  @override
  String get commentsTitle => 'التعليقات';

  @override
  String get noCommentsYet => 'لا توجد تعليقات بعد';

  @override
  String get addCommentHint => 'أضف تعليقاً...';

  @override
  String replyingTo(String userName) {
    return 'الرد على $userName';
  }

  @override
  String get reply => 'رد';

  @override
  String get privacyPublic => 'عام';

  @override
  String get privacyPrivate => 'خاص';

  @override
  String get addPostHint => 'بماذا تفكر؟';

  @override
  String get image => 'صورة';

  @override
  String get video => 'فيديو';

  @override
  String get back => 'رجوع';

  @override
  String get createNewPost => 'إنشاء منشور جديد';

  @override
  String get postAction => 'نشر';

  @override
  String get postCreatedSuccess => 'تم إنشاء المنشور بنجاح!';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get useCamera => 'استخدام الكاميرا';

  @override
  String get copyComment => 'نسخ التعليق';

  @override
  String get viewEditHistory => 'عرض سجل التعديلات';

  @override
  String get reportComment => 'الإبلاغ عن التعليق';

  @override
  String get hideComment => 'إخفاء التعليق';

  @override
  String get edit => 'تعديل';

  @override
  String get menu => 'القائمة';

  @override
  String get darkMode => 'الوضع المظلم';

  @override
  String get on => 'تفعيل';

  @override
  String get off => 'إيقاف';

  @override
  String get systemDefault => 'تلقائي حسب النظام';

  @override
  String get groups => 'المجموعات';

  @override
  String get posts => 'المنشورات';

  @override
  String get reels => 'المقاطع';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get theme => 'المظهر';

  @override
  String get blocked => 'المحظورين';

  @override
  String get activeStatus => 'حالة النشاط';

  @override
  String get messages => 'الرسائل';

  @override
  String get searchChatsHint => 'البحث في المحادثات...';

  @override
  String get mute => 'كتم';

  @override
  String get muteChatTitle => 'كتم الدردشة';

  @override
  String get muteChatConfirm => 'هل أنت متأكد من رغبتك في كتم هذه الدردشة؟';

  @override
  String get deleteChatTitle => 'حذف الدردشة';

  @override
  String get deleteChatConfirm => 'هل أنت متأكد من رغبتك في حذف هذه الدردشة؟';

  @override
  String get album => 'الألبوم';

  @override
  String get location => 'الموقع';

  @override
  String get files => 'الملفات';

  @override
  String get copy => 'نسخ';

  @override
  String get deleteMessageConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذه الرسالة؟';

  @override
  String get messageHint => 'رسالة';

  @override
  String get calling => 'جاري الاتصال...';

  @override
  String get videoCalling => 'مكالمة فيديو...';

  @override
  String get callAction => 'اتصال';

  @override
  String callUser(Object userName) {
    return 'اتصال بـ \"$userName\"';
  }

  @override
  String videoCallUser(Object userName) {
    return 'مكالمة فيديو بـ \"$userName\"';
  }

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get options => 'خيارات';

  @override
  String get createGroupChat => 'إنشاء دردشة جماعية';

  @override
  String get block => 'حظر';

  @override
  String get blockUserTitle => 'حظر المستخدم';

  @override
  String get blockUserConfirm => 'هل أنت متأكد من رغبتك في حظر هذا المستخدم؟';

  @override
  String get cancelBtn => 'الغاء';

  @override
  String get followers => 'المتابعين';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get shareProfile => 'مشاركة الملف الشخصي';

  @override
  String get followRequests => 'طلبات المتابعة';

  @override
  String get noFollowRequests => 'لا يوجد طلبات متابعة حالياً';

  @override
  String get noFollowersYet => 'لا يوجد متابعين حالياً';

  @override
  String get noFollowingYet => 'لا تتابع أحداً';

  @override
  String get profileSettings => 'إعدادات الملف الشخصي';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get accountSettingsSub => 'إدارة تفاصيل حسابك وتفضيلاتك.';

  @override
  String get privacySettings => 'إعدادات الخصوصية';

  @override
  String get privacySettingsSub => 'التحكم في من يرى منشوراتك ونشاطك.';

  @override
  String get notificationPrefs => 'تفضيلات الإشعارات';

  @override
  String get notificationPrefsSub => 'تخصيص تنبيهات الإشعارات الخاصة بك.';

  @override
  String get appPrefs => 'تفضيلات التطبيق';

  @override
  String get appPrefsSub => 'ضبط اللغة، المظهر، واستهلاك البيانات.';

  @override
  String get requireFollow => 'طلب الموافقة على المتابعة';

  @override
  String get requireFollowSub => 'الموافقة على المتابعين يدوياً.';

  @override
  String get searchableProfile => 'ملف شخصي قابل للبحث';

  @override
  String get searchableProfileSub =>
      'السماح لملفك الشخصي بالظهور في نتائج البحث.';
}
