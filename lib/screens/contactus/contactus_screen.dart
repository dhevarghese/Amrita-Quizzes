import 'package:amrita_quizzes/screens/contactus/components/body.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report"),),
      body: ContactUsBody(),
      resizeToAvoidBottomInset: false,
    );
  }
}