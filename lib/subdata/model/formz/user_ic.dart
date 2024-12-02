import 'package:formz/formz.dart';

enum User_ICValidationError { empty }

class User_IC extends FormzInput<String, User_ICValidationError> {
  const User_IC.pure() : super.pure('');
  const User_IC.dirty([super.value = '']) : super.dirty();

  @override
  User_ICValidationError? validator(String value) {
    if (value.isEmpty) return User_ICValidationError.empty;
    return null;
  }
}
