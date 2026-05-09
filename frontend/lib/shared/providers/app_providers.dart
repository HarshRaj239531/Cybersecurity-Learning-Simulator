import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/storage_service.dart';

// ─── Auth State ───────────────────────────────────────────────────────────────

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    _checkToken();
    return AuthStatus.unknown;
  }

  Future<void> _checkToken() async {
    final hasToken = await StorageService.hasValidToken();
    state = hasToken ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  Future<void> login(String token, String refreshToken) async {
    await StorageService.saveAccessToken(token);
    await StorageService.saveRefreshToken(refreshToken);
    state = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    await StorageService.clearTokens();
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(
  () => AuthNotifier(),
);

// ─── XP State ─────────────────────────────────────────────────────────────────

class XPNotifier extends Notifier<int> {
  @override
  int build() => 2450;

  void addXP(int amount) => state = state + amount;
}

final xpProvider = NotifierProvider<XPNotifier, int>(
  () => XPNotifier(),
);

// ─── Streak State ─────────────────────────────────────────────────────────────

class StreakNotifier extends Notifier<int> {
  @override
  int build() => 7;
  void set(int v) => state = v;
}
final streakProvider = NotifierProvider<StreakNotifier, int>(() => StreakNotifier());

// ─── Rank State ───────────────────────────────────────────────────────────────

class RankNotifier extends Notifier<int> {
  @override
  int build() => 42;
  void set(int v) => state = v;
}
final rankProvider = NotifierProvider<RankNotifier, int>(() => RankNotifier());

// ─── Level computed from XP ───────────────────────────────────────────────────

final levelProvider = Provider<int>((ref) {
  final xp = ref.watch(xpProvider);
  return (xp / 500).floor() + 1;
});
