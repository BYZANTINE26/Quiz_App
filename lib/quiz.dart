import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:demoquiz/pages/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoquiz/pages/youtube.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:polls/polls.dart';
import 'package:wakelock/wakelock.dart';
import 'package:customtoggleswitch/customtoggleswitch.dart';
import 'options/rearrage.dart';
import 'options/mcq.dart';


class Quizing extends StatefulWidget {
  final documentId;
  final bool music;
  final String emailId;
  final String userName;
  final int total;

  Quizing({@required this.documentId, @required this.emailId, @required this.userName, @required this.total, @required this.music});

  @override
  _QuizingState createState() => _QuizingState();
}

class _QuizingState extends State<Quizing> with WidgetsBindingObserver{
  int currentIndex;
  int totalScore = 0;
  int outOf = 0;
  int totalQuestions;

  QuerySnapshot documents;
  void getDocuments()async{
    documents = await Firestore.instance.collection('Quizes').document(widget.documentId).collection('Questions').getDocuments();
  }

  int option_1;
  int option_2;
  int option_3;
  int option_4;
  QuerySnapshot polls;
  void getPoll() async {
    polls = await Firestore.instance.collection('Quizes').document(widget.documentId).collection('Polls').getDocuments();
  }

  void play()async{
    _player = await _cache.loop('bgmusic.mp3');
  }

  DateTime start;
  DateTime end;
  int time;
  @override
  void initState()  {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Wakelock.enable();
    getDocuments();
    start = DateTime.now();
    currentIndex = 0;
    pollIndex = 0;
    timer = 10;
    totalQuestions = widget.total;
    video = false;
    startTimer();
//    getImage();
//    getVideo();
//    getType();
//    getQuestions();
//    getOptions();
    getPoll();
//    getCorrectAnswer();
//    getScore();
    widget.music ? play() : print('DON\'T PLAY') ;
    print(_player.state);
    status = widget.music;
    super.initState();
    Future.delayed(Duration(seconds: 1), () => (currentIndex == 0 && documents.documents[0].data['video'] != null) ? checkVideo() : print('NO VIDEO'));
    WidgetsBinding.instance.addObserver(this);
  }
  
  AudioCache _cache = AudioCache();
  AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
    _player.stop();
    _player.dispose();
  }

  bool video;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.detached:
        if (video == false) {
          _player.stop();
          _player.dispose();
        }
        break;
      case AppLifecycleState.inactive:
        if(video == false){
          _player.pause();
        }
        break;
      case AppLifecycleState.paused:
        if(video == false){
          _player.pause();
        }
        break;
      case AppLifecycleState.resumed:
        if(video == false){
          _player.resume();
        }
        break;
    }
  }

  @override
  void setState(fn){
    if (mounted){
      super.setState((fn));
    }
  }

  void updatePoll(String which) async {
    await Firestore.instance.collection('Quizes').document(widget.documentId)
        .collection("Polls")
        .document('poll_value_$currentIndex')
        .updateData({'option_$which': FieldValue.increment(1)});
  }

  void updateLongPoll(String which) async {
    await Firestore.instance.collection('Quizes').document(widget.documentId)
        .collection("Long_Polls")
        .document('poll_value_$currentIndex')
        .updateData({'option_$which': FieldValue.increment(1)});
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
          print('timer ended');
          t.cancel();
          setState((){
            ans = null;
          });
          dialog();
        } else if (pauseTimer == true) {
          t.cancel();
          print('timer paused');
        } else if (cancelTimer == true) {
          t.cancel();
          re();
        } else {
          timer = timer - 1;
          print(timer);
        }
        showTimer = timer.toString();
      });
    });
  }

  re() {
    timer = 10;
    cancelTimer = false;
    startTimer();
  }

  bool status;
  musicToggle(){
    return Center(
      child: Card(
        elevation: 15.0,
        child: Padding(
          padding: EdgeInsets.all(_height*0.015),
          child: Row(
            children: <Widget>[
              Text(
                'Music: ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _height*0.03,
                ),
              ),
              CustomToggleSwitch(
                activeText: "On",
                inactiveText: "Off",
                inactiveColor: Colors.red[300],
                activeTextColor: Colors.white,
                inactiveTextColor: Colors.white,
                activeColor: Colors.green[300],
                value: status,
                onChanged: (value) {
                  print(_player.state);
                  print("VALUE : $value");
                  setState(() {
                    status = value;
                    if (status == true){
                      play();
                    } else {
                      _player.stop();
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ima() {
    if (documents.documents[currentIndex].data['image'] == null) {
      return Container();
    } else {
      return Container(
        child: GestureDetector(
          onTap: () {
            setState(() async{
              if (documents.documents[currentIndex].data['video'] != null){
                pauseTimer = true;
                video = true;
                _player.pause();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Youtube(
                      link: documents.documents[currentIndex].data['video'].toString(),
                    ),
                  ),
                );
                pauseTimer = false;
                video = false;
                _player.resume();
                startTimer();
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('No video available !', textAlign: TextAlign.center,),),);
              }
            });
          },
          child: Image.network(
            documents.documents[currentIndex].data['image'],
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }

  ques() {
    if (documents.documents[currentIndex].data['question'] == null) {
      return Container();
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  documents.documents[currentIndex].data['question'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.black,
                      height: 1,
                      fontSize: _height*0.04,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  bool ans;
  dialog() {
    if (ans == true) {
      return AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: true,
        dialogType: DialogType.SUCCES,
        title: 'CORRECT ANSWER',
        desc: 'SCORE:  $totalScore / $outOf',
        btnOkOnPress: () {
          setState(() {
            if(currentIndex == (totalQuestions - 1)){
              pauseTimer = true;
              end = DateTime.now();
              time = end.difference(start).inSeconds;
              connectivity();
            } else {
              currentIndex++;
              re();
              cancelTimer = true;
              if(documents.documents[currentIndex].data['video'] != null){
                checkVideo();
              } else {
                setState(() {
                  pauseTimer = true;
                  video = true;
                  Timer(Duration(seconds: 1), (){
                    setState(() {
                      pauseTimer = false;
                      video = false;
                      startTimer();
                    });
                  });
                });
              }
            }
          });
        },
        btnOkText: 'NEXT QUESTION',
        btnOkIcon: Icons.check_circle,
      )..show();
    } else if (ans == false) {
      return AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: 'WRONG ANSWER',
          desc: 'SCORE:  $totalScore / $outOf',
          btnOkOnPress: () {
            setState(() {
              if(currentIndex == (totalQuestions - 1)){
                pauseTimer = true;
                end = DateTime.now();
                time = end.difference(start).inSeconds;
                connectivity();
//                uploadRank();
//                timer = 10;
//                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Result(name: widget.userName)), (route) => false);
              } else {
                currentIndex++;
                re();
                cancelTimer = true;
                if(documents.documents[currentIndex].data['video'] != null){
                  checkVideo();
                } else {
                  setState(() {
                    pauseTimer = true;
                    video = true;
                    Timer(Duration(seconds: 1), (){
                      setState(() {
                        pauseTimer = false;
                        video = false;
                        startTimer();
                      });
                    });
                  });
                }
              }
            });
          },
          btnOkText: 'NEXT QUESTION',
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
        ..show();
    } else {
      return AwesomeDialog(
        context: context,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          dialogType: DialogType.WARNING,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'OOPPS',
          desc:
          'TIME OUT',
          btnOkText: 'NEXT QUESTION',
          btnOkOnPress: () {
            setState(() {
              if(currentIndex == (totalQuestions - 1)){
                pauseTimer = true;
                end = DateTime.now();
                time = end.difference(start).inSeconds;
                connectivity();
              } else {
                currentIndex++;
                re();
                cancelTimer = true;
                if(documents.documents[currentIndex].data['video'] != null){
                  checkVideo();
                } else {
                  setState(() {
                    pauseTimer = true;
                    video = true;
                    Timer(Duration(seconds: 1), (){
                      setState(() {
                        pauseTimer = false;
                        video = false;
                        startTimer();
                      });
                    });
                  });
                }
              }
            });
          })
        ..show();
    }
  }

  checkAnswer(dynamic userPicked) {
    pauseTimer = true;
    outOf += documents.documents[currentIndex].data['score'];
    if ((userPicked == documents.documents[currentIndex].data['correct_answer']) || (userPicked.toString() == documents.documents[currentIndex].data['correct_answer'].toString())) {
      totalScore += documents.documents[currentIndex].data['score'];
      ans = true;
      return dialog();
    } else {
      ans = false;
      return dialog();
    }
  }

  trueFalse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonTheme(
          minWidth: _width*0.45,
          height: _height*0.075,
          child: RaisedButton(
            padding: EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.green.shade600,
            splashColor: Colors.blueGrey,
            highlightColor: Colors.greenAccent,
            elevation: 5.0,
            onPressed: () {
              setState(() {
                checkAnswer(true);
              });
            },
            child: Text(
              'True',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: _height*0.045,
              ),
            ),
          ),
        ),
        ButtonTheme(
          minWidth: _width*0.45,
          height: _height*0.075,
          child: RaisedButton(
            padding: EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.red.shade500,
            splashColor: Colors.blueGrey,
            highlightColor: Colors.redAccent,
            elevation: 5.0,
            onPressed: () {
              setState(() {
                checkAnswer(false);
              });
            },
            child: Text(
              'False',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: _height*0.045,
              ),
            ),
          ),
        ),
      ],
    );
  }

  mcq() {
    if (documents.documents[currentIndex].data['options'] != null) {
      return Container(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(10.0),
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 2,
          children: List.generate(documents.documents[currentIndex].data['options'].length, (index){
            return Container(
              height: MediaQuery.of(context).size.height*0.075,
              width: MediaQuery.of(context).size.width*0.425,
              child: McqOptions(
                documents.documents[currentIndex].data['options'],
                index,
                Key('$index'),
                onChoice: (choice){
                  checkAnswer(choice);
                },
              ),
            );
          }),
        ),
      );
    } else {
      return Container();
    }
  }

  dynamic rearrange;
  rear() {
    if (documents.documents[currentIndex].data['options'] == null) {
      return Container();
    } else {
      setState(() {
        rearrange = documents.documents[currentIndex].data['options'];
      });
      return Container(
        child: Center(
          child: ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: List.generate(
              rearrange.length,
              (index) {
                return ListViewCard(
                  rearrange,
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

  longPoll(){
    return Container(
      child: ListView(
        children: List.generate(documents.documents[currentIndex].data['options'].length, (index) {
          return GestureDetector(
            onTap: (){
              updateLongPoll((index++).toString());
              setState(() {
                re();
                cancelTimer = true;
                if(currentIndex == (totalQuestions - 1)){
                  pauseTimer = true;
                  end = DateTime.now();
                  time = end.difference(start).inSeconds;
                  connectivity();
                } else {
                  currentIndex++;
                  if(documents.documents[currentIndex].data['video'] != null){
                    checkVideo();
                  }
                  re();
                  cancelTimer = true;
                }
              });
            },
            child: Card(
              child: Center(
                child: Text(documents.documents[currentIndex].data['options'][index]),
              ),
            ),
          );
        }),
      ),
    );
  }

  delay() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        pollIndex++;
        re();
        cancelTimer = true;
        usersWhoVoted = {};
        if(currentIndex == (totalQuestions - 1)){
          pauseTimer = true;
          end = DateTime.now();
          time = end.difference(start).inSeconds;
          connectivity();
        } else {
          currentIndex++;
          if(documents.documents[currentIndex].data['video'] != null){
            checkVideo();
          }
          re();
          cancelTimer = true;
        }
      });
    });
  }

  Map usersWhoVoted = {};
  String creator = "yuvraj";
  int pollIndex;
  poll() {
    setState(() {
      pauseTimer = true;
      option_1 = polls.documents[pollIndex].data['option_1'];
      option_2 = polls.documents[pollIndex].data['option_2'];
      option_3 = polls.documents[pollIndex].data['option_3'];
      option_4 = polls.documents[pollIndex].data['option_4'];
    });
    if (documents.documents[currentIndex].data['options'] == null) {
      return Container();
    } else {
      return Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Polls(
            outlineColor: Colors.transparent,
            pollStyle: TextStyle(fontSize: MediaQuery.of(context).size.height*0.030),
            leadingPollStyle: TextStyle(fontSize: MediaQuery.of(context).size.height*0.035),
            children: [
              Polls.options(
                  title: documents.documents[currentIndex].data['options'][0].toString(),
                  value: option_1.toDouble()),
              Polls.options(
                  title: documents.documents[currentIndex].data['options'][1].toString(),
                  value: option_2.toDouble()),
              Polls.options(
                  title: documents.documents[currentIndex].data['options'][2].toString(),
                  value: option_3.toDouble()),
              Polls.options(
                  title: documents.documents[currentIndex].data['options'][3].toString(),
                  value: option_4.toDouble()),
            ],
            question: Text(
              'options',
              style: TextStyle(color: Colors.transparent),
            ),
            currentUser: widget.emailId,
            creatorID: this.creator,
            voteData: usersWhoVoted,
            userChoice: usersWhoVoted[widget.emailId],
            onVoteBackgroundColor: Colors.blue,
            leadingBackgroundColor: Colors.blue,
            backgroundColor: Colors.red,
            onVote: (choice) {
              print(choice);
              setState(() {
                this.usersWhoVoted[widget.emailId] = choice;
                print(usersWhoVoted);
//            delay();
              });
              if (choice == 1) {
                setState(() {
                  updatePoll('1');
                  delay();
                });
              } else if (choice == 2) {
                setState(() {
                  updatePoll('2');
                  delay();
                });
              } else if (choice == 3) {
                setState(() {
                  updatePoll('3');
                  delay();
                });
              } else if (choice == 4) {
                setState(() {
                  updatePoll('4');
                  delay();
                });
              } else {}
            },
          ),
        ),
      );
    }
  }

  opt() {
    if (documents.documents[currentIndex].data['question_type'] == "True/False") {
      return Expanded(
        flex: 1,
        child: Center(
          child: trueFalse(),
        ),
      );
    } else if (documents.documents[currentIndex].data['question_type'] == "MCQ") {
      return Expanded(
        flex: 1,
        child: Center(
          child: mcq(),
        ),
      );
    } else if (documents.documents[currentIndex].data['question_type'] == "Re-arrange") {
      return Expanded(
        flex: 1,
        child: Center(
          child: rear(),
        ),
      );
    } else if (documents.documents[currentIndex].data['question_type'] == "Poll") {
      return Expanded(
        flex: 1,
        child: Center(
          child: Container(
            alignment: Alignment.centerRight,
            child: poll(),
          ),
        ),
      );
    } else if (documents.documents[currentIndex].data['question_type'] == "LongPoll"){
      return Expanded(
        flex: 1,
        child: Center(
          child: longPoll(),
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Center(
          child: Container(),
        ),
      );
    }
  }

  checkVideo(){
    setState(() {
      pauseTimer = true;
      return AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          dialogType: DialogType.WARNING,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'VIDEO',
          desc:
          'WATCH THIS VIDEO BEFORE ANSWERING THE FOLLOWING QUESTIONS',
          btnOkText: 'WATCH VIDEO',
          btnOkOnPress: () {
            setState(() async {
              pauseTimer = true;
              video = true;
              _player.pause();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Youtube(
                    link: documents.documents[currentIndex].data['video'].toString(),
                  ),
                ),
              );
              pauseTimer = false;
              video = false;
              _player.resume();
              startTimer();
              cancelTimer = true;
            });
          })
        ..show();
    });
  }

  submit() {
    if (documents.documents[currentIndex].data['options'] == "Re-arrange") {
      return ButtonTheme(
        minWidth: _width*0.23,
        height: _height*0.025,
        child: RaisedButton(
          padding: EdgeInsets.all(_height*0.01),
          color: Colors.grey.shade800,
          splashColor: Colors.blueGrey,
          highlightColor: Colors.grey.shade600,
          elevation: 10.0,
          onPressed: () {
            setState(() {
              checkAnswer(rearrange);
            });
          },
          child: Text(
            'Submit',
            style: TextStyle(
                color: Colors.white,
                fontSize: _height*0.03,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  skip(){
    return ButtonTheme(
      minWidth: _width*0.23,
      height: _height*0.025,
      child: RaisedButton(
        padding: EdgeInsets.all(_height*0.01),
        color: Colors.grey.shade800,
        splashColor: Colors.blueGrey,
        highlightColor: Colors.grey.shade600,
        elevation: 10.0,
        onPressed: () {
          setState(() {
            pauseTimer = true;
            outOf += documents.documents[currentIndex].data['score'];
            if(currentIndex == (totalQuestions - 1)){
              pauseTimer = true;
              end = DateTime.now();
              time = end.difference(start).inSeconds;
              connectivity();
            } else {
              currentIndex++;
//              pauseTimer = false;
              re();
              cancelTimer = true;
              if(documents.documents[currentIndex].data['video'] != null){
                checkVideo();
              } else {
                setState(() {
                  pauseTimer = true;
                  video = true;
                  Timer(Duration(seconds: 1), (){
                    setState(() {
                      pauseTimer = false;
                      video = false;
                      startTimer();
                    });
                  });
                });
              }
            }
          });
        },
        child: Text(
          'SKIP',
          style: TextStyle(
              color: Colors.white,
              fontSize: _height*0.03,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  sh() {
    if ((documents.documents[currentIndex].data['question_type'] == "Poll") || documents.documents[currentIndex].data['question_type'] == "LongPoll") {
      return Container();
    } else {
      return Container(
        child: SizedBox(
          height: _height*0.05,
          width: _height*0.05,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: _height*0.05,
                  width: _height*0.05,
                  child: CircularProgressIndicator(
                    value: timer.toDouble()*0.1,
                  ),
                ),
              ),
              Center(
                child: Text(
                  showTimer,
                  style: TextStyle(fontSize: _height*0.03, color: Colors.yellowAccent.shade700, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  sco() {
    return Center(
      child: Card(
        elevation: 15.0,
        child: Padding(
          padding: EdgeInsets.all(_height*0.015),
          child: Text(
            'Score: $totalScore',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height*0.03,
            ),
          ),
        ),
      ),
    );
  }

  double _width;
  double _height;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: (){
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.all(0.0),
              content: Text("Do you want to exit the app ?"),
              actions: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'No',
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Yes',
                      ),
                    ),
                  ],
                )
              ],
            ));
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Quiz"),
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blue, Colors.red]),),
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: _height*0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          musicToggle(),
                          sh(),
                          sco(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ima(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          ques(),
                          opt(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          submit(),
                          skip(),
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
          print(rearrange);
        }
        final String item = rearrange.removeAt(oldIndex);
        rearrange.insert(newIndex, item);
        print(rearrange);
      },
    );
  }

  uploadRank()async{
    final snapShot = await Firestore.instance.collection('Quizes').document(widget.documentId).collection('Rank').document(widget.emailId).get();
    if (snapShot.exists){
      Firestore.instance.collection('Quizes').document(widget.documentId).collection('Rank').document(widget.emailId).updateData({"user_name": widget.userName, "score": totalScore, "time": time});
    }
    else{
      Firestore.instance.collection('Quizes').document(widget.documentId)
          .collection('Rank')
          .document(widget.emailId)
          .setData({"user_name": widget.userName, "score": totalScore, "time": time});
    }
//    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Result(id: widget.emailId, name: widget.userName)), (route) => false);
  }

  connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      uploadRank();
      video = true;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Result(emailId: widget.emailId, name: widget.userName, documentId: widget.documentId,)), (route) => false);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      uploadRank();
      video = true;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Result(emailId: widget.emailId, name: widget.userName, documentId: widget.documentId,)), (route) => false);
    } else {
      return AwesomeDialog(
          context: context,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          dialogType: DialogType.WARNING,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'NO INTERNET CONNECTIVITY',
          desc:
          'CHECK INTERNET CONNECTIVITY AND TRY AGAIN',
          btnOkText: 'TRY AGAIN',
          btnOkOnPress: () {
            setState(() {
              connectivity();
            });
          })
        ..show();
    }
  }
}

