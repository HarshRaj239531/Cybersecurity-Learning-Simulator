import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class AppGuidePage extends StatefulWidget {
  const AppGuidePage({super.key});

  @override
  State<AppGuidePage> createState() => _AppGuidePageState();
}

class _AppGuidePageState extends State<AppGuidePage> {
  int _expandedIndex = 0;

  static const List<_GuideSection> _sections = [
    _GuideSection(
      icon: Icons.home,
      color: AppColors.primary,
      title: 'Dashboard',
      subtitle: 'Your mission control center',
      overview:
          'The Dashboard is your home base. Every time you log in, you land here and see a real-time snapshot of your progress.',
      steps: [
        _Step('📊 Stats Bar', 'Top row shows your XP, Rank, Streak and Level — all fetched live from the backend.'),
        _Step('⚡ XP Progress Bar', 'Shows how much XP you need to reach the next level. Every 500 XP = 1 level up.'),
        _Step('🎯 Active Missions', 'Displays your first 3 available labs with difficulty tags and XP rewards.'),
        _Step('🤖 AI Recommendation', 'Tapping this takes you to the AI Mentor for personalized guidance.'),
        _Step('⚡ Quick Start', 'Jump directly to CTF Challenges, Terminal Simulator, or Achievements.'),
        _Step('🕐 Recent Activity', 'Shows your real completed labs and solved CTF challenges — updates as you play.'),
      ],
    ),
    _GuideSection(
      icon: Icons.science,
      color: AppColors.secondary,
      title: 'Labs',
      subtitle: 'Hands-on cybersecurity training',
      overview:
          'Labs are interactive cybersecurity exercises. Each lab teaches a specific attack or defense technique through a guided simulation.',
      steps: [
        _Step('🔍 Browse Labs', 'Scroll through all labs — filtered by difficulty: BEGINNER, INTERMEDIATE, ADVANCED.'),
        _Step('▶ Start a Lab', 'Tap any lab card to open the lab environment with instructions and a terminal.'),
        _Step('💻 Terminal', 'Each lab has a simulated terminal where you practice commands and attacks safely.'),
        _Step('✅ Complete Lab', 'Tap "COMPLETE LAB" after finishing — your XP is instantly added and progress saved.'),
        _Step('📈 Progress Tracking', 'Completed labs show a green checkmark. Your profile updates automatically.'),
      ],
    ),
    _GuideSection(
      icon: Icons.flag,
      color: Color(0xFF00E5FF),
      title: 'CTF Challenges',
      subtitle: 'Capture The Flag competitions',
      overview:
          'CTF (Capture The Flag) is a cybersecurity competition format. Solve puzzles to find a hidden "flag" string and submit it to earn XP.',
      steps: [
        _Step('🏆 Pick a Challenge', 'Browse challenges by type: Crypto, Web, Forensics, Misc. Each has a difficulty rating.'),
        _Step('📖 Read the Challenge', 'Tap a challenge card to open the description — understand what you need to find.'),
        _Step('🔑 Find the Flag', 'Use your cybersecurity knowledge to solve the puzzle. Flags look like: FLAG{...}'),
        _Step('📤 Submit Flag', 'Enter the flag in the input field and tap SUBMIT. The backend verifies it instantly.'),
        _Step('💰 Earn XP', 'Correct flags instantly award XP to your account and are saved to your progress history.'),
        _Step('⚠ One Try', 'Challenges can be solved only once — no XP for re-submitting the same flag.'),
      ],
    ),
    _GuideSection(
      icon: Icons.psychology,
      color: AppColors.accent,
      title: 'AI Mentor',
      subtitle: 'Your personal cybersecurity guide',
      overview:
          'The AI Mentor is a built-in chatbot trained on cybersecurity topics. Ask anything — it explains concepts, suggests labs, and quizzes you.',
      steps: [
        _Step('💬 Start Chatting', 'Type any cybersecurity question in the text box and tap Send.'),
        _Step('🎯 Suggested Topics', 'Tap the quick-suggestion chips at the top for common questions like "Explain SQL Injection".'),
        _Step('📚 Get Explanations', 'The mentor explains attack types, defense strategies, tools like Nmap, Burp Suite, etc.'),
        _Step('🧠 Take a Quiz', 'Type "Quiz me on [topic]" to get a quiz question — test your knowledge!'),
        _Step('📜 Chat History', 'Your conversation history is saved to the backend — it persists across sessions.'),
      ],
    ),
    _GuideSection(
      icon: Icons.person,
      color: Colors.orange,
      title: 'Profile',
      subtitle: 'Your agent identity and stats',
      overview:
          'Your Profile page shows all your stats, completed labs, solved CTF challenges, and earned achievements pulled directly from the server.',
      steps: [
        _Step('👤 Identity Card', 'Shows your username, level, XP bar, and rank number.'),
        _Step('📊 Stats Grid', 'Labs completed, CTF challenges solved, badges earned, and total XP — all real-time.'),
        _Step('🔬 Lab History', 'Scrollable list of every lab you have completed with XP earned.'),
        _Step('🏴 CTF History', 'Every CTF flag you have captured, shown with challenge name.'),
        _Step('🏅 Achievements', 'Earned badges appear here — complete labs and CTFs to unlock them.'),
        _Step('✏ Edit Profile', 'Tap the edit button to update your username via the backend API.'),
      ],
    ),
    _GuideSection(
      icon: Icons.leaderboard,
      color: Colors.amber,
      title: 'Leaderboard',
      subtitle: 'Global rankings by XP',
      overview:
          'The Leaderboard shows all users ranked by XP. Complete labs and CTF challenges to earn XP and climb the global rankings.',
      steps: [
        _Step('🌍 Global Rankings', 'All registered users are ranked by total XP earned from labs and CTF.'),
        _Step('🥇 Top Agents', 'Top 3 users get gold, silver, bronze medal highlights.'),
        _Step('📍 Your Position', 'Your own rank is highlighted so you can quickly see where you stand.'),
        _Step('🔄 Live Data', 'Rankings update in real-time as users complete labs and submit flags.'),
      ],
    ),
    _GuideSection(
      icon: Icons.emoji_events,
      color: Colors.deepOrange,
      title: 'Achievements',
      subtitle: 'Badges for your accomplishments',
      overview:
          'Achievements are badges you earn by hitting milestones. Complete your first lab, reach a streak, solve CTFs — each unlocks a badge.',
      steps: [
        _Step('🏅 Earned Badges', 'Glowing colored badges you have already unlocked appear at the top.'),
        _Step('🔒 Locked Badges', 'Greyed-out badges show what you still need to accomplish.'),
        _Step('📈 Progress Bar', 'Shows overall completion percentage of all available achievements.'),
        _Step('🎯 How to Earn', 'Complete labs → First Blood. Reach Level 5 → Rookie Hacker. Login streaks → streak badges.'),
      ],
    ),
    _GuideSection(
      icon: Icons.terminal,
      color: Colors.green,
      title: 'Terminal',
      subtitle: 'Simulated Linux terminal',
      overview:
          'The Terminal Simulator lets you practice real Linux and cybersecurity commands in a safe, sandboxed environment.',
      steps: [
        _Step('💻 Type Commands', 'Enter any Linux command and press Enter — the simulator responds like a real terminal.'),
        _Step('🛠 Supported Tools', 'Try: ls, cat, whoami, nmap, ping, curl, grep, find, chmod, and more.'),
        _Step('🔐 Hacking Tools', 'Practice: sqlmap, hydra, metasploit syntax, netcat, john, hashcat commands.'),
        _Step('📜 History', 'Use ↑ Arrow key to cycle through previous commands — just like a real terminal.'),
        _Step('🧹 Clear Screen', 'Type "clear" or press the trash icon to reset the terminal output.'),
      ],
    ),
    _GuideSection(
      icon: Icons.settings,
      color: AppColors.textSecondary,
      title: 'Settings',
      subtitle: 'App preferences and account',
      overview:
          'Settings lets you manage your account security, notification preferences, and navigate to other profile features.',
      steps: [
        _Step('🔑 Change Password', 'Tap "Change Password" → enter current and new password → hits the backend API securely.'),
        _Step('🔔 Notifications', 'Toggle push notifications and sound effects on/off.'),
        _Step('🎨 Theme', 'Switch between Cyberpunk, Matrix, Midnight, and Neon Noir visual themes.'),
        _Step('📊 My Progress', 'Shortcut to your Profile page showing completed labs and CTF stats.'),
        _Step('🚪 Logout', 'Clears your JWT token and returns you to the login screen.'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APP GUIDE', style: TextStyle(letterSpacing: 2)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  border:
                      Border.all(color: AppColors.primary.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_sections.length} SECTIONS',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.secondary.withOpacity(0.08),
                ],
              ),
              border: Border(
                bottom:
                    BorderSide(color: AppColors.primary.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.help_outline,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How CyberVerse Works',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary)),
                      SizedBox(height: 4),
                      Text(
                        'Tap any section to learn how it works and how to use it effectively.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Section List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                final isExpanded = _expandedIndex == index;
                return _SectionCard(
                  section: section,
                  isExpanded: isExpanded,
                  index: index,
                  onTap: () =>
                      setState(() => _expandedIndex = isExpanded ? -1 : index),
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: index * 60))
                    .slideX(begin: 0.05, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _GuideSection section;
  final bool isExpanded;
  final int index;
  final VoidCallback onTap;

  const _SectionCard({
    required this.section,
    required this.isExpanded,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isExpanded
              ? section.color.withOpacity(0.05)
              : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isExpanded
                ? section.color.withOpacity(0.5)
                : const Color(0xFF2A2A2A),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                      color: section.color.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Column(
          children: [
            // Header Row
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Number badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: section.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: section.color.withOpacity(0.4)),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                              color: section.color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: section.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Icon(section.icon, color: section.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(section.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isExpanded
                                      ? section.color
                                      : AppColors.textPrimary)),
                          Text(section.subtitle,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.expand_more,
                          color: section.color.withOpacity(0.7), size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Content
            if (isExpanded)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider
                    Container(
                        height: 1,
                        color: section.color.withOpacity(0.2),
                        margin: const EdgeInsets.only(bottom: 14)),

                    // Overview
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: section.color.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: section.color.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              color: section.color, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(section.overview,
                                style: TextStyle(
                                    color: section.color.withOpacity(0.9),
                                    fontSize: 12,
                                    height: 1.5)),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 50.ms).slideY(begin: -0.1),

                    const SizedBox(height: 14),

                    // Step-by-step
                    Text('HOW TO USE',
                        style: TextStyle(
                            color: section.color,
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    ...section.steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: section.color.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: section.color.withOpacity(0.3)),
                              ),
                              child: Center(
                                child: Text('${i + 1}',
                                    style: TextStyle(
                                        color: section.color,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(step.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: AppColors.textPrimary)),
                                  const SizedBox(height: 2),
                                  Text(step.description,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                          height: 1.4)),
                                ],
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 80 + i * 40))
                            .slideX(begin: 0.05),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GuideSection {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String overview;
  final List<_Step> steps;

  const _GuideSection({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.steps,
  });
}

class _Step {
  final String title;
  final String description;
  const _Step(this.title, this.description);
}
