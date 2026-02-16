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

  /// No description provided for @postDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get postDeletedSuccess;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Trivio Feed'**
  String get homeTitle;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more posts...'**
  String get loadMore;

  /// No description provided for @refreshSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feed updated'**
  String get refreshSuccess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'less'**
  String get showLess;

  /// No description provided for @defaultGroupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get defaultGroupName;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @shareHint.
  ///
  /// In en, this message translates to:
  /// **'Say something about this post...'**
  String get shareHint;

  /// No description provided for @shareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Post shared successfully!'**
  String get shareSuccess;

  /// No description provided for @errEmptyShare.
  ///
  /// In en, this message translates to:
  /// **'Write something first!'**
  String get errEmptyShare;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get defaultUserName;

  /// No description provided for @reactionGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get reactionGoal;

  /// No description provided for @reactionOffside.
  ///
  /// In en, this message translates to:
  /// **'Offside'**
  String get reactionOffside;

  /// No description provided for @skeletonLoadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading content lines for skeleton effect.\nSecond line for better UI.'**
  String get skeletonLoadingText;

  /// No description provided for @errNoPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts found in your timeline.'**
  String get errNoPosts;

  /// No description provided for @reportPostSuccess.
  ///
  /// In en, this message translates to:
  /// **'Post reported successfully'**
  String get reportPostSuccess;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @noLink.
  ///
  /// In en, this message translates to:
  /// **'No Link'**
  String get noLink;

  /// No description provided for @notInterested.
  ///
  /// In en, this message translates to:
  /// **'Not Interested'**
  String get notInterested;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePostTitle;

  /// No description provided for @deletePostConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post?'**
  String get deletePostConfirm;

  /// No description provided for @reportQuestion.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this post?'**
  String get reportQuestion;

  /// No description provided for @reportDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us keep the football community safe and enjoyable.'**
  String get reportDisclaimer;

  /// No description provided for @reportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or irrelevant content'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonToxic.
  ///
  /// In en, this message translates to:
  /// **'Toxic or offensive behavior'**
  String get reportReasonToxic;

  /// No description provided for @reportReasonFalse.
  ///
  /// In en, this message translates to:
  /// **'False or misleading information'**
  String get reportReasonFalse;

  /// No description provided for @reportReasonAds.
  ///
  /// In en, this message translates to:
  /// **'Promotion / advertising not allowed'**
  String get reportReasonAds;

  /// No description provided for @reportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportReasonOther;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addCommentHint;

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {userName}'**
  String replyingTo(String userName);

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @privacyPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get privacyPublic;

  /// No description provided for @privacyPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privacyPrivate;

  /// No description provided for @addPostHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening on your mind?'**
  String get addPostHint;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @createNewPost.
  ///
  /// In en, this message translates to:
  /// **'Create New Post'**
  String get createNewPost;

  /// No description provided for @postAction.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postAction;

  /// No description provided for @postCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully!'**
  String get postCreatedSuccess;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @useCamera.
  ///
  /// In en, this message translates to:
  /// **'Use Camera'**
  String get useCamera;

  /// No description provided for @copyComment.
  ///
  /// In en, this message translates to:
  /// **'Copy comment'**
  String get copyComment;

  /// No description provided for @viewEditHistory.
  ///
  /// In en, this message translates to:
  /// **'View Edit History'**
  String get viewEditHistory;

  /// No description provided for @reportComment.
  ///
  /// In en, this message translates to:
  /// **'Report comment'**
  String get reportComment;

  /// No description provided for @hideComment.
  ///
  /// In en, this message translates to:
  /// **'Hide comment'**
  String get hideComment;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @reels.
  ///
  /// In en, this message translates to:
  /// **'Reels'**
  String get reels;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active status'**
  String get activeStatus;
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
