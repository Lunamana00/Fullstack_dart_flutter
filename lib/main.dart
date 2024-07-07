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
        level: 1,
        exp: 0,
        coding: {'lv': 1, 'exp': 0},
        reading: {'lv': 1, 'exp': 0},
        fitness: {'lv': 1, 'exp': 0},
        music: {'lv': 1, 'exp': 0},
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
