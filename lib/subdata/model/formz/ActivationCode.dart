import 'package:formz/formz.dart';

enum ActivationCodeValidationError { empty }

class ActivationCode extends FormzInput<String, ActivationCodeValidationError> {
  const ActivationCode.pure() : super.pure('');
  const ActivationCode.dirty([super.value = '']) : super.dirty();

  @override
  ActivationCodeValidationError? validator(String value) {
    if (value.isEmpty) return ActivationCodeValidationError.empty;
    return null;
  }
}
