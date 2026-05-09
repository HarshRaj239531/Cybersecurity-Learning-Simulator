import 'dart:io';
import 'package:flutter/foundation.dart';

class AppEndpoints {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';

  // Labs
  static const String labs = '/labs';
  static String labById(String id) => '/labs/$id';
  static String completeLab(String id) => '/labs/$id/complete';
  static const String myProgress = '/labs/my-progress';

  // CTF
  static const String ctfChallenges = '/ctf';
  static String submitFlag(String id) => '/ctf/$id/submit';
  static const String myCtfProgress = '/ctf/my-progress';

  // Leaderboard
  static const String leaderboard = '/leaderboard';

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static const String changePassword = '/profile/change-password';

  // Achievements
  static const String allAchievements = '/achievements';
  static const String myAchievements = '/achievements/my';

  // AI Mentor
  static const String aiChat = '/mentor/chat';
  static const String aiHistory = '/mentor/history';
}
