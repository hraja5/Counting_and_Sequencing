import 'package:counting_and_sequencing/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'verify_email_screen.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[400]!, Colors.blue[500]!],
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
                        Icons.app_registration,
                        size: 100,
                        color: Colors.white,
                      ).animate().fade(duration: 500.ms).scale(delay: 300.ms),
                      const SizedBox(height: 30),
                      Text(
                        'Create Account',
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
                        hintText: 'Username',
                        delay: 400,
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        icon: Icons.email,
                        hintText: 'Email',
                        delay: 600,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        icon: Icons.lock,
                        hintText: 'Password',
                        isPassword: true,
                        delay: 800,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 40),
                      _buildSignUpButton()
                          .animate()
                          .fade(duration: 500.ms)
                          .scale(delay: 1000.ms),
                      const SizedBox(height: 20),
                      _buildLoginText(context)
                          .animate()
                          .fade(duration: 500.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              delay: 1200.ms,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your ${hintText.toLowerCase()}';
          }
          return null;
        },
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

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final username = _usernameController.text.trim();
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();

          final user = await _authService.signUp(email, password);

          if (user != null) {
            await user.updateDisplayName(username);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup successful!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => VerifyEmailScreen(user: user)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup failed. Please try again.')),
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
        'Sign Up',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "Already have an account? Login",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
