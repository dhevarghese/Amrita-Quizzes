import 'dart:math';

import 'package:amrita_quizzes/app/sign_in/social_sign_in_button.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/addquiz/add_questions_screen.dart';
import 'package:amrita_quizzes/screens/addquiz/color_picker.dart';
import 'package:amrita_quizzes/screens/home/home_screen.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';

class AddQuizScreen extends StatefulWidget{
  AddQuizScreen({Key key, this.quizInfo}) : super(key: key);
  final Quiz quizInfo;
  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  final FocusScopeNode _node = FocusScopeNode();
  Map<String, Widget> takersField = {};
  DateTime  start = new DateTime.now();
  int minutes = 10;

  Widget _textField(BuildContext context, String id, String label, String hint, int mLines, bool obscure, TextInputType keyboardType, IconData fIcon, bool valReq){
    return FormBuilderTextField(name: id,
      keyboardType: keyboardType,
      obscureText: obscure,
      maxLines: mLines,
      onChanged: (val){
        if(id == "qDuration"){
          minutes = int.tryParse(val) ?? 10;
        }
      },
      onSubmitted: (val){
        if(id == "qDuration"){
          minutes = int.parse(val);
        }
      },
      onEditingComplete: () => _node.nextFocus(),
      decoration: InputDecoration(
        icon: Icon(fIcon, color: Colors.lightBlueAccent,),
        labelText: label,
        hintText: hint,
        //border: OutlineInputBorder(),
      ),
      validator: valReq ? FormBuilderValidators.required(context) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    List users = [];
    int numQuizzes = new Random().nextInt(1000000);
    bool addMode = (widget.quizInfo ==null);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: addMode ? Text("Add Quiz", style: TextStyle(
            color: Colors.white
        )) : Text("Edit Quiz", style: TextStyle(
            color: Colors.white
        )),
      ),
      body: FocusScope(
        node: _node,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                if(!addMode)
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
                        child: Text("All fields need not be filled to update Quiz details! ", style: TextStyle(color: Colors.redAccent),),
                      ),
                    )
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Quiz details", textAlign: TextAlign.left ,style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Container(
                  /**decoration: BoxDecoration(
                    color: Colors.accents[10],
                    borderRadius:  BorderRadius.circular(16),
                  ),*/
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Column(
                    children: [
                      _textField(context, 'qName', 'Quiz name', 'ML Quiz', 1, false, TextInputType.text, Icons.auto_stories, addMode), //assistant_photo
                      _textField(context, 'qDesc', 'Description', 'This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.', 4, false, TextInputType.text, Icons.assignment, addMode),
                      _textField(context, 'qPass', 'Password', '', 1, true, TextInputType.text, Icons.shield, addMode),
                      _textField(context, 'qMarks', 'Marks', '20', 1, false, TextInputType.number, Icons.bar_chart, addMode),
                      _textField(context, 'qCategory', 'Category', 'CSE', 1, false, TextInputType.text, Icons.category, addMode),
                      if(addMode)
                        _textField(context, 'numQ', 'Number of Questions', '5', 1, false, TextInputType.number, Icons.question_answer, addMode),
                      FormBuilderSwitch(
                        name: 'qNav',
                        title: Text("Allow Navigation", style: TextStyle(fontSize: 15),),
                        initialValue: addMode ? false : widget.quizInfo.nav,
                        decoration: InputDecoration(
                          icon: Icon(Icons.assistant_navigation, color: Colors.lightBlueAccent,),
                          border: InputBorder.none,
                        ),
                      ),
                      Divider(),
                      FormBuilderSwitch(
                        name: 'qPubScore',
                        title: Text("Publish Scores", style: TextStyle(fontSize: 15),),
                        initialValue: addMode ? false : widget.quizInfo.pubScore,
                        decoration: InputDecoration(
                          icon: Icon(Icons.score, color: Colors.lightBlueAccent,),
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 15,),
                      DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItem: true,
                          showSearchBox: true,
                          onFind: (String filter) async {
                            if(users.isEmpty){
                              users = await dbs.getUsers();
                            }
                            List filterRes = users.where((user) {
                              return user.contains(filter);
                            }).toList(growable: false)
                              ..sort((a, b) => a
                                  .indexOf(filter)
                                  .compareTo(
                                  b.indexOf(filter)));
                            List<String> workaround = [];
                            for(var temp in filterRes){
                              workaround.add(temp);
                            }
                            return workaround;
                          },
                          label: "Takers",
                          hint: "Who all are invited to this quiz?",
                          onChanged: (taker){
                            _formKey.currentState.save();
                            takersField[taker] =
                              InputChip(
                                //labelPadding: EdgeInsets.all(2.0),
                                padding: EdgeInsets.all(8.0),
                                backgroundColor: Colors.lightBlueAccent,
                                deleteIconColor: Colors.white,
                                key: ObjectKey(taker),
                                label: Text(taker, style: TextStyle(color: Colors.white),),
                                onDeleted: () {
                                  takersField.remove(taker);
                                  setState(() {});
                                }
                              );
                            setState(() {});
                          },
                      ),
                      if(takersField.isNotEmpty)
                        SizedBox(height: 10,),
                      Wrap(
                        children: [
                          ...takersField.values,
                        ],
                      ),
                      /*FormBuilderSearchableDropdown(
                        //isFilteredOnline: true,
                        onChanged: (val) => print(val),
                        name: 'searchable_dropdown',
                        onFind: (String filter) => dbs.getUsers(),
                      ),*/
                    ],
                  ),

                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Duration", textAlign: TextAlign.left ,style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                    ),
                  ),
                ),

                Container(
                  /*decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius:  BorderRadius.circular(16),
                  ),*/
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 4.0),
                  child: Column(
                    children: [
                      FormBuilderDateTimePicker(
                        name: 'qStartDate',
                        decoration: InputDecoration(
                          icon: Icon(Icons.date_range_outlined, color: Colors.lightBlueAccent,),
                          labelText: 'Start time',
                        ),
                        validator: addMode? (value){
                          if(value==null){
                            return "This field cannot be empty.";
                          }
                          else if(value.isBefore(DateTime.now())){
                            return "Start time cannot be in the past.";
                          }
                          start = value;
                          return null;
                        } : null,
                      ),
                      FormBuilderDateTimePicker(
                          name: 'qEndDate',
                          decoration: InputDecoration(
                            icon: Icon(Icons.date_range_sharp, color: Colors.lightBlueAccent,),
                            labelText: 'End time',
                          ),
                        validator: addMode? (value){
                          DateTime temp = start;
                          if(value==null){
                            return "This field cannot be empty.";
                          }
                          else if(value.isBefore(start)){
                            return "End time cannot be before start.";
                          }
                          else if(value.isBefore(temp.add(Duration(minutes: minutes)))){
                            return "Please give sufficient time to take up the quiz";
                          }
                          start = value;
                          return null;
                        } : null,
                      ),
                      _textField(context, 'qDuration', 'Duration', 'In Minutes', 1, false, TextInputType.number, Icons.timelapse, addMode),
                    ],
                  ),
                ),
                if(widget.quizInfo == null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Design", textAlign: TextAlign.left ,style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                      ),
                    ),
                  ),
                if(addMode)
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 4.0),
                    child: Column(
                      children: [
                        FormBuilderColorPickerField(  name: 'qColor',
                          colorPickerType: ColorPickerType.MaterialPicker,
                          decoration: InputDecoration(
                              icon: Icon(Icons.color_lens, color: Colors.lightBlueAccent,),
                              labelText: 'Pick Color'),
                          validator: FormBuilderValidators.required(context),
                          valueTransformer: (value) {
                            return value.toString();
                          },
                        ),
                        SizedBox(height: 10,),
                        FormBuilderImagePicker(
                          name: 'qImage',
                          decoration: const InputDecoration(labelText: 'Image', border: InputBorder.none, icon: Icon(Icons.image, color: Colors.lightBlueAccent,),),
                          maxImages: 1,
                          validator: FormBuilderValidators.required(context),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 18),
                if(addMode)
                  SignInButton(
                    text: "Add Questions!",
                    onPressed: () {
                      final validationSuccess = _formKey.currentState.validate();
                      if(validationSuccess){
                        _formKey.currentState.save();
                        final formData = _formKey.currentState.value;
                        print(formData);
                        dbs.getUserName().then((value){
                          String hexString = formData['qColor'].substring(formData['qColor'].indexOf('x')+1,formData['qColor'].length-1);
                          final newQuiz = Quiz(title: formData['qName'], description: formData['qDesc'], password: formData['qPass'], creator: value, category: formData['qCategory'], startTime: formData['qStartDate'], endTime: formData['qEndDate'], duration: formData['qDuration'], numQuestions: double.parse(formData['numQ']), marks: int.parse(formData['qMarks']), id: numQuizzes.toString(), color: hexString, image: formData['qImage'][0], takers: takersField.keys.toList(), nav: formData['qNav'], pubScore: formData['qPubScore']);
                          print(newQuiz.toString());
                          //_node.dispose();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddQuestions(newQuiz),
                              )
                          );
                        });
                      }
                    },
                    textColor: Colors.white,
                    color: Colors.lightBlueAccent,
                  ),
                if(!addMode)
                  SignInButton(
                    text: "Update details!",
                    onPressed: () {
                      final validationSuccess = _formKey.currentState.validate();
                      if(validationSuccess){
                        _formKey.currentState.save();
                        final formData = _formKey.currentState.value;
                        print(formData);
                        print(widget.quizInfo.id);
                        print(takersField.keys.toList());
                        showProgressDialog(context, dbs, formData, takersField.keys.toList());
                      }
                    },
                    textColor: Colors.white,
                    color: Colors.lightBlueAccent,
                  ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addIndicator(Database dbs, Map updateData, List updateTakers){
    return FutureBuilder<void>(
        future: dbs.updateQuiz(widget.quizInfo.id, updateData, updateTakers),
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
                  Icon(Icons.update),
                  SizedBox( width: 36,),
                  Text("Updated"),
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


  showProgressDialog(BuildContext context, Database dbs, Map updateData, List updateTakers) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Updating Quiz!"),
      content: addIndicator(dbs, updateData, updateTakers),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
