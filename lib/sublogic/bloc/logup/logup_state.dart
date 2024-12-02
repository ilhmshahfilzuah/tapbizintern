part of 'logup_bloc.dart';

class LogupState extends Equatable {
  const LogupState({
    this.status = FormzSubmissionStatus.initial,
    this.user_Name = const User_Name.pure(),
    this.user_Tel = const User_NoTel.pure(),
    this.user_Email = const User_Email.pure(),
    this.password = const User_KodKawasan.pure(),
    this.activationCode = const ActivationCode.pure(),
    this.user_Pin = const User_Pin.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final User_Name user_Name;
  final User_NoTel user_Tel;
  final User_Email user_Email;
  final User_KodKawasan password;
  final ActivationCode activationCode;
  final User_Pin user_Pin;

  final bool isValid;

  LogupState copyWith({
    FormzSubmissionStatus? status,
    User_Name? user_Name,
    User_NoTel? user_Tel,
    User_Email? user_Email,
    User_KodKawasan? password,
    ActivationCode? activationCode,
    User_Pin? user_Pin,
    bool? isValid,
  }) {
    return LogupState(
      status: status ?? this.status,
      user_Name: user_Name ?? this.user_Name,
      user_Tel: user_Tel ?? this.user_Tel,
      user_Email: user_Email ?? this.user_Email,
      password: password ?? this.password,
      activationCode: activationCode ?? this.activationCode,
      user_Pin: user_Pin ?? this.user_Pin,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        status,
        user_Name,
        user_Tel,
        user_Email,
        password,
        activationCode,
        user_Pin
      ];
}
