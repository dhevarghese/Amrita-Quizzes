import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Questions.dart';
import 'package:amrita_quizzes/screens/Quiz/quiz_screens/score/score_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar

  AnimationController _animationController;
  Animation _animation;
  // so that we can access our animation outside
  Animation get animation => this._animation;

  PageController _pageController;
  PageController get pageController => this._pageController;
/*
  List<Question> _questions = sample_data
      .map(
        (question) => Question(
        id: question['id'],
        question: question['question'],
        options: question['options'],
        answer: question['answer_index']),
  )
      .toList();
  */
  List<Question> _questions = questionList;
  List<Question> get questions => this._questions;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  int _correctAns ;
  int get correctAns => this._correctAns;

  int _selectedAns;
  int get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  int _marksObtained = 0;
  int get marksObtained => this._marksObtained;

  int _totalMarks = 0;
  int get totalMarks => this._totalMarks;

  // called immediately after the widget is allocated memory
  @override
  void onInit() {

    //test start
    int i=0;
    List<int> questionID = [];
    List<int> answersInitial = [];
    while (i<questions.length) {
      questionID.add(questions[i].id);
      answersInitial.add(-1);
      i++;
    }
    Map<int, int> answerstemp = Map.fromIterables(questionID, answersInitial);
    answerIndexes = Map.from(answerstemp);
    print("answer hashmap!");
    print(answerIndexes);
    print("duration");
    print(quizDuration);

    //test end
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    //**** change duration to quiz duration
    _animationController =
        AnimationController(duration: Duration(minutes: int.parse(quizDuration)), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {

        if(_animation.value>0.5 && _animation.value<1) {
          kPrimaryGradient=LinearGradient(
            colors: [Color(0xFFE92E30), Color(0xFFC51162)],
            //colors: [Color(0x1B1429), Color(0x1B1429)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          );
        }
        else {
          kPrimaryGradient = LinearGradient(
            colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
            //colors: [Color(0x1B1429), Color(0x1B1429)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          );
        }
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn

    _animationController.forward().whenComplete(timerDone);
    //nextQuestion();

    _pageController = PageController();
    super.onInit();
    print("idk why im here");
    //Get.to(ScoreScreen());
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;
    // test start
    answerIndexes[question.id] = selectedIndex;
    print(answerIndexes);
    //test end
    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // It will stop the counter
    //_animationController.stop();
    //update();

    // Once user select an ans after 3s it will go to the next qn
    // Future.delayed(Duration(seconds: 3), () {
    //nextQuestion();
    //});
  }

  void nextQuestion() {
    if(_animation.value == 1) {
      Get.to(ScoreScreen());
    }

    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      //_animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(timerDone);
    } else {
      // Get package provide us simple way to naviigate another page
      //test start
      int j = 0;
      int correctAnsCount = 0;
      while (j<questions.length) {
        if(answerIndexes[questions[j].id] == questions[j].answer) {
          correctAnsCount++;
          _marksObtained += questions[j].mark;
        }
        _totalMarks += questions[j].mark;
        j++;
      }
      print("marks obtained ");
      print(marksObtained);
      _numOfCorrectAns = correctAnsCount;

      //test end
      Get.to(ScoreScreen());
    }
  }

  void prevQuestion() {
    if (_questionNumber.value > 0) {
      _isAnswered = false;
      _pageController.previousPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      //_animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(timerDone);
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }

  void timerDone() {
    int j = 0;
    while (j<questions.length) {
      if(answerIndexes[questions[j].id] == questions[j].answer) {
        _marksObtained += questions[j].mark;
      }
      _totalMarks += questions[j].mark;
      j++;
    }
    Get.to(ScoreScreen());
  }
}