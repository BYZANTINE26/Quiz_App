import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../ongoing.dart';

class Greetings extends StatefulWidget {
  final String name;
  Greetings({@required this.name});
  @override
  _GreetingsState createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Greetings'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/resultbg.jpg'), fit: BoxFit.fill),),
          child: Card(
            elevation: 20.0,
            margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 100.0, bottom: 100.0),
            color: Color(0xFF006666),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF006666),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Thank You ' + widget.name + ' for your valuable time !', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.white,
                      height: 7.5,
                      thickness: 1.5,
                      indent: 120,
                      endIndent: 120,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('The Poll is over', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      child: ButtonTheme(
                        minWidth: 170.0,
                        height: 50.0,
                        child: RaisedButton(
                          padding: EdgeInsets.all(8.0),
                          color: Color(0xFF006666),
                          splashColor: Colors.blueGrey,
                          highlightColor: Colors.yellowAccent,
                          elevation: 25.0,
                          onPressed: () {
                            setState(() {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnGoing()));
//                            Navigator.pushAndRemoveUntil(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => HomePage()),
//                                (route) => false);
                            });
                          },
                          child: Container(
                            width: 250.0,
                            height: 50.0,
                            child: Center(
                              child: Shimmer.fromColors(
                                baseColor: Colors.blueGrey,
                                highlightColor: Colors.white38,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      Icons.settings_backup_restore,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                    Text(
                                      'PLAY AGAIN',
                                      style: TextStyle(
                                          fontSize: 35.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey.shade200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );  }
}
