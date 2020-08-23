import 'package:flutter/material.dart';
import 'dart:async';

class Timerr extends StatefulWidget {
  @override
  _TimerrState createState() => _TimerrState();
}

class _TimerrState extends State<Timerr> {
  bool _loading;
  double _progressValue;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LinearProgressIndicator"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: _loading
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                value: _progressValue,
              ),
              Text('${(_progressValue * 100).round()}%'),
            ],
          )
              : Text("Press button to download"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loading = !_loading;
            _updateProgress();
          });
        },
        tooltip: 'Download',
        child: Icon(Icons.cloud_download),
      ),
    );
  }

  // we use this function to simulate a download
  // by updating the progress value
  void _updateProgress() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue -= 0.1;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '0.0') {
          _loading = false;
          t.cancel();
          _progressValue = 1.0;
          return;
        }
      });
    });
  }
}
