import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../core/analytics/analytics_provider.dart';
import '../../core/network/dio_client.dart';
import '../../core/auth/auth_provider.dart';
import '../../data/repos/auth_repo.dart';
import '../../data/api/yole_api_client.dart';

/// Login screen - matches Figma design exactly
/// Implements PRD Section 6.1 New User → First Send:
/// - Login (email, password)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _showPassword = false;
  late AnimationController _sparkleController;
  final List<SparkleData> _sparkles = [];

  @override
  void initState() {
    super.initState();
    _initializeSparkles();
  }

  void _initializeSparkles() {
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    
    final random = Random();
    for (int i = 0; i < 80; i++) {
      _sparkles.add(SparkleData(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 0.8 + 0.4,
        opacity: random.nextDouble() * 0.3 + 0.2,
        delay: random.nextDouble(),
      ));
    }
    
    _sparkleController.repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final loginResult = await _authRepo.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Track successful login
      ref.read(analyticsProvider).authLoginSuccess();

      // Update auth state
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.login(
        userId: loginResult['userId'] ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
        userName: loginResult['name'] ?? 'User',
        userEmail: _emailController.text.trim(),
        isEmailVerified: loginResult['emailVerified'] ?? false,
        isKycComplete: loginResult['kycComplete'] ?? false,
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B0F19),
                    Color(0xFF19173D),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
                ),
        ),
        child: Stack(
          children: [
            // Sparkle layer for dark theme
            if (isDark)
              AnimatedBuilder(
                animation: _sparkleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SparklePainter(_sparkles, _sparkleController.value),
                    size: Size.infinite,
                  );
                },
              ),

            // Main content
            Column(
              children: [
                // Header
                Container(
                  padding: SpacingTokens.mdAll,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark 
                            ? Colors.white.withOpacity(0.1)
                            : colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        onPressed: () => context.go('/splash'),
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white : colorScheme.onSurface,
                        ),
                      ),
                      // Title
                      Expanded(
                        child: Text(
                          'Sign In',
                          style: textTheme.titleLarge?.copyWith(
                            color: isDark ? Colors.white : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Spacer
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: SpacingTokens.lgAll,
                    child: Column(
                      children: [
                        const SizedBox(height: 32),

                        // Logo & Welcome Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 48),
                          child: Column(
                            children: [
                              // YOLE Logo
                              Text(
                                'YOLE',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -2,
                                  color: isDark ? Colors.white : colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Welcome text
                              Text(
                                'Welcome back',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: isDark ? Colors.white : colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to your Yole account',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: isDark 
                                      ? Colors.white.withOpacity(0.7)
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Card (Glassmorphism for dark theme)
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          padding: SpacingTokens.lgAll,
                          decoration: BoxDecoration(
                            color: isDark 
                                ? Colors.white.withOpacity(0.12)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark 
                                  ? Colors.white.withOpacity(0.2)
                                  : colorScheme.outline.withOpacity(0.1),
                              width: 1.5,
                            ),
                            boxShadow: isDark ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ] : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  hint: 'Enter your email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter a valid email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Password
                                _buildTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  obscureText: !_showPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword ? Icons.visibility_off : Icons.visibility,
                                      color: isDark 
                                          ? Colors.white.withOpacity(0.6)
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 8),

                                // Forgot password link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => context.go('/forgot-password'),
                                    child: Text(
                                      'Forgot Password?',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  child: GradientButton(
                                    onPressed: _isLoading ? null : _login,
                                    child: _isLoading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                colorScheme.onPrimary,
                                              ),
                                            ),
                                          )
                                        : const Text('Sign In'),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Register link
                                Center(
                                  child: TextButton(
                                    onPressed: () => context.go('/register'),
                                    child: Text(
                                      "Don't have an account? Create one",
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: isDark 
                                            ? Colors.white.withOpacity(0.8)
                                            : colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isDark 
                ? Colors.white.withOpacity(0.9)
                : colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark 
                  ? Colors.white.withOpacity(0.5)
                  : colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: isDark 
                ? Colors.white.withOpacity(0.05)
                : colorScheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark 
                    ? Colors.white.withOpacity(0.2)
                    : colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark 
                    ? Colors.white.withOpacity(0.2)
                    : colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1,
              ),
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Get auth repo
  AuthRepository get _authRepo => AuthRepository(createYoleApiClient());
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
      final opacity = sparkle.opacity * (1.0 - progress * 0.3);
      final offsetY = sin(progress * 2 * pi) * 2;

      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(
        Offset(x, y + offsetY),
        sparkle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
