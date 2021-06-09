import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Utilities.dart';
class ChatPage extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;
  final int threadID;

  ChatPage(this.threadID);

  @override
  _ChatPageState createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  bool _isLoading = false;

  void initState() {
  }
  @override
  Widget build(BuildContext context) {
  }
  getMessages(int threadID) async {
    setState(() {
      _isLoading = false;
    });
  }
}
