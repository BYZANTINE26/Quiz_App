import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoquiz/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shot extends StatefulWidget {
  @override
  _ShotState createState() => _ShotState();
}

class _ShotState extends State<Shot> {

  dynamic videoLink;
  dynamic imageLink;
  dynamic currentIndex = 0;
  dynamic question;
  dynamic questionType;
  dynamic answers;
  dynamic correctAnswer;
  dynamic userPicked;
  dynamic score;
  dynamic totalScore = 0;
//  void initState() {
//    super.initState();
//    yuviState.initState();
//    getScore();
//    getQuestion();
//    getQuestionType();
//    mcq();
//  }

  getVideo(){
    print(videoLink);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) =>
            setState((){videoLink = value.data['questions'][currentIndex]['video'];}));
    print(videoLink);
    if (videoLink == null) {
      return Container();
    } else {
      return Container();
    }
  }

  getImage() {
    print(imageLink);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) =>
            imageLink = value.data['questions'][currentIndex]['image']);
    print(imageLink);
    if (imageLink == null) {
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
                onTap: (){
                  setState(() {
                    getVideo();
                    if(videoLink == null) {
                      return null;
                    } else {}
                  });
                },
                  child: Image.network(imageLink),
              ),
            ),
          ),
        ),
      );
    }
  }

  getQuestion() {
    print(question);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) =>
            question = value.data['questions'][currentIndex]['question']);
    print(question);
    if (question == null) {
      return Row();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              question,
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

  getAnswers() {
    print(answers);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) =>
            answers = value.data['questions'][currentIndex]['answers']);
    print(answers);
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
                currentIndex += 1;
//                print(currentIndex);
                userPicked = true;
                checkAnswer();
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
                currentIndex += 1;
                userPicked = false;
                checkAnswer();
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
    if (answers == null) {
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
                      userPicked = answers[0].toString();
                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    answers[0].toString(),
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
                      userPicked = answers[1].toString();
                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    answers[1].toString(),
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
                      userPicked = answers[2].toString();
                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    answers[2].toString(),
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
                      userPicked = answers[3].toString();
                      checkAnswer();
//                checkAnswer(true);
//                                currentIndex += 1;
                    });
                  },
                  child: Text(
                    answers[3].toString(),
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
    if (answers == null) {
      return Container();
    } else {
      return Container(
        child: Center(
          child: ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: List.generate(
              answers.length,
                  (index) {
                return ListViewCard(
                  answers,
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

  getQuestionType() {
    print(questionType);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) => questionType =
            value.data['questions'][currentIndex]['question_type']);
    print(questionType);
    getAnswers();
    getCorrectAnswer();
    if (questionType == "True/False") {
      return Expanded(
        flex: 1,
        child: Center(
          child: trueFalse(),
        ),
      );
    } else if (questionType == "MCQ") {
      return Expanded(
        flex: 1,
        child: Center(
          child: mcq(),
        ),
      );
    } else if (questionType == "Re-arrange") {
      return Expanded(
        flex: 1,
        child: Center(
          child: rear(),
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(),
        );
    }
  }

  getCorrectAnswer() {
    print(correctAnswer);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) =>
            correctAnswer = value.data['questions'][currentIndex]['correct_answer'].toString());
    print(correctAnswer);
  }

  getScore() {
    print(score);
    Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then(
            (value) => score = value.data['questions'][currentIndex]['score']);
    print(score);
    if (score == null) {
      return Container();
    } else {
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
  }

  checkAnswer() {
    if (userPicked.toString() == correctAnswer.toString()) {
      totalScore += score;
    }
  }

  checkOrder(){
    if(answers[0].toString() == correctAnswer[0].toString()){
      totalScore += score;
    }
  }

  submit(){
    if (questionType == 'Re-arrange'){
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
              userPicked = answers;
              checkOrder();
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

  @override
  Widget build(BuildContext context) {
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
                  colors: [Colors.blue, Colors.red]
              )
          ),
          child: Center(
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getImage(),
                    getQuestion(),
                    getQuestionType(),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          submit(),
                          getScore(),
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
          print(answers);
        }
        final String item = answers.removeAt(oldIndex);
        answers.insert(newIndex, item);
        print(answers);
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
