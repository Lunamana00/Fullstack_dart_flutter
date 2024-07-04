import 'package:flutter/material.dart';
import 'pg_write.dart';

class DetailScreen extends StatelessWidget {
  final DateTime date;

  DetailScreen({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 240, 247),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${date.year}년 ${date.month}월 ${date.day}일',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.code,
                  label: 'Comment',
                ),
                SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.book,
                  label: 'Comment',
                ),
                SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.fitness_center,
                  label: 'Comment',
                ),
                SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.music_note,
                  label: 'Comment',
                ),
                SizedBox(height: 20),
                buildItem(
                  context,
                  customIcon: Text(
                    "ETC",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  label: 'Comment',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context,
      {IconData? icon, Widget? customIcon, required String label}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Icon(icon, size: 30)
              else if (customIcon != null)
                customIcon,
              SizedBox(height: 5),
              Text(label),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteScreen(
                    date: this.date,
                    icon: icon,
                    customIcon: customIcon,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
