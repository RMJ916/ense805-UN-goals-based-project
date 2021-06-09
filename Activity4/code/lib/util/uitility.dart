import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

 

void shareImage1({
  ScreenshotController controller,String msg
}) async {
  final directory =
      (await getTemporaryDirectory()).path; //from path_provide package
  String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  var path = '$directory';

  controller
      .captureAndSave(
          path //set path where screenshot will be saved
          ,
          fileName: fileName + '.png',
          pixelRatio: 5)
      .then((value) {
    print(value);
    Share.shareFiles(['${directory}/${fileName}.png'], text: msg)
        .then((value) {
      File('${directory}/${fileName}.png').delete().then((value) {
        print("cache file deleted");
      });
    });
  });
}
