import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';
import 'count_butterfly.dart';

class CountBirdsPage extends StatelessWidget {
  const CountBirdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'How many birds do you see?',
      spanishQuestion: '¿Cuántos pájaros ves?',
      imageAsset: 'assets/bird.png',
      englishOption1: 'Seven',
      spanishOption1: 'SIETE',
      nextPage1: const FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true,
      ),
      englishOption2: 'Nine',
      spanishOption2: 'NUEVE',
      nextPage2: FeedbackPage(
        isCorrect: true,
        nextPage: CountButterflyPage(),
      ),
    );
  }
}
