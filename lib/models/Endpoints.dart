import 'dart:convert';
import 'package:one_hundred_push_ups/utils/constants.dart';
import 'package:one_hundred_push_ups/utils/methods.dart';
import 'Achievement.dart';
import 'package:http/http.dart' as http;

Future<List<Achievement>?> getTodayAchievements() async{
  final String day = toPrismaCompatibleIsoStringForDate(DateTime.now());
  const String type = defaultGoalType;
  final uri = Uri.parse("$endpoint/achievement/$day/$type");
  final response = await http.get(uri);
  if (response.statusCode == 200){
    print("200: got responses successfully");
    final List jsonResponse = json.decode(response.body);
    final achievements = jsonResponse.map((e) => Achievement.fromJson(e)).toList();
    return achievements;
  }else{
    print(response.body.toString());
    print("error loading achievements");
    return null;
  }
}

Future<List<Map<String,dynamic>>?> getUserAchievements() async{
  const String type = defaultGoalType;
  final int userId = me.id!;
  final uri = Uri.parse("$endpoint/achievement/user/$userId/$type");
  final response = await http.get(uri);
  if (response.statusCode == 200){
    print("200: got rank responses successfully");
    final List jsonResponse = json.decode(response.body);
    return jsonResponse.map((e) => {'dailyRank':e['dailyRank'].toString(),'day':e['day'].toString()}).toList();
  }else{
    print(response.body.toString());
    print("error loading user rank achievements");
    return null;
  }
}
Future<Achievement?> postTodayAchievement(Achievement achievement) async {
  // Construct the URI
  final uri = Uri.parse("$endpoint/achievement");
  try {
    // Send POST request with JSON body
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'}, // Set Content-Type header
      body: json.encode(achievement.toJson()), // Encode achievement object to JSON
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200 || response.statusCode ==201 ) {
      print("post successful!");
      final jsonData = json.decode(response.body);
      return Achievement.fromJson(jsonData);
    } else {
      // Print for debugging
      print("post failed! ${response.statusCode}");
      print(response.body);
      return null;
    }
  } catch (error) {
    print("Error posting achievement: $error");

    return null;
  }
}
