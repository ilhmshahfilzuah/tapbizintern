part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// // ------------------------
// class LoginUsernameChanged extends LoginEvent {
//   const LoginUsernameChanged(this.username);
//   final String username;
//   @override
//   List<Object> get props => [username];
// }

// // ------------------------
// // ------------------------
// class LoginPasswordChanged extends LoginEvent {
//   const LoginPasswordChanged(this.password);
//   final String password;
//   @override
//   List<Object> get props => [password];
// }
// // ------------------------
// ------------------------
class LoginUser_ICChanged extends LoginEvent {
  const LoginUser_ICChanged(this.user_IC);
  final String user_IC;
  @override
  List<Object> get props => [user_IC];
}

// ------------------------
// ------------------------
class LoginUser_KodKawasanChanged extends LoginEvent {
  const LoginUser_KodKawasanChanged(this.user_KodKawasan);
  final String user_KodKawasan;
  @override
  List<Object> get props => [user_KodKawasan];
}

// ------------------------
// ------------------------
class LoginUser_PinChanged extends LoginEvent {
  const LoginUser_PinChanged(this.user_Pin);
  final String user_Pin;
  @override
  List<Object> get props => [user_Pin];
}

// ------------------------
// ------------------------
class LoginUser_KataLaluanChanged extends LoginEvent {
  const LoginUser_KataLaluanChanged(this.user_KataLaluan);
  final String user_KataLaluan;
  @override
  List<Object> get props => [user_KataLaluan];
}

// ------------------------

class LoginSubmitted extends LoginEvent {
  final String user_IC;
  final String? user_KodKawasan;
  final String? user_Pin;
  final String? user_KataLaluan;
  const LoginSubmitted({required this.user_IC, this.user_KodKawasan, this.user_Pin, this.user_KataLaluan});
}

// -----
class LoginAPI extends LoginEvent {
  final String email;
  final String password;
  final apiToken;
  LoginAPI(
      {required this.email, required this.password, required this.apiToken});
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError({
    required this.errorMessage,
  });
}

class LoginWaiting extends LoginState {}

// class LoginSuccess extends LoginState {
//   final List<UserModel> loginData;
//   LoginSuccess({required this.loginData});
// }
// -----
