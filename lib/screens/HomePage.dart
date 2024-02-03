import "package:flutter/material.dart";
import '../utils/constants.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Column(
              children: [
                Text("Almost Done!",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(
                  height: 20,
                ),
                Image(image: AssetImage('assets/images/percentage.png')),
              ],
            ),
            const Text(
              "You have\n 12 hours 10 mins and 31\n seconds\n to finish your goal",
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
                    onPressed: () {},
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
