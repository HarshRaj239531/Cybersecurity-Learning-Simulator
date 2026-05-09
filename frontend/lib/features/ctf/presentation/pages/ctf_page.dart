import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class CtfPage extends StatefulWidget {
  const CtfPage({super.key});

  @override
  State<CtfPage> createState() => _CtfPageState();
}

class _CtfPageState extends State<CtfPage> {
  final List<Map<String, dynamic>> _challenges = [
    {
      'id': '1',
      'title': 'Base64 Decode',
      'desc': 'Decode the hidden message to reveal the flag.',
      'difficulty': 'EASY',
      'xp': 100,
      'icon': Icons.code,
      'color': AppColors.primary,
      'solved': false,
      'type': 'crypto',
    },
    {
      'id': '2',
      'title': 'Hash Cracking',
      'desc': 'Crack the MD5 hash to find the password.',
      'difficulty': 'MEDIUM',
      'xp': 250,
      'icon': Icons.fingerprint,
      'color': Colors.orange,
      'solved': false,
      'type': 'crypto',
    },
    {
      'id': '3',
      'title': 'Hidden Files',
      'desc': 'Find the flag hidden in the server filesystem.',
      'difficulty': 'MEDIUM',
      'xp': 250,
      'icon': Icons.folder_outlined,
      'color': AppColors.accent,
      'solved': true,
      'type': 'forensics',
    },
    {
      'id': '4',
      'title': 'JWT Challenge',
      'desc': 'Manipulate the JWT token to escalate privileges.',
      'difficulty': 'HARD',
      'xp': 500,
      'icon': Icons.token_outlined,
      'color': AppColors.secondary,
      'solved': false,
      'type': 'web',
    },
    {
      'id': '5',
      'title': 'SQLi Bypass',
      'desc': 'Use SQL injection to retrieve the admin flag.',
      'difficulty': 'HARD',
      'xp': 500,
      'icon': Icons.storage_outlined,
      'color': AppColors.error,
      'solved': false,
      'type': 'web',
    },
    {
      'id': '6',
      'title': 'XSS Cookie Steal',
      'desc': 'Steal the admin session cookie using XSS.',
      'difficulty': 'HARD',
      'xp': 750,
      'icon': Icons.cookie_outlined,
      'color': Colors.deepPurple,
      'solved': false,
      'type': 'web',
    },
  ];

  String _selectedType = 'all';

  List<Map<String, dynamic>> get _filtered {
    if (_selectedType == 'all') return _challenges;
    return _challenges.where((c) => c['type'] == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    final solved = _challenges.where((c) => c['solved'] == true).length;
    final total = _challenges.length;
    final totalXp = _challenges
        .where((c) => c['solved'] == true)
        .fold<int>(0, (sum, c) => sum + (c['xp'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('CAPTURE THE FLAG', style: TextStyle(letterSpacing: 2)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Stats
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBadge(label: 'SOLVED', value: '$solved/$total', color: AppColors.primary),
                      _StatBadge(label: 'XP EARNED', value: '$totalXp', color: AppColors.secondary),
                      _StatBadge(label: 'RANK', value: '#42', color: AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: total > 0 ? solved / total : 0,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      color: AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            // Category Filter
            SizedBox(
              height: 44,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  for (final cat in ['all', 'web', 'crypto', 'forensics'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.toUpperCase()),
                        selected: _selectedType == cat,
                        onSelected: (v) =>
                            setState(() => _selectedType = cat),
                        selectedColor: AppColors.secondary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _selectedType == cat
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        backgroundColor: const Color(0xFF1A1A1A),
                        side: BorderSide(
                          color: _selectedType == cat
                              ? AppColors.secondary
                              : const Color(0xFF333333),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Challenge Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                return _ChallengeCard(
                  challenge: _filtered[i],
                  onTap: () => _showChallengeDialog(context, _filtered[i]),
                ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showChallengeDialog(BuildContext context, Map<String, dynamic> challenge) {
    final flagCtrl = TextEditingController();
    final color = challenge['color'] as Color;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(challenge['icon'] as IconData, color: color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(challenge['title'] as String,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(challenge['desc'] as String,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 20),
              const TerminalBox(
                content:
                    'Hint: Use a Base64 decoder or CyberChef tool.\nFlag format: FLAG{...}',
              ),
              const SizedBox(height: 20),
              TextField(
                controller: flagCtrl,
                style: const TextStyle(
                    fontFamily: 'monospace', color: AppColors.primary),
                decoration: const InputDecoration(
                  labelText: 'Enter Flag',
                  hintText: 'FLAG{...}',
                  prefixIcon: Icon(Icons.flag_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlowButton(
                      text: 'SUBMIT FLAG',
                      color: color,
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (flagCtrl.text.toLowerCase().contains('flag{')) {
                          setState(() {
                            final idx = _challenges.indexWhere(
                                (c) => c['id'] == challenge['id']);
                            if (idx >= 0) _challenges[idx]['solved'] = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '✓ Correct! +${challenge['xp']} XP'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✗ Wrong flag. Try again!'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onTap;

  const _ChallengeCard({required this.challenge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = challenge['color'] as Color;
    final solved = challenge['solved'] as bool;

    return CyberCard(
      onTap: solved ? null : onTap,
      borderColor: solved ? AppColors.primary.withOpacity(0.3) : color.withOpacity(0.25),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (solved ? AppColors.primary : color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              solved ? Icons.check_circle : (challenge['icon'] as IconData),
              color: solved ? AppColors.primary : color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge['title'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(challenge['desc'] as String,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(challenge['difficulty'])
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _getDifficultyColor(challenge['difficulty'])
                        .withOpacity(0.4),
                  ),
                ),
                child: Text(challenge['difficulty'] as String,
                    style: TextStyle(
                        color:
                            _getDifficultyColor(challenge['difficulty']),
                        fontSize: 9,
                        letterSpacing: 0.5)),
              ),
              const SizedBox(height: 6),
              Text(solved ? 'SOLVED' : '+${challenge['xp']} XP',
                  style: TextStyle(
                      color: solved ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(dynamic difficulty) {
    switch (difficulty) {
      case 'EASY':
        return AppColors.primary;
      case 'MEDIUM':
        return Colors.orange;
      case 'HARD':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

class _StatBadge extends StatelessWidget {
  final String label, value;
  final Color color;

  const _StatBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 1.5)),
      ],
    );
  }
}
