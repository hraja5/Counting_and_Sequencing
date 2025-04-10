import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counting_and_sequencing/screens/login_screen.dart';
import 'package:counting_and_sequencing/screens/merma.dart';
import 'package:counting_and_sequencing/screens/mermaid_game.dart';
import 'package:counting_and_sequencing/screens/shell_counting_game.dart';
import 'package:counting_and_sequencing/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  Future<Map<String, dynamic>> _loadProgress() async {
    final user = AuthService().currentUser;

    if (user == null) {
      // Return guest metadata — redirect is handled in builder
      return {'level': 1, 'score': 0, 'email': 'Guest'};
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('progress')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      return {
        'level': data['level'] ?? 1,
        'score': data['score'] ?? 0,
        'email': user.email ?? 'N/A',
      };
    } else {
      return {'level': 1, 'score': 0, 'email': user.email ?? 'N/A'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Progress"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.blue.shade400],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _loadProgress(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;
            if (data['email'] == 'Guest') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              });
              return const SizedBox(); // Avoid rendering anything
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 100, color: Colors.white)
                      .animate()
                      .fade(duration: 500.ms)
                      .scale(delay: 300.ms),
                  const SizedBox(height: 20),
                  Text(
                    data['email'],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ).animate().fade(duration: 500.ms).slideY(
                      begin: -0.2,
                      end: 0,
                      delay: 400.ms,
                      curve: Curves.easeOut),
                  const SizedBox(height: 40),
                  Text(
                    'Level: ${data['level']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
                  const SizedBox(height: 10),
                  Text(
                    'Score: ${data['score']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fade(duration: 500.ms).scale(delay: 700.ms),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MermaidGame(isDemo: false),
                        ),
                      );
                    },
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
                    child: const Text(
                      "Continue Playing",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ).animate().fade(duration: 500.ms).scale(delay: 900.ms),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
