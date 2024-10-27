import 'package:flutter/cupertino.dart';
import '../database/LocalDB.dart';
import '../utils/constants.dart';
import 'Goal.dart';
import 'Set.dart';

class GoalProvider extends ChangeNotifier {
  Goal? todayGoal;
  bool goalDifferentFromDb = true;
  int totalReps = 0;
  bool setsDifferentFromDb = true;

  //set methods
  void addSet({required int reps, required int goalId}) async {
    var db = LocalDB();
    int id = await db.createSet(
        set: Set(reps: reps, time: DateTime.now()), goalId: goalId);
    totalReps += reps;
    setsDifferentFromDb = true;
    notifyListeners();
  }

  void getGoalSets(int goalId) async {
    if (setsDifferentFromDb) {
      var db = LocalDB();
      List<Set> sets = await db.fetchSetsForGoal(goalId);
      if (sets.isNotEmpty) {
        totalReps =
            sets.map((set) => set.reps).reduce((reps1, reps2) => reps1 + reps2);
        notifyListeners();
      }
      setsDifferentFromDb = false;
    }
  }

  //goal methods
  void changeGoal({required int newGoalAmount}) async {
    var db = LocalDB();
    db.updateGoal(id: todayGoal!.id!, goalAmount: newGoalAmount);
    todayGoal!.goalAmount = newGoalAmount;
    goalDifferentFromDb = true;
    notifyListeners();
  }

  Future<void> getOrCreateTodayGoal() async {
    //first we deal with the daily goal
    if (todayGoal == null || goalDifferentFromDb) {
      /*await LocalDB().initializeGoals();
      await LocalDB().initializeSets();*/
      var db = LocalDB();
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      todayGoal = (await db.fetchGoalByDate(today));
      if (todayGoal == null) {
        //creating today's goal
        //first we try to have the same goal as the latest created goal
        var previousGoals = await db.fetchAllGoals();
        if (previousGoals.isNotEmpty) {
          Goal previousGoal = previousGoals.last;
          todayGoal = Goal(
              type: previousGoal.type,
              date: today,
              goalAmount: previousGoal.goalAmount);
        } else {
          //default goal of 100 pushUps
          todayGoal = placeholderGoal;
        }
        int id = await db.createGoal(goal: todayGoal!);
        todayGoal!.id = id;
      }
      goalDifferentFromDb = false;
    }
    //then we deal with this goal's sets
    if (setsDifferentFromDb) {
      getGoalSets(todayGoal!.id!);
    }
  }

  void nullifyGoal() {
    todayGoal = null;
    goalDifferentFromDb = true;
    totalReps = 0;
    setsDifferentFromDb = true;
    notifyListeners();
  }
}
