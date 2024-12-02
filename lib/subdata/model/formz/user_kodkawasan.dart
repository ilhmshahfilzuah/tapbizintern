import 'package:formz/formz.dart';

enum User_KodKawasanValidationError { empty }

class User_KodKawasan
    extends FormzInput<String, User_KodKawasanValidationError> {
  const User_KodKawasan.pure() : super.pure('');
  const User_KodKawasan.dirty([super.value = '']) : super.dirty();

  @override
  User_KodKawasanValidationError? validator(String value) {
    if (value.isEmpty) return User_KodKawasanValidationError.empty;
    return null;
  }
}
