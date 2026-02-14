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

  static const String settings = '/app/home/settings';
  static const String notifications = '/app/home/settings/notifications';
  static const String theme = '/theme';
  static const String blocked = '/app/home/settings/blocked';
  static const String activeStates = '/app/home/settings/active_states';
  static const String saved = '/app/home/settings/saved';
  static const String search = '/app/home/search';

// groups
  static const String groups = '/app/home/settings/groups';
  static const String groupPreview = '/app/home/settings/groups/group_preview';
  static const String groupFeed = '/app/home/settings/groups/group_feed';
  static const String createGroup = '/app/home/settings/groups/create_group';
  static const String addCoverPhoto = '/app/home/settings/groups/create_group/add_cover_photo';
  static const String myGroup = '/app/home/settings/groups/my_group';
  static const String manageGroup = '/app/home/settings/groups/my_group/manage_group';




// chats
  static const String messages = '/app/home/messages';
  static const String chat = '/app/home/messages/chat';
  static const String chatInfo = '/app/home/messages/chat/chat_info';

  //profile
  static const String userProfileSettings = '/app/profile_settings';

}