import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myNotifCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';
import 'package:application/util/Utilities.dart';

class NotificationPage extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Widget> myNotifications = [];
  List<Post> myPost = [];
  bool _isLoading = false;
  int page;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    log("Dashboard init");
    setState(() {
      _isLoading = true;
      page = 1;
      MyAppBar.appBarTitle =
          Text("اعلان ها", style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
      myPost.clear();
    });
    getNotifications(page.toString());
  }

  void _onRefresh() async{
    myPost.clear();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    for ( int i = 1; i <= page; i++) {
      getNotifications(page.toString());
    }
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    page++;
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    getNotifications(page.toString());
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
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("بار گذاری شد");
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
          notifications(),
        ]),

      ),
      drawer: MyDrawer(),
    );
  }

  Widget notifications() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: myNotifications);
  }

  getNotifications(String p) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse(AppUrl.Get_Notifications + "?page=" + p);
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
      setState(() {
        if(jsonResponse["detail"] == "Invalid page.")
          page--;
      });
    }

    setState(() {
      _isLoading = false;
    });
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
