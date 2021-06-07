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
    if(widget.mQuiz.questions.isEmpty){
      questionsFormField.add(_expand(curQuestion));
      questionsFormField.add(SizedBox(height: 20));
    }
    else{
      for(var q in widget.mQuiz.questions){
        print(q);
        questionsFormField.add(_expand(curQuestion, q));
        questionsFormField.add(SizedBox(height: 20));
        curQuestion+=1;
      }
    }
  }

  Widget _newQuestion(var qNum, [Question quest]){
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: QuestionForm(qNumber: qNum, maxScore: widget.mQuiz.marks, editQ: quest),
    );
  }

  Widget _expand(var curQ, [Question quest]){
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
            child: _newQuestion(curQ, quest),
          ),
        ),
      ],
    );
  }

  List<Widget> _getQuestions(){
    return questionsFormField;
  }

  Widget addIndicator(Database dbs, String uid, bool addMode, [List<Question> updatedQuestions]){
    return FutureBuilder<void>(
        future: addMode? dbs.addQuiz(widget.mQuiz, uid) : dbs.updateQuizQuestions(widget.mQuiz.id, updatedQuestions),
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
                  addMode? Icon(Icons.add_chart) : Icon(Icons.update_outlined),
                  SizedBox( width: 36,),
                  addMode? Text("Published") : Text("Updated"),
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


  showProgressDialog(BuildContext context, Database dbs, String uid, bool addMode, [List<Question> updatedQuestions]) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: addMode? Text("Uploading Quiz!") : Text("Updating Questions!"),
      content: addIndicator(dbs, uid, addMode, updatedQuestions),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context, String title, String content) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
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
        title: (widget.mQuiz.questions.isEmpty) ? Text("Questions!", style: TextStyle(
            color: Colors.white
        )) : Text("Edit Questions", style: TextStyle(
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
                          if(curQuestion<widget.mQuiz.numQuestions){
                            curQuestion+=1;
                            questionsFormField.add(_expand(curQuestion));
                            questionsFormField.add(SizedBox(height: 20));
                            setState(() {});
                          }
                          else{
                            final snackBar = SnackBar(
                              content: Text("Oops! That's the limit!"),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(width: 15,),
                      if(widget.mQuiz.questions.isEmpty)
                        SignInButton(
                          text: "Submit!",
                          onPressed: () {
                            final validationSuccess = _formKey.currentState.validate();
                            if(validationSuccess) {
                              _formKey.currentState.save();
                              final formData = _formKey.currentState.value;
                              //print(formData);
                              var totalMarks =0;
                              for (var k in formData.keys) {
                                if(k.contains("mark")){
                                  totalMarks += formData[k].toInt();
                                  //print("Key : $k, value : ${formData[k]}");
                                }
                              }
                              if(totalMarks != widget.mQuiz.marks){
                                showAlertDialog(context, "Does not quite hit the mark!", "The alloted marks do not correctly add up to the quiz marks specified, that is " + widget.mQuiz.marks.toString());
                                return;
                              }
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
                                final ques = Question(id: ct,question: formData['Question'+ct.toString()],answer: formData['Question'+ct.toString()+"_Correct_Choice"],options: options, mark: formData['mark'+ct.toString()].toInt());
                                widget.mQuiz.addQuestions(ques);
                              }
                              print(widget.mQuiz.toString());
                              showProgressDialog(context,dbs, user.uid, (widget.mQuiz.questions.isEmpty));
                            }
                            else{
                              showAlertDialog(context, "Stop right there!", "Please fill all the necessary details for each question.");
                            }
                          },
                          textColor: Colors.white,
                          color: Colors.lightBlueAccent,
                        ),
                      if(widget.mQuiz.questions.isNotEmpty)
                        SignInButton(
                          text: "Update!",
                          onPressed: () {
                            final validationSuccess = _formKey.currentState.validate();
                            if(validationSuccess) {
                              List<Question> updatedQuestions = [];
                              _formKey.currentState.save();
                              final formData = _formKey.currentState.value;
                              print(formData);
                              var totalMarks =0;
                              for (var k in formData.keys) {
                                if(k.contains("mark")){
                                  totalMarks += formData[k].toInt();
                                }
                              }
                              if(totalMarks != widget.mQuiz.marks){
                                showAlertDialog(context, "Does not quite hit the mark!", "The alloted marks do not correctly add up to the quiz marks specified, that is " + widget.mQuiz.marks.toString());
                                return;
                              }
                              for(int ct = 1; ct<curQuestion; ct++){
                                List<String> options = [];
                                for (var k in formData.keys) {
                                  if(k.contains("Question"+ct.toString()+"_Option")){
                                    options.add(formData[k]);
                                  }
                                }
                                //print(options);
                                final ques = Question(id: ct,question: formData['Question'+ct.toString()],answer: formData['Question'+ct.toString()+"_Correct_Choice"],options: options, mark: formData['mark'+ct.toString()].toInt());
                                //print(widget.mQuiz.questions[ct-1]==ques);
                                if(widget.mQuiz.questions[ct-1]!=ques){
                                  updatedQuestions.add(ques);
                                }
                                showProgressDialog(context,dbs, user.uid, (widget.mQuiz.questions.isEmpty), updatedQuestions);
                              }
                            }
                            else{
                              showAlertDialog(context, "Stop right there!", "Please fill all the necessary details for each question.");
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