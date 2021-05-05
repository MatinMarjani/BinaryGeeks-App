import 'dart:ui';
import 'package:flutter/material.dart';


class BlurryDialog extends StatelessWidget {

  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);
  TextStyle textStyle = TextStyle (color: Colors.black, fontFamily: 'myfont');

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          title: new Text(title,style: textStyle,),
          content: new Text(content, style: textStyle,),
          actions: <Widget>[
            new TextButton(
              child: new Text("بله",style:TextStyle (color: Colors.white, fontFamily: 'myfont')),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                continueCallBack();
              },
            ),
            new TextButton(
              child: Text("خیر",style:TextStyle (fontFamily: 'myfont')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}