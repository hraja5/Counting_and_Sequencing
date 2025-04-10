import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'login_screen.dart';
import 'welcome_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final User user;
  const VerifyEmailScreen({super.key, required this.user});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;
  bool isEmailSent = false;
  bool canResend = true;
  int resendCountdown = 0;
  Timer? _timer;

  Future<void> _sendVerificationEmail() async {
    await widget.user.sendEmailVerification();
    setState(() {
      isEmailSent = true;
      canResend = false;
      resendCountdown = 30;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification email sent.")),
    );
    _startResendCooldown();
  }

  void _startResendCooldown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown > 0) {
        setState(() {
          resendCountdown--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _checkIfVerified() async {
    await widget.user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    if (refreshedUser != null && refreshedUser.emailVerified) {
      setState(() {
        isVerified = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User yet to be verified.")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[400]!, Colors.purple[500]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_read,
                    size: 100,
                    color: Colors.white,
                  ).animate().fade(duration: 500.ms).scale(delay: 300.ms),
                  const SizedBox(height: 30),
                  Text(
                    isVerified ? 'User Verified!' : 'Verify Your Email! ✉️',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 500.ms).slideY(
                      begin: -0.2,
                      end: 0,
                      delay: 200.ms,
                      curve: Curves.easeOut),
                  const SizedBox(height: 50),
                  if (!isVerified) ...[
                    ElevatedButton(
                      onPressed: canResend ? _sendVerificationEmail : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple[700],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        canResend
                            ? 'Send Verification Email'
                            : 'Wait $resendCountdown s',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ).animate().scale(delay: 500.ms),
                    const SizedBox(height: 20),
                    if (isEmailSent)
                      ElevatedButton(
                        onPressed: _checkIfVerified,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "I've Verified",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ).animate().scale(delay: 700.ms),
                  ] else
                    Column(
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.greenAccent,
                          size: 80,
                        ).animate().scale(delay: 300.ms).fadeIn(),
                        const SizedBox(height: 20),
                        const Text(
                          'User successfully verified! Redirecting to login... 🌟',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ).animate().fade(duration: 500.ms).slideY(),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
