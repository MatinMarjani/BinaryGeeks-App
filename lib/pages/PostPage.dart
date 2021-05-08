import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';


import 'package:application/pages/widgets/myPostCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage(this.post);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final Color mainColor = Colors.blue[800];
  final String myFont = 'myFont';

  final TextEditingController author = new TextEditingController();
  final TextEditingController publisher = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final TextEditingController province = new TextEditingController();
  final TextEditingController city = new TextEditingController();
  final TextEditingController zone = new TextEditingController();
  final TextEditingController description = new TextEditingController();

  bool _isLoading = false;
  bool _noImage = false;
  bool _isOwner = false;
  var formatter = new NumberFormat('###,###');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      MyAppBar.appBarTitle = Text("BookTrader",
          style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    checkOwner();
  }

  checkOwner() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int ownerID = sharedPreferences.getInt("id");
    if (widget.post.owner_id == ownerID){
      setState(() {
        MyAppBar.actionIcon = Icon(Icons.edit, color: Colors.white);
        _isOwner = true;
      });
    }
    else {
      setState(() {
        _isOwner = false;
      });
    }
    log(_isOwner.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ))
            : ListView(
            shrinkWrap: true,
            children: <Widget>[
              _BannerImage(),
              _Header(),
              _MainBody(),
            ],
          ),
      ),
      drawer: MyDrawer(),
    );
  }

  Container _Header() {
    String date = "";
    String time2 = "";
    String time = "";
    try {
      date = widget.post.created_at.split('T')[0] ?? "";
      time2 = widget.post.created_at.split('T')[1] ?? "";
      time = time2.split(".")[0] ?? "";
    } catch (e) {}
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  time,
                  style: TextStyle(fontSize: 12.0, fontFamily: 'myfont'),
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 12.0, fontFamily: 'myfont'),
              ),
            ],
          ),
          SizedBox(height: 10),
          _isOwner ? Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                    widget.post.title,
                    style: TextStyle(fontSize: 30.0, fontFamily: 'myfont'),
                  ),),
              SizedBox(width: 10,),
              Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: mainColor))),
                    ),
                    child: Icon(Icons.edit, color: mainColor,),
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => updatePostForm(),
                      );
                    },
                  ),),
            ],
          )
          : Text(
            widget.post.title,
            style: TextStyle(fontSize: 30.0, fontFamily: 'myfont'),
          ),
          Text(
            widget.post.author,
            style: TextStyle(fontSize: 20.0, fontFamily: 'myfont'),
          ),
          SizedBox(height: 10),
          Text(
            widget.post.publisher,
            style: TextStyle(fontSize: 15.0, fontFamily: 'myfont'),
          ),
        ],
      ),
    );
  }

  Container _BannerImage() {
    if (widget.post.image == null) _noImage = true;
    return Container(
      height: 300.0,
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      margin: EdgeInsets.only(top: 0.0, bottom: 20),
      child: _noImage
          ? Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.no_photography,
                color: Colors.black,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.post.image,
                loadingBuilder: (context, child, progress) {
                  return progress == null ? child : LinearProgressIndicator();
                },
                width: 300,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
            ),
    );
  }

  Container _MainBody() {
    final TextEditingController price = new TextEditingController();
    final TextEditingController priceH = new TextEditingController();
    final TextEditingController province = new TextEditingController();
    final TextEditingController provinceH = new TextEditingController();
    final TextEditingController city = new TextEditingController();
    final TextEditingController cityH = new TextEditingController();
    final TextEditingController zone = new TextEditingController();
    final TextEditingController zoneH = new TextEditingController();
    final TextEditingController description = new TextEditingController();

    setState(() {
      priceH.text = "قیمت :";
      price.text = formatter.format(widget.post.price);
      provinceH.text = "استان :";
      province.text = widget.post.province ?? "-";
      cityH.text = "شهر :";
      city.text = widget.post.city ?? "-";
      zoneH.text = "محله :";
      zone.text = widget.post.zone ?? "-";
      description.text = widget.post.description ?? "-";
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                  child: TextFormField(
                controller: priceH,
                textAlign: TextAlign.right,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
              Flexible(
                  child: TextFormField(
                controller: price,
                textAlign: TextAlign.left,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  child: TextFormField(
                controller: provinceH,
                textAlign: TextAlign.right,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
              Flexible(
                  child: TextFormField(
                controller: province,
                textAlign: TextAlign.left,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  child: TextFormField(
                controller: cityH,
                textAlign: TextAlign.right,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
              Flexible(
                  child: TextFormField(
                controller: city,
                textAlign: TextAlign.left,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  child: TextFormField(
                controller: zoneH,
                textAlign: TextAlign.right,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
              Flexible(
                  child: TextFormField(
                controller: zone,
                textAlign: TextAlign.left,
                enabled: false,
                style: TextStyle(fontFamily: 'myfont'),
              )),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "توضیحات : ",
            style: TextStyle(fontSize: 30.0, fontFamily: 'myfont'),
          ),
          TextField(
            controller: description,
            enabled: false,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(fontFamily: 'myfont'),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }

  Form updatePostForm() {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            updateHeader(),
            updateBody(),
            // updateImage(),
            updateSubmit(),
          ],
        ),
    );
  }

  Container updateHeader() {
    return Container(
      margin: EdgeInsets.only(top: 00.0, bottom: 60),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 00.0),
      child: Center(
          child: Text("تغییر اطلاعات آگهی",
              style: TextStyle(
                  color: mainColor,
                  fontSize: 20.0,
                  fontFamily: myFont,
                  fontWeight: FontWeight.bold))),
    );
  }

  Container updateBody() {
    author.text = widget.post.author;
    publisher.text = widget.post.publisher;
    price.text = widget.post.price.toString();
    province.text = widget.post.province;
    city.text = widget.post.city;
    zone.text = widget.post.zone;
    description.text = widget.post.description;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: author,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: myFont),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.assignment_ind, color: mainColor),
                labelText: "نویسنده",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: myFont),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: publisher,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: myFont),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.print, color: mainColor),
                labelText: "ناشر",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: myFont),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: price,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الزامی است';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontFamily: myFont),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money, color: mainColor),
                      labelText: "قیمت",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      hintStyle:
                      TextStyle(color: Colors.black, fontFamily: myFont),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: province,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الزامی است';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontFamily: myFont),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.map, color: mainColor),
                      labelText: "استان",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      hintStyle:
                      TextStyle(color: Colors.black, fontFamily: myFont),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                      controller: city,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontFamily: myFont),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city, color: mainColor),
                        labelText: "شهر",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        hintStyle:
                        TextStyle(color: Colors.black, fontFamily: myFont),
                      ),
                    ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                    child: TextFormField(
                      controller: zone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الزامی است';
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontFamily: myFont),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.map, color: mainColor),
                        labelText: "منطقه",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        hintStyle:
                        TextStyle(color: Colors.black, fontFamily: myFont),
                      ),
                    ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: myFont),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.description, color: mainColor),
                labelText: "توضیحات",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: myFont),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        )
    );
  }

  Container updateSubmit() {
    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 00),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 00.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: mainColor))),
        ),
        child: Text(
          "ثبت",
          style: TextStyle(
              color: mainColor, fontFamily: 'myfont'),
        ),
        onPressed: () {
          updatePost();
        },
      ),
    );
  }

  updatePost() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int postID = widget.post.id;
    String token = sharedPreferences.getString("token");

    var url = Uri.parse(AppUrl.Update_Post + postID.toString());

    var response;

    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    };

    var body = jsonEncode(<String, dynamic>{
      "author": author.text,
      "publisher": publisher.text,
      "price": price.text,
      "province": province.text,
      "city": city.text,
      "zone": zone.text,
      "description": description.text,
      "is_active": true
    });

    var jsonResponse;


    log("Token $token");
    log(body.toString());
    log(AppUrl.Update_Post + postID.toString());

    try {
      response = await http.put(url, body: body.toString(), headers: headers);
      if (response.statusCode == 200) {
        log("200");
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);

        // post_Image(jsonResponse["post"]["id"].toString());
        setState(() {
          _isLoading = false;

          widget.post.author = author.text;
          widget.post.publisher = publisher.text;
          widget.post.price = int.parse(price.text);
          widget.post.province = province.text;
          widget.post.city = city.text;
          widget.post.zone = zone.text;
          widget.post.description = description.text;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("با موفقیت انجام شد",
                  style: TextStyle(color: Colors.green))));

          Navigator.of(context).pop();
        });
      } else {
        print(response.body);
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("مشکلی به وجود آمد",
                  style: TextStyle(color: Colors.green))));
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      log(e);
    }

    setState(() {
      _isLoading = false;
    });

  }
}
