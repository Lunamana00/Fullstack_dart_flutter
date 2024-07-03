import 'package:flutter/material.dart';
import 'pg_login.dart';
import 'pg_register.dart';
import 'pg_main.dart';
import 'pg_calendar.dart';

final Map<String, WidgetBuilder> route_controller = {
  '/login': (context) => LoginPage(),
  '/signup': (context) => RegisterPage(),
  '/pg_main': (context) => MainPage(),
  '/pg_calendar': (context) => CalendarScreen()
};