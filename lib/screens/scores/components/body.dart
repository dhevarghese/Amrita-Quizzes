
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final Map scoresData;
  Body(this.scoresData, {Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Report", style: TextStyle(
            color: Colors.white
        ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
                margin: EdgeInsets.fromLTRB(16.0,16,16,0),
                shadowColor: Colors.redAccent,
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.info,
                        color: Colors.redAccent
                    ),
                  ),
                  title: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("NA Students have not yet attempted the Quiz! ", style: TextStyle(color: Colors.redAccent),),
                  ),
                )
            ),
            Expanded(
              child: getScores(),
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget getScores(){
    return ListView.builder(
      itemCount: widget.scoresData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Card(
            color: (widget.scoresData.values.elementAt(index) == null ) ? Colors.redAccent : (widget.scoresData.values.elementAt(index)[0] /widget.scoresData.values.elementAt(index)[1] > 0.80) ? Colors.greenAccent : (widget.scoresData.values.elementAt(index)[0] /widget.scoresData.values.elementAt(index)[1] > 0.50) ? Colors.amber[400] : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text('${widget.scoresData.keys.elementAt(index)}' , style: TextStyle(color: Colors.white),),
              trailing: (widget.scoresData.values.elementAt(index) == null ) ? Text("NA", style: TextStyle(color: Colors.white),) : Text('${widget.scoresData.values.elementAt(index)[0]} / ${widget.scoresData.values.elementAt(index)[1]}', style: TextStyle(color: Colors.white),),
            ),
          ),
        );
      },
    );
  }


}