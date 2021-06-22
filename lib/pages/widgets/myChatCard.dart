import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/Chats.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/pages/ChatPage.dart';

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
      date = Utilities().replaceFarsiNumber(myChat.message["created_at"].split('T')[0] ?? "").replaceAll("-", "/");
      time2 = myChat.message["created_at"].split('T')[1] ?? "";
      time = Utilities().replaceFarsiNumber(time2.split(".")[0] ?? "");
    } catch (e) {}

    bool isRead;

    if (myChat.message["is_read"] || myChat.message["sender"] != myChat.user["id"])
      isRead = true;
    else
      isRead = false;

    return Container(
      color: isRead ? Colors.white : Colors.redAccent[100],
      child: InkWell(
        highlightColor: Colors.red,
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => ChatPage(myChat)));
        },
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
                      child: Text(
                        myChat.user['email'][0],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: Utilities().myFont),
                      ),
                      backgroundColor: Colors.orange,
                    ),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: Utilities().myFont),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          myChat.message["message"],
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Utilities().myFont),
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
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: Utilities().myFont),
                    ),
                  ),
                  Opacity(
                    opacity: 0.64,
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: Utilities().myFont),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
