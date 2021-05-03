import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  var formatter = new NumberFormat('###,###');

  @override
  void initState() {
    super.initState();
    setState(() {
      MyAppBar.appBarTitle =
          Text("BookTrader", style: TextStyle(color: Colors.white));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
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
                  _Header(),
                  _BannerImage(),
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
    try{
      date = widget.post.created_at.split('T')[0] ?? "";
      time2 = widget.post.created_at.split('T')[1] ?? "";
      time = time2.split(".")[0] ?? "";
    }catch(e) {

    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.post.title,
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            widget.post.author,
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            widget.post.publisher,
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                    date,
                    style: TextStyle(fontSize: 15.0),
                  ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 15.0),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Container _BannerImage() {
    if(widget.post.image == null)
      _noImage = true;
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
              )),
              Flexible(
                  child: TextFormField(
                controller: price,
                textAlign: TextAlign.left,
                enabled: false,
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
              )),
              Flexible(
                  child: TextFormField(
                controller: province,
                textAlign: TextAlign.left,
                enabled: false,
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
              )),
              Flexible(
                  child: TextFormField(
                controller: city,
                textAlign: TextAlign.left,
                enabled: false,
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
              )),
              Flexible(
                  child: TextFormField(
                controller: zone,
                textAlign: TextAlign.left,
                enabled: false,
              )),
            ],
          ),
          SizedBox(height:30),
          Text(
            "توضیحات : ",
            style: TextStyle(fontSize: 30.0),
          ),
          TextField(
            controller: description,
            enabled: false,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
