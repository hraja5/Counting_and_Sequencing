import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';

class CountApplesPage extends StatelessWidget {
  const CountApplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'How many apples do you see?',
      spanishQuestion: '¿Cuántas manzanas ves?',
      imageAsset: 'assets/apples.png',

      // OPTION 1 → correct → show feedback and exit to home
      englishOption1: 'Nine',
      spanishOption1: 'NUEVE',
      nextPage1: const FeedbackPage(
        isCorrect: true,
        exitToHome: true, // Ends the flow and returns to home
      ),

      // OPTION 2 → wrong → show feedback and allow retry
      englishOption2: 'Eight',
      spanishOption2: 'OCHO',
      nextPage2: FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true,
      ),
    );
  }
}
