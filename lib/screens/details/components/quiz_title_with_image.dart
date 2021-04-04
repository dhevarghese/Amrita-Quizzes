import 'package:flutter/material.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';

import 'package:amrita_quizzes/constants/color_constants.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.quiz_info,
  }) : super(key: key);

  final Quiz_info quiz_info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            //"Aristocratic Hand Bag",
            quiz_info.title,
            //style: TextStyle(color: Colors.white),
              style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "\ ${quiz_info.marks} marks",
            style: TextStyle(color: Colors.white),
            //style: Theme.of(context)
                //.textTheme
                //.headline4
               // .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Duration\n"),
                    TextSpan(
                      text: quiz_info.duration,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: "${quiz_info.id}",
                  child: Image.asset(
                    quiz_info.image,
                    fit: BoxFit.fill,
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
