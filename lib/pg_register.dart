import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  var selectedCharacter;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({required this.selectedCharacter});
  final myip = '192.168.0.20';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.all(20.0),
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
                  controller: nameController,
                  decoration: InputDecoration(labelText: '이름'),
                ),
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
                ElevatedButton(
                  onPressed: () async {
                    var url = Uri.parse('http://${myip}:8080/register');
                    var response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'name': nameController.text,
                        'id': idController.text,
                        'pw': passwordController.text,
                        'char_type': selectedCharacter
                      }),
                    );

                    if (response.statusCode == 200) {
                      Navigator.pushReplacementNamed(context, '/login');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원가입 완료')),
                      );
                    } else if (response.statusCode == 101) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('중복된 아이디 입니다')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원가입 실패')),
                      );
                    }
                  },
                  child: Text('회원가입'),
                  style: ElevatedButton.styleFrom(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
