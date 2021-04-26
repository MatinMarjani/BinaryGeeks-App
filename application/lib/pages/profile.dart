import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/alertDialog_widget.dart';

import 'package:application/util/app_url.dart';
import 'package:application/pages/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _wrongInfo = false;
  bool _wrongPass = false;
  bool _successful = false;
  bool _updatePass = false;

  bool phoneError = false;
  bool emailError = false;
  bool _noImage = true;

  File _image;

  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController universityController =
      new TextEditingController();
  final TextEditingController fieldOfStudyController =
      new TextEditingController();
  final TextEditingController entryYearController = new TextEditingController();

  final TextEditingController oldPasswordController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordReController =
      new TextEditingController();
  final TextEditingController imageController = new TextEditingController();

  final TextEditingController _controller = new TextEditingController();

  var items = [
    'دانشجو',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: profile(),
      drawer: MyDrawer(),
    );
  }

  @override
  void initState() {
    super.initState();
    log('Profile Init');
    getProfile();
  }

  getProfile() async {
    setState(() {
      _isLoading = true;
      phoneError = false;
      emailError = false;
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

  Scaffold profile() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
            : ListView(
                children: <Widget>[
                  headerSection(),
                  profilePicture(),
                  infoForm(),
                  passForm(),
                  DeleteForm(),
                ],
              ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Center(
          child: Text("پروفایل من",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold))),
    );
  }

  Container profilePicture() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      margin: EdgeInsets.only(top: 0.0),
      child: Center(
        child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Container(
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(500.0),
                        child: Image.file(
                          _image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : _noImage
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(500)),
                            width: 200,
                            height: 200,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(500.0),
                            child: Image.network(
                              'http://37.152.176.11' + imageController.text,
                              width: 200,
                              height: 200,
                              fit: BoxFit.fitHeight,
                            ),
                          ))),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('گالری'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('دوربین'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  Form infoForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          errorSection(),
          successSection(),
          profileSection(),
          Submit(),
        ],
      ),
    );
  }

  Form passForm() {
    return Form(
      key: _formKey2,
      child: Column(
        children: <Widget>[
          passHeader(),
          updatePassword_errorSection(),
          updatePassword_success(),
          changePass(),
          Submit2(),
        ],
      ),
    );
  }

  Container errorSection() {
    if (_wrongInfo)
      return Container(
        child: Column(children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: emailError
                ? Text(
                    "* ایمیل تکراری است",
                    style: TextStyle(color: Colors.red),
                  )
                : null,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: phoneError
                ? Text(
                    "* شماره موبایل تکراری است",
                    style: TextStyle(color: Colors.red),
                  )
                : null,
          ),
        ]),
      );
    return Container();
  }

  Container successSection() {
    if (_successful)
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          "موفقیت آمیز",
          style: TextStyle(color: Colors.green),
        ),
      );
    return Container();
  }

  Container profileSection() {
    return Container(
      //color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: firstNameController,
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
              ),
              SizedBox(width: 5.0),
              Flexible(
                child: TextFormField(
                  controller: lastNameController,
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
              ),
            ],
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: emailController,
            validator: ProfileEmailFieldValidator.validate,
            onChanged: (content) {
              setState(() {
                emailError = false;
              });
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
          SizedBox(height: 30),
          TextFormField(
            controller: phoneController,
            cursorColor: Colors.black,
            validator: ProfilePhoneFieldValidator.validate,
            onChanged: (content) {
              setState(() {
                phoneError = false;
              });
            },
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              icon: Icon(Icons.phone, color: Colors.black),
              labelText: "تلفن همراه",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _controller,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (String value) {
                  _controller.text = value;
                },
                itemBuilder: (BuildContext context) {
                  return items.map<PopupMenuItem<String>>((String value) {
                    return new PopupMenuItem(
                        child: new Text(value), value: value);
                  }).toList();
                },
              ),
              icon: Icon(Icons.accessibility_new_sharp, color: Colors.black),
              labelText: "وضعیت",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: universityController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.school, color: Colors.black),
              labelText: "دانشگاه",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: fieldOfStudyController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(Icons.school, color: Colors.black),
                    labelText: "رشته تحصیلی",
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Flexible(
                child: TextFormField(
                  controller: entryYearController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range, color: Colors.black),
                    labelText: "سال ورود",
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
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
            updateProfile(
              firstNameController.text,
              lastNameController.text,
              emailController.text,
              phoneController.text,
              universityController.text,
              fieldOfStudyController.text,
              entryYearController.text,
            );
          }
        },
        child: Text("ثبت تغییرات", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  updateProfile(String first, last, email, phone, uni, field, year) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (phone.length == 0) phone = null;
    if (uni.length == 0) uni = null;
    if (field.length == 0) field = null;
    if (year.length == 0) year = null;

    setState(() {
      _isLoading = true;
    });

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Update_Profile + id);

    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.MultipartRequest('PUT', url);
    try {
      request.files.add(
          await http.MultipartFile.fromPath('profile_image', _image.path));
      request.headers.addAll(headers);

      http.StreamedResponse response1 = await request.send();

      if (response1.statusCode == 200) {
        print(await response1.stream.bytesToString());
      }
      else {
        print(response1.reasonPhrase);
      }
    } catch(e){

    }
    var response;
    headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    };

    String data =
        '{\r\n    "username": "$email",\r\n    "email": "$email",\r\n    "first_name": "$first",\r\n    "last_name": "$last",\r\n    "phone_number": $phone,\r\n    "university": "$uni",\r\n    "field_of_study": "$field", \r\n    "entry_year": $year \r\n}';
    var jsonResponse = null;

    log("Token $token");
    log(data.toString());
    log(AppUrl.Update_Profile + id);

    try {
      response = await http.put(url, body: data, headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        setState(() {
          _isLoading = false;
          _wrongInfo = false;
          _successful = true;
        });
      } else {
        jsonResponse = await json.decode(response.body);
        print(response.statusCode);
        print(jsonResponse);
        if (jsonResponse['phone_number'].toString() ==
            '[user with this phone number already exists.]') {
          setState(() {
            phoneError = true;
          });
        }
        if (jsonResponse['email'].toString() ==
            '[user with this email already exists.]') {
          setState(() {
            emailError = true;
          });
        }
        setState(() {
          _isLoading = false;
          _wrongInfo = true;
          _successful = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Container passHeader() {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0),
      child: Center(
          child: Text("تغییر گذرواژه",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold))),
    );
  }

  Container changePass() {
    return Container(
        child: Column(
      children: <Widget>[
        TextFormField(
          controller: oldPasswordController,
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
            labelText: "گذرواژه ی جدید",
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
            labelText: "تکرار گذرواژه ی جدید",
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
      ],
    ));
  }

  Container Submit2() {
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
          if (!_formKey2.currentState.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          } else {
            setState(() {
              _isLoading = true;
            });
            updatePassword(
              oldPasswordController.text,
              passwordController.text,
            );
          }
        },
        child: Text("تغییر گذرواژه", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  updatePassword(String oldPass, newPass) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Delete_Profile + id + '/change-password');

    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', url);
    request.body =
        '''{\r\n    "old_password": "$oldPass",\r\n    "new_password": "$newPass"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      sharedPreferences.clear();
      sharedPreferences.commit();
      setState(() {
        _updatePass = true;
        _wrongPass = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print(response.reasonPhrase);
      setState(() {
        _wrongPass = true;
        _updatePass = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Container updatePassword_errorSection() {
    if (_wrongPass)
      return Container(
        padding: EdgeInsets.only(right: 15.0, left: 15, top: 20.0),
        child: Text(
          "رمز وارد شده غلط می باشد",
          style: TextStyle(color: Colors.red),
        ),
      );
    return Container();
  }

  Container updatePassword_success() {
    if (_updatePass)
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          "موفقیت آمیز",
          style: TextStyle(color: Colors.green),
        ),
      );
    return Container();
  }

  Form DeleteForm() {
    return Form(
      child: Column(
        children: <Widget>[SizedBox(height: 150), deleteBtn()],
      ),
    );
  }

  Container deleteBtn() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 25.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          onPressed: () {
            _showDialog(context);
          },
          child: Text("پاک کردن اکانت", style: TextStyle(color: Colors.black)),
        ));
  }

  deleteProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Update_Profile + id);

    var headers = {'Authorization': 'Token $token'};
    var request = http.Request('DELETE', url);
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      sharedPreferences.clear();
      sharedPreferences.commit();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print(response.reasonPhrase);
    }
  }

  _showDialog(BuildContext context) {
    VoidCallback continueCallBack =
        () => {Navigator.of(context).pop(), deleteProfile()};
    BlurryDialog alert = BlurryDialog(
        "خیر", "آیا مطمین هستید؟ امکان بازگشت وجود ندارد", continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ProfilePhoneFieldValidator {
  static String validate(String value) {
    String pattern = r'^(?:0|98)9?[0-9]{10}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) return 'شماره موبایل درست را وارد کنید';

    return null;
  }
}

class ProfileEmailFieldValidator {
  static String validate(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) return 'ایمیل را درست وارد کنید';
    return null;
  }
}
