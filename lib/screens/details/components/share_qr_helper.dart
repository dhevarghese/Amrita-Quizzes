import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';

/// class that will take image url try to download it after that will preview share
class ShareImageHelper {
  ////////// singleton
  ShareImageHelper._privateConstructor();

  static ShareImageHelper _instance;

  static ShareImageHelper get instance {
    if (_instance == null) {
      _instance = ShareImageHelper._privateConstructor();
    }
    return _instance;
  }

  ////////// actions
  Future shareImage(Uint8List imageAsUint8List) async{
    await Share.files(
        "share image",
        {
          'image.png': imageAsUint8List,
        },
        '*/*');

  }



}