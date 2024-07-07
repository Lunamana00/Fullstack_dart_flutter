import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String id;
  String name;
  String charType;
  int level;
  int exp;
  Map<String, dynamic> coding;
  Map<String, dynamic> reading;
  Map<String, dynamic> fitness;
  Map<String, dynamic> music;

  UserModel({
    required this.id,
    required this.name,
    required this.charType,
    required this.level,
    required this.exp,
    required this.coding,
    required this.reading,
    required this.fitness,
    required this.music,
  });

  void updateUser(List<dynamic> userInfo) {
    id = userInfo[0]['id'];
    name = userInfo[0]['name'];
    charType = userInfo[0]['char_type'];
    level = userInfo[0]['u_lv'];
    exp = userInfo[0]['u_exp'];
    coding = userInfo[1];
    reading = userInfo[2];
    fitness = userInfo[3];
    music = userInfo[4];
    notifyListeners();
  }
}
