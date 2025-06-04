import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';
import 'count_carrots.dart';

class CountFishPage extends StatelessWidget {
  const CountFishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'How many fish are swimming?',
      spanishQuestion: '¿Cuántos peces están nadando?',
      imageAsset: 'assets/fish.png',
      englishOption1: 'Fourteen',
      spanishOption1: 'CATORCE',
      nextPage1: const FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true,
      ),
      englishOption2: 'Twelve',
      spanishOption2: 'DOCE',
      nextPage2: FeedbackPage(
        isCorrect: true,
        nextPage: CountCarrotsPage(),
      ),
    );
  }
}
