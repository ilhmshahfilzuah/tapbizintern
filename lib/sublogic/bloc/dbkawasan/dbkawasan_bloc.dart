import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc() : super(InitialDbKawasanState()) {
    on(_getDbKawasanWaiting);
    on<GetDbKawasan>(_getDbKawasan);
    on<GetDbKawasanQuery>(_getDbKawasanQuery);
  }
}

_getDbKawasanWaiting(GetDbKawasanWaiting event, Emitter<DbKawasanState> emit) {
  emit(GetDbKawasanWaiting());
}

// --------------Full Cover
void _getDbKawasan(GetDbKawasan event, Emitter<DbKawasanState> emit) async {
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

  // emit(GetDbKawasanWaiting());
  try {
    late var postdata;
    late String apiUrl;
    if (event.paparanQuery == 'Paparan Pusat') {
      if (event.paparanSubPusatQuery == 'Pusat Negeri') {
        postdata = {"flag": event.flag};
        apiUrl = 'dbKODKawasan/listKODState';
      }
      if (event.paparanSubPusatQuery == 'Pusat Parlimen') {
        postdata = {"flag": event.flag};
        apiUrl = 'dbKODKawasan/listKODArea';
      }
    }
    if (event.paparanQuery == 'Paparan Negeri') {
      if (event.paparanSubNQuery == 'Negeri Parlimen') {
        postdata = {"flag": event.flag, "stateCode": kodNegeriQuery, "stateName": namaNegeriQuery};
        apiUrl = 'dbKODKawasan/listKODStateArea';
      } else {
        postdata = {"flag": event.flag, "stateCode": kodNegeriQuery, "stateName": namaNegeriQuery};
        apiUrl = 'dbKODKawasan/listKODStateDun';
      }
    }
    if (event.paparanQuery == 'Paparan Parlimen/Bhgn') {
      if (event.paparanSubPQuery == 'Parlimen DUN') {
        postdata = {"flag": event.flag, "parlimenCode": kodParlimenQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDun';
      } else {
        postdata = {"flag": event.flag, "parlimenCode": kodParlimenQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDm';
      }
    }
    if (event.paparanQuery == 'Paparan Dun') {
      postdata = {"flag": event.flag, "dunCode": kodDunQuery};
      apiUrl = 'dbKODKawasan/listKODStateAreaDunDm';
    }
    if (event.paparanQuery == 'Paparan Dm') {
      if (event.paparanSubDmQuery == 'Dm Lok') {
        postdata = {"flag": event.flag, "dmCode": kodDmQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDunDmLok';
      } else {
        postdata = {"flag": event.flag, "dmCode": kodDmQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDunDmCaw';
      }
    }

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      if (event.paparanQuery == 'Paparan Pusat') {
        if (event.paparanSubPusatQuery == 'Pusat Negeri') {
          data = (response.data as Map<String, dynamic>)['DbState'];
        }
        if (event.paparanSubPusatQuery == 'Pusat Parlimen') {
          data = (response.data as Map<String, dynamic>)['DbArea'];
        }
      }
      if (event.paparanQuery == 'Paparan Negeri') {
        if (event.paparanSubNQuery == 'Negeri Parlimen') {
          data = (response.data as Map<String, dynamic>)['DbStateArea'];
        }
        if (event.paparanSubNQuery == 'Negeri DUN') {
          data = (response.data as Map<String, dynamic>)['DbStateDun'];
        }
      }
      if (event.paparanQuery == 'Paparan Parlimen/Bhgn') {
        if (event.paparanSubPQuery == 'Parlimen DUN') {
          data = (response.data as Map<String, dynamic>)['DbStateAreaDun'];
        } else {
          data = (response.data as Map<String, dynamic>)['DbStateAreaDm'];
        }
      }
      if (event.paparanQuery == 'Paparan Dun') {
        data = (response.data as Map<String, dynamic>)['DbStateAreaDunDm'];
      }
      if (event.paparanQuery == 'Paparan Dm') {
        if (event.paparanSubDmQuery == 'Dm Lok') {
          data = (response.data as Map<String, dynamic>)['DbStateAreaDunDmLok'];
        } else {
          data = (response.data as Map<String, dynamic>)['DbStateAreaDunDmCaw'];
        }
      }
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    if (event.paparanQuery == 'Paparan Dm') {
      emit(GetDbKawasanSuccess(
        listDbKawasan: datajson,
        //----
        JumPemilih: response.data['JumPemilih'],
        //----
        JumPemilihL: response.data['JumPemilihL'],
        JumPemilihLM: response.data['JumPemilihLM'],
        JumPemilihLM_40Bawah: response.data['JumPemilihLM_40Bawah'],
        JumPemilihLM_40Bawah_P: response.data['JumPemilihLM_40Bawah_P'],
        JumPemilihLM_40Bawah_K: response.data['JumPemilihLM_40Bawah_K'],
        JumPemilihLM_40Bawah_H: response.data['JumPemilihLM_40Bawah_H'],
        JumPemilihLM_40Bawah_T: response.data['JumPemilihLM_40Bawah_T'],
        JumPemilihLM_40Bawah_M: response.data['JumPemilihLM_40Bawah_M'],
        JumPemilihLM_40Bawah_Banci: response.data['JumPemilihLM_40Bawah_Banci'],
        JumPemilihLM_40Bawah_BBanci: response.data['JumPemilihLM_40Bawah_BBanci'],
        JumPemilihLM_40Bawah_Parti_Banci: response.data['JumPemilihLM_40Bawah_Parti_Banci'],
        JumPemilihLM_40Bawah_Parti_BBanci: response.data['JumPemilihLM_40Bawah_Parti_BBanci'],
        //----
        //----
        JumPemilihP: response.data['JumPemilihP'],
        JumPemilihPM: response.data['JumPemilihPM'],
        JumPemilihPM_40Bawah: response.data['JumPemilihPM_40Bawah'],
        JumPemilihPM_40Bawah_P: response.data['JumPemilihPM_40Bawah_P'],
        JumPemilihPM_40Bawah_K: response.data['JumPemilihPM_40Bawah_K'],
        JumPemilihPM_40Bawah_H: response.data['JumPemilihPM_40Bawah_H'],
        JumPemilihPM_40Bawah_T: response.data['JumPemilihPM_40Bawah_T'],
        JumPemilihPM_40Bawah_M: response.data['JumPemilihPM_40Bawah_M'],
        JumPemilihPM_40Bawah_Banci: response.data['JumPemilihPM_40Bawah_Banci'],
        JumPemilihPM_40Bawah_BBanci: response.data['JumPemilihPM_40Bawah_BBanci'],
        JumPemilihPM_40Bawah_Parti_Banci: response.data['JumPemilihPM_40Bawah_Parti_Banci'],
        JumPemilihPM_40Bawah_Parti_BBanci: response.data['JumPemilihPM_40Bawah_Parti_BBanci'],
        //----
      ));
    } else {
      emit(GetDbKawasanSuccess(
        listDbKawasan: datajson,
        //----
        JumPemilih: 0,
        //----
        JumPemilihL: 0,
        JumPemilihLM: 0,
        JumPemilihLM_40Bawah: 0,
        JumPemilihLM_40Bawah_P: 0,
        JumPemilihLM_40Bawah_K: 0,
        JumPemilihLM_40Bawah_H: 0,
        JumPemilihLM_40Bawah_T: 0,
        JumPemilihLM_40Bawah_M: 0,
        JumPemilihLM_40Bawah_Banci: 0,
        JumPemilihLM_40Bawah_BBanci: 0,
        JumPemilihLM_40Bawah_Parti_Banci: 0,
        JumPemilihLM_40Bawah_Parti_BBanci: 0,
        //----
        //----
        JumPemilihP: 0,
        JumPemilihPM: 0,
        JumPemilihPM_40Bawah: 0,
        JumPemilihPM_40Bawah_P: 0,
        JumPemilihPM_40Bawah_K: 0,
        JumPemilihPM_40Bawah_H: 0,
        JumPemilihPM_40Bawah_T: 0,
        JumPemilihPM_40Bawah_M: 0,
        JumPemilihPM_40Bawah_Banci: 0,
        JumPemilihPM_40Bawah_BBanci: 0,
        JumPemilihPM_40Bawah_Parti_Banci: 0,
        JumPemilihPM_40Bawah_Parti_BBanci: 0,
        //----
      ));
    }

    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbKawasanError(errorMessage: ex.toString()));
    }
  }
}
// --------------Full Cover

// --------------ByQuery
void _getDbKawasanQuery(GetDbKawasanQuery event, Emitter<DbKawasanState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  // emit(GetDbKawasanWaiting());
  try {
    late var postdata;
    late String apiUrl;
    if (event.kawasanQuery == 'N') {
      postdata = {"flag": event.flag};
      apiUrl = 'dbKODKawasan/listKODState';
    }
    if (event.kawasanQuery == 'P') {
      postdata = {"flag": event.flag, "stateCode": event.kawasanKodQuery};
      apiUrl = 'dbKODKawasan/listKODStateArea';
    }
    if (event.kawasanQuery == 'Dun') {
      postdata = {"flag": event.flag, "parlimenCode":event.kawasanKodQuery};
      apiUrl = 'dbKODKawasan/listKODStateAreaDun';
    }
    if (event.kawasanQuery == 'Dm') {
      postdata = {"flag": event.flag, "dunCode":event.kawasanKodQuery};
      apiUrl = 'dbKODKawasan/listKODStateAreaDunDm';
    }

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      if (event.kawasanQuery == 'N') {
        data = (response.data as Map<String, dynamic>)['DbState'];
      }
      if (event.kawasanQuery == 'P') {
        data = (response.data as Map<String, dynamic>)['DbStateArea'];
      }
      if (event.kawasanQuery == 'Dun') {
        data = (response.data as Map<String, dynamic>)['DbStateAreaDun'];
      }
      if (event.kawasanQuery == 'Dm') {
        data = (response.data as Map<String, dynamic>)['DbStateAreaDunDm'];
      }
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbKawasanQuerySuccess(
      listDbKawasan: datajson,
    ));

    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbKawasanError(errorMessage: ex.toString()));
    }
  }
}
// --------------ByQuery