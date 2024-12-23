import 'dart:convert';
import 'package:one_hundred_push_ups/models/User.dart';
import 'package:one_hundred_push_ups/utils/constants.dart';
import 'package:one_hundred_push_ups/utils/methods.dart';
import 'Achievement.dart';
import 'package:http/http.dart' as http;

Future<List<Achievement>?> getTodayAchievements() async {
  final String day = toPrismaCompatibleIsoStringForDate(DateTime.now());
  const String type = defaultGoalType;
  final uri = Uri.parse("$endpoint/achievement/$day/$type");
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final List jsonResponse = json.decode(response.body);
    final achievements =
        jsonResponse.map((e) => Achievement.fromJson(e)).toList();
    return achievements;
  } else {
    print(response.body.toString());
    return null;
  }
}

Future<List<Map<String, dynamic>>?> getUserAchievements(int userId) async {
  const String type = defaultGoalType;
  final uri = Uri.parse("$endpoint/achievement/user/$userId/$type");
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((e) => {
              'dailyRank': e['dailyRank'].toString(),
              'day': e['day'].toString(),
              'type': defaultGoalType,
              'score': e['score'],
              'rankChange': e['rankChange']
            })
        .toList();
  } else {
    print(response.body.toString());
    return null;
  }
}

Future<Achievement?> postTodayAchievement(Achievement achievement) async {
  //todo: maybe there is a problem here posting the achievement of the same user twice check later, problem happened again
  // Construct the URI
  final uri = Uri.parse("$endpoint/achievement");
  try {
    // Send POST request with JSON body
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'}, // Set Content-Type header
      body: json.encode(
          achievement.toJsonBeforeRank()), // Encode achievement object to JSON
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("post successful!");
      final jsonData = json.decode(response.body);
      return Achievement.fromJson(jsonData);
    } else {
      // Print for debugging
      //print("post failed! ${response.statusCode}");
      //print(response.body);
      return null;
    }
  } catch (error) {
    //print("Error posting achievement: $error");

    return null;
  }
}

Future<bool?> isEmailNotPreviouslyUsed(String email) async {
  final uri = Uri.parse("$endpoint/user/verifyEmail");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"email": email}),
    );

    if (response.statusCode == 401) {
      print("post successful!");
      print(response.body);
      return true;
    } else if (response.statusCode == 400) {
      print(response.body);
      return false;
    }
  } catch (error) {
    print("Error verifying email: $error");
  }
  return null;
}

Future<String?> sendOTPCodeForSignUp(
    String email, String fName, String lName) async {
  final uri = Uri.parse("$endpoint/user/otp/send/signUp");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"email": email, "fName": fName, "lName": lName}),
    );

    if (response.statusCode == 200) {
      print("post successful!");
      print(response.body);
      final res = json.decode(response.body);
      return res['data'];
    } else if (response.statusCode == 400) {
      print(response.body);
      return "Error";
    }
  } catch (error) {
    print("Error receiving: $error");
  }
  return null;
}

Future<String?> sendOTPCodeForForgotPassword(String email) async {
  final uri = Uri.parse("$endpoint/user/otp/send/forgotPassword");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      print("post successful!");
      print(response.body);
      final res = json.decode(response.body);
      return res['data'];
    } else if (response.statusCode == 400) {
      print(response.body);
      return "Error";
    } else if (response.statusCode == 401) {
      print(response.body);
      return "Email doesn't exists";
    }
  } catch (error) {
    print("Error receiving: $error");
  }
  return null;
}

Future<bool?> verifyOTPCode(String email, String hash, String otp) async {
  final uri = Uri.parse("$endpoint/user/otp/verify");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"email": email, "hash": hash, "otp": otp}),
    );

    if (response.statusCode == 200) {
      print("post successful!");
      print(response.body);
      return true;
    } else if (response.statusCode == 400) {
      print(response.body);
      return false;
    }
  } catch (error) {
    print("Error receiving: $error");
  }
  return null;
}

Future<User?> postNewUser(
    String email, String fName, String lName, String password) async {
  final uri = Uri.parse("$endpoint/user/create");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": email,
        "fName": fName,
        "lName": lName,
        "password": password
      }),
    );
    if (response.statusCode == 201) {
      print("added user successfully");
      final jsonData = json.decode(response.body);
      return User(jsonData['id'], jsonData['firstname'], jsonData['lastname'],
          jsonData['email'], jsonData['ispublic']);
    } else if (response.statusCode == 400) {
      print(response.body);
      return null;
    }
  } catch (error) {
    print("Error adding user: $error");
  }
  return null;
}

Future<User?> changeUserPassword(String email, String password) async {
  final uri = Uri.parse("$endpoint/user/changePassword");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"email": email, "password": password}),
    );
    if (response.statusCode == 201) {
      print("password changed successfully");
      final jsonData = json.decode(response.body);
      return User(jsonData['id'], jsonData['firstname'], jsonData['lastname'],
          jsonData['email'], jsonData['ispublic']);
    } else if (response.statusCode == 400) {
      print(response.body);
      return null;
    }
  } catch (error) {
    print("Error adding user: $error");
  }
  return null;
}

Future<User?> loginWithEmailAndPassword(String email, String password) async {
  final uri = Uri.parse("$endpoint/user/login");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      print("login successful");
      final jsonData = json.decode(response.body);
      return User(jsonData['id'], jsonData['firstname'], jsonData['lastname'],
          jsonData['email'], jsonData['ispublic']);
    } else if (response.statusCode == 401) {
      print(response.body);
      return User(-1, "", "", "", true);
    } else {
      return null;
    }
  } catch (error) {
    print("Error logging in: $error");
  }
  return null;
}

Future<User?> loginOrSignUpWithGoogle(
    String email, String fName, String lName) async {
  final uri = Uri.parse("$endpoint/user/create/google");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": email,
        "fName": fName,
        "lName": lName,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return User(jsonData['id'], jsonData['firstname'], jsonData['lastname'],
          jsonData['email'], jsonData['ispublic']);
    } else if (response.statusCode == 400) {
      return User(-1, "", "", "", true);
    }
  } catch (error) {
    print("Error adding user: $error");
  }
  return null;
}

Future<User?> changeUserPersonalDetails(
    int id, String fName, String lName, bool isVisible) async {
  print("entered function change details");
  final uri = Uri.parse("$endpoint/user/changePersonalDetails");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "id": id,
        "firstname": fName,
        "lastname": lName,
        "ispublic": isVisible
      }),
    );
    if (response.statusCode == 201) {
      print("details changed successfully");
      final jsonData = json.decode(response.body);
      return User(jsonData['id'], jsonData['firstname'], jsonData['lastname'],
          jsonData['email'], jsonData['ispublic']);
    } else if (response.statusCode == 400) {
      print(response.body);
      return null;
    }
  } catch (error) {
    print("Error changing user details: $error");
  }
  return null;
}
