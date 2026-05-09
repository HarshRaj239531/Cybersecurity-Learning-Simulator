class AppEndpoints {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';

  // Labs
  static const String labs = '/labs';
  static String labById(String id) => '/labs/$id';
  static const String submitLabAnswer = '/labs/complete';
  static const String saveProgress = '/labs/progress';

  // CTF
  static const String ctfChallenges = '/ctf';
  static const String validateFlag = '/ctf/validate';

  // Leaderboard
  static const String leaderboard = '/leaderboard';
  static const String friendsLeaderboard = '/leaderboard/friends';

  // Profile
  static const String profile = '/users/profile';
  static const String updateProfile = '/profile/update';
  static const String achievements = '/profile/achievements';

  // AI Mentor
  static const String aiChat = '/mentor/chat';
  static const String aiSuggestLab = '/mentor/suggest';
}
