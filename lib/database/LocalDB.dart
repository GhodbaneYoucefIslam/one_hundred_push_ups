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
            "('pushUps', '2024-03-10T00:00:00.000', 100),"
            "('pushUps', '2024-03-11T00:00:00.000', 110),"
            "('pushUps', '2024-03-12T00:00:00.000', 120),"
            "('pushUps', '2024-03-13T00:00:00.000', 130),"
            "('pushUps', '2024-03-14T00:00:00.000', 140),"
            "('pushUps', '2024-03-15T00:00:00.000', 150),"
            "('pushUps', '2024-03-16T00:00:00.000', 130),"
            "('pushUps', '2024-03-17T00:00:00.000', 170),"
            "('pushUps', '2024-03-18T00:00:00.000', 50),"
            "('pushUps', '2024-03-19T00:00:00.000', 50),"
            "('pushUps', '2024-03-20T00:00:00.000', 50),"
            "('pushUps', '2024-03-21T00:00:00.000', 50);"
    );
    print("init goals done!");
    return 1;
  }
  Future<int> initializeSets() async {
    final db = await DatabaseService().database;
    await db.rawQuery(
        "INSERT INTO sets (reps, time, goalId) VALUES "
            "(5, '2024-03-10T18:07:44.924267', 1),"
            "(10, '2024-03-10T18:08:44.924267', 1),"
            "(11, '2024-03-10T18:09:44.924267', 1),"
            "(20, '2024-03-10T18:12:44.924267', 1),"
            "(25, '2024-03-10T18:13:44.924267', 1),"
            "(7, '2024-03-11T18:07:44.924267', 2),"
            "(16, '2024-03-11T18:08:44.924267', 2),"
            "(17, '2024-03-11T18:09:44.924267', 2),"
            "(18, '2024-03-11T18:10:44.924267', 2),"
            "(19, '2024-03-11T18:11:44.924267', 2),"
            "(10, '2024-03-11T18:12:44.924267', 2),"
            "(11, '2024-03-11T18:13:44.924267', 2),"
            "(7, '2024-03-12T18:07:44.924267', 3),"
            "(16, '2024-03-12T18:08:44.924267', 3),"
            "(11, '2024-03-12T18:13:44.924267', 3),"
            "(7, '2024-03-13T18:07:44.924267', 4),"
            "(16, '2024-03-13T18:08:44.924267', 4),"
            "(17, '2024-03-13T18:09:44.924267', 4),"
            "(18, '2024-03-13T18:10:44.924267', 4),"
            "(11, '2024-03-13T18:13:44.924267', 4),"
            "(30, '2024-03-14T18:07:44.924267', 5),"
            "(30, '2024-03-14T18:08:44.924267', 5),"
            "(30, '2024-03-14T18:09:44.924267', 5),"
            "(10, '2024-03-14T18:10:44.924267', 5),"
            "(10, '2024-03-14T18:11:44.924267', 5),"
            "(10, '2024-03-14T18:12:44.924267', 5),"
            "(10, '2024-03-14T18:13:44.924267', 5),"
            "(5, '2024-03-15T18:07:44.924267', 6),"
            "(16, '2024-03-15T18:08:44.924267', 6),"
            "(5, '2024-03-15T18:09:44.924267', 6),"
            "(18, '2024-03-15T18:10:44.924267', 6),"
            "(19, '2024-03-15T18:11:44.924267', 6),"
            "(5, '2024-03-15T18:12:44.924267', 6),"
            "(5, '2024-03-15T18:13:44.924267', 6),"
            "(7, '2024-03-16T18:07:44.924267', 7),"
            "(16, '2024-03-16T18:08:44.924267', 7),"
            "(12, '2024-03-16T18:09:44.924267', 7),"
            "(5, '2024-03-16T18:10:44.924267', 7),"
            "(20, '2024-03-16T18:11:44.924267', 7),"
            "(20, '2024-03-16T18:12:44.924267', 7),"
            "(25, '2024-03-16T18:13:44.924267', 7),"
            "(7, '2024-03-17T18:07:44.924267', 8),"
            "(16, '2024-03-17T18:08:44.924267', 8),"
            "(17, '2024-03-17T18:09:44.924267', 8),"
            "(18, '2024-03-17T18:10:44.924267', 8),"
            "(19, '2024-03-17T18:11:44.924267', 8),"
            "(10, '2024-03-17T18:12:44.924267', 8),"
            "(11, '2024-03-17T18:13:44.924267', 8),"
            "(7, '2024-03-18T18:07:44.924267', 9),"
            "(13, '2024-03-18T18:08:44.924267', 9),"
            "(30, '2024-03-18T18:09:44.924267', 9),"
            "(15, '2024-03-19T18:07:44.924267', 10),"
            "(15, '2024-03-19T18:08:44.924267', 10),"
            "(5, '2024-03-19T18:09:44.924267', 10),"
            "(5, '2024-03-19T18:10:44.924267', 10),"
            "(5, '2024-03-19T18:11:44.924267', 10),"
            "(10, '2024-03-19T18:12:44.924267', 10),"
            "(50, '2024-03-20T18:13:44.924267', 11),"
            "(25, '2024-03-21T19:13:44.924267', 12),"
            "(25, '2024-03-21T19:20:44.924267', 12);"
    );
    print("init sets done!");
    return 1;
  }

}