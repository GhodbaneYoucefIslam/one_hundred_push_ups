import 'package:one_hundred_push_ups/models/User.dart';
import "package:one_hundred_push_ups/utils/constants.dart";
import 'Goal.dart';

class Achievement {
  String type;
  int rank;
  User user;
  int reps;
  int rankChange;
  String date;
  Achievement(this.type,this.rank, this.user, this.reps, this.rankChange, this.date);
  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
      defaultGoalType,//todo: modify server later to include type in response
      json['dailyRank'],
      User(json['id'], json['user']['firstname'].toString(), json['user']['lastname'].toString(), json['email'].toString()),
      json['score'],
      json['rankChange']??0,
      json['day']);
  @override
  String toString() {
    return "Achievement($rank,${user.initials()},$reps,$rankChange,$date)";
  }
  Map<String,dynamic> toJson(){
    return {
      'type':type,
      'score': reps,
      'day': date,
      'userId': user.id
    };
  }
  factory Achievement.fromGoalAndSets(Goal goal,int sets) {
    final String day = "${goal.date.year}-${goal.date.month.toString().padLeft(2,"0")}-${goal.date.day.toString().padLeft(2,"0")}T00:00:00Z";
    return Achievement(
      goal.type,
      0,
      me,
      sets,
      0,
      day);
  }
}
