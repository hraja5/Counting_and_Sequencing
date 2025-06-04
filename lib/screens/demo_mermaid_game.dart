import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:counting_and_sequencing/utils/language_controller.dart';
import 'package:counting_and_sequencing/widgets/language_toggle_button.dart';

class DemoMermaidGame extends StatefulWidget {
  const DemoMermaidGame({super.key});

  @override
  _DemoMermaidGameState createState() => _DemoMermaidGameState();
}

class _DemoMermaidGameState extends State<DemoMermaidGame> {
  late AudioPlayer _audioPlayer;
  late FlutterTts _flutterTts;
  int gridSize = 3;
  int seahorsePosition = 0;
  int _mermaidCurrentPosition = 1;
  int score = 0;
  bool isAnimating = false;
  bool isProcessingAnswer = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
    _initializeTTS();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRandomQuestion();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('audio/ocea.mp3')).catchError((error) {
      print("Error playing audio: $error");
    });
  }

  void _initializeTTS() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text) async {
    final languageController =
        Provider.of<LanguageController>(context, listen: false);
    await _flutterTts.setLanguage(
        languageController.currentLanguage == 'es' ? "es-ES" : "en-US");
    await _flutterTts.speak(text);
  }

  void _generateRandomQuestion() {
    int totalShells = gridSize * gridSize;
    seahorsePosition = Random().nextInt(totalShells) + 1;

    final languageController =
        Provider.of<LanguageController>(context, listen: false);
    String translatedOrdinal = languageController.ordinal(seahorsePosition);

    _mermaidCurrentPosition = 1; // Reset here

    _flutterTts.setLanguage(
        languageController.currentLanguage == 'es' ? "es-ES" : "en-US");
    _speak(languageController.translate("find_shell").replaceAll(
          "{ordinal}",
          languageController.ordinal(seahorsePosition),
        ));
    setState(() {});
  }

  void _onShellTap(int shellIndex) {
    if (isProcessingAnswer || isAnimating) return;

    setState(() {
      isProcessingAnswer = true;
    });

    _animateMermaidTo(shellIndex);
  }

  List<int> _calculatePath(int start, int end) {
    List<int> path = [];
    int current = start;
    while (current != end) {
      current++;
      if (current > gridSize * gridSize) current = 1;
      path.add(current);
    }
    return path;
  }

  Future<void> _animateMermaidTo(int target) async {
    if (isAnimating) return;
    setState(() => isAnimating = true);

    final languageController =
        Provider.of<LanguageController>(context, listen: false);
    List<int> path = _calculatePath(_mermaidCurrentPosition, target);
    await _speak(
        languageController.ordinal(_mermaidCurrentPosition)); // say first shell
    await Future.delayed(const Duration(milliseconds: 400));

    for (int pos in path) {
      setState(() => _mermaidCurrentPosition = pos);
      await _speak(languageController.ordinal(pos)); // <- Sync TTS
      await Future.delayed(const Duration(milliseconds: 400));
    }

    _showResult(target == seahorsePosition);

    setState(() {
      isAnimating = false;
      isProcessingAnswer = false;
    });
  }

  void _showResult(bool isCorrect) {
    final languageController =
        Provider.of<LanguageController>(context, listen: false);

    if (isCorrect) {
      score += 5;
      _speak("Congratulations! You found the correct shell!");
    } else {
      score -= 1;
      _speak("Try Again! That's the wrong shell.");
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(languageController
              .translate(isCorrect ? "Congratulations!" : "Try Again!")),
          content: Text(languageController.translate(isCorrect
              ? "You found the correct shell!"
              : "Wrong shell! Try again.")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  _generateRandomQuestion();
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double shellSize =
        (MediaQuery.of(context).size.shortestSide / gridSize) - 16;

    return Consumer<LanguageController>(
      builder: (context, languageController, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageController.currentLanguage == 'en'
                ? "Demo: Mermaid Game"
                : "Demostración: Juego de Sirenas"),
            actions: const [LanguageToggleButton()],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        languageController.translate("find_shell").replaceAll(
                            "{ordinal}",
                            languageController.ordinal(seahorsePosition)),
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          int shellIndex = index + 1;
                          return GestureDetector(
                            onTap: () => _onShellTap(shellIndex),
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/shell.svg',
                                  width: shellSize,
                                  height: shellSize,
                                ),
                                if (shellIndex == seahorsePosition)
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/seahorse.svg',
                                        width: shellSize / 2,
                                        height: shellSize / 2,
                                      ),
                                    ),
                                  ),
                                if (shellIndex == _mermaidCurrentPosition)
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/mermaid.svg',
                                        width: shellSize / 1.5,
                                        height: shellSize / 1.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${languageController.translate('Score')}: $score",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
