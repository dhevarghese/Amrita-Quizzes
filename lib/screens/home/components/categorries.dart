import 'dart:convert';

import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// We need satefull widget for our categories

class Categories extends StatefulWidget {
  String SelectedCategory;
  Function(String) callback;

  Categories(this.SelectedCategory, this.callback);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  //List<String> categories = ["CSE", "ECE", "ASCII", "CIE"];
  List categories = [];
  // By default our first item will be selected
  int selectedIndex = 0;


  // start temp json workspace
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/categories.json');
    final data = await json.decode(response);
    setState(() {
      //_items = data["Categories"];
      categories = data["Categories"];
      //print(categories);
    });
  }
  //end temp json workspace

  @override
  void initState() {
    super.initState();
    readJson();
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
          widget.callback(categories[index]["name"]);
          //print(selectedIndex);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index]["name"],
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
            /*
            Container(//
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )

             */
          ],
        ),
      ),
    );
  }
}
