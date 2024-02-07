import "package:flutter/material.dart";
import "package:one_hundred_push_ups/utils/LeaderboardItem.dart";
import "package:one_hundred_push_ups/utils/constants.dart";

class LeaderboardPage extends StatelessWidget {
  //todo: fix alignment
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<LeaderboardItem> data = [
      LeaderboardItem(1, "IS", 250, 10),
      LeaderboardItem(2, "OP", 240, -1),
      LeaderboardItem(3, "FI", 200, 0),
      LeaderboardItem(4, "ME", 180, 7),
      LeaderboardItem(5, "QS", 100, -4),
      LeaderboardItem(1, "IS", 250, 10),
      LeaderboardItem(2, "OP", 240, -1),
      LeaderboardItem(3, "FI", 200, 0),
      LeaderboardItem(4, "ME", 180, 7),
      LeaderboardItem(5, "QS", 100, -4),
      LeaderboardItem(1, "IS", 250, 10),
      LeaderboardItem(2, "OP", 240, -1),
      LeaderboardItem(3, "FI", 200, 0),
      LeaderboardItem(4, "ME", 180, 7),
      LeaderboardItem(5, "QS", 100, -4),
    ];
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
                  Text(
                      "Leaderboard",
                      style:TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Text(
                      "For: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style:TextStyle(
                        fontSize: 20,
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.separated(
                shrinkWrap: true,
                  itemBuilder:(context,index){
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (data[index].userInitials == "ME")? Color(0XFFF7F16E):(index%2==0? turquoiseBlue.withOpacity(0.8): turquoiseBlue.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data[index].rank.toString().padLeft(data.reduce((cur,next)=>cur.rank>next.rank? cur:next).rank.toString().length,'0'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: lightBlue,
                                      border: Border.all(color: darkBlue,width: 1),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(
                                    child: Text(
                                      data[index].userInitials,
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
                              data[index].reps.toString().padLeft(data.reduce((cur,next)=>cur.reps>next.reps? cur:next).reps.toString().length,'0'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  data[index].rankChange==0?Icons.remove:( data[index].rankChange>0?Icons.arrow_circle_up: Icons.arrow_circle_down),
                                  size: 20,
                                  color: (data[index].rankChange==0) ? grey : ( data[index].rankChange>0?greenBlue: Colors.red),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  data[index].rankChange==0? "".padLeft(data.reduce((cur,next)=>cur.rankChange>next.rankChange? cur:next).rankChange.toString().length): data[index].rankChange.abs().toString().padLeft(data.reduce((cur,next)=>cur.rankChange>next.rankChange? cur:next).rankChange.toString().length,'0'),
                                  style:TextStyle(
                                    color: (data[index].rankChange==0) ? grey : ( data[index].rankChange>0?greenBlue: Colors.red),
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
                  separatorBuilder: (context,index){
                    return const SizedBox(
                      height: 11,
                    );
                  },
                  itemCount: data.length),
            ),
          ],
        ),
      ),
    );
  }
}
