import 'package:bloc/bloc.dart';
import '../../../subconfig/AppSettings.dart';
import '../../../subdata/model/user_model.dart';
import '../../../subdata/network/api_provider.dart';
import '../../../subdata/repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../subdata/model/formz/formzmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'logupdate_event.dart';
part 'logupdate_state.dart';

class LogupdateBloc extends Bloc<LogupdateEvent, LogupdateState> {
  late UserModel userCls;
  LogupdateBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LogupdateState()) {
    on<LogupdateUser_ICChanged>(_onUser_ICChanged);
    on<LogupdateSubmitted>(_onLogupdateSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  // -------------_onUser_ICChanged
  void _onUser_ICChanged(
    LogupdateUser_ICChanged event,
    Emitter<LogupdateState> emit,
  ) {
    final user_IC = User_IC.dirty(event.user_IC);
    emit(
      state.copyWith(
        user_IC: user_IC,
        isValid: Formz.validate(
            [user_IC, state.user_KodKawasan, state.user_KodKeselamatan, state.user_Pin]),
      ),
    );
  }

  // -------------_onUser_ICChanged
  // -------------_onUser_KodKawasanChanged
  void _onUser_KodKawasanChanged(
    LogupdateUser_KodKawasanChanged event,
    Emitter<LogupdateState> emit,
  ) {
    final user_KodKawasan = User_KodKawasan.dirty(event.user_KodKawasan);
    emit(
      state.copyWith(
        user_KodKawasan: user_KodKawasan,
        isValid: Formz.validate(
            [state.user_IC, user_KodKawasan, state.user_KodKeselamatan, state.user_Pin]),
      ),
    );
  }

  // -------------_onUser_KodKawasanChanged
  // -------------_onUser_KodKeselamatanChanged
  void _onUser_KodKeselamatanChanged(
    LogupdateUser_KodKeselamatanChanged event,
    Emitter<LogupdateState> emit,
  ) {
    final user_KodKeselamatan =
        User_KodKeselamatan.dirty(event.user_KodKeselamatan);
    emit(
      state.copyWith(
        user_KodKeselamatan: user_KodKeselamatan,
        isValid: Formz.validate(
            [state.user_IC, state.user_KodKawasan, user_KodKeselamatan, state.user_Pin]),
      ),
    );
  }
  // -------------_onUser_KodKeselamatanChanged
  // -------------_onUser_PinChanged
  void _onUser_PinChanged(
    LogupdateUser_PinChanged event,
    Emitter<LogupdateState> emit,
  ) {
    final user_Pin =
        User_Pin.dirty(event.user_Pin);
    emit(
      state.copyWith(
        user_Pin: user_Pin,
        isValid: Formz.validate(
            [state.user_IC, state.user_KodKawasan, state.user_KodKeselamatan, user_Pin]),
      ),
    );
  }
  // -------------_onUser_KodKeselamatanChanged

  // -------------_onLogupdateSubmitted
  Future<void> _onLogupdateSubmitted(
    LogupdateSubmitted event,
    Emitter<LogupdateState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // if (state.isValid) {
    try {
      // -----
      ApiProvider _apiProvider = ApiProvider();
      // -----

      // emit(LogupdateWaiting());
      try {
        var User_IC = event.user_IC;
        //--------
        var Access_Flag = '';
        var Access_Cat = '1';
        var Access_CatSubIndex = '1';

        var postdata = {
          "fcm_token": '',
          'User_IC': User_IC,
          'Pin': User_Pin,
          'Auth_Type': AppSettings.Auth_Type,
          'Access_Flag': Access_Flag,
          'Access_Cat': Access_Cat,
          'Access_CatSubIndex': Access_CatSubIndex,
        };

        // -----
        final response = await _apiProvider.postConnect(
            'userEditKodKawasanKeselamatan', postdata);
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
  // -------------_onLogupdateSubmitted
}


// emit(
//       state.copyWith(
//         password: password,
//         isValid: Formz.validate([password, state.username]),
//       ),
//     );