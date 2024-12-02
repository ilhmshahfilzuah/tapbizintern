import 'package:bloc/bloc.dart';
import '../../../subconfig/AppSettings.dart';
import '../../../subdata/model/formz/ActivationCode.dart';
import '../../../subdata/model/formz/user_email.dart';
import '../../../subdata/model/user_model.dart';
import '../../../subdata/network/api_provider.dart';
import '../../../subdata/repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../subdata/model/formz/formzmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'logup_event.dart';
part 'logup_state.dart';

class LogupBloc extends Bloc<LogupEvent, LogupState> {
  late UserModel userCls;
  LogupBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LogupState()) {
    on<LogupUser_NameChanged>(_onUser_NameChanged);
    on<LogupUser_EmailChanged>(_onUser_EmailChanged);
    on<LogupPasswordChanged>(_onPasswordChanged);
    on<LogupActivationCodeChanged>(_onActivationCodeChanged);
    on<LogupSubmitted>(_onLogupSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  // -------------_onUser_NameChanged
  void _onUser_NameChanged(
    LogupUser_NameChanged event,
    Emitter<LogupState> emit,
  ) {
    final user_Name = User_Name.dirty(event.user_Name);
    emit(
      state.copyWith(
        user_Name: user_Name,
        isValid: Formz.validate([
          state.activationCode,
          user_Name,
          state.user_Email,
          state.password,
        ]),
      ),
    );
  }
  // -------------_onUser_NameChanged
  // -------------_onUser_EmailChanged
  void _onUser_EmailChanged(
    LogupUser_EmailChanged event,
    Emitter<LogupState> emit,
  ) {
    final user_Email = User_Email.dirty(event.user_Email);
    emit(
      state.copyWith(
        user_Email: user_Email,
        isValid: Formz.validate([
          state.activationCode,
          state.user_Name,
          user_Email,
          state.password,
        ]),
      ),
    );
  }

  // -------------_onUser_EmailChanged
  // -------------_onPasswordChanged
  void _onPasswordChanged(
    LogupPasswordChanged event,
    Emitter<LogupState> emit,
  ) {
    final password = User_KodKawasan.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.activationCode,
          state.user_Name,
          state.user_Email,
          password,
        ]),
      ),
    );
  }

  // -------------_onPasswordChanged
  // -------------_onActivationCodeChanged
  void _onActivationCodeChanged(
    LogupActivationCodeChanged event,
    Emitter<LogupState> emit,
  ) {
    final activationCode = ActivationCode.dirty(event.activationCode);
    emit(
      state.copyWith(
        activationCode: activationCode,
        isValid: Formz.validate([
          activationCode,
          state.user_Name,
          state.user_Email,
          state.password,
        ]),
      ),
    );
  }
  // -------------_onActivationCodeChanged

  // -------------_onLogupSubmitted
  Future<void> _onLogupSubmitted(
    LogupSubmitted event,
    Emitter<LogupState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // if (state.isValid) {
    try {
      // -----
      ApiProvider _apiProvider = ApiProvider();
      // -----

      // emit(LogupWaiting());
      try {
        var User_Email = event.user_Email;
        var Password = event.password;
        //--------
        var User_Name = event.user_Name;
        var activationCode = event.activationCode;
        

        //--------
        var Access_Flag = '';
        var Access_Cat = '1';
        var Access_CatSubIndex = '1';
        var postdata = {
          "fcm_token": '',
          'activationCode': activationCode,
          'User_Name': User_Name,
          'User_Email': User_Email,
          'Password': Password,
          'Auth_Type': AppSettings.Auth_Type,
          'Access_Flag': Access_Flag,
          'Access_Cat': Access_Cat,
          'Access_CatSubIndex': Access_CatSubIndex,
        };

        // -----
        final response = await _apiProvider.postConnect('register', postdata);
        print(response);
        print('-----');
        if (response.data['success'] == true) {
          final token = response.data['token'];
          final userModel = (response.data as Map<String, dynamic>)['user'];
          // -----
          Map<String, dynamic> map = userModel;
          String user = jsonEncode(map);

          final SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('token', token);
          await prefs.setString('user', user);


          print('-Stop');
          // -----

          // -----------------------
          await _authenticationRepository.logIn(
            username: state.user_Email.value,
            password: state.password.value,
          );
          // -----------------------

          return userModel;
        } else {
          throw response.data['message'];
        }
      } catch (ex) {
        if (ex != 'cancel') {
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        }
      }
      // -----
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
    // }
  }
  // -------------_onLogupSubmitted
}