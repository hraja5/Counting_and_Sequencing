import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_oranges.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';

class CountMatchApp extends StatelessWidget {
  const CountMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Count and Match App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const CountMatchHomePage(),
    );
  }
}

class CountMatchHomePage extends StatefulWidget {
  const CountMatchHomePage({super.key});

  @override
  State<CountMatchHomePage> createState() => _CountMatchHomePageState();
}

class _CountMatchHomePageState extends State<CountMatchHomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildRandomBubbles(Size screenSize) {
    final bubbles = <Widget>[];
    final random = math.Random();

    for (int i = 0; i < 25; i++) {
      final size = random.nextDouble() * 16 + 4;
      final left = random.nextDouble() * screenSize.width;
      final top = random.nextDouble() * screenSize.height;
      final dx = (random.nextDouble() - 0.5) * 2 * 20;
      final dy = (random.nextDouble() - 0.5) * 2 * 20;

      bubbles.add(
        Positioned(
          left: left,
          top: top,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2 + random.nextDouble() * 0.3),
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .move(
                duration: Duration(seconds: 3 + random.nextInt(4)),
                begin: Offset(0, 0),
                end: Offset(dx, dy),
                curve: Curves.easeInOut,
              ),
        ),
      );
    }

    return bubbles;
  }

  Widget _animatedFloatingButton() {
    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        FadeEffect(duration: 800.ms),
        ScaleEffect(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeInOutBack,
          duration: 600.ms,
        ),
        MoveEffect(
          duration: 1.seconds,
          begin: const Offset(0, 10),
          end: const Offset(0, -10),
          curve: Curves.easeInOut,
          delay: 300.ms,
        ),
      ],
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CountOrangesPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 50),
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 10,
        ),
        child: const Text(
          'Start Game!',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingAssets(Size screenSize) {
    return [
      // Top fishes
      Positioned(
        top: screenSize.height * 0.1,
        left: screenSize.width * 0.1,
        child: Image.asset(
          'assets/fishes.gif',
          width: 150,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .move(
              duration: 4.seconds,
              begin: const Offset(0, -5),
              end: const Offset(0, 5),
              curve: Curves.easeInOut,
            ),
      ),
      // Bottom fishes
      Positioned(
        bottom: screenSize.height * 0.12,
        right: screenSize.width * 0.1,
        child: Image.asset(
          'assets/fishes.gif',
          width: 300,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .move(
              duration: 5.seconds,
              begin: const Offset(0, -6),
              end: const Offset(0, 6),
              curve: Curves.easeInOut,
            ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: Stack(
          children: [
            // Bubble background
            ..._buildRandomBubbles(screenSize),

            // Game Title
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  'Count & Match Game!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .shimmer(duration: 2.seconds, color: Colors.white54),
              ),
            ),

            // Two fish positions
            ..._buildFloatingAssets(screenSize),

            // Start Button
            Center(
              child: _animatedFloatingButton(),
            ),
          ],
        ),
      ),
    );
  }
}
