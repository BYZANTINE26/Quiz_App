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
  final int total;
  final String documentId;

  Polling(
      {@required this.emailId,
      @required this.userName,
      @required this.total,
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

  QuerySnapshot documents;
  void getDocuments()async{
    documents = await Firestore.instance.collection('Polls').document(widget.documentId).collection('Questions').getDocuments();
  }

  void play()async{
    _player = await _cache.loop('bgmusic.mp3');
  }

  @override
  void initState() {
    print('yuvraj');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Wakelock.enable();
//    pollingIndexes = widget.indexes;
    currentIndex = 0;
    pollIndex = 0;
    totalQuestions = widget.total;
    video = false;
    getDocuments();
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
    Future.delayed(Duration(seconds: 1), () => (currentIndex == 0 && documents.documents[0].data['video'] != null) ? checkVideo() : print('NO VIDEO'));
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
    await Firestore.instance.collection('Polls').document(widget.documentId)
        .collection("Polls")
        .document('poll_value_$currentIndex')
        .updateData({'option_$which': FieldValue.increment(1)});
  }

  void updateLongPoll(String which) async {
    await Firestore.instance.collection('Polls').document(widget.documentId)
        .collection("LongPolls")
        .document('poll_value_$currentIndex')
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
    if (documents.documents[currentIndex].data['image'] != 'Poll') {
      return Container();
    } else {
      return Container(
        child: GestureDetector(
          onTap: () {
            setState(() async {
              if (documents.documents[currentIndex].data['video'] != null) {
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
            documents.documents[currentIndex].data['image'],
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }

  ques() {
    if (documents.documents[currentIndex].data['question'] != null) {
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
//          connectivity();
//          uploadRank();
//          timer = 10;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Greetings(name: widget.userName)), (route) => false);
        } else {
          currentIndex++;
          checkVideo();
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
    if (documents.documents[currentIndex].data['options'] == null) {
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

  longPoll(){
    return Container(
      child: ListView(
        children: List.generate(documents.documents[currentIndex].data['options'].length, (index) {
          return GestureDetector(
            onTap: (){
              updateLongPoll((index++).toString());
              setState(() {
                if(currentIndex == (totalQuestions - 1)){
                  video = true;
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Greetings(name: widget.userName)), (route) => false);
                } else {
                  currentIndex++;
                  if(documents.documents[currentIndex].data['video'] != null){
                    checkVideo();
                  }
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


  opt() {
    if (documents.documents[currentIndex].data['question_type'] == "Poll") {
      return Expanded(
        flex: 1,
        child: Center(
          child: poll(),
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
                  link: documents.documents[currentIndex].data['video'].toString(),
                ),
              ),
            );
            video = false;
              _player.resume();
          });
        })
      ..show();
  }

  double _height;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return SafeArea(
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
