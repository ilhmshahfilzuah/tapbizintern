import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../subdata/model/user.dart';
import '../../../subdata/network/api_provider.dart';
import '../../../subdata/repository/authentication_repository.dart';
import '../../../subdata/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
    on<OnSetAuthenticationStatus>(_onSetAuthenticationStatus);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = User(const Uuid().v4()); //await _tryGetUser();
        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  Future<void> _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    _authenticationRepository.logOut();

    // return emit(const AuthenticationState.unauthenticated());
  }

  Future<void> _onSetAuthenticationStatus(OnSetAuthenticationStatus event,
      Emitter<AuthenticationState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    final user = User(const Uuid().v4()); // await _tryGetUser();

    if (token.isEmpty) {
      await prefs.remove("user");

      _authenticationRepository.logOut();
    } else {
      // _authenticationRepository.setLoggedIn();
      ApiProvider _apiProvider = ApiProvider();
      bool result = await _apiProvider.refreshToken();

      if (result) {
        _authenticationRepository.setLoggedIn();
      } else {
        _authenticationRepository.logOut();
      }
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }
}
