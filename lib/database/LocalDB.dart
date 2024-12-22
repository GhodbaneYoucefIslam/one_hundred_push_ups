import 'package:sqflite/sqflite.dart';
import '../utils/constants.dart';
import 'DatabaseService.dart';
import 'package:one_hundred_push_ups/models/Goal.dart';
import 'package:one_hundred_push_ups/models/Set.dart';

class LocalDB {
  Future<void> createTables(Database db) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $goalsTable(id INTEGER, type TEXT NOT NULL, date TEXT NOT NULL, goalAmount INTEGER NOT NULL, PRIMARY KEY(id AUTOINCREMENT) )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $setsTable(id INTEGER, reps INTEGER NOT NULL, time TEXT NOT NULL, goalId INTEGER NOT NULL,PRIMARY KEY(id AUTOINCREMENT), FOREIGN KEY(goalId) REFERENCES goal(id) )");
  }

  //Goal methods
  Future<int> createGoal({required Goal goal}) async {
    final db = await DatabaseService().database;
    return await db.rawInsert(
      "INSERT INTO $goalsTable(type,goalAmount,date) VALUES(?,?,?)",
      [goal.type, goal.goalAmount, goal.date.toIso8601String()],
    );
  }

  Future<List<Goal>> fetchAllGoals() async {
    final db = await DatabaseService().database;
    final goals = await db.rawQuery("SELECT * from $goalsTable order by id");
    return goals.map((map) => Goal.fromMap(map)).toList();
  }

  Future<int> updateGoal({required int id, required int goalAmount}) async {
    final db = await DatabaseService().database;
    return await db.update(goalsTable, {'goalAmount': goalAmount},
        where: 'id =?', whereArgs: [id]);
  }

  Future<Goal?> fetchGoalByDate(DateTime date,
      {String type = defaultGoalType}) async {
    final db = await DatabaseService().database;
    final goals = await db.rawQuery(
        "SELECT * from $goalsTable WHERE date=? AND type =?",
        [date.toIso8601String(), type]);
    return goals.isNotEmpty ? Goal.fromMap(goals.first) : null;
  }

  Future<Goal?> fetchGoalById(int id) async {
    final db = await DatabaseService().database;
    final goals =
        await db.rawQuery("SELECT * from $goalsTable WHERE id=?", [id]);
    return goals.isNotEmpty ? Goal.fromMap(goals.first) : null;
  }

  Future<void> deleteAllGoals() async {
    final db = await DatabaseService().database;
    db.rawQuery(
      "DELETE FROM $goalsTable WHERE id>0",
    );
  }

  Future<List<DateTime>?> fetchAvailableDates() async {
    final db = await DatabaseService().database;
    final dates = await db.rawQuery("SELECT distinct date from $goalsTable");
    final list =
        dates.map((map) => DateTime.parse(map['date'].toString())).toList();
    list.sort((date1, date2) => date1.compareTo(date2));
    return list;
  }

  Future<void> importGoalsList({required List<Goal> goals}) async {
    final db = await DatabaseService().database;
    for (Goal goal in goals) {
      await db.insert(goalsTable, goal.toMap());
    }
  }

  //set methods
  Future<int> createSet({required Set set, required int goalId}) async {
    final db = await DatabaseService().database;
    return await db.rawInsert(
      "INSERT INTO $setsTable(reps,time,goalId) VALUES(?,?,?)",
      [set.reps, "${set.time.toIso8601String()}Z", goalId],
    );
  }

  Future<List<Set>> fetchSetsForGoal(int goalId) async {
    final db = await DatabaseService().database;
    final sets =
        await db.rawQuery("SELECT * from $setsTable WHERE goalId=?", [goalId]);
    return sets.map((map) => Set.fromMap(map)).toList();
  }

  Future<List<Set>> fetchAllSets() async {
    final db = await DatabaseService().database;
    final sets = await db.rawQuery("SELECT * from $setsTable ");
    return sets.map((map) => Set.fromMap(map)).toList();
  }

  Future<void> deleteAllSets() async {
    final db = await DatabaseService().database;
    db.rawQuery(
      "DELETE FROM $setsTable WHERE id>0",
    );
  }

  Future<void> importSetsList({required List<Set> sets}) async {
    final db = await DatabaseService().database;
    for (Set set in sets) {
      await db.insert(setsTable, set.toMap());
    }
  }

  //methods for displaying statistics
  Future<List<Map<String, dynamic>>> fetchDailyRepsStats() async {
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
  Future<int> initializeGoals() async {
    final db = await DatabaseService().database;
    await db.execute("DROP TABLE $goalsTable");
    await db.execute("DROP TABLE $setsTable");
    await createTables(db);
    await db.rawQuery("INSERT INTO goal (type, date, goalAmount) VALUES "
        "('pushUps', '2024-12-19T00:00:00', 55),"
        "('pushUps', '2024-12-20T00:00:00', 100),"
        "('pushUps', '2024-12-21T00:00:00', 75);");
    return 1;
  }

  Future<int> initializeSets() async {
    final db = await DatabaseService().database;
    await db.rawQuery("INSERT INTO sets (reps, time, goalId) VALUES "
        "(3, '2024-12-19T18:07:44.924267', 1),"
        "(3, '2024-12-19T18:08:44.924267', 1),"
        "(2, '2024-12-19T18:09:44.924267', 1),"
        "(7, '2024-12-19T18:10:44.924267', 1),"
        "(5, '2024-12-20T18:07:44.924267', 2),"
        "(10, '2024-12-20T18:08:44.924267', 2),"
        "(11, '2024-12-20T18:09:44.924267', 2),"
        "(20, '2024-12-20T18:12:44.924267', 2),"
        "(25, '2024-12-20T18:13:44.924267', 2),"
        "(7, '2024-12-21T18:07:44.924267', 3),"
        "(16, '2024-12-21T18:08:44.924267', 3),"
        "(17, '2024-12-21T18:09:44.924267', 3),"
        "(18, '2024-12-21T18:10:44.924267', 3),"
        "(19, '2024-12-21T18:11:44.924267', 3),"
        "(10, '2024-12-21T18:12:44.924267', 3),"
        "(11, '2024-12-21T18:13:44.924267', 3);");
    return 1;
  }
}
