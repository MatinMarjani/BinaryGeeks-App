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
  final TextEditingController _searchQuery = new TextEditingController();
  String _searchText = "";

  void initState() {
    super.initState();
    log("SearchPage init");
    MyAppBar.appBarTitle = TextField(
      controller: _searchQuery,
      onSubmitted: (value) {
        if (_searchQuery.text != "" || _searchQuery.text != null) {
          myPost.clear();
          getPosts(_searchQuery.text);
        }
      },
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
        child: ListView(
          children: <Widget>[
            Posts(),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget Posts() {
    if (myPost.length == 0) return Text("nothing");
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < myPost.length; i++) {
      if( myPost[i].title == null )
        myPost[i].title = " ";
      if( myPost[i].author == null )
        myPost[i].author = " ";
      if( myPost[i].categories == null )
        myPost[i].categories = " ";
      if( myPost[i].price == null )
        myPost[i].price = 0;
      if( myPost[i].province == null )
        myPost[i].province = " ";
      if( myPost[i].description == null )
        myPost[i].description = " ";

      list.add(PostCard(myPost[i].title, myPost[i].author, myPost[i].categories,
          myPost[i].price.toString(), myPost[i].province, myPost[i].description));
    }
    return Column(
        children: list);
  }

  getPosts(String contains) async {
    var jsonResponse;
    var response;

    var url = Uri.parse(AppUrl.Search + "?contains=" + contains);
    log(AppUrl.Search + "?contains=" + contains);

    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        if (jsonResponse != null) {
          setState(() {
            //_isLoading = false;
            for (var i in jsonResponse) {
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
  }
}
