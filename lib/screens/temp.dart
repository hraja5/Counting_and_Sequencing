// import 'dart:collection';
// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:video_player/video_player.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:counting_and_sequencing/screens/mermaid_progress_screen.dart';

// import 'package:provider/provider.dart';
// import 'package:counting_and_sequencing/utils/language_controller.dart';
// import 'package:counting_and_sequencing/utils/auth_service.dart';
// import 'package:counting_and_sequencing/utils/analytics_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:counting_and_sequencing/widgets/language_toggle_button.dart';

// class ShellCountingGame extends StatefulWidget {
//   const ShellCountingGame({Key? key}) : super(key: key);

//   @override
//   _ShellCountingGameState createState() => _ShellCountingGameState();
// }

// class _ShellCountingGameState extends State<ShellCountingGame> {
//   int score = 0;
//   int level = 1;
//   int targetIndex = 5;
//   int seahorsePosition = -1;
//   int sharkPosition = -1;
//   String question = "";
//   late VideoPlayerController _videoController;
//   late AudioPlayer _audioPlayer;
//   late FlutterTts _flutterTts;
//   Queue<int> ttsQueue = Queue<int>();
//   bool isSpeaking = false;
//   bool isProcessingAnswer = false;
//   bool isAnimating = false;
//   int _mermaidCurrentPosition = 1; // Start mermaid on the first shell
//   List<int> _pathToTarget = [];
//   LanguageController? _languageController;

//   @override
//   void initState() {
//     super.initState();
//     _loadProgress();
//     _initializeVideoPlayer();
//     _initializeAudioPlayer();
//     _initializeTTS();
//     _generateNewQuestion();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       _languageController =
//           Provider.of<LanguageController>(context, listen: false);
//       _languageController!.addListener(_updateQuestion);
//       _updateQuestion();
//     });
//   }

//   @override
//   void dispose() {
//     _languageController?.removeListener(_updateQuestion);
//     _videoController.dispose();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }

//   void _updateQuestion() {
//     if (!mounted || _languageController == null) return;
//     setState(() {
//       question = _languageController!
//           .translate('find_shell')
//           .replaceAll('{ordinal}', _languageController!.ordinal(targetIndex));
//     });
//   }

//   void _initializeTTS() {
//     _flutterTts = FlutterTts();
//   }

//   Future<void> _speakMermaidJump(int index) async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       ttsQueue.add(index);
//       await _processQueue();
//     });
//   }

//   Future<void> _loadProgress() async {
//     final currentUser = AuthService().currentUser;
//     if (currentUser != null) {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('progress')
//           .doc(currentUser.uid)
//           .get();

//       if (snapshot.exists) {
//         final data = snapshot.data();
//         setState(() {
//           score = data?['score'] ?? 0;
//           level = data?['level'] ?? 1;
//         });
//       }
//     }
//   }

//   Future<void> _processQueue() async {
//     if (isSpeaking ||
//         ttsQueue.isEmpty ||
//         !mounted ||
//         _flutterTts == null ||
//         _languageController == null) return;
//     isSpeaking = true;
//     int index = ttsQueue.removeFirst();
//     String language = _languageController!.currentLanguage;
//     await _flutterTts.setLanguage(language == 'es' ? "es-ES" : "en-US");

//     String toSpeak = _languageController!.ordinal(index);
//     await _flutterTts.speak(toSpeak);
//     await _flutterTts.awaitSpeakCompletion(true);

//     isSpeaking = false;
//     if (ttsQueue.isNotEmpty) {
//       await _processQueue();
//     }
//   }

//   void _initializeVideoPlayer() {
//     _videoController =
//         VideoPlayerController.asset("assets/videos/background.mp4")
//           ..initialize().then((_) {
//             setState(() {
//               _videoController.setVolume(0.0);
//               _videoController.setLooping(true);
//               _videoController.play();
//             });
//           }).catchError((error) {
//             debugPrint("Error initializing video: $error");
//           });
//   }

//   void _initializeAudioPlayer() {
//     _audioPlayer = AudioPlayer();
//     _audioPlayer.setReleaseMode(ReleaseMode.loop);

//     _audioPlayer.play(AssetSource('audio/ocea.mp3')).then((_) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         _audioPlayer.setVolume(0.1);
//       });
//     }).catchError((error) {
//       debugPrint("Error playing audio: $error");
//     });
//   }

//   void _generateNewQuestion() {
//     int gridSize = level + 2;
//     int totalShells = gridSize * gridSize;
//     targetIndex = Random().nextInt(totalShells) + 1;

//     WidgetsBinding.instance.addPostFrameCallback((_) => _updateQuestion());

//     seahorsePosition = -1;
//     sharkPosition = -1;
//     isProcessingAnswer = false;
//     isAnimating = false;
//     _mermaidCurrentPosition = 1;
//     _pathToTarget = [];
//   }

//   // Remaining game logic remains unchanged...
// }
