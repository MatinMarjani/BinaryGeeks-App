import 'dart:ui';
import 'package:application/pages/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/Post.dart';

//ignore: must_be_immutable
class NotificationCard extends StatelessWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  int notificationID;
  int ownerID;
  int postID;
  bool seen = false;
  String message;

  Post post;

  NotificationCard(this.notificationID, this.ownerID, this.postID, this.seen, this.message, this.post);

  @override
  Widget build(BuildContext context) {
    String postIDfarsi = Utilities().replaceFarsiNumber(postID.toString());
    String notificationIDfarsi = Utilities().replaceFarsiNumber(notificationID.toString());
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
      child: ListTile(
        leading: seen
            ? Text(
                "اعلان قدیمی",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, fontFamily: Utilities().myFont),
              )
            : Text(
                "اعلان جدید",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14, fontFamily: Utilities().myFont),
              ),
        title: Text(
          "درخواست جدید",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: Utilities().myFont),
        ),
        subtitle: Text(
          "پست $postIDfarsi",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200, fontFamily: Utilities().myFont),
        ),
        trailing: Text(
          "$notificationIDfarsi",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200, fontFamily: Utilities().myFont),
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => PostPage(post)));
        },
      ),
    );
  }
}
