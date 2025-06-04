import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';
import 'count_apples.dart'; // Updated: go to apples next

class CountCarrotsPage extends StatelessWidget {
  const CountCarrotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'How many carrots are there?',
      spanishQuestion: '¿Cuántas zanahorias hay?',
      imageAsset: 'assets/carrot.png',
      englishOption1: 'Twelve',
      spanishOption1: 'DOCE',
      nextPage1: const FeedbackPage(
        isCorrect: true,
        nextPage: CountApplesPage(),
      ),
      englishOption2: 'Fifteen',
      spanishOption2: 'QUINCE',
      nextPage2: FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true,
      ),
    );
  }
}
