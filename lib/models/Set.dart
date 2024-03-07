class Set{
  int? id;
  int reps;
  DateTime time;
  Set({
    id,
    required this.reps,
    required this.time
});

  static Set fromMap(Map<String,dynamic> map){
    return Set(
      id: map['id'],
      reps: map['reps'],
      time: map['time']
    );
  }
}