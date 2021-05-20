import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myPostCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';
import 'package:application/util/Utilities.dart';

class BookMarks extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;


  @override
  _BookMarksState createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  List<Post> myPost = [];
  bool _isLoading = false;
  int page;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    log("Bookmark init");
    setState(() {
      _isLoading = true;
      page = 1;
      MyAppBar.appBarTitle =
          Text("نشان ها", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
      myPost.clear();
    });
    getPosts(page.toString());
  }

  void _onRefresh() async{
    myPost.clear();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    for ( int i = 1; i <= page; i++) {
      getPosts(page.toString());
    }
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    page++;
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    getPosts(page.toString());
    if(mounted)
      setState(() {});
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
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
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
            : ListView(children: <Widget>[
          posts(),
        ]),

      ),
      drawer: MyDrawer(),
    );
  }

  Widget posts() {
    if (myPost.length == 0)
      return Center(
        heightFactor: 4,
        child: Text(
            "هیچ آگهی ای را نشان نکرده اید",
          style: TextStyle( color: Colors.red, fontSize: 20, fontFamily: widget.myFont),
        ),
      );
    List<Widget> list = [];
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

  getPosts(String p) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    var response;
    var url = Uri.parse(AppUrl.Get_BookMarks + "?page=" + p);
    var token = sharedPreferences.getString("token");

    log(AppUrl.Get_BookMarks + "?page=" + p);
    log(token);

    try {
      response = await http.get(url,headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse["results"]);
        if (jsonResponse != null) {
          setState(() {
            for (var i in jsonResponse["results"]) {
              myPost.add(Post(
                i["markedpost"]["owner"]["id"],
                i["markedpost"]["owner"]["email"],
                i["markedpost"]["owner"]["profile_image"],
                i["markedpost"]["id"],
                i["markedpost"]["title"],
                i["markedpost"]["author"],
                i["markedpost"]["publisher"],
                i["markedpost"]["price"],
                i["markedpost"]["province"],
                i["markedpost"]["city"],
                i["markedpost"]["zone"],
                i["markedpost"]["status"],
                i["markedpost"]["description"],
                i["markedpost"]["is_active"],
                i["markedpost"]["image"],
                //url
                i["markedpost"]["categories"],
                i["markedpost"]["created_at"],
              ));
            }
          });
        }
      } else {
        log('!200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          if(jsonResponse["detail"] == "Invalid page.")
            page--;
        });
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
