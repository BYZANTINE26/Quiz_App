import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

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
          child: CircularCountDownTimer(
            duration: 30,
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height/2,
            color: Colors.white,
            fillColor: Colors.red,
            strokeWidth: 5.0,
            textStyle: TextStyle(
              fontSize: 22.0,
              color: Colors.black87,
              fontWeight: FontWeight.bold
            ),
            isReverse: true,
            onComplete: (){
              print('countdown ended');
            },
          ),
        ),
      ),
    );
  }
}
