
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/details/details_screen.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'categories.dart';
import 'quiz_card.dart';

class Body extends StatefulWidget {
  final List<Quiz> qlist;
  Body(this.qlist, {Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Quiz> quizzes = [];
  //Future<List<Quiz>> futureQuiz;
  String SelectedCategory = "";
  int selectedIndex = 0;



  List<Quiz> filterQList(String filter)  {
    List<Quiz> filterq = [];
    for (var quiz in widget.qlist) {
      if(quiz.category == filter) {
        filterq.add(quiz);
      }
    }
    return filterq;
  }

  callback(newSelectedCategory) {
    setState(() {
      SelectedCategory = newSelectedCategory;
      quizzes =filterQList(SelectedCategory);

    });
  }


  @override
  void initState() {
    super.initState();
    if (widget.qlist.length != 0) {
      SelectedCategory = widget.qlist[0].category;
    }
    quizzes = filterQList(SelectedCategory);
  }

  GridView _quizGridView(List<Quiz> data) {
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: kDefaultPaddin,
          crossAxisSpacing: kDefaultPaddin,
          childAspectRatio: 0.75 ,
        ),
        itemBuilder: (context, index) => ItemCard(
          quiz_info: data[index],
          press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  quiz_info: data[index],
                ),
              )),
        ));

    /*

     */
  }

  @override
  Widget build(BuildContext context) {
    return (widget.qlist.length == 0) ?  noQuizzes() : quizDisplay();
    //return quizDisplay();
  }

  Widget noQuizzes() {
    return Container(
        child: Center(
            child: Text('No Quizzes To Take at this moment', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),)
        )
    );
  }


  Widget quizDisplay(){
    final dbs = Provider.of<Database>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text(
            "$SelectedCategory Quizzes ",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        Categories(SelectedCategory, callback, widget.qlist),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: _quizGridView(quizzes),
          ),
        ),
      ],
    );
  }
}

