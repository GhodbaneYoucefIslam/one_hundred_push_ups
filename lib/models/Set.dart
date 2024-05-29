import 'package:one_hundred_push_ups/models/Mappable.dart';

class Set extends Mappable{
  int? id;
  int reps;
  DateTime time;
  int? goalId;
  Set({
    this.id,
    required this.reps,
    required this.time,
    this.goalId
});

  static Set fromMap(Map<String,dynamic> map){
    return Set(
      id: map['id'],
      reps: map['reps'],
      time: DateTime.parse(map['time']),
      goalId: map['goalId'],
    );
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "reps": reps,
      "time": time.toIso8601String(),
      "goalId": goalId
    };
  }

  @override
  String toString() {
    return "Set($id,$reps,$time,$goalId)";
  }
}