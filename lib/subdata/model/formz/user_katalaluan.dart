import 'package:formz/formz.dart';

enum User_KataLaluanValidationError { empty }

class User_KataLaluan
    extends FormzInput<String, User_KataLaluanValidationError> {
  const User_KataLaluan.pure() : super.pure('');
  const User_KataLaluan.dirty([super.value = '']) : super.dirty();

  @override
  User_KataLaluanValidationError? validator(String value) {
    if (value.isEmpty) return User_KataLaluanValidationError.empty;
    return null;
  }
}
