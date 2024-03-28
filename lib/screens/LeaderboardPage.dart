import "package:flutter/material.dart";
import 'package:one_hundred_push_ups/models/Achievement.dart';
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/utils/constants.dart";

class LeaderboardPage extends StatefulWidget {
  //todo: fix alignment
  const LeaderboardPage({super.key});
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<Achievement>?> data;
  void getLeaderBoardData() async {
    data = getTodayAchievements();
  }

  @override
  void initState() {
    getLeaderBoardData();
    super.initState();
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
                  future: data,
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
                                  color:
                                      (snapshot.data![index].user.isEqualTo(me))
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
                                          snapshot.data![index].rank
                                              .toString()
                                              .padLeft(
                                                  snapshot.data!
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
                                              snapshot.data![index].user
                                                  .initials(),
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
                                      snapshot.data![index].reps
                                          .toString()
                                          .padLeft(
                                              snapshot
                                                  .data!
                                                  .reduce((cur,
                                                          next) =>
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
                                          snapshot.data![index].rankChange == 0
                                              ? Icons.remove
                                              : (snapshot.data![index]
                                                          .rankChange >
                                                      0
                                                  ? Icons.arrow_circle_up
                                                  : Icons.arrow_circle_down),
                                          size: 20,
                                          color: (snapshot.data![index]
                                                      .rankChange ==
                                                  0)
                                              ? grey
                                              : (snapshot.data![index]
                                                          .rankChange >
                                                      0
                                                  ? greenBlue
                                                  : Colors.red),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].rankChange == 0
                                              ? "".padLeft(snapshot.data!
                                                  .reduce((cur, next) =>
                                                      cur.rankChange >
                                                              next.rankChange
                                                          ? cur
                                                          : next)
                                                  .rankChange
                                                  .toString()
                                                  .length)
                                              : snapshot.data![index].rankChange
                                                  .abs()
                                                  .toString()
                                                  .padLeft(
                                                      snapshot.data!
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
                                            color: (snapshot.data![index]
                                                        .rankChange ==
                                                    0)
                                                ? grey
                                                : (snapshot.data![index]
                                                            .rankChange >
                                                        0
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
                          itemCount: snapshot.data!.length);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
