import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class SqlInjectionLabPage extends StatefulWidget {
  const SqlInjectionLabPage({super.key});

  @override
  State<SqlInjectionLabPage> createState() => _SqlInjectionLabPageState();
}

class _SqlInjectionLabPageState extends State<SqlInjectionLabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inputCtrl = TextEditingController();
  String _terminalOutput = 'System ready. Enter a payload in the search field...';
  bool _isAttackSuccess = false;
  bool _isRunning = false;
  int _currentQuizAnswer = -1;
  bool _quizSubmitted = false;

  static const String _hint = "Try: ' OR '1'='1";
  static const String _successPayload = "' or '1'='1";

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'What makes SQL Injection possible?',
      'options': [
        'Strong input validation',
        'Unvalidated user input in SQL queries',
        'Encrypted database',
        'Strong passwords',
      ],
      'answer': 1,
    },
  ];

  void _runAttack() async {
    if (_isRunning) return;
    final input = _inputCtrl.text.toLowerCase().trim();
    setState(() {
      _isRunning = true;
      _terminalOutput = 'Executing query...\n\n> SELECT * FROM users WHERE username = \'$input\'\n';
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    if (input.contains("' or '1'='1") ||
        input.contains("'or'1'='1") ||
        input.contains("' or 1=1") ||
        input.contains("1=1")) {
      setState(() {
        _terminalOutput = '''Executing query...

> SELECT * FROM users WHERE username = '$input'

[!] QUERY BYPASS DETECTED
[+] Condition is always TRUE

RESULTS EXTRACTED:
┌─────────┬──────────────────────────┐
│ ID      │ Username    │ Role       │
├─────────┼─────────────┼────────────┤
│ 1       │ admin       │ SUPERADMIN │
│ 2       │ root        │ ADMIN      │
│ 3       │ guest       │ USER       │
│ 4       │ neo_hacker  │ USER       │
└─────────┴─────────────┴────────────┘

[✓] SUCCESS: Database extracted! +250 XP
''';
        _isAttackSuccess = true;
        _isRunning = false;
      });
    } else {
      setState(() {
        _terminalOutput = '''Executing query...

> SELECT * FROM users WHERE username = '$input'

[✗] No results found for user: "$input"

Hint: Try manipulating the WHERE clause...
$_hint''';
        _isAttackSuccess = false;
        _isRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAB: SQL INJECTION'),
        actions: [
          if (_isAttackSuccess)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                  SizedBox(width: 4),
                  Text('+250 XP',
                      style: TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ).animate().fadeIn().scale(),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'THEORY'),
            Tab(text: 'PLAYGROUND'),
            Tab(text: 'DEFENSE'),
            Tab(text: 'QUIZ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TheoryTab(),
          _PlaygroundTab(
            inputCtrl: _inputCtrl,
            terminalOutput: _terminalOutput,
            isAttackSuccess: _isAttackSuccess,
            isRunning: _isRunning,
            onRun: _runAttack,
            onHint: () => _inputCtrl.text = _hint,
            onNext: () => _tabController.animateTo(2),
          ),
          _DefenseTab(),
          _QuizTab(
            questions: _quizQuestions,
            selectedAnswer: _currentQuizAnswer,
            submitted: _quizSubmitted,
            onAnswer: (i) => setState(() => _currentQuizAnswer = i),
            onSubmit: () => setState(() => _quizSubmitted = true),
          ),
        ],
      ),
    );
  }
}

class _TheoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CyberCard(
            borderColor: AppColors.primary.withOpacity(0.3),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text('OBJECTIVE',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Learn how SQL Injection works by bypassing a vulnerable login system and extracting all user data from the database.',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          const SectionHeader(title: 'WHAT IS SQL INJECTION?'),
          const SizedBox(height: 12),
          CyberCard(
            child: const Text(
              'SQL Injection (SQLi) is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database.\n\nIt generally allows attackers to view data they are not normally able to retrieve. This might include data belonging to other users, or any other data that the application itself is able to access.',
              style: TextStyle(
                  color: AppColors.textSecondary, height: 1.6, fontSize: 13),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),
          const SectionHeader(title: 'VULNERABLE QUERY EXAMPLE'),
          const SizedBox(height: 12),
          const TerminalBox(
            content: '''// VULNERABLE CODE (PHP)
\$username = \$_POST['username'];
\$query = "SELECT * FROM users 
           WHERE username = '\$username'";

// If username = ' OR '1'='1
// Final query becomes:
// SELECT * FROM users 
// WHERE username = '' OR '1'='1'
// This returns ALL users!''',
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          const SectionHeader(title: 'ATTACK TYPES'),
          const SizedBox(height: 12),
          ...[
            ['In-band SQLi', 'Result returned directly in the application response'],
            ['Blind SQLi', 'No direct output, infer results from app behavior'],
            ['Time-based SQLi', 'Use time delays to extract data'],
            ['UNION-based SQLi', 'Retrieve data from other database tables'],
          ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CyberCard(
                  borderColor: AppColors.secondary.withOpacity(0.2),
                  child: Row(
                    children: [
                      const Icon(Icons.chevron_right,
                          color: AppColors.secondary, size: 18),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item[0],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(item[1],
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _PlaygroundTab extends StatelessWidget {
  final TextEditingController inputCtrl;
  final String terminalOutput;
  final bool isAttackSuccess, isRunning;
  final VoidCallback onRun, onHint, onNext;

  const _PlaygroundTab({
    required this.inputCtrl,
    required this.terminalOutput,
    required this.isAttackSuccess,
    required this.isRunning,
    required this.onRun,
    required this.onHint,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CyberCard(
            borderColor: AppColors.error.withOpacity(0.3),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bug_report_outlined, color: AppColors.error, size: 18),
                    SizedBox(width: 8),
                    Text('VULNERABLE LOGIN FORM',
                        style: TextStyle(
                            color: AppColors.error,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text('This form directly injects user input into a SQL query.',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: inputCtrl,
            style: const TextStyle(
                fontFamily: 'monospace', color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'USERNAME (inject payload here)',
              hintText: "' OR '1'='1",
              prefixIcon: const Icon(Icons.terminal, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.lightbulb_outline, color: AppColors.accent),
                onPressed: onHint,
                tooltip: 'Show hint',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GlowButton(
                  text: isRunning ? 'RUNNING...' : 'EXECUTE ATTACK',
                  onPressed: onRun,
                  isLoading: isRunning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('TERMINAL OUTPUT',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  letterSpacing: 2)),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isAttackSuccess
                      ? AppColors.primary.withOpacity(0.5)
                      : const Color(0xFF333333),
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  terminalOutput,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: isAttackSuccess ? AppColors.primary : const Color(0xFF888888),
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
          if (isAttackSuccess) ...[
            const SizedBox(height: 12),
            GlowButton(
              text: 'NEXT: DEFENSE TECHNIQUES',
              onPressed: onNext,
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          ],
        ],
      ),
    );
  }
}

class _DefenseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'HOW TO PREVENT SQL INJECTION', color: AppColors.primary),
          const SizedBox(height: 16),
          const TerminalBox(
            content: '''// ✓ SECURE: Parameterized Queries (PHP PDO)
\$stmt = \$pdo->prepare(
  "SELECT * FROM users WHERE username = ?"
);
\$stmt->execute([\$username]);

// ✓ SECURE: Prepared Statements (Python)
cursor.execute(
  "SELECT * FROM users WHERE username = %s",
  (username,)
)''',
            textColor: AppColors.primary,
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          ...['Use Parameterized Queries / Prepared Statements', 'Validate and sanitize all user inputs', 'Use an ORM (Object Relational Mapper)', 'Apply principle of least privilege to DB users', 'Enable WAF (Web Application Firewall)', 'Regularly audit and test your SQL queries'].asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CyberCard(
                borderColor: AppColors.primary.withOpacity(0.2),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.15),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                      ),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(fontSize: 13, height: 1.4)),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: e.key * 80)),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizTab extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int selectedAnswer;
  final bool submitted;
  final Function(int) onAnswer;
  final VoidCallback onSubmit;

  const _QuizTab({
    required this.questions,
    required this.selectedAnswer,
    required this.submitted,
    required this.onAnswer,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final q = questions[0];
    final correctAnswer = q['answer'] as int;
    final isCorrect = selectedAnswer == correctAnswer;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CyberCard(
            borderColor: AppColors.secondary.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('QUESTION 1/1',
                    style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 11,
                        letterSpacing: 2)),
                const SizedBox(height: 12),
                Text(q['question'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, height: 1.4)),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          ...(q['options'] as List<String>).asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            Color borderColor = const Color(0xFF333333);
            Color textColor = AppColors.textPrimary;
            if (submitted) {
              if (i == correctAnswer) {
                borderColor = AppColors.primary;
                textColor = AppColors.primary;
              } else if (i == selectedAnswer && i != correctAnswer) {
                borderColor = AppColors.error;
                textColor = AppColors.error;
              }
            } else if (i == selectedAnswer) {
              borderColor = AppColors.accent;
              textColor = AppColors.accent;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: submitted ? null : () => onAnswer(i),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                    color: borderColor.withOpacity(0.07),
                  ),
                  child: Row(
                    children: [
                      Text(String.fromCharCode(65 + i),
                          style: TextStyle(
                              color: borderColor,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(opt,
                              style: TextStyle(color: textColor))),
                      if (submitted && i == correctAnswer)
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 18),
                      if (submitted && i == selectedAnswer && i != correctAnswer)
                        const Icon(Icons.cancel, color: AppColors.error, size: 18),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: i * 80)),
            );
          }),
          const SizedBox(height: 24),
          if (!submitted)
            GlowButton(
              text: 'SUBMIT ANSWER',
              onPressed: selectedAnswer >= 0 ? onSubmit : null,
            )
          else
            CyberCard(
              borderColor: isCorrect
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.error.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? AppColors.primary : AppColors.error,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCorrect ? 'CORRECT! +50 XP' : 'INCORRECT',
                          style: TextStyle(
                            color: isCorrect ? AppColors.primary : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Unvalidated input directly into SQL queries causes SQL Injection.',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
        ],
      ),
    );
  }
}
