import 'package:flutter/material.dart';

class ProfileControllers {
  static final TextEditingController firstNameController =
  new TextEditingController();
  static final TextEditingController lastNameController =
  new TextEditingController();
  static final TextEditingController emailController =
  new TextEditingController();
  static final TextEditingController phoneController =
  new TextEditingController();
  static final TextEditingController universityController =
  new TextEditingController();
  static final TextEditingController fieldOfStudyController =
  new TextEditingController();
  static final TextEditingController entryYearController =
  new TextEditingController();
  static final TextEditingController oldPasswordController =
  new TextEditingController();
  static final TextEditingController passwordController =
  new TextEditingController();
  static final TextEditingController passwordReController =
  new TextEditingController();
  static final TextEditingController imageController =
  new TextEditingController();
  static final TextEditingController controller = new TextEditingController();
}

class ProfileValidators {
  static String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) return 'ایمیل را درست وارد کنید';
    return null;
  }

  static String errorEmail(bool emailError) {
    if (emailError) return 'ایمیل تکراری است';
    return (null);
  }

  static String validatePhone(String value) {
    String pattern = r'^(?:0|98)9?[0-9]{10}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) return 'شماره موبایل درست را وارد کنید';
    return null;
  }

  static String errorPhone(bool phoneError) {
    if (phoneError) return 'شماره موبایل تکراری است';
    return null;
  }

  static String errorPass(bool _wrongPass) {
    if (_wrongPass) return 'رمز وارد شده غلط می باشد';
    return null;
  }
}