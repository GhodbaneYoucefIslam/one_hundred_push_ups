import 'dart:async';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import "package:flutter/material.dart";
import '../utils/constants.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration remainingTime= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0).add(Duration(days: 1)).difference(DateTime.now());
  //todo: make persistent
  int totalReps = 20;
  final int goal = 100;
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
  late List<CircularStackEntry> chartData = <CircularStackEntry>[
  CircularStackEntry(
  <CircularSegmentEntry>[
  CircularSegmentEntry(totalReps.toDouble(), turquoiseBlue, rankKey: '% of daily goal'),
  CircularSegmentEntry((goal-totalReps).toDouble(), Colors.white10, rankKey: 'remaining %'),
  ],
  rankKey: 'Daily Progress',
  ),
  ];

  void startTimer(){
    Timer timer;
    timer= Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0).add(Duration(days: 1)).difference(DateTime.now());
      });
    });
  }
  String upperText(){
    switch(totalReps*100~/goal){
      case (<=20) : return "Do your best";
      case (>20 && <50) : return "Keep going";
      case (>=50 && <70) : return "You're doing great!";
      case (>=70 && <90) : return "Keep grinding!";
      case (>=90 && <100) : return "Almost done!";
      default: return "You've made it!";
    }
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text( upperText(),
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(
                  height: 20,
                ),
                AnimatedCircularChart(
                  size:  const Size(280, 280),
                  initialChartData: chartData,
                  key: _chartKey,
                  chartType: CircularChartType.Radial,
                  holeLabel: "${totalReps*100~/goal}%",
                  labelStyle: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "SpaceGrotesk",
                  ),
                ),
              ],
            ),
            Text(
              totalReps<goal? "You have\n ${remainingTime.inHours} hours ${remainingTime.inMinutes-remainingTime.inHours*60} mins and ${remainingTime.inSeconds-(remainingTime.inMinutes-remainingTime.inHours*60)*60-(remainingTime.inHours)*3600}\n seconds\n to finish your goal" : "\nDone for the day!\n\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Add set",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    elevation: 3,
                    onPressed: () {
                      setState(() {
                        totalReps+=10;
                        List<CircularStackEntry> updatedChartData = <CircularStackEntry>[
                          CircularStackEntry(
                            <CircularSegmentEntry>[
                              CircularSegmentEntry(totalReps.toDouble(), turquoiseBlue, rankKey: '% of daily goal'),
                              CircularSegmentEntry((goal-totalReps).toDouble(), Colors.white10, rankKey: 'remaining %'),
                            ],
                            rankKey: 'Daily Progress',
                          ),
                        ];
                        _chartKey.currentState!.updateData(updatedChartData);
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    backgroundColor: greenBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
