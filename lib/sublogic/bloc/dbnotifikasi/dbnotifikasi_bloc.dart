import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import './bloc.dart';

import 'dart:convert';

class DbNotifikasiBloc extends Bloc<DbNotifikasiEvent, DbNotifikasiState> {
  DbNotifikasiBloc() : super(InitialDbNotifikasiState()) {
    on(_getDbNotifikasiWaiting);
    on<GetDbNotifikasi>(_getDbNotifikasi);
    on<UpdateDbNotifikasiStatus1>(_updateDbNotifikasiStatus1);

    // on<GetDbNotifikasiListByFav>(_getDbNotifikasiListByFav);
    // on<AddDbNotifikasiListByFav>(_addDbNotifikasiListByFav);
    // on<RemoveDbNotifikasiListByFav>(_removeDbNotifikasiListByFav);
  }
}

_getDbNotifikasiWaiting(GetDbNotifikasiWaiting event, Emitter<DbNotifikasiState> emit) {
  emit(GetDbNotifikasiWaiting());
}



// --------------Full Cover
void _getDbNotifikasi(GetDbNotifikasi event, Emitter<DbNotifikasiState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  emit(GetDbNotifikasiWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      
      // "flag": event.flag,
      // "IC_Pengguna": event.IC_Pengguna,
      "userId": event.ID_Pengguna
    };

    apiUrl = 'notifikasilogs/listNotifikasiByUser';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserNotifikasiLogs'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbNotifikasiSuccess(
      UserNotifikasiLogs: datajson,
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbNotifikasiError(errorMessage: ex.toString()));
    }
  }
}

// --------------Full Cover

void _updateDbNotifikasiStatus1(UpdateDbNotifikasiStatus1 event, Emitter<DbNotifikasiState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  try {
    late var postdata;
    late String apiUrl;
    //------------------dynamic
    postdata = {
      "notificationLogsId": event.notificationLogsId,
    };
    apiUrl = 'notifikasilogs/editNotifikasiStatus1';
    //------------------dynamic
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      // emit(GetDbNotifikasiSuccess());
    }
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbNotifikasiError(errorMessage: ex.toString()));
    }
  }
}





// --------------Notifikasi Fav
// void _getDbNotifikasiListByFav(GetDbNotifikasiListByFav event, Emitter<DbNotifikasiState> emit) async {
//   ApiProvider _apiProvider = ApiProvider();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   String kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
//   String namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
//   String kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
//   String namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
//   String kodDunQuery = prefs.getString('kodDunQuery') ?? '';
//   String namaDunQuery = prefs.getString('namaDunQuery') ?? '';
//   String kodDmQuery = prefs.getString('kodDmQuery') ?? '';
//   String namaDmQuery = prefs.getString('namaDmQuery') ?? '';
//   String kodLokQuery = prefs.getString('kodLokQuery') ?? '';
//   String namaLokQuery = prefs.getString('namaLokQuery') ?? '';
//   String kodCawQuery = prefs.getString('kodCawQuery') ?? '';
//   String namaCawQuery = prefs.getString('namaCawQuery') ?? '';

//   emit(GetDbNotifikasiWaiting());
//   try {
//     late var postdata;
//     late String apiUrl;

//     postdata = {
//       "flag": event.flag,
//       "IC_Pengguna": event.IC_Pengguna,
//     };

//     apiUrl = 'dbNotifikasi/getNotifikasiListByFav';

//     //---------------------------------------------------
//     final response = await _apiProvider.postConnect(apiUrl, postdata);
//     dynamic data;
//     if (response.data['success'] == true) {
//       data = (response.data as Map<String, dynamic>)['UserNotifikasiLogs'];
//     }
//     //------------------------------------------------------------
//     String datajson = jsonEncode(data);
//     emit(GetDbNotifikasiSuccess(
//       UserNotifikasiLogs: datajson,
//       //----
//       // JumNotifikasi: response.data['JumNotifikasi'],
//       //----
//       //----
//     ));
//     //------------------------------------------------------------
//   } catch (ex) {
//     if (ex != 'cancel') {
//       emit(GetDbNotifikasiError(errorMessage: ex.toString()));
//     }
//   }
// }

// void _addDbNotifikasiListByFav(AddDbNotifikasiListByFav event, Emitter<DbNotifikasiState> emit) async {
//   ApiProvider _apiProvider = ApiProvider();

//   emit(GetDbNotifikasiWaiting());
//   try {
//     late var postdata;
//     late String apiUrl;

//     postdata = {
//       "flag": event.flag,
//       "IC_Pengguna": event.IC_Pengguna,
//       "IC_Notifikasi": event.IC_Notifikasi,
//       "KodNegeri_Notifikasi": event.KodNegeri_Notifikasi,
//       "KodParlimen_Notifikasi": event.KodParlimen_Notifikasi,
//     };

//     apiUrl = 'dbNotifikasi/addNotifikasiListByFav';

//     //---------------------------------------------------
//     final response = await _apiProvider.postConnect(apiUrl, postdata);
//     dynamic data;
//     if (response.data['success'] == true) {
//       data = (response.data as Map<String, dynamic>)['UserSPRNotifikasiList'];
//     }
//     //------------------------------------------------------------
//     String datajson = jsonEncode(data);
//     emit(AddDbNotifikasiFavSuccess());
//     //------------------------------------------------------------
//   } catch (ex) {
//     if (ex != 'cancel') {
//       emit(GetDbNotifikasiError(errorMessage: ex.toString()));
//     }
//   }
// }
// void _removeDbNotifikasiListByFav(RemoveDbNotifikasiListByFav event, Emitter<DbNotifikasiState> emit) async {
//   ApiProvider _apiProvider = ApiProvider();

//   emit(GetDbNotifikasiWaiting());
//   try {
//     late var postdata;
//     late String apiUrl;

//     postdata = {
//       "flag": event.flag,
//       "IC_Pengguna": event.IC_Pengguna,
//       "IC_Notifikasi": event.IC_Notifikasi,
//     };

//     apiUrl = 'dbNotifikasi/removeNotifikasiListByFav';

//     //---------------------------------------------------
//     final response = await _apiProvider.postConnect(apiUrl, postdata);
//     dynamic data;
//     if (response.data['success'] == true) {
//       data = (response.data as Map<String, dynamic>)['UserSPRNotifikasiList'];
//     }
//     //------------------------------------------------------------
//     String datajson = jsonEncode(data);
//     emit(RemoveDbNotifikasiFavSuccess());
//     //------------------------------------------------------------
//   } catch (ex) {
//     if (ex != 'cancel') {
//       emit(GetDbNotifikasiError(errorMessage: ex.toString()));
//     }
//   }
// }
// --------------Notifikasi Fav