import 'package:flutter/material.dart';
import 'pg_login.dart';
import 'pg_register.dart';
import 'pg_main.dart';
import 'route_controller.dart';
import 'package:table_calendar/table_calendar.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Signup',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(),
      routes: route_controller,
    );
  }
}