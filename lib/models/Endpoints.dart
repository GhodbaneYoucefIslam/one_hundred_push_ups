import 'dart:convert';
import 'package:one_hundred_push_ups/utils/constants.dart';
import 'Achievement.dart';
import 'package:http/http.dart' as http;

Future<List<Achievement>?> getTodayAchievements() async{
  final String day = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2,"0")}-${DateTime.now().day-3}T00:00:00Z";
  const String type = defaultGoalType;
  final uri = Uri.parse("$endpoint/achievement/$day/$type");
  final response = await http.get(uri);
  if (response.statusCode == 200){
    print("200: got responses succesfully");
    final List jsonResponse = json.decode(response.body);
    print(jsonResponse.toString());
    return jsonResponse.map((e) => Achievement.fromJson(e)).toList();
  }else{
    print(response.body.toString());
    print("error loading achievements");
    return null;
  }
}

//todo: set up post request endpoint