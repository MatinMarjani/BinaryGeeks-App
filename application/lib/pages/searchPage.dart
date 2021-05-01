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

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Post> myPost = [];

  void initState() {
    super.initState();
    log("Dashboard init");
    //getPosts();
    MyAppBar.appBarTitle = TextField(
      // controller: _searchQuery,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: "جست و جو",
          hintStyle: TextStyle(color: Colors.white)),
    );

    MyAppBar.actionIcon = Icon(
      Icons.close,
      color: Colors.white,
    );

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
        child: Text("search"),
      ),
      drawer: MyDrawer(),
    );
  }

  Container Posts() {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PostCard("فیزیک 1", "فرامرزی", "دانشگاهی", "25000", "تهران",
              "description"),
          SizedBox(
            height: 20,
          ),
          PostCard("ریاضی 1", "فرامرزی", "دانشگاهی", "25000", "تهران",
              "description"),
          SizedBox(
            height: 20,
          ),
          PostCard("ریاضی 2", "فرامرزی", "دانشگاهی", "35000", "تهران",
              "description"),
          SizedBox(
            height: 20,
          ),
          PostCard("فیزیک 1", "فرامرزی", "دانشگاهی", "25000", "تهران",
              "description"),
          SizedBox(
            height: 20,
          ),
          PostCard("ریاضی 1", "فرامرزی", "دانشگاهی", "25000", "تهران",
              "description"),
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
    for (var i in posts) {
      myPost.add(Post(
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
  }
}
