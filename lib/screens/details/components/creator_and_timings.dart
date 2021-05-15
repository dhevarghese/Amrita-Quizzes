import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatorAndTimings extends StatelessWidget {
  const CreatorAndTimings({
    Key key,
    @required this.quizInfo,
  }) : super(key: key);

  final Quiz quizInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8,8,24,0),
      child: Row(
        children: <Widget>[
          /*
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Color"),
                Row(
                  children: <Widget>[
                    ColorDot(
                      color: Color(0xFF356C95),
                      isSelected: true,
                    ),
                    ColorDot(color: Color(0xFFF8C078)),
                    ColorDot(color: Color(0xFFA29B9B)),
                  ],
                ),
              ],
            ),
          ),
          */
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: kTextColor),
                children: [
                  TextSpan(text: "Creator\n"),
                  TextSpan(
                    text: quizInfo.creator,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: kTextColor),
                children: [
                  TextSpan(text: "Start Time\n"),
                  TextSpan(
                    text:  DateFormat('MM/dd kk:mm').format(quizInfo.startTime),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(text: "End Time\n"),
                  TextSpan(
                    text:  DateFormat('MM/dd kk:mm').format(quizInfo.endTime),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const ColorDot({
    Key key,
    this.color,
    // by default isSelected is false
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: kDefaultPaddin / 4,
        right: kDefaultPaddin / 2,
      ),
      padding: EdgeInsets.all(2.5),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
