import 'package:test/test.dart';
import 'package:application/pages/login.dart';

void main () {
   test("Empty email return error",(){
     var result = EmailFieldValidator.validate('');
     expect(result, 'الزامی است');
   });

   test("non-Empty email return null",(){
     var result = EmailFieldValidator.validate('email');
     expect(result, "ایمیل را درست وارد کنید");
   });

   test("Empty password return error",(){
     var result = PasswordFieldValidator.validate('');
     expect(result, 'الزامی است');
   });

   test("non-Empty password return error",(){
     var result = PasswordFieldValidator.validate('password');
     expect(result, null);
   });
}