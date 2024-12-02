import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbPemilihBloc extends Bloc<DbPemilihEvent, DbPemilihState> {
  DbPemilihBloc() : super(InitialDbPemilihState()) {
    on(_getDbPemilihWaiting);
    on<GetDbPemilih>(_getDbPemilih);
    on<GetDbPemilihListByJRJagaan>(_getDbPemilihListByJRJagaan);
    on<GetDbPemilihListByJCawJagaan>(_getDbPemilihListByJCawJagaan);
    
    
    on<GetDbPemilihListByFav>(_getDbPemilihListByFav);
    on<AddDbPemilihListByFav>(_addDbPemilihListByFav);
    on<RemoveDbPemilihListByFav>(_removeDbPemilihListByFav);

    on<GetDbPemilihListByWstL1>(_getDbPemilihListByWstL1);
    on<AddBlastQueDbPemilihListByWstL1>(_addBlastQueDbPemilihListByWstL1);
    on<GetDbPemilihListByWstL2>(_getDbPemilihListByWstL2);
    on<AddBlastQueDbPemilihListByWstL2>(_addBlastQueDbPemilihListByWstL2);

    on<AddDbPemilihListByWstL>(_addDbPemilihListByWstL);
    on<RemoveDbPemilihListByWstL>(_removeDbPemilihListByWstL);

    on<GetDbPemilihCheckIC>(_getDbPemilihCheckIC);

    on<UpdateDbPemilihUpdateSikap>(_updateDbPemilihUpdateSikap);
    on<UpdateDbPemilihUpdateStatus>(_updateDbPemilihUpdateStatus);
    on<UpdateDbPemilihUpdateSikapM>(_updateDbPemilihUpdateSikapM);

    on<UpdateDbPemilihUpdateNoTel>(_updateDbPemilihUpdateNoTel);
    on<UpdateDbPemilihUpdateCatatan>(_updateDbPemilihUpdateCatatan);
    on<UpdateDbPemilihUpdateMaklumatPenuh>(_updateDbPemilihUpdateMaklumatPenuh);
  }
}

_getDbPemilihWaiting(GetDbPemilihWaiting event, Emitter<DbPemilihState> emit) {
  emit(GetDbPemilihWaiting());
}

void _getDbPemilihCheckIC(GetDbPemilihCheckIC event, Emitter<DbPemilihState> emit) async {
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

  // String IC_Pemilih = prefs.getString('IC_Pemilih') ?? '';
  // String sikap = prefs.getString('sikap') ?? '';

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "KodDm_Pengguna": event.KodDm_Pengguna,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pemilih": event.IC_Pemilih,
    };

    apiUrl = 'dbPemilih/getDbPemilihCheckIC';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    late String semakICStatus;
    if (response.data['success'] == true) {
      semakICStatus = '1';
    } else {
      semakICStatus = '2';
    }
    //------------------------------------------------------------
    // String datajson = jsonEncode(data);
    // if (semakICStatus == '1') {
    emit(GetDbPemilihByICSuccess(
      semakICStatus: semakICStatus,
      semakICFavStatus: response.data['FavStatus'],
      semakICWstLStatus: response.data['WstLStatus'],
      Nama: response.data['Nama'],
      IC: response.data['IC'],
      Jantina: response.data['Jantina'],

      KodNegeri: response.data['KodNegeri'],
      KodDM: response.data['KodDM'],
      KodParlimen: response.data['KodParlimen'],
      NamaParlimen: response.data['NamaParlimen'],
      NamaDUN: response.data['NamaDUN'],
      NamaDM: response.data['NamaDM'],
      NamaLokaliti: response.data['NamaLokaliti'],

      NoSaluran: response.data['NoSaluran'],
      tm: response.data['tm'],

      ALAMAT1_JPN: response.data['ALAMAT1_JPN'],
      ALAMAT2_JPN: response.data['ALAMAT2_JPN'],
      ALAMAT3_JPN: response.data['ALAMAT3_JPN'],
      POSKOD_JPN: response.data['POSKOD_JPN'],
      BANDAR_JPN: response.data['BANDAR_JPN'],
      Sikap: response.data['Sikap'],
      Status: response.data['Status'],
      SikapM: response.data['SikapM'],
      NO_TEL_JPN: response.data['NO_TEL_JPN'],
      Catatan: response.data['Catatan'],
      HandbilDigitalTxt: response.data['HandbilDigitalTxt'],

      DataPetugasJR: response.data['dataPetugasJR'] ?? "",
      DataUserAccess: response.data['dataUserAccess'] ?? "",
      User_Kod_Kawasan: response.data['User_Kod_Kawasan'] ?? "",
      User_Kod_Keselamatan: response.data['User_Kod_Keselamatan'] ?? "",
      User_Kod_Laluan: response.data['User_Kod_Laluan'] ?? "",
      User_Kod_Laluan_Flag: response.data['User_Kod_Laluan_Flag'] ?? 0,
      PetugasJR_Negeri: response.data['PetugasJR_Negeri'] ?? "",
      PetugasJR_NamaParlimen: response.data['PetugasJR_NamaParlimen'] ?? "",
      PetugasJR_NamaDun: response.data['PetugasJR_NamaDun'] ?? "",
      PetugasJR_NamaDM: response.data['PetugasJR_NamaDM'] ?? "",
      PetugasJR_Jagaan: response.data['PetugasJR_Jagaan'] ?? 0,



      // HandbilDigitalTxt: Uri.encodeComponent("Salam Sejahtera\n${response.data['Nama']}.\n\nTahniah anda sebagai pengundi di PR Negeri ke 15.\n\nDisertakan butiran anda sebagai pemilih. Sila klik link berikut.\n\nhttps://v2-umno-platform.techworqsb.net/handbill?rec=${response.data['IC']}&par=${response.data['KodParlimen']}\n\n*Undilah Barisan Nasional*\nSelamat Mengundi"),
      // HandbilDigitalTxt: Uri.encodeComponent("Salam Sejahtera\n${response.data['Nama']}.\n\nTahniah anda sebagai pengundi di PR Negeri ke 15.\n\nDisertakan butiran anda sebagai pemilih. Sila klik link berikut.\n\nhttps://v2-umno-platform.techworqsb.net/handbill?rec=${response.data['IC']}&par=${response.data['KodParlimen']}\n\n*Undilah Barisan Nasional*\nSelamat Mengundi"),
    ));
    // }

    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihUpdateSikap(UpdateDbPemilihUpdateSikap event, Emitter<DbPemilihState> emit) async {
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
      emit(UpdateDbPemilihSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihUpdateStatus(UpdateDbPemilihUpdateStatus event, Emitter<DbPemilihState> emit) async {
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
      emit(UpdateDbPemilihSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbPemilihUpdateSikapM(UpdateDbPemilihUpdateSikapM event, Emitter<DbPemilihState> emit) async {
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
      emit(UpdateDbPemilihSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

_updateDbPemilihUpdateNoTel(UpdateDbPemilihUpdateNoTel event, Emitter<DbPemilihState> emit) async {
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
      emit(UpdateDbPemilihSuccess());
    }
    return;
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
    return;
  }
}

_updateDbPemilihUpdateCatatan(UpdateDbPemilihUpdateCatatan event, Emitter<DbPemilihState> emit) async {
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
      emit(UpdateDbPemilihSuccess());
    }
    return;
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
    return;
  }
}

void _updateDbPemilihUpdateMaklumatPenuh(UpdateDbPemilihUpdateMaklumatPenuh event, Emitter<DbPemilihState> emit) async {
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
      // emit(UpdateDbPemilihSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

// --------------Full Cover
void _getDbPemilih(GetDbPemilih event, Emitter<DbPemilihState> emit) async {
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

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "kodNegeri": kodNegeriQuery,
      "kodDm": kodDmQuery,
      "dataLok": event.dataFilterLokaliti,
      "dataJantina": event.dataFilterJantina,
      "dataKaum": event.dataFilterKaum,
      "dataUmur": event.dataFilterUG,
    };

    apiUrl = 'dbPemilih/chkUserJRPemilihListByLokJKU';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPemilihSuccess(
      listDbPemilih: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

// --------------Full Cover





// --------------Pemilih JR Jagaan
void _getDbPemilihListByJRJagaan(GetDbPemilihListByJRJagaan event, Emitter<DbPemilihState> emit) async {
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

  emit(GetDbPemilihFavWaiting());
  try {
    late var postdata;
    late String apiUrl;
    

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "kodParlimen": kodParlimenQuery,
      // "IC_Pengguna": '601105095004',
      // "kodParlimen": '001',
    };

    apiUrl = 'dbPemilih/getPemilihListByJRJagaan';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPemilihFavSuccess(
      listDbPemilih: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

// --------------Pemilih JR Jagaan
void _getDbPemilihListByJCawJagaan(GetDbPemilihListByJCawJagaan event, Emitter<DbPemilihState> emit) async {
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

  emit(GetDbPemilihFavWaiting());
  try {
    late var postdata;
    late String apiUrl;
    

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "kodParlimen": kodParlimenQuery,
      // "IC_Pengguna": '601105095004',
      // "kodParlimen": '001',
    };

    apiUrl = 'dbPemilih/getPemilihListByJCawJagaan';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPemilihFavSuccess(
      listDbPemilih: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

// --------------Pemilih Fav
void _getDbPemilihListByFav(GetDbPemilihListByFav event, Emitter<DbPemilihState> emit) async {
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

  emit(GetDbPemilihFavWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
    };

    apiUrl = 'dbPemilih/getPemilihListByFav';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPemilihFavSuccess(
      listDbPemilih: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

void _addDbPemilihListByFav(AddDbPemilihListByFav event, Emitter<DbPemilihState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pemilih": event.IC_Pemilih,
      "KodNegeri_Pemilih": event.KodNegeri_Pemilih,
      "KodParlimen_Pemilih": event.KodParlimen_Pemilih,
    };

    apiUrl = 'dbPemilih/addPemilihListByFav';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(AddDbPemilihFavSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
void _removeDbPemilihListByFav(RemoveDbPemilihListByFav event, Emitter<DbPemilihState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pemilih": event.IC_Pemilih,
    };

    apiUrl = 'dbPemilih/removePemilihListByFav';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(RemoveDbPemilihFavSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
// --------------Pemilih Fav


// --------------Pemilih WS Test List
void _getDbPemilihListByWstL1(GetDbPemilihListByWstL1 event, Emitter<DbPemilihState> emit) async {
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

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
    };

    apiUrl = 'dbPemilih/getPemilihListByWstL1';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPemilihSuccess(
      listDbPemilih: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
void _addBlastQueDbPemilihListByWstL1(AddBlastQueDbPemilihListByWstL1 event, Emitter<DbPemilihState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "Nama_Pemilih": event.Nama_Pemilih,
      "IC_Pemilih": event.IC_Pemilih,
      "NoTel_Pemilih": event.NoTel_Pemilih,
      "KodNegeri_Pemilih": event.KodNegeri_Pemilih,
      "KodParlimen_Pemilih": event.KodParlimen_Pemilih,
    };

    apiUrl = 'dbPemilih/addBlastQuePemilihListByWstL1';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(AddDbPemilihWstLSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
void _getDbPemilihListByWstL2(GetDbPemilihListByWstL2 event, Emitter<DbPemilihState> emit) async {
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

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
    };

    apiUrl = 'dbPemilih/getPemilihListByWstL2';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbPemilihSuccess(
      listDbPemilih: datajson,
      //----
      // JumPemilih: response.data['JumPemilih'],
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
void _addBlastQueDbPemilihListByWstL2(AddBlastQueDbPemilihListByWstL2 event, Emitter<DbPemilihState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "Nama_Pemilih": event.Nama_Pemilih,
      "IC_Pemilih": event.IC_Pemilih,
      "NoTel_Pemilih": event.NoTel_Pemilih,
      "KodNegeri_Pemilih": event.KodNegeri_Pemilih,
      "KodParlimen_Pemilih": event.KodParlimen_Pemilih,
    };

    apiUrl = 'dbPemilih/addBlastQuePemilihListByWstL2';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(AddDbPemilihWstLSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}

void _addDbPemilihListByWstL(AddDbPemilihListByWstL event, Emitter<DbPemilihState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "Nama_Pemilih": event.Nama_Pemilih,
      "IC_Pemilih": event.IC_Pemilih,
      "NoTel_Pemilih": event.NoTel_Pemilih,
      "KodNegeri_Pemilih": event.KodNegeri_Pemilih,
      "KodParlimen_Pemilih": event.KodParlimen_Pemilih,
    };

    apiUrl = 'dbPemilih/addPemilihListByWstL';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(AddDbPemilihWstLSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
void _removeDbPemilihListByWstL(RemoveDbPemilihListByWstL event, Emitter<DbPemilihState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  emit(GetDbPemilihWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      "flag": event.flag,
      "IC_Pengguna": event.IC_Pengguna,
      "IC_Pemilih": event.IC_Pemilih,
    };

    apiUrl = 'dbPemilih/removePemilihListByWstL';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserSPRPemilihList'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(RemoveDbPemilihWstLSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbPemilihError(errorMessage: ex.toString()));
    }
  }
}
// --------------Pemilih WS Test List

