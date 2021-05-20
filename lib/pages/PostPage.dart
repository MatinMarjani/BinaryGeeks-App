import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myBidCard.dart';


import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';
import 'package:application/util/User.dart';
import 'package:application/util/Utilities.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage(this.post);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  final TextEditingController author = new TextEditingController();
  final TextEditingController publisher = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  final TextEditingController province = new TextEditingController();
  final TextEditingController city = new TextEditingController();
  final TextEditingController zone = new TextEditingController();
  final TextEditingController description = new TextEditingController();

  final TextEditingController bidDescriptionController = new TextEditingController();
  final TextEditingController bidPriceController = new TextEditingController();

  bool _isLoading = false;
  bool _noImage = false;
  bool _isOwner = false;

  List<Widget> myBids = [];

  var formatter = new NumberFormat('###,###');

  File _image;
  String userImage;

  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      MyAppBar.appBarTitle = Text("صفحه آگهی",
          style: TextStyle(color: Colors.white, fontFamily: 'myfont'));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
    myBids.clear();
    checkOwner();
    getBids();

    author.text = widget.post.author;
    publisher.text = widget.post.publisher;
    price.text = widget.post.price.toString();
    province.text = widget.post.province;
    city.text = widget.post.city;
    zone.text = widget.post.zone;
    description.text = widget.post.description;

    userImage = User.profileImage;
  }

  checkOwner() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int ownerID = sharedPreferences.getInt("id");
    if (widget.post.ownerId == ownerID){
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
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ))
            : ListView(
            shrinkWrap: true,
            children: <Widget>[
              bannerImage(),
              header(),
              mainBody(),
              Center(
                child: Text("درخواست ها",style: TextStyle( fontSize: 30),),
              ),
              Divider(),
              SizedBox(height: 20,),
              postBidField(),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),
              Column(children: myBids),
            ],
          ),
      ),
      drawer: MyDrawer(),
    );
  }

  Container header() {
    String date = "";
    String time2 = "";
    String time = "";
    try {
      date = widget.post.createdAt.split('T')[0] ?? "";
      time2 = widget.post.createdAt.split('T')[1] ?? "";
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
                      showBarModalBottomSheet(
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

  Container bannerImage() {
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

  Container mainBody() {
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

  Container postBidField() {
    return Container(
      child: ListTile(
        // tileColor: Colors.white,
        leading: Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(Radius.circular(50))),
          child: CircleAvatar(
              radius: 50, backgroundImage: NetworkImage('http://37.152.176.11' + userImage)),
        ),
        title: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                maxLines: 4,
                minLines: 1,
                controller: bidDescriptionController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.request_page, color: mainColor),
                  labelText: "توضیحات",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintStyle: TextStyle(
                      color: Colors.black, fontFamily: myFont),
                ),
                validator: (value) => value.isEmpty ? "الزامی است" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: bidPriceController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.request_page, color: mainColor),
                  labelText: "قیمت",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  hintStyle: TextStyle(
                      color: Colors.black, fontFamily: myFont),
                ),
                validator: (value) => value.isEmpty ? "الزامی است" : null,
              ),
              SizedBox(height: 10),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), side: BorderSide(color: mainColor))),
                ),
                child: Text(
                  "ارسال درخواست",
                ),
                onPressed: () {
                  postBid(bidPriceController.text, bidDescriptionController.text);
                },
              ),
            ],
          )
        ),
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
            updateImage(),
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

  Container updateImage() {
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
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _image,
                width: 300,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
            )
                : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15)),
              width: 300,
              height: 300,
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container updateBody() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: author,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'الزامی است';
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
                if (value == null || value.isEmpty)
                  return 'الزامی است';
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
                      if (value == null || value.isEmpty)
                        return 'الزامی است';
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
                      if (value == null || value.isEmpty)
                        return 'الزامی است';
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
                        if (value == null || value.isEmpty)
                          return 'الزامی است';
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
                if (value == null || value.isEmpty)
                  return 'الزامی است';
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.delete, color: Colors.red,),
                      title: new Text('پاک کردن'),
                      onTap: () {
                        _imgDelete();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: new Icon(Icons.photo_library, color: Colors.lightBlue,),
                      title: new Text('گالری'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera, color: Colors.cyanAccent,),
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

  _imgDelete() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var postID = widget.post.id;
    var token = sharedPreferences.getString("token");

    var url = Uri.parse(AppUrl.Update_Post + postID.toString());
    var response;

    String data =
        '{\r\n    "image": null\r\n}';

    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    };

    try {
      response = await http.put(url, body: data, headers: headers);
      if (response.statusCode == 200) {
        log('200');
        print(response.statusCode);
        setState(() {
          widget.post.image = null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("با موفقیت انجام شد",
                  style: TextStyle(color: Colors.green))));
          Navigator.of(context).pop();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "مشکلی وجود دارد",
              style: TextStyle(color: Colors.red),
            )));
        Navigator.of(context).pop();
        print(response.error);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
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

  updatePost() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int postID = widget.post.id;
    String token = sharedPreferences.getString("token");

    var url = Uri.parse(AppUrl.Update_Post + postID.toString());
    var response;
    var jsonResponse;


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

    try {
      response = await http.put(url, body: body.toString(), headers: headers);
      if (response.statusCode == 200) {
        log("200");
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        postImage();
        setState(() {
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

  postImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int postID = widget.post.id;
    String token = sharedPreferences.getString("token");

    var url = Uri.parse(AppUrl.Update_Post + postID.toString());

    var headers = {'Authorization': 'Token $token'};
    var request = http.MultipartRequest('PUT', url);

    try {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        getImage();
      } else {
        print(await response.stream.bytesToString());
        print(response.reasonPhrase);
      }
    } catch (e) {
      log(e);
    }
  }

  getImage() async {
    int postID = widget.post.id;

    var url = Uri.parse(AppUrl.Get_Post + postID.toString());
    var response;

    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        if (jsonResponse != null) {
          setState(() {
            widget.post.image = AppUrl.liveBaseURL + jsonResponse['image'];
            log("YESYESYSEYSEYSY");
          });
        }
      }
    } catch(e) {}

  }

  getBids() async {
    int postID = widget.post.id;
    var url = Uri.parse(AppUrl.Get_Post + postID.toString() + "/bids");
    var response;
    log("1");

    try {
      response = await http.get(url);
      log("2");
      if (response.statusCode == 200) {
        log("3");
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        if (jsonResponse != null) {
          log("4");
          setState(() {
            for (var i in jsonResponse) {
              myBids.add(BidCard(
                i["id"],
                i["owner"]["id"],
                i["owner"]["username"],
                i["owner"]["email"],
                i["owner"]["first_name"],
                i["owner"]["last_name"],
                i["owner"]["profile_image"],

                i["offered_price"].toString(),
                i["description"],
                i["is_accepted"],
              ));
              myBids.add(Divider(
                thickness: 5,
                indent: 20,
              ));
            }
          });
        }
      }
    } catch(e) {}

    if ( myBids.isEmpty ){
      myBids.add(BidCard(1, 1, "userName", "email", "firstName", "lastName", "null", "10000", "description", false));
      myBids.add(Divider(
        thickness: 5,
        indent: 20,
      ));
      myBids.add(BidCard(1, 1, "userName", "email", "firstName", "lastName", "null", "5785178", "description", false));
      myBids.add(Divider(
        thickness: 5,
        indent: 20,
      ));
      myBids.add(BidCard(1, 1, "userName", "email", "firstName", "lastName", "null", "78578578", "description", false));
      myBids.add(Divider(
        thickness: 5,
        indent: 20,
      ));
    }
  }

  postBid(String price, String description) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int postID = widget.post.id;
    String token = sharedPreferences.getString("token");

    var url = Uri.parse(AppUrl.Post_Bid);

    var headers = {'Authorization': 'Token $token','Content-Type': 'application/json'};

    var response;
    var jsonResponse;

    var body = jsonEncode(<String, dynamic>{
      "post": postID,
      "offered_price": int.parse(price),
      "description": description,
    });

    try {
      response = await http.post(url, body: body.toString(), headers: headers);
      if (response.statusCode == 200) {
        log("200");
        print(jsonResponse);
        setState(() {
          myBids.clear();
          getBids();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("با موفقیت انجام شد",
                  style: TextStyle(color: Colors.green))));
          // Navigator.of(context).pop();
        });
      } else {
        print(response.body);
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("مشکلی به وجود آمد",
                  style: TextStyle(color: Colors.red))));
          // Navigator.of(context).pop();
        });
      }
    } catch (e) {
      log(e);
    }


  }

}
