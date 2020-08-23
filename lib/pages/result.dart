import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoquiz/ongoing.dart';
import 'package:demoquiz/pages/home.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';


class Result extends StatefulWidget {
  final String emailId;
  final String name;
  final String documentId;
  Result({@required this.emailId, @required this.name, @required this.documentId});
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> with SingleTickerProviderStateMixin{
  int rank;
  int outOf;
  int score;
  void getRank() async {
    final QuerySnapshot result = await Firestore.instance.collection('Quizes').document(widget.documentId)
        .collection('Rank')
        .orderBy("score", descending: true)
        .orderBy("time")
        .getDocuments();
    result.documents.forEach((element) {print(element.data);});
    setState(() {
      rank = result.documents
          .indexWhere((element) => element.documentID == widget.emailId) +
          1;
      outOf = result.documents.length;
      score = result.documents[(rank-1)].data['score'];
      print(score);
      print(rank);
    });
  }

  @override
  void setState(fn){
    if (mounted){
      super.setState((fn));
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getRank();
    super.initState();
  }

  _renderContent(context) {
    return Card(
      elevation: 20.0,
      margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 100.0, bottom: 100.0),
      color: Color(0x00000000),
      child: FlipCard(
        direction: FlipDirection.VERTICAL,
        speed: 1000,
        onFlipDone: (status) {
          print(status);
          if (!status) {
            getRank();
          }
        },
        front: Container(
          decoration: BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('RESULTS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45)),
                Divider(
                  color: Colors.white,
                  height: 7.5,
                  thickness: 1.5,
                  indent: 120,
                  endIndent: 120,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('(Click here to reveal)', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  child: Text('Congratulations !!!\n' + widget.name, textAlign: TextAlign.center, style: TextStyle(height: 1.5, fontSize: 30, fontWeight: FontWeight.bold),),
                ),
                const Divider(
                  color: Colors.white,
                  height: 15.0,
                  thickness: 1.5,
                  indent: 30,
                  endIndent: 30,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('RANK: $rank', textAlign: TextAlign.center, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.yellow.shade900),),
                      Text('SCORE: $score', textAlign: TextAlign.center, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.yellow.shade900),)
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 10.0,
                  thickness: 1.5,
                  indent: 30,
                  endIndent: 30,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                            'You scored $score and secured $rank position \nout of $outOf players !!', overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: ButtonTheme(
                    minWidth: 170.0,
                    height: 50.0,
                    child: RaisedButton(
                      padding: EdgeInsets.all(8.0),
                      color: Color(0xFF006666),
                      splashColor: Colors.blueGrey,
                      highlightColor: Colors.yellowAccent,
                      elevation: 25.0,
                      onPressed: () {
                        setState(() {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnGoing()));
//                            Navigator.pushAndRemoveUntil(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => HomePage()),
//                                (route) => false);
                        });
                      },
                      child: Container(
                        width: 250.0,
                        height: 50.0,
                        child: Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.blueGrey,
                            highlightColor: Colors.white38,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.settings_backup_restore,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                Text(
                                  'PLAY AGAIN',
                                  style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey.shade200),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('RESULT'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/resultbg.jpg'), fit: BoxFit.fill),),
          child: _renderContent(context),
        ),
      ),
    );
  }
}
