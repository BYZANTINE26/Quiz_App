import 'package:flutter/material.dart';
import 'package:polls/polls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Polly extends StatefulWidget {
  @override
  _PollyState createState() => _PollyState();
}

class _PollyState extends State<Polly> {

  List<int> options = [2, 0, 1, 1];
//  void getPoll() async {
//    await Firestore.instance
//        .collection("quetions")
//        .document('rFZFFNX1S2BxPMuOI1vM')
//        .get()
//        .then((value) => setState(() {
//      pollValues = value.data['questions'][currentIndex]['image'];
//    }));
//    print(pollValues);
//  }

  String user = "";
  Map usersWhoVoted = {};
  String creator = "yuvraj";

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
              Polls.options(title: '1', value: options[0].toDouble()),
              Polls.options(title: '2', value: options[1].toDouble()),
              Polls.options(title: '3', value: options[2].toDouble()),
              Polls.options(title: '4', value: options[3].toDouble()),
            ],
            question: Text('options', style: TextStyle(color: Colors.transparent),),
            currentUser: this.user,
            creatorID: this.creator,
            voteData: usersWhoVoted,
            userChoice: usersWhoVoted[this.user],
            onVoteBackgroundColor: Colors.blue,
            leadingBackgroundColor: Colors.blue,
            backgroundColor: Colors.red,
            onVote: (choice) {
              print(choice);
              setState(() {
                this.usersWhoVoted[this.user] = choice;
                print(usersWhoVoted);
              });
              if (choice == 1) {
                setState(() {
                  options[0] += 1;
                });
              }
              if (choice == 2) {
                setState(() {
                  options[1] += 1;
                });
              }
              if (choice == 3) {
                setState(() {
                  options[2] += 1;
                });
              }
              if (choice == 4) {
                setState(() {
                  options[3] += 1;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
