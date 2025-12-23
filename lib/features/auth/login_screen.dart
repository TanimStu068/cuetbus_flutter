import 'package:flutter/material.dart';
import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _loginMessage;
  Color _messageColor = Colors.green;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  // Future<void> saveUserData({
  //   required String name,
  //   required String studentId,
  //   required String email,
  // }) async {
  //   final box = Hive.box('userBox');
  //   await box.put('name', name);
  //   await box.put('studentId', studentId);
  //   await box.put('email', email);
  // }

  @override
  void dispose() {
    _animationController.dispose();
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ----------------- LOGO HEADER ----------------- //
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.directions_bus_filled_rounded,
                        size: 52,
                        color: theme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ----------------- TITLE ----------------- //
                    Text(
                      "Welcome Back!",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue to CUETBus",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium!.color!.withOpacity(
                          0.7,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ----------------- STUDENT ID FIELD ----------------- //
                    _buildTextField(
                      controller: studentIdController,
                      label: "Student ID",
                      hint: "Enter your CUET student ID",
                      icon: Icons.person_rounded,
                      theme: theme,
                    ),

                    const SizedBox(height: 20),

                    // ----------------- PASSWORD FIELD ----------------- //
                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscure: true,
                      icon: Icons.lock_rounded,
                      theme: theme,
                    ),

                    const SizedBox(height: 14),

                    // ----------------- FORGOT PASSWORD ----------------- //
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ----------------- LOGIN BUTTON ----------------- //
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          elevation: 8,
                          shadowColor: theme.primaryColor.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    if (_loginMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _loginMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _messageColor,
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),
                    //signup row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have any account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium!.color,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.signup,
                            );
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 33),

                    // ----------------- FOOTER ----------------- //
                    Text(
                      "Powered by CUET Transport",
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium!.color!.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- CUSTOM TEXT FIELD ------------------- //
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure ? _obscurePassword : false,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium!.color,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        hintText: hint,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.primaryColor, width: 1.8),
        ),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: theme.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }

  // ------------------- LOGIN FUNCTION ------------------- //
  void _loginUser() async {
    final id = studentIdController.text.trim();
    final password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your credentials")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = 'u$id@student.cuet.ac.bd';
    final result = await _authService.login(email: email, password: password);

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      setState(() {
        _loginMessage = "Login successful";
        _messageColor = Theme.of(context).primaryColor;
      });
      Navigator.pushReplacementNamed(context, AppRoutes.mainNavBar);
    } else {
      setState(() {
        _loginMessage = result['message'];
        _messageColor = Colors.red;
      });
    }
  }
}
