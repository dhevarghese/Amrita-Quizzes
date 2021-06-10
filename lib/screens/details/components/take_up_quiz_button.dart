// import 'package:shop_app/screens/home/components/qr.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import'package:amrita_quizzes/screens/Quiz/quiz_main.dart';
import 'package:amrita_quizzes/screens/addquiz/add_questions_screen.dart';
import 'package:amrita_quizzes/screens/addquiz/add_quiz_screen.dart';
import 'package:amrita_quizzes/screens/details/components/qr_generator.dart';
import 'package:amrita_quizzes/screens/home/home_screen.dart';
import 'package:amrita_quizzes/screens/scores/scores_screen.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TakeUpQuiz extends StatelessWidget {
  const TakeUpQuiz({
    Key key,
    @required this.quizInfo,
    @required this.displayText,
    @required this.mode,
  }) : super(key: key);

  final Quiz quizInfo;
  final String displayText;
  final int mode;

  Widget deleteIndicator(Database dbs){
    return FutureBuilder<void>(
        future: dbs.deleteQuiz(quizInfo),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'There was an error :(',
              style: Theme.of(context).textTheme.headline5,
            );
          } else if (snapshot.hasData) {
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.redAccent,
              ),
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox( width: 36,),
                  Text("Deleted" , style: TextStyle(color: Colors.white),),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    )
                );
              },
            );
          } else {
            return Container(
              padding: new EdgeInsets.fromLTRB(100,0,100,0),
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  showAlertDialog(BuildContext context, String title, String content, [Database dbs]) {
    bool conf = title.contains("Confirmation");
    // Create button
    Widget noButton = TextButton(
      child: conf? Text("NO") : Text("OKAY"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = TextButton(
      child: Text("YES", style: TextStyle(color: Colors.redAccent),),
      onPressed: () {
        Navigator.of(context).pop();
        if(dbs != null){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Deleting Quiz!"),
                content: deleteIndicator(dbs),
              );
            },
          );
        }
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        noButton,
        if(conf)
          yesButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin/2),
      child: Row(
        children: <Widget>[
          if(mode==1)
            Container(
              margin: EdgeInsets.only(right: kDefaultPaddin),
              height: 50,
              width: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Color(int.parse('0x'+quizInfo.color)),
                ),
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/qr.svg",
                  color: Color(int.parse('0x'+quizInfo.color)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>GenerateScreen(quizinfo: quizInfo)),
                  );
                },
              ),
            ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Color(int.parse('0x'+quizInfo.color)),
                onPressed: () {
                  if(mode==1)
                    if(quizInfo.endTime.isBefore(DateTime.now())){
                      showAlertDialog(context, "Missed it!", "It's past the end time of the quiz. You can no longer take it up.");
                    }
                    else if(quizInfo.startTime.isAfter(DateTime.now())){
                      showAlertDialog(context, "Too early!", "The allotted start time for this quiz has not yet come. Please be patient.");
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => QuizMain(quizInfo: quizInfo,)),
                      );
                    }
                  if(mode==0 && displayText.contains("View Scores"))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScoresScreen(quiz_info: quizInfo,),
                        )
                    );
                  if(mode==0 && displayText.contains("Edit Quiz"))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuizScreen(quizInfo: quizInfo,),
                        )
                    );
                  if(mode==0 && displayText.contains("Edit Questions"))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuestions(quizInfo),
                        )
                    );
                  if(mode==0 && displayText.contains("Delete"))
                    showAlertDialog(context, "Confirmation!", "The Quiz and it's details will be removed from the database. Are you sure about this action?", dbs);
                },
                child: Text(
                  displayText.toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}