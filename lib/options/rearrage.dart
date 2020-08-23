import 'package:flutter/material.dart';

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
        height: MediaQuery.of(context).size.height*0.045,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      '${widget.listItems[widget.index]}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height*0.035,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Icon(
                  Icons.reorder,
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.height*0.024,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}