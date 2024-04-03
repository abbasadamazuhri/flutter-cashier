import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_ecashier/models/user.dart';

Future<List<User>> getRequest() async {
  String url = "https://randomuser.me/api/?results=5";
  final response = await http.get(Uri.parse(url));
  var responseData = json.decode(response.body);
  List<User> users = [];
  for (var row in responseData["results"]) {
    User user = User(
      name: row["name"]["title"] +
          " " +
          row["name"]["first"] +
          " " +
          row["name"]["last"],
      picture: row["picture"]["large"],
      gender: row["gender"],
    );
    users.add(user);
  }
  return users;
}
