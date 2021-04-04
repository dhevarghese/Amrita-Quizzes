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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
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




