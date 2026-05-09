import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  static const List<Map<String, dynamic>> _achievements = [
    {
      'title': 'First Blood',
      'desc': 'Complete your first lab',
      'icon': Icons.water_drop,
      'color': AppColors.error,
      'xp': 100,
      'earned': true,
    },
    {
      'title': 'Rookie Hacker',
      'desc': 'Reach Level 5',
      'icon': Icons.star,
      'color': Colors.amber,
      'xp': 200,
      'earned': true,
    },
    {
      'title': '7 Day Streak',
      'desc': 'Login 7 days in a row',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'xp': 150,
      'earned': true,
    },
    {
      'title': 'SQLi Expert',
      'desc': 'Complete all SQL Injection labs',
      'icon': Icons.storage,
      'color': AppColors.primary,
      'xp': 500,
      'earned': true,
    },
    {
      'title': 'CTF Champion',
      'desc': 'Solve 10 CTF challenges',
      'icon': Icons.emoji_events,
      'color': AppColors.secondary,
      'xp': 750,
      'earned': false,
    },
    {
      'title': 'Network Ninja',
      'desc': 'Complete all network labs',
      'icon': Icons.wifi,
      'color': Colors.teal,
      'xp': 600,
      'earned': false,
    },
    {
      'title': 'AI Apprentice',
      'desc': 'Have 50 chats with AI Mentor',
      'icon': Icons.psychology,
      'color': AppColors.accent,
      'xp': 300,
      'earned': false,
    },
    {
      'title': 'Leaderboard Climber',
      'desc': 'Reach Top 20 global rank',
      'icon': Icons.leaderboard,
      'color': Colors.deepPurple,
      'xp': 1000,
      'earned': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final earned = _achievements.where((a) => a['earned'] == true).toList();
    final locked = _achievements.where((a) => a['earned'] == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACHIEVEMENTS', style: TextStyle(letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary
            CyberCard(
              borderColor: AppColors.primary.withOpacity(0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('${earned.length}/${_achievements.length}',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      const Text('BADGES EARNED',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1.5)),
                    ],
                  ),
                  Container(
                      width: 1, height: 40, color: const Color(0xFF333333)),
                  Column(
                    children: [
                      Text(
                          '${earned.fold<int>(0, (s, a) => s + (a['xp'] as int))} XP',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber)),
                      const Text('TOTAL EARNED',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1.5)),
                    ],
                  ),
                  Container(
                      width: 1, height: 40, color: const Color(0xFF333333)),
                  Column(
                    children: [
                      Text('${(earned.length / _achievements.length * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent)),
                      const Text('COMPLETE',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1.5)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(),

            const SizedBox(height: 24),

            // Overall Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: earned.length / _achievements.length,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                color: AppColors.primary,
                minHeight: 8,
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 24),
            const SectionHeader(title: 'EARNED BADGES', color: AppColors.primary),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: earned.length,
              itemBuilder: (context, i) {
                return _AchievementCard(badge: earned[i])
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: i * 80))
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
              },
            ),

            const SizedBox(height: 24),
            const SectionHeader(title: 'LOCKED BADGES', color: AppColors.textSecondary),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: locked.length,
              itemBuilder: (context, i) {
                return _AchievementCard(badge: locked[i], locked: true)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: (earned.length + i) * 60));
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Map<String, dynamic> badge;
  final bool locked;

  const _AchievementCard({required this.badge, this.locked = false});

  @override
  Widget build(BuildContext context) {
    final color = locked ? const Color(0xFF444444) : (badge['color'] as Color);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(locked ? 0.2 : 0.35)),
        boxShadow: locked
            ? []
            : [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(badge['icon'] as IconData,
                    color: locked ? const Color(0xFF444444) : color,
                    size: 22),
              ),
              if (locked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF333333),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock, size: 10, color: Color(0xFF666666)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(badge['title'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: locked ? const Color(0xFF555555) : AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(badge['desc'] as String,
                    style: TextStyle(
                        color: locked ? const Color(0xFF444444) : AppColors.textSecondary,
                        fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('+${badge['xp']} XP',
                    style: TextStyle(
                        color: locked ? const Color(0xFF444444) : color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
