import 'dart:convert';

import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/screens/home/components/body.dart';
import 'package:amrita_quizzes/screens/home/components/qr.dart';
//import 'package:amrita_quizzes/app/home_page.dart';

//import 'package:amrita_quizzes/common_widgets/avatar.dart';
import 'package:amrita_quizzes/common_widgets/platform_alert_dialog.dart';
import 'package:amrita_quizzes/common_widgets/platform_exception_alert_dialog.dart';
//import 'package:amrita_quizzes/constants/keys.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SearchBar searchbar;
  List test = [];
  List products = [];
  String searchText = "";
  _HomeScreenState() {
    searchbar = SearchBar(
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: (value) {
          searchText = value;
          filter(test);
        },
        onSubmitted: (value) {},
        onCleared: () {},
        onClosed: () {},
        inBar: false);
  }
  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  void filter(test) {
    products.clear();
    if (searchText == null || searchText == "") {
      for (int i = 0; i < test.length; i++) {
        products.add(Quiz_info(
            id: int.parse(test[i]["id"]),
            title: test[i]['title'],
            price: test[i]['price'],
            size: test[i]['size'],
            image: test[i]['image'],
            color: Color(int.parse(test[i]["colorcode"])),
            description:
                'This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.',
            faculty: test[i]['faculty'],
            marks: test[i]['marks'],
            duration: test[i]['duration']));
      }
      setState(() {});
      return;
    }

    for (int i = 0; i < test.length; i++) {
      if (test[i]['title']
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        products.add(Quiz_info(
            id: int.parse(test[i]["id"]),
            title: test[i]['title'],
            price: test[i]['price'],
            size: test[i]['size'],
            image: test[i]['image'],
            color: Color(int.parse(test[i]["colorcode"])),
            description:
                'This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.',
            faculty: test[i]['faculty'],
            marks: test[i]['marks'],
            duration: test[i]['duration']));
      }
    }
    setState(() {});
  }

  Future<void> readJsonProducttemp() async {
    final String response = await rootBundle.loadString('assets/QuizInfo.json');
    final data = await json.decode(response);
    //_items = data["Categories"];
    test = data["QuizInfo"];
    filter(test);
    // setState(() {
    //
    //   //print(test);
    //   for (int i = 0; i < test.length; i++) {
    //     var tempid = int.parse(test[i]["id"]);
    //     var temptitle = test[i]["title"];
    //     var tempprice = test[i]["price"];
    //     var tempsize = test[i]["size"];
    //     var tempimage = test[i]["image"];
    //     var tempcolor = Color(int.parse(test[i]["colorcode"]));
    //     //var tempdescription = test[i]["description"];
    //     var tempdescription ="This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.";
    //     var tempfaculty = test[i]["faculty"];
    //     var tempmarks = test[i]["marks"];
    //     var tempduration = test[i]["duration"];
    //
    //     var temp_quiz_info = Quiz_info(
    //         id: tempid,
    //         title: temptitle,
    //         price: tempprice,
    //         size: tempsize,
    //         image: tempimage,
    //         color: tempcolor,
    //         description: tempdescription,
    //         faculty: tempfaculty,
    //         marks: tempmarks,
    //         duration: tempduration);
    //     productstest.add(temp_quiz_info);
    //     products.add(temp_quiz_info);// comment this later, used for test
    //
    //     print(temp_quiz_info.image);
    // }
    // });
  }

  @override
  void initState() {
    readJsonProducttemp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchbar.build(context),
      body: Body(products),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {
          _confirmSignOut(context);
        },
      ),
      /*Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: SvgPicture.asset("assets/icons/back.svg"),
            onPressed: () {
              onPressed: () => _confirmSignOut(context);
            },
          );
        },
      ),

       */
      /*
      title: Text(
        "Quizzes", style: TextStyle(color: Colors.black),
      ),
       */
      actions: <Widget>[
        searchbar.getSearchAction(context),
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                "assets/icons/qr.svg",
                // By default our  icon color is white
                color: kTextColor,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => QRViewExample()),
                );
              },
            );
          },
        ),

        //IconButton(
        //icon: SvgPicture.asset(
        //"assets/icons/qr.svg",
        // By default our  icon color is white
        //color: kTextColor,
        // ),
        //onPressed: () {
        // Navigator.of(context).push(
        // MaterialPageRoute(
        //   builder: (BuildContext context) => Qr()),
        //);
        //},
        //),

        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
