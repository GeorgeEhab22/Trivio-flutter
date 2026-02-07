class ApiEndpoints {
  // auth
  static const login = 'auth/login';
  static const signup = 'auth/signup';
  static const signout = 'auth/signout';
  static const me = 'auth/me';
  static const requestOTP = 'auth/request-otp';
  static const googleSignIn = 'auth/google-login';
  static const appleSignIn = 'auth/apple';
  static const googleRegister = 'auth/google/register';
  static const appleRegister = 'auth/apple/register';
  static const verifyEmail = 'auth/verify-code';
  static const forgetPassword = 'auth/forget-password';
  static const resendVerificationCode = 'auth/resend-verification-code';
  static const resetPassword = 'auth/reset-password';

  // POSTS
  static const createPost = 'posts'; // POST
  static const fetchPosts = 'posts/all'; // GET
  static const fetchSinglePost = 'posts/single'; // GET {id}
  static const editPost = 'posts/edit'; // PATCH {id}`
  static const deletePost = 'posts'; // DELETE {id}
  static const sharePost = 'posts/share'; // POST {postId}
  static const toggleSavePost = 'posts/save'; // POST {postId}
  static const reportPost = 'posts/report'; // POST {postId}
  static const searchPosts = 'posts/search'; // GET ?q=query

  // FOLLOW
  static const toggleFollow = 'users/follow'; // POST {userId}

  // REACTIONS (On Posts)
  static const addReactionToPost = 'posts/react'; // POST {postId}
  static const removeReactionFromPost = 'posts/remove-react'; // DELETE {postId}

  // COMMENTS
  static const getComments = 'comments/all-comments'; // GET {postId}
  static const addComment = 'comments/add'; // POST
  static const deleteComment = 'comments/delete'; // DELETE {commentId}
  static const editComment = 'comments/edit'; // PATCH {commentId}
  static const getReplies = 'comments/all-replies'; // GET {commentId}

  // COMMENT REACTIONS
  static const reactToComment = 'comments/react'; // POST {commentId}
  static const removeReactionFromComment =
      'comments/remove-react'; // DELETE {commentId}

  // COMMENT MENTIONS
  static const mentionUsersInComment = 'comments/mentions'; // POST {commentId}

  // GROUPS
  static const groups = 'groups';            // POST (create), GET (all)
}