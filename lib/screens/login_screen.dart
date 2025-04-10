import 'package:counting_and_sequencing/screens/home.dart';
import 'package:counting_and_sequencing/utils/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'signup_screen.dart';
import 'welcome_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school,
                        size: 100,
                        color: Colors.white,
                      ).animate().fade(duration: 500.ms).scale(delay: 300.ms),
                      const SizedBox(height: 30),
                      Text(
                        'Welcome Back!',
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
                      _buildTextField(
                        icon: Icons.person,
                        hintText: 'Email',
                        delay: 400,
                        controller: _emailController,
                      ),
                      _buildTextField(
                        icon: Icons.lock,
                        hintText: 'Password',
                        isPassword: true,
                        delay: 600,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 40),
                      _buildLoginButton()
                          .animate()
                          .fade(duration: 500.ms)
                          .scale(delay: 800.ms),
                      const SizedBox(height: 20),
                      _buildSignUpText(context)
                          .animate()
                          .fade(duration: 500.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              delay: 1000.ms,
                              curve: Curves.easeOut),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    bool isPassword = false,
    required int delay,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.purple[400]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.purple[400],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    )
        .animate()
        .fade(duration: 500.ms)
        .slideX(begin: -0.2, end: 0, delay: delay.ms, curve: Curves.easeOut);
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();
          final user = await _authService.login(email, password);

          if (user != null) {
            // 👇 Email verification check
            if (!user.emailVerified) {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please verify your email before logging in.'),
                ),
              );
              return;
            }

            // ✅ Verified — proceed to home
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${user.email}!')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed. Please try again.')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple[700],
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: const Text(
        "Don't have an account? Sign Up",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
