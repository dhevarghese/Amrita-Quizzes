import 'dart:io';

import 'package:amrita_quizzes/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Quiz {

  final String title, description, password, creator, category, duration, color;
  final DateTime startTime, endTime;
  final int marks, id;
  final double numQuestions;
  final File image;
  List<Question> questions = [];

  Quiz({
    @required this.title,
    @required this.description,
    @required this.password,
    @required this.creator,
    @required this.category,
    @required this.startTime,
    @required this.endTime,
    @required this.duration,
    @required this.numQuestions,
    @required this.marks,
    @required this.id,
    @required this.image,
    @required this.color,
  });

  void addQuestions(Question question){
    questions.add(question);
  }

  Map<String, dynamic> getQuestionJson(int index){
    print(questions[index].toString());
    return questions[index].toJson();
  }

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'description': description,
        'password': password,
        'creator': creator,
        'category': category,
        'startTime': startTime,
        'endTime': endTime,
        'duration': duration,
        'numQuestions': numQuestions,
        'marks': marks,
        'id': id,
        'color': color,
      };

  @override
  String toString(){
    return this.title +" "+ this.description +" "+ this.password+" "+ this.creator+" "+this.category+" "+this.startTime.toString()+" "+this.endTime.toString()+" "+this.duration+" "+this.numQuestions.toString()+" "+this.marks.toString()+" "+this.id.toString()+" "+this.color + " " + this.questions.toString();
  }

}