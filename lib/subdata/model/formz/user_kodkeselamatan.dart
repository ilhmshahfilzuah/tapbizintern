import 'package:formz/formz.dart';

enum User_KodKeselamatanValidationError { empty }

class User_KodKeselamatan
    extends FormzInput<String, User_KodKeselamatanValidationError> {
  const User_KodKeselamatan.pure() : super.pure('');
  const User_KodKeselamatan.dirty([super.value = '']) : super.dirty();

  @override
  User_KodKeselamatanValidationError? validator(String value) {
    if (value.isEmpty) return User_KodKeselamatanValidationError.empty;
    return null;
  }
}
