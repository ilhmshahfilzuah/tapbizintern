import 'package:bloc/bloc.dart';
import '../../../subconfig/AppSettings.dart';
import '../../../subdata/model/formz/user_katalaluan.dart';
import '../../../subdata/model/user_model.dart';
import '../../../subdata/network/api_provider.dart';
import '../../../subdata/repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../subdata/model/formz/formzmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late UserModel userCls;
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    // on<LoginUsernameChanged>(_onUsernameChanged);
    // on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginUser_ICChanged>(_onUser_ICChanged);
    on<LoginUser_KodKawasanChanged>(_onUser_KodKawasanChanged);
    on<LoginUser_PinChanged>(_onUser_PinChanged);
    on<LoginUser_KataLaluanChanged>(_onUser_KataLaluanChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  // -------------_onUser_ICChanged
  void _onUser_ICChanged(
    LoginUser_ICChanged event,
    Emitter<LoginState> emit,
  ) {
    final user_IC = User_IC.dirty(event.user_IC);
    //------------
    if (AppSettings.Auth_Type == 'PIN') {
      emit(
        state.copyWith(
          user_IC: user_IC,
          isValid: Formz.validate([user_IC, state.user_KodKawasan, state.user_Pin]),
        ),
      );
    } else {
      if (AppSettings.AppKey == 'myJR') {
        emit(
          state.copyWith(
            user_IC: user_IC,
            isValid: Formz.validate([user_IC, state.user_KataLaluan]),
          ),
        );
      } else {
        emit(
          state.copyWith(
            user_IC: user_IC,
            isValid: Formz.validate([user_IC, state.user_KodKawasan]),
          ),
        );
      }
    }
    //------------
  }

  // -------------_onUser_ICChanged
  // -------------_onUser_KodKawasanChanged
  void _onUser_KodKawasanChanged(
    LoginUser_KodKawasanChanged event,
    Emitter<LoginState> emit,
  ) {
    final user_KodKawasan = User_KodKawasan.dirty(event.user_KodKawasan);
    //------------
    if (AppSettings.Auth_Type == 'PIN') {
      emit(
        state.copyWith(
          user_KodKawasan: user_KodKawasan,
          isValid: Formz.validate([state.user_IC, user_KodKawasan, state.user_Pin]),
        ),
      );
    } else {
      emit(
        state.copyWith(
          user_KodKawasan: user_KodKawasan,
          isValid: Formz.validate([state.user_IC, user_KodKawasan]),
        ),
      );
    }
    //------------
  }

  // -------------_onUser_KodKawasanChanged
  // -------------_onUser_PINChanged
  void _onUser_PinChanged(
    LoginUser_PinChanged event,
    Emitter<LoginState> emit,
  ) {
    final user_Pin = User_Pin.dirty(event.user_Pin);
    //------------
    if (AppSettings.Auth_Type == 'PIN') {
      emit(
        state.copyWith(
          user_Pin: user_Pin,
          isValid: Formz.validate([state.user_IC, state.user_KodKawasan, user_Pin]),
        ),
      );
    } else {
      emit(
        state.copyWith(
          user_Pin: user_Pin,
          isValid: Formz.validate([state.user_IC, state.user_KodKawasan]),
        ),
      );
    }
    //------------
  }

  // -------------_onUser_KataLaluanChanged
  void _onUser_KataLaluanChanged(
    LoginUser_KataLaluanChanged event,
    Emitter<LoginState> emit,
  ) {
    final user_KataLaluan = User_KataLaluan.dirty(event.user_KataLaluan);
    //------------
      emit(
        state.copyWith(
          user_KataLaluan: user_KataLaluan,
          isValid: Formz.validate([state.user_IC, user_KataLaluan]),
        ),
      );
    //------------
  }

  // -------------_onLoginSubmitted
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // if (state.isValid) {
    try {
      // -----
      ApiProvider _apiProvider = ApiProvider();
      // -----

      // emit(LoginWaiting());
      try {
        var User_IC = event.user_IC;
        var User_Kod_Kawasan = event.user_KodKawasan;
        var User_Pin = event.user_Pin;
        var User_KataLaluan = event.user_KataLaluan;
        var Access_Flag = '';
        var Access_Cat = '1';
        var Access_CatSubIndex = '1';

        if (User_KataLaluan != '') {
          Access_Cat = '0';
          Access_CatSubIndex = '0';
        }

        var postdata = {
          "fcm_token": '',
          'User_IC': User_IC,
          'User_Kod_Kawasan': User_Kod_Kawasan,
          'Pin': User_Pin,
          'User_Kod_Laluan': User_KataLaluan,
          'Auth_Type': AppSettings.Auth_Type,
          'Access_Flag': Access_Flag,
          'Access_Cat': Access_Cat,
          'Access_CatSubIndex': Access_CatSubIndex,
        };

        // -----
        final response = await _apiProvider.postConnect('login', postdata);
        print(response);
        print('-----');
        if (response.data['success'] == true) {
          final token = response.data['token'];
          final isDDay = response.data['isDDay'];
          final userModel = (response.data as Map<String, dynamic>)['user'];
          // -----
          Map<String, dynamic> map = userModel;
          String user = jsonEncode(map);

          final SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('token', token);
          await prefs.setBool('isDDay', isDDay);
          await prefs.setString('user', user);

          await prefs.setString('accessCat', Access_Cat);
          if (Access_Cat == '0') {
            await prefs.setString('accessCatSubIndex', '-');
          } else {
            await prefs.setString('accessCatSubIndex', '');
          }

          await prefs.setString('kodNegeri', "");
          await prefs.setString('namaNegeri', "");
          await prefs.setString('kodParlimen', "");
          await prefs.setString('namaParlimen', "");
          await prefs.setString('kodDun', "");
          await prefs.setString('namaDun', "");
          await prefs.setString('kodDm', "");
          await prefs.setString('namaDm', "");
          await prefs.setString('kodLok', "");
          await prefs.setString('namaLok', "");

          await prefs.setString('kodNegeriQuery', "");
          await prefs.setString('namaNegeriQuery', "");
          await prefs.setString('kodParlimenQuery', "");
          await prefs.setString('namaParlimenQuery', "");
          await prefs.setString('kodDunQuery', "");
          await prefs.setString('namaDunQuery', "");
          await prefs.setString('kodDmQuery', "");
          await prefs.setString('namaDmQuery', "");
          await prefs.setString('kodLokQuery', "");
          await prefs.setString('namaLokQuery', "");

          await prefs.setString('PinNama', "");
          await prefs.setString('PinNamaQuery', "");

          print('-Stop');
          // -----

          // -----------------------
          await _authenticationRepository.logIn(
            username: state.user_IC.value,
            password: state.user_KodKawasan.value,
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
  // -------------_onLoginSubmitted
}

// emit(
//       state.copyWith(
//         password: password,
//         isValid: Formz.validate([password, state.username]),
//       ),
//     );
