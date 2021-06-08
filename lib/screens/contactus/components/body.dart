import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:image_picker/image_picker.dart';

class ContactUsBody extends StatefulWidget {
  @override
  _ContactUsBodyState createState() => _ContactUsBodyState();
}

class _ContactUsBodyState extends State<ContactUsBody> {
  TextEditingController subjectTEC = new TextEditingController();

  TextEditingController descriptionTEC = new TextEditingController();

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  File _image;
  bool imagePicked = false;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: TextFormField(
                  controller: subjectTEC,
                  validator:(val) => validate(val),
                  maxLength: 50,
                  decoration: InputDecoration(
                      hintText: "Subject",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23))),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: TextFormField(
                  validator:(val) => validate(val),
                  maxLength: 255,
                  controller: descriptionTEC,
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23))),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    await attachImage();
                  },
                  child: imagePicked
                      ? Container(
                    height: 40,
                      child: Text(_image.path))
                      : Row(
                          children: [Text("Attach:"), Icon(Icons.add)],
                        ),
                ),
              ),
              MaterialButton(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23.0),
                  ),
                  color: Colors.lightBlue,
                  onPressed: () async {
                    if(formKey.currentState.validate())
                      {
                        if(imagePicked) {
                          var response = await sendEmail(
                              descriptionTEC.text, subjectTEC.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                              new SnackBar(content: Text(response)));
                          // Navigator.pop(context); //Uncomment when added to a stack of views.
                        }else
                        {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("No image has been picked"),
                                  actions: [
                                    MaterialButton(
                                      onPressed: ()
                                      {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Close"),
                                    )
                                  ],
                                );
                              }
                          );
                        }
                      }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100.0,
                    height: 40.0,
                    child: Text("Submit"),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future attachImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imagePicked = true;
      } else {
        print('No image selected.');
      }
    });
  }

  sendEmail(String body, String subject) async
  {
    var platformResponse;
    try{
      final MailOptions mailOptions = MailOptions(
        body: body,
        subject: subject,
        recipients: ['quizse2021@gmail.com'],
        isHTML: false,
        attachments: [_image.path],
      );

      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved: /// ios only
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent: /// ios only
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled: /// ios only
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'Email sent!';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
      print(platformResponse);
      return platformResponse;
    }catch(e)
    {
      print("Error in contact us: $e");
    }
  }

  validate(String val)
  {
    if(val.isEmpty)
      {
        return "This field cannot be empty";
      }
  }
}
