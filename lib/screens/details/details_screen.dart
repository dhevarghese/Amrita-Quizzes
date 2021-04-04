import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:amrita_quizzes/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Quiz_info quiz_info;

  const DetailsScreen({Key key, this.quiz_info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: quiz_info.color,
      appBar: buildAppBar(context),
      body: Body(quiz_info: quiz_info),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: quiz_info.color,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/heart.svg"),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
