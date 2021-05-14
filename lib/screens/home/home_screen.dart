import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/home/components/body.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return FutureBuilder<List<Quiz>> (
        future: dbs.getQuizzes(),
        builder: (context, AsyncSnapshot<List<Quiz>> dashBoardsnapshot) {
          if(!dashBoardsnapshot.hasData){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else {
            List<Quiz> data = dashBoardsnapshot.data;
            return Body(data);
          }
        }
    );
    /*return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<List<Quiz>> (
        future: dbs.getQuizzes(),
        builder: (context, AsyncSnapshot<List<Quiz>> dashBoardsnapshot) {
          if(!dashBoardsnapshot.hasData){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else {
            List<Quiz> data = dashBoardsnapshot.data;
            return Body(data);
          }
        }
        ,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 4.0,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddQuizScreen(),
            )
        ),
      ),
    );*/
  }
}