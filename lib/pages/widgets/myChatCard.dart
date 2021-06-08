import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/Chats.dart';

// ignore: must_be_immutable
class ChatCard extends StatelessWidget {
  Chats myChat;

  ChatCard(this.myChat);

  @override
  Widget build(BuildContext context) {

    String date = "";
    String time2 = "";
    String time = "";
    try {
      date = Utilities().replaceFarsiNumber(myChat.message["created_at"].split('T')[0] ?? "");
      time2 = myChat.message["created_at"].split('T')[1] ?? "";
      time = Utilities().replaceFarsiNumber(time2.split(".")[0] ?? "");
    } catch (e) {}

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Stack(
              children: [
                if (myChat.user["profile_image"] != null)
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('http://37.152.176.11' + myChat.user["profile_image"]),
                  )
                else
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                  ),
                if (!myChat.message["is_read"])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 1),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myChat.user["username"],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        myChat.message["message"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Opacity(
                  opacity: 0.64,
                  child: Text(date),
                ),
                Opacity(
                  opacity: 0.64,
                  child: Text(time),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
