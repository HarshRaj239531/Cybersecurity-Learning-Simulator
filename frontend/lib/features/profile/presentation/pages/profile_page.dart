import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENT PROFILE', style: TextStyle(letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const HackerAvatar(radius: 44, initials: 'NH', color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text('NEO_HACKER',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  const SizedBox(height: 4),
                  const Text('Level 12 · Security Analyst',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text('7 day streak',
                          style: TextStyle(
                              color: Colors.orange, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: 'LABS', value: '24', color: AppColors.primary),
                      _Divider(),
                      _StatItem(label: 'CTF SOLVED', value: '5', color: AppColors.secondary),
                      _Divider(),
                      _StatItem(label: 'GLOBAL RANK', value: '#42', color: AppColors.accent),
                      _Divider(),
                      _StatItem(label: 'XP', value: '2,450', color: Colors.orange),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(),

            // XP Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CyberCard(
                borderColor: AppColors.primary.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('XP PROGRESS',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                letterSpacing: 2)),
                        Text('2,450 / 6,000',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 2450 / 6000,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        color: AppColors.primary,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Level 13 requires 3,550 more XP',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 11)),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 20),

            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SectionHeader(title: 'EARNED BADGES', trailing: 'VIEW ALL'),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      ..._badges.map((b) => _BadgeItem(badge: b)),
                      ...List.generate(
                          8 - _badges.length, (_) => const _LockedBadge()),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 20),

            // Completed Labs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SectionHeader(title: 'COMPLETED LABS'),
                  const SizedBox(height: 12),
                  ..._completedLabs.asMap().entries.map((e) {
                    final lab = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CyberCard(
                        borderColor: AppColors.primary.withOpacity(0.2),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(lab['title'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                            Text(lab['xp'] as String,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12)),
                          ],
                        ),
                      ).animate().fadeIn(
                          delay: Duration(milliseconds: e.key * 80)),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout
            Padding(
              padding: const EdgeInsets.all(16),
              child: DangerButton(
                text: 'LOGOUT',
                onPressed: () => _showLogoutDialog(context),
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: const Text('LOGOUT',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _badges = [
    {'icon': Icons.star, 'label': 'First Hack', 'color': Colors.amber},
    {'icon': Icons.military_tech, 'label': 'SQLi Expert', 'color': AppColors.primary},
    {'icon': Icons.local_fire_department, 'label': '7 Day Streak', 'color': Colors.orange},
    {'icon': Icons.emoji_events, 'label': 'CTF Winner', 'color': AppColors.secondary},
  ];

  static const List<Map<String, dynamic>> _completedLabs = [
    {'title': 'SQL Injection: Level 1', 'xp': '+250 XP'},
    {'title': 'XSS Basics', 'xp': '+250 XP'},
  ];
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final Color color;

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                letterSpacing: 1)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32,
        width: 1,
        color: const Color(0xFF333333));
  }
}

class _BadgeItem extends StatelessWidget {
  final Map<String, dynamic> badge;

  const _BadgeItem({required this.badge});

  @override
  Widget build(BuildContext context) {
    final color = badge['color'] as Color;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2),
            boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)],
          ),
          child: Icon(badge['icon'] as IconData, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(badge['label'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: const Icon(Icons.lock_outline,
              color: Color(0xFF333333), size: 22),
        ),
        const SizedBox(height: 4),
        const Text('Locked',
            style: TextStyle(fontSize: 9, color: Color(0xFF555555))),
      ],
    );
  }
}
