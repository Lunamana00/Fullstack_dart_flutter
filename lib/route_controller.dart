import 'package:flutter/material.dart';
import 'pg_login.dart';
import 'pg_ranking.dart';
import 'pg_charselect.dart';

final Map<String, WidgetBuilder> route_controller = {
  '/login': (context) => LoginPage(),
  '/pg_ranking': (context) => RankingPage(),
  'pg_charselect': (context) => CharacterSelectionPage()
};
