import 'package:hive/hive.dart';

part 'leaderboard_model.g.dart';

@HiveType(typeId: 0)
class LeaderboardEntry extends HiveObject {
  @HiveField(0)
  String playerName;

  @HiveField(1)
  int score;

  @HiveField(2)
  String category;

  LeaderboardEntry({required this.playerName, required this.score, required this.category});
}
