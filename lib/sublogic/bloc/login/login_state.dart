part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.user_IC = const User_IC.pure(),
    this.user_KodKawasan = const User_KodKawasan.pure(),
    this.user_Pin = const User_Pin.pure(),
    this.user_KataLaluan = const User_KataLaluan.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final User_IC user_IC;
  final User_KodKawasan user_KodKawasan;
  final User_Pin user_Pin;
  final User_KataLaluan user_KataLaluan;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    User_IC? user_IC,
    User_KodKawasan? user_KodKawasan,
    User_Pin? user_Pin,
    User_KataLaluan? user_KataLaluan,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      user_IC: user_IC ?? this.user_IC,
      user_KodKawasan: user_KodKawasan ?? this.user_KodKawasan,
      user_Pin: user_Pin ?? this.user_Pin,
      user_KataLaluan: user_KataLaluan ?? this.user_KataLaluan,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
        status,
        user_IC,
        user_KodKawasan,
        user_Pin,
        user_KataLaluan,
      ];
}
