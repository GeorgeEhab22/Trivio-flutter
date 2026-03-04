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
  /// **'Welcome, {username}! Your account has been created'**
  String registrationSuccess(String username);

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
  /// **'Don\'t worry! It happens. Please enter the email address associated with your account'**
  String get forgotPasswordDesc;

  /// No description provided for @resendCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Code'**
  String get resendCodeTitle;

  /// No description provided for @resendCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your email address. We’ll resend a new verification code to help you activate your account'**
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
  /// **'Sign In'**
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
  /// **'Loading content lines for skeleton effect.\nSecond line for better UI'**
  String get skeletonLoadingText;

  /// No description provided for @errNoPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts found in your timeline'**
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
  /// **'Your feedback helps us keep the football community safe and enjoyable'**
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

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @searchChatsHint.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChatsHint;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @muteChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Mute chat'**
  String get muteChatTitle;

  /// No description provided for @muteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mute this chat?'**
  String get muteChatConfirm;

  /// No description provided for @deleteChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChatTitle;

  /// No description provided for @deleteChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat?'**
  String get deleteChatConfirm;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @deleteMessageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageConfirm;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageHint;

  /// No description provided for @calling.
  ///
  /// In en, this message translates to:
  /// **'Calling...'**
  String get calling;

  /// No description provided for @videoCalling.
  ///
  /// In en, this message translates to:
  /// **'Video Calling...'**
  String get videoCalling;

  /// No description provided for @callAction.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callAction;

  /// No description provided for @callUser.
  ///
  /// In en, this message translates to:
  /// **'Call \"{userName}\"'**
  String callUser(Object userName);

  /// No description provided for @videoCallUser.
  ///
  /// In en, this message translates to:
  /// **'Video Call \"{userName}\"'**
  String videoCallUser(Object userName);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @createGroupChat.
  ///
  /// In en, this message translates to:
  /// **'Create Group Chat'**
  String get createGroupChat;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blockUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUserTitle;

  /// No description provided for @blockUserConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this user?'**
  String get blockUserConfirm;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get shareProfile;

  /// No description provided for @followRequests.
  ///
  /// In en, this message translates to:
  /// **'Follow Requests'**
  String get followRequests;

  /// No description provided for @noFollowRequests.
  ///
  /// In en, this message translates to:
  /// **'No follow requests yet'**
  String get noFollowRequests;

  /// No description provided for @noFollowersYet.
  ///
  /// In en, this message translates to:
  /// **'No followers found'**
  String get noFollowersYet;

  /// No description provided for @noFollowingYet.
  ///
  /// In en, this message translates to:
  /// **'No following found'**
  String get noFollowingYet;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @accountSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Manage your account details and preferences'**
  String get accountSettingsSub;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @privacySettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Control who sees your posts and activity'**
  String get privacySettingsSub;

  /// No description provided for @notificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPrefs;

  /// No description provided for @notificationPrefsSub.
  ///
  /// In en, this message translates to:
  /// **'Customize your notification alerts'**
  String get notificationPrefsSub;

  /// No description provided for @appPrefs.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPrefs;

  /// No description provided for @appPrefsSub.
  ///
  /// In en, this message translates to:
  /// **'Adjust language, theme, and data usage'**
  String get appPrefsSub;

  /// No description provided for @requireFollow.
  ///
  /// In en, this message translates to:
  /// **'Require Follow Requests'**
  String get requireFollow;

  /// No description provided for @requireFollowSub.
  ///
  /// In en, this message translates to:
  /// **'Manually approve followers'**
  String get requireFollowSub;

  /// No description provided for @searchableProfile.
  ///
  /// In en, this message translates to:
  /// **'Searchable Profile'**
  String get searchableProfile;

  /// No description provided for @searchableProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Allow your profile to appear in search results'**
  String get searchableProfileSub;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @yourGroups.
  ///
  /// In en, this message translates to:
  /// **'Your groups'**
  String get yourGroups;

  /// No description provided for @suggestedGroups.
  ///
  /// In en, this message translates to:
  /// **'Suggested groups'**
  String get suggestedGroups;

  /// No description provided for @fromYourGroups.
  ///
  /// In en, this message translates to:
  /// **'From your groups'**
  String get fromYourGroups;

  /// No description provided for @suggestedForYou.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get suggestedForYou;

  /// No description provided for @noJoinedGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined any groups yet. Explore now!'**
  String get noJoinedGroupsYet;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get forYou;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @myGroups.
  ///
  /// In en, this message translates to:
  /// **'My groups'**
  String get myGroups;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noPostsInGroups.
  ///
  /// In en, this message translates to:
  /// **'No posts in your groups yet. Join some!'**
  String get noPostsInGroups;

  /// No description provided for @updateSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Update Successful'**
  String get updateSuccessful;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @mostRelevant.
  ///
  /// In en, this message translates to:
  /// **'Most relevant'**
  String get mostRelevant;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @editDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit description'**
  String get editDescription;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Write something...'**
  String get writeSomething;

  /// No description provided for @reportedPosts.
  ///
  /// In en, this message translates to:
  /// **'Reported Posts'**
  String get reportedPosts;

  /// No description provided for @pendingPosts.
  ///
  /// In en, this message translates to:
  /// **'Pending Posts'**
  String get pendingPosts;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @noModeratorsFound.
  ///
  /// In en, this message translates to:
  /// **'No Moderators found'**
  String get noModeratorsFound;

  /// No description provided for @moderator.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get moderator;

  /// No description provided for @membersRequests.
  ///
  /// In en, this message translates to:
  /// **'Members Requests'**
  String get membersRequests;

  /// No description provided for @requestAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request accepted successfully'**
  String get requestAcceptedSuccess;

  /// No description provided for @requestDeclinedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request declined successfully'**
  String get requestDeclinedSuccess;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @acceptMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept this member?'**
  String get acceptMemberTitle;

  /// No description provided for @acceptMemberContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add {userName} to the group?'**
  String acceptMemberContent(String userName);

  /// No description provided for @declineRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline request?'**
  String get declineRequestTitle;

  /// No description provided for @declineRequestContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this request?'**
  String get declineRequestContent;

  /// No description provided for @noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFound;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @manageGroup.
  ///
  /// In en, this message translates to:
  /// **'Manage group'**
  String get manageGroup;

  /// No description provided for @groupDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group deleted successfully'**
  String get groupDeletedSuccess;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @communityAndPeople.
  ///
  /// In en, this message translates to:
  /// **'Community & People'**
  String get communityAndPeople;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @bannedMembers.
  ///
  /// In en, this message translates to:
  /// **'Banned Members'**
  String get bannedMembers;

  /// No description provided for @shareGroup.
  ///
  /// In en, this message translates to:
  /// **'Share group'**
  String get shareGroup;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopied;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get leaveGroup;

  /// No description provided for @leaveGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave group?'**
  String get leaveGroupTitle;

  /// No description provided for @leaveGroupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this group?'**
  String get leaveGroupContent;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get deleteGroup;

  /// No description provided for @deleteGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete group?'**
  String get deleteGroupTitle;

  /// No description provided for @deleteGroupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group?'**
  String get deleteGroupContent;

  /// No description provided for @noBannedMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No banned members found'**
  String get noBannedMembersFound;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @unban.
  ///
  /// In en, this message translates to:
  /// **'Unban'**
  String get unban;

  /// No description provided for @unbanUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Unban user'**
  String get unbanUserTitle;

  /// No description provided for @unbanUserContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unban this user?'**
  String get unbanUserContent;

  /// No description provided for @noAdminsFound.
  ///
  /// In en, this message translates to:
  /// **'No Admins found'**
  String get noAdminsFound;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @manageMember.
  ///
  /// In en, this message translates to:
  /// **'Manage Member'**
  String get manageMember;

  /// No description provided for @kick.
  ///
  /// In en, this message translates to:
  /// **'Kick'**
  String get kick;

  /// No description provided for @ban.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get ban;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get changeRole;

  /// No description provided for @kickUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Kick {name}'**
  String kickUserTitle(String name);

  /// No description provided for @kickUserContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to kick {name}?'**
  String kickUserContent(String name);

  /// No description provided for @banUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Ban {name}'**
  String banUserTitle(String name);

  /// No description provided for @banUserContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to ban {name}?'**
  String banUserContent(String name);

  /// No description provided for @moderators.
  ///
  /// In en, this message translates to:
  /// **'Moderators'**
  String get moderators;

  /// No description provided for @admins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get admins;

  /// No description provided for @privateGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Only members can see who\'s in the group and what they post.'**
  String get privateGroupDescription;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @cancelJoinRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel join request'**
  String get cancelJoinRequest;

  /// No description provided for @cancelJoinRequestContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this request?'**
  String get cancelJoinRequestContent;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @reportGroup.
  ///
  /// In en, this message translates to:
  /// **'Report group'**
  String get reportGroup;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get createGroup;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameYourGroup.
  ///
  /// In en, this message translates to:
  /// **'Name your group'**
  String get nameYourGroup;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @tellPeopleAboutGroup.
  ///
  /// In en, this message translates to:
  /// **'Tell people what this group is about'**
  String get tellPeopleAboutGroup;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @groupCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group Created Successfully!'**
  String get groupCreatedSuccess;

  /// No description provided for @addCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a cover photo'**
  String get addCoverPhoto;

  /// No description provided for @addCoverPhotoSub.
  ///
  /// In en, this message translates to:
  /// **'Get noticed with an image that helps show what your group is all about.'**
  String get addCoverPhotoSub;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @getSeeAll.
  ///
  /// In en, this message translates to:
  /// **'see all'**
  String get getSeeAll;

  /// No description provided for @errorPickingMedia.
  ///
  /// In en, this message translates to:
  /// **'Error picking media'**
  String get errorPickingMedia;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @noPostsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No posts available yet. Be the first to post!'**
  String get noPostsAvailable;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please write your group name'**
  String get nameRequiredError;

  /// No description provided for @googleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was cancelled'**
  String get googleSignInCancelled;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get networkError;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load football data. Please check your connection.'**
  String get failedToLoadData;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'matches'**
  String get matches;

  /// No description provided for @noMatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No Matches Found'**
  String get noMatchesFound;

  /// No description provided for @errInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits'**
  String get errInvalidCode;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minuteLetter.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minuteLetter;

  /// No description provided for @hourLetter.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hourLetter;

  /// No description provided for @dayLetter.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get dayLetter;

  /// No description provided for @weekLetter.
  ///
  /// In en, this message translates to:
  /// **'w'**
  String get weekLetter;

  /// No description provided for @trivio.
  ///
  /// In en, this message translates to:
  /// **'Trivio'**
  String get trivio;

  /// No description provided for @noMorePosts.
  ///
  /// In en, this message translates to:
  /// **'No more posts to show'**
  String get noMorePosts;

  /// No description provided for @noMoreGroups.
  ///
  /// In en, this message translates to:
  /// **'No more groups'**
  String get noMoreGroups;

  /// No description provided for @noGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'No groups found.'**
  String get noGroupsFound;

  /// No description provided for @searchGroupsHint.
  ///
  /// In en, this message translates to:
  /// **'Search groups...'**
  String get searchGroupsHint;

  /// No description provided for @whatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnYourMind;

  /// No description provided for @noMoreMembers.
  ///
  /// In en, this message translates to:
  /// **'No more members'**
  String get noMoreMembers;
  /// No description provided for @favTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your favourite teams'**
  String get favTeamsTitle;

  /// No description provided for @favTeamsDesc.
  ///
  /// In en, this message translates to:
  /// **'Select your interested teams to get better recommendations'**
  String get favTeamsDesc;

  /// No description provided for @favPlayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Your favourite players'**
  String get favPlayersTitle;

  /// No description provided for @favPlayersDesc.
  ///
  /// In en, this message translates to:
  /// **'Select your interested players to get better recommendations'**
  String get favPlayersDesc;

  /// No description provided for @noTeamsFound.
  ///
  /// In en, this message translates to:
  /// **'No teams found'**
  String get noTeamsFound;

  /// No description provided for @noPlayersFound.
  ///
  /// In en, this message translates to:
  /// **'No players found'**
  String get noPlayersFound;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @settingsFavTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Favourite teams'**
  String get settingsFavTeamsTitle;

  /// No description provided for @settingsFavTeamsSub.
  ///
  /// In en, this message translates to:
  /// **'Change your favourite teams'**
  String get settingsFavTeamsSub;

  /// No description provided for @settingsFavPlayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Favourite players'**
  String get settingsFavPlayersTitle;

  /// No description provided for @settingsFavPlayersSub.
  ///
  /// In en, this message translates to:
  /// **'Change your favourite players'**
  String get settingsFavPlayersSub;
  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @accountSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettingsTitle;

  /// No description provided for @accountSettingsSubSettings.
  ///
  /// In en, this message translates to:
  /// **'Manage your account details and preferences.'**
  String get accountSettingsSubSettings;

  /// No description provided for @likedPosts.
  ///
  /// In en, this message translates to:
  /// **'Liked Posts'**
  String get likedPosts;

  /// No description provided for @likedPostsSub.
  ///
  /// In en, this message translates to:
  /// **'View and manage the posts you\'ve liked.'**
  String get likedPostsSub;

  /// No description provided for @privacySettingsSubSettings.
  ///
  /// In en, this message translates to:
  /// **'Control who sees your posts and activity.'**
  String get privacySettingsSubSettings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Update your security credentials.'**
  String get changePasswordSub;

  /// No description provided for @requireFollowRequests.
  ///
  /// In en, this message translates to:
  /// **'Require Follow Requests'**
  String get requireFollowRequests;

  /// No description provided for @requireFollowRequestsSub.
  ///
  /// In en, this message translates to:
  /// **'Manually approve followers'**
  String get requireFollowRequestsSub;

  /// No description provided for @searchableProfileToggle.
  ///
  /// In en, this message translates to:
  /// **'Searchable Profile'**
  String get searchableProfileToggle;

  /// No description provided for @followInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow Info'**
  String get followInfoTitle;

  /// No description provided for @followersTab.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followersTab;

  /// No description provided for @followingTab.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingTab;

  /// No description provided for @requestsTab.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsTab;

  /// No description provided for @suggestionsTab.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestionsTab;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUsersFound;

  /// No description provided for @noPendingRequestsSimple.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequestsSimple;

  /// No description provided for @noLikedPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No liked posts yet.'**
  String get noLikedPostsYet;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @reEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reEnterNewPassword;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password Updated!'**
  String get passwordUpdated;

  /// No description provided for @saveNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Save New Password'**
  String get saveNewPassword;

  /// No description provided for @noUsersDefault.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get noUsersDefault;
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
