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
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Post> myPost = [];

  void initState() {
    super.initState();
    log("Dashboard init");
    setState(() {
      MyAppBar.appBarTitle =
          Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    //getPosts();
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
        child: ListView(children: <Widget>[
          Posts(),
        ]),
      ),
      drawer: MyDrawer(),
    );
  }

  Container Posts() {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PostCard( Post(0, "owner_email", null, 0, "title", "author", "publisher", 1500000, "province", "city", "zone", "status", "description", true, null, "categories", "") ),
        ],
      ),
    );
  }

  getPosts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse = null;
    var response;

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse("??????");

    try {
      response =
          await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        print(response.body);
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            //_isLoading = false;
          });
        }
      } else {
        log('!200');
        print(response.body);
      }
    } catch (e) {
      print(e);
    }

    response = await http.get(url);
    final extractedData = json.decode(response.body);
    List posts = extractedData['post'];
  }
}
