import 'dart:math';

import 'package:amrita_quizzes/app/sign_in/social_sign_in_button.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/addquiz/add_questions_screen.dart';
import 'package:amrita_quizzes/screens/addquiz/color_picker.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';

class AddQuizScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormBuilderState>();

  Widget _textField(BuildContext context, String id, String label, String hint, int mLines, bool obscure, TextInputType keyboardType, IconData fIcon){
    return FormBuilderTextField(name: id,
      keyboardType: keyboardType,
      obscureText: obscure,
      maxLines: mLines,
      decoration: InputDecoration(
        icon: Icon(fIcon, color: Colors.lightBlueAccent,),
        labelText: label,
        hintText: hint,
        //border: OutlineInputBorder(),
      ),
      validator: FormBuilderValidators.required(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    int numQuizzes = new Random().nextInt(1000000);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Add Quiz", style: TextStyle(
            color: Colors.white
        )),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
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
                    _textField(context, 'qName', 'Quiz name', 'ML Quiz', 1, false, TextInputType.text, Icons.auto_stories), //assistant_photo
                    _textField(context, 'qDesc', 'Description', 'This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.', 4, false, TextInputType.text, Icons.assignment),
                    _textField(context, 'qPass', 'Password', '', 1, true, TextInputType.text, Icons.shield),
                    _textField(context, 'qMarks', 'Marks', '20', 1, false, TextInputType.number, Icons.bar_chart),
                    _textField(context, 'qCategory', 'Category', 'CSE', 1, false, TextInputType.text, Icons.category),
                    FormBuilderSlider(name: 'numQ',
                      min: 0.0,
                      max: 10.0,
                      initialValue: 7.0,
                      divisions: 10,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.lightBlueAccent,
                      decoration: InputDecoration(
                        //icon: Icon(Icons.question_answer, color: Colors.lightBlueAccent,),
                        labelText: 'Number of Questions',
                        border: InputBorder.none,
                      ),
                    )
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
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderDateTimePicker(
                        name: 'qEndDate',
                        decoration: InputDecoration(
                          icon: Icon(Icons.date_range_sharp, color: Colors.lightBlueAccent,),
                          labelText: 'End time',
                        ),
                      validator: FormBuilderValidators.required(context),
                    ),
                    _textField(context, 'qDuration', 'Duration', 'In Minutes', 1, false, TextInputType.number, Icons.timelapse),
                  ],
                ),
              ),

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
                      final newQuiz = Quiz(title: formData['qName'], description: formData['qDesc'], password: formData['qPass'], creator: value, category: formData['qCategory'], startTime: formData['qStartDate'], endTime: formData['qEndDate'], duration: formData['qDuration'], numQuestions: formData['numQ'], marks: int.parse(formData['qMarks']), id: numQuizzes.toString(), color: hexString, image: formData['qImage'][0]);
                      print(newQuiz.toString());
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
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
