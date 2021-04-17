import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

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
        child: ListView(
          children: <Widget>[
            headerSection(),
            profilePicture(),
            infoForm(),
            // passForm(),
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
        child: CircleAvatar(
      maxRadius: 75,
      backgroundColor: Colors.white,
      child: Text("م"),
    ));
  }

  Form infoForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
          //changePass(),
          //Submit2(),
        ],
      ),
    );
  }

  Container profileSection() {
    return Container(
      //color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
            style: TextStyle(color: Colors.black),
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
            setState(() {
              //_isLoading = true;
            });
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

  updateProfile(String first, last, email, phone, uni, field, year) {
    //request
  }
}
