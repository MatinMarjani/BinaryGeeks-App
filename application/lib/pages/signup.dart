import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:application/util/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/main.dart';
import 'package:application/pages/login.dart';

class FirstNameFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty)
      return 'الزامی است';
    return null;
  }
}

class LastNameFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty)
      return 'الزامی است';
    return null;
  }
}

class EmailFieldValidator {
  static String validate(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);

    if (value == null || value.isEmpty)
      return 'الزامی است';
    if (!regExp.hasMatch(value))
      return 'ایمیل را درست وارد کنید';
    return null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty)
      return 'الزامی است';
    return null;
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _wrongEmail = false;
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
        margin: EdgeInsets.symmetric(vertical: 00, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ))
            : Center( child : ListView(
          children: <Widget>[
            headerSection(),
            signupForm(),
            buttonSection1(),
          ],
        ),
        )
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      // padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      padding: EdgeInsetsDirectional.only(bottom: 40,top: 80),
      child: Center(
          child: Text("ساخت اکانت جدید",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold))),
    );
  }

  Form signupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          errorSection(),
          textSection(),
          Submit(),
        ],
      ),
    );
  }

  Container textSection() {
    return Container(
      //color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: firstNameController,
            validator: FirstNameFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.account_box_rounded, color: Colors.blueAccent),
              labelText: "نام",
              border: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: lastNameController,
            validator: LastNameFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.account_box_rounded, color: Colors.blueAccent),
              labelText: "نام خانوادگی",
              border: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.black)),
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: emailController,
            validator: EmailFieldValidator.validate,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.blueAccent),
              labelText: "ایمیل",
              errorText: _wrongEmail ? 'ایمیل تکراری است' : null,
              border: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.black)),
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: passwordController,
            validator: PasswordFieldValidator.validate,
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.blueAccent),
              labelText: "گذرواژه",
              border: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.black)),
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0),
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
              icon: Icon(Icons.lock, color: Colors.blueAccent),
              labelText: "تکرار گذرواژه",
              border: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.black)),
                  borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Container Submit() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 110.0),
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
            signUp(emailController.text, passwordController.text,
                firstNameController.text, lastNameController.text);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "ثبت نام",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
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
          child :
          RichText(
            text: TextSpan(
              text: 'قبلا اکانت ساخته اید؟ ',
              style: TextStyle(fontSize: 15, color: Colors.black),
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
                    )),
              ],
            ),
          )
      ),
    );
  }

  Container errorSection() {
    if (_wrongInfo)
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          "* There was a problem",
          style: TextStyle(color: Colors.red),
        )
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
        print(jsonResponse);

        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
            _wrongEmail = false;
            _wrongInfo = false;
          });
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setInt("id", jsonResponse['user']['id']);

          log(' token : ' + sharedPreferences.getString("token"));
          log(' id : ' + sharedPreferences.getInt("id").toString());

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
        }else {
          setState(() {
            _wrongInfo = true;
          });
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
