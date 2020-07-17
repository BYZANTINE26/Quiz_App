import 'package:demoquiz/data.dart';
import 'package:demoquiz/home.dart';
import 'package:demoquiz/rear.dart';
import 'package:demoquiz/youtube.dart';
import 'package:flutter/material.dart';
import 'package:demoquiz/data.dart';
import 'shot.dart';

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
      home: Youtube(),
    );
  }
}
