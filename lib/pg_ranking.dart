import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pg_main.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Map<String, dynamic>> rankingData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRankingData();
  }

  Future<void> _fetchRankingData() async {
    final response = await http.get(Uri.parse('http://192.168.0.20:8080/ranking'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      data.sort((a, b) {
        int scoreA = (a['u_lv'] ?? 0) * 100 + (a['u_exp'] ?? 0);
        int scoreB = (b['u_lv'] ?? 0) * 100 + (b['u_exp'] ?? 0);
        return scoreB.compareTo(scoreA); // 내림차순 정렬
      });

      setState(() {
        rankingData = data.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return {
            "rank": index + 1,
            "name": item["name"],
            "level": item["u_lv"] ?? 0,
            "categories": ["A", "B", "C", "D"], // 해당 사용자가 기록한 카테고리로 업데이트 필요
            "change": item["change"] ?? 0, // 전일 대비 랭킹 변동값
          };
        }).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load ranking data');
    }
  }

  IconData _getChangeIcon(int change) {
    if (change > 0) {
      return Icons.arrow_upward;
    } else if (change < 0) {
      return Icons.arrow_downward;
    } else {
      return Icons.remove;
    }
  }

  Color _getChangeColor(int change) {
    if (change > 0) {
      return Colors.green;
    } else if (change < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.star),
                        SizedBox(width: 8),
                        Text('랭킹',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                ));
                          },
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: rankingData.length,
                              itemBuilder: (context, index) {
                                final item = rankingData[index];
                                return ListTile(
                                  title: Text(
                                    '${item["rank"]}st - Lv.${item["level"]} ${item["name"]}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(item["categories"].join(" / ")),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${item["change"]}',
                                        style: TextStyle(
                                          color: _getChangeColor(item["change"]),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        _getChangeIcon(item["change"]),
                                        color: _getChangeColor(item["change"]),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
