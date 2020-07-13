import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Yuvi extends StatefulWidget {
  @override
  _YuviState createState() => _YuviState();
}

class _YuviState extends State<Yuvi> {

  List<String> typeBank = [];
  String type;
  void getType() async {
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState(() {
        type = value.data['questions'][i]['question'].toString();
      }));
      print(type);
      typeBank.add(type);
      print(typeBank);
    }
  }

  List<String> questionBank = [];
  String question;
  void getQuestions() async {
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
  dynamic options;
  void getOptions() async {
    for (int i = 0; i < 3; i++) {
      await Firestore.instance
          .collection("quetions")
          .document('rFZFFNX1S2BxPMuOI1vM')
          .get()
          .then((value) => setState((){options = value.data['questions'][i]['answers'];}));
      print(options);
      optionsBank.add(options);
      print(optionsBank);
    }
  }

  @override
  void initState() {
    getType();
    getQuestions();
    getOptions();
    super.initState();
  }

  ques(){
    if (questionBank[0] == null) {
      return
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('yuv.yub[0]'),
    );
  }
}
