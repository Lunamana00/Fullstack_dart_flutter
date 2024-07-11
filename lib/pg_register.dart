import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'info_provider.dart';
import 'pg_login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  final String selectedCharacter;
  
  RegisterPage({required this.selectedCharacter});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late UserModel user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: const Text('회원가입'),
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '이름'),
                ),
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
                ElevatedButton(
                  onPressed: () async {
                    var url = Uri.parse('http://${user.myip}:8080/register');
                    var response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'name': nameController.text,
                        'id': idController.text,
                        'pw': passwordController.text,
                        'char_type': widget.selectedCharacter
                      }),
                    );

                    if (response.statusCode == 200) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('회원가입 완료')),
                      );
                    } else if (response.statusCode == 101) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('중복된 아이디 입니다')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('회원가입 실패')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
