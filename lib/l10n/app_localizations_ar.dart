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
  String registrationSuccess(String username) {
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
      'تساعدنا ملاحظاتك في الحفاظ على أمان مجتمع كرة القدم';

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
  String get cancelBtn => 'إلغاء';

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
  String get accountSettingsSub => 'إدارة تفاصيل حسابك وتفضيلاتك';

  @override
  String get privacySettings => 'إعدادات الخصوصية';

  @override
  String get privacySettingsSub => 'التحكم في من يرى منشوراتك ونشاطك';

  @override
  String get notificationPrefs => 'تفضيلات الإشعارات';

  @override
  String get notificationPrefsSub => 'تخصيص تنبيهات الإشعارات الخاصة بك';

  @override
  String get appPrefs => 'تفضيلات التطبيق';

  @override
  String get appPrefsSub => 'ضبط اللغة، المظهر، واستهلاك البيانات';

  @override
  String get requireFollow => 'طلب الموافقة على المتابعة';

  @override
  String get requireFollowSub => 'الموافقة على المتابعين يدوياً';

  @override
  String get searchableProfile => 'ملف شخصي قابل للبحث';

  @override
  String get searchableProfileSub =>
      'السماح لملفك الشخصي بالظهور في نتائج البحث';

  @override
  String get search => 'بحث';

  @override
  String get yourGroups => 'مجموعاتك';

  @override
  String get suggestedGroups => 'مجموعات مقترحة';

  @override
  String get fromYourGroups => 'من مجموعاتك';

  @override
  String get suggestedForYou => 'مقترح لك';

  @override
  String get noJoinedGroupsYet => 'لم تنضم إلى أي مجموعات بعد. استكشف الآن!';

  @override
  String get forYou => 'لك';

  @override
  String get joined => 'المنضمة';

  @override
  String get discover => 'استكشف';

  @override
  String get myGroups => 'مجموعاتي';

  @override
  String get members => 'عضو';

  @override
  String get remove => 'إزالة';

  @override
  String get noPostsInGroups =>
      'لا توجد منشورات في مجموعاتك بعد. انضم إلى بعض المجموعات!';

  @override
  String get updateSuccessful => 'تم التحديث بنجاح';

  @override
  String get manage => 'إدارة';

  @override
  String get mostRelevant => 'الأكثر صلة';

  @override
  String get about => 'حول المجموعة';

  @override
  String get editDescription => 'تعديل الوصف';

  @override
  String get home => 'الرئيسية';

  @override
  String get writeSomething => 'اكتب شيئاً...';

  @override
  String get reportedPosts => 'المنشورات المبلّغ عنها';

  @override
  String get pendingPosts => 'منشورات في انتظار المراجعة';

  @override
  String get approve => 'موافقة';

  @override
  String get decline => 'رفض';

  @override
  String get noModeratorsFound => 'لم يتم العثور على مشرفين';

  @override
  String get moderator => 'مشرف';

  @override
  String get membersRequests => 'طلبات الأعضاء';

  @override
  String get requestAcceptedSuccess => 'تم قبول الطلب بنجاح';

  @override
  String get requestDeclinedSuccess => 'تم رفض الطلب بنجاح';

  @override
  String get noPendingRequests => 'لا توجد طلبات معلقة';

  @override
  String get accepted => 'تم القبول';

  @override
  String get declined => 'تم الرفض';

  @override
  String get acceptMemberTitle => 'قبول هذا العضو؟';

  @override
  String acceptMemberContent(String userName) {
    return 'هل تريد إضافة $userName إلى المجموعة؟';
  }

  @override
  String get declineRequestTitle => 'رفض الطلب؟';

  @override
  String get declineRequestContent => 'هل أنت متأكد أنك تريد رفض هذا الطلب؟';

  @override
  String get noMembersFound => 'لم يتم العثور على أعضاء';

  @override
  String get member => 'عضو';

  @override
  String get manageGroup => 'إدارة المجموعة';

  @override
  String get groupDeletedSuccess => 'تم حذف المجموعة بنجاح';

  @override
  String get review => 'مراجعة';

  @override
  String get communityAndPeople => 'المجتمع والأشخاص';

  @override
  String get people => 'الأشخاص';

  @override
  String get bannedMembers => 'الأعضاء المحظورون';

  @override
  String get shareGroup => 'مشاركة المجموعة';

  @override
  String get linkCopied => 'تم نسخ الرابط إلى الحافظة';

  @override
  String get leaveGroup => 'مغادرة المجموعة';

  @override
  String get leaveGroupTitle => 'مغادرة المجموعة؟';

  @override
  String get leaveGroupContent => 'هل أنت متأكد أنك تريد مغادرة هذه المجموعة؟';

  @override
  String get leave => 'مغادرة';

  @override
  String get deleteGroup => 'حذف المجموعة';

  @override
  String get deleteGroupTitle => 'حذف المجموعة؟';

  @override
  String get deleteGroupContent => 'هل أنت متأكد أنك تريد حذف هذه المجموعة؟';

  @override
  String get noBannedMembersFound => 'لم يتم العثور على أعضاء محظورين';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get unban => 'إلغاء الحظر';

  @override
  String get unbanUserTitle => 'إلغاء حظر المستخدم';

  @override
  String get unbanUserContent =>
      'هل أنت متأكد أنك تريد إلغاء حظر هذا المستخدم؟';

  @override
  String get noAdminsFound => 'لم يتم العثور على مسؤولين';

  @override
  String get admin => 'مسؤول';

  @override
  String get manageMember => 'إدارة العضو';

  @override
  String get kick => 'طرد';

  @override
  String get ban => 'حظر';

  @override
  String get changeRole => 'تغيير الرتبة';

  @override
  String kickUserTitle(String name) {
    return 'طرد $name';
  }

  @override
  String kickUserContent(String name) {
    return 'هل أنت متأكد أنك تريد طرد $name؟';
  }

  @override
  String banUserTitle(String name) {
    return 'حظر $name';
  }

  @override
  String banUserContent(String name) {
    return 'هل أنت متأكد أنك تريد حظر $name؟';
  }

  @override
  String get moderators => 'المشرفون';

  @override
  String get admins => 'المسؤولون';

  @override
  String get privateGroupDescription =>
      'يمكن للأعضاء فقط رؤية من في المجموعة وما ينشرونه.';

  @override
  String get join => 'انضمام';

  @override
  String get requested => 'تم إرسال الطلب';

  @override
  String get cancelJoinRequest => 'إلغاء طلب الانضمام';

  @override
  String get cancelJoinRequestContent =>
      'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟';

  @override
  String get cancelRequest => 'إلغاء الطلب';

  @override
  String get reportGroup => 'إبلاغ عن المجموعة';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get createGroup => 'إنشاء مجموعة';

  @override
  String get name => 'الاسم';

  @override
  String get nameYourGroup => 'قم بتسمية مجموعتك';

  @override
  String get description => 'الوصف';

  @override
  String get tellPeopleAboutGroup => 'أخبر الأشخاص عن موضوع هذه المجموعة';

  @override
  String get next => 'التالي';

  @override
  String get close => 'إغلاق';

  @override
  String get groupCreatedSuccess => 'تم إنشاء المجموعة بنجاح!';

  @override
  String get addCoverPhoto => 'أضف صورة غلاف';

  @override
  String get addCoverPhotoSub =>
      'اجعل مجموعتك ملحوظة بصورة تساعد في إظهار ما تدور حوله مجموعتك.';

  @override
  String get creating => 'جارٍ الإنشاء...';

  @override
  String get getSeeAll => 'إظهار الكل';

  @override
  String get errorPickingMedia => 'خطأ أثناء اختيار الوسائط';

  @override
  String get accept => 'موافق';

  @override
  String get unknownUser => 'مستخدم مجهول';

  @override
  String get noPostsAvailable =>
      'لا توجد منشورات متاحة حالياً. كن أول من ينشر!';

  @override
  String get nameRequiredError => 'يرجى كتابة اسم المجموعة';

  @override
  String get googleSignInCancelled => 'تم إلغاء تسجيل الدخول بـ Google';

  @override
  String get googleSignInFailed => 'فشل تسجيل الدخول بـ Google. حاول مرة أخرى.';

  @override
  String get networkError => 'يرجى التحقق من اتصال الإنترنت الخاص بك.';

  @override
  String get failedToLoadData => 'فشل تحميل البيانات. يرجى التحقق من الاتصال.';

  @override
  String get matches => 'المباريات';

  @override
  String get noMatchesFound => 'لا توجد مباريات';

  @override
  String get errInvalidCode => 'يرجى إدخال جميع الأرقام الستة';

  @override
  String get copied => 'تم النسخ الى الحافظة';

  @override
  String get justNow => 'الآن';

  @override
  String get minuteLetter => 'د';

  @override
  String get hourLetter => 'س';

  @override
  String get dayLetter => 'ي';

  @override
  String get weekLetter => 'أ';

  @override
  String get trivio => 'Trivio';

  @override
  String get noMorePosts => 'لا يوجد المزيد من المنشورات لعرضها';

  @override
  String get noMoreGroups => 'لا يوجد المزيد من المجموعات';

  @override
  String get noGroupsFound => 'لم يتم العثور على مجموعات.';

  @override
  String get searchGroupsHint => 'ابحث عن مجموعات...';

  @override
  String get whatsOnYourMind => 'بماذا تفكر؟';

  @override
  String get noMoreMembers => 'لا يوجد المزيد من الأعضاء';
  String get favTeamsTitle => 'فرقك المفضلة';

  @override
  String get favTeamsDesc => 'اختر فرقك المفضلة للحصول على توصيات أفضل';

  @override
  String get favPlayersTitle => 'لاعبوك المفضلون';

  @override
  String get favPlayersDesc => 'اختر لاعبيك المفضلين للحصول على توصيات أفضل';

  @override
  String get noTeamsFound => 'لم يتم العثور على فرق';

  @override
  String get noPlayersFound => 'لم يتم العثور على لاعبين';

  @override
  String get skip => 'تخطي';

  @override
  String get finish => 'إنهاء';

  @override
  String get update => 'تحديث';

  @override
  String get settingsFavTeamsTitle => 'الفرق المفضلة';

  @override
  String get settingsFavTeamsSub => 'تغيير فرقك المفضلة';

  @override
  String get settingsFavPlayersTitle => 'اللاعبين المفضلين';

  @override
  String get settingsFavPlayersSub => 'تغيير لاعبيك المفضلين';
}
