import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await ref.read(authProvider.notifier).register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );
      context.pop(); // Go back to login
    } else if (mounted) {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Registration failed')),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CREATE ACCOUNT',
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(),
              const SizedBox(height: 8),
              Text('Register Agent',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(delay: 150.ms),
              const SizedBox(height: 32),
              CyberTextField(
                label: 'AGENT NAME',
                hint: 'shadow_walker',
                controller: _nameCtrl,
                prefixIcon: Icons.person_outline,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name is required' : null,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 16),
              CyberTextField(
                label: 'EMAIL',
                hint: 'agent@cyberverse.app',
                controller: _emailCtrl,
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Email is required' : null,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 16),
              CyberTextField(
                label: 'PASSWORD',
                controller: _passCtrl,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePass,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscurePass = !_obscurePass),
                  child: Icon(
                    _obscurePass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 32),
              GlowButton(
                text: 'CREATE ACCOUNT',
                onPressed: _register,
                color: AppColors.secondary,
                isLoading: isLoading,
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?',
                      style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('LOGIN',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}
