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
  Future<void> deleteAllGoals() async{
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
      [set.reps, "${set.time.toIso8601String()}Z",goalId],
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
  Future<List<Set>> fetchAllSets() async{
    final db = await DatabaseService().database;
    final sets = await db.rawQuery(
        "SELECT * from $setsTable ");
    return sets.map((map) => Set.fromMap(map)).toList();
  }
  Future<void> deleteAllSets() async{
    final db = await DatabaseService().database;
    db.rawQuery(
      "DELETE FROM $setsTable WHERE id>0",
    );
  }

  //methods for displaying statistics
  Future<List<Map<String,dynamic>>> fetchDailyRepsStats() async{
    final db = await DatabaseService().database;
    final result = await db.rawQuery(
      "SELECT date,goalAmount,SUM(reps),AVG(reps)"
      "FROM goal, sets "
      "WHERE goal.id=sets.goalId "
      "GROUP BY goal.id",
    );
    var stats = result;
    return stats;
  }

  //sample data for statistics :
  Future<int> initializeGoals() async{
    final db = await DatabaseService().database;
    await db.rawQuery(
        "INSERT INTO goal (type, date, goalAmount) VALUES "
            "('pushUps', '2024-05-03T00:00:00', 100),"
            "('pushUps', '2024-05-04T00:00:00', 100);"
    );
    print("init goals done!");
    return 1;
  }
  Future<int> initializeSets() async {
    final db = await DatabaseService().database;
    await db.rawQuery(
        "INSERT INTO sets (reps, time, goalId) VALUES "
            "(5, '2024-05-03T18:07:44.924267', 1),"
            "(10, '2024-05-03T18:08:44.924267', 1),"
            "(11, '2024-05-03T18:09:44.924267', 1),"
            "(20, '2024-05-03T18:12:44.924267', 1),"
            "(25, '2024-05-03T18:13:44.924267', 1),"
            "(7, '2024-05-04T18:07:44.924267', 2),"
            "(16, '2024-05-04T18:08:44.924267', 2),"
            "(17, '2024-05-04T18:09:44.924267', 2),"
            "(18, '2024-05-04T18:10:44.924267', 2),"
            "(19, '2024-05-04T18:11:44.924267', 2),"
            "(10, '2024-05-04T18:12:44.924267', 2),"
            "(11, '2024-05-04T18:13:44.924267', 2);"
    );
    print("init sets done!");
    return 1;
  }

}