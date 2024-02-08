import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:one_hundred_push_ups/utils/constants.dart";
import "package:toastification/toastification.dart";
import "../widgets/RoundedTextField.dart";

class MyGoalsPage extends StatefulWidget {
  const MyGoalsPage({super.key});

  @override
  State<MyGoalsPage> createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  final myController = TextEditingController();
  int dailyGoal = 100;
  List<Color> gradientColors = [turquoiseBlue, lightBlue];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(
                      "22 days",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: turquoiseBlue),
                    )
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Your average is 120 reps per day",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 5, right: 30),
                    child: Container(
                        width: 300, //MediaQuery.of(context).size.width*0.9,
                        height: 250,
                        child: LineChartWidget()),
                  ),
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
              "$dailyGoal Reps",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: turquoiseBlue),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await openDialog();
                setState(() {
                  dailyGoal = int.parse(result!);
                });
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
                      child: const Text("Change",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ],
              ),
            ),
          ));
}

class LineChartWidget extends StatelessWidget {
  //todo: more customization + refactoring
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(spots: [
          FlSpot(0, 77),
          FlSpot(1, 120),
          FlSpot(2, 100),
          FlSpot(3, 80),
          FlSpot(4, 100),
          FlSpot(5, 95),
          FlSpot(6, 50),
        ])
      ],
      titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      "Day ${value.toInt().toString()}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    );
                  }))),
    ));
  }
}
