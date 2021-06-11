import 'dart:async';

import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/models/QuizUser.dart';
import 'package:amrita_quizzes/screens/details/details_screen.dart';
import 'package:amrita_quizzes/screens/home/components/quiz_card.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatefulWidget {
  final QuizUser userInfo;
  Body(this.userInfo, {Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedIndex = 0;
  List options = ["Created", "Taken", "Details"];
  List avs = [Icons.add_chart, Icons.analytics_outlined, Icons.admin_panel_settings_outlined];
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ),
        if(selectedIndex==0)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: getQuizzes(selectedIndex),
            ),
          ),
        if(selectedIndex==1)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: getScores(),
            ),
          ),
        if(selectedIndex==2)
          getUDetails(),
      ],
    );
  }

  Widget getScores(){
    Map quizzes = widget.userInfo.quizzesTaken;
    return ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            final snackBar = SnackBar(
              content: Text('More details will be available soon!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Card(
              //color: Colors.lightBlue[50],
              color: (quizzes.values.elementAt(index)[5]) ? (quizzes.values.elementAt(index)[0] /quizzes.values.elementAt(index)[1] > 0.80) ? Colors.greenAccent : (quizzes.values.elementAt(index)[0] /quizzes.values.elementAt(index)[1] > 0.50) ? Colors.amber[400] : Colors.redAccent : Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text('${quizzes.values.elementAt(index)[3]}', style: TextStyle(color: Colors.white),),
                trailing: Text((quizzes.values.elementAt(index)[5]) ? '${quizzes.values.elementAt(index)[0]} / ${quizzes.values.elementAt(index)[1]}' : "Not Published", style: TextStyle(color: Colors.white),),
                /*trailing: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: '${quizzes.values.elementAt(index)[0]} / ${quizzes.values.elementAt(index)[1]}', style: TextStyle(color: Colors.black)),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                ),*/
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getQuizzes(int index){
    final dbs = Provider.of<Database>(context);
    String category = (selectedIndex==0)? "quizzes_created" : "quizzes_taken";
    return FutureBuilder<List<Quiz>> (
        future: dbs.getQuizzes(category),
        builder: (context, AsyncSnapshot<List<Quiz>> dashBoardSnapshot) {
          if(!dashBoardSnapshot.hasData){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else {
            List<Quiz> data = dashBoardSnapshot.data;
            return _quizGridView(data);
          }
        }
    );
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
                  mode:0,
                  quiz_info: data[index],
                ),
              )),
        ));
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          //widget.callback(categories[index]);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Chip(
              //backgroundColor: Colors.lightBlue[50],
              avatar: Icon(
                avs[index],
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
              label: Text(
                options[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? kTextColor : kTextLightColor,
                ),
              )
            ),
            Expanded(
              child: Container(
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

  Widget getUDetails(){
    final dbs = Provider.of<Database>(context);
    final _formKey = GlobalKey<FormBuilderState>();
    return Expanded(
      child: Padding(
        padding: new EdgeInsets.fromLTRB(32,16,32,16),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(name: 'uName',
                    initialValue: widget.userInfo.name,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle, color: Colors.lightBlueAccent,),
                      labelText: 'Name',
                      //prefixText: widget.userInfo.name,
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.required(context),
                  ),
                  SizedBox(height: 16),
                  FormBuilderTextField(name: 'uDept',
                    initialValue: widget.userInfo.department,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_balance_outlined, color: Colors.lightBlueAccent,),
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.required(context),
                  ),
                  SizedBox(height: 16),
                  FormBuilderTextField(name: 'uSect',
                    initialValue: widget.userInfo.section,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_tree, color: Colors.lightBlueAccent,),
                      labelText: 'Section',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.required(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            RoundedLoadingButton(
              key: Key('form-user-info-update-button'),
              child: Text("Update details!", style: TextStyle(color: Colors.white, fontSize: 20.0)),
              height: 44.0,
              color: Colors.lightBlueAccent,
              controller: _btnController,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final validationSuccess = _formKey.currentState.validate();
                if(validationSuccess){
                  _formKey.currentState.save();
                  final formData = _formKey.currentState.value;
                  print(formData);
                  print(_formKey.currentState.value['uName']);
                  return dbs.updateUserData(formData['uName'], formData['uDept'], formData['uSect']).then((value){
                    _btnController.success();
                    Timer(Duration(seconds: 2), () {
                      _btnController.reset();
                    });
                  });
                }
                return _btnController.reset();
                //Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}