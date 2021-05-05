import 'package:test/test.dart';
import 'package:application/pages/signup.dart';

void main() {
  //FirsName
  test("Empty first name return error", () {
    var result = FirstNameFieldValidator.validate('');
    expect(result, 'الزامی است');
  });

  test("non-Empty first name return null", () {
    var result = FirstNameFieldValidator.validate('FirstName');
    expect(result, null);
  });

  //LastName
  test("Empty last name return error", () {
    var result = LastNameFieldValidator.validate('');
    expect(result, 'الزامی است');
  });

  test("non-Empty last name return null", () {
    var result = LastNameFieldValidator.validate('LastName');
    expect(result, null);
  });

  //Email
  test("Empty email return error", () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'الزامی است');
  });

  test("non-Empty email return null", () {
    var result = EmailFieldValidator.validate('email');
    expect(result, "ایمیل را درست وارد کنید");
  });

  //Password
  test("Empty password return error", () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'الزامی است');
  });

  test("non-Empty password return error", () {
    var result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}
