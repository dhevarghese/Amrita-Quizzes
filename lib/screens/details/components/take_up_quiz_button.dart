import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:amrita_quizzes/screens/home/components/qr.dart';
// import 'package:shop_app/screens/home/components/qr.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import'package:amrita_quizzes/screens/Quiz/quiz_main.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({
    Key key,
    @required this.quiz_info,
  }) : super(key: key);

  final Quiz_info quiz_info;

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
                color: quiz_info.color,
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/qr.svg",
                color: quiz_info.color,
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
                color: quiz_info.color,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyApp()),
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