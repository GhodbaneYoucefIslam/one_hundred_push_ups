class Goal{
  int? id;
  String type;
  int goalAmount;
  DateTime date;
  Goal({
    this.id,
    required this.type,
    required this.date,
    required this.goalAmount
});

  static Goal fromMap(Map<String,dynamic> map){
    return Goal(
        id: map['id'],
        type: map['type'],
        date: DateTime.parse(map['date']),
        goalAmount: map['goalAmount']
    );
  }

  Map<String,dynamic> toMap(){
    return {'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'goalAmount': goalAmount
    };
}

  @override
  String toString() {
    return "Goal($id,$type,$date,$goalAmount)";
  }
}