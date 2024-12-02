part of 'logupdate_bloc.dart';

class LogupdateState extends Equatable {
  const LogupdateState({
    this.status = FormzSubmissionStatus.initial,
    this.user_IC = const User_IC.pure(),
    this.user_KodKawasan = const User_KodKawasan.pure(),
    this.user_KodKeselamatan = const User_KodKeselamatan.pure(),
    this.user_Pin = const User_Pin.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final User_IC user_IC;
  final User_KodKawasan user_KodKawasan;
  final User_KodKeselamatan user_KodKeselamatan;
  final User_Pin user_Pin;

  final bool isValid;

  LogupdateState copyWith({
    FormzSubmissionStatus? status,
    User_IC? user_IC,
    User_KodKawasan? user_KodKawasan,
    User_KodKeselamatan? user_KodKeselamatan,
    User_Pin? user_Pin,
    bool? isValid,
  }) {
    return LogupdateState(
      status: status ?? this.status,
      user_IC: user_IC ?? this.user_IC,
      user_KodKawasan: user_KodKawasan ?? this.user_KodKawasan,
      user_KodKeselamatan: user_KodKeselamatan ?? this.user_KodKeselamatan,
      user_Pin: user_Pin ?? this.user_Pin,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props =>
      [status, user_IC, user_KodKawasan, user_KodKeselamatan, user_Pin];
}
