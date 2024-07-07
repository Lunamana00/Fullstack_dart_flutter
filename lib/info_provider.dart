import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void updateExperienceAndLevel(
    String subject,
    int userExp,
    int userLevel,
    int subjectExp,
    int subjectLevel,
  ) {
    exp = userExp;
    level = userLevel;
    if (subject == 'A') {
      A['exp'] = subjectExp;
      A['lv'] = subjectLevel;
    } else if (subject == 'B') {
      B['exp'] = subjectExp;
      B['lv'] = subjectLevel;
    } else if (subject == 'C') {
      C['exp'] = subjectExp;
      C['lv'] = subjectLevel;
    } else if (subject == 'D') {
      D['exp'] = subjectExp;
      D['lv'] = subjectLevel;
    }
    notifyListeners();
  }

  Future<List<String>> fetchDatesForSubject(String subject) async {
    final response = await http.get(Uri.parse('http://$myip:8080/user_info/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (subject == 'A') {
        return List<String>.from(data[1]['dates']);
      } else if (subject == 'B') {
        return List<String>.from(data[2]['dates']);
      } else if (subject == 'C') {
        return List<String>.from(data[3]['dates']);
      } else if (subject == 'D') {
        return List<String>.from(data[4]['dates']);
      }
    }
    return [];
  }
}
