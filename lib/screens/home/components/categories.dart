
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:flutter/material.dart';

// We need satefull widget for our categories

class Categories extends StatefulWidget {
  String SelectedCategory;
  Function(String) callback;
  final List<Quiz> qlist;

  Categories(this.SelectedCategory, this.callback, this.qlist);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List categories = [];
  int selectedIndex = 0;


  void getCategories()  {
      for (var quiz in widget.qlist) {
        if (!(categories.contains(quiz.category))) {
          categories.add(quiz.category);
        }
      }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.callback(categories[index]);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            Expanded(
              child: Container(//
                margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
                height: 2,
                width: 30,
                color: selectedIndex == index ? Colors.black : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
