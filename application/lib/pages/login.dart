import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/util/app_url.dart';
import 'package:application/main.dart';
//import 'package:application/pages/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _wrongInfo = false;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        decoration: new BoxDecoration(
          border: Border.all(width: 1, color: Colors.white54),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white54,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  errorSection(),
                  loginForm(),
                  buttonSection1(),
                ],
              ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Center(
          child: Text("ورود",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold))),
    );
  }

  Form loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          textSection(),
          Submit(),
        ],
      ),
    );
  }

  Container textSection() {
    return Container(
      //color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الزامی است';
              }
              return null;
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.black),
              labelText: "ایمیل",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الزامی است';
              }
              return null;
            },
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.black),
              labelText: "گذرواژه",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Container Submit() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 25.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.indigoAccent)),
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          } else {
            setState(() {
              _isLoading = true;
            });
            signIn(emailController.text, passwordController.text);
          }
        },
        child: Text("ورود", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Container buttonSection1() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black38)),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => SignUpPage()),
              (Route<dynamic> route) => false);
        },
        child: Text("ثبت نام", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Container errorSection() {
    if (_wrongInfo)
      return Container(
        child: Text(
          "ایمیل یا رمز وارد شده غلط می باشد",
          style: TextStyle(color: Colors.red),
        ),
      );
    return Container();
  }

  signIn(String email, pass) async {
    log('Login btn pressed');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': email, 'password': pass};
    var jsonResponse = null;
    var response;

    try {
      //log(' url : ' + AppUrl.login);
      var url = Uri.parse(AppUrl.login);
      response = await http.post(url, body: data);
      //print(response.statusCode);
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
            _wrongInfo = false;
          });

          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setInt("id", jsonResponse['id']);

          log(' token : ' + sharedPreferences.getString("token"));
          log(' id : ' + sharedPreferences.getInt("id").toString());

          //Set user Info from response.data to sharedPrefrences

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
        }
      } else {
        log('!200');
        setState(() {
          _isLoading = false;
          _wrongInfo = true;
        });
        print(response.body);
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
