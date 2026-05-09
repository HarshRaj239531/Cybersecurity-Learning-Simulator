import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;
  String _selectedTheme = 'Cyberpunk';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(letterSpacing: 2)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          CyberCard(
            borderColor: AppColors.primary.withOpacity(0.3),
            child: Row(
              children: [
                const HackerAvatar(radius: 28, initials: 'NH'),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NEO_HACKER',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Level 12 Agent',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('EDIT',
                      style: TextStyle(color: AppColors.primary, fontSize: 12)),
                ),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 24),
          _SectionHeader(title: 'APPEARANCE'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: _selectedTheme,
            color: AppColors.primary,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => _showThemeDialog(),
          ).animate().fadeIn(delay: 100.ms),

          _SettingTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Recommended for best experience',
            color: AppColors.accent,
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (v) => setState(() => _darkModeEnabled = v),
              activeColor: AppColors.primary,
            ),
          ).animate().fadeIn(delay: 150.ms),

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
            icon: Icons.fingerprint,
            title: 'Biometric Auth',
            subtitle: 'Use fingerprint or face ID',
            color: Colors.teal,
            trailing: Switch(
              value: _biometricEnabled,
              onChanged: (v) => setState(() => _biometricEnabled = v),
              activeColor: AppColors.primary,
            ),
          ).animate().fadeIn(delay: 300.ms),

          _SettingTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            color: Colors.orange,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => _showChangePasswordDialog(),
          ).animate().fadeIn(delay: 350.ms),

          _SettingTile(
            icon: Icons.security_outlined,
            title: 'Active Sessions',
            subtitle: '1 device connected',
            color: AppColors.error,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 24),
          _SectionHeader(title: 'ACCOUNT'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.person_outline,
            title: 'Profile Settings',
            subtitle: 'Edit name, bio, avatar',
            color: AppColors.primary,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ).animate().fadeIn(delay: 450.ms),

          _SettingTile(
            icon: Icons.download_outlined,
            title: 'Export Progress',
            subtitle: 'Download your lab history',
            color: AppColors.accent,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 24),
          _SectionHeader(title: 'SYSTEM'),
          const SizedBox(height: 12),

          _SettingTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: 'CyberVerse v1.0.0',
            color: AppColors.textSecondary,
            trailing: const SizedBox.shrink(),
          ).animate().fadeIn(delay: 550.ms),

          _SettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            color: AppColors.textSecondary,
            trailing: const Icon(Icons.open_in_new, color: AppColors.textSecondary, size: 16),
            onTap: () {},
          ).animate().fadeIn(delay: 600.ms),

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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('CHANGE PASSWORD'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CyberTextField(label: 'CURRENT PASSWORD', obscureText: true),
            SizedBox(height: 16),
            CyberTextField(label: 'NEW PASSWORD', obscureText: true),
            SizedBox(height: 16),
            CyberTextField(label: 'CONFIRM PASSWORD', obscureText: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Password updated successfully!'),
                    backgroundColor: AppColors.primary),
              );
            },
            child: const Text('UPDATE',
                style: TextStyle(color: AppColors.primary)),
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
                          color: AppColors.textSecondary,
                          fontSize: 12)),
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
