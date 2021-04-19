import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:application/util/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/main.dart';
import 'package:application/pages/login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _wrongInfo = false;

  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordReController =
      new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            ? Center(child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ))
            : ListView(
                children: <Widget>[
                  headerSection(),
                  errorSection(),
                  signupForm(),
                  buttonSection1(),
                ],
              ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Center(
          child: Text("ثبت نام",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold))),
    );
  }

  Form signupForm() {
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
            controller: firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الزامی است';
              }
              return null;
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.account_box_rounded, color: Colors.black),
              labelText: "نام",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الزامی است';
              }
              return null;
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.account_box_rounded, color: Colors.black),
              labelText: "نام خانوادگی",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30.0),
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
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordReController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الزامی است';
              } else if (value != passwordController.text) {
                return 'تکرار گذرواژه غلط می باشد';
              }
              return null;
            },
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.black),
              labelText: "تکرار گذرواژه",
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
            signUp(emailController.text, passwordController.text,
                firstNameController.text, lastNameController.text);
          }
        },
        child: Text("ثبت نام", style: TextStyle(color: Colors.black)),
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
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
        },
        child: Text("ورود", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Container errorSection() {
    if (_wrongInfo)
      return Container(
        child: Text(
          "اطلاعات وارد شده غلط می باشند.",
          style: TextStyle(color: Colors.red),
        ),
      );
    return Container();
  }

  signUp(String email, pass, firstName, lastName) async {
    log('SignUp btn pressed');

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'username': email,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': pass
    };

    var jsonResponse = null;
    var response;

    try {
      log(' url : ' + AppUrl.register);
      var url = Uri.parse(AppUrl.register);
      response = await http.post(url, body: data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        log('200');
        //print(response.body);
        jsonResponse = json.decode(response.body);
        //print(jsonResponse);

        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
            _wrongInfo = false;
          });
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setInt("id", jsonResponse['user']['id']);

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
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
