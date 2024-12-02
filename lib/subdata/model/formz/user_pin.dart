import 'package:formz/formz.dart';

enum User_PinValidationError { empty }

class User_Pin
    extends FormzInput<String, User_PinValidationError> {
  const User_Pin.pure() : super.pure('');
  const User_Pin.dirty([super.value = '']) : super.dirty();

  @override
  User_PinValidationError? validator(String value) {
    if (value.isEmpty) return User_PinValidationError.empty;
    return null;
  }
}
