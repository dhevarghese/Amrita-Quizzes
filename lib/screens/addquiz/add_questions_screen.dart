import 'package:amrita_quizzes/app/sign_in/social_sign_in_button.dart';
import 'package:amrita_quizzes/models/Questions.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/addquiz/question_form.dart';
import 'package:amrita_quizzes/screens/home/home_screen.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AddQuestions extends StatefulWidget{
  final Quiz mQuiz;
  AddQuestions(this.mQuiz, {Key key}) : super(key: key);

  @override
  _QuestionsState createState() => _QuestionsState();

}

class _QuestionsState extends State<AddQuestions>{

  List<Question> questions = [];
  List<Widget> questionsFormField = [];
  var curQuestion = 1;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState(){
    super.initState();
    questionsFormField.add(_expand(curQuestion));
    questionsFormField.add(SizedBox(height: 20));
  }

  Widget _newQuestion(var qNum){
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: QuestionForm(qNumber: qNum),
    );
  }

  Widget _expand(var curQ){
    return ExpansionTile(
      collapsedBackgroundColor: Colors.lightBlue[50],
      backgroundColor: Colors.white60,
      maintainState: true,
      onExpansionChanged: (exp) {
        if(!exp){
          _formKey.currentState.save();
          final formData = _formKey.currentState.value;
          print(formData);
        }
      },
      leading: CircleAvatar(
          child: Text("Q"+curQ.toString())),
      title: Text("Question "+curQ.toString()),
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: _newQuestion(curQ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getQuestions(){
    return questionsFormField;
  }

  Widget addIndicator(Database dbs, String uid){
    return FutureBuilder<void>(
        future: dbs.addQuiz(widget.mQuiz, uid),
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
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: Row(
                children: [
                  Icon(Icons.add_chart),
                  SizedBox( width: 36,),
                  Text("Published"),
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
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }


  showProgressDialog(BuildContext context, Database dbs, String uid) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uploading Quiz!"),
      content: addIndicator(dbs, uid),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Stop right there!"),
      content: Text("Please fill all the necessary details for each question."),
      actions: [
        okButton,
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
    final user = Provider.of<MyAppUser>(context);
    return Scaffold(
      //backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Questions!", style: TextStyle(
            color: Colors.white
        )),
      ),
      //Padding(padding: const EdgeInsets.fromLTRB(10,10,10,0), child: ,),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(padding: const EdgeInsets.fromLTRB(10,10,10,0),
              child: Column(
                children: [
                  ..._getQuestions(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        text: "Next Question",
                        onPressed: () {
                          //questionsFormField.add(_question());
                          curQuestion+=1;
                          questionsFormField.add(_expand(curQuestion));
                          questionsFormField.add(SizedBox(height: 20));
                          setState(() {});
                        },
                        textColor: Colors.white,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(width: 15,),
                      SignInButton(
                        text: "Submit!",
                        onPressed: () {
                          final validationSuccess = _formKey.currentState.validate();
                          if(validationSuccess) {
                            _formKey.currentState.save();
                            final formData = _formKey.currentState.value;
                            //print(formData);
                            for(int ct = 1; ct<=curQuestion; ct++){
                              //Question1: gh, Question1_Correct_Choice: 0, Question1_Option0: ds
                              List<String> options = [];
                              for (var k in formData.keys) {
                                if(k.contains("Question"+ct.toString()+"_Option")){
                                  options.add(formData[k]);
                                  //print("Key : $k, value : ${formData[k]}");
                                }
                              }
                              //print(options);
                              final ques = Question(id: ct,question: formData['Question'+ct.toString()],answer: formData['Question'+ct.toString()+"_Correct_Choice"],options: options);
                              widget.mQuiz.addQuestions(ques);
                            }
                            print(widget.mQuiz.toString());
                            showProgressDialog(context,dbs, user.uid);
                          }
                          else{
                            showAlertDialog(context);
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.lightBlueAccent,
                      )
                    ],
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}