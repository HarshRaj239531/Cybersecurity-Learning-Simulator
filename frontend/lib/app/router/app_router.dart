import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/labs/presentation/pages/labs_page.dart';
import '../../features/labs/presentation/pages/sql_injection_lab_page.dart';
import '../../features/labs/presentation/pages/other_labs_page.dart';
import '../../features/ctf/presentation/pages/ctf_page.dart';
import '../../features/mentor_ai/presentation/pages/mentor_ai_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/terminal/presentation/pages/terminal_page.dart';
import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../app/theme/app_colors.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      // ── Splash ────────────────────────────────────────────────────────────
      GoRoute(path: '/', builder: (_, __) => const SplashPage()),

      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: '/otp-verify', builder: (_, __) => const OtpVerifyPage()),

      // ── Main Shell (Bottom Nav) ───────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _ShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/labs', builder: (_, __) => const LabsPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/ctf', builder: (_, __) => const CtfPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/mentor', builder: (_, __) => const MentorAiPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
          ]),
        ],
      ),

      // ── Individual Labs ────────────────────────────────────────────────────
      GoRoute(
        path: '/lab/sql-injection',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const SqlInjectionLabPage(),
      ),
      GoRoute(
        path: '/lab/xss',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const XssLabPage(),
      ),
      GoRoute(
        path: '/lab/csrf',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const CsrfLabPage(),
      ),
      GoRoute(
        path: '/lab/jwt',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const JwtLabPage(),
      ),
      GoRoute(
        path: '/lab/network-sniff',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const NetworkSniffLabPage(),
      ),
      GoRoute(
        path: '/lab/auth-bypass',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AuthBypassLabPage(),
      ),
      GoRoute(
        path: '/lab/dns-spoof',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const DnsSpoofLabPage(),
      ),
      GoRoute(
        path: '/lab/encryption',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const EncryptionLabPage(),
      ),

      // ── Other Pages ────────────────────────────────────────────────────────
      GoRoute(
        path: '/leaderboard',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LeaderboardPage(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: '/terminal',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const TerminalPage(),
      ),
      GoRoute(
        path: '/achievements',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AchievementsPage(),
      ),
    ],
  );
});

// ─── Bottom Navigation Shell ─────────────────────────────────────────────────

class _ShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ShellScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.primary.withOpacity(0.15), width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) =>
              navigationShell.goBranch(index),
          backgroundColor: AppColors.background,
          indicatorColor: AppColors.primary.withOpacity(0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.science_outlined),
              selectedIcon: Icon(Icons.science, color: AppColors.primary),
              label: 'Labs',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              selectedIcon: Icon(Icons.flag, color: AppColors.primary),
              label: 'CTF',
            ),
            NavigationDestination(
              icon: Icon(Icons.psychology_outlined),
              selectedIcon: Icon(Icons.psychology, color: AppColors.primary),
              label: 'AI',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
