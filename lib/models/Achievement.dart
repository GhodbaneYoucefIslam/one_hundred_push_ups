import 'package:one_hundred_push_ups/models/Mappable.dart';
import 'package:one_hundred_push_ups/models/User.dart';
import "package:one_hundred_push_ups/utils/constants.dart";
import 'package:one_hundred_push_ups/utils/methods.dart';
import 'Goal.dart';

class Achievement extends Mappable {
  String type;
  int rank;
  User user;
  int reps;
  int rankChange;
  String date;
  Achievement(
      this.type, this.rank, this.user, this.reps, this.rankChange, this.date);
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
        defaultGoalType, //todo: modify server later to include type in response
        json['dailyRank'],
        User(
            json['user']['id'],
            json['user']['firstname'].toString(),
            json['user']['lastname'].toString(),
            json['user']['email'].toString(),
            json['user']['ispublic']),
        json['score'],
        json['rankChange'] ?? 0,
        json['day']);
  }
  @override
  String toString() {
    return "Achievement($rank,${user.initials()},$reps,$rankChange,$date)";
  }

  Map<String, dynamic> toJsonBeforeRank() {
    return {'type': type, 'score': reps, 'day': date, 'userId': user.id};
  }

  factory Achievement.fromGoalAndSets(Goal goal, int sets, User user) {
    final String day = toPrismaCompatibleIsoStringForDate(goal.date);
    return Achievement(goal.type, 0, user, sets, 0, day);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'date': date,
      'rank': rank,
      'reps': reps,
      'rankChange': rankChange,
    };
  }

  static Achievement fromMap(Map<String, dynamic> map) {
    return Achievement(map["type"], int.parse(map["dailyRank"]),
        placeholderUser, map["score"], map["rankChange"] ?? 0, map["day"]);
  }
}
