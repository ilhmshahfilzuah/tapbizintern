import 'package:formz/formz.dart';

enum User_NameValidationError { empty }

class User_Name extends FormzInput<String, User_NameValidationError> {
  const User_Name.pure() : super.pure('');
  const User_Name.dirty([super.value = '']) : super.dirty();

  @override
  User_NameValidationError? validator(String value) {
    if (value.isEmpty) return User_NameValidationError.empty;
    return null;
  }
}
