import 'dart:convert';

import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:amrita_quizzes/screens/details/details_screen.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'categorries.dart';
import 'quiz_card.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List test = [];


  Future<void> readJsonProducttemp() async {
    final String response = await rootBundle.loadString('assets/QuizInfo.json');
    final data = await json.decode(response);
    //_items = data["Categories"];
    setState(() {
      test = data["QuizInfo"];
      //print(test);
      for (int i = 0; i < test.length; i++) {
        var tempid = int.parse(test[i]["id"]);
        var temptitle = test[i]["title"];
        var tempprice = test[i]["price"];
        var tempsize = test[i]["size"];
        var tempimage = test[i]["image"];
        var tempcolor = Color(int.parse(test[i]["colorcode"]));
        //var tempdescription = test[i]["description"];
        var tempdescription ="This quiz will assess your knowledge on the topics covered in the first four weeks of the semester. Marks will be taken into account for continuous assessment.";
        var tempfaculty = test[i]["faculty"];
        var tempmarks = test[i]["marks"];
        var tempduration = test[i]["duration"];

        var temp_quiz_info = Quiz_info(
            id: tempid,
            title: temptitle,
            price: tempprice,
            size: tempsize,
            image: tempimage,
            color: tempcolor,
            description: tempdescription,
            faculty: tempfaculty,
            marks: tempmarks,
            duration: tempduration);
        productstest.add(temp_quiz_info);
        products.add(temp_quiz_info);// comment this later, used for test

        print(temp_quiz_info.image);
    }
    });
  }

  @override
  void initState() {
    super.initState();
    readJsonProducttemp();
  }

  Widget getUName(Database dbs){
    final _formKey = GlobalKey<FormBuilderState>();
    return Container(
      color: Colors.white,
      padding: new EdgeInsets.all(50),
      child: Column(
        children: [
          Text(
            'Identify yourself!',
            style: Theme.of(context).textTheme.headline5,
          ),
          FormBuilder(
            key: _formKey,
            child: FormBuilderTextField(name: 'uName',
              decoration: InputDecoration(
                labelText: 'Your name',
                hintText: 'Ron',
              ),
              validator: FormBuilderValidators.required(context),
            ),
          ),
          TextButton(
            child: new Text("OK"),
            onPressed: () {
              final validationSuccess = _formKey.currentState.validate();
              if(validationSuccess){
                _formKey.currentState.save();
                final formData = _formKey.currentState.value;
                print(formData);
                print(_formKey.currentState.value['uName']);
                dbs.updateUserData(_formKey.currentState.value['uName']);
                setState(() {});
              }
              //Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return FutureBuilder<String>(
        future: dbs.getUserName(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            // while data is loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // data loaded:
            final uName = snapshot.data;
            if(uName == ""){
              /*return Stack(children: [
                quizDisplay(),
                getUName(dbs)
              ],);*/
              return getUName(dbs);
            }
            return quizDisplay();
          }
        }
    );
  }

  Widget quizDisplay(){
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
                  childAspectRatio: 0.75 ,
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
