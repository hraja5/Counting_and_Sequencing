import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEngine {
  static final instance = FirebaseAnalytics.instance;

  static Future<void> init() async {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  // Log which game is selected from the home screen
  static Future<void> logGameSelected(String gameName) async {
    print('Game selected: $gameName');
    await instance.logEvent(
      name: 'game_selected',
      parameters: {'game_name': gameName},
    );
  }

  // Log language toggle
  static Future<void> logLanguageToggle(String newLanguage) async {
    print('Language toggled to: $newLanguage');
    await instance.logEvent(
      name: 'language_toggle',
      parameters: {'language': newLanguage},
    );
  }

  // Log when a shell is tapped in the Mermaid Game
  static Future<void> logShellTapped(int shellIndex, bool correct) async {
    print('Shell tapped: $shellIndex, Correct: $correct');
    await instance.logEvent(
      name: 'shell_tap',
      parameters: {
        'shell_index': shellIndex,
        'is_correct': correct,
      },
    );
  }

  // Log when a level is completed or failed
  static Future<void> logLevelResult({
    required int level,
    required int score,
    required bool completed,
  }) async {
    print('Level result - Level: $level, Score: $score, Completed: $completed');
    await instance.logEvent(
      name: 'level_result',
      parameters: {
        'level': level,
        'score': score,
        'completed': completed,
      },
    );
  }

  // Log progress view tapped
  static Future<void> logViewProgressTapped() async {
    print('Progress view opened');
    await instance.logEvent(
      name: 'view_progress',
    );
  }
}
