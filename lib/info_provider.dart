import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String id;
  String name;
  String charType;
  int level;
  int exp;
  Map<String, dynamic> A;
  Map<String, dynamic> B;
  Map<String, dynamic> C;
  Map<String, dynamic> D;
  String myip = '192.168.0.20';

  UserModel({
    required this.id,
    required this.name,
    required this.charType,
    required this.level,
    required this.exp,
    required this.A,
    required this.B,
    required this.C,
    required this.D,
  });

  void updateUser(List<dynamic> userInfo) {
    id = userInfo[0]['id'];
    name = userInfo[0]['name'];
    charType = userInfo[0]['char_type'];
    level = userInfo[0]['u_lv'];
    exp = userInfo[0]['u_exp'];
    A = userInfo[1];
    B = userInfo[2];
    C = userInfo[3];
    D = userInfo[4];
    notifyListeners();
  }
}
