import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/alertDialog_widget.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/ProfileUtils.dart';
import 'package:application/pages/login.dart';

class ProfilePage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final Color mainColor = Colors.blueAccent;
  final String myFont = 'myFont';

  bool _isLoading = false;
  bool _wrongPass = false;
  bool _successful = false;
  bool _updatePass = false;
  bool phoneError = false;
  bool emailError = false;
  bool _noImage = true;
  File _image;
  var items = [
    'دانشجو',
  ];

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    log('Profile Init');
    getProfile();
    setState(() {
      MyAppBar.appBarTitle = Text("BookTrader", style: TextStyle(color: Colors.white, fontFamily: widget.myFont));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
  }

  getProfile() async {
    setState(() {
      widget._isLoading = true;
      widget.phoneError = false;
      widget.emailError = false;
    });

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
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            ProfileControllers.firstNameController.text = jsonResponse['first_name'];
            ProfileControllers.lastNameController.text = jsonResponse['last_name'];
            ProfileControllers.emailController.text = jsonResponse['email'];
            if (jsonResponse['phone_number'] != null)
              ProfileControllers.phoneController.text = jsonResponse['phone_number'].toString();
            if (jsonResponse['university'] != "null")
              ProfileControllers.universityController.text = jsonResponse['university'];
            if (jsonResponse['field_of_study'] != "null")
              ProfileControllers.fieldOfStudyController.text = jsonResponse['field_of_study'];
            if (jsonResponse['entry_year'] != null)
              ProfileControllers.entryYearController.text = jsonResponse['entry_year'].toString();
            if (jsonResponse['profile_image'] != null) {
              ProfileControllers.imageController.text = jsonResponse['profile_image'].toString();
              widget._noImage = false;
              log(ProfileControllers.imageController.text);
            } else {
              widget._noImage = true;
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

    setState(() {
      widget._isLoading = false;
    });
  }

  updateProfile(String first, last, email, phone, uni, field, year) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (phone.length == 0) phone = null;
    if (uni.length == 0) uni = null;
    if (field.length == 0) field = null;
    if (year.length == 0) year = null;

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Update_Profile + id);

    var headers = {'Authorization': 'Token $token'};
    var request = http.MultipartRequest('PUT', url);
    try {
      request.files.add(await http.MultipartFile.fromPath('profile_image', widget._image.path));
      request.headers.addAll(headers);

      http.StreamedResponse response1 = await request.send();

      if (response1.statusCode == 200) {
        print(await response1.stream.bytesToString());
      } else {
        print(response1.reasonPhrase);
      }
    } catch (e) {}
    var response;
    headers = {'Authorization': 'Token $token', 'Content-Type': 'application/json'};

    String data =
        '{\r\n    "username": "$email",\r\n    "email": "$email",\r\n    "first_name": "$first",\r\n    "last_name": "$last",\r\n    "phone_number": $phone,\r\n    "university": "$uni",\r\n    "field_of_study": "$field", \r\n    "entry_year": $year \r\n}';
    var jsonResponse;

    log("Token $token");
    log(data.toString());
    log(AppUrl.Update_Profile + id);

    try {
      response = await http.put(url, body: data, headers: headers);
      if (response.statusCode == 200) {
        print(response.statusCode);
        setState(() {
          widget._isLoading = false;
          widget._successful = true;
        });
      } else {
        jsonResponse = await json.decode(response.body);
        print(response.statusCode);
        print(jsonResponse);
        if (jsonResponse['phone_number'].toString() == '[user with this phone number already exists.]') {
          setState(() {
            widget.phoneError = true;
          });
        }
        if (jsonResponse['email'].toString() == '[user with this email already exists.]') {
          setState(() {
            widget.emailError = true;
          });
        }
        setState(() {
          widget._isLoading = false;
          widget._successful = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        widget._isLoading = false;
      });
    }
  }

  updatePassword(String oldPass, newPass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse(AppUrl.Delete_Profile + id + '/change-password');

    var headers = {'Authorization': 'Token $token', 'Content-Type': 'application/json'};
    var request = http.Request('PUT', url);
    request.body = '''{\r\n    "old_password": "$oldPass",\r\n    "new_password": "$newPass"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      sharedPreferences.clear();
      sharedPreferences.commit();
      setState(() {
        widget._updatePass = true;
        widget._wrongPass = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    } else {
      print(response.reasonPhrase);
      setState(() {
        widget._wrongPass = true;
        widget._updatePass = false;
      });
    }
    setState(() {
      widget._isLoading = false;
    });
  }

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
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    } else {
      print(response.reasonPhrase);
    }
  }

  Scaffold profile() {
    return Scaffold(
      body: Container(
        child: widget._isLoading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(widget.mainColor),
              ))
            : ListView(
                children: <Widget>[
                  headerSection(),
                  profilePicture(),
                  infoForm(),
                  changePassModalBtn(),
                  deleteForm(),
                ],
              ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Center(
          child: Text("پروفایل من",
              style: TextStyle(
                  color: widget.mainColor, fontSize: 20.0, fontFamily: widget.myFont, fontWeight: FontWeight.bold))),
    );
  }

  Container profilePicture() {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      margin: EdgeInsets.only(top: 0.0, bottom: 20),
      child: Center(
        child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Container(
                child: widget._image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(500.0),
                        child: Image.file(
                          widget._image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : widget._noImage
                        ? Container(
                            decoration:
                                BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(500)),
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
                              'http://37.152.176.11' + ProfileControllers.imageController.text,
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
    File image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      widget._image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      widget._image = image;
    });
  }

  Form infoForm() {
    return Form(
      key: widget._formKey,
      child: Column(
        children: <Widget>[
          successSection(),
          profileSection(),
          submit(),
        ],
      ),
    );
  }

  Form passForm() {
    return Form(
      key: widget._formKey2,
      child: Column(
        children: <Widget>[
          passHeader(),
          updatePasswordSuccess(),
          changePass(),
          submit2(),
        ],
      ),
    );
  }

  Container successSection() {
    if (widget._successful)
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          "موفقیت آمیز",
          style: TextStyle(color: Colors.green, fontFamily: widget.myFont),
        ),
      );
    return Container();
  }

  Container profileSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: ProfileControllers.firstNameController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_box_rounded, color: widget.mainColor),
                    labelText: "نام",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                    hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Flexible(
                child: TextFormField(
                  controller: ProfileControllers.lastNameController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  decoration: InputDecoration(
                    labelText: "نام خانوادگی",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                    hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: ProfileControllers.emailController,
            validator: ProfileValidators.validateEmail,
            onChanged: (content) {
              setState(() {
                widget.emailError = false;
              });
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: widget.mainColor),
              labelText: "ایمیل",
              errorText: ProfileValidators.errorEmail(widget.emailError),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: ProfileControllers.phoneController,
            cursorColor: Colors.black,
            validator: ProfileValidators.validatePhone,
            onChanged: (content) {
              setState(() {
                widget.phoneError = false;
              });
            },
            style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              icon: Icon(Icons.phone, color: widget.mainColor),
              labelText: "تلفن همراه",
              errorText: ProfileValidators.errorPhone(widget.phoneError),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
            ),
          ),
          SizedBox(height: 10),
          // TextFormField(
          //   controller: ProfileControllers.controller,
          //   cursorColor: Colors.black,
          //   style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
          //   decoration: InputDecoration(
          //     suffixIcon: PopupMenuButton<String>(
          //       icon: const Icon(Icons.arrow_drop_down),
          //       onSelected: (String value) {
          //         ProfileControllers.controller.text = value;
          //       },
          //       itemBuilder: (BuildContext context) {
          //         return widget.items.map<PopupMenuItem<String>>((String value) {
          //           return new PopupMenuItem(
          //               child: new Text(value), value: value);
          //         }).toList();
          //       },
          //     ),
          //     icon: Icon(Icons.accessibility_new_sharp, color: widget.mainColor),
          //     labelText: "وضعیت",
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
          //     hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
          //   ),
          // ),
          // SizedBox(height: 10),
          TextFormField(
            controller: ProfileControllers.universityController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
            decoration: InputDecoration(
              icon: Icon(Icons.school, color: widget.mainColor),
              labelText: "دانشگاه",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
              hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: ProfileControllers.fieldOfStudyController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  decoration: InputDecoration(
                    icon: Icon(Icons.school, color: widget.mainColor),
                    labelText: "رشته تحصیلی",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                    hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  ),
                ),
              ),
              SizedBox(width: 5.0),
              Flexible(
                child: TextFormField(
                  controller: ProfileControllers.entryYearController,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range, color: widget.mainColor),
                    labelText: "سال ورود",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                    hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container submit() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 110.0),
      margin: EdgeInsets.only(top: 10.0),
      child: RaisedButton(
        onPressed: () {
          if (!widget._formKey.currentState.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
          } else {
            setState(() {
              widget._isLoading = true;
            });
            updateProfile(
              ProfileControllers.firstNameController.text,
              ProfileControllers.lastNameController.text,
              ProfileControllers.emailController.text,
              ProfileControllers.phoneController.text,
              ProfileControllers.universityController.text,
              ProfileControllers.fieldOfStudyController.text,
              ProfileControllers.entryYearController.text,
            );
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
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
              "ثبت تغییرات",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: widget.myFont),
            ),
          ),
        ),
      ),
    );
  }

  Container changePassModalBtn() {
    return Container(
        child: IconButton(
            icon: Icon(Icons.security, color: widget.mainColor),
            onPressed: () {
              ProfileControllers.passwordController.clear();
              ProfileControllers.oldPasswordController.clear();
              ProfileControllers.passwordReController.clear();
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => passForm(),
              );
            }));
  }

  Container passHeader() {
    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 30),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0),
      child: Center(
          child: Text("تغییر گذرواژه :",
              style: TextStyle(
                  color: widget.mainColor, fontSize: 20.0, fontFamily: widget.myFont, fontWeight: FontWeight.bold))),
    );
  }

  Container changePass() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: ProfileControllers.oldPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              obscureText: true,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: widget.mainColor),
                labelText: "گذرواژه",
                errorText: widget._wrongPass ? 'رمز وارد شده غلط می باشد' : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: ProfileControllers.passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              obscureText: true,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: widget.mainColor),
                labelText: "گذرواژه ی جدید",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: ProfileControllers.passwordReController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                } else if (value != ProfileControllers.passwordController.text) {
                  return 'تکرار گذرواژه غلط می باشد';
                }
                return null;
              },
              cursorColor: Colors.black,
              obscureText: true,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: widget.mainColor),
                labelText: "تکرار گذرواژه ی جدید",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                hintStyle: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
          ],
        ));
  }

  Container submit2() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 110.0),
      margin: EdgeInsets.only(top: 30.0),
      child: RaisedButton(
        onPressed: () {
          if (!widget._formKey2.currentState.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
          } else {
            setState(() {
              widget._isLoading = true;
            });
            updatePassword(
              ProfileControllers.oldPasswordController.text,
              ProfileControllers.passwordController.text,
            );
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
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
              "تغییر گذرواژه",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: widget.myFont),
            ),
          ),
        ),
      ),
    );
  }

  Container updatePasswordSuccess() {
    if (widget._updatePass)
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          "موفقیت آمیز",
          style: TextStyle(color: Colors.green, fontFamily: widget.myFont),
        ),
      );
    return Container();
  }

  Form deleteForm() {
    return Form(
      child: Column(
        children: <Widget>[SizedBox(height: 150), deleteBtn()],
      ),
    );
  }

  Container deleteBtn() {
    return Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 25.0, bottom: 10),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            _showDialog(context);
          },
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.yellow],
                  begin: Alignment.center,
                  // end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "پاک کردن اکانت",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: widget.myFont),
              ),
            ),
          ),
        ));
  }

  _showDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {Navigator.of(context).pop(), deleteProfile()};
    BlurryDialog alert = BlurryDialog("خیر", "آیا مطمین هستید؟ امکان بازگشت وجود ندارد", continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
