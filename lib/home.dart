import 'dart:ui';
import 'package:demoquiz/shot.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shimmer/shimmer.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('QUIZ'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red]
            )
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      width: 250.0,
                      child: FadeAnimatedTextKit(
                          onTap: () {},
                          text: [
                            "Let's!",
                            "Let's Get!!",
                            "Let's Get Started!!!"
                          ],
                          textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 390.0),
                    child: ButtonTheme(
                      minWidth: 200.0,
                      height: 70.0,
                      child: RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.yellow.shade400,
                        splashColor: Colors.blueGrey,
                        highlightColor: Colors.yellowAccent,
                        elevation: 5.0,
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Shot()),
                            );
                          });
                            },
                        child: Container(
                          width: 200.0,
                          height: 70.0,
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.blue,
                              highlightColor: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    'START',
                                    style:  TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade200
                                    ),
                                  ),
                                  Icon(
                                      Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                ],
                              ),
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
    );
  }
}
