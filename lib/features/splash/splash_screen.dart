import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/core/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _startAnimations();
    _redirectUser();
  }

  void _startAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // slower = premium
    );

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutExpo),
    );

    _logoFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeInOut),
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _taglineController.forward();
    });
  }

  void _redirectUser() async {
    final auth = AuthService();
    final loggedIn = await auth.isLoggedIn();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        loggedIn ? AppRoutes.mainNavBar : AppRoutes.signup,
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoController,
              builder: (_, __) {
                return FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: theme.colorScheme.primary.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/splash_screen_icon.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            FadeTransition(
              opacity: _logoFade,
              child: Text(
                "CUETBus",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 10),

            FadeTransition(
              opacity: _taglineFade,
              child: Text(
                "Reserve seats. Ride fair.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.65),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SlowLoader(color: theme.colorScheme.primary),

            const SizedBox(height: 80),

            FadeTransition(
              opacity: _taglineFade,
              child: Text(
                "Powered by CUET Transport",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlowLoader extends StatefulWidget {
  final Color color;
  const SlowLoader({required this.color});

  @override
  State<SlowLoader> createState() => _SlowLoaderState();
}

class _SlowLoaderState extends State<SlowLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Slow, premium rotation ⚡
    )..repeat(); // infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(widget.color),
        ),
      ),
    );
  }
}
