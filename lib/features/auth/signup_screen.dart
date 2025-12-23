import 'package:flutter/material.dart';
import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:cuetbus/core/services/auth_service.dart';
import 'package:hive/hive.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  final TapGestureRecognizer _termsRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _privacyRecognizer = TapGestureRecognizer();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final AuthService _authService = AuthService();

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

  Future<void> saveUserData({
    required String name,
    required String studentId,
    required String email,
  }) async {
    final box = Hive.box('userBox');
    await box.put('name', name);
    await box.put('studentId', studentId);
    await box.put('email', email);
  }

  @override
  void dispose() {
    _animationController.dispose();
    fullNameController.dispose();
    studentIdController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.directions_bus_filled_rounded,
                            size: 52,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Title
                        Text(
                          "Create Account",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign up to start using CUETBus",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 36),

                        // Input Fields
                        _buildTextField(
                          controller: fullNameController,
                          label: "Full Name",
                          hint: "Enter your full name",
                          icon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: studentIdController,
                          label: "Student ID",
                          hint: "Enter your CUET student ID",
                          icon: Icons.school_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: emailController,
                          label: "Email (must use CUET email)",
                          hint: "Enter your email",
                          icon: Icons.email_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: passwordController,
                          label: "Password",
                          hint: "Enter password",
                          icon: Icons.lock_rounded,
                          obscure: true,
                          toggleObscure: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          obscureValue: _obscurePassword,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: confirmPasswordController,
                          label: "Confirm Password",
                          hint: "Re-enter password",
                          icon: Icons.lock_rounded,
                          obscure: true,
                          toggleObscure: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                          obscureValue: _obscureConfirmPassword,
                        ),
                        const SizedBox(height: 20),

                        // Terms & Privacy
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeTerms,
                              onChanged: (val) =>
                                  setState(() => _agreeTerms = val!),
                              activeColor: theme.primaryColor,
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(
                                    color: theme.textTheme.bodySmall!.color,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: _termsRecognizer
                                        ..onTap = () => Navigator.pushNamed(
                                          context,
                                          AppRoutes.termsConditions,
                                        ),
                                    ),
                                    const TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: _privacyRecognizer
                                        ..onTap = () => Navigator.pushNamed(
                                          context,
                                          AppRoutes.privacyPolicy,
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signUpUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              elevation: 8,
                              shadowColor: theme.colorScheme.shadow.withOpacity(
                                theme.brightness == Brightness.dark ? 0.3 : 0.5,
                              ),
                              // shadowColor: theme.shadowColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: theme.textTheme.bodySmall,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.login),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Theme.of(context).cardColor,

                // color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Custom TextField with dynamic colors
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggleObscure,
    bool obscureValue = true,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure ? obscureValue : false,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
        filled: true,
        fillColor: Theme.of(context).cardColor,
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
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.8,
          ),
        ),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                  obscureValue ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: toggleObscure,
              )
            : null,
      ),
    );
  }

  // SignUp function remains unchanged
  void _signUpUser() async {
    final name = fullNameController.text.trim();
    final id = studentIdController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        id.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms & privacy")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signup(
        name: name,
        studentId: id,
        email: email,
        password: password,
      );
      if (result == "success") {
        await saveUserData(name: name, studentId: id, email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Account created successfully!",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
