import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pg_write.dart';
import 'info_provider.dart';

class RecordPage extends StatelessWidget {
  final DateTime date;

  RecordPage({required this.date});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${date.year}년 ${date.month}월 ${date.day}일',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.code,
                  label: '코딩',
                ),
                const SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.book,
                  label: '독서',
                ),
                const SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.fitness_center,
                  label: '운동',
                ),
                const SizedBox(height: 20),
                buildItem(
                  context,
                  icon: Icons.music_note,
                  label: '음악',
                ),
                const SizedBox(height: 20),
                buildItem(
                  context,
                  customIcon: const Text(
                    "ETC",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  label: '기타',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context,
      {IconData? icon, Widget? customIcon, required String label}) {
    var user = Provider.of<UserModel>(context);

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
              const SizedBox(height: 5),
              Text(label),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
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
