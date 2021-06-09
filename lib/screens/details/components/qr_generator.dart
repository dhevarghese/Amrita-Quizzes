import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/details/components/share_qr_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatefulWidget {
  final Quiz quizinfo;

  const GenerateScreen ({ Key key, this.quizinfo }): super(key: key);
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "widget.displayText";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('0x'+widget.quizinfo.color)),
        title: Text('QR Code'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      ShareImageHelper.instance.shareImage(pngBytes);

    } catch(e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    _dataString = widget.quizinfo.id;
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          /*
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child:  Container(
              height: _topSectionHeight,
              child:  Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child:  TextField(
                      controller: _textController,
                      decoration:  InputDecoration(
                        hintText: "Enter a custom message",
                        errorText: _inputErrorText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child:  FlatButton(
                      child:  Text("SUBMIT"),
                      onPressed: () {
                        setState((){
                          _dataString =widget.displayText;
                          _inputErrorText = null;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          */
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.45 * bodyHeight,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}