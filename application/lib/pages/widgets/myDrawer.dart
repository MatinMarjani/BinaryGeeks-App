import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:application/pages/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:application/util/app_url.dart';
import 'package:application/pages/login.dart';
import 'package:application/pages/newpost.dart';
import 'package:application/main.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController universityController =
      new TextEditingController();
  final TextEditingController fieldOfStudyController =
      new TextEditingController();
  final TextEditingController entryYearController = new TextEditingController();
  final TextEditingController imageController = new TextEditingController();

  SharedPreferences sharedPreferences;

  var token;

  bool _isLoading = false;
  bool _noImage = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ))
          : ListView(
              children: <Widget>[
                !_noImage
                    ? UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        accountName: Text(
                          firstNameController.text ??
                              " " + " " + lastNameController.text ??
                              " ",
                          style: TextStyle(fontFamily: 'myfont'),
                        ),
                        accountEmail: Text(
                          emailController.text ?? " ",
                          style: TextStyle(fontFamily: 'myfont'),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              'http://37.152.176.11' + imageController.text),
                        ))
                    : UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        accountName: Text(
                          firstNameController.text ??
                              " " + " " + lastNameController.text ??
                              " ",
                          style: TextStyle(fontFamily: 'myfont'),
                        ),
                        accountEmail: Text(
                          emailController.text ?? " ",
                          style: TextStyle(fontFamily: 'myfont'),
                        ),
                        currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(firstNameController.text[0]))),
                ListTile(
                  title: Text(
                    "داشبورد",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  leading: Icon(Icons.home, color: Colors.blueAccent),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => MainPage()));
                  },
                ),
                ListTile(
                  title: Text(
                    "پروفایل",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  leading:
                      Icon(Icons.account_box_rounded, color: Colors.blueAccent),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ProfilePage()));
                  },
                ),
                ListTile(
                  title: Text(
                    "آگهی جدید",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  leading: Icon(Icons.create_new_folder_rounded,
                      color: Colors.blueAccent),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => NewPostPage()));
                  },
                ),
                ListTile(
                  title: Text(
                    "خروج",
                    style: TextStyle(fontFamily: 'myfont'),
                  ),
                  leading: Icon(Icons.logout, color: Colors.blueAccent),
                  onLongPress: () {
                    logout();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
    );
  }

  void initState() {
    super.initState();
    firstNameController.text = " ";
    lastNameController.text = " ";
    emailController.text = " ";
    getProfile();
  }

  getProfile() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    var response;

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Get_Profile + id);

    try {
      log(' url : ' + AppUrl.Get_Profile + id);
      log(token);
      response =
          await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        print(response.body);
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            //_isLoading = false;
            firstNameController.text = jsonResponse['first_name'];
            lastNameController.text = jsonResponse['last_name'];
            emailController.text = jsonResponse['email'];
            if (jsonResponse['phone_number'] != null)
              phoneController.text = jsonResponse['phone_number'].toString();
            if (jsonResponse['university'] != "null")
              universityController.text = jsonResponse['university'];
            if (jsonResponse['field_of_study'] != "null")
              fieldOfStudyController.text = jsonResponse['field_of_study'];
            if (jsonResponse['entry_year'] != null)
              entryYearController.text = jsonResponse['entry_year'].toString();
            if (jsonResponse['profile_image'] != null) {
              imageController.text = jsonResponse['profile_image'].toString();
              _noImage = false;
              log(imageController.text);
            } else {
              _noImage = true;
            }
          });
          //Set user Info from response.data to sharedPrefrences
        }
      } else {
        log('!200');
        print(response.body);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  logout() async {
    var response;
    var url = Uri.parse(AppUrl.logout);
    var token = sharedPreferences.getString("token");
    try {
      sharedPreferences.clear();
      sharedPreferences.commit();
      response =
          await http.get(url, headers: {'Authorization': 'Token $token'});
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
