import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:one_hundred_push_ups/database/LocalDB.dart";
import "package:one_hundred_push_ups/utils/constants.dart";
import "package:provider/provider.dart";
import "package:toastification/toastification.dart";
import "../models/GoalProvider.dart";
import "../widgets/RoundedTextField.dart";
import "../widgets/LineGraph.dart";

class MyGoalsPage extends StatefulWidget {
  const MyGoalsPage({super.key});

  @override
  State<MyGoalsPage> createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  final myTextController = TextEditingController();
  int currentGraph = 0;
  final myPageController = PageController();
  List<Color> gradientColors = [turquoiseBlue, lightBlue];

  String graphTitle() {
    switch (currentGraph) {
      case (0):
        return "Daily reps";
      case (1):
        return "% of daily goal";
      case (2):
        return "Reps per set";
      case (3):
        return "Rank";
      default:
        return "";
    }
  }

  late Future<List<Map<String, dynamic>>> stats;
  void getStats() async {
    final db = LocalDB();
    stats = db.fetchDailyRepsStats();
  }

  int calculateStreak(
      List<String> dates, List<double> goals, List<double> reps) {
    List<DateTime> days = dates.map((date) => DateTime.parse(date)).toList();
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int streak = 0;
    int remainingDays = days.length;
    DateTime current = today;
    while (remainingDays >= 1) {
      DateTime previous = current.subtract(const Duration(days: 1));
      //if previous day is not yesterday there is no streak
      if (previous.compareTo(days[remainingDays - 1]) != 0) {
        break;
      } else {
        //if previous day is yesterday then we check if the goal was completed
        if (goals[remainingDays - 1] <= reps[remainingDays - 1]) {
          streak++;
        } else {
          break;
        }
      }
      remainingDays -= 1; //move to the previous day
      current = previous;
    }
    return streak;
  }

  @override
  void initState() {
    getStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Statistics",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.electric_bolt_outlined, size: 20),
                    Text("Current goal\ncompletion streak",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                    FutureBuilder(
                        future: stats,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            List<double> reps = snapshot.data!
                                .map((map) =>
                                    double.parse(map["SUM(reps)"].toString()))
                                .toList();
                            List<String> dates = snapshot.data!
                                .map((map) => map["date"].toString())
                                .toList();
                            List<double> goals = snapshot.data!
                                .map((map) =>
                                    double.parse(map["goalAmount"].toString()))
                                .toList();
                            return Text(
                              "${calculateStreak(dates, goals, reps)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: turquoiseBlue),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 350,
              decoration: BoxDecoration(
                  color: grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: PageView(
                  controller: myPageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentGraph = index;
                    });
                  },
                  children: [
                    FutureBuilder(
                        future: stats,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            List<double> reps = snapshot.data!
                                .map((map) =>
                                    double.parse(map["SUM(reps)"].toString()))
                                .toList();
                            List<String> dates = snapshot.data!
                                .map((map) => map["date"].toString())
                                .toList();
                            double average = snapshot.data!
                                    .map((map) =>
                                        int.parse(map["SUM(reps)"].toString()))
                                    .toList()
                                    .reduce((reps1, reps2) => reps1 + reps2) /
                                snapshot.data!.length;
                            List<FlSpot> dataPoints = [];
                            for (int i = 0; i < reps.length; i++) {
                              dataPoints.add(FlSpot(i.toDouble() + 1, reps[i]));
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Your average is ${average.toStringAsFixed(2)} reps per day",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 5, right: 30),
                                  child: Container(
                                      width: 300,
                                      height: 250,
                                      child: LineGraph(
                                          minX: 1,
                                          maxX: dates.length.toDouble(),
                                          minY: 0,
                                          maxY: reps.reduce((reps1, reps2) =>
                                                  reps1 > reps2
                                                      ? reps1
                                                      : reps2) +
                                              10,
                                          dates: dates,
                                          dataPoints: dataPoints)),
                                ),
                              ],
                            );
                          }
                        }),
                    FutureBuilder(
                        future: stats,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            List<double> goals = snapshot.data!
                                .map((map) =>
                                    double.parse(map["goalAmount"].toString()))
                                .toList();
                            List<double> reps = snapshot.data!
                                .map((map) =>
                                    double.parse(map["SUM(reps)"].toString()))
                                .toList();
                            List<String> dates = snapshot.data!
                                .map((map) => map["date"].toString())
                                .toList();
                            double average = 0;
                            List<FlSpot> dataPoints = [];
                            for (int i = 0; i < reps.length; i++) {
                              double per = (reps[i] / goals[i]) * 100;
                              average += per;
                              dataPoints.add(FlSpot(i.toDouble() + 1, (per)));
                            }
                            average /= goals.length;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Your average is ${average.toStringAsFixed(2)}%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 5, right: 30),
                                  child: Container(
                                      width: 300,
                                      height: 250,
                                      child: LineGraph(
                                          minX: 1,
                                          maxX: dates.length.toDouble(),
                                          minY: 0,
                                          maxY: reps.reduce((reps1, reps2) =>
                                                  reps1 > reps2
                                                      ? reps1
                                                      : reps2) +
                                              10,
                                          dates: dates,
                                          dataPoints: dataPoints)),
                                ),
                              ],
                            );
                          }
                        }),
                    FutureBuilder(
                        future: stats,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            List<double> avgReps = snapshot.data!
                                .map((map) =>
                                    double.parse(map["AVG(reps)"].toString()))
                                .toList();
                            List<String> dates = snapshot.data!
                                .map((map) => map["date"].toString())
                                .toList();
                            double average =
                                avgReps.reduce((avg1, avg2) => avg1 + avg2) /
                                    avgReps.length;
                            List<FlSpot> dataPoints = [];
                            for (int i = 0; i < avgReps.length; i++) {
                              dataPoints
                                  .add(FlSpot(i.toDouble() + 1, avgReps[i]));
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Your average is ${average.toStringAsFixed(2)} reps per set",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 5, right: 30),
                                  child: Container(
                                      width: 300,
                                      height: 250,
                                      child: LineGraph(
                                          minX: 1,
                                          maxX: dates.length.toDouble(),
                                          minY: 0,
                                          maxY: avgReps.reduce((reps1, reps2) =>
                                                  reps1 > reps2
                                                      ? reps1
                                                      : reps2) +
                                              10,
                                          dates: dates,
                                          dataPoints: dataPoints)),
                                ),
                              ],
                            );
                          }
                        }),
                    Column(
                      //todo: make after setting up server
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Your average rank is 25",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 10, left: 5, right: 30),
                          child: Container(
                              width: 300,
                              height: 250,
                              child: LineGraph(
                                minX: 1,
                                maxX: 7,
                                minY: 0,
                                maxY: 30,
                                dataPoints: [
                                  FlSpot(1, 25),
                                  FlSpot(2, 25),
                                  FlSpot(3, 23),
                                  FlSpot(4, 20),
                                  FlSpot(5, 20),
                                  FlSpot(6, 18),
                                  FlSpot(7, 10),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        myPageController.previousPage(
                            duration: Duration(microseconds: 1000),
                            curve: Curves.easeIn);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: currentGraph == 0 ? grey : Colors.black,
                      )),
                  Text(graphTitle(), style: TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () {
                        myPageController.nextPage(
                            duration: Duration(microseconds: 1000),
                            curve: Curves.easeIn);
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: currentGraph == 3 ? grey : Colors.black,
                      )),
                ],
              ),
            ),
            Text(
              "Daily goal",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${context.watch<GoalProvider>().todayGoal!.goalAmount} Reps",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: turquoiseBlue),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await openDialog();
                if (context.mounted)
                  context
                      .read<GoalProvider>()
                      .changeGoal(newGoalAmount: int.parse(result!));
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                fixedSize: MaterialStateProperty.all(
                  const Size(
                    300,
                    50,
                  ),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(greenBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(
                "Change goal",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Change daily goal",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 220,
                    child: RoundedTextField(
                      textInputType: TextInputType.number,
                      hintText: "Enter daily goal",
                      hintTextSize: 10,
                      borderColor: grey,
                      selectedBorderColor: greenBlue,
                      controller: myTextController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (myTextController.text.isNotEmpty &&
                            int.parse(myTextController.text) != 0) {
                          Navigator.of(context).pop(myTextController.text);
                          myTextController.text = "";
                        } else {
                          toastification.show(
                              context: context,
                              title: const Text("Input can't be empty"),
                              autoCloseDuration: const Duration(seconds: 2),
                              style: ToastificationStyle.simple,
                              alignment: const Alignment(0, 0.75));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(greenBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text("Change",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ],
              ),
            ),
          ));
}
