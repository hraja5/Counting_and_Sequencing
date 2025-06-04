import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:counting_and_sequencing/utils/language_controller.dart';
import 'package:counting_and_sequencing/widgets/language_toggle_button.dart';

import 'package:counting_and_sequencing/screens/shell_counting_game.dart';
import 'count_match_demo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'sequence_demo.dart';

class DemoGame extends StatefulWidget {
  const DemoGame({super.key});

  @override
  State<DemoGame> createState() => _DemoGameState();
}

class _DemoGameState extends State<DemoGame> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _randomOffsets;
  late AnimationController _waveController;

  late AnimationController _floatController;
  late Animation<Offset> _floatingAnimation;

  static Offset _generateRandomOffset() {
    final random = math.Random();
    return Offset(
      (random.nextDouble() * 2 - 1) * 2.0,
      (random.nextDouble() * 2 - 1) * 2.4,
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<Offset>(
      begin: const Offset(0, -0.02),
      end: const Offset(0, 0.02),
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _randomOffsets = List.generate(4, (_) => _generateRandomOffset());
  }

  @override
  void dispose() {
    _controller.dispose();

    _waveController.dispose();

    _floatController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required int delayMs,
  }) {
    return Animate(
      effects: [
        SlideEffect(
            begin: const Offset(0, 0.4), duration: 600.ms, delay: delayMs.ms),
        FadeEffect(duration: 600.ms, delay: delayMs.ms),
        ScaleEffect(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
          duration: 600.ms,
          delay: delayMs.ms,
        )
      ],
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _animatedGlowingButton({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    required int delay,
  }) {
    return ElevatedButton.icon(
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.15),
        foregroundColor: Colors.white,
        shadowColor: Colors.white.withOpacity(0.3),
        elevation: 8,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          delay: delay.ms,
        )
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 1.seconds,
          curve: Curves.easeInOut,
        );
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Provider.of<LanguageController>(context);

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[300]!, Colors.purple[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: const LanguageToggleButton(),
            ),

            // Subtle background bubbles
            ...List.generate(12, (i) {
              final random = math.Random(i);
              final left = random.nextDouble() * screenSize.width;
              final bottom = random.nextDouble() * screenSize.height * 0.3;
              final size = random.nextDouble() * 8 + 4;

              return AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final dy = 30 * math.sin(_controller.value * 2 * math.pi + i);
                  final opacity =
                      0.1 + 0.1 * math.sin(_controller.value * 2 * math.pi + i);
                  return Positioned(
                    left: left,
                    bottom: bottom + dy,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              );
            }),

            // Soft-moving jellyfish in corners
            ...[
              Offset(0.1, 0.2),
              Offset(0.85, 0.15),
              Offset(0.1, 0.75),
              Offset(0.85, 0.7),
            ].map((offset) {
              final baseSize = 80.0;
              return AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final dx = offset.dx * screenSize.width +
                      10 * math.sin(_controller.value * 2 * math.pi);
                  final dy = offset.dy * screenSize.height +
                      10 * math.cos(_controller.value * 2 * math.pi);
                  final scale =
                      1 + 0.03 * math.sin(_controller.value * 2 * math.pi);
                  final opacity =
                      0.3 + 0.1 * math.sin(_controller.value * 2 * math.pi);

                  return Positioned(
                    left: dx - baseSize / 2,
                    top: dy - baseSize / 2,
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Image.asset(
                          'assets/jelly.png',
                          width: baseSize,
                          height: baseSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Seahorse in center with floating animation
            Positioned(
              top: screenSize.height * 0.18,
              left: screenSize.width * 0.5 - 70,
              child: SlideTransition(
                position: _floatingAnimation,
                child: Image.asset(
                  'assets/seahorse-2.png',
                  width: 140,
                  height: 140,
                ),
              ),
            ),

            // Title
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  languageController.translate("demo_game_zone"),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .shimmer(duration: 1800.ms, color: Colors.white54),
              ),
            ),
// Ocean wave at bottom with floating animation
            AnimatedBuilder(
              animation: _waveController,
              builder: (_, __) {
                final dx = 10 * math.sin(_waveController.value * 2 * math.pi);
                return Positioned(
                  bottom: 0,
                  left: dx,
                  right: -dx,
                  child: SvgPicture.asset(
                    'assets/ocean-wave.svg',
                    fit: BoxFit.fill,
                    height: 120,
                    color: Colors.white.withOpacity(0.15),
                  ),
                );
              },
            ),

            // Animated Buttons with glow
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _animatedGlowingButton(
                      icon: Image.asset(
                        'assets/numbers.png',
                        width: 24,
                        height: 24,
                      ),
                      label: languageController.translate("count_match_game"),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CountMatchDemo()),
                      ),
                      delay: 200,
                    ),
                    const SizedBox(height: 24),
                    _animatedGlowingButton(
                      icon: Image.asset(
                        'assets/sequence.png',
                        width: 24,
                        height: 24,
                      ),
                      label: languageController.translate("sequence_game"),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SequenceDemo()),
                      ),
                      delay: 400,
                    ),
                    const SizedBox(height: 24),
                    _animatedGlowingButton(
                      icon: Image.asset(
                        'assets/jellyfish.png',
                        width: 24,
                        height: 24,
                      ),
                      label: languageController.translate("mermaid_game"),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MermaidGame(isDemo: true)),
                      ),
                      delay: 600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
