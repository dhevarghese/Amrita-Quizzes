import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/contactus/contactus_screen.dart';
import 'package:amrita_quizzes/screens/details/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailsScreen extends StatelessWidget {
  final Quiz quiz_info;
  final int mode;

  const DetailsScreen({Key key, this.mode, this.quiz_info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: Color(int.parse('0x'+quiz_info.color)),
      appBar: buildAppBar(context),
      body: Body(quizInfo: quiz_info, mode: mode),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(int.parse('0x'+quiz_info.color)),
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
            icon: Icon(Icons.call, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ContactUsScreen()),
              );
            }
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
