class AppRoutes {
  // Auth routes
  static const String signIn = '/signin';
  static const String register = '/register';
  static const String verifyCode = '/verify';
  static const String requsetResetPassword = '/forget_password_email';
  static const String changeEmailVerification = '/change_email_verification';
  static const String changeEmailOTP = '/change_email_otp';
  static const String forgetPasswordOtp = '/forget-password-otp';
  // App routes
  static const String home = '/app/home';
  static const String reels = '/app/reels';
  static const String chatbot = '/app/chatbot';
  static const String stats = '/app/stats';
  static const String profile = '/app/profile';

  static const String settings = '/app/settings';
  static const String notifications = '/app/settings/notifications';
  static const String theme = '/app/settings/theme';
  static const String blocked = '/app/settings/blocked';
  static const String activeStates = '/app/settings/active_states';
  static const String saved = '/app/settings/saved';
  static const String search = '/app/search';
  
  // edit post cartion
  static const String editCaption = '/app/home/edit';

// groups
  static const String groups = '/app/settings/groups';
  static const String groupPreview = '/app/settings/groups/group_preview';
  static const String groupFeed = '/app/settings/groups/group_feed';
  static const String createGroup = '/app/settings/groups/create_group';
  static const String addCoverPhoto = '/app/settings/groups/create_group/add_cover_photo';
  static const String myGroup = '/app/settings/groups/my_group';
  static const String manageGroup = '/app/settings/groups/my_group/manage_group';

  static const String groupMembersRequests = '/app/settings/groups/my_group/manage_group/members_requests';
  static const String groupPendingPosts = '/app/settings/groups/my_group/manage_group/pending_posts';
  static const String groupReportedPosts = '/app/settings/groups/my_group/manage_group/reported_posts';

  static const String groupMembers = '/app/settings/groups/my_group/manage_group/members';
  static const String bannedMembers = '/app/settings/groups/my_group/manage_group/banned_members';



// chats
  static const String messages = '/app/messages';
  static const String chat = '/app/messages/chat';
  static const String chatInfo = '/app/messages/chat/chat_info';

  //profile
  static const String profileSettings = '/app/profile/settings';
  static const String requests = '/app/profile/settings/requests';
  static const String followerInfo = '/app/profile/follow_info';
  static const String editProfile = '/app/profile/settings/edit';
  static const String changePassword = '/app/profile/settings/change_password';
  static const String likedPosts = '/app/profile/settings/liked_posts';
}