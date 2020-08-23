import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoquiz/polling.dart';
import 'package:demoquiz/quiz.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';


class HomePage extends StatefulWidget {
  final bool quiz;
  final String documentId;

  HomePage({@required this.quiz, @required this.documentId});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _name = TextEditingController();
  final _email = TextEditingController();
  bool _validate = false;
  bool _connectivity = false;

  Future check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState((){
        _connectivity = true;
//        print(_connectivity);
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState((){
        _connectivity = true;
//        print(_connectivity);
      });
    } else {
      setState((){
        _connectivity = false;
//        print(_connectivity);
      });
    }
  }

  int questions;
  void total() async {
    if(widget.quiz){
      await Firestore.instance.collection('Quizes').getDocuments().then((value) => questions = value.documents.length);
    } else {
      await Firestore.instance.collection('Polls').getDocuments().then((value) => questions = value.documents.length);
    }
  }

  double _height;
  double _width;
  @override
  void initState(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    total();
    check();
  }

  music(){
    return AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: context,
      animType: AnimType.LEFTSLIDE,
      headerAnimationLoop: true,
      dialogType: DialogType.INFO,
      title: 'MUSIC',
      desc: 'Will you like some background music ?',
      btnOkOnPress: () {
        setState(() {
          if (widget.quiz){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Quizing(emailId: _email.text, userName: _name.text, total: questions, music: true, documentId: widget.documentId,)),
                    (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Polling(emailId: _email.text, userName: _name.text, total: questions, music: true)),
                    (route) => false);
          }
        });
      },
      btnOkText: 'YES',
      btnOkIcon: Icons.check_circle,
      btnCancelColor: Colors.red,
      btnCancelIcon: Icons.cancel,
      btnCancelText: 'NO',
      btnCancelOnPress: (){
        setState(() {
          if (widget.quiz){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Quizing(emailId: _email.text, userName: _name.text, total: questions, music: false, documentId: widget.documentId,)),
                    (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Polling(emailId: _email.text, userName: _name.text, total: questions, music: false)),
                    (route) => false);
          }
        });
      },
    )..show();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('QUIZ'),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
//              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                    flex: 2,
                    child: Center(
                      child: FadeAnimatedTextKit(
                          onTap: () {},
                          onFinished: (){},
                          repeatForever: true,
                          displayFullTextOnTap: false,
                          stopPauseOnTap: false,
                          isRepeatingAnimation: true,
                          text: [
                            "Let's!",
                            "Let's Get!!",
                            "Let's Get Started!!!"
                          ],
                          textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: _height*0.05,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: _width*0.075),
                            child: TextField(
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: _height*0.025),
                              controller: _name,
                              onEditingComplete: (){
                                setState(() {
                                  check();
                                  (_name.text.isEmpty || !EmailValidator.validate(_email.text)) ? _validate = false : _validate = true;
                                });
                              },
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(fontSize: _height*0.025),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: _width*0.075),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: _height*0.025),
                              controller: _email,
                              onEditingComplete: (){
                                setState(() {
                                  check();
                                  (_name.text.isEmpty || !EmailValidator.validate(_email.text)) ? _validate = false : _validate = true;
                                });
                              },
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: 'Email id',
                                hintStyle: TextStyle(fontSize: _height*0.025),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height*0.07,
                        ),
                        Container(
                          child: ButtonTheme(
                            minWidth: _width*0.17,
                            height: _height*0.05,
                            child: RaisedButton(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.yellow.shade400,
                              splashColor: Colors.blueGrey,
                              highlightColor: Colors.yellowAccent,
                              elevation: 5.0,
                              onPressed: () {
                                check();
                                (_name.text.isEmpty || !EmailValidator.validate(_email.text)) ? _validate = false : _validate = true;
                                setState((){
//                          check();
//                          print(_validate);
//                          print(_connectivity);
                                  (_validate && _connectivity ) ? music() : _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(_connectivity ? 'INVALID USERNAME OR EMAIL !' : 'NO INTERNET CONNECTION !', textAlign: TextAlign.center,),),);
//                          SnackBar(content: Text('NO INTERNET CONNECTION !!', textAlign: TextAlign.center,),);
                                });
                              },
                               child: Shimmer.fromColors(
                                baseColor: Colors.blue,
                                highlightColor: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'START',
                                      style:  TextStyle(
                                          fontSize: _height*0.035,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey.shade200
                                      ),
                                    ),
                                    SizedBox(width: _width*0.01,),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: _height*0.035,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(_width*0.015),
                          child: Card(
                            elevation: 10.0,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Divider(
                                    color: Colors.redAccent,
                                    height: _height*0.0075,
                                    thickness: _height*0.0015,
                                    indent: _width*0.016,
                                    endIndent: _width*0.016,
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(_height*0.0075),
                                    title: Text('Instructions', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: _height*0.025, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: Colors.blueGrey, decorationThickness: 2),),
                                    subtitle: Text('\n\n1.  Keep a good internet connection .\n'
                                        '2.  Timer won\'t stop for you even in background .\n'
                                        '3.  Once moved on from any question you can\'t return back .', textAlign: TextAlign.start, style: TextStyle(color: Colors.black87, fontSize: _height*0.0175, fontWeight: FontWeight.w600),),
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
    );
  }
}
