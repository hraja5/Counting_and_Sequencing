import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home.dart'; // Your main home screen

class FeedbackPage extends StatefulWidget {
  final bool isCorrect;
  final Widget? nextPage; // Optional next screen to push
  final bool popInsteadOfPush; // If true, just pop instead of push
  final String? tryAgainText; // Optional override for "Try Again"
  final bool exitToHome; // Whether "Exit" goes to home or just pops

  const FeedbackPage({
    super.key,
    required this.isCorrect,
    this.nextPage,
    this.popInsteadOfPush = false,
    this.tryAgainText,
    this.exitToHome = true,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSound();
  }

  void _playSound() async {
    final sound =
        widget.isCorrect ? 'audio/game-correct.mp3' : 'audio/game-wrong.mp3';
    await player.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isCorrect ? 'Right Answer' : 'Wrong!',
          style: const TextStyle(fontSize: 30.0, color: Colors.black),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        color: Colors.purple[100],
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              widget.isCorrect
                  ? Icons.check_circle_outline
                  : Icons.cancel_presentation_outlined,
              size: 120,
              color: widget.isCorrect ? Colors.green : Colors.redAccent,
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                widget.isCorrect ? 'You Are Right!' : 'You Are Wrong!',
                style: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                if (widget.popInsteadOfPush) {
                  Navigator.pop(context);
                } else if (widget.nextPage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => widget.nextPage!),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isCorrect ? Colors.green : Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(120.0),
                ),
              ),
              child: Text(
                widget.isCorrect
                    ? 'Continue'
                    : widget.tryAgainText ?? 'Try Again',
                style: const TextStyle(fontSize: 30.0, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.exitToHome) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(120.0),
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(fontSize: 30.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
