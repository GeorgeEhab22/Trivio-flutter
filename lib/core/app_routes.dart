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

  static const String settings = '/settings';
  static const String notifications = '/settings/notifications';
  static const String theme = '/settings/theme';
  static const String blocked = '/settings/blocked';
  static const String activeStates = 'settings/active_states';
  static const String saved = '/settings/saved';
  static const String search = '/search';
  
  // edit post cartion
  static const String editCaption = '/app/home/edit';

// groups
  static const String groups = '/settings/groups';
  static const String groupPreview = '/settings/groups/group_preview';
  static const String groupFeed = '/settings/groups/group_feed';
  static const String createGroup = '/settings/groups/create_group';
  static const String addCoverPhoto = '/settings/groups/create_group/add_cover_photo';
  static const String myGroup = '/settings/groups/my_group';
  static const String manageGroup = '/settings/groups/my_group/manage_group';

  static const String groupMembersRequests = '/settings/groups/my_group/manage_group/members_requests';
  static const String groupPendingPosts = '/settings/groups/my_group/manage_group/pending_posts';
  static const String groupReportedPosts = '/settings/groups/my_group/manage_group/reported_posts';

  static const String groupMembers = '/settings/groups/my_group/manage_group/members';
  static const String bannedMembers = '/settings/groups/my_group/manage_group/banned_members';



// chats
  static const String messages = '/messages';
  static const String chat = '/messages/chat';
  static const String chatInfo = '/messages/chat/chat_info';

  //profile
  static const String profileSettings = '/app/profile/settings';
  static const String requests = '/app/profile/settings/requests';
  static const String followersList = '/app/profile/followers';
  static const String followingList = '/app/profile/following';

  // interests
  static const String selectTeams = '/select-teams';
  static const String selectPlayers = '/select-teams/select-players';
}