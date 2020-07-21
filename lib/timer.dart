import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import  'package:circular_countdown/circular_countdown.dart';


class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('timer'),
      ),
      body: Container(
        child: Center(
          child: CircularCountdown(
            countdownTotal: 10,
            countdownRemaining: 5,
          ),
        ),
      ),
    );
  }
}
