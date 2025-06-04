import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';
import 'count_fish.dart';

class CountButterflyPage extends StatelessWidget {
  const CountButterflyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'How many butterflies are there?',
      spanishQuestion: '¿Cuántas mariposas hay?',
      imageAsset: 'assets/butterfly.png',
      englishOption1: 'Sixteen',
      spanishOption1: 'DIECISÉIS',
      nextPage1: const FeedbackPage(
        isCorrect: true,
        nextPage: CountFishPage(),
      ),
      englishOption2: 'Eighteen',
      spanishOption2: 'DIECIOCHO',
      nextPage2: FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true,
      ),
    );
  }
}
