import 'dart:ui';
import 'package:application/pages/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/Post.dart';
import 'package:http/http.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
      child: ListTile(
        leading: seen
            ? Text(
                "اعلان قدیمی",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              )
            : Text(
                "اعلان جدید",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
        title: Text(
          "درخواست جدید",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("پست $postID"),
        trailing: Text("$notificationID"),
        isThreeLine: true,
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => PostPage(post)));
        },
      ),
    );
  }
}
