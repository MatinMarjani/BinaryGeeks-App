import 'package:test/test.dart';
import 'package:application/util/ProfileUtils.dart';

void main () {
  test("empty email return error", () {
    var result = ProfileValidators.validateEmail('');
    expect(result, "ایمیل را درست وارد کنید");
  });

  test("bad format email return error", () {
    var result = ProfileValidators.validateEmail('email');
    expect(result, "ایمیل را درست وارد کنید");
  });

  test("non-Empty email return null", () {
    var result = ProfileValidators.validateEmail('email@email.com');
    expect(result, null);
  });

  test("already existing email return error", () {
    var result = ProfileValidators.errorEmail(true);
    expect(result, 'ایمیل تکراری است');
  });

  test("new email return null", () {
    var result = ProfileValidators.errorEmail(false);
    expect(result, null);
  });

  test("empty phone number return error", () {
    var result = ProfileValidators.validatePhone("");
    expect(result, 'شماره موبایل درست را وارد کنید');
  });

  test("bad format phone number return error", () {
    var result = ProfileValidators.validatePhone("4551223");
    expect(result, 'شماره موبایل درست را وارد کنید');
  });

  test("correct format phone number return null", () {
    var result = ProfileValidators.validatePhone("989357473800");
    expect(result, null);
  });

  test("already existing email return error", () {
    var result = ProfileValidators.errorPhone(true);
    expect(result, 'شماره موبایل تکراری است');
  });

  test("new email return null", () {
    var result = ProfileValidators.errorPhone(false);
    expect(result, null);
  });

  test("wrong password return error", () {
    var result = ProfileValidators.errorPass(true);
    expect(result, 'رمز وارد شده غلط می باشد');
  });

  test("correct password return null", () {
    var result = ProfileValidators.errorPass(false);
    expect(result, null);
  });

}