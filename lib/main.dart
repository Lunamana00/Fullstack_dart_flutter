import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'info_provider.dart';
import 'pg_login.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Signup',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(),
    );
  }
}
