import 'package:formz/formz.dart';

enum User_NoTelValidationError { empty }

class User_NoTel extends FormzInput<String, User_NoTelValidationError> {
  const User_NoTel.pure() : super.pure('');
  const User_NoTel.dirty([super.value = '']) : super.dirty();

  @override
  User_NoTelValidationError? validator(String value) {
    if (value.isEmpty) return User_NoTelValidationError.empty;
    return null;
  }
}
