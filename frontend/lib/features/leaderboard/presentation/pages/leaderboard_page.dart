import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leaderboard_provider.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _globalRankings = [
    {'rank': 1, 'name': 'shadow_walker', 'xp': 15200, 'level': 30, 'badge': '🥇', 'isMe': false},
    {'rank': 2, 'name': 'cyber_ghost', 'xp': 14850, 'level': 29, 'badge': '🥈', 'isMe': false},
    {'rank': 3, 'name': 'null_pointer', 'xp': 14100, 'level': 28, 'badge': '🥉', 'isMe': false},
    {'rank': 4, 'name': 'binary_beast', 'xp': 13500, 'level': 27, 'badge': '', 'isMe': false},
    {'rank': 5, 'name': 'data_daemon', 'xp': 12900, 'level': 25, 'badge': '', 'isMe': false},
    {'rank': 6, 'name': 'root_access', 'xp': 11200, 'level': 22, 'badge': '', 'isMe': false},
    {'rank': 7, 'name': 'hax0r_99', 'xp': 9800, 'level': 19, 'badge': '', 'isMe': false},
    {'rank': 8, 'name': 'exploit_dev', 'xp': 8400, 'level': 16, 'badge': '', 'isMe': false},
    {'rank': 9, 'name': 'vuln_hunter', 'xp': 7100, 'level': 14, 'badge': '', 'isMe': false},
    {'rank': 10, 'name': 'packet_sniffer', 'xp': 6000, 'level': 12, 'badge': '', 'isMe': false},
    {'rank': 42, 'name': 'neo_hacker (YOU)', 'xp': 2450, 'level': 12, 'badge': '⭐', 'isMe': true},
  ];

  final List<Map<String, dynamic>> _friendsRankings = [
    {'rank': 1, 'name': 'sys_admin', 'xp': 4200, 'level': 8, 'badge': '🥇', 'isMe': false},
    {'rank': 2, 'name': 'neo_hacker (YOU)', 'xp': 2450, 'level': 12, 'badge': '🥈', 'isMe': true},
    {'rank': 3, 'name': 'w1reguard', 'xp': 1800, 'level': 3, 'badge': '🥉', 'isMe': false},
    {'rank': 4, 'name': 'l33t_coder', 'xp': 900, 'level': 1, 'badge': '', 'isMe': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEADERBOARD', style: TextStyle(letterSpacing: 2)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'GLOBAL'),
            Tab(text: 'FRIENDS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ref.watch(leaderboardProvider).when(
                data: (data) => _buildRankingList(data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
          _buildRankingList(_friendsRankings),
        ],
      ),
    );
  }

  Widget _buildRankingList(List<dynamic> rankings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, i) {
        final user = rankings[i];
        final isMe = user['isMe'] == true;
        final rank = user['rank'] ?? (i + 1);
        final name = user['username'] ?? user['name'] ?? 'Unknown';
        final xp = user['xp'] ?? 0;
        final level = user['level'] ?? (xp / 500).floor() + 1;
        final badge = user['badge'] ?? (rank == 1 ? '🥇' : rank == 2 ? '🥈' : rank == 3 ? '🥉' : '');

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isMe
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.12),
                        AppColors.primary.withOpacity(0.04),
                      ],
                    )
                  : null,
              color: isMe ? null : AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isMe
                    ? AppColors.primary
                    : rank <= 3
                        ? AppColors.primary.withOpacity(0.3)
                        : const Color(0xFF2A2A2A),
              ),
            ),
            child: Row(
              children: [
                // Rank
                SizedBox(
                  width: 44,
                  child: rank <= 3
                      ? Text(badge,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22))
                      : Text('#$rank',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 14)),
                ),
                const SizedBox(width: 12),
                // Avatar
                HackerAvatar(
                  radius: 18,
                  initials: name.substring(0, 1).toUpperCase(),
                  color: isMe ? AppColors.primary : AppColors.secondary,
                ),
                const SizedBox(width: 12),
                // Name & Level
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isMe
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              letterSpacing: 0.5)),
                      Text('Level $level',
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11)),
                    ],
                  ),
                ),
                // XP
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$xp XP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontSize: 13)),
                    if (isMe)
                      const Text('YOU',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              letterSpacing: 1.5)),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 50)).slideX(
                begin: -0.08,
                end: 0,
              ),
        );
      },
    );
  }
}
