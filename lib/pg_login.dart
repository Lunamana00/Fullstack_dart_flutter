import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
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
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(labelText: 'ID'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            var url =
                                Uri.parse('http://192.168.55.225:8080/login');
                            var response = await http.post(
                              url,
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'id': idController.text,
                                'pw': passwordController.text,
                              }),
                            );

                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('로그인 성공')),
                              );
                              Navigator.pushNamed(context, '/pg_main');
                            } else if (response.statusCode == 201) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('ID 혹은 비밀번호가 일치하지 않습니다')),
                              );
                            }
                          },
                          child: Text('로그인'),
                          style: ElevatedButton.styleFrom(),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text('회원가입'),
                          style: ElevatedButton.styleFrom(),
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
    );
  }
}
