import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../labs/presentation/providers/labs_provider.dart';
import '../../../../shared/providers/repository_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final labsAsync = ref.watch(labsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.terminal, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            const Text('CYBERVERSE', style: TextStyle(letterSpacing: 2, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined, color: AppColors.accent),
            onPressed: () => context.push('/leaderboard'),
          ),
          IconButton(
            icon: const Icon(Icons.terminal_outlined, color: AppColors.primary),
            onPressed: () => context.push('/terminal'),
          ),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: profileAsync.when(
              data: (profile) => HackerAvatar(
                radius: 16,
                initials: (profile['username'] ?? 'AG').substring(0, 1).toUpperCase(),
              ),
              loading: () => const HackerAvatar(radius: 16, initials: '..'),
              error: (_, __) => const HackerAvatar(radius: 16, initials: '??'),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          final xp = profile['xp'] ?? 0;
          final rank = profile['rank'] ?? '--';
          final streak = profile['streak'] ?? 0;
          final level = (xp / 500).floor() + 1;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  children: [
                    XPCard(
                        label: 'XP',
                        value: '$xp',
                        color: AppColors.primary,
                        icon: Icons.bolt),
                    const SizedBox(width: 10),
                    XPCard(
                        label: 'RANK',
                        value: '#$rank',
                        color: AppColors.secondary,
                        icon: Icons.military_tech_outlined),
                    const SizedBox(width: 10),
                    XPCard(
                        label: 'STREAK',
                        value: '$streak',
                        color: AppColors.accent,
                        icon: Icons.local_fire_department_outlined),
                    const SizedBox(width: 10),
                    XPCard(
                        label: 'LEVEL',
                        value: '$level',
                        color: Colors.orange,
                        icon: Icons.shield_outlined),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 24),

                // XP Progress Bar
                CyberCard(
                  borderColor: AppColors.primary.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('LEVEL $level PROGRESS',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  letterSpacing: 2)),
                          Text('$xp / ${level * 500} XP',
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (xp % 500) / 500,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          color: AppColors.primary,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 24),

                // Active Missions
                const SectionHeader(title: 'ACTIVE MISSIONS', trailing: 'VIEW ALL'),
                const SizedBox(height: 12),
                labsAsync.when(
                  data: (labs) {
                    final activeLabs = labs.take(3).toList();
                    return Column(
                      children: [
                        for (int i = 0; i < activeLabs.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _MissionCard(
                              title: activeLabs[i]['title'],
                              subtitle: activeLabs[i]['description'],
                              progress: (activeLabs[i]['progress'] ?? 0).toDouble(),
                              xp: activeLabs[i]['xpReward'],
                              difficulty: activeLabs[i]['difficulty'],
                              onTap: () => context.push('/lab/sql-injection'),
                            ).animate().fadeIn(delay: Duration(milliseconds: 300 + (i * 100))),
                          ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Error loading labs: $err'),
                ),

                const SizedBox(height: 12),

            const SizedBox(height: 24),

            // AI Recommendation
            const SectionHeader(
                title: 'AI MENTOR RECOMMENDATION',
                color: AppColors.secondary),
            const SizedBox(height: 12),
            CyberCard(
              borderColor: AppColors.secondary.withOpacity(0.3),
              onTap: () => context.push('/mentor'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.psychology,
                        color: AppColors.secondary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mentor Suggestion',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          'Based on your SQL Injection progress, try the XSS Deep Dive lab next.',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.secondary, size: 20),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 24),

            // Quick Actions
            const SectionHeader(title: 'QUICK START'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.flag_outlined,
                    label: 'CTF\nCHALLENGE',
                    color: AppColors.secondary,
                    onTap: () => context.push('/ctf'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.terminal_outlined,
                    label: 'TERMINAL\nSIMULATOR',
                    color: AppColors.accent,
                    onTap: () => context.push('/terminal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.emoji_events_outlined,
                    label: 'ACHIEVE-\nMENTS',
                    color: Colors.orange,
                    onTap: () => context.push('/achievements'),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 700.ms),

            const SizedBox(height: 24),

            // Recent Lab Activity
            const SectionHeader(title: 'RECENT ACTIVITY'),
            const SizedBox(height: 12),
            _ActivityItem(
                icon: Icons.check_circle,
                text: 'Completed SQLi Level 1',
                time: '2h ago',
                xp: '+250 XP',
                color: AppColors.primary),
            _ActivityItem(
                icon: Icons.play_arrow,
                text: 'Started XSS Basics',
                time: '5h ago',
                xp: '+50 XP',
                color: AppColors.accent),
            _ActivityItem(
                icon: Icons.emoji_events,
                text: 'Earned "Rookie Hacker" badge',
                time: '1d ago',
                xp: '+100 XP',
                color: Colors.orange),

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
}

class _MissionCard extends StatelessWidget {
  final String title, subtitle, difficulty;
  final double progress;
  final int xp;
  final VoidCallback onTap;

  const _MissionCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.xp,
    required this.difficulty,
    required this.onTap,
  });

  Color get _difficultyColor {
    switch (difficulty) {
      case 'BEGINNER':
        return AppColors.primary;
      case 'INTERMEDIATE':
        return Colors.orange;
      case 'ADVANCED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _difficultyColor.withOpacity(0.4)),
                ),
                child: Text(difficulty,
                    style: TextStyle(
                        color: _difficultyColor,
                        fontSize: 10,
                        letterSpacing: 1)),
              ),
              const Spacer(),
              Text('+$xp XP',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    color: AppColors.primary,
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(progress * 100).toInt()}%',
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String text, time, xp;
  final Color color;

  const _ActivityItem(
      {required this.icon,
      required this.text,
      required this.time,
      required this.xp,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 13)),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          Text(xp,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
