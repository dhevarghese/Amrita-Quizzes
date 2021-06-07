import 'dart:io';

import 'package:amrita_quizzes/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Quiz {

  final String title, description, password, creator, category, duration, color, id;
  final DateTime startTime, endTime;
  final int marks;
  final double numQuestions;
  File image;
  List<Question> questions = [];
  List takers;
  String imageLink = "";

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
    this.takers = const [],
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
        'takers':takers
      };

  Quiz.fromJson(Map parsedJson) :
    title = parsedJson['title'] ?? '',
    description = parsedJson['description'] ?? '',
    password = parsedJson['password'] ?? '',
    creator = parsedJson['creator'] ?? '',
    category = parsedJson['category'] ?? '',
    startTime = parsedJson['startTime'],
    endTime = parsedJson['endTime'],
    duration = parsedJson['duration'],
    numQuestions = parsedJson['numQuestions'],
    marks = parsedJson['marks'],
    id = parsedJson['id'] ?? '', // the doc ID, helpful to have
    takers = parsedJson['takers'] ?? [],
    imageLink = parsedJson['image'] ?? '',
    color = parsedJson['color'] ?? '';

  @override
  String toString(){
    return this.title +" "+ this.description +" "+ this.password+" "+ this.creator+" "+this.category+" "+this.startTime.toString()+" "+this.endTime.toString()+" "+this.duration+" "+this.numQuestions.toString()+" "+this.marks.toString()+" "+this.id.toString()+" "+this.color + " " + this.questions.toString();
  }

}