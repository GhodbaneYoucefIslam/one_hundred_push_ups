import 'dart:async';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import "package:flutter/material.dart";
import 'package:one_hundred_push_ups/models/GoalProvider.dart';
import 'package:one_hundred_push_ups/widgets/RoundedTextField.dart';
import 'package:provider/provider.dart';
import '../models/Goal.dart';
import '../utils/constants.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  late int totalReps;
  late int goal;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();

  List<CircularStackEntry> chartData(Goal todayGoal, int totalReps) {
    return <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(totalReps.toDouble(), turquoiseBlue,
              rankKey: '% of daily goal'),
          CircularSegmentEntry(
              (todayGoal.goalAmount - totalReps).toDouble(), Colors.white10,
              rankKey: 'remaining %'),
        ],
        rankKey: 'Daily Progress',
      ),
    ];
  }

  //dealing with timer
  late ValueNotifier<Duration> remainingTime;
  void startTimer() async {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        remainingTime.value = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 0, 0, 0)
            .add(const Duration(days: 1))
            .difference(DateTime.now());
      });
  }

  String upperText(Goal todayGoal) {
    switch (totalReps * 100 ~/ todayGoal.goalAmount) {
      case (<= 20):
        return "Do your best";
      case (> 20 && < 50):
        return "Keep going";
      case (>= 50 && < 70):
        return "You're doing great!";
      case (>= 70 && < 90):
        return "Keep grinding!";
      case (>= 90 && < 100):
        return "Almost done!";
      default:
        return "You've made it!";
    }
  }

  @override
  void initState() {
    remainingTime = ValueNotifier<Duration>(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day, 0, 0, 0)
        .add(const Duration(days: 1))
        .difference(DateTime.now()));
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: Provider.of<GoalProvider>(context, listen: false)
              .getOrCreateTodayGoal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              try{
                goal = context.watch<GoalProvider>().todayGoal!.goalAmount;
                totalReps = context.watch<GoalProvider>().totalReps;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                              upperText(context.watch<GoalProvider>().todayGoal!),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30)),
                          const SizedBox(
                            height: 20,
                          ),
                          AnimatedCircularChart(
                            size: const Size(280, 280),
                            initialChartData: <CircularStackEntry>[
                              CircularStackEntry(
                                <CircularSegmentEntry>[
                                  CircularSegmentEntry(
                                      totalReps.toDouble(), turquoiseBlue,
                                      rankKey: '% of daily goal'),
                                  CircularSegmentEntry(
                                      (goal - totalReps).toDouble(),
                                      Colors.white10,
                                      rankKey: 'remaining %'),
                                ],
                                rankKey: 'Daily Progress',
                              ),
                            ],
                            key: _chartKey,
                            chartType: CircularChartType.Radial,
                            holeLabel: "${totalReps * 100 ~/ goal}%",
                            labelStyle: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "SpaceGrotesk",
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: remainingTime,
                        builder: (context,value,child)=> Text(
                          totalReps <
                              context
                                  .watch<GoalProvider>()
                                  .todayGoal!
                                  .goalAmount
                              ? "You have\n ${value.inHours} hours ${value.inMinutes - value.inHours * 60} mins and ${(value.inSeconds - (value.inMinutes - value.inHours * 60) * 60 - (value.inHours) * 3600).toString().padLeft(2,"0")}\n seconds\n to finish your goal"
                              : "\nDone for the day!\n\n",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Add set",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30)),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child: FloatingActionButton(
                              elevation: 3,
                              onPressed: () async {
                                var result = await openDialog();
                                int repsToAdd = int.parse(result!);
                                Provider.of<GoalProvider>(context, listen: false).addSet(reps: repsToAdd, goalId:Provider.of<GoalProvider>(context, listen: false).todayGoal!.id!);
                                setState(() {
                                  List<CircularStackEntry> updatedChartData =
                                  <CircularStackEntry>[
                                    CircularStackEntry(
                                      <CircularSegmentEntry>[
                                        CircularSegmentEntry(
                                            totalReps.toDouble(), turquoiseBlue,
                                            rankKey: '% of daily goal'),
                                        CircularSegmentEntry(
                                            (goal - totalReps).toDouble(),
                                            Colors.white10,
                                            rankKey: 'remaining %'),
                                      ],
                                      rankKey: 'Daily Progress',
                                    ),
                                  ];
                                  _chartKey.currentState!
                                      .updateData(updatedChartData);
                                });
                              },
                              backgroundColor: greenBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }catch(e){
                return const Center(child: CircularProgressIndicator());
              }
            }
          },
        ));
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
                    "Add new set",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 220,
                    child: RoundedTextField(
                      textInputType: TextInputType.number,
                      hintText: "Enter number of reps",
                      hintTextSize: 10,
                      borderColor: grey,
                      selectedBorderColor: greenBlue,
                      controller: myController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (myController.text.isNotEmpty &&
                            int.parse(myController.text) != 0) {
                          Navigator.of(context).pop(myController.text);
                          myController.text = "";
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
                      child: const Text("Add reps",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ],
              ),
            ),
          ));
}
