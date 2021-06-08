import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myChatCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/Chats.dart';

class ChatList extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool _isLoading = false;
  List<Chats> myChats = [];

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    log("ChatList init");
    setState(() {
      _isLoading = true;
      MyAppBar.appBarTitle = Text("چت ها", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    getChatLists();
  }

  void _onRefresh() async {
// monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
// monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
// if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("بار گذاری شد");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(widget.mainColor),
              ))
            : myChats.isNotEmpty
                ? ListView.builder(
                    itemCount: myChats.length,
                    itemBuilder: (context, index) => ChatCard(
                      myChats[index],
                    ),
                  )
                : Text("SADfadfsdfgdgsa gsdsgd aa gs"),
      ),
      drawer: MyDrawer(),
    );
  }

  getChatLists() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    var response;
    var url = Uri.parse(AppUrl.Get_User_Chats);
    var token = sharedPreferences.getString("token");

    try {
      response = await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('CHAT List : 200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          if (jsonResponse != null) {
            setState(() {
              for (var i in jsonResponse) {
                myChats.add(Chats(i["thread_id"], i["user"], i["message"]));
              }
            });
          }
        });
      } else {
        log('Chat List : !200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        log(jsonResponse);
      }
    } catch (e) {
      print(e);
      log("error");
    }
    setState(() {
      _isLoading = false;
    });
  }
}
