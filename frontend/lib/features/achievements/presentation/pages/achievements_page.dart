import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import '../../../../shared/providers/repository_providers.dart';

// Providers for achievements
final _allAchievementsProvider =
    FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.getAllAchievements();
});

final _myAchievementsProvider =
    FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.getMyAchievements();
});

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(_allAchievementsProvider);
    final myAsync = ref.watch(_myAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACHIEVEMENTS', style: TextStyle(letterSpacing: 2)),
      ),
      body: allAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorDisplayWidget(
          message: 'Failed to load achievements',
          onRetry: () {
            ref.invalidate(_allAchievementsProvider);
            ref.invalidate(_myAchievementsProvider);
          },
        ),
        data: (allAchievements) {
          return myAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorDisplayWidget(
              message: 'Failed to load your achievements',
              onRetry: () => ref.invalidate(_myAchievementsProvider),
            ),
            data: (myAchievements) {
              final earnedIds = myAchievements
                  .map((ua) => ua['achievementId'] ?? ua['achievement']?['id'])
                  .toSet();

              final earned = allAchievements
                  .where((a) => earnedIds.contains(a['id']))
                  .toList();
              final locked = allAchievements
                  .where((a) => !earnedIds.contains(a['id']))
                  .toList();
              final total = allAchievements.length;

              return SingleChildScrollView(
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
                              Text('${earned.length}/$total',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              const Text('EARNED',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      letterSpacing: 1.5)),
                            ],
                          ),
                          Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFF333333)),
                          Column(
                            children: [
                              Text(
                                  total > 0
                                      ? '${(earned.length / total * 100).toInt()}%'
                                      : '0%',
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
                          Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFF333333)),
                          Column(
                            children: [
                              Text('${locked.length}',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange)),
                              const Text('REMAINING',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      letterSpacing: 1.5)),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(),

                    const SizedBox(height: 16),

                    // Overall Progress Bar
                    if (total > 0)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: earned.length / total,
                          backgroundColor:
                              AppColors.primary.withOpacity(0.1),
                          color: AppColors.primary,
                          minHeight: 8,
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 24),

                    if (earned.isNotEmpty) ...[
                      const SectionHeader(
                          title: 'EARNED BADGES', color: AppColors.primary),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: earned.length,
                        itemBuilder: (context, i) {
                          return _AchievementCard(
                                  achievement: earned[i], earned: true)
                              .animate()
                              .fadeIn(
                                  delay: Duration(milliseconds: i * 80))
                              .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1, 1));
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (locked.isNotEmpty) ...[
                      const SectionHeader(
                          title: 'LOCKED BADGES',
                          color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: locked.length,
                        itemBuilder: (context, i) {
                          return _AchievementCard(
                                  achievement: locked[i], earned: false)
                              .animate()
                              .fadeIn(delay: Duration(
                                  milliseconds:
                                      (earned.length + i) * 60));
                        },
                      ),
                    ],

                    if (allAchievements.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('No achievements yet.',
                              style: TextStyle(
                                  color: AppColors.textSecondary)),
                        ),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Map<String, dynamic> achievement;
  final bool earned;

  const _AchievementCard(
      {required this.achievement, required this.earned});

  // Map icon names from the backend to Flutter icons
  IconData get _icon {
    switch (achievement['icon']) {
      case 'water_drop':
        return Icons.water_drop;
      case 'star':
        return Icons.star;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'storage':
        return Icons.storage;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'wifi':
        return Icons.wifi;
      case 'psychology':
        return Icons.psychology;
      case 'leaderboard':
        return Icons.leaderboard;
      case 'military_tech':
        return Icons.military_tech;
      default:
        return Icons.shield;
    }
  }

  Color get _color {
    if (!earned) return const Color(0xFF444444);
    // Cycle through accent colors for variety
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      Colors.amber,
      Colors.orange,
      AppColors.accent,
      Colors.teal,
    ];
    final hash = (achievement['title'] as String).length % colors.length;
    return colors[hash];
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: color.withOpacity(earned ? 0.35 : 0.2)),
        boxShadow: earned
            ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)]
            : [],
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
                child: Icon(_icon, color: color, size: 22),
              ),
              if (!earned)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF333333),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock,
                        size: 10, color: Color(0xFF666666)),
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
                Text(achievement['title'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: earned
                            ? AppColors.textPrimary
                            : const Color(0xFF555555)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(achievement['description'] as String,
                    style: TextStyle(
                        color: earned
                            ? AppColors.textSecondary
                            : const Color(0xFF444444),
                        fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
