import 'package:flutter/material.dart';
import 'pg_profile.dart';

class MainPage extends StatelessWidget {
  final List<dynamic> userInfo;

  MainPage({required this.userInfo});

  String setRoute() {
    String route;
    if (userInfo[0]['u_lv'] < 33) {
      route = 'assets/char/${userInfo[0]["char_type"]}1.png';
    } else if (userInfo[0]['u_lv'] < 66) {
      route = 'assets/char/${userInfo[0]["char_type"]}2.png';
    } else {
      route = 'assets/char/${userInfo[0]["char_type"]}3.png';
    }
    return route;
  }

  @override
  Widget build(BuildContext context) {
    String route = setRoute();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    icon: Icons.code,
                    onPressed: () {
                      Navigator.pushNamed(context, '/pg_calendar');
                    },
                  ),
                  _buildIconButton(
                    icon: Icons.book,
                    onPressed: () {
                      Navigator.pushNamed(context, '/pg_calendar');
                    },
                  ),
                  _buildIconButton(
                    icon: Icons.fitness_center,
                    onPressed: () {
                      Navigator.pushNamed(context, '/pg_calendar');
                    },
                  ),
                  _buildIconButton(
                    icon: Icons.music_note,
                    onPressed: () {
                      Navigator.pushNamed(context, '/pg_calendar');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      name: userInfo[0]['name'],
                      level: userInfo[0]['u_lv'],
                      exp: userInfo[0]['u_exp'],
                      levelData: [
                        userInfo[1],
                        userInfo[2],
                        userInfo[3],
                        userInfo[4]
                      ],
                      route: route,
                      userInfo: userInfo,
                    ),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 238, 238),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                          image: AssetImage(route), // 프로필 이미지 경로
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 225, 195, 229),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'Lv.${userInfo[0]["u_lv"]}', // 여기에 userInfo 사용
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    userInfo[0]["name"], // 유저 이름 표시
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: FractionallySizedBox(
                                      widthFactor: userInfo[0]["u_exp"] / 100,
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.star,
                        size: 34,
                      ),
                      label: Text(
                        '랭킹',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/pg_ranking');
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

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onPressed}) {
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
