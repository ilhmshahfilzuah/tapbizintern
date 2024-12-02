part of 'logup_bloc.dart';

class LogupEvent extends Equatable {
  const LogupEvent();

  @override
  List<Object> get props => [];
}

// ------------------------
class LogupUser_NameChanged extends LogupEvent {
  const LogupUser_NameChanged(this.user_Name);
  final String user_Name;
  @override
  List<Object> get props => [user_Name];
}

// ------------------------
// ------------------------
class LogupUser_EmailChanged extends LogupEvent {
  const LogupUser_EmailChanged(this.user_Email);
  final String user_Email;
  @override
  List<Object> get props => [user_Email];
}

// ------------------------
// ------------------------
class LogupActivationCodeChanged extends LogupEvent {
  const LogupActivationCodeChanged(this.activationCode);
  final String activationCode;
  @override
  List<Object> get props => [activationCode];
}

// ------------------------
// ------------------------
class LogupPasswordChanged extends LogupEvent {
  const LogupPasswordChanged(this.password);
  final String password;
  @override
  List<Object> get props => [password];
}

// ------------------------

class LogupSubmitted extends LogupEvent {
  final String user_Name;
  final String user_Email;
  final String password;
  final String activationCode;
  const LogupSubmitted(
      {required this.user_Name,
      required this.user_Email,
      required this.password,
      required this.activationCode
      });
}

// -----
class LogupError extends LogupState {
  final String errorMessage;
  LogupError({
    required this.errorMessage,
  });
}

class LogupWaiting extends LogupState {}


