import 'package:flutter/cupertino.dart';
import '../database/LocalDB.dart';
import '../utils/constants.dart';
import 'Goal.dart';

class GoalProvider extends ChangeNotifier{
  Goal? todayGoal;
  bool goalDifferentFromDb = true;

  void changeGoal({required int newGoalAmount}) async{
    var db = LocalDB();
    db.updateGoal(id: todayGoal!.id!, goalAmount: newGoalAmount);
    todayGoal!.goalAmount = newGoalAmount;
    goalDifferentFromDb = true;
    notifyListeners();
  }

  Future<void> getOrCreateTodayGoal() async {
    if (todayGoal==null || goalDifferentFromDb){
      var db = LocalDB();
      DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      todayGoal = (await db.fetchGoalByDate(today));
      if (todayGoal == null) {
        //creating today's goal
        //first we try to have the same goal as the latest created goal
        var previousGoals = await db.fetchAllGoals();
        if (previousGoals.isNotEmpty) {
          Goal previousGoal = previousGoals.last;
          todayGoal = Goal(type: previousGoal.type,
              date: today,
              goalAmount: previousGoal.goalAmount);
        } else {
          //default goal of 100 pushUps
          todayGoal = placeholderGoal;
        }
        int id = await db.createGoal(goal: todayGoal!);
        todayGoal!.id = id;
      } else{
      }
      goalDifferentFromDb = false;
    }
  }

}
