import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/main.dart';
import 'package:application/pages/login.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/SignUpUtils.dart';

class SignUpPage extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordReController =
  new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _wrongEmail = false;
  bool _wrongInfo = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 00, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(widget.mainColor),
                ))
              : Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      headerSection(),
                      signUpForm(),
                      buttonSection1(),
                    ],
                  ),
                )),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      padding: EdgeInsetsDirectional.only(bottom: 40, top: 00),
      child: Center(
          child: Text("ساخت اکانت جدید",
              style: TextStyle(
                  color: widget.mainColor,
                  fontSize: 25.0,
                  fontFamily: 'myfont',
                  fontWeight: FontWeight.bold))),
    );
  }

  Form signUpForm() {
    return Form(
      key: widget._formKey,
      child: Column(
        children: <Widget>[
          errorSection(),
          textSection(),
          submit(),
        ],
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.firstNameController,
            validator: FirstNameFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myfont',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_box_rounded, color: widget.mainColor),
              labelText: "نام",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'myfont',
              ),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: widget.lastNameController,
            validator: LastNameFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myfont',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_box_rounded, color: widget.mainColor),
              labelText: "نام خانوادگی",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'myfont',
              ),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: widget.emailController,
            validator: EmailFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myfont',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: widget.mainColor),
              labelText: "ایمیل",
              errorText: _wrongEmail ? 'ایمیل تکراری است' : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'myfont',
              ),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: widget.passwordController,
            validator: PasswordFieldValidator.validate,
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myfont',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: widget.mainColor),
              labelText: "گذرواژه",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'myfont',
              ),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: widget.passwordReController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الزامی است';
              } else if (value != widget.passwordController.text) {
                return 'تکرار گذرواژه غلط می باشد';
              }
              return null;
            },
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myfont',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: widget.mainColor),
              labelText: "تکرار گذرواژه",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'myfont',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container submit() {
    return Container(
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 110.0),
      margin: EdgeInsets.only(top: 10.0),
      child: TextButton(
        onPressed: () {
          if (!widget._formKey.currentState.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          } else {
            setState(() {
              _isLoading = true;
            });
            signUp(widget.emailController.text, widget.passwordController.text,
                widget.firstNameController.text, widget.lastNameController.text);
          }
        },
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "ثبت نام",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'myfont',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buttonSection1() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: 30.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(top: 12.0),
      child: Center(
          child: RichText(
        text: TextSpan(
          text: 'قبلا اکانت ساخته اید؟ ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontFamily: 'myfont',
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'وارد شوید ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'myfont',
                )),
          ],
        ),
      )),
    );
  }

  Container errorSection() {
    if (_wrongInfo)
      return Container(
          alignment: Alignment.centerRight,
          child: Text(
            "* There was a problem",
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'myfont',
            ),
          ));
    return Container();
  }

  signUp(String email, pass, firstName, lastName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'username': email,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': pass
    };
    var jsonResponse;
    var response;

    try {
      log(' url : ' + AppUrl.register);
      var url = Uri.parse(AppUrl.register);
      response = await http.post(url, body: data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          setState(() {
            _wrongEmail = false;
            _wrongInfo = false;
          });
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setInt("id", jsonResponse['user']['id']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
        }
      } else {
        log('!200');
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['email'].toString() ==
            '[user with this email already exists.]') {
          setState(() {
            _wrongEmail = true;
          });
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
