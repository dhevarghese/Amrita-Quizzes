import 'package:amrita_quizzes/models/QuizUser.dart';
import 'package:amrita_quizzes/screens/profile/components/body.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return Scaffold(
        body: FutureBuilder<QuizUser> (
            future: dbs.getUserDetails(),
            builder: (context, AsyncSnapshot<QuizUser> userSnapshot) {
              if(!userSnapshot.hasData){
                return Center(
                    child: CircularProgressIndicator()
                );
              }
              else {
                QuizUser data = userSnapshot.data;
                return Body(data);
              }
            }
        )
    );
  }
}