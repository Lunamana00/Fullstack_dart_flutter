/*
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'info_provider.dart';
import 'pg_login.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Provider 생성 / My App 실행 - 로그인화면
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(
        id: '',
        name: '',
        charType: '',
        level: 0,
        exp: 0,
        A: {'lv': 0, 'exp': 0},
        B: {'lv': 0, 'exp': 0},
        C: {'lv': 0, 'exp': 0},
        D: {'lv': 0, 'exp': 0},
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  // 로그인 화면
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starting point',
      home: LoginPage(),
    );
  }
}
