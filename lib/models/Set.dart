class Set{
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
  String toString() {
    return "Set($id,$reps,$time,$goalId)";
  }
}