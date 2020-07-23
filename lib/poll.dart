import 'package:flutter/material.dart';
import 'package:polls/polls.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class Poll extends StatefulWidget {
  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {

  double option1 = 2.0;
  double option2 = 0.0;
  double option3 = 2.0;
  double option4 = 3.0;

  String user = "king@mail.com";
  Map usersWhoVoted = {'sam@mail.com': 3, 'mike@mail.com' : 4, 'john@mail.com' : 1, 'kenny@mail.com' : 1};
  String creator = "eddy@mail.com";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('POLL'),
        ),
        body: Container(
          child: Polls(
            children: [
              Polls.options(title: '1', value: option1),
              Polls.options(title: '2', value: option2),
              Polls.options(title: '3', value: option3),
              Polls.options(title: '4', value: option4),
            ],
            question: Text('numbers'),
            userChoice: usersWhoVoted[this.user],
            onVoteBackgroundColor: Colors.blue,
            leadingBackgroundColor: Colors.blue,
            backgroundColor: Colors.red,
            onVote: (choice) {
              print(choice);
              setState(() {
                this.usersWhoVoted[this.user] = choice;
              });
              if (choice == 1) {
                setState(() {
                  option1 += 1.0;
                });
              }
              if (choice == 2) {
                setState(() {
                  option2 += 1.0;
                });
              }
              if (choice == 3) {
                setState(() {
                  option3 += 1.0;
                });
              }
              if (choice == 4) {
                setState(() {
                  option4 += 1.0;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class ScoreCard extends StatefulWidget {
  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          AnimatedButton(
            text: 'Error Dialog',
            color: Colors.red,
            pressEvent: () {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: false,
                  title: 'Error',
                  desc:
                  'Dialog description here..................................................',
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
                ..show();
            },
          ),
          SizedBox(
            height: 16,
          ),
          AnimatedButton(
            text: 'Succes Dialog',
            color: Colors.green,
            pressEvent: () {
              AwesomeDialog(
                  context: context,
                  animType: AnimType.LEFTSLIDE,
                  headerAnimationLoop: false,
                  dialogType: DialogType.SUCCES,
                  title: 'Succes',
                  desc:
                  'Dialog description here..................................................',
                  btnOkOnPress: () {
                    debugPrint('OnClcik');
                  },
                  btnOkIcon: Icons.check_circle,
                  onDissmissCallback: () {
                    debugPrint('Dialog Dissmiss from callback');
                  })
                ..show();
            },
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

