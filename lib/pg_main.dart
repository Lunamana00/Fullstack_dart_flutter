import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom UI',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(10.0),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildIconButton(
                    icon: Icons.computer,
                    onPressed: () {
                      _navigateTo(context, CodingPage());
                    },
                  ),
                  _buildIconButton(
                    icon: Icons.book,
                    onPressed: () {
                      _navigateTo(context, ReadingPage());
                    },
                  ),
                  _buildIconButton(
                    icon: Icons.fitness_center,
                    onPressed: () {
                      _navigateTo(context, WorkoutPage());
                    },
                  ),
                  _buildIconButton(
                    icon: Icons.music_note,
                    onPressed: () {
                      _navigateTo(context, MusicPage());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
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
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: AssetImage('assets/not_my_fault.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              _navigateTo(context, SettingsPage());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '김태현',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.star),
                      label: Text('랭킹'),
                      onPressed: () {
                        _navigateTo(context, RankingPage());
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.group),
                      label: Text('커뮤니티'),
                      onPressed: () {
                        _navigateTo(context, CommunityPage());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade300,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

// Example pages for navigation
class CodingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코딩 페이지'),
      ),
      body: Center(
        child: Text('이곳은 코딩 페이지입니다'),
      ),
    );
  }
}

class ReadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('독서 페이지'),
      ),
      body: Center(
        child: Text('이곳은 독서 페이지입니다'),
      ),
    );
  }
}

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 페이지'),
      ),
      body: Center(
        child: Text('이곳은 운동 페이지입니다'),
      ),
    );
  }
}

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음악 페이지'),
      ),
      body: Center(
        child: Text('이곳은 음악 페이지입니다'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정 페이지'),
      ),
      body: Center(
        child: Text('이곳은 설정 페이지입니다'),
      ),
    );
  }
}

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('랭킹 페이지'),
      ),
      body: Center(
        child: Text('이곳은 랭킹 페이지입니다'),
      ),
    );
  }
}

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티 페이지'),
      ),
      body: Center(
        child: Text('이곳은 커뮤니티 페이지입니다'),
      ),
    );
  }
}
