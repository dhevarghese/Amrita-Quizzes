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
                    FormBuilderTextField(name: 'qName',
                        decoration: InputDecoration(
                          labelText: 'Quiz name',
                          hintText: 'ML Quiz',
                          //border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderTextField(name: 'qDesc',
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.',
                          //border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderTextField(name: 'qPass',
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderTextField(name: 'qMarks',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Marks',
                      ),
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderTextField(name: 'qCategory',
                      decoration: InputDecoration(
                        labelText: 'Category',
                      ),
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderSlider(name: 'numQ',
                      min: 0.0,
                      max: 10.0,
                      initialValue: 7.0,
                      divisions: 10,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.lightBlueAccent,
                      decoration: InputDecoration(
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
                        labelText: 'Start time',
                      ),
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderDateTimePicker(
                        name: 'qEndDate',
                        decoration: InputDecoration(
                          labelText: 'End time',
                        ),
                      validator: FormBuilderValidators.required(context),
                    ),
                    FormBuilderTextField(name: 'qDuration',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Duration',
                          hintText: 'In Minutes',
                        ),
                      validator: FormBuilderValidators.required(context),
                    ),
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
                      decoration: InputDecoration(labelText: 'Pick Color'),
                      validator: FormBuilderValidators.required(context),
                      valueTransformer: (value) {
                       return value.toString();
                      },
                    ),
                    SizedBox(height: 10,),
                    FormBuilderImagePicker(
                      name: 'qImage',
                      decoration: const InputDecoration(labelText: 'Image', border: InputBorder.none),
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
