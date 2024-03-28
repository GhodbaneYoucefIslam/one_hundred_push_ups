import 'package:one_hundred_push_ups/models/User.dart';

class Achievement {
  int rank;
  User user;
  int reps;
  int rankChange;
  Achievement(this.rank, this.user, this.reps, this.rankChange);
  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
      json['dailyRank'],
      User(json['id'], json['user']['firstname'].toString(), json['user']['lastname'].toString(), json['email'].toString()),
      json['score'],
      json['rankChange'] ?? 0);
  @override
  String toString() {
    return "Achievement($rank,${user.initials()},$reps,$rankChange)";
  }
}
