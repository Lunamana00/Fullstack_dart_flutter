import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'pg_record.dart';
import 'info_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  final IconData icon;
  final String name;
  final Map<String, dynamic> levelData;

  CalendarPage(
      {super.key, required this.icon, required this.name, required this.levelData});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<DateTime> _streakDays = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStreakDays();
  }

  Future<void> _loadStreakDays() async {
    var user = Provider.of<UserModel>(context, listen: false);
    String subject = _getSubjectFromIcon(widget.icon);

    var response = await http.get(Uri.parse('http://${user.myip}:8080/user_info/${user.id}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> dates = [];
      if (subject == 'A') {
        dates = List<String>.from(data[1]['dates']);
      } else if (subject == 'B') {
        dates = List<String>.from(data[2]['dates']);
      } else if (subject == 'C') {
        dates = List<String>.from(data[3]['dates']);
      } else if (subject == 'D') {
        dates = List<String>.from(data[4]['dates']);
      }

      setState(() {
        _streakDays = dates.map((date) {
          int year = int.parse(date.substring(0, 4));
          int month = int.parse(date.substring(4, 6));
          int day = int.parse(date.substring(6, 8));
          return DateTime(year, month, day);
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getSubjectFromIcon(IconData icon) {
    if (icon == Icons.code) {
      return 'A';
    } else if (icon == Icons.book) {
      return 'B';
    } else if (icon == Icons.fitness_center) {
      return 'C';
    } else if (icon == Icons.music_note) {
      return 'D';
    } else {
      return 'ETC';
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(31, 255, 154, 154),
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TableCalendar(
                        firstDay: DateTime.utc(2022, 1, 1),
                        lastDay: DateTime.utc(DateTime.now().year, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        availableCalendarFormats: const {CalendarFormat.month: ''},
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) async {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecordPage(date: selectedDay),
                            ),
                          );
                          if (result == true) {
                            _loadStreakDays();
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            for (DateTime d in _streakDays) {
                              if (isSameDay(day, d)) {
                                return Center(
                                  child: Icon(
                                    Icons.check,
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    size: 30,
                                  ),
                                );
                              }
                            }
                            return Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            bool isStreakDay = _streakDays.any((d) => isSameDay(day, d));
                            return Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  if (isStreakDay)
                                    Icon(
                                      Icons.check,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      size: 20,
                                    ),
                                  if (!isStreakDay)
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(widget.icon, size: 40),
                        SizedBox(width: 10),
                        Text(
                          'Lv. ${widget.levelData['lv']} ${widget.name}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: widget.levelData['exp'] / 100,
                      minHeight: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}