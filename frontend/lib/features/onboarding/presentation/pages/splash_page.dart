import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/components/shared_components.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated background grid
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(
                                0.3 + _glowController.value * 0.4),
                            blurRadius: 30 + _glowController.value * 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.security, size: 72, color: AppColors.primary),
                    );
                  },
                )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut),
                const SizedBox(height: 40),
                Text(
                  'CYBERVERSE',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 10,
                        fontWeight: FontWeight.w900,
                      ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5, end: 0),
                const SizedBox(height: 8),
                const Text(
                  'LEARNING SIMULATOR',
                  style: TextStyle(
                      color: AppColors.textSecondary, letterSpacing: 6, fontSize: 13),
                ).animate().fadeIn(delay: 900.ms),
                const SizedBox(height: 60),
                SizedBox(
                  width: 180,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    color: AppColors.primary,
                  ),
                ).animate().fadeIn(delay: 1200.ms),
                const SizedBox(height: 16),
                const Text(
                  'INITIALIZING SYSTEMS...',
                  style: TextStyle(
                      color: AppColors.textHint, letterSpacing: 2, fontSize: 11),
                ).animate().fadeIn(delay: 1400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.04)
      ..strokeWidth = 0.5;
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
