import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/repository_providers.dart';

class MentorAiPage extends ConsumerStatefulWidget {
  const MentorAiPage({super.key});

  @override
  ConsumerState<MentorAiPage> createState() => _MentorAiPageState();
}

class _MentorAiPageState extends ConsumerState<MentorAiPage> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'ai',
      'text':
          'Hello, Agent. I am your AI Security Mentor. I can explain vulnerabilities, suggest labs, generate quizzes, and guide your learning path. How can I assist you today?',
    },
  ];

  final List<String> _suggestedQuestions = [
    'Explain SQL Injection',
    'What is XSS attack?',
    'How does JWT work?',
    'Suggest a lab for beginners',
    'Quiz me on network security',
    'What is CSRF?',
  ];

  final Map<String, String> _aiResponses = {
    'explain sql injection':
        'SQL Injection (SQLi) is a vulnerability where attackers insert malicious SQL code into a query. For example, entering \' OR \'1\'=\'1 in a login form can bypass authentication by making the WHERE clause always true.\n\n**Prevention:**\n• Use parameterized queries\n• Validate all inputs\n• Use an ORM\n\nWant me to open the SQL Injection lab? 🎯',
    'what is xss attack':
        'Cross-Site Scripting (XSS) allows attackers to inject malicious scripts into web pages that are then executed by other users\' browsers.\n\n**Types:**\n• Reflected XSS - script in request\n• Stored XSS - script saved in DB\n• DOM-based XSS - client-side only\n\n**Defense:** Use Content Security Policy (CSP) and sanitize output.',
    'how does jwt work':
        'JSON Web Tokens (JWT) consist of 3 parts:\n\n1. **Header** - Algorithm type (e.g., HS256)\n2. **Payload** - Claims (user data)\n3. **Signature** - Verification hash\n\nThey\'re signed with a secret or private key. Common attacks include None algorithm bypass and weak secret brute force.',
    'suggest a lab for beginners':
        'Great! For beginners, I recommend:\n\n1. **SQL Injection** - Most common and impactful\n2. **XSS Basics** - Understand DOM manipulation\n3. **Authentication Flaws** - Real-world scenarios\n\nStart with SQL Injection - it\'s the most educational for understanding how databases work under attack.',
    'quiz me on network security':
        'Quiz time! 🎯\n\n**Question:** What does ARP stand for?\n\nA) Address Resolution Protocol\nB) Advanced Router Protocol\nC) Application Routing Path\nD) Authenticated Request Protocol\n\nType your answer (A, B, C, or D)!',
    'what is csrf':
        'CSRF (Cross-Site Request Forgery) tricks authenticated users into executing unwanted actions.\n\n**Example:** A malicious page sends a hidden form to a bank, transferring money while you\'re logged in.\n\n**Defense:**\n• CSRF tokens in forms\n• SameSite cookie attribute\n• Verify Origin/Referer header',
  };

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    try {
      final history = await ref.read(mentorAiRepositoryProvider).getChatHistory();
      if (mounted) {
        setState(() {
          for (var chat in history) {
            _messages.add({'role': 'user', 'text': chat['message']});
            _messages.add({'role': 'ai', 'text': chat['response']});
          }
        });
        _scrollToBottom();
      }
    } catch (e) {
      // Quietly fail or show a hint
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _msgCtrl.clear();
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _scrollToBottom();
    
    try {
      final response = await ref.read(mentorAiRepositoryProvider).sendMessage(text);
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({'role': 'ai', 'text': response});
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'role': 'ai', 
            'text': 'Agent, I am having trouble connecting to the neural network. Please check your connection.'
          });
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology, color: AppColors.secondary, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI MENTOR', style: TextStyle(fontSize: 14, letterSpacing: 1)),
                Text('Online · Always learning',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        letterSpacing: 0.5)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isTyping && i == _messages.length) {
                  return _TypingIndicator();
                }
                final msg = _messages[i];
                return _ChatBubble(
                  message: msg['text'] as String,
                  isAi: msg['role'] == 'ai',
                ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.1, end: 0);
              },
            ),
          ),

          // Suggested Questions
          if (_messages.length <= 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedQuestions.map((q) {
                  return GestureDetector(
                    onTap: () => _sendMessage(q),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.secondary.withOpacity(0.3)),
                      ),
                      child: Text(q,
                          style: const TextStyle(
                              color: AppColors.secondary, fontSize: 12)),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                  top: BorderSide(color: Colors.grey.shade900)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Ask your mentor anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF333333)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_msgCtrl.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.4)),
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: AppColors.secondary, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isAi;

  const _ChatBubble({required this.message, required this.isAi});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isAi
              ? AppColors.secondary.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isAi ? 2 : 12),
            bottomRight: Radius.circular(isAi ? 12 : 2),
          ),
          border: Border.all(
            color: isAi
                ? AppColors.secondary.withOpacity(0.25)
                : const Color(0xFF333333),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAi)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.psychology, color: AppColors.secondary, size: 14),
                    SizedBox(width: 4),
                    Text('AI MENTOR',
                        style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            Text(
              message,
              style: const TextStyle(
                  fontSize: 13, height: 1.6, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.08),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(2),
          ),
          border:
              Border.all(color: AppColors.secondary.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scaleXY(
                  begin: 0.6,
                  end: 1.0,
                  duration: 600.ms,
                  delay: Duration(milliseconds: i * 200),
                  curve: Curves.easeInOut,
                );
          }),
        ),
      ),
    );
  }
}
