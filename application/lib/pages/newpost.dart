import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';



import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  bool complete = false;

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController authorController = new TextEditingController();
  final TextEditingController publisherController = new TextEditingController();
  final TextEditingController categoriesController =
      new TextEditingController();
  final TextEditingController priceController = new TextEditingController();
  final TextEditingController provinceController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();
  final TextEditingController zoneController = new TextEditingController();
  final TextEditingController statusController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();

  File _image;

  var items = ["ریاضی", "علوم پایه", "مهندسی کامپیوتر", "معارف"];

  var items1 = ["فروش", "خرید", "معاوضه", "اهدا"];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: NewPost(),
      drawer: MyDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.list),
      //   onPressed: switchStepsType,
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          _formKey1.currentState.validate();
          _formKey3.currentState.validate();
        },
      ),
    );
  }

  Container NewPost() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stepper(
              type: stepperType,
              physics: ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row(
                  children: <Widget>[
                    SizedBox(height: 200),
                    Container(
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.indigoAccent)),
                        child: Text(
                          "ادامه",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          log(_currentStep.toString());
                          onStepContinue();
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red)),
                        child: Text(
                          "قبلی",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          log(_currentStep.toString());
                          onStepCancel();
                        },
                      ),
                    ),
                  ],
                );
              },
              steps: <Step>[
                step_one(),
                step_two(),
                step_three(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2
        ? setState(() => _currentStep += 1)
        : setState(() => complete = true);

    if (_currentStep == 1) if (!_formKey1.currentState.validate()) {
      setState(() => _currentStep = 0);
    }

    if (complete) {
      if (!_formKey3.currentState.validate()) {
        setState(() => _currentStep = 2);
      }else{
        CreatePost();
      }
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
    if (_currentStep < 2) {
      setState(() => complete = false);
    }
  }

  Step step_one() {
    return Step(
      title: new Text('مشخصات کتاب'),
      content: Form(
        key: _formKey1,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.title, color: Colors.black),
                labelText: "نام کتاب",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: authorController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.assignment_ind, color: Colors.black),
                labelText: "نویسنده",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: publisherController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.print, color: Colors.black),
                labelText: "ناشر",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: categoriesController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    categoriesController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return items.map<PopupMenuItem<String>>((String value) {
                      return new PopupMenuItem(
                          child: new Text(value), value: value);
                    }).toList();
                  },
                ),
                icon: Icon(Icons.speaker_group, color: Colors.black),
                labelText: "دسته بندی",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    );
  }

  Step step_two() {
    return Step(
      title: new Text('تصویر کتاب'),
      content: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              margin: EdgeInsets.only(top: 0.0),
              child:           Center(
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
          ),
          SizedBox(height: 20),
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step step_three() {
    return Step(
      title: new Text('توضیحات'),
      content: Form(
        key: _formKey3,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: priceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الزامی است';
                }
                return null;
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                icon: Icon(Icons.attach_money, color: Colors.black),
                labelText: 'قیمت',
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: provinceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الزامی است';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: Icon(Icons.map, color: Colors.black),
                      labelText: "استان",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Flexible(
                  child: TextFormField(
                    controller: cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الزامی است';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_city, color: Colors.black),
                      labelText: "شهر",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: zoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الزامی است';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: Icon(Icons.map, color: Colors.black),
                      labelText: "منطقه",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Flexible(
                  child: TextFormField(
                    controller: statusController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الزامی است';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String value) {
                          statusController.text = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return items1
                              .map<PopupMenuItem<String>>((String value) {
                            return new PopupMenuItem(
                                child: new Text(value), value: value);
                          }).toList();
                        },
                      ),
                      icon: Icon(Icons.speaker_group, color: Colors.black),
                      labelText: "وضعیت",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
    );
  }

  CreatePost() async {

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
        }
    );
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }


}
