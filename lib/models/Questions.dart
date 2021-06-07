import 'dart:collection';

import 'package:equatable/equatable.dart';

class Question extends Equatable{
  final int id, answer, mark;
  final String question;
  final List options;

  Question({this.id, this.question, this.answer, this.options, this.mark});

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'question':question,
        'answer': answer,
        'options':options,
        'mark':mark,
      };

  Question.fromJson(Map parsedJson) :
        options = parsedJson['options'] ?? '',
        question = parsedJson['question'] ?? '',
        answer = parsedJson['answer'],
        mark = parsedJson['mark'],
        id = parsedJson['id'];

  @override
  String toString(){
    return this.id.toString() +" "+ this.question +" "+ this.options.toString()+" "+ this.answer.toString()+ " "+ this.mark.toString();
  }

  @override
  List<Object> get props => [id, question, answer, options, mark];
}

const List sample_data = [
  {
    "id": 1,
    "question":
    "Flutter is an open-source UI software development kit created by ______",
    "options": ['Apple', 'Google', 'Facebook', 'Microsoft'],
    "answer_index": 1,
  },
  {
    "id": 2,
    "question": "When did google release Flutter?",
    "options": ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
    "answer_index": 2,
  },
  {
    "id": 3,
    "question": "_______ is the only team to ever score 100 points in the Premier League ",
    "options": ['Manchester City', 'Liverpool', 'Arsenal', 'Manchester United'],
    "answer_index": 0,
  },
  {
    "id": 4,
    "question": "Which company was the first ever to be valued higher than 2 trillion US Dollars?",
    "options": ['Microsoft', 'Apple', 'Amazon', 'Google', 'Facebook'],
    "answer_index": 1,
  },
];

List<Question> questionList = [];
LinkedHashMap answerIndexes = new LinkedHashMap<int, int>();
String quizDuration = "";
