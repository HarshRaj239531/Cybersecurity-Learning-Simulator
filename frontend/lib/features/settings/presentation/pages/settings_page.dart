import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  String _selectedTheme = 'Cyberpunk';

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(letterSpacing: 2)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section — live data from backend
          profileAsync.when(
            data: (profile) {
              final username = profile['username'] ?? 'AGENT';
              final xp = profile['xp'] ?? 0;
              final level = (xp / 500).floor() + 1;
              return CyberCard(
                borderColor: AppColors.primary.withOpacity(0.3),
                child: Row(
                  children: [
                    HackerAvatar(
                      radius: 28,
                      initials: username.substring(0, 1).toUpperCase(),
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Level $level Agent',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/profile'),
                      child: const Text('EDIT',
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 12)),
                    ),
                  ],
                ),
              );
            },
            loading: () => const CyberCard(
              child: Row(
                children: [
                  SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator()),
                ],
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ).animate().fadeIn(),

          const SizedBox(height: 24),
          _SectionHeader(title: 'APPEARANCE'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: _selectedTheme,
            color: AppColors.primary,
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => _showThemeDialog(),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 24),
          _SectionHeader(title: 'NOTIFICATIONS'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Lab updates, CTF events, streaks',
            color: AppColors.secondary,
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
              activeColor: AppColors.primary,
            ),
          ).animate().fadeIn(delay: 200.ms),

          _SettingTile(
            icon: Icons.volume_up_outlined,
            title: 'Sound Effects',
            subtitle: 'Terminal sounds, achievement alerts',
            color: AppColors.accent,
            trailing: Switch(
              value: _soundEnabled,
              onChanged: (v) => setState(() => _soundEnabled = v),
              activeColor: AppColors.primary,
            ),
          ).animate().fadeIn(delay: 250.ms),

          const SizedBox(height: 24),
          _SectionHeader(title: 'SECURITY'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            color: Colors.orange,
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => _showChangePasswordDialog(),
          ).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 24),
          _SectionHeader(title: 'ACCOUNT'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.download_outlined,
            title: 'My Progress',
            subtitle: 'View your completed labs and CTF score',
            color: AppColors.accent,
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => context.push('/profile'),
          ).animate().fadeIn(delay: 500.ms),

          _SettingTile(
            icon: Icons.emoji_events_outlined,
            title: 'Achievements',
            subtitle: 'View earned badges and achievements',
            color: Colors.amber,
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => context.push('/achievements'),
          ).animate().fadeIn(delay: 550.ms),

          const SizedBox(height: 24),
          _SectionHeader(title: 'SYSTEM'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.help_outline,
            title: 'App Guide',
            subtitle: 'Learn how every section works',
            color: AppColors.primary,
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => context.push('/guide'),
          ).animate().fadeIn(delay: 580.ms),

          _SettingTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: 'CyberVerse v1.0.0',
            color: AppColors.textSecondary,
            trailing: const SizedBox.shrink(),
          ).animate().fadeIn(delay: 620.ms),

          const SizedBox(height: 24),

          // Logout Button
          DangerButton(
            text: 'LOGOUT',
            onPressed: () => _showLogoutDialog(),
          ).animate().fadeIn(delay: 700.ms),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('SELECT THEME'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Cyberpunk', 'Matrix', 'Midnight', 'Neon Noir'].map((theme) {
            return RadioListTile<String>(
              title: Text(theme),
              value: theme,
              groupValue: _selectedTheme,
              activeColor: AppColors.primary,
              onChanged: (v) {
                setState(() => _selectedTheme = v!);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool loading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('CHANGE PASSWORD'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CyberTextField(
                  label: 'CURRENT PASSWORD',
                  controller: currentCtrl,
                  obscureText: true),
              const SizedBox(height: 16),
              CyberTextField(
                  label: 'NEW PASSWORD',
                  controller: newCtrl,
                  obscureText: true),
              const SizedBox(height: 16),
              CyberTextField(
                  label: 'CONFIRM PASSWORD',
                  controller: confirmCtrl,
                  obscureText: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.pop(ctx),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (newCtrl.text != confirmCtrl.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Passwords do not match'),
                              backgroundColor: AppColors.error),
                        );
                        return;
                      }
                      if (newCtrl.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password must be at least 6 characters'),
                              backgroundColor: AppColors.error),
                        );
                        return;
                      }
                      setDialogState(() => loading = true);
                      try {
                        await ref
                            .read(profileRepositoryProvider)
                            .changePassword(currentCtrl.text, newCtrl.text);
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('✓ Password updated successfully'),
                                backgroundColor: AppColors.primary),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => loading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(e.toString().replaceFirst('Exception: ', '')),
                                backgroundColor: AppColors.error),
                          );
                        }
                      }
                    },
              child: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('UPDATE',
                      style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('LOGOUT'),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) context.go('/login');
            },
            child: const Text('LOGOUT',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CyberCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
