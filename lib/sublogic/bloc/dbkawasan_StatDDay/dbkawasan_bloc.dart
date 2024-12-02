import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc_StatDDay extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc_StatDDay() :super(InitialDbKawasanState()) {
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
        postdata = {"flag":event.flag};
        apiUrl = 'dbKODKawasan/listKODState';
      }
      if (event.paparanSubPusatQuery == 'Pusat Parlimen') {
        postdata = {"flag":event.flag};
        apiUrl = 'dbKODKawasan/listKODArea';
      }
    }
    if (event.paparanQuery == 'Paparan Negeri') {
      if (event.paparanSubNQuery == 'Negeri Parlimen') {
        postdata = {"flag":event.flag, "stateCode":kodNegeriQuery, "stateName":namaNegeriQuery};
        apiUrl = 'dbKODKawasan/listKODStateArea';
      } else {
        postdata = {"flag":event.flag, "stateCode":kodNegeriQuery, "stateName":namaNegeriQuery};
        apiUrl = 'dbKODKawasan/listKODStateDun';
      }
    }
    if (event.paparanQuery == 'Paparan Parlimen/Bhgn') {
      if (event.paparanSubPQuery == 'Parlimen DUN') {
        postdata = {"flag":event.flag, "parlimenCode":kodParlimenQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDun';
      } else {
        postdata = {"flag":event.flag, "parlimenCode":kodParlimenQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDm';
      }
    }
    if (event.paparanQuery == 'Paparan Dun') {
      postdata = {"flag":event.flag, "dunCode":kodDunQuery};
      apiUrl = 'dbKODKawasan/listKODStateAreaDunDm';
    }
    if (event.paparanQuery == 'Paparan Dm') {
      if (event.paparanSubDmQuery == 'Dm Lok') {
        postdata = {"flag":event.flag, "dmCode":kodDmQuery};
        apiUrl = 'dbKODKawasan/listKODStateAreaDunDmLok';
      } else {
        postdata = {"flag":event.flag, "dmCode":kodDmQuery};
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
        listDbKawasan:datajson,
        //----
        JumNegeri:response.data['JumNegeri'],
        JumParlimen:response.data['JumParlimen'],
        JumDUN:response.data['JumDUN'],
        JumDM:response.data['JumDM'],
        JumLokaliti:response.data['JumLokaliti'],
        JumPemilih:response.data['JumPemilih'], 
        //----
        JumPemilihAwal:response.data['JumPemilihAwal']??0,
        JumPemilihAwalHadir:response.data['JumPemilihAwalHadir']??0,
        JumPemilihHadir:response.data['JumPemilihHadir']??0,
        JumPemilihTHadir:response.data['JumPemilihTHadir']??0,
        JumPemilihLelaki:response.data['JumPemilihLelaki']??0,
        JumPemilihPerempuan:response.data['JumPemilihPerempuan']??0,
        JumPemilihLelaki_Hadir:response.data['JumPemilihLelaki_Hadir']??0,
        JumPemilihPerempuan_Hadir:response.data['JumPemilihPerempuan_Hadir']??0,
        JumPemilihLelaki_THadir:response.data['JumPemilihLelaki_THadir']??0,
        JumPemilihPerempuan_THadir:response.data['JumPemilihPerempuan_THadir']??0,
        JumPemilihLelaki_P:response.data['JumPemilihLelaki_P']??0,
        JumPemilihPerempuan_P:response.data['JumPemilihPerempuan_P']??0,
        JumPemilihLelaki_P_Hadir:response.data['JumPemilihLelaki_P_Hadir']??0,
        JumPemilihPerempuan_P_Hadir:response.data['JumPemilihPerempuan_P_Hadir']??0,
        JumPemilihLelaki_P_THadir:response.data['JumPemilihLelaki_P_THadir']??0,
        JumPemilihPerempuan_P_THadir:response.data['JumPemilihPerempuan_P_THadir']??0,
        JumPemilihM:response.data['JumPemilihM']??0,
        JumPemilihC:response.data['JumPemilihC']??0,
        JumPemilihI:response.data['JumPemilihI']??0,
        JumPemilihL:response.data['JumPemilihL']??0,
        JumPemilihM_Hadir:response.data['JumPemilihM_Hadir']??0,
        JumPemilihC_Hadir:response.data['JumPemilihC_Hadir']??0,
        JumPemilihI_Hadir:response.data['JumPemilihI_Hadir']??0,
        JumPemilihL_Hadir:response.data['JumPemilihL_Hadir']??0,
        JumPemilihM_THadir:response.data['JumPemilihM_THadir']??0,
        JumPemilihC_THadir:response.data['JumPemilihC_THadir']??0,
        JumPemilihI_THadir:response.data['JumPemilihI_THadir']??0,
        JumPemilihL_THadir:response.data['JumPemilihL_THadir']??0,
        JumPemilihM_P:response.data['JumPemilihM_P']??0,
        JumPemilihC_P:response.data['JumPemilihC_P']??0,
        JumPemilihI_P:response.data['JumPemilihI_P']??0,
        JumPemilihL_P:response.data['JumPemilihL_P']??0,
        JumPemilihM_P_Hadir:response.data['JumPemilihM_P_Hadir']??0,
        JumPemilihC_P_Hadir:response.data['JumPemilihC_P_Hadir']??0,
        JumPemilihI_P_Hadir:response.data['JumPemilihI_P_Hadir']??0,
        JumPemilihL_P_Hadir:response.data['JumPemilihL_P_Hadir']??0,
        JumPemilihM_P_THadir:response.data['JumPemilihM_P_THadir']??0,
        JumPemilihC_P_THadir:response.data['JumPemilihC_P_THadir']??0,
        JumPemilihI_P_THadir:response.data['JumPemilihI_P_THadir']??0,
        JumPemilihL_P_THadir:response.data['JumPemilihL_P_THadir']??0,
        JumPemilihU0:response.data['JumPemilihU0']??0,
        JumPemilihU1:response.data['JumPemilihU1']??0,
        JumPemilihU2:response.data['JumPemilihU2']??0,
        JumPemilihU3:response.data['JumPemilihU3']??0,
        JumPemilihU4:response.data['JumPemilihU4']??0,
        JumPemilihU5:response.data['JumPemilihU5']??0,
        JumPemilihU6:response.data['JumPemilihU6']??0,
        JumPemilihU7:response.data['JumPemilihU7']??0,
        JumPemilihU0_Hadir:response.data['JumPemilihU0_Hadir']??0,
        JumPemilihU1_Hadir:response.data['JumPemilihU1_Hadir']??0,
        JumPemilihU2_Hadir:response.data['JumPemilihU2_Hadir']??0,
        JumPemilihU3_Hadir:response.data['JumPemilihU3_Hadir']??0,
        JumPemilihU4_Hadir:response.data['JumPemilihU4_Hadir']??0,
        JumPemilihU5_Hadir:response.data['JumPemilihU5_Hadir']??0,
        JumPemilihU6_Hadir:response.data['JumPemilihU6_Hadir']??0,
        JumPemilihU7_Hadir:response.data['JumPemilihU7_Hadir']??0,
        JumPemilihU0_THadir:response.data['JumPemilihU0_THadir']??0,
        JumPemilihU1_THadir:response.data['JumPemilihU1_THadir']??0,
        JumPemilihU2_THadir:response.data['JumPemilihU2_THadir']??0,
        JumPemilihU3_THadir:response.data['JumPemilihU3_THadir']??0,
        JumPemilihU4_THadir:response.data['JumPemilihU4_THadir']??0,
        JumPemilihU5_THadir:response.data['JumPemilihU5_THadir']??0,
        JumPemilihU6_THadir:response.data['JumPemilihU6_THadir']??0,
        JumPemilihU7_THadir:response.data['JumPemilihU7_THadir']??0,
        JumPemilihU0_P:response.data['JumPemilihU0_P']??0,
        JumPemilihU1_P:response.data['JumPemilihU1_P']??0,
        JumPemilihU2_P:response.data['JumPemilihU2_P']??0,
        JumPemilihU3_P:response.data['JumPemilihU3_P']??0,
        JumPemilihU4_P:response.data['JumPemilihU4_P']??0,
        JumPemilihU5_P:response.data['JumPemilihU5_P']??0,
        JumPemilihU6_P:response.data['JumPemilihU6_P']??0,
        JumPemilihU7_P:response.data['JumPemilihU7_P']??0,
        JumPemilihU0_P_Hadir:response.data['JumPemilihU0_P_Hadir']??0,
        JumPemilihU1_P_Hadir:response.data['JumPemilihU1_P_Hadir']??0,
        JumPemilihU2_P_Hadir:response.data['JumPemilihU2_P_Hadir']??0,
        JumPemilihU3_P_Hadir:response.data['JumPemilihU3_P_Hadir']??0,
        JumPemilihU4_P_Hadir:response.data['JumPemilihU4_P_Hadir']??0,
        JumPemilihU5_P_Hadir:response.data['JumPemilihU5_P_Hadir']??0,
        JumPemilihU6_P_Hadir:response.data['JumPemilihU6_P_Hadir']??0,
        JumPemilihU7_P_Hadir:response.data['JumPemilihU7_P_Hadir']??0,
        JumPemilihU0_P_THadir:response.data['JumPemilihU0_P_THadir']??0,
        JumPemilihU1_P_THadir:response.data['JumPemilihU1_P_THadir']??0,
        JumPemilihU2_P_THadir:response.data['JumPemilihU2_P_THadir']??0,
        JumPemilihU3_P_THadir:response.data['JumPemilihU3_P_THadir']??0,
        JumPemilihU4_P_THadir:response.data['JumPemilihU4_P_THadir']??0,
        JumPemilihU5_P_THadir:response.data['JumPemilihU5_P_THadir']??0,
        JumPemilihU6_P_THadir:response.data['JumPemilihU6_P_THadir']??0,
        JumPemilihU7_P_THadir:response.data['JumPemilihU7_P_THadir']??0,
        JumPemilih_P:response.data['JumPemilih_P']??0,
        JumPemilih_K:response.data['JumPemilih_K']??0,
        JumPemilih_H:response.data['JumPemilih_H']??0,
        JumPemilih_T:response.data['JumPemilih_T']??0,
        JumPemilih_M:response.data['JumPemilih_M']??0,
        JumPemilih_BB:response.data['JumPemilih_BB']??0,
        JumPemilih_P_Hadir:response.data['JumPemilih_P_Hadir']??0,
        JumPemilih_K_Hadir:response.data['JumPemilih_K_Hadir']??0,
        JumPemilih_H_Hadir:response.data['JumPemilih_H_Hadir']??0,
        JumPemilih_T_Hadir:response.data['JumPemilih_T_Hadir']??0,
        JumPemilih_M_Hadir:response.data['JumPemilih_M_Hadir']??0,
        JumPemilih_BB_Hadir:response.data['JumPemilih_BB_Hadir']??0,
        JumPemilih_P_THadir:response.data['JumPemilih_P_THadir']??0,
        JumPemilih_K_THadir:response.data['JumPemilih_K_THadir']??0,
        JumPemilih_H_THadir:response.data['JumPemilih_H_THadir']??0,
        JumPemilih_T_THadir:response.data['JumPemilih_T_THadir']??0,
        JumPemilih_M_THadir:response.data['JumPemilih_M_THadir']??0,
        JumPemilih_BB_THadir:response.data['JumPemilih_BB_THadir']??0,
      ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbKawasanError(errorMessage:ex.toString()));
    }
  }
}
// --------------Full Cover