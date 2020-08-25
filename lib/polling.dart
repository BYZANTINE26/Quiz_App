import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:customtoggleswitch/customtoggleswitch.dart';
import 'package:demoquiz/pages/greetings.dart';
import 'package:demoquiz/pages/youtube.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:polls/polls.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';


class Polling extends StatefulWidget {
  final bool music;
  final String emailId;
  final String userName;
  final String documentId;

  Polling(
      {@required this.emailId,
      @required this.userName,
      @required this.music,
      @required this.documentId});
  @override
  _PollingState createState() => _PollingState();
}

class _PollingState extends State<Polling> with WidgetsBindingObserver{
  int totalQuestions;
  int currentIndex;
  int pollIndex;

  int option_1;
  int option_2;
  int option_3;
  int option_4;
  QuerySnapshot pol;
  void getPoll() async {
    pol = await Firestore.instance.collection('Polls').document(widget.documentId).collection('Polls').getDocuments();
  }

  QuerySnapshot questionDocuments;
  void getDocuments()async{
    await Firestore.instance.collection('Polls').document(widget.documentId).collection('Questions').getDocuments().then((value) {
      setState(() {
        questionDocuments = value;
        totalQuestions = questionDocuments.documents.length;
        Future.delayed(Duration(seconds: 1), () => (currentIndex == 0 && questionDocuments.documents[0].data['video'] != null) ? checkVideo() : print('NO VIDEO'));
      });
    });
  }

  void play()async{
    _player = await _cache.loop('bgmusic.mp3');
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Wakelock.enable();
//    pollingIndexes = widget.indexes;
    currentIndex = 0;
    pollIndex = 0;
    video = false;
//    getImage();
//    getVideo();
//    getType();
//    getQuestions();
//    getOptions();
    getPoll();
    widget.music ? play() : print('DON\'T PLAY') ;
//    print(_player.state);
    status = widget.music;
    super.initState();
    getDocuments();
    WidgetsBinding.instance.addObserver(this);
  }

  AudioCache _cache = AudioCache();
  AudioPlayer _player = AudioPlayer();

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
  void setState(fn) {
    if (mounted) {
      super.setState((fn));
    }
  }

  void updatePoll(String which) async {
    print(option_1);
    print(option_2);
    print(option_3);
    print(option_4);
    int count = currentIndex + 1;
    await Firestore.instance.collection('Polls').document(widget.documentId)
        .collection("Polls")
        .document('poll_value_$count')
        .updateData({'option_$which': FieldValue.increment(1)});
  }

  void updateLongPoll(String which) async {
    int count = currentIndex + 1;
    await Firestore.instance.collection('Polls').document(widget.documentId)
        .collection("LongPolls")
        .document('poll_value_$count')
        .updateData({'option_$which': FieldValue.increment(1)});
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
    if (questionDocuments.documents[currentIndex].data['image'] == null) {
      return Container();
    } else {
      return Container(
        child: GestureDetector(
          onTap: () {
            setState(() async {
              if (questionDocuments.documents[currentIndex].data['video'] != null) {
                video = true;
                _player.pause();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Youtube(
                      link: questionDocuments.documents[currentIndex].data['video'].toString(),
                    ),
                  ),
                );
                video = false;
                _player.resume();
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      'No video available !',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            });
          },
          child: Image.network(
            questionDocuments.documents[currentIndex].data['image'],
            fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              return Icon(Icons.error_outline, color: Colors.white,);
            },
          ),
        ),
      );
    }
  }

  ques() {
    if (questionDocuments.documents[currentIndex].data['question'] != null) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  questionDocuments.documents[currentIndex].data['question'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.black,
                      height: 1,
                      fontSize: _height * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  delay() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        pollIndex++;
        usersWhoVoted = {};
        if (currentIndex == (totalQuestions - 1)) {
          video = true;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Greetings(name: widget.userName)), (route) => false);
        } else {
          currentIndex++;
          if (questionDocuments.documents[currentIndex].data['video'] != null){
            checkVideo();
          }
        }
      });
    });
  }

  Map usersWhoVoted = {};
  String creator = "yuvraj";
  poll() {
    setState(() {
      option_1 = pol.documents[pollIndex].data['option_1'];
      option_2 = pol.documents[pollIndex].data['option_2'];
      option_3 = pol.documents[pollIndex].data['option_3'];
      option_4 = pol.documents[pollIndex].data['option_4'];
    });
    if (questionDocuments.documents[currentIndex].data['answers'] == null) {
      return Container();
    } else {
      return Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Polls(
            outlineColor: Colors.transparent,
            pollStyle:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.030),
            leadingPollStyle:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035),
            children: [
              Polls.options(
                  title: questionDocuments.documents[currentIndex].data['answers'][0].toString(),
                  value: option_1.toDouble()),
              Polls.options(
                  title: questionDocuments.documents[currentIndex].data['answers'][1].toString(),
                  value: option_2.toDouble()),
              Polls.options(
                  title: questionDocuments.documents[currentIndex].data['answers'][2].toString(),
                  value: option_3.toDouble()),
              Polls.options(
                  title: questionDocuments.documents[currentIndex].data['answers'][3].toString(),
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

  longPoll(){
    if (questionDocuments.documents[currentIndex].data['answers'] != null){
      return Container(
        child: ListView(
          children: List.generate(questionDocuments.documents[currentIndex].data['answers'].length, (index) {
            return GestureDetector(
              onTap: (){
                updateLongPoll((index++).toString());
                setState(() {
                  if(currentIndex == (totalQuestions - 1)){
                    video = true;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Greetings(name: widget.userName)), (route) => false);
                  } else {
                    currentIndex++;
                    if(questionDocuments.documents[currentIndex].data['video'] != null){
                      checkVideo();
                    }
                  }
                });
              },
              child: Card(
                color: Colors.yellow,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Text(
                        questionDocuments.documents[currentIndex].data['answers'][index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20
                        ),
                      ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else {
      return Container();
    }
  }


  opt() {
    if (questionDocuments.documents[currentIndex].data['question_type'] == "Poll") {
      return Expanded(
        flex: 1,
        child: Center(
          child: poll(),
        ),
      );
    } else if (questionDocuments.documents[currentIndex].data['question_type'] == "LongPoll"){
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
            video = true;
              _player.pause();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Youtube(
                  link: questionDocuments.documents[currentIndex].data['video'].toString(),
                ),
              ),
            );
            video = false;
              _player.resume();
          });
        })
      ..show();
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
            if(currentIndex == (totalQuestions - 1)){
              video = true;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Greetings(name: widget.userName)), (route) => false);
            } else {
              (questionDocuments.documents[currentIndex].data['question_type'] == 'Poll')?pollIndex++:null;
              currentIndex++;
              if(questionDocuments.documents[currentIndex].data['video'] != null){
                checkVideo();
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


  double _width;
  double _height;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quiz"),
        ),
        body: (questionDocuments != null)?Container(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        musicToggle(),
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
                    child: Container(
                      alignment: Alignment.center,
                      child: skip(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ):Container(
          child: LinearProgressIndicator(),
        ),
      ),
    );
  }
}
