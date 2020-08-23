import 'package:demoquiz/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnGoing extends StatefulWidget {
  @override
  _OnGoingState createState() => _OnGoingState();
}

class _OnGoingState extends State<OnGoing> {
  QuerySnapshot quizstream;
  QuerySnapshot pollstream;
  getStream()async{
    int now = DateTime.now().millisecondsSinceEpoch;
    setState(() async{
      quizstream = await Firestore.instance.collection('Quizes').where("start_time", isLessThan: now).where("end_time", isGreaterThan: now).getDocuments();
      print('not waiting');
      print(quizstream);
      pollstream = await Firestore.instance.collection('Polls').where("start_time", isLessThan: now).where("end_time", isGreaterThan: now).getDocuments();
    });
  }

  @override
  void initState() {
    getStream();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Currently available'),
        ),
        body: Container(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
            child: (quizstream!=null)?((_selectedIndex==0)?_quizTable():_pollTable()):Container(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text('Quiz'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.poll),
              title: Text('Poll'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _quizTable(){
    return DataTable(
      columnSpacing: 0.0,
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Start Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'End Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: _buildQuizes(),
    );
  }

  List<DataRow> _buildQuizes(){
    List<DataRow> newList = List.generate(quizstream.documents.length, (index) {
      return new DataRow(
          onSelectChanged: (selected){
            if(selected){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(quiz: quiz, documentId: pollstream.documents[index].documentID,)));
            } else {
              print('not selected');
            }
          },
          cells: [
            DataCell(Text(quizstream.documents[index].documentID)),
            DataCell(Text(quizstream.documents[index].data['start_time'].toString())),
            DataCell(Text(quizstream.documents[index].data['end_time'].toString())),
          ]);
    });
    return newList;
  }

  Widget _pollTable(){
    return DataTable(
      columnSpacing: 0.0,
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Start Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'End Date',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: _buildPolls(),
    );
  }

  List<DataRow> _buildPolls(){
    List<DataRow> newList = List.generate(pollstream.documents.length, (index) {
      return new DataRow(
          onSelectChanged: (selected){
            if(selected){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(quiz: quiz, documentId: pollstream.documents[index].documentID,)));
            } else {
              print('not selected');
            }
          },
          cells: [
            DataCell(Text(pollstream.documents[index].documentID)),
            DataCell(Text(pollstream.documents[index].data['start_time'].toString())),
            DataCell(Text(pollstream.documents[index].data['end_time'].toString())),
          ]);
    });
    return newList;
  }

  int _selectedIndex = 0;
  bool quiz = true;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 0){
        quiz = true;
      } else {
        quiz = false;
      }
    });
  }

}
