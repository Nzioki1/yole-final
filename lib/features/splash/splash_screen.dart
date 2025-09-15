import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../core/auth/auth_provider.dart';

/// Splash screen - shows while app initializes
/// Implements the Figma design with sparkles and gradient background
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _sparkleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<SparkleData> _sparkles = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateSparkles();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
    _sparkleController.repeat();
  }

  void _generateSparkles() {
    final random = Random();
    for (int i = 0; i < 120; i++) {
      _sparkles.add(
        SparkleData(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 0.7 + 0.5,
          opacity: random.nextDouble() * 0.25 + 0.35,
          delay: random.nextDouble(),
        ),
      );
    }
  }

  void _navigateToNextScreen() async {
    // Simulate app initialization - longer delay to show the beautiful splash
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      final authState = ref.read(authProvider);

      if (authState.isAuthenticated) {
        // User is logged in, go to home
        context.go('/home');
      } else {
        // User is not logged in, show welcome/register flow
        context.go('/register');
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0B0F19), const Color(0xFF19173D)]
                : [const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // Sparkle layer
            _buildSparkleLayer(),

            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Top spacer
                    const Spacer(),

                    // Logo and title section
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              children: [
                                // YOLE Logo
                                Text(
                                  'YOLE',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -2,
                                    height: 0.9,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Middle section with tagline and buttons
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 0.7),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Container(
                              margin: const EdgeInsets.only(top: 32),
                              child: Column(
                                children: [
                                  // Tagline
                                  Text(
                                    'Send money to the DRC quickly and securely',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      color: isDark
                                          ? Colors.white.withOpacity(0.7)
                                          : const Color(0xFF64748B),
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),

                                  const SizedBox(height: 32),

                                  // Get Started button
                                  Container(
                                    width: double.infinity,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF3B82F6),
                                          Color(0xFF8B5CF6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF3B82F6,
                                          ).withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () => context.go('/home'),
                                        child: const Center(
                                          child: Text(
                                            'Get started',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Log In button
                                  TextButton(
                                    onPressed: () => context.go('/login'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: isDark
                                          ? Colors.white.withOpacity(0.8)
                                          : const Color(0xFF475569),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Bottom spacer
                    const Spacer(),

                    // Language selector
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            child: TextButton.icon(
                              onPressed: () {
                                // TODO: Show language selector
                              },
                              icon: const Text(
                                '🇺🇸',
                                style: TextStyle(fontSize: 16),
                              ),
                              label: Text(
                                'English',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.7)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: isDark
                                    ? Colors.white.withOpacity(0.7)
                                    : const Color(0xFF64748B),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkleLayer() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return CustomPaint(
          painter: SparklePainter(_sparkles, _sparkleController.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class SparkleData {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double delay;

  SparkleData({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.delay,
  });
}

class SparklePainter extends CustomPainter {
  final List<SparkleData> sparkles;
  final double animationValue;

  SparklePainter(this.sparkles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final sparkle in sparkles) {
      final x = sparkle.x * size.width;
      final y = sparkle.y * size.height;

      // Animate sparkle opacity and position
      final progress = (animationValue + sparkle.delay) % 1.0;
      final opacity = sparkle.opacity * (1.0 - progress * 0.2);
      final offsetY = sin(progress * 2 * pi) * 3;

      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(Offset(x, y + offsetY), sparkle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
