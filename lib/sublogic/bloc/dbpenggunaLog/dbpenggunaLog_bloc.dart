import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbPenggunaLogBloc extends Bloc<DbPenggunaLogEvent, DbPenggunaLogState> {
  DbPenggunaLogBloc() : super(InitialDbPenggunaLogState()) {
    on(_getDbPenggunaLogWaiting);
    on<GetDbPenggunaLog_ByPengundi>(_getDbPenggunaLog_ByPengundi);
    on<GetDbPenggunaLog_ByPeringkat>(_getDbPenggunaLog_ByPeringkat);

    on<GetDbPenggunaLog_ByPeringkat_Daftar>(_getDbPenggunaLog_ByPeringkat_Daftar);
    on<GetDbPenggunaLog_ByPeringkat_Pelaporan>(_getDbPenggunaLog_ByPeringkat_Pelaporan);
  }
}

_getDbPenggunaLogWaiting(GetDbPenggunaLogWaiting event, Emitter<DbPenggunaLogState> emit) {
  emit(GetDbPenggunaLogWaiting());
}

// --------------Full Cover
void _getDbPenggunaLog_ByPengundi(GetDbPenggunaLog_ByPengundi event, Emitter<DbPenggunaLogState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPenggunaLogWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pengundi": event.IC_Pengundi,
    };

    apiUrl = 'dbPenggunaLog/getPenggunaLog_ByPengundi';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['dbPenggunaLog'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPenggunaLogSuccess(
      listDbPenggunaLog: datajson,
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPenggunaLogError(errorMessage: ex.toString()));
    }
  }
}

void _getDbPenggunaLog_ByPeringkat(GetDbPenggunaLog_ByPeringkat event, Emitter<DbPenggunaLogState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String paparanQuery = prefs.getString('paparanQuery') ?? '';
  String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
  String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
  String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
  String kodDmQuery = prefs.getString('kodDmQuery') ?? '';

  emit(GetDbPenggunaLogWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": 'buck',
      "paparanQuery": paparanQuery,
      "kodNegeriQuery": kodNegeriQuery,
      "kodParlimenQuery": kodParlimenQuery,
      "kodDunQuery": kodDunQuery,
      "kodDmQuery": kodDmQuery,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pengundi": event.IC_Pengundi,
    };

    apiUrl = 'dbPenggunaLog/getPenggunaLog_ByPeringkat';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['dbPenggunaLog'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPenggunaLogSuccess(
      listDbPenggunaLog: datajson,
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPenggunaLogError(errorMessage: ex.toString()));
    }
  }
}

void _getDbPenggunaLog_ByPeringkat_Daftar(GetDbPenggunaLog_ByPeringkat_Daftar event, Emitter<DbPenggunaLogState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String paparanQuery = prefs.getString('paparanQuery') ?? '';
  String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
  String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
  String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
  String kodDmQuery = prefs.getString('kodDmQuery') ?? '';

  emit(GetDbPenggunaLogWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": 'buck',
      "paparanQuery": paparanQuery,
      "kodNegeriQuery": kodNegeriQuery,
      "kodParlimenQuery": kodParlimenQuery,
      "kodDunQuery": kodDunQuery,
      "kodDmQuery": kodDmQuery,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pengundi": event.IC_Pengundi,
    };

    apiUrl = 'dbPenggunaLog/getPenggunaLog_ByPeringkat_Daftar';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['dbPenggunaLog'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPenggunaLog_Daftar_Success(
      listDbPenggunaLog: datajson,
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPenggunaLogError(errorMessage: ex.toString()));
    }
  }
}

void _getDbPenggunaLog_ByPeringkat_Pelaporan(GetDbPenggunaLog_ByPeringkat_Pelaporan event, Emitter<DbPenggunaLogState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String paparanQuery = prefs.getString('paparanQuery') ?? '';
  String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
  String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
  String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
  String kodDmQuery = prefs.getString('kodDmQuery') ?? '';

  emit(GetDbPenggunaLogWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": 'buck',
      "paparanQuery": paparanQuery,
      "kodNegeriQuery": kodNegeriQuery,
      "kodParlimenQuery": kodParlimenQuery,
      "kodDunQuery": kodDunQuery,
      "kodDmQuery": kodDmQuery,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pengundi": event.IC_Pengundi,
    };

    apiUrl = 'dbPenggunaLog/getPenggunaLog_ByPeringkat_Pelaporan';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['dbPenggunaLog'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPenggunaLog_Pelaporan_Success(
      listDbPenggunaLog: datajson,
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPenggunaLogError(errorMessage: ex.toString()));
    }
  }
}
// --------------Full Cover
