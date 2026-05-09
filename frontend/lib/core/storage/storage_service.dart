import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class StorageService {
  static const FlutterSecureStorage _secure = FlutterSecureStorage();

  // ─── Secure Storage (Tokens) ─────────────────────────────────────────────

  static Future<void> saveAccessToken(String token) async {
    await _secure.write(key: AppConstants.accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _secure.read(key: AppConstants.accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _secure.write(key: AppConstants.refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _secure.read(key: AppConstants.refreshTokenKey);
  }

  static Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearTokens() async {
    await _secure.delete(key: AppConstants.accessTokenKey);
    await _secure.delete(key: AppConstants.refreshTokenKey);
  }

  static Future<void> clearAll() async {
    await _secure.deleteAll();
  }

  // ─── Hive Storage (Preferences / Cache) ──────────────────────────────────

  static Box get _settingsBox => Hive.box('settings');

  static Future<void> saveString(String key, String value) async {
    await _settingsBox.put(key, value);
  }

  static String? getString(String key) {
    return _settingsBox.get(key) as String?;
  }

  static Future<void> saveBool(String key, bool value) async {
    await _settingsBox.put(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as bool;
  }

  static bool isOnboardingDone() {
    return getBool(AppConstants.onboardingKey);
  }

  static Future<void> setOnboardingDone() async {
    await saveBool(AppConstants.onboardingKey, true);
  }
}
