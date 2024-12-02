import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbPemilihCrudBloc extends Bloc<DbPemilihCrudEvent, DbPemilihCrudState> {
  DbPemilihCrudBloc() : super(InitialDbPemilihCrudState()) {
    on(_getDbPemilihCrudWaiting);

    on<UpdateDbPemilihCrudUpdateSikap_Caw>(_updateDbPemilihCrudUpdateSikap_Caw);
    on<UpdateDbPemilihCrudUpdateStatus_Caw>(_updateDbPemilihCrudUpdateStatus_Caw);
    
    on<UpdateDbPemilihCrudUpdateSikap>(_updateDbPemilihCrudUpdateSikap);
    on<UpdateDbPemilihCrudUpdateStatus>(_updateDbPemilihCrudUpdateStatus);

    on<UpdateDbPemilihCrudUpdateKawasan_Luar>(_updateDbPemilihCrudUpdateKawasan_Luar);
    on<UpdateDbPemilihCrudUpdateSikapM>(_updateDbPemilihCrudUpdateSikapM);
    on<UpdateDbPemilihCrudUpdateSikapM_myjr>(_updateDbPemilihCrudUpdateSikapM_myjr);

    on<UpdateDbPemilihCrudUpdateHB1>(_updateDbPemilihCrudUpdateHB1);
    on<UpdateDbPemilihCrudUpdateHB2>(_updateDbPemilihCrudUpdateHB2);

    on<UpdateDbPemilihCrudUpdateHadir>(_updateDbPemilihCrudUpdateHadir);
    on<UpdateDbPemilihCrudUpdateHadir2>(_updateDbPemilihCrudUpdateHadir2);
    on<UpdateDbPemilihCrudUpdateNoTel>(_updateDbPemilihCrudUpdateNoTel);
    on<UpdateDbPemilihCrudUpdateCatatan>(_updateDbPemilihCrudUpdateCatatan);
    on<UpdateDbPemilihCrudUpdateMaklumatPenuh>(_updateDbPemilihCrudUpdateMaklumatPenuh);
  }
}

_getDbPemilihCrudWaiting(GetDbPemilihCrudWaiting event, Emitter<DbPemilihCrudState> emit) {
  emit(GetDbPemilihCrudWaiting());
}

void _updateDbPemilihCrudUpdateSikap_Caw(UpdateDbPemilihCrudUpdateSikap_Caw event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "sikap_Caw": event.sikap_Caw,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihSikap_Caw';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateStatus_Caw(UpdateDbPemilihCrudUpdateStatus_Caw event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "status_Caw": event.status_Caw,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihStatus_Caw';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateSikap(UpdateDbPemilihCrudUpdateSikap event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "sikap": event.sikap,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihSikap';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateStatus(UpdateDbPemilihCrudUpdateStatus event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "status": event.status,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihStatus';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateKawasan_Luar(UpdateDbPemilihCrudUpdateKawasan_Luar event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "Kawasan_Luar": event.Kawasan_Luar,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihKawasan_Luar';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateSikapM(UpdateDbPemilihCrudUpdateSikapM event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "sikapM": event.sikapM,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihSikapM';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateSikapM_myjr(UpdateDbPemilihCrudUpdateSikapM_myjr event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "sikapM": event.sikapM,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihSikapM_myjr';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

_updateDbPemilihCrudUpdateNoTel(UpdateDbPemilihCrudUpdateNoTel event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "NoTel": event.NoTel,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihNoTel';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    return;
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
    return;
  }
}

_updateDbPemilihCrudUpdateCatatan(UpdateDbPemilihCrudUpdateCatatan event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "Catatan": event.Catatan,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihCatatan';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    return;
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
    return;
  }
}

void _updateDbPemilihCrudUpdateMaklumatPenuh(UpdateDbPemilihCrudUpdateMaklumatPenuh event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "NoTel": event.NoTel,
      "KodRumah": event.KodRumah,
      "Alamat1": event.Alamat1,
      "Alamat2": event.Alamat2,
      "Alamat3": event.Alamat3,
      "Alamat_Poskod": event.Alamat_Poskod,
      "Alamat_Bandar": event.Alamat_Bandar,
      "Alamat_Negeri": event.Alamat_Negeri,
      "Catatan": event.Catatan,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihMaklumatPenuh';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateHB1(UpdateDbPemilihCrudUpdateHB1 event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "HB1": event.hb1,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihHB1';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateHB2(UpdateDbPemilihCrudUpdateHB2 event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "HB2": event.hb2,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihHB2';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateHadir(UpdateDbPemilihCrudUpdateHadir event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  late String kodTMQuery;
  
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
    kodTMQuery = prefs.getString('kodTMQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
    kodTMQuery = event.KodTMQuery;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "kodTm": kodTMQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "Hadir": event.hadir,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihHadir';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihCrudUpdateHadir2(UpdateDbPemilihCrudUpdateHadir2 event, Emitter<DbPemilihCrudState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  late String kodNegeriQuery;
  late String kodDmQuery;
  if (event.KodDm_Pemilih == '') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
  } else {
    kodNegeriQuery = event.KodNegeri_Pemilih;
    kodDmQuery = event.KodDm_Pemilih;
  }
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "IC_Pemilih": event.IC_Pemilih,
      "Hadir2": event.hadir2,
    };
    apiUrl = 'dbPemilih/updateUserJRPemilihHadir2';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      emit(UpdateDbPemilihCrudSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihCrudError(errorMessage: ex.toString()));
    }
  }
}
