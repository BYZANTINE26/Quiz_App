import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';

//import 'package:circular_countdown/circular_countdown.dart';
//import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoquiz/youtube.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'timer.dart';

class Yuvi extends StatefulWidget {
  @override
  _YuviState createState() => _YuviState();
}

class _YuviState extends State<Yuvi> {
  int currentIndex = 0;
  int totalScore = 0;

  List<String> imageBank = [];
  void getImage() async {
    String imageLink;
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
                imageLink = value.data['questions'][i]['image'].toString();
              }));
      print(imageLink);
      imageBank.add(imageLink);
      print(imageBank);
    }
  }

  List<String> typeBank = [];
  void getType() async {
    String type;
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
                type = value.data['questions'][i]['question_type'];
              }));
      print(type);
      typeBank.add(type);
      print(typeBank);
    }
  }

  List<String> questionBank = [];
  void getQuestions() async {
    String question;
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
                question = value.data['questions'][i]['question'].toString();
              }));
      print(question);
      questionBank.add(question);
      print(questionBank);
    }
  }

  List optionsBank = [];
  void getOptions() async {
    dynamic options;
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
                options = value.data['questions'][i]['answers'];
              }));
      print(options);
      optionsBank.add(options);
      print(optionsBank);
    }
  }

  List correctAnswers = [];
  void getCorrectAnswer() async {
    dynamic correctAnswer;
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
                correctAnswer = value.data['questions'][i]['correct_answer'];
              }));
      print(correctAnswer);
      correctAnswers.add(correctAnswer);
      print(correctAnswers);
    }
  }

  List<int> scores = [];
  void getScore() async {
    int score;
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
                score = value.data['questions'][i]['score'];
              }));
      print(score);
      scores.add(score);
      print(scores);
    }
  }

  @override
  void initState() {
    startTimer();
    getImage();
    getType();
    getQuestions();
    getOptions();
    getCorrectAnswer();
    getScore();
    super.initState();
  }

  static int timer = 10;
  bool cancelTimer = false;
  bool pauseTimer = false;
  String showTimer = timer.toString();
  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          currentIndex = 1;
          re();
        } else if (pauseTimer == true){
          t.cancel();
          startTimer();
        }else if (cancelTimer == true) {
          t.cancel();
          re();
        } else {
          timer = timer - 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  re(){
    timer = 10;
    cancelTimer = false;
    startTimer();
  }

  ima() {
    if (imageBank[currentIndex] == null) {
      return Expanded(
        flex: 1,
        child: Container(),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Center(
          child: Container(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState((){
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Youtube()),
                    );
                  });
                },
                child: Image.network(imageBank[currentIndex].toString()),
              ),
            ),
          ),
        ),
      );
    }
  }

  ques() {
    if (questionBank == null) {
      return Row();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              questionBank[currentIndex],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    }
  }

  bool ans;
  dialog(){
    if (ans == true) {
      return AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'CORRECT ANSWER',
//          desc:
//          'Dialog description here..................................................',
        btnOkOnPress: () {
          cancelTimer = true;
          currentIndex = 1;
        },
        btnOkText: 'NEXT QUESTION',
        btnOkIcon: Icons.check_circle,
//          onDissmissCallback: () {
//            debugPrint('Dialog Dissmiss from callback');
//          },
      )
        ..show();
    } else if (ans == false) {
      return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: 'WRONG ANSWER',
//          desc:
//          'Dialog description here..................................................',
          btnOkOnPress: () {
            cancelTimer = true;
            currentIndex = 1;
          },
          btnOkText: 'NEXT QUESTION',
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
        ..show();
    } else {
      return Container();
    }
  }

  dynamic userPicked;
  checkAnswer() {
    if (userPicked == correctAnswers[currentIndex]) {
      totalScore += scores[currentIndex];
//      currentIndex = 1;
      ans = true;
//      return dialog();
    } else {
      ans = false;
//      return dialog();
    }
  }

  trueFalse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ButtonTheme(
          minWidth: 200.0,
          height: 75.0,
          child: RaisedButton(
            padding: EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.green.shade400,
            splashColor: Colors.blueGrey,
            highlightColor: Colors.greenAccent,
            elevation: 5.0,
            onPressed: () {
              setState(() {
                cancelTimer = true;
                userPicked = true;
                checkAnswer();
//                re();
//                print(currentIndex);
//                userPicked = true;
//                checkAnswer();
              });
            },
            child: Text(
              'True',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
              ),
            ),
          ),
        ),
        ButtonTheme(
          minWidth: 200.0,
          height: 75.0,
          child: RaisedButton(
            padding: EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.red.shade400,
            splashColor: Colors.blueGrey,
            highlightColor: Colors.redAccent,
            elevation: 5.0,
            onPressed: () {
              setState(() {
                currentIndex++;
//                userPicked = false;
//                checkAnswer();
//                getD();
//                                currentIndex += 1;
              });
            },
            child: Text(
              'False',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  mcq() {
    if (optionsBank[currentIndex] == null) {
      return Container();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                minWidth: 200.0,
                height: 75.0,
                child: RaisedButton(
                  color: Colors.yellow.shade400,
                  splashColor: Colors.blueGrey,
                  highlightColor: Colors.yellowAccent,
                  elevation: 5.0,
                  onPressed: () {
                    setState(() {
//                      userPicked = answers[0].toString();
//                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    optionsBank[currentIndex][0].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              ButtonTheme(
                minWidth: 200.0,
                height: 75.0,
                child: RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.yellow.shade400,
                  splashColor: Colors.blueGrey,
                  highlightColor: Colors.yellowAccent,
                  elevation: 5.0,
                  onPressed: () {
                    setState(() {
//                      userPicked = answers[1].toString();
//                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    optionsBank[currentIndex][1].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                minWidth: 200.0,
                height: 75.0,
                child: RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.yellow.shade400,
                  splashColor: Colors.blueGrey,
                  highlightColor: Colors.yellowAccent,
                  elevation: 5.0,
                  onPressed: () {
                    setState(() {
//                      userPicked = answers[2].toString();
//                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    optionsBank[currentIndex][2].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              ButtonTheme(
                minWidth: 200.0,
                height: 75.0,
                child: RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.yellow.shade400,
                  splashColor: Colors.blueGrey,
                  highlightColor: Colors.yellowAccent,
                  elevation: 5.0,
                  onPressed: () {
                    setState(() {
//                      userPicked = answers[3].toString();
//                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    optionsBank[currentIndex][3].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  rear() {
    if (optionsBank[currentIndex] == null) {
      return Container();
    } else {
      return Container(
        child: Center(
          child: ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: List.generate(
              optionsBank[currentIndex].length,
                  (index) {
                return ListViewCard(
                  optionsBank[currentIndex],
                  index,
                  Key('$index'),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  opt() {
    if (typeBank[currentIndex] == "True/False") {
      return Expanded(
        flex: 1,
        child: Center(
          child: trueFalse(),
        ),
      );
    } else if (typeBank[currentIndex] == "MCQ") {
      return Expanded(
        flex: 1,
        child: Center(
          child: rear(),
        ),
      );
    } else if (typeBank[currentIndex] == "Re-arrange") {
      return Expanded(
        flex: 1,
        child: Center(
          child: Container(),
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(),
      );
    }
  }

  submit(){
    if (typeBank[currentIndex] == "MCQ"){
      return ButtonTheme(
        minWidth: 120.0,
        height: 25.0,
        child: RaisedButton(
          padding: EdgeInsets.all(10.0),
          color: Colors.grey.shade800,
          splashColor: Colors.blueGrey,
          highlightColor: Colors.grey.shade600,
          elevation: 10.0,
          onPressed: () {
            setState(() {
//              currentIndex += 1;
//                print(currentIndex);
//              userPicked = answers;
//              checkOrder();
            });
          },
          child: Text(
            'Submit',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  sco(){
    return Center(
      child: Card(
        elevation: 20.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 120.0,
            height: 25.0,
            child: Center(
              child: Text(
                'Score:  ' + '$totalScore',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quiz"),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red])),
          child: Center(
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ima(),
                    ques(),
                    opt(),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              showTimer,
                            style: TextStyle(fontSize: 25.0),
                          ),
                          sco(),
//                          submit(),
//                          getScore(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
          () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
          print(optionsBank[currentIndex]);
        }
        final String item = optionsBank[currentIndex].removeAt(oldIndex);
        optionsBank[currentIndex].insert(newIndex, item);
        print(optionsBank[currentIndex]);
      },
    );
  }
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final List listItems;

  ListViewCard(this.listItems, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();
}

class _ListViewCard extends State<ListViewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.yellow,
      child: SizedBox(
        height: 60.0,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          '${widget.listItems[widget.index]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.black
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(
                  Icons.reorder,
                  color: Colors.grey,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
