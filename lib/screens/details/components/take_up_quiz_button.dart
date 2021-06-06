
// import 'package:shop_app/screens/home/components/qr.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import'package:amrita_quizzes/screens/Quiz/quiz_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TakeUpQuiz extends StatelessWidget {
  const TakeUpQuiz({
    Key key,
    @required this.quizInfo,
  }) : super(key: key);

  final Quiz quizInfo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: kDefaultPaddin),
            height: 50,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Color(int.parse('0x'+quizInfo.color)),
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/qr.svg",
                color: Color(int.parse('0x'+quizInfo.color)),
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Color(int.parse('0x'+quizInfo.color)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => QuizMain(quizInfo: quizInfo,)),
                  );
                },
                child: Text(
                  "Take up quiz".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
