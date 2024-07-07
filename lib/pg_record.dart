import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pg_write.dart';
import 'info_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class RecordPage extends StatefulWidget {
  final DateTime date;

  RecordPage({required this.date});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<dynamic> records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    var user = Provider.of<UserModel>(context, listen: false);
    final parsedDate = DateTime.parse(widget.date.toIso8601String());
    var response = await http.get(Uri.parse(
        'http://${user.myip}:8080/record/${user.id}/${parsedDate.year}${parsedDate.month.toString().padLeft(2, '0')}${parsedDate.day.toString().padLeft(2, '0')}'));
    if (response.statusCode == 200) {
      setState(() {
        records = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 248, 240, 247),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일',
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_back, size: 30),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildItem(context, 'A', Icons.code, '코딩'),
                      const SizedBox(height: 20),
                      buildItem(context, 'B', Icons.book, '독서'),
                      const SizedBox(height: 20),
                      buildItem(context, 'C', Icons.fitness_center, '운동'),
                      const SizedBox(height: 20),
                      buildItem(context, 'D', Icons.music_note, '음악'),
                      const SizedBox(height: 20),
                      buildItem(
                        context,
                        'ETC',
                        null,
                        '기타',
                        customIcon: const Text(
                          "ETC",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, String subject, IconData? icon,
      String label, {Widget? customIcon}) {
    var user = Provider.of<UserModel>(context);

    var record = records.firstWhere(
        (record) => record['subject'] == subject,
        orElse: () => null);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (icon != null)
                    Icon(icon, size: 30)
                  else if (customIcon != null)
                    customIcon,
                  const SizedBox(height: 5),
                  Text(label),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (record != null &&
                        record['images'] != null &&
                        record['images'].isNotEmpty)
                      Row(
                        children: record['images'].map<Widget>((image) {
                          Uint8List imageBytes = base64Decode(image);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Image.memory(imageBytes,
                                width: 30, height: 30),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                    if (record != null)
                      Text(record['comment'] ?? 'No comment'),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriteScreen(
                          date: widget.date,
                          icon: icon,
                          customIcon: customIcon,
                          initialImages: record != null
                              ? record['images']
                                  .map<Uint8List>((image) => base64Decode(image))
                                  .toList()
                              : [],
                          initialComment:
                              record != null ? record['comment'] : '',
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _loadRecords();
                      });
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
