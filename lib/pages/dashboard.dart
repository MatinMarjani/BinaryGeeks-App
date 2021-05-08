import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myPostCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';

class DashBoard extends StatefulWidget {
  final Color mainColor = Colors.blue[800];
  final String myFont = 'myFont';


  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Post> myPost = [];
  bool _isLoading = false;

  void initState() {
    super.initState();
    log("Dashboard init");
    setState(() {
      MyAppBar.appBarTitle =
          Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _isLoading
            ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(widget.mainColor),
            ))
            : ListView(children: <Widget>[
          Posts(),
        ]),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget Posts() {
    if (myPost.length == 0) return Text("nothing");
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < myPost.length; i++) {
      if (myPost[i].title == null) myPost[i].title = " ";
      if (myPost[i].author == null) myPost[i].author = " ";
      if (myPost[i].categories == null) myPost[i].categories = " ";
      if (myPost[i].price == null) myPost[i].price = 0;
      if (myPost[i].province == null) myPost[i].province = " ";
      if (myPost[i].description == null) myPost[i].description = " ";

      list.add(PostCard(myPost[i]));
    }
    return Column(children: list);
  }

  getPosts() async {
    setState(() {
      _isLoading = true;
      myPost.clear();
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    var response;

    var url = Uri.parse(AppUrl.Get_My_Posts);
    log(AppUrl.Get_My_Posts);
    var token = sharedPreferences.getString("token");

    try {
      response = await http.get(url,headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        if (jsonResponse != null) {
          setState(() {
            for (var i in jsonResponse["results"]) {
              myPost.add(Post(
                i["owner"]["id"],
                i["owner"]["email"],
                i["owner"]["profile_image"],
                i["id"],
                i["title"],
                i["author"],
                i["publisher"],
                i["price"],
                i["province"],
                i["city"],
                i["zone"],
                i["status"],
                i["description"],
                i["is_active"],
                i["image"],
                //url
                i["categories"],
                i["created_at"],
              ));
            }
          });
        }
      } else {
        log('!200');
        print(response.body);
      }
    } catch (e) {
      log("error");
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
