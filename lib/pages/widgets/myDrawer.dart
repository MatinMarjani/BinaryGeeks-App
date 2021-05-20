import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:application/pages/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:application/pages/login.dart';
import 'package:application/pages/newpost.dart';
import 'package:application/pages/BookMark.dart';
import 'package:application/main.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/User.dart';
import 'package:application/util/Utilities.dart';

class MyDrawer extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController imageController = new TextEditingController();

  SharedPreferences sharedPreferences;

  var token;

  bool _noImage = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          !_noImage
              ? UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: widget.mainColor,
                  ),
                  accountName: Text(
                    firstNameController.text + " " + lastNameController.text ,
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  accountEmail: Text(
                    emailController.text ?? " ",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage('http://37.152.176.11' + imageController.text),
                  ))
              : UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: widget.mainColor,
                  ),
                  accountName: Text(
                    firstNameController.text ?? " " + " " + lastNameController.text ?? " ",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  accountEmail: Text(
                    emailController.text ?? " ",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  currentAccountPicture:
                      CircleAvatar(backgroundColor: Colors.white, child: Text(firstNameController.text[0]))),
          ListTile(
            title: Text(
              "داشبورد",
              style: TextStyle(fontFamily: 'myfont'),
            ),
            leading: Icon(Icons.home_outlined, color: widget.mainColor),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => MainPage()));
            },
          ),
          ListTile(
            title: Text(
              "پروفایل",
              style: TextStyle(fontFamily: 'myfont'),
            ),
            leading: Icon(Icons.account_circle_outlined, color: widget.mainColor),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            title: Text(
              "آگهی جدید",
              style: TextStyle(fontFamily: 'myfont'),
            ),
            leading: Icon(Icons.create_new_folder_outlined, color: widget.mainColor),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => NewPostPage()));
            },
          ),
          ListTile(
            title: Text(
              "نشان ها",
              style: TextStyle(fontFamily: 'myfont'),
            ),
            leading: Icon(Icons.bookmark_border_outlined, color: widget.mainColor),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => BookMarks()));
            },
          ),
          ListTile(
            title: Text(
              "خروج",
              style: TextStyle(fontFamily: 'myfont'),
            ),
            leading: Icon(Icons.login_outlined, color: widget.mainColor),
            onLongPress: () {
              logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    setState(() {
      firstNameController.text = User.firstName;
      lastNameController.text = User.lastName;
      emailController.text = User.email;
      imageController.text = User.profileImage;
    });
    getProfile();
  }

  getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    var response;

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Get_Profile + id);

    try {
      response = await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        print(response.body);
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse != null) {
          setState(() {
            User.firstName = jsonResponse['first_name'];
            User.lastName = jsonResponse['last_name'];
            User.email = jsonResponse['email'];
            if (jsonResponse['profile_image'] != null) {
              User.profileImage = jsonResponse['profile_image'].toString();
              _noImage = false;
            } else {
              _noImage = true;
            }
          });
        }
      } else {
        log('!200');
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  logout() async {
    var response;
    var url = Uri.parse(AppUrl.logout);
    var token = sharedPreferences.getString("token");
    try {
      sharedPreferences.clear();
      response = await http.get(url, headers: {'Authorization': 'Token $token'});
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
