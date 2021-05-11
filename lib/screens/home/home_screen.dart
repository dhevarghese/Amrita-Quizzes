//import 'package:amrita_quizzes/common_widgets/avatar.dart';
import 'package:amrita_quizzes/common_widgets/platform_alert_dialog.dart';
import 'package:amrita_quizzes/common_widgets/platform_exception_alert_dialog.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
//import 'package:amrita_quizzes/constants/keys.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/addquiz/add_quiz_screen.dart';
import 'package:amrita_quizzes/screens/home/components/body.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

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


  /*
  FutureBuilder<List<Quiz>> (
              future: dbs.getQuizzes(),
              builder: (context, AsyncSnapshot dashBoardsnapshot) {
                if(!dashBoardsnapshot.hasData){
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                else {
                  return Body(dashBoardsnapshot.data);
                }
              }
              ,
            ),
   */

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    dbs.getQuizById('xgBjbGsmedoqLycp2NPK');
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<List<Quiz>> (
        future: dbs.getQuizzes(),
        builder: (context, AsyncSnapshot<List<Quiz>> dashBoardsnapshot) {
          if(!dashBoardsnapshot.hasData){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else {
            List<Quiz> data = dashBoardsnapshot.data;
            return Body(data);
          }
        }
        ,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 4.0,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddQuizScreen(),
            )
        ),
      ),
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
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/search.svg",
            // By default our  icon color is white
            color: kTextColor,
          ),
          onPressed: () {},
        ),
/*
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
*/
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




