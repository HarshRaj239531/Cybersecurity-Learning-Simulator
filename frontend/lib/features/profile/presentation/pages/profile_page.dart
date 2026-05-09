import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import '../../../../shared/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    
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
      body: profileAsync.when(
        data: (profile) {
          final username = profile['username'] ?? 'AGENT';
          final xp = profile['xp'] ?? 0;
          final level = (xp / 500).floor() + 1;
          final nextLevelXp = level * 500;
          final prevLevelXp = (level - 1) * 500;
          final progress = (xp - prevLevelXp) / (nextLevelXp - prevLevelXp);
          final streak = profile['streak'] ?? 0;

          return SingleChildScrollView(
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
                      HackerAvatar(
                        radius: 44,
                        initials: username.substring(0, 1).toUpperCase(),
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(username.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2)),
                      const SizedBox(height: 4),
                      Text('Level $level · Security Agent',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text('$streak day streak',
                              style: const TextStyle(
                                  color: Colors.orange, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(label: 'LABS', value: '${(profile['progress'] as List?)?.length ?? 0}', color: AppColors.primary),
                          const _Divider(),
                          _StatItem(label: 'CTF SOLVED', value: '${(profile['challengeProgress'] as List?)?.length ?? 0}', color: AppColors.secondary),
                          const _Divider(),
                          _StatItem(label: 'BADGES', value: '${(profile['userAchievements'] as List?)?.length ?? 0}', color: AppColors.accent),
                          const _Divider(),
                          _StatItem(label: 'XP', value: '$xp', color: Colors.orange),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('XP PROGRESS',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    letterSpacing: 2)),
                            Text('$xp / $nextLevelXp',
                                style: const TextStyle(
                                    color: AppColors.primary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            color: AppColors.primary,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Level ${level + 1} requires ${nextLevelXp - xp} more XP',
                            style: const TextStyle(
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
                if ((profile['progress'] as List?)?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SectionHeader(title: 'COMPLETED LABS'),
                        const SizedBox(height: 12),
                        ...((profile['progress'] as List).map((p) {
                          final lab = p['lab'];
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
                                  Text('+${lab['xpReward']} XP',
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        })),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Logout
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DangerButton(
                    text: 'LOGOUT',
                    onPressed: () => _showLogoutDialog(context, ref),
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
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
              if (context.mounted) {
                Navigator.pop(ctx);
                context.go('/login');
              }
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
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textHint, fontSize: 9, letterSpacing: 1)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white10,
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final Map<String, dynamic> badge;

  const _BadgeItem({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (badge['color'] as Color).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: (badge['color'] as Color).withOpacity(0.3)),
          ),
          child: Icon(badge['icon'] as IconData,
              color: badge['color'] as Color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(badge['label'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
          ),
          child: const Icon(Icons.lock_outline, color: Colors.white24, size: 20),
        ),
        const SizedBox(height: 6),
        const Text('LOCKED',
            style: TextStyle(fontSize: 9, color: Colors.white10)),
      ],
    );
  }
}
