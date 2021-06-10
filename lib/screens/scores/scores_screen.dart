import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/scores/components/body.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ScoresScreen extends StatefulWidget {
  final Quiz quiz_info;
  ScoresScreen({Key key, this.quiz_info}) : super(key: key);
  _ScoresScreenState createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return Scaffold(
        body: FutureBuilder<Map> (
            future: dbs.getQuizScores(widget.quiz_info),
            builder: (context, AsyncSnapshot<Map> userSnapshot) {
              if(!userSnapshot.hasData){
                return Center(
                    child: CircularProgressIndicator()
                );
              }
              else {
                Map data = userSnapshot.data;
                print(data);
                return Body(data);
              }
            }
        )
    );
  }
}