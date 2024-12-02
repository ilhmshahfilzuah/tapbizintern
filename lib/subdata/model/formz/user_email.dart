import 'package:formz/formz.dart';

enum User_EmailValidationError { empty }

class User_Email extends FormzInput<String, User_EmailValidationError> {
  const User_Email.pure() : super.pure('');
  const User_Email.dirty([super.value = '']) : super.dirty();

  @override
  User_EmailValidationError? validator(String value) {
    if (value.isEmpty) return User_EmailValidationError.empty;
    return null;
  }
}
