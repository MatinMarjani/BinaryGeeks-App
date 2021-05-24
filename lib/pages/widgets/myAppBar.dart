import 'dart:convert';
import 'package:application/util/Post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:application/pages/widgets/myNotifCard.dart';

import 'package:application/pages/searchPage.dart';

import 'package:application/util/Utilities.dart';
import 'package:application/util/app_url.dart';

class MyAppBar extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  static Widget appBarTitle = Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont));
  static Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  _MyAppBarState createState() => _MyAppBarState(appBarTitle, actionIcon);
}

class _MyAppBarState extends State<MyAppBar> {
  Widget appBarTitle = Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);
  List<Widget> myNotifications = [];
  List<Post> myPost = [];
  bool alert = false;

  _MyAppBarState(
    this.appBarTitle,
    this.actionIcon,
  );

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      backgroundColor: widget.mainColor,
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            if (this.actionIcon.icon == Icons.search) {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => SearchPage()));
            } else if (this.actionIcon.icon == Icons.close) {
              setState(() {
                this.actionIcon = Icon(
                  Icons.search,
                  color: Colors.white,
                );
                this.appBarTitle =
                    Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont));
                Navigator.pop(context);
              });
            }
          },
        ),
        IconButton(
            icon: alert ? Icon(Icons.notifications, color: Colors.red)
                : Icon(Icons.notifications_none_outlined),
            onPressed: () {
              setState(() {
                alert = false;
              });
              showBarModalBottomSheet(
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: notifications(),
                ),
              );
            })
      ],
    );
  }

  Widget notifications() {
    if (myNotifications.isEmpty) {
      myNotifications.add(Center(
        heightFactor: 4,
        child: Text(
          "هیچ اعلانی ندارید",
          style: TextStyle(color: Colors.red, fontSize: 20, fontFamily: widget.myFont),
        ),
      ));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: myNotifications);
  }

  getNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse(AppUrl.Get_Notifications);
    var token = sharedPreferences.getString("token");
    var jsonResponse;
    var response;

    try {
      response = await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse["results"]);
        if (jsonResponse != null) {
          setState(() {
            for (var i in jsonResponse["results"]) {
              getPost(sharedPreferences, i["post"], i);
            }
          });
        }
      } else {
        log('!200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print(e);
      log("error");
    }

    if ( myNotifications.isNotEmpty ) {
      setState(() {
        myNotifications.add(SizedBox(
          height: 200,
        ));
      });
    }
  }

  getPost(SharedPreferences sharedPreferences, int postID, var i) async {
    var token = sharedPreferences.getString("token");
    var url = Uri.parse(AppUrl.Get_Post + postID.toString());
    var jsonResponse;
    var response;

    try {
      response = await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse != null) {
          setState(() {
                myNotifications.add(NotificationCard(i["id"], i["owner"], i["post"], i["is_seen"], i["message"], Post(
                  jsonResponse["owner"]["id"],
                  jsonResponse["owner"]["email"],
                  jsonResponse["owner"]["profile_image"],
                  jsonResponse["id"],
                  jsonResponse["title"],
                  jsonResponse["author"],
                  jsonResponse["publisher"],
                  jsonResponse["price"],
                  jsonResponse["province"],
                  jsonResponse["city"],
                  jsonResponse["zone"],
                  jsonResponse["status"],
                  jsonResponse["description"],
                  jsonResponse["is_active"],
                  AppUrl.baseURL + jsonResponse["image"],
                  //url
                  jsonResponse["categories"],
                  jsonResponse["created_at"],
                  jsonResponse["exchange_book_title"],
                  jsonResponse["exchange_book_author"],
                  jsonResponse["exchange_book_publisher"],
                )));
                myNotifications.add(Divider(thickness: 3,));
                if( !i["is_seen"] ) {
                  alert = true;
                }
          });
        }
      } else {
        log('!200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print(e);
      log("error");
    }
  }
}
