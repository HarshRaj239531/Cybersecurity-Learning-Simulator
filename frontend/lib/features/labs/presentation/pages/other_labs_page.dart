import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

/// Generic lab placeholder for labs not yet fully built
class GenericLabPage extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String description;
  final List<String> topics;

  const GenericLabPage({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.description,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LAB: $title'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CyberCard(
              borderColor: color.withOpacity(0.3),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 52),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'TOPICS COVERED'),
            const SizedBox(height: 12),
            ...topics.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CyberCard(
                  borderColor: color.withOpacity(0.2),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: color, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(e.value,
                            style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: e.key * 80)),
              ),
            ),
            const SizedBox(height: 24),
            CyberCard(
              borderColor: AppColors.warning.withOpacity(0.3),
              child: const Row(
                children: [
                  Icon(Icons.construction, color: AppColors.warning),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This lab is under construction. Interactive playground coming soon!',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 24),
            CyberButton(
              text: 'START BASIC QUIZ (+50 XP)',
              color: color,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Quiz module coming soon!'),
                    backgroundColor: color,
                  ),
                );
              },
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }
}

class XssLabPage extends StatelessWidget {
  const XssLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'XSS ATTACK',
      color: AppColors.accent,
      icon: Icons.code_outlined,
      description:
          'Cross-Site Scripting allows attackers to inject malicious scripts into web pages viewed by other users.',
      topics: [
        'What is Cross-Site Scripting (XSS)',
        'Reflected vs Stored vs DOM-based XSS',
        'Injecting script tags into input fields',
        'Cookie theft via XSS',
        'Content Security Policy (CSP) as defense',
        'Input sanitization and output encoding',
      ],
    );
  }
}

class CsrfLabPage extends StatelessWidget {
  const CsrfLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'CSRF VULNERABILITY',
      color: Colors.orange,
      icon: Icons.sync_problem_outlined,
      description:
          'CSRF forces authenticated users to execute unwanted actions on web applications.',
      topics: [
        'What is Cross-Site Request Forgery',
        'How CSRF tokens work',
        'Creating malicious HTML forms',
        'Same-Site cookie attribute',
        'Referer header validation',
        'CSRF defense strategies',
      ],
    );
  }
}

class JwtLabPage extends StatelessWidget {
  const JwtLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'JWT EXPLOITS',
      color: AppColors.secondary,
      icon: Icons.token_outlined,
      description:
          'JSON Web Tokens can be vulnerable to algorithm confusion, weak secrets, and signature bypass attacks.',
      topics: [
        'How JWT tokens work (Header, Payload, Signature)',
        'None algorithm attack',
        'RS256 to HS256 confusion',
        'Weak secret brute forcing',
        'JWT claim manipulation',
        'Secure JWT implementation',
      ],
    );
  }
}

class NetworkSniffLabPage extends StatelessWidget {
  const NetworkSniffLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'NETWORK SNIFFING',
      color: Colors.teal,
      icon: Icons.wifi_outlined,
      description:
          'Packet sniffing captures network traffic to analyze data flowing between hosts.',
      topics: [
        'Wireshark packet capture basics',
        'HTTP vs HTTPS traffic analysis',
        'ARP poisoning for man-in-the-middle',
        'Password sniffing on HTTP',
        'Network topology mapping',
        'Using encryption to prevent sniffing',
      ],
    );
  }
}

class AuthBypassLabPage extends StatelessWidget {
  const AuthBypassLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'AUTHENTICATION BYPASS',
      color: AppColors.error,
      icon: Icons.no_encryption_outlined,
      description:
          'Bypass flawed authentication mechanisms to gain unauthorized access to systems.',
      topics: [
        'Weak session management',
        'Default credentials exploitation',
        'Password reset flow vulnerabilities',
        'Multi-factor auth bypass',
        'Cookie manipulation',
        'Secure authentication best practices',
      ],
    );
  }
}

class DnsSpoofLabPage extends StatelessWidget {
  const DnsSpoofLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'DNS SPOOFING',
      color: Colors.deepPurple,
      icon: Icons.dns_outlined,
      description:
          'DNS Spoofing redirects users to malicious servers by injecting false DNS records.',
      topics: [
        'How DNS resolution works',
        'DNS cache poisoning',
        'Creating fake DNS records',
        'DNSSEC as a defense',
        'Phishing via DNS spoofing',
        'Monitoring DNS traffic',
      ],
    );
  }
}

class EncryptionLabPage extends StatelessWidget {
  const EncryptionLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericLabPage(
      title: 'ENCRYPTION LABS',
      color: Colors.amber,
      icon: Icons.lock_outlined,
      description:
          'Explore cryptographic weaknesses including broken ciphers, key management flaws, and protocol attacks.',
      topics: [
        'Symmetric vs Asymmetric encryption',
        'Weak cipher detection (RC4, DES)',
        'Hash function vulnerabilities (MD5, SHA1)',
        'TLS/SSL downgrade attacks',
        'Key derivation function weaknesses',
        'Modern encryption standards (AES-256, RSA-4096)',
      ],
    );
  }
}
