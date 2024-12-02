import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbPetugasJRJPMBloc extends Bloc<DbPetugasJRJPMEvent, DbPetugasJRJPMState> {
  DbPetugasJRJPMBloc() : super(InitialDbPetugasJRJPMState()) {
    on(_getDbPetugasJRJPMWaiting);
    on<GetDbPetugasJR>(_getDbPetugasJR);
    on<GetDbPetugasJPMPemuda>(_getDbPetugasJPMPemuda);
    on<GetDbPetugasJPMPuteri>(_getDbPetugasJPMPuteri);
    // on<GetDbPetugasJPM_Pemuda>(_getDbPetugasJPM_Pemuda);
    // on<GetDbPetugasJPM_Puteri>(_getDbPetugasJPM_Puteri);
  }
}

_getDbPetugasJRJPMWaiting(GetDbPetugasJRJPMWaiting event, Emitter<DbPetugasJRJPMState> emit) {
  emit(GetDbPetugasJRJPMWaiting());
}


void _getDbPetugasJR(GetDbPetugasJR event, Emitter<DbPetugasJRJPMState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
  String namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
  String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
  String namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
  String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
  String namaDunQuery = prefs.getString('namaDunQuery') ?? '';
  String kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  String namaDmQuery = prefs.getString('namaDmQuery') ?? '';
  String kodLokQuery = prefs.getString('kodLokQuery') ?? '';
  String namaLokQuery = prefs.getString('namaLokQuery') ?? '';
  String kodCawQuery = prefs.getString('kodCawQuery') ?? '';
  String namaCawQuery = prefs.getString('namaCawQuery') ?? '';

  emit(GetDbPetugasJRJPMWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "kodDM": kodDmQuery,
    };

    apiUrl = 'dbPetugasJR/chkUserJRDmList';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['PetugasJRDmList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPetugasJRSuccess(
      listDbPetugasJR: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPetugasJRJPMError(errorMessage: ex.toString()));
    }
  }
}

void _getDbPetugasJPMPemuda(GetDbPetugasJPMPemuda event, Emitter<DbPetugasJRJPMState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
  String namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
  String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
  String namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
  String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
  String namaDunQuery = prefs.getString('namaDunQuery') ?? '';
  String kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  String namaDmQuery = prefs.getString('namaDmQuery') ?? '';
  String kodLokQuery = prefs.getString('kodLokQuery') ?? '';
  String namaLokQuery = prefs.getString('namaLokQuery') ?? '';
  String kodCawQuery = prefs.getString('kodCawQuery') ?? '';
  String namaCawQuery = prefs.getString('namaCawQuery') ?? '';

  emit(GetDbPetugasJRJPMWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "kodDM": kodDmQuery,
    };

    apiUrl = 'dbPetugasJPM/chkUserJPMPemudaDmList';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['PetugasJPMDmList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPetugasJPMPemudaSuccess(
      listDbPetugasJR: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPetugasJRJPMError(errorMessage: ex.toString()));
    }
  }
}
void _getDbPetugasJPMPuteri(GetDbPetugasJPMPuteri event, Emitter<DbPetugasJRJPMState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
  String namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
  String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
  String namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
  String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
  String namaDunQuery = prefs.getString('namaDunQuery') ?? '';
  String kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  String namaDmQuery = prefs.getString('namaDmQuery') ?? '';
  String kodLokQuery = prefs.getString('kodLokQuery') ?? '';
  String namaLokQuery = prefs.getString('namaLokQuery') ?? '';
  String kodCawQuery = prefs.getString('kodCawQuery') ?? '';
  String namaCawQuery = prefs.getString('namaCawQuery') ?? '';

  emit(GetDbPetugasJRJPMWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "kodDM": kodDmQuery,
    };

    apiUrl = 'dbPetugasJPM/chkUserJPMPuteriDmList';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['PetugasJPMDmList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPetugasJPMPuteriSuccess(
      listDbPetugasJR: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPetugasJRJPMError(errorMessage: ex.toString()));
    }
  }
}