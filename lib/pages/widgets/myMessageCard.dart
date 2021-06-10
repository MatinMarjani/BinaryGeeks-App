import 'package:flutter/material.dart';

import 'package:application/util/Chats.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/User.dart';

class MessageCard extends StatelessWidget {
  final Messages message;
  final Chats myChat;

  MessageCard(this.message, this.myChat);

  @override
  Widget build(BuildContext context) {
    bool _noImage;
    bool _noImage2;

    if (User.profileImage == null)
      _noImage = true;
    else
      _noImage = false;

    if (myChat.user['profile_image'] == null)
      _noImage2 = true;
    else
      _noImage2 = false;

    String date2 = "";
    String date = "";
    String time2 = "";
    String time3 = "";
    String time = "";

    date2 = Utilities().replaceFarsiNumber(message.message["created_at"].split('T')[0] ?? "");
    date = date2.split("-")[1] + "/" + date2.split("-")[2];
    time2 = message.message["created_at"].split('T')[1] ?? "";
    time3 = Utilities().replaceFarsiNumber(time2.split(".")[0] ?? "");
    time = time3.split(":")[0] + ":" + time3.split(":")[1];

    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
      child: Row(
        mainAxisAlignment: message.isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.isSender) ...[
            !_noImage
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('http://37.152.176.11' + User.profileImage),
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Text(
                      User.email[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
            SizedBox(width: 5),
          ],
          if (!message.isSender) ...[
            Column(
              children: [
                Text(time),
                Text(date),
              ],
            ),
            SizedBox(width: 5),
          ],
          TextMessage(message),
          if (message.isSender) ...[
            SizedBox(width: 5),
            Column(
              children: [
                Text(time),
                Text(date),
              ],
            ),
          ],
          if (!message.isSender) ...[
            SizedBox(width: 5),
            !_noImage2
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('http://37.152.176.11' + myChat.user["profile_image"]),
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Text(
                      myChat.user['email'][0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange,
                  ),
          ],
        ],
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  TextMessage(this.message);

  final Messages message;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(message.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message.message["message"],
        // "sadddddddddddddddddddddd asdaasd asdasd asd sadddddddddddddddddddddd asdaasd asdasd asd sadddddddddddddddddddddd asdaasd asdasd asd sadddddddddddddddddddddd asdaasd asdasd asd ",
        style: TextStyle(
          color: message.isSender ? Colors.white : mainColor,
        ),
      ),
    ));
  }
}
