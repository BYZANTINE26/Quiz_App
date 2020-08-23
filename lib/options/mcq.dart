import 'package:flutter/material.dart';

typedef void OptionCallBack(String choice);

class McqOptions extends StatefulWidget {
  final int index;
  final Key key;
  final List listItems;
  final OptionCallBack onChoice;

  McqOptions(this.listItems, this.index, this.key, {this.onChoice});

  @override
  _McqOptionsState createState() => _McqOptionsState();
}

class _McqOptionsState extends State<McqOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.425,
      height: MediaQuery.of(context).size.height*0.075,
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width*0.425,
        height: MediaQuery.of(context).size.height*0.075,
        child: RaisedButton(
          color: Colors.yellow.shade400,
          splashColor: Colors.blueGrey,
          highlightColor: Colors.yellowAccent,
          elevation: 5.0,
          onPressed: () {
            setState(() {
              widget.onChoice(widget.listItems[widget.index].toString());
            });
          },
          child: Text(
            widget.listItems[widget.index].toString(),
            style: TextStyle(
              color: Colors.black45,
              fontSize: MediaQuery.of(context).size.height*0.05,
            ),
          ),
        ),
      ),
    );
  }
}
