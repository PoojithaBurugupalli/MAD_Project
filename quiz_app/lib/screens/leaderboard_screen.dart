import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/leaderboard_model.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('leaderboard');
    final entries = box.values.cast<LeaderboardEntry>().toList();

    // Group entries by category
    final Map<String, List<LeaderboardEntry>> groupedEntries = {};
    for (var entry in entries) {
      if (!groupedEntries.containsKey(entry.category)) {
        groupedEntries[entry.category] = [];
      }
      groupedEntries[entry.category]!.add(entry);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: ListView(
        children: groupedEntries.entries.map((categoryGroup) {
          final category = categoryGroup.key;
          final scores = categoryGroup.value;

          // Sort scores within each category
          scores.sort((a, b) => b.score.compareTo(a.score)); // Highest score first

          return ExpansionTile(
            title: Text(category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: scores.map((entry) {
              return ListTile(
                title: Text(entry.playerName),
                trailing: Text('Score: ${entry.score}'),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
