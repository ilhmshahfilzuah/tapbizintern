part of 'logupdate_bloc.dart';

class LogupdateEvent extends Equatable {
  const LogupdateEvent();

  @override
  List<Object> get props => [];
}

// ------------------------
class LogupdateUser_ICChanged extends LogupdateEvent {
  const LogupdateUser_ICChanged(this.user_IC);
  final String user_IC;
  @override
  List<Object> get props => [user_IC];
}

// ------------------------
// ------------------------
class LogupdateUser_KodKawasanChanged extends LogupdateEvent {
  const LogupdateUser_KodKawasanChanged(this.user_KodKawasan);
  final String user_KodKawasan;
  @override
  List<Object> get props => [user_KodKawasan];
}

// ------------------------
// ------------------------
class LogupdateUser_KodKeselamatanChanged extends LogupdateEvent {
  const LogupdateUser_KodKeselamatanChanged(this.user_KodKeselamatan);
  final String user_KodKeselamatan;
  @override
  List<Object> get props => [user_KodKeselamatan];
}
// ------------------------
// ------------------------
class LogupdateUser_PinChanged extends LogupdateEvent {
  const LogupdateUser_PinChanged(this.user_Pin);
  final String user_Pin;
  @override
  List<Object> get props => [user_Pin];
}
// ------------------------

// class LogupdateSubmitted extends LogupdateEvent {
//   final String email;
//   final String password;
//   const LogupdateSubmitted({required this.email, required this.password});
// }

class LogupdateSubmitted extends LogupdateEvent {
  final String user_IC;
  const LogupdateSubmitted(
      {required this.user_IC});
}

// -----
class LogupdateError extends LogupdateState {
  final String errorMessage;
  LogupdateError({
    required this.errorMessage,
  });
}

class LogupdateWaiting extends LogupdateState {}

// class LogupdateSuccess extends LogupdateState {
//   final List<UserModel> logupdateData;
//   LogupdateSuccess({required this.logupdateData});
// }
// -----
