import 'package:flutter/material.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:amrita_quizzes/screens/details/details_screen.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

import 'categorries.dart';
import 'quiz_card.dart';

class Body extends StatefulWidget {
  final List products;
  Body(this.products);
  //Body({Key key}) : super(key: key);

  _BodyState createState() => _BodyState(products);
}

class _BodyState extends State<Body> {
  List test = [];
  List products;
  _BodyState(List products) {
    this.products = products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text(
            "Quizzes",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Categories(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPaddin,
                  crossAxisSpacing: kDefaultPaddin,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                      quiz_info: products[index],
                      press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              quiz_info: products[index],
                            ),
                          )),
                    )),
          ),
        ),
      ],
    );
  }
}
