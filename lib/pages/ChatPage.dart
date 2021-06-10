import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myMessageCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/Chats.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  Chats myChat;

  ChatPage(this.myChat);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isLoading = false;
  Timer timer;
  List<Messages> messages = [];

  static ScrollController _scrollController = new ScrollController();

  void initState() {
    super.initState();
    log("ChatPage init");
    setState(() {
      messages.clear();
      _isLoading = true;
      MyAppBar.appBarTitle =
          Text(widget.myChat.user["email"], style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    sendIsRead(widget.myChat.threadId);
    getMessages(widget.myChat.threadId);
    const oneSec = const Duration(seconds:3);
    timer =  Timer.periodic(oneSec, (Timer t) => repeat());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.mainColor),
            ))
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) => MessageCard(messages[index], widget.myChat, index, messages.length),
                  ),
                ),
                ChatInputField(sendMessage, widget.myChat.threadId),
              ],
            ),
      drawer: MyDrawer(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  sendIsRead(int threadID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var url = Uri.parse(AppUrl.Send_Is_Read + threadID.toString());
    var response;
    var headers = {'Authorization': 'Token $token'};

    try {
      response = await http.put(url, headers: headers);
      if (response.statusCode == 200) {
        log("Send Is_Read Message : 200");
      } else {
        log("Send Is_Read Message : !200");
      }
    } catch (e) {
      log("error Is_Read : e");
    }
  }

  getMessages(int threadID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    var response;
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Get_Chat_Messages + threadID.toString());
    var token = sharedPreferences.getString("token");

    try {
      response = await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('Chat : 200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        // print(jsonResponse);
        setState(() {
          if (jsonResponse != null) {
            setState(() {
              for (var i in jsonResponse) {
                bool isSender;
                if (i["sender"].toString() == id)
                  isSender = true;
                else
                  isSender = false;
                messages.add(Messages(i, id, isSender));
              }
            });
          }
        });
      } else {
        log('Chat : !200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        log(jsonResponse);
      }
    } catch (e) {
      print(e);
      log("Chat : error");
    }

    setState(() {
      _isLoading = false;
    });
  }

  sendMessage(int threadID, String text) async {
    _scrollController.animateTo(
      100000000000000000,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Send_Messages + threadID.toString());
    var response;
    var jsonResponse;
    var headers = {'Authorization': 'Token $token', 'Content-Type': 'application/json'};
    var body;

    if (text.isNotEmpty) {
      body = jsonEncode(<String, dynamic>{
        "message": text,
      });
    }

    try {
      response = await http.post(url, body: body.toString(), headers: headers);
      if (response.statusCode == 200) {
        log("Send Message : 200");
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        setState(() {
          messages.add(Messages(jsonResponse, id, true));
        });
      } else {
        log("Send Message : !200");
        print(response.body);
      }
    } catch (e) {
      log(e);
    }
  }

  repeat() {
    messages.clear();
    getMessages(widget.myChat.threadId);
    sendIsRead(widget.myChat.threadId);
  }
}

// ignore: must_be_immutable
class ChatInputField extends StatelessWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;
  static final TextEditingController textEditingController = new TextEditingController();

  dynamic acceptBid;
  final int threadId;

  ChatInputField(this.acceptBid, this.threadId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Transform.rotate(
                      angle: 180 * math.pi / 180,
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // ignore: unnecessary_statements
                          acceptBid(threadId, textEditingController.text);
                          textEditingController.text = "";
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: "تایپ کنید ...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
