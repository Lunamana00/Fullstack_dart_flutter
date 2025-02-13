import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'info_provider.dart';
import 'pg_main.dart';
import 'pg_charselect.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<UserModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            var url = Uri.parse('http://${_user.myip}:8080/login');
                            var response = await http.post(
                              url,
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'id': idController.text,
                                'pw': passwordController.text,
                              }),
                            );

                            if (response.statusCode == 200) {
                              var user = jsonDecode(response.body);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('로그인 성공')),
                              );

                              // 유저 정보를 추가로 요청
                              var userInfoUrl = Uri.parse(
                                  'http://${_user.myip}:8080/user_info/${user['id']}');
                              var userInfoResponse =
                                  await http.get(userInfoUrl);
                              var userInfo = jsonDecode(userInfoResponse.body);

                              // Provider로 상태 업데이트
                              Provider.of<UserModel>(context, listen: false)
                                  .updateUser(userInfo);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainPage()
                                ),
                              );
                            } else if (response.statusCode == 201) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('ID 혹은 비밀번호가 일치하지 않습니다')),
                              );
                            }
                          },
                          child: const Text('로그인'),
                          style: ElevatedButton.styleFrom(),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CharacterSelectionPage()));
                          },
                          child: const Text('회원가입'),
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
