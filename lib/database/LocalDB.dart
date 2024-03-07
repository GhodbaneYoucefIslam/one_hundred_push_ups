import 'package:sqflite/sqflite.dart';
import '../utils/constants.dart';
import 'DatabaseService.dart';
import 'package:one_hundred_push_ups/models/Goal.dart';
import 'package:one_hundred_push_ups/models/Set.dart';

class LocalDB{
  final String goalsTable = "goal";
  final String setsTable = "sets";

  Future<void> createTables(Database db) async{
    await db.execute(
      "CREATE TABLE IF NOT EXISTS $goalsTable(id INTEGER, type TEXT NOT NULL, date TEXT NOT NULL, goalAmount INTEGER NOT NULL, PRIMARY KEY(id AUTOINCREMENT) )"
    );
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $setsTable(id INTEGER, reps INTEGER NOT NULL, time TEXT NOT NULL, goalId INTEGER NOT NULL,PRIMARY KEY(id AUTOINCREMENT), FOREIGN KEY(goalId) REFERENCES goal(id) )"
    );
  }

  //Goal methods
  Future<int> createGoal({required Goal goal}) async{
    final db = await DatabaseService().database;
    return await db.rawInsert(
      "INSERT INTO $goalsTable(type,goalAmount,date) VALUES(?,?,?)",
      [goal.type,goal.goalAmount,goal.date.toIso8601String()],
    );
  }
  Future<List<Goal>> fetchAllGoals() async{
    final db = await DatabaseService().database;
    final goals = await db.rawQuery(
        "SELECT * from $goalsTable order by id"
    );
    return goals.map((map) => Goal.fromMap(map)).toList();
  }
  Future<int> updateGoal({required int id,required int goalAmount}) async{
    final db = await DatabaseService().database;
    return await db.update(
      goalsTable,
      {
        'goalAmount' : goalAmount
      },
      where: 'id =?',
      whereArgs: [id]
    );
  }
  Future<Goal?> fetchGoalByDate(DateTime date, {String type = defaultGoalType}) async{
    final db = await DatabaseService().database;
    final goals = await db.rawQuery(
        "SELECT * from $goalsTable WHERE date=? AND type =?",
      [date.toIso8601String(),type]
    );
    return goals.isNotEmpty? Goal.fromMap(goals.first): null;
  }
  Future<Goal?> fetchGoalById(int id) async{
    final db = await DatabaseService().database;
    final goals = await db.rawQuery(
        "SELECT * from $goalsTable WHERE id=?",
        [id]
    );
    return goals.isNotEmpty? Goal.fromMap(goals.first): null;
  }
  Future<void> deleteAll() async{
    final db = await DatabaseService().database;
     db.rawQuery(
      "DELETE FROM $goalsTable WHERE id>0",
    );
  }


  //set methods
  Future<int> createSet({required Set set, required int goalId}) async {
    final db = await DatabaseService().database;
    return await db.rawInsert(
      "INSERT INTO $setsTable(reps,time,goalId) VALUES(?,?,?)",
      [set.reps, set.time.toIso8601String(),goalId],
    );
  }
  Future<List<Set>> fetchSetsForGoal(int goalId) async{
    final db = await DatabaseService().database;
    final sets = await db.rawQuery(
        "SELECT * from $setsTable WHERE goalId=?",
        [goalId]
    );
    return sets.map((map) => Set.fromMap(map)).toList();
  }
}