import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:one_hundred_push_ups/utils/constants.dart";
import "package:toastification/toastification.dart";
import "../widgets/RoundedTextField.dart";
import "../widgets/LineGraph.dart";

class MyGoalsPage extends StatefulWidget {
  const MyGoalsPage({super.key});

  @override
  State<MyGoalsPage> createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  String graphTitle() {
    switch (currentGraph) {
      case (0) :
        return "Daily reps";
      case (1) :
        return "% of daily goal";
      case (2) :
        return "Reps per set";
      case (3) :
        return "Rank";
      default:
        return "";
    }
  }
  final myTextController = TextEditingController();
  int currentGraph = 0;
  final myPageController = PageController();
  int dailyGoal = 100;
  List<Color> gradientColors = [turquoiseBlue, lightBlue];


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
            Text(
                "Statistics",
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
              child: PageView(
                  controller: myPageController,
                  onPageChanged: (index){
                    setState(() {
                      currentGraph=index;
                    });
                  },
                  children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your average is 120 reps per day",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                            maxY: 200,
                            dataPoints: [
                              FlSpot(1, 50),
                              FlSpot(2, 60),
                              FlSpot(3, 110),
                              FlSpot(4, 100),
                              FlSpot(5, 85),
                              FlSpot(6, 120),
                              FlSpot(7, 100),
                            ],
                          )),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your average is 92% per day",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                            maxY: 150,
                            dataPoints: [
                              FlSpot(1, 14),
                              FlSpot(2, 22),
                              FlSpot(3, 89),
                              FlSpot(4, 100),
                              FlSpot(5, 78),
                              FlSpot(6, 120),
                              FlSpot(7, 130),
                            ],
                          )),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your average is 10 reps per set",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                            maxY: 20,
                            dataPoints: [
                              FlSpot(1, 5),
                              FlSpot(2, 10),
                              FlSpot(3, 10),
                              FlSpot(4, 15),
                              FlSpot(5, 15),
                              FlSpot(6, 10),
                              FlSpot(7, 12),
                            ],
                          )),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your average rank is 25",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                              FlSpot(5,20),
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
                        myPageController.previousPage(duration: Duration(microseconds: 1000), curve: Curves.easeIn);
                      },
                      icon: Icon(
                          Icons.arrow_circle_left_outlined,
                        color: currentGraph==0? grey: Colors.black,
                      )
                  ),
                  Text(
                      graphTitle(),
                      style: TextStyle(fontSize: 20)
                  ),
                  IconButton(
                      onPressed: () {
                        myPageController.nextPage(duration: Duration(microseconds: 1000), curve: Curves.easeIn);
                      },
                      icon: Icon(
                          Icons.arrow_circle_right_outlined,
                        color: currentGraph==3? grey: Colors.black,
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
