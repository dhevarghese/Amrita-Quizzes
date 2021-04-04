import 'package:flutter/material.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';

import 'package:amrita_quizzes/constants/color_constants.dart';

class ItemCard extends StatelessWidget {
  final Quiz_info quiz_info;
  final Function press;
  const ItemCard({
    Key key,
    this.quiz_info,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: quiz_info.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${quiz_info.id}",
                child: Image.asset(quiz_info.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              quiz_info.title,
              //style: TextStyle(color: kTextLightColor),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            quiz_info.duration,
            //style: TextStyle(fontWeight: FontWeight.bold),
            style: TextStyle(color: kTextLightColor),
          )
        ],
      ),
    );
  }
}
