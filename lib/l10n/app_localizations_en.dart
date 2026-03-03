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
  String registrationSuccess(String username) {
    return 'Welcome, $username! Your account has been created';
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
      'Don\'t worry! It happens. Please enter the email address associated with your account';

  @override
  String get resendCodeTitle => 'Resend Verification Code';

  @override
  String get resendCodeDesc =>
      'Please re-enter your email address. We’ll resend a new verification code to help you activate your account';

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
  String get signIn => 'Sign In';

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

  @override
  String get postDeletedSuccess => 'Post deleted successfully';

  @override
  String get homeTitle => 'Trivio Feed';

  @override
  String get loadMore => 'Loading more posts...';

  @override
  String get refreshSuccess => 'Feed updated';

  @override
  String get showMore => 'more';

  @override
  String get showLess => 'less';

  @override
  String get defaultGroupName => 'Group Name';

  @override
  String get shareAction => 'Share';

  @override
  String get shareHint => 'Say something about this post...';

  @override
  String get shareSuccess => 'Post shared successfully!';

  @override
  String get errEmptyShare => 'Write something first!';

  @override
  String get defaultUserName => 'User Name';

  @override
  String get reactionGoal => 'Goal';

  @override
  String get reactionOffside => 'Offside';

  @override
  String get skeletonLoadingText =>
      'Loading content lines for skeleton effect.\nSecond line for better UI';

  @override
  String get errNoPosts => 'No posts found in your timeline';

  @override
  String get reportPostSuccess => 'Post reported successfully';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get noLink => 'No Link';

  @override
  String get notInterested => 'Not Interested';

  @override
  String get report => 'Report';

  @override
  String get delete => 'Delete';

  @override
  String get deletePostTitle => 'Delete Post';

  @override
  String get deletePostConfirm => 'Are you sure you want to delete this post?';

  @override
  String get reportQuestion => 'Why are you reporting this post?';

  @override
  String get reportDisclaimer =>
      'Your feedback helps us keep the football community safe and enjoyable';

  @override
  String get reportReasonSpam => 'Spam or irrelevant content';

  @override
  String get reportReasonToxic => 'Toxic or offensive behavior';

  @override
  String get reportReasonFalse => 'False or misleading information';

  @override
  String get reportReasonAds => 'Promotion / advertising not allowed';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String get addCommentHint => 'Add a comment...';

  @override
  String replyingTo(String userName) {
    return 'Replying to $userName';
  }

  @override
  String get reply => 'Reply';

  @override
  String get privacyPublic => 'Public';

  @override
  String get privacyPrivate => 'Private';

  @override
  String get addPostHint => 'What\'s happening on your mind?';

  @override
  String get image => 'Image';

  @override
  String get video => 'Video';

  @override
  String get back => 'Back';

  @override
  String get createNewPost => 'Create New Post';

  @override
  String get postAction => 'Post';

  @override
  String get postCreatedSuccess => 'Post created successfully!';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get useCamera => 'Use Camera';

  @override
  String get copyComment => 'Copy comment';

  @override
  String get viewEditHistory => 'View Edit History';

  @override
  String get reportComment => 'Report comment';

  @override
  String get hideComment => 'Hide comment';

  @override
  String get edit => 'Edit';

  @override
  String get menu => 'Menu';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get systemDefault => 'System default';

  @override
  String get groups => 'Groups';

  @override
  String get posts => 'Posts';

  @override
  String get reels => 'Reels';

  @override
  String get notifications => 'Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get blocked => 'Blocked';

  @override
  String get activeStatus => 'Active status';

  @override
  String get messages => 'Messages';

  @override
  String get searchChatsHint => 'Search chats...';

  @override
  String get mute => 'Mute';

  @override
  String get muteChatTitle => 'Mute chat';

  @override
  String get muteChatConfirm => 'Are you sure you want to mute this chat?';

  @override
  String get deleteChatTitle => 'Delete Chat';

  @override
  String get deleteChatConfirm => 'Are you sure you want to delete this chat?';

  @override
  String get album => 'Album';

  @override
  String get location => 'Location';

  @override
  String get files => 'Files';

  @override
  String get copy => 'Copy';

  @override
  String get deleteMessageConfirm =>
      'Are you sure you want to delete this message?';

  @override
  String get messageHint => 'Message';

  @override
  String get calling => 'Calling...';

  @override
  String get videoCalling => 'Video Calling...';

  @override
  String get callAction => 'Call';

  @override
  String callUser(Object userName) {
    return 'Call \"$userName\"';
  }

  @override
  String videoCallUser(Object userName) {
    return 'Video Call \"$userName\"';
  }

  @override
  String get profile => 'Profile';

  @override
  String get options => 'Options';

  @override
  String get createGroupChat => 'Create Group Chat';

  @override
  String get block => 'Block';

  @override
  String get blockUserTitle => 'Block User';

  @override
  String get blockUserConfirm => 'Are you sure you want to block this user?';

  @override
  String get cancelBtn => 'Cancel';

  @override
  String get followers => 'Followers';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get shareProfile => 'Share Profile';

  @override
  String get followRequests => 'Follow Requests';

  @override
  String get noFollowRequests => 'No follow requests yet';

  @override
  String get noFollowersYet => 'No followers found';

  @override
  String get noFollowingYet => 'No following found';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get accountSettingsSub =>
      'Manage your account details and preferences';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Control who sees your posts and activity';

  @override
  String get notificationPrefs => 'Notification Preferences';

  @override
  String get notificationPrefsSub => 'Customize your notification alerts';

  @override
  String get appPrefs => 'App Preferences';

  @override
  String get appPrefsSub => 'Adjust language, theme, and data usage';

  @override
  String get requireFollow => 'Require Follow Requests';

  @override
  String get requireFollowSub => 'Manually approve followers';

  @override
  String get searchableProfile => 'Searchable Profile';

  @override
  String get searchableProfileSub =>
      'Allow your profile to appear in search results';

  @override
  String get search => 'Search';

  @override
  String get yourGroups => 'Your groups';

  @override
  String get suggestedGroups => 'Suggested groups';

  @override
  String get fromYourGroups => 'From your groups';

  @override
  String get suggestedForYou => 'Suggested for you';

  @override
  String get noJoinedGroupsYet =>
      'You haven\'t joined any groups yet. Explore now!';

  @override
  String get forYou => 'For you';

  @override
  String get joined => 'Joined';

  @override
  String get discover => 'Discover';

  @override
  String get myGroups => 'My groups';

  @override
  String get members => 'members';

  @override
  String get remove => 'Remove';

  @override
  String get noPostsInGroups => 'No posts in your groups yet. Join some!';

  @override
  String get updateSuccessful => 'Update Successful';

  @override
  String get manage => 'Manage';

  @override
  String get mostRelevant => 'Most relevant';

  @override
  String get about => 'About';

  @override
  String get editDescription => 'Edit description';

  @override
  String get home => 'Home';

  @override
  String get writeSomething => 'Write something...';

  @override
  String get reportedPosts => 'Reported Posts';

  @override
  String get pendingPosts => 'Pending Posts';

  @override
  String get approve => 'Approve';

  @override
  String get decline => 'Decline';

  @override
  String get noModeratorsFound => 'No Moderators found';

  @override
  String get moderator => 'Moderator';

  @override
  String get membersRequests => 'Members Requests';

  @override
  String get requestAcceptedSuccess => 'Request accepted successfully';

  @override
  String get requestDeclinedSuccess => 'Request declined successfully';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get accepted => 'Accepted';

  @override
  String get declined => 'Declined';

  @override
  String get acceptMemberTitle => 'Accept this member?';

  @override
  String acceptMemberContent(String userName) {
    return 'Do you want to add $userName to the group?';
  }

  @override
  String get declineRequestTitle => 'Decline request?';

  @override
  String get declineRequestContent =>
      'Are you sure you want to decline this request?';

  @override
  String get noMembersFound => 'No members found';

  @override
  String get member => 'Member';

  @override
  String get manageGroup => 'Manage group';

  @override
  String get groupDeletedSuccess => 'Group deleted successfully';

  @override
  String get review => 'Review';

  @override
  String get communityAndPeople => 'Community & People';

  @override
  String get people => 'People';

  @override
  String get bannedMembers => 'Banned Members';

  @override
  String get shareGroup => 'Share group';

  @override
  String get linkCopied => 'Link copied to clipboard';

  @override
  String get leaveGroup => 'Leave group';

  @override
  String get leaveGroupTitle => 'Leave group?';

  @override
  String get leaveGroupContent => 'Are you sure you want to leave this group?';

  @override
  String get leave => 'Leave';

  @override
  String get deleteGroup => 'Delete group';

  @override
  String get deleteGroupTitle => 'Delete group?';

  @override
  String get deleteGroupContent =>
      'Are you sure you want to delete this group?';

  @override
  String get noBannedMembersFound => 'No banned members found';

  @override
  String get username => 'Username';

  @override
  String get unban => 'Unban';

  @override
  String get unbanUserTitle => 'Unban user';

  @override
  String get unbanUserContent => 'Are you sure you want to unban this user?';

  @override
  String get noAdminsFound => 'No Admins found';

  @override
  String get admin => 'Admin';

  @override
  String get manageMember => 'Manage Member';

  @override
  String get kick => 'Kick';

  @override
  String get ban => 'Ban';

  @override
  String get changeRole => 'Change Role';

  @override
  String kickUserTitle(String name) {
    return 'Kick $name';
  }

  @override
  String kickUserContent(String name) {
    return 'Are you sure you want to kick $name?';
  }

  @override
  String banUserTitle(String name) {
    return 'Ban $name';
  }

  @override
  String banUserContent(String name) {
    return 'Are you sure you want to ban $name?';
  }

  @override
  String get moderators => 'Moderators';

  @override
  String get admins => 'Admins';

  @override
  String get privateGroupDescription =>
      'Only members can see who\'s in the group and what they post.';

  @override
  String get join => 'Join';

  @override
  String get requested => 'Requested';

  @override
  String get cancelJoinRequest => 'Cancel join request';

  @override
  String get cancelJoinRequestContent =>
      'Are you sure you want to cancel this request?';

  @override
  String get cancelRequest => 'Cancel Request';

  @override
  String get reportGroup => 'Report group';

  @override
  String get loading => 'Loading...';

  @override
  String get createGroup => 'Create group';

  @override
  String get name => 'Name';

  @override
  String get nameYourGroup => 'Name your group';

  @override
  String get description => 'Description';

  @override
  String get tellPeopleAboutGroup => 'Tell people what this group is about';

  @override
  String get next => 'Next';

  @override
  String get close => 'Close';

  @override
  String get groupCreatedSuccess => 'Group Created Successfully!';

  @override
  String get addCoverPhoto => 'Add a cover photo';

  @override
  String get addCoverPhotoSub =>
      'Get noticed with an image that helps show what your group is all about.';

  @override
  String get creating => 'Creating...';

  @override
  String get getSeeAll => 'see all';

  @override
  String get errorPickingMedia => 'Error picking media';

  @override
  String get accept => 'Accept';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get noPostsAvailable =>
      'No posts available yet. Be the first to post!';

  @override
  String get nameRequiredError => 'Please write your group name';

  @override
  String get googleSignInCancelled => 'Google sign-in was cancelled';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Please try again.';

  @override
  String get networkError => 'Please check your internet connection.';

  @override
  String get failedToLoadData =>
      'Failed to load football data. Please check your connection.';

  @override
  String get matches => 'matches';

  @override
  String get noMatchesFound => 'No Matches Found';

  @override
  String get errInvalidCode => 'Please enter all 6 digits';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String get justNow => 'Just now';

  @override
  String get minuteLetter => 'm';

  @override
  String get hourLetter => 'h';

  @override
  String get dayLetter => 'd';

  @override
  String get weekLetter => 'w';

  @override
  String get trivio => 'Trivio';

  @override
  String get noMorePosts => 'No more posts to show';

  @override
  String get noMoreGroups => 'No more groups';

  @override
  String get noGroupsFound => 'No groups found.';

  @override
  String get searchGroupsHint => 'Search groups...';

  @override
  String get whatsOnYourMind => 'What\'s on your mind?';

  @override
  String get noMoreMembers => 'No more members';
}
