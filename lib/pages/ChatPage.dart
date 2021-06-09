import 'dart:convert';
import 'dart:developer';
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
  List<Messages> messages = [];


  void initState() {
    super.initState();
    log("ChatPage init");
    setState(() {
      _isLoading = true;
      MyAppBar.appBarTitle = Text("چت", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    getMessages(widget.myChat.threadId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: _isLoading
          ? Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(widget.mainColor),
          ))
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) =>
            MessageCard(messages[index], widget.myChat),
      ),
      drawer: MyDrawer(),
    );
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
        setState(() {
          if (jsonResponse != null) {
            setState(() {
              for (var i in jsonResponse) {
                bool isSender;
                if(i["sender"].toString() == id)
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
}
