import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isLoading = false;
  bool canResend = false;
  int timerSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    newPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timerSeconds = 60;
    canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // ------------------ Verify OTP and Reset Password ------------------
  void _verifyAndResetPassword() async {
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (otp.isEmpty || newPassword.isEmpty) {
      _showMessage("All fields are required");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.107:5000/password/verify-reset"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otp,
          "newPassword": newPassword,
        }),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showMessage(data['message']);
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final data = jsonDecode(response.body);
        _showMessage(data['error'] ?? "Something went wrong");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage("Failed to connect to server");
    }
  }

  // ------------------ Resend OTP ------------------
  void _resendOTP() async {
    setState(() => canResend = false);
    startTimer();

    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.107:5000/password/request-reset"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": widget.email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showMessage("OTP resent: ${data['message']}");
      } else {
        final data = jsonDecode(response.body);
        _showMessage(data['error'] ?? "Failed to resend OTP");
      }
    } catch (e) {
      _showMessage("Failed to connect to server");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              decoration: InputDecoration(
                labelText: "Enter OTP",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),

              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                // border: OutlineInputBorder(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ------------------ Resend OTP & Timer ------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Resend OTP in ${timerSeconds}s",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.color!.withOpacity(0.8),
                  ),
                  // style: const TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: canResend ? _resendOTP : null,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: canResend
                          ? Theme.of(context).primaryColor
                          : Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color!.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verifyAndResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Text(
                        "Reset Password",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
