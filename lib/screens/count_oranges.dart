import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';
import 'count_grapes.dart'; // The next question screen

class CountOrangesPage extends StatelessWidget {
  const CountOrangesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'Let\'s see how many oranges we have',
      spanishQuestion: 'Veamos cuántas naranjas tenemos',
      imageAsset: 'assets/oranges.png',

      // OPTION 1 → correct → show right feedback → go to grapes next
      englishOption1: 'Eight',
      spanishOption1: 'OCHO',
      nextPage1: const FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true,
      ),

      // OPTION 2 → wrong → show wrong feedback → allow retry
      englishOption2: 'Six',
      spanishOption2: 'SEIS',
      nextPage2: FeedbackPage(
        isCorrect: true,
        nextPage: CountGrapesPage(), // goes back to question to retry
      ),
    );
  }
}
