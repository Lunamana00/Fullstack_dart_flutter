import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'info_provider.dart';
import 'pg_login.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Provider 생성 / My App 실행 - 로그인화면
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(
        id: '',
        name: '',
        charType: '',
        level: 0,
        exp: 0,
        A: {'lv': 0, 'exp': 0},
        B: {'lv': 0, 'exp': 0},
        C: {'lv': 0, 'exp': 0},
        D: {'lv': 0, 'exp': 0},
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  // 로그인 화면
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starting point',
      home: LoginPage(),
    );
  }
}
