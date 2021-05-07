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
                              side: BorderSide(color: Colors.blueAccent))),
                    ),
                    child: Icon(Icons.edit, color: Colors.blueAccent,),
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => updatePost(),
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

  Form updatePost() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // editHeader(),
          // updatePasswordSuccess(),
          // changePass(),
          // submit2(),
        ],
      ),
    );
  }
}
