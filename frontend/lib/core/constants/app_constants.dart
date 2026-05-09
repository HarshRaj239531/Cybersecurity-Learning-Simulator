class AppConstants {
  // App Info
  static const String appName = 'CyberVerse';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration verySlow = Duration(milliseconds: 1200);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_done';

  // Lab IDs
  static const String labSqlInjection = 'sql_injection';
  static const String labXss = 'xss';
  static const String labCsrf = 'csrf';
  static const String labJwt = 'jwt';
  static const String labNetworkSniff = 'network_sniff';

  // XP Values
  static const int xpEasyLab = 100;
  static const int xpMediumLab = 250;
  static const int xpHardLab = 500;
  static const int xpCtfChallenge = 750;
  static const int xpQuizCorrect = 50;
}
