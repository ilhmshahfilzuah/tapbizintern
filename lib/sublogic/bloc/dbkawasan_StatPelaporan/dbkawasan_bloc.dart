import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc_StatPelaporan extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc_StatPelaporan() : super(InitialDbKawasanState()) {
    on(_getDbKawasanWaiting);
    on<GetDbKawasan>(_getDbKawasan);
  }
}

_getDbKawasanWaiting(GetDbKawasanWaiting event, Emitter<DbKawasanState> emit) {emit(GetDbKawasanWaiting());}
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

  emit(GetDbKawasanWaiting());
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
      emit(GetDbKawasanSuccess(
        listDbKawasan: datajson,
        //----
        JumNegeri: response.data['JumNegeri'],
        JumParlimen: response.data['JumParlimen'],
        JumDUN: response.data['JumDUN'],
        JumDM: response.data['JumDM'],
        JumLokaliti: response.data['JumLokaliti'],
        JumPemilih: response.data['JumPemilih'],
        JumIsuAll: response.data['JumIsuAll'],  
        JumIsu0: response.data['JumIsu0'],  
        JumIsu1: response.data['JumIsu1'],  
        JumIsu2: response.data['JumIsu2'],  
        JumIsu3: response.data['JumIsu3'],  
        JumIsu4: response.data['JumIsu4'],  
        JumIsu5: response.data['JumIsu5'],  
        //----
      ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbKawasanError(errorMessage: ex.toString()));
    }
  }
}
// --------------Full Cover