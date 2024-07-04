import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  final List<Map<String, dynamic>> rankingData = [
    {
      "rank": 1,
      "level": 100,
      "name": "김태현",
      "categories": ["운동", "코딩", "독서"],
      "change": 1
    },
    {
      "rank": 2,
      "level": 99,
      "name": "B",
      "categories": ["운동", "코딩", "독서"],
      "change": 3
    },
    {
      "rank": 3,
      "level": 80,
      "name": "C",
      "categories": ["운동", "코딩", "독서"],
      "change": 1
    },
    {
      "rank": 4,
      "level": 67,
      "name": "D",
      "categories": ["운동", "코딩", "독서"],
      "change": 0
    },
    {
      "rank": 5,
      "level": 55,
      "name": "E",
      "categories": ["운동", "코딩", "독서"],
      "change": 4
    },
    {
      "rank": 6,
      "level": 67,
      "name": "F",
      "categories": ["운동", "코딩", "독서"],
      "change": 5
    },
    {
      "rank": 7,
      "level": 55,
      "name": "G",
      "categories": ["운동", "코딩", "독서"],
      "change": 6
    },
    // 추가 데이터...
  ];

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
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
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
                                Text('↑${item["change"]}'),
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
