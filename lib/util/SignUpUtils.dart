class FirstNameFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty) return 'الزامی است';
    return null;
  }
}

class LastNameFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty) return 'الزامی است';
    return null;
  }
}

class EmailFieldValidator {
  static String validate(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);

    if (value == null || value.isEmpty) return 'الزامی است';
    if (!regExp.hasMatch(value)) return 'ایمیل را درست وارد کنید';
    return null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    if (value == null || value.isEmpty) return 'الزامی است';
    return null;
  }
}