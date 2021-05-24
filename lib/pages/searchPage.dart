import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myPostCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';
import 'package:application/util/Utilities.dart';

class FilterControllers {
  static final TextEditingController categoryController = new TextEditingController();
  static final TextEditingController pricestartController = new TextEditingController();
  static final TextEditingController priceendController = new TextEditingController();
  static final TextEditingController provinceController = new TextEditingController();
  static final TextEditingController cityController = new TextEditingController();
  static final TextEditingController sortController = new TextEditingController();

  static var items = [
    'قیمت',
  ];
}

class SearchPage extends StatefulWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;
  final _formKey = GlobalKey<FormState>();


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Post> myPost = [];
  bool _isLoading = false;
  int page;

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _searchQuery = new TextEditingController();

  void initState() {
    super.initState();
    log("SearchPage init");
    setState(() {
      page = 1;
      MyAppBar.appBarTitle = TextField(
        controller: _searchQuery,
        onSubmitted: (value) {
          if (_searchQuery.text != "" || _searchQuery.text != null) {
            myPost.clear();
            getPosts(_searchQuery.text, page.toString());
          }
        },
        style: TextStyle(color: Colors.white, fontFamily: 'myfont'),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: "جست و جو",
            hintStyle: TextStyle(color: Colors.white, fontFamily: 'myfont')),
      );
      MyAppBar.actionIcon = Icon(Icons.close, color: Colors.white,);
      myPost.clear();

    });
    FilterControllers.categoryController.text = "";
    FilterControllers.pricestartController.text = "";
    FilterControllers.priceendController.text = "";
    FilterControllers.provinceController.text = "";
    FilterControllers.cityController.text = "";
    FilterControllers.sortController.text = "";
  }

  void _onRefresh() async{
    myPost.clear();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    for ( int i = 1; i <= page; i++) {
      getPosts(_searchQuery.text, page.toString());
    }
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    page++;
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    getPosts(_searchQuery.text, page.toString());
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _isLoading
            ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(widget.mainColor),
            ))
            : ListView(
          children: <Widget>[
            filterBtn(),
            posts(),
          ],
        ),

      ),
      drawer: MyDrawer(),
    );
  }

  Container filterBtn() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: widget.mainColor))),
        ),
        child: Text(
          "فیلتر",
          style: TextStyle(
              color: widget.mainColor, fontFamily: 'myfont'),
        ),
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => filterForm(),
          );
        },
      ),
    );
  }

  Form filterForm(){
    return Form(
      key: widget._formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          filterHeader(),
          filterBody(),
        ],
      ),
    );
  }

  Container filterHeader() {
    return Container(
      margin: EdgeInsets.only(top: 00.0, bottom: 30),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 00.0),
      child: Center(
          child: Text("فیلتر ها :",
              style: TextStyle(
                  color: widget.mainColor,
                  fontSize: 20.0,
                  fontFamily: widget.myFont,
                  fontWeight: FontWeight.bold))),
    );
  }

  Container filterBody() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: FilterControllers.categoryController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.web_asset_outlined, color: widget.mainColor),
                labelText: "دسته بندی",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: FilterControllers.provinceController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                // icon: Icon(Icons.lock, color: widget.mainColor),
                prefixIcon: Icon(Icons.map_outlined, color: widget.mainColor),
                labelText: "استان",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: FilterControllers.cityController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                // icon: Icon(Icons.lock, color: widget.mainColor),
                prefixIcon: Icon(Icons.location_city_outlined, color: widget.mainColor),
                labelText: "شهر",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: FilterControllers.sortController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.save_alt_outlined, color: widget.mainColor),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    FilterControllers.categoryController.text = value;},
                  itemBuilder: (BuildContext context) {
                    return FilterControllers.items.map<PopupMenuItem<String>>((String value) {
                      return new PopupMenuItem(
                          child: new Text(value), value: value);
                    }).toList();
                    },
                ),
                labelText: "اساس",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                hintStyle:
                TextStyle(color: Colors.black, fontFamily: widget.myFont),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Flexible(
                    child: TextFormField(
                      controller: FilterControllers.pricestartController,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.arrow_back_ios_outlined, color: widget.mainColor),
                        labelText: "از قیمت",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        hintStyle:
                        TextStyle(color: Colors.black, fontFamily: widget.myFont),
                      ),
                    ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                    child: TextFormField(
                      controller: FilterControllers.priceendController,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontFamily: widget.myFont),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.arrow_forward_ios_outlined, color: widget.mainColor),
                        labelText: "تا قیمت",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        hintStyle:
                        TextStyle(color: Colors.black, fontFamily: widget.myFont),
                      ),
                    ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
            SizedBox(height: 30,),
            filterDoneBtn(),
          ],
        )
    );
  }

  Container filterDoneBtn() {
    return Container(
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 110.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: widget.mainColor))),
        ),
        child: Text(
          "اعمال فیلتر ها",
          style: TextStyle(
              color: widget.mainColor, fontFamily: 'myfont'),
        ),
        onPressed: () {
          myPost.clear();
          page = 1;
          getPosts(_searchQuery.text, page.toString());
          Navigator.of(context).pop();
          },
      ),
    );
  }

  Widget posts() {
    if (myPost.length == 0) return Center(child: Text("بدون نتیجه",style: TextStyle(fontSize: 13,fontFamily: widget.myFont),),);
    List<Widget> list = [];
    for (var i = 0; i < myPost.length; i++) {
      if (myPost[i].title == null) myPost[i].title = " ";
      if (myPost[i].author == null) myPost[i].author = " ";
      if (myPost[i].categories == null) myPost[i].categories = " ";
      if (myPost[i].price == null) myPost[i].price = 0;
      if (myPost[i].province == null) myPost[i].province = " ";
      if (myPost[i].description == null) myPost[i].description = " ";

      list.add(PostCard(myPost[i]));
    }
    return Column(children: list);
  }

  getPosts(String contains, String p) async {
    String category = FilterControllers.categoryController.text;
    String province = FilterControllers.provinceController.text;
    String city = FilterControllers.cityController.text;
    String sort = FilterControllers.sortController.text;
    String pricestart = FilterControllers.pricestartController.text;
    String priceend = FilterControllers.priceendController.text;

    if(contains.isNotEmpty)
      contains = "contains=$contains&";
    if(category.isNotEmpty)
      category = "category=$category&";
    if(province.isNotEmpty)
      province = "province=$province&";
    if(city.isNotEmpty)
      city = "city=$city&";
    if(sort.isNotEmpty)
      sort= "sort=price&";
    if(pricestart.isNotEmpty)
      pricestart= "pricestart=$pricestart&";
    if(priceend.isNotEmpty)
      priceend= "priceend=$priceend&";

    var jsonResponse;
    var response;

    var url = Uri.parse(AppUrl.Search + "?" + contains + category + province + city + sort + priceend + pricestart + "page=" + p);
    log(AppUrl.Search + "?" + contains + category + province + city + sort + priceend + pricestart + "page=" + p);

    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        log('200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print(jsonResponse);
        if (jsonResponse != null) {
          setState(() {
            for (var i in jsonResponse["results"]) {
              if ( i["is_active"] == null )
                i["is_active"] = false;
              myPost.add(Post(
                i["owner"]["id"],
                i["owner"]["email"],
                i["owner"]["profile_image"],
                i["id"],
                i["title"],
                i["author"],
                i["publisher"],
                i["price"],
                i["province"],
                i["city"],
                i["zone"],
                i["status"],
                i["description"],
                i["is_active"],
                i["image"],
                //url
                i["categories"],
                i["created_at"],
              ));
            }
          });
        }
      } else {
        log('!200');
        jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          if(jsonResponse["detail"] == "Invalid page.")
            page--;
        });
      }
    } catch (e) {
      log("error");
      print(e);
    }
  }
}
