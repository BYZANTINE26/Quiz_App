import 'package:demoquiz/pages/home.dart';
import 'package:demoquiz/timer.dart';
import 'package:flutter/material.dart';
import 'ongoing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DemoQuiz',
      theme: ThemeData.dark(),
      home: OnGoing(),
    );
  }
}
