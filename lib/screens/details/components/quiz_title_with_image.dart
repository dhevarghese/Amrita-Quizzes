import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:flutter/material.dart';

class QuizTitleWithImage extends StatelessWidget {
  const QuizTitleWithImage({
    Key key,
    @required this.quizInfo,
  }) : super(key: key);

  final Quiz quizInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            //"Aristocratic Hand Bag",
            quizInfo.title,
            //style: TextStyle(color: Colors.white),
              style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "\ ${quizInfo.marks} marks",
            style: TextStyle(color: Colors.white),
            //style: Theme.of(context)
                //.textTheme
                //.headline4
               // .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Duration\n"),
                    TextSpan(
                      text: quizInfo.duration,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: "${quizInfo.id}",
                  child: Image.network(
                    quizInfo.imageLink,
                    height: 230,
                    width: 250,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
