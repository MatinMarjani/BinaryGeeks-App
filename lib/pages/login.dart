import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/util/app_url.dart';
import 'package:application/main.dart';
import 'package:application/pages/signup.dart';

class EmailFieldValidator {
  static String validate(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);

    if (value == null || value.isEmpty) return 'الزامی است';
    if (!regExp.hasMatch(value)) return 'ایمیل را درست وارد کنید';
    return null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty) return 'الزامی است';
    return null;
  }
}

class LoginPage extends StatefulWidget {
  final Color mainColor = Colors.blue[800];
  final String myFont = 'myFont';

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
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                    errorSection(),
                    loginForm(),
                    buttonSection1(),
                  ],
                ),
              ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      padding: EdgeInsetsDirectional.only(bottom: 40, top: 00),
      child: Center(
          child: Text("ورود",
              style: TextStyle(
                  color: widget.mainColor,
                  fontSize: 25.0,
                  fontFamily: 'myfont',
                  fontWeight: FontWeight.bold))),
    );
  }

  Form loginForm() {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            textSection(),
            Submit(),
          ],
        ),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            validator: EmailFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black, fontFamily: 'myfont'),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: widget.mainColor),
              labelText: "ایمیل",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black, fontFamily: 'myfont'),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: passwordController,
            validator: PasswordFieldValidator.validate,
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(color: Colors.black, fontFamily: 'myfont'),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: widget.mainColor),
              labelText: "گذرواژه",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black, fontFamily: 'myfont'),
            ),
          ),
        ],
      ),
    );
  }

  Container Submit() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 120.0),
      margin: EdgeInsets.only(top: 10.0),
      child: RaisedButton(
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
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
              "ورود",
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
          text: 'اکانت ندارید؟ ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontFamily: 'myfont',
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'ثبت نام',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => SignUpPage()),
                        (Route<dynamic> route) => false);
                  },
                style: TextStyle(
                  color: widget.mainColor,
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
        child: Text(
          "* ایمیل یا رمز وارد شده غلط می باشد",
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
      log(data.toString());
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
