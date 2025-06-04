import 'package:counting_and_sequencing/screens/count_birds.dart';
import 'package:flutter/material.dart';
import 'package:counting_and_sequencing/screens/count_match_template.dart';
import 'package:counting_and_sequencing/screens/feedback.dart';
import 'count_birds.dart'; // The next question after grapes

class CountGrapesPage extends StatelessWidget {
  const CountGrapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CountMatchScreen(
      englishQuestion: 'Let\'s see how many grapes we have',
      spanishQuestion: 'Veamos cuántas uvas tenemos',
      imageAsset: 'assets/grapes.png',

      // OPTION 1 → correct → show right feedback → go to apples next
      englishOption1: 'Five',
      spanishOption1: 'CINCO',
      nextPage1: const FeedbackPage(
        isCorrect: true,
        nextPage: CountBirdsPage(),
      ),

      // OPTION 2 → wrong → show wrong feedback → allow retry
      englishOption2: 'Two',
      spanishOption2: 'DOS',
      nextPage2: FeedbackPage(
        isCorrect: false,
        popInsteadOfPush: true, // returns to this question
      ),
    );
  }
}
