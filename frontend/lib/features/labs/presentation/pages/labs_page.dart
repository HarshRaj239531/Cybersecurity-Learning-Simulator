import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/labs_provider.dart';

class LabsPage extends ConsumerStatefulWidget {
  const LabsPage({super.key});

  @override
  ConsumerState<LabsPage> createState() => _LabsPageState();
}

class _LabsPageState extends ConsumerState<LabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _labs = [
    {
      'id': 'sql_injection',
      'title': 'SQL Injection',
      'subtitle': 'Bypass authentication and extract data',
      'category': 'Web',
      'difficulty': 'BEGINNER',
      'xp': 250,
      'icon': Icons.storage_outlined,
      'color': AppColors.primary,
      'progress': 0.65,
      'route': '/lab/sql-injection',
    },
    {
      'id': 'xss',
      'title': 'XSS Attack',
      'subtitle': 'Inject malicious scripts into web pages',
      'category': 'Web',
      'difficulty': 'BEGINNER',
      'xp': 250,
      'icon': Icons.code_outlined,
      'color': AppColors.accent,
      'progress': 0.2,
      'route': '/lab/xss',
    },
    {
      'id': 'csrf',
      'title': 'CSRF Vulnerability',
      'subtitle': 'Forge cross-site request attacks',
      'category': 'Web',
      'difficulty': 'INTERMEDIATE',
      'xp': 400,
      'icon': Icons.sync_problem_outlined,
      'color': Colors.orange,
      'progress': 0.0,
      'route': '/lab/csrf',
    },
    {
      'id': 'jwt',
      'title': 'JWT Exploits',
      'subtitle': 'Bypass token validation mechanisms',
      'category': 'Auth',
      'difficulty': 'INTERMEDIATE',
      'xp': 400,
      'icon': Icons.token_outlined,
      'color': AppColors.secondary,
      'progress': 0.0,
      'route': '/lab/jwt',
    },
    {
      'id': 'network_sniff',
      'title': 'Network Sniffing',
      'subtitle': 'Intercept and analyze network packets',
      'category': 'Network',
      'difficulty': 'INTERMEDIATE',
      'xp': 500,
      'icon': Icons.wifi_outlined,
      'color': Colors.teal,
      'progress': 0.0,
      'route': '/lab/network-sniff',
    },
    {
      'id': 'auth_bypass',
      'title': 'Authentication Bypass',
      'subtitle': 'Circumvent login mechanisms',
      'category': 'Auth',
      'difficulty': 'ADVANCED',
      'xp': 600,
      'icon': Icons.no_encryption_outlined,
      'color': AppColors.error,
      'progress': 0.0,
      'route': '/lab/auth-bypass',
    },
    {
      'id': 'dns_spoof',
      'title': 'DNS Spoofing',
      'subtitle': 'Redirect traffic using fake DNS records',
      'category': 'Network',
      'difficulty': 'ADVANCED',
      'xp': 750,
      'icon': Icons.dns_outlined,
      'color': Colors.deepPurple,
      'progress': 0.0,
      'route': '/lab/dns-spoof',
    },
    {
      'id': 'encryption',
      'title': 'Encryption Labs',
      'subtitle': 'Explore cryptographic vulnerabilities',
      'category': 'Crypto',
      'difficulty': 'ADVANCED',
      'xp': 750,
      'icon': Icons.lock_outlined,
      'color': Colors.amber,
      'progress': 0.0,
      'route': '/lab/encryption',
    },
  ];

  final List<String> _categories = ['All', 'Web', 'Network', 'Auth', 'Crypto'];
  String _selectedCategory = 'All';

  List<dynamic> _getFilteredLabs(List<dynamic> labs) {
    return labs.where((lab) {
      final matchesSearch = _searchQuery.isEmpty ||
          lab['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || lab['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRAINING LABS', style: TextStyle(letterSpacing: 2)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'ALL LABS'),
            Tab(text: 'MY PROGRESS'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search labs...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = _categories[i];
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.15)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFF333333),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ref.watch(labsProvider).when(
              data: (labs) {
                final filteredLabs = _getFilteredLabs(labs);
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // All Labs
                    filteredLabs.isEmpty
                        ? const Center(
                            child: Text('No labs found',
                                style: TextStyle(color: AppColors.textSecondary)))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredLabs.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final lab = filteredLabs[i];
                              return _LabCard(
                                lab: lab,
                                onTap: () {
                                  // Map backend ID to existing frontend routes for now
                                  String route = '/lab/sql-injection';
                                  if (lab['title'].toString().contains('XSS')) route = '/lab/xss';
                                  if (lab['title'].toString().contains('JWT')) route = '/lab/jwt';
                                  context.push(route);
                                },
                              ).animate().fadeIn(
                                  delay: Duration(milliseconds: i * 60));
                            },
                          ),
                    // My Progress (Filter completed or in-progress from the same list)
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: labs.where((l) => (l['progress'] ?? 0) > 0).length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final inProgress = labs
                            .where((l) => (l['progress'] ?? 0) > 0)
                            .toList();
                        return _LabCard(
                          lab: inProgress[i],
                          onTap: () => context.push('/lab/sql-injection'),
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabCard extends StatelessWidget {
  final Map<String, dynamic> lab;
  final VoidCallback onTap;

  const _LabCard({required this.lab, required this.onTap});

  Color get _difficultyColor {
    switch (lab['difficulty']) {
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
    final progress = (lab['progress'] ?? 0).toDouble();
    final color = lab['color'] is Color ? lab['color'] as Color : AppColors.primary;

    return CyberCard(
      onTap: onTap,
      borderColor: color.withOpacity(0.25),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon((lab['icon'] is IconData ? lab['icon'] : Icons.terminal) as IconData, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(lab['title'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: _difficultyColor.withOpacity(0.4)),
                      ),
                      child: Text(lab['difficulty'] as String,
                          style: TextStyle(
                              color: _difficultyColor,
                              fontSize: 9,
                              letterSpacing: 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(lab['description'] ?? lab['subtitle'] ?? '',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                if (progress > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: color.withOpacity(0.1),
                            color: color,
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${(progress * 100).toInt()}%',
                          style: TextStyle(color: color, fontSize: 11)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Icon(
                progress >= 1.0
                    ? Icons.check_circle
                    : Icons.play_circle_outline,
                color: progress >= 1.0 ? AppColors.primary : color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text('+${lab['xpReward'] ?? lab['xp'] ?? 0} XP',
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
