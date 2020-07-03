import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Rear extends StatefulWidget {
  @override
  _RearState createState() => _RearState();
}

class _RearState extends State<Rear> {

//  void initState(){
//    super.initState();
//    getOptions();
//  }

  dynamic options;
//  getOptions() {
//    Firestore.instance
//        .collection("quetions")
//        .document('rFZFFNX1S2BxPMuOI1vM')
//        .get()
//        .then((value) => setState((){options = value.data['questions'][1]['answers'];}));
//    print(options);
//  }

  getNext() {
    setState((){Firestore.instance
        .collection("quetions")
        .document('rFZFFNX1S2BxPMuOI1vM')
        .get()
        .then((value) => options = value.data['questions'][1]['answers']);});
    if (options == null) {
      return Container();
    } else {
      return Container(
        child: Center(
          child: ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: List.generate(
              options.length,
              (index) {
                return ListViewCard(
                  options,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: getNext(),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
          print(options);
        }
        final String item = options.removeAt(oldIndex);
        options.insert(newIndex, item);
        print(options);
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
