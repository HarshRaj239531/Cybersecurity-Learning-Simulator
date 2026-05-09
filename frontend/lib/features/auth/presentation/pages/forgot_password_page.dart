import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  void _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.push('/otp-verify');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_reset, color: AppColors.accent, size: 48)
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              const Text('RECOVER ACCESS',
                  style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Text('Forgot Password',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              const Text(
                'Enter your email address to receive a recovery code.',
                style: TextStyle(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 36),
              CyberTextField(
                label: 'EMAIL ADDRESS',
                hint: 'agent@cyberverse.app',
                controller: _emailCtrl,
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Email is required' : null,
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 32),
              CyberButton(
                text: 'SEND RECOVERY CODE',
                onPressed: _sendCode,
                color: AppColors.accent,
                isLoading: _isLoading,
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
