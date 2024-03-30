import "package:flutter/material.dart";
import 'package:one_hundred_push_ups/models/Achievement.dart';
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/utils/constants.dart";
import "package:provider/provider.dart";
import "../models/Goal.dart";
import "../models/GoalProvider.dart";

class LeaderboardPage extends StatefulWidget {
  //todo: fix alignment
  const LeaderboardPage({super.key});
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<Achievement>? data;
  Future<void> getLeaderBoardData(Goal todayGoal, int totalReps) async {
    //fist we create or update the achievement for the current user
    var achievementAdded = await postTodayAchievement(
        Achievement.fromGoalAndSets(todayGoal, totalReps));
    if (achievementAdded != null) {
    } else {
      print("error adding achievement");
    }
    data = await getTodayAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Leaderboard",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text(
                      "For: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: FutureBuilder(
                  future: getLeaderBoardData(
                      context.watch<GoalProvider>().todayGoal!,
                      context.watch<GoalProvider>().totalReps),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: (data![index].user.isEqualTo(me))
                                      ? Color(0XFFF7F16E)
                                      : (index % 2 == 0
                                          ? turquoiseBlue.withOpacity(0.8)
                                          : turquoiseBlue.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data![index].rank.toString().padLeft(
                                              data!
                                                  .reduce((cur, next) =>
                                                      cur.rank > next.rank
                                                          ? cur
                                                          : next)
                                                  .rank
                                                  .toString()
                                                  .length,
                                              '0'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: lightBlue,
                                              border: Border.all(
                                                  color: darkBlue, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Text(
                                              data![index].user.initials(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      data![index].reps.toString().padLeft(
                                          data!
                                              .reduce((cur, next) =>
                                                  cur.reps > next.reps
                                                      ? cur
                                                      : next)
                                              .reps
                                              .toString()
                                              .length,
                                          '0'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          data![index].rankChange == 0
                                              ? Icons.remove
                                              : (data![index].rankChange > 0
                                                  ? Icons.arrow_circle_up
                                                  : Icons.arrow_circle_down),
                                          size: 20,
                                          color: (data![index].rankChange == 0)
                                              ? grey
                                              : (data![index].rankChange > 0
                                                  ? greenBlue
                                                  : Colors.red),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          data![index].rankChange == 0
                                              ? "".padLeft(data!
                                                  .reduce((cur, next) =>
                                                      cur.rankChange >
                                                              next.rankChange
                                                          ? cur
                                                          : next)
                                                  .rankChange
                                                  .toString()
                                                  .length)
                                              : data![index]
                                                  .rankChange
                                                  .abs()
                                                  .toString()
                                                  .padLeft(
                                                      data!
                                                          .reduce((cur, next) =>
                                                              cur.rankChange >
                                                                      next.rankChange
                                                                  ? cur
                                                                  : next)
                                                          .rankChange
                                                          .toString()
                                                          .length,
                                                      '0'),
                                          style: TextStyle(
                                            color: (data![index].rankChange ==
                                                    0)
                                                ? grey
                                                : (data![index].rankChange > 0
                                                    ? greenBlue
                                                    : Colors.red),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 11,
                            );
                          },
                          itemCount: data!.length);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
