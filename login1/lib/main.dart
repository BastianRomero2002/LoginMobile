import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 18, 140, 97),
        hintColor: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'San Francisco',
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
