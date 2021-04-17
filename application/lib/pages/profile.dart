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
            passForm(),
          ],
        ),
      ),
    );
  }

  Container headerSection() {
    return Container();
  }

  Container profilePicture() {
    return Container();
  }

  Form infoForm() {
    return Form();
  }

  Form passForm() {
    return Form();
  }
}
