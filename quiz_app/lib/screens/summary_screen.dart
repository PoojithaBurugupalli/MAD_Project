import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/quiz_model.dart';
import '../models/leaderboard_model.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<QuizQuestion> questions;

  SummaryScreen({required this.score, required this.total, required this.questions});

  void _saveToLeaderboard(String playerName, String category) {
    final box = Hive.box('leaderboard');
    final entry = LeaderboardEntry(playerName: playerName, score: score, category: category);
    box.add(entry);
  }

  @override
  Widget build(BuildContext context) {
    final category = questions.isNotEmpty ? 'General Knowledge' : 'Unknown'; // Placeholder for category

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $score / $total',
              style: TextStyle(fontSize: 20, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveToLeaderboard('Player1', category); // Save score for demonstration
                Navigator.of(context).pop(); // Go back to setup screen
              },
              child: Text('Save Score & Return'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/leaderboard'); // Navigate to leaderboard
              },
              child: Text('View Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}
