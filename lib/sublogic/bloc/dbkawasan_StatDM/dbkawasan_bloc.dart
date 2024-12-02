import 'package:bloc/bloc.dart';
import '../../../subconfig/AppSettings.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc_StatDM extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc_StatDM() : super(InitialDbKawasanState()) {
    on(_getDbKawasanWaiting);
    on<GetDbKawasan>(_getDbKawasan);
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
      if (event.paparanSubDmQuery == 'DM Lok') {
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
        if (event.paparanSubDmQuery == 'DM Lok') {
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
      JumLokaliti: response.data['JumLokaliti'] ?? 0,

      St_Pemilih: response.data['St_Pemilih'],
      St_Awal: response.data['St_Awal'],
      St_Pos: response.data['St_Pos'],
      St_Awam: response.data['St_Awam'],
      St_JantinaL: response.data['St_JantinaL'],
      St_JantinaP: response.data['St_JantinaP'],
      St_KaumM: response.data['St_KaumM'],
      St_KaumC: response.data['St_KaumC'],
      St_KaumI: response.data['St_KaumI'],
      St_KaumL: response.data['St_KaumL'],
      St_UmurU0: response.data['St_UmurU0'],
      St_UmurU1: response.data['St_UmurU1'],
      St_UmurU2: response.data['St_UmurU2'],
      St_UmurU3: response.data['St_UmurU3'],
      St_UmurU4: response.data['St_UmurU4'],
      St_UmurU5: response.data['St_UmurU5'],
      St_UmurU6: response.data['St_UmurU6'],
      St_UmurU7: response.data['St_UmurU7'],
      St_UmurU0L: response.data['St_UmurU0L'],
      St_UmurU0LM: response.data['St_UmurU0LM'],
      St_UmurU0LC: response.data['St_UmurU0LC'],
      St_UmurU0LI: response.data['St_UmurU0LI'],
      St_UmurU0LL: response.data['St_UmurU0LL'],
      St_UmurU0P: response.data['St_UmurU0P'],
      St_UmurU0PM: response.data['St_UmurU0PM'],
      St_UmurU0PC: response.data['St_UmurU0PC'],
      St_UmurU0PI: response.data['St_UmurU0PI'],
      St_UmurU0PL: response.data['St_UmurU0PL'],
      St_UmurU1L: response.data['St_UmurU1L'],
      St_UmurU1LM: response.data['St_UmurU1LM'],
      St_UmurU1LC: response.data['St_UmurU1LC'],
      St_UmurU1LI: response.data['St_UmurU1LI'],
      St_UmurU1LL: response.data['St_UmurU1LL'],
      St_UmurU1P: response.data['St_UmurU1P'],
      St_UmurU1PM: response.data['St_UmurU1PM'],
      St_UmurU1PC: response.data['St_UmurU1PC'],
      St_UmurU1PI: response.data['St_UmurU1PI'],
      St_UmurU1PL: response.data['St_UmurU1PL'],
      St_UmurU2L: response.data['St_UmurU2L'],
      St_UmurU2LM: response.data['St_UmurU2LM'],
      St_UmurU2LC: response.data['St_UmurU2LC'],
      St_UmurU2LI: response.data['St_UmurU2LI'],
      St_UmurU2LL: response.data['St_UmurU2LL'],
      St_UmurU2P: response.data['St_UmurU2P'],
      St_UmurU2PM: response.data['St_UmurU2PM'],
      St_UmurU2PC: response.data['St_UmurU2PC'],
      St_UmurU2PI: response.data['St_UmurU2PI'],
      St_UmurU2PL: response.data['St_UmurU2PL'],
      St_UmurU3L: response.data['St_UmurU3L'],
      St_UmurU3LM: response.data['St_UmurU3LM'],
      St_UmurU3LC: response.data['St_UmurU3LC'],
      St_UmurU3LI: response.data['St_UmurU3LI'],
      St_UmurU3LL: response.data['St_UmurU3LL'],
      St_UmurU3P: response.data['St_UmurU3P'],
      St_UmurU3PM: response.data['St_UmurU3PM'],
      St_UmurU3PC: response.data['St_UmurU3PC'],
      St_UmurU3PI: response.data['St_UmurU3PI'],
      St_UmurU3PL: response.data['St_UmurU3PL'],
      St_UmurU4L: response.data['St_UmurU4L'],
      St_UmurU4LM: response.data['St_UmurU4LM'],
      St_UmurU4LC: response.data['St_UmurU4LC'],
      St_UmurU4LI: response.data['St_UmurU4LI'],
      St_UmurU4LL: response.data['St_UmurU4LL'],
      St_UmurU4P: response.data['St_UmurU4P'],
      St_UmurU4PM: response.data['St_UmurU4PM'],
      St_UmurU4PC: response.data['St_UmurU4PC'],
      St_UmurU4PI: response.data['St_UmurU4PI'],
      St_UmurU4PL: response.data['St_UmurU4PL'],
      St_UmurU5L: response.data['St_UmurU5L'],
      St_UmurU5LM: response.data['St_UmurU5LM'],
      St_UmurU5LC: response.data['St_UmurU5LC'],
      St_UmurU5LI: response.data['St_UmurU5LI'],
      St_UmurU5LL: response.data['St_UmurU5LL'],
      St_UmurU5P: response.data['St_UmurU5P'],
      St_UmurU5PM: response.data['St_UmurU5PM'],
      St_UmurU5PC: response.data['St_UmurU5PC'],
      St_UmurU5PI: response.data['St_UmurU5PI'],
      St_UmurU5PL: response.data['St_UmurU5PL'],
      St_UmurU6L: response.data['St_UmurU6L'],
      St_UmurU6LM: response.data['St_UmurU6LM'],
      St_UmurU6LC: response.data['St_UmurU6LC'],
      St_UmurU6LI: response.data['St_UmurU6LI'],
      St_UmurU6LL: response.data['St_UmurU6LL'],
      St_UmurU6P: response.data['St_UmurU6P'],
      St_UmurU6PM: response.data['St_UmurU6PM'],
      St_UmurU6PC: response.data['St_UmurU6PC'],
      St_UmurU6PI: response.data['St_UmurU6PI'],
      St_UmurU6PL: response.data['St_UmurU6PL'],
      St_UmurU7L: response.data['St_UmurU7L'],
      St_UmurU7LM: response.data['St_UmurU7LM'],
      St_UmurU7LC: response.data['St_UmurU7LC'],
      St_UmurU7LI: response.data['St_UmurU7LI'],
      St_UmurU7LL: response.data['St_UmurU7LL'],
      St_UmurU7P: response.data['St_UmurU7P'],
      St_UmurU7PM: response.data['St_UmurU7PM'],
      St_UmurU7PC: response.data['St_UmurU7PC'],
      St_UmurU7PI: response.data['St_UmurU7PI'],
      St_UmurU7PL: response.data['St_UmurU7PL'],
      St_AhliG: response.data['St_AhliG'],
      St_AhliW: response.data['St_AhliW'],
      St_AhliY: response.data['St_AhliY'],
      St_AhliP: response.data['St_AhliP'],
      Dy0a_JumJR: response.data['Dy0a_JumJR'],
      Dy0a_JumJRAktif_queDel: response.data['Dy0a_JumJRAktif_queDel'],
      Dy0a_JumJRAktif_DMSPR_queDel: response.data['Dy0a_JumJRAktif_DMSPR_queDel'],
      Dy0a_JumJRAktif_DMAkses_queDel: response.data['Dy0a_JumJRAktif_DMAkses_queDel'],
      Dy0a_JumJRXAktif_queDel: response.data['Dy0a_JumJRXAktif_queDel'],
      Dy1_P: response.data['Dy1_P'],
      Dy1_K: response.data['Dy1_K'],
      Dy1_H: response.data['Dy1_H'],
      Dy1_T: response.data['Dy1_T'],
      Dy1_M: response.data['Dy1_M'],
      Dy1_BB: response.data['Dy1_BB'],
      Dy1_Aktif: response.data['Dy1_Aktif'],
      Dy1_LN: response.data['Dy1_LN'],
      Dy1_LP: response.data['Dy1_LP'],
      Dy1_LD: response.data['Dy1_LD'],
      Dy1_LM: response.data['Dy1_LM'],
      Dy1_PLuar: response.data['Dy1_PLuar'],
      Dy1_AktifPu: response.data['Dy1_AktifPu'],
      Dy1_LNPu: response.data['Dy1_LNPu'],
      Dy1_LPPu: response.data['Dy1_LPPu'],
      Dy1_LDPu: response.data['Dy1_LDPu'],
      Dy1_LMPu: response.data['Dy1_LMPu'],
      Dy1_PLuarPu: response.data['Dy1_PLuarPu'],
      Dy1_JantinaLPu: response.data['Dy1_JantinaLPu'],
      Dy1_JantinaLK: response.data['Dy1_JantinaLK'],
      Dy1_JantinaLH: response.data['Dy1_JantinaLH'],
      Dy1_JantinaLT: response.data['Dy1_JantinaLT'],
      Dy1_JantinaLM: response.data['Dy1_JantinaLM'],
      Dy1_JantinaLPLuar: response.data['Dy1_JantinaLPLuar'],
      Dy1_JantinaPPu: response.data['Dy1_JantinaPPu'],
      Dy1_JantinaPK: response.data['Dy1_JantinaPK'],
      Dy1_JantinaPH: response.data['Dy1_JantinaPH'],
      Dy1_JantinaPT: response.data['Dy1_JantinaPT'],
      Dy1_JantinaPM: response.data['Dy1_JantinaPM'],
      Dy1_JantinaPPLuar: response.data['Dy1_JantinaPPLuar'],
      Dy1_KaumMPu: response.data['Dy1_KaumMPu'],
      Dy1_KaumMK: response.data['Dy1_KaumMK'],
      Dy1_KaumMH: response.data['Dy1_KaumMH'],
      Dy1_KaumMT: response.data['Dy1_KaumMT'],
      Dy1_KaumMM: response.data['Dy1_KaumMM'],
      Dy1_KaumMPLuar: response.data['Dy1_KaumMPLuar'],
      Dy1_KaumCPu: response.data['Dy1_KaumCPu'],
      Dy1_KaumCK: response.data['Dy1_KaumCK'],
      Dy1_KaumCH: response.data['Dy1_KaumCH'],
      Dy1_KaumCT: response.data['Dy1_KaumCT'],
      Dy1_KaumCM: response.data['Dy1_KaumCM'],
      Dy1_KaumCPLuar: response.data['Dy1_KaumCPLuar'],
      Dy1_KaumIPu: response.data['Dy1_KaumIPu'],
      Dy1_KaumIK: response.data['Dy1_KaumIK'],
      Dy1_KaumIH: response.data['Dy1_KaumIH'],
      Dy1_KaumIT: response.data['Dy1_KaumIT'],
      Dy1_KaumIM: response.data['Dy1_KaumIM'],
      Dy1_KaumIPLuar: response.data['Dy1_KaumIPLuar'],
      Dy1_KaumLPu: response.data['Dy1_KaumLPu'],
      Dy1_KaumLK: response.data['Dy1_KaumLK'],
      Dy1_KaumLH: response.data['Dy1_KaumLH'],
      Dy1_KaumLT: response.data['Dy1_KaumLT'],
      Dy1_KaumLM: response.data['Dy1_KaumLM'],
      Dy1_KaumLPLuar: response.data['Dy1_KaumLPLuar'],
      Dy1_UmurU0Pu: response.data['Dy1_UmurU0Pu'],
      Dy1_UmurU1Pu: response.data['Dy1_UmurU1Pu'],
      Dy1_UmurU2Pu: response.data['Dy1_UmurU2Pu'],
      Dy1_UmurU3Pu: response.data['Dy1_UmurU3Pu'],
      Dy1_UmurU4Pu: response.data['Dy1_UmurU4Pu'],
      Dy1_UmurU5Pu: response.data['Dy1_UmurU5Pu'],
      Dy1_UmurU6Pu: response.data['Dy1_UmurU6Pu'],
      Dy1_UmurU7Pu: response.data['Dy1_UmurU7Pu'],
      Dy1_AhliGPu: response.data['Dy1_AhliGPu'],
      Dy1_AhliWPu: response.data['Dy1_AhliWPu'],
      Dy1_AhliYPu: response.data['Dy1_AhliYPu'],
      Dy1_AhliPPu: response.data['Dy1_AhliPPu'],
      Dy1__XMatchingM: response.data['Dy1__XMatchingM'],
      Dy1__XMatchingMP: response.data['Dy1__XMatchingMP'],
      Dy1__MatchingM: response.data['Dy1__MatchingM'],
      Dy1__MatchingMP: response.data['Dy1__MatchingMP'],
      Dy1__MatchingMK: response.data['Dy1__MatchingMK'],
      Dy1__MatchingMH: response.data['Dy1__MatchingMH'],
      Dy1__MatchingMT: response.data['Dy1__MatchingMT'],
      Dy1__MatchingMM: response.data['Dy1__MatchingMM'],
      Dy1__MatchingMBanci: response.data['Dy1__MatchingMBanci'],
      Dy1__MatchingMBBanci: response.data['Dy1__MatchingMBBanci'],
      Dy1__MatchingC: response.data['Dy1__MatchingC'],
      Dy1__MatchingI: response.data['Dy1__MatchingI'],
      Dy1__MatchingL: response.data['Dy1__MatchingL'],
      Dy1___KaumM_L_1: response.data['Dy1___KaumM_L_1'],
      Dy1___KaumM_L_1_P: response.data['Dy1___KaumM_L_1_P'],
      Dy1___KaumM_L_1_K: response.data['Dy1___KaumM_L_1_K'],
      Dy1___KaumM_L_1_H: response.data['Dy1___KaumM_L_1_H'],
      Dy1___KaumM_L_1_T: response.data['Dy1___KaumM_L_1_T'],
      Dy1___KaumM_L_1_M: response.data['Dy1___KaumM_L_1_M'],
      Dy1___KaumM_L_1_Banci: response.data['Dy1___KaumM_L_1_Banci'],
      Dy1___KaumM_L_1_BBanci: response.data['Dy1___KaumM_L_1_BBanci'],
      Dy1___KaumM_P_2: response.data['Dy1___KaumM_P_2'],
      Dy1___KaumM_P_2_P: response.data['Dy1___KaumM_P_2_P'],
      Dy1___KaumM_P_2_K: response.data['Dy1___KaumM_P_2_K'],
      Dy1___KaumM_P_2_H: response.data['Dy1___KaumM_P_2_H'],
      Dy1___KaumM_P_2_T: response.data['Dy1___KaumM_P_2_T'],
      Dy1___KaumM_P_2_M: response.data['Dy1___KaumM_P_2_M'],
      Dy1___KaumM_P_2_Banci: response.data['Dy1___KaumM_P_2_Banci'],
      Dy1___KaumM_P_2_BBanci: response.data['Dy1___KaumM_P_2_BBanci'],
      Dy1___KaumM_L_3: response.data['Dy1___KaumM_L_3'],
      Dy1___KaumM_L_3_P: response.data['Dy1___KaumM_L_3_P'],
      Dy1___KaumM_L_3_K: response.data['Dy1___KaumM_L_3_K'],
      Dy1___KaumM_L_3_H: response.data['Dy1___KaumM_L_3_H'],
      Dy1___KaumM_L_3_T: response.data['Dy1___KaumM_L_3_T'],
      Dy1___KaumM_L_3_M: response.data['Dy1___KaumM_L_3_M'],
      Dy1___KaumM_L_3_Banci: response.data['Dy1___KaumM_L_3_Banci'],
      Dy1___KaumM_L_3_BBanci: response.data['Dy1___KaumM_L_3_BBanci'],
      Dy1___KaumM_P_4: response.data['Dy1___KaumM_P_4'],
      Dy1___KaumM_P_4_P: response.data['Dy1___KaumM_P_4_P'],
      Dy1___KaumM_P_4_K: response.data['Dy1___KaumM_P_4_K'],
      Dy1___KaumM_P_4_H: response.data['Dy1___KaumM_P_4_H'],
      Dy1___KaumM_P_4_T: response.data['Dy1___KaumM_P_4_T'],
      Dy1___KaumM_P_4_M: response.data['Dy1___KaumM_P_4_M'],
      Dy1___KaumM_P_4_Banci: response.data['Dy1___KaumM_P_4_Banci'],
      Dy1___KaumM_P_4_BBanci: response.data['Dy1___KaumM_P_4_BBanci'],
      Dy1___KaumM_L_3_SikapM_Banci: response.data['Dy1___KaumM_L_3_SikapM_Banci'],
      Dy1___KaumM_L_3_SikapM_Banci_P: response.data['Dy1___KaumM_L_3_SikapM_Banci_P'],
      Dy1___KaumM_L_3_SikapM_Banci_K: response.data['Dy1___KaumM_L_3_SikapM_Banci_K'],
      Dy1___KaumM_L_3_SikapM_Banci_H: response.data['Dy1___KaumM_L_3_SikapM_Banci_H'],
      Dy1___KaumM_L_3_StatusM_Banci_T: response.data['Dy1___KaumM_L_3_StatusM_Banci_T'],
      Dy1___KaumM_L_3_StatusM_Banci_M: response.data['Dy1___KaumM_L_3_StatusM_Banci_M'],
      Dy1___KaumM_L_3_SikapM_1: response.data['Dy1___KaumM_L_3_SikapM_1'],
      Dy1___KaumM_L_3_SikapM_2: response.data['Dy1___KaumM_L_3_SikapM_2'],
      Dy1___KaumM_L_3_SikapM_3: response.data['Dy1___KaumM_L_3_SikapM_3'],
      Dy1___KaumM_L_3_SikapM_4: response.data['Dy1___KaumM_L_3_SikapM_4'],
      Dy1___KaumM_L_3_SikapM_5: response.data['Dy1___KaumM_L_3_SikapM_5'],
      Dy1___KaumM_L_3_SikapM_6: response.data['Dy1___KaumM_L_3_SikapM_6'],
      Dy1___KaumM_L_3_SikapM_7: response.data['Dy1___KaumM_L_3_SikapM_7'],
      Dy1___KaumM_L_3_SikapM_8: response.data['Dy1___KaumM_L_3_SikapM_8'],
      Dy1___KaumM_L_3_SikapM_9: response.data['Dy1___KaumM_L_3_SikapM_9'],
      Dy1___KaumM_L_3_SikapM_10: response.data['Dy1___KaumM_L_3_SikapM_10'],
      Dy1___KaumM_L_3_SikapM_11: response.data['Dy1___KaumM_L_3_SikapM_11'],
      Dy1___KaumM_L_3_StatusM_T: response.data['Dy1___KaumM_L_3_StatusM_T'],
      Dy1___KaumM_L_3_StatusM_M: response.data['Dy1___KaumM_L_3_StatusM_M'],
      Dy1___L_3_Jumlah_Petugas: response.data['Dy1___L_3_Jumlah_Petugas'],
      Dy1___KaumM_P_4_SikapM_Banci: response.data['Dy1___KaumM_P_4_SikapM_Banci'],
      Dy1___KaumM_P_4_SikapM_Banci_P: response.data['Dy1___KaumM_P_4_SikapM_Banci_P'],
      Dy1___KaumM_P_4_SikapM_Banci_K: response.data['Dy1___KaumM_P_4_SikapM_Banci_K'],
      Dy1___KaumM_P_4_SikapM_Banci_H: response.data['Dy1___KaumM_P_4_SikapM_Banci_H'],
      Dy1___KaumM_P_4_StatusM_Banci_T: response.data['Dy1___KaumM_P_4_StatusM_Banci_T'],
      Dy1___KaumM_P_4_StatusM_Banci_M: response.data['Dy1___KaumM_P_4_StatusM_Banci_M'],
      Dy1___KaumM_P_4_SikapM_1: response.data['Dy1___KaumM_P_4_SikapM_1'],
      Dy1___KaumM_P_4_SikapM_2: response.data['Dy1___KaumM_P_4_SikapM_2'],
      Dy1___KaumM_P_4_SikapM_3: response.data['Dy1___KaumM_P_4_SikapM_3'],
      Dy1___KaumM_P_4_SikapM_4: response.data['Dy1___KaumM_P_4_SikapM_4'],
      Dy1___KaumM_P_4_SikapM_5: response.data['Dy1___KaumM_P_4_SikapM_5'],
      Dy1___KaumM_P_4_SikapM_6: response.data['Dy1___KaumM_P_4_SikapM_6'],
      Dy1___KaumM_P_4_SikapM_7: response.data['Dy1___KaumM_P_4_SikapM_7'],
      Dy1___KaumM_P_4_SikapM_8: response.data['Dy1___KaumM_P_4_SikapM_8'],
      Dy1___KaumM_P_4_SikapM_9: response.data['Dy1___KaumM_P_4_SikapM_9'],
      Dy1___KaumM_P_4_SikapM_10: response.data['Dy1___KaumM_P_4_SikapM_10'],
      Dy1___KaumM_P_4_SikapM_11: response.data['Dy1___KaumM_P_4_SikapM_11'],
      Dy1___KaumM_P_4_StatusM_T: response.data['Dy1___KaumM_P_4_StatusM_T'],
      Dy1___KaumM_P_4_StatusM_M: response.data['Dy1___KaumM_P_4_StatusM_M'],
      Dy1___P_4_Jumlah_Petugas: response.data['Dy1___P_4_Jumlah_Petugas'],

      Dy1___KaumM_L_3_SikapP_SikapMP: response.data['Dy1___KaumM_L_3_SikapP_SikapMP'],
      Dy1___KaumM_L_3_SikapP_SikapMNotP: response.data['Dy1___KaumM_L_3_SikapP_SikapMNotP'],
      Dy1___KaumM_L_3_SikapNotP_SikapMP: response.data['Dy1___KaumM_L_3_SikapNotP_SikapMP'],

      Dy1___KaumM_P_4_SikapP_SikapMP: response.data['Dy1___KaumM_P_4_SikapP_SikapMP'],
      Dy1___KaumM_P_4_SikapP_SikapMNotP: response.data['Dy1___KaumM_P_4_SikapP_SikapMNotP'],
      Dy1___KaumM_P_4_SikapNotP_SikapMP: response.data['Dy1___KaumM_P_4_SikapNotP_SikapMP'],

      
      Dy2_HB1: response.data['Dy2_HB1'],
      Dy2_PHB1: response.data['Dy2_PHB1'],
      Dy2_KHB1: response.data['Dy2_KHB1'],
      Dy2_HHB1: response.data['Dy2_HHB1'],
      Dy2_THB1: response.data['Dy2_THB1'],
      Dy2_MHB1: response.data['Dy2_MHB1'],
      Dy2_BBHB1: response.data['Dy2_BBHB1'],
      Dy2_JantinaLHB1: response.data['Dy2_JantinaLHB1'],
      Dy2_JantinaPHB1: response.data['Dy2_JantinaPHB1'],
      Dy2_JantinaLPuHB1: response.data['Dy2_JantinaLPuHB1'],
      Dy2_JantinaPPuHB1: response.data['Dy2_JantinaPPuHB1'],
      Dy2_KaumMHB1: response.data['Dy2_KaumMHB1'],
      Dy2_KaumCHB1: response.data['Dy2_KaumCHB1'],
      Dy2_KaumIHB1: response.data['Dy2_KaumIHB1'],
      Dy2_KaumLHB1: response.data['Dy2_KaumLHB1'],
      Dy2_KaumMPuHB1: response.data['Dy2_KaumMPuHB1'],
      Dy2_KaumCPuHB1: response.data['Dy2_KaumCPuHB1'],
      Dy2_KaumIPuHB1: response.data['Dy2_KaumIPuHB1'],
      Dy2_KaumLPuHB1: response.data['Dy2_KaumLPuHB1'],
      Dy2_UmurU0HB1: response.data['Dy2_UmurU0HB1'],
      Dy2_UmurU1HB1: response.data['Dy2_UmurU1HB1'],
      Dy2_UmurU2HB1: response.data['Dy2_UmurU2HB1'],
      Dy2_UmurU3HB1: response.data['Dy2_UmurU3HB1'],
      Dy2_UmurU4HB1: response.data['Dy2_UmurU4HB1'],
      Dy2_UmurU5HB1: response.data['Dy2_UmurU5HB1'],
      Dy2_UmurU6HB1: response.data['Dy2_UmurU6HB1'],
      Dy2_UmurU7HB1: response.data['Dy2_UmurU7HB1'],
      Dy2_UmurU0PuHB1: response.data['Dy2_UmurU0PuHB1'],
      Dy2_UmurU1PuHB1: response.data['Dy2_UmurU1PuHB1'],
      Dy2_UmurU2PuHB1: response.data['Dy2_UmurU2PuHB1'],
      Dy2_UmurU3PuHB1: response.data['Dy2_UmurU3PuHB1'],
      Dy2_UmurU4PuHB1: response.data['Dy2_UmurU4PuHB1'],
      Dy2_UmurU5PuHB1: response.data['Dy2_UmurU5PuHB1'],
      Dy2_UmurU6PuHB1: response.data['Dy2_UmurU6PuHB1'],
      Dy2_UmurU7PuHB1: response.data['Dy2_UmurU7PuHB1'],
      Dy2_AhliGHB1: response.data['Dy2_AhliGHB1'],
      Dy2_AhliWHB1: response.data['Dy2_AhliWHB1'],
      Dy2_AhliYHB1: response.data['Dy2_AhliYHB1'],
      Dy2_AhliPHB1: response.data['Dy2_AhliPHB1'],
      Dy2_AhliGPuHB1: response.data['Dy2_AhliGPuHB1'],
      Dy2_AhliWPuHB1: response.data['Dy2_AhliWPuHB1'],
      Dy2_AhliYPuHB1: response.data['Dy2_AhliYPuHB1'],
      Dy2_AhliPPuHB1: response.data['Dy2_AhliPPuHB1'],
      Dy3_HB2: response.data['Dy3_HB2'],
      Dy3_PHB2: response.data['Dy3_PHB2'],
      Dy3_KHB2: response.data['Dy3_KHB2'],
      Dy3_HHB2: response.data['Dy3_HHB2'],
      Dy3_THB2: response.data['Dy3_THB2'],
      Dy3_MHB2: response.data['Dy3_MHB2'],
      Dy3_BBHB2: response.data['Dy3_BBHB2'],
      Dy3_JantinaLHB2: response.data['Dy3_JantinaLHB2'],
      Dy3_JantinaPHB2: response.data['Dy3_JantinaPHB2'],
      Dy3_JantinaLPuHB2: response.data['Dy3_JantinaLPuHB2'],
      Dy3_JantinaPPuHB2: response.data['Dy3_JantinaPPuHB2'],
      Dy3_KaumMHB2: response.data['Dy3_KaumMHB2'],
      Dy3_KaumCHB2: response.data['Dy3_KaumCHB2'],
      Dy3_KaumIHB2: response.data['Dy3_KaumIHB2'],
      Dy3_KaumLHB2: response.data['Dy3_KaumLHB2'],
      Dy3_KaumMPuHB2: response.data['Dy3_KaumMPuHB2'],
      Dy3_KaumCPuHB2: response.data['Dy3_KaumCPuHB2'],
      Dy3_KaumIPuHB2: response.data['Dy3_KaumIPuHB2'],
      Dy3_KaumLPuHB2: response.data['Dy3_KaumLPuHB2'],
      Dy3_UmurU0HB2: response.data['Dy3_UmurU0HB2'],
      Dy3_UmurU1HB2: response.data['Dy3_UmurU1HB2'],
      Dy3_UmurU2HB2: response.data['Dy3_UmurU2HB2'],
      Dy3_UmurU3HB2: response.data['Dy3_UmurU3HB2'],
      Dy3_UmurU4HB2: response.data['Dy3_UmurU4HB2'],
      Dy3_UmurU5HB2: response.data['Dy3_UmurU5HB2'],
      Dy3_UmurU6HB2: response.data['Dy3_UmurU6HB2'],
      Dy3_UmurU7HB2: response.data['Dy3_UmurU7HB2'],
      Dy3_UmurU0PuHB2: response.data['Dy3_UmurU0PuHB2'],
      Dy3_UmurU1PuHB2: response.data['Dy3_UmurU1PuHB2'],
      Dy3_UmurU2PuHB2: response.data['Dy3_UmurU2PuHB2'],
      Dy3_UmurU3PuHB2: response.data['Dy3_UmurU3PuHB2'],
      Dy3_UmurU4PuHB2: response.data['Dy3_UmurU4PuHB2'],
      Dy3_UmurU5PuHB2: response.data['Dy3_UmurU5PuHB2'],
      Dy3_UmurU6PuHB2: response.data['Dy3_UmurU6PuHB2'],
      Dy3_UmurU7PuHB2: response.data['Dy3_UmurU7PuHB2'],
      Dy3_AhliGHB2: response.data['Dy3_AhliGHB2'],
      Dy3_AhliWHB2: response.data['Dy3_AhliWHB2'],
      Dy3_AhliYHB2: response.data['Dy3_AhliYHB2'],
      Dy3_AhliPHB2: response.data['Dy3_AhliPHB2'],
      Dy3_AhliGPuHB2: response.data['Dy3_AhliGPuHB2'],
      Dy3_AhliWPuHB2: response.data['Dy3_AhliWPuHB2'],
      Dy3_AhliYPuHB2: response.data['Dy3_AhliYPuHB2'],
      Dy3_AhliPPuHB2: response.data['Dy3_AhliPPuHB2'],
      Dy4_Hadir: response.data['Dy4_Hadir'],
      Dy4_PHadir: response.data['Dy4_PHadir'],
      Dy4_KHadir: response.data['Dy4_KHadir'],
      Dy4_HHadir: response.data['Dy4_HHadir'],
      Dy4_THadir: response.data['Dy4_THadir'],
      Dy4_MHadir: response.data['Dy4_MHadir'],
      Dy4_BBHadir: response.data['Dy4_BBHadir'],
      Dy4_AktifHadir: response.data['Dy4_AktifHadir'],
      Dy4_LNHadir: response.data['Dy4_LNHadir'],
      Dy4_LPHadir: response.data['Dy4_LPHadir'],
      Dy4_LDHadir: response.data['Dy4_LDHadir'],
      Dy4_LMHadir: response.data['Dy4_LMHadir'],
      Dy4_AktifPuHadir: response.data['Dy4_AktifPuHadir'],
      Dy4_LNPuHadir: response.data['Dy4_LNPuHadir'],
      Dy4_LPPuHadir: response.data['Dy4_LPPuHadir'],
      Dy4_LDPuHadir: response.data['Dy4_LDPuHadir'],
      Dy4_LMPuHadir: response.data['Dy4_LMPuHadir'],
      Dy4_JantinaLHadir: response.data['Dy4_JantinaLHadir'],
      Dy4_JantinaPHadir: response.data['Dy4_JantinaPHadir'],
      Dy4_JantinaLPuHadir: response.data['Dy4_JantinaLPuHadir'],
      Dy4_JantinaPPuHadir: response.data['Dy4_JantinaPPuHadir'],
      Dy4_KaumMHadir: response.data['Dy4_KaumMHadir'],
      Dy4_KaumCHadir: response.data['Dy4_KaumCHadir'],
      Dy4_KaumIHadir: response.data['Dy4_KaumIHadir'],
      Dy4_KaumLHadir: response.data['Dy4_KaumLHadir'],
      Dy4_KaumMPuHadir: response.data['Dy4_KaumMPuHadir'],
      Dy4_KaumCPuHadir: response.data['Dy4_KaumCPuHadir'],
      Dy4_KaumIPuHadir: response.data['Dy4_KaumIPuHadir'],
      Dy4_KaumLPuHadir: response.data['Dy4_KaumLPuHadir'],
      Dy4_UmurU0Hadir: response.data['Dy4_UmurU0Hadir'],
      Dy4_UmurU1Hadir: response.data['Dy4_UmurU1Hadir'],
      Dy4_UmurU2Hadir: response.data['Dy4_UmurU2Hadir'],
      Dy4_UmurU3Hadir: response.data['Dy4_UmurU3Hadir'],
      Dy4_UmurU4Hadir: response.data['Dy4_UmurU4Hadir'],
      Dy4_UmurU5Hadir: response.data['Dy4_UmurU5Hadir'],
      Dy4_UmurU6Hadir: response.data['Dy4_UmurU6Hadir'],
      Dy4_UmurU7Hadir: response.data['Dy4_UmurU7Hadir'],
      Dy4_UmurU0PuHadir: response.data['Dy4_UmurU0PuHadir'],
      Dy4_UmurU1PuHadir: response.data['Dy4_UmurU1PuHadir'],
      Dy4_UmurU2PuHadir: response.data['Dy4_UmurU2PuHadir'],
      Dy4_UmurU3PuHadir: response.data['Dy4_UmurU3PuHadir'],
      Dy4_UmurU4PuHadir: response.data['Dy4_UmurU4PuHadir'],
      Dy4_UmurU5PuHadir: response.data['Dy4_UmurU5PuHadir'],
      Dy4_UmurU6PuHadir: response.data['Dy4_UmurU6PuHadir'],
      Dy4_UmurU7PuHadir: response.data['Dy4_UmurU7PuHadir'],
      Dy4_AhliGHadir: response.data['Dy4_AhliGHadir'],
      Dy4_AhliWHadir: response.data['Dy4_AhliWHadir'],
      Dy4_AhliYHadir: response.data['Dy4_AhliYHadir'],
      Dy4_AhliPHadir: response.data['Dy4_AhliPHadir'],
      Dy4_AhliGPuHadir: response.data['Dy4_AhliGPuHadir'],
      Dy4_AhliWPuHadir: response.data['Dy4_AhliWPuHadir'],
      Dy4_AhliYPuHadir: response.data['Dy4_AhliYPuHadir'],
      Dy4_AhliPPuHadir: response.data['Dy4_AhliPPuHadir'],
      Kpi_Per_Hadir_PRULepas: response.data['Kpi_Per_Hadir_PRULepas'],
      Kpi_PemilihHadir: response.data['Kpi_PemilihHadir'],
      Kpi_Undi_AsasMenang: response.data['Kpi_Undi_AsasMenang'],
      Kpi_P100: response.data['Kpi_P100'],
      Kpi_BukanP100: response.data['Kpi_BukanP100'],
      Kpi_P100_Undi_AsasMenang: response.data['Kpi_P100_Undi_AsasMenang'],
      Kpi_Status_Simulasi_Majoriti100: response.data['Kpi_Status_Simulasi_Majoriti100'],
      Kpi_Status_Majoriti100: response.data['Kpi_Status_Majoriti100'],
      Kpi_P95: response.data['Kpi_P95'],
      Kpi_BukanP95: response.data['Kpi_BukanP95'],
      Kpi_P95_Undi_AsasMenang: response.data['Kpi_P95_Undi_AsasMenang'],
      Kpi_Status_Simulasi_Majoriti95: response.data['Kpi_Status_Simulasi_Majoriti95'],
      Kpi_Status_Majoriti95: response.data['Kpi_Status_Majoriti95'],
      Kpi_P90: response.data['Kpi_P90'],
      Kpi_BukanP90: response.data['Kpi_BukanP90'],
      Kpi_P90_Undi_AsasMenang: response.data['Kpi_P90_Undi_AsasMenang'],
      Kpi_Status_Simulasi_Majoriti90: response.data['Kpi_Status_Simulasi_Majoriti90'],
      Kpi_Status_Majoriti90: response.data['Kpi_Status_Majoriti90'],
      Kpi_P85: response.data['Kpi_P85'],
      Kpi_BukanP85: response.data['Kpi_BukanP85'],
      Kpi_P85_Undi_AsasMenang: response.data['Kpi_P85_Undi_AsasMenang'],
      Kpi_Status_Simulasi_Majoriti85: response.data['Kpi_Status_Simulasi_Majoriti85'],
      Kpi_Status_Majoriti85: response.data['Kpi_Status_Majoriti85'],
      Kpi_P80: response.data['Kpi_P80'],
      Kpi_BukanP80: response.data['Kpi_BukanP80'],
      Kpi_P80_Undi_AsasMenang: response.data['Kpi_P80_Undi_AsasMenang'],
      Kpi_Status_Simulasi_Majoriti80: response.data['Kpi_Status_Simulasi_Majoriti80'],
      Kpi_Status_Majoriti80: response.data['Kpi_Status_Majoriti80'],
      Kpi_P75: response.data['Kpi_P75'],
      Kpi_BukanP75: response.data['Kpi_BukanP75'],
      Kpi_P75_Undi_AsasMenang: response.data['Kpi_P75_Undi_AsasMenang'],
      Kpi_Status_Simulasi_Majoriti75: response.data['Kpi_Status_Simulasi_Majoriti75'],
      Kpi_Status_Majoriti75: response.data['Kpi_Status_Majoriti75'],

      Dy0ax_JumJRAktif: response.data['Dy0ax_JumJRAktif'],
      Dy0ax_JumJRXAktif: response.data['Dy0ax_JumJRXAktif'],
      Dy1x_Banci: response.data['Dy1x_Banci'],
      Dy1x_BBanci: response.data['Dy1x_BBanci'],
      Dy1x_KaumMBanci: response.data['Dy1x_KaumMBanci'],
      Dy1x_KaumMBBanci: response.data['Dy1x_KaumMBBanci'],
      Dy4x_THadir: response.data['Dy4x_THadir'],
      Dy4x_PTHadir: response.data['Dy4x_PTHadir'],
      Dy4x_KTHadir: response.data['Dy4x_KTHadir'],
      Dy4x_HTHadir: response.data['Dy4x_HTHadir'],
      Dy4x_TTHadir: response.data['Dy4x_TTHadir'],
      Dy4x_MTHadir: response.data['Dy4x_MTHadir'],
      Dy4x_BBTHadir: response.data['Dy4x_BBTHadir'],
      Dy4x_JantinaLTHadir: response.data['Dy4x_JantinaLTHadir'],
      Dy4x_JantinaPTHadir: response.data['Dy4x_JantinaPTHadir'],
      Dy4x_JantinaLPuTHadir: response.data['Dy4x_JantinaLPuTHadir'],
      Dy4x_JantinaPPuTHadir: response.data['Dy4x_JantinaPPuTHadir'],
      Dy4x_KaumMTHadir: response.data['Dy4x_KaumMTHadir'],
      Dy4x_KaumCTHadir: response.data['Dy4x_KaumCTHadir'],
      Dy4x_KaumITHadir: response.data['Dy4x_KaumITHadir'],
      Dy4x_KaumLTHadir: response.data['Dy4x_KaumLTHadir'],
      Dy4x_KaumMPuTHadir: response.data['Dy4x_KaumMPuTHadir'],
      Dy4x_KaumCPuTHadir: response.data['Dy4x_KaumCPuTHadir'],
      Dy4x_KaumIPuTHadir: response.data['Dy4x_KaumIPuTHadir'],
      Dy4x_KaumLPuTHadir: response.data['Dy4x_KaumLPuTHadir'],
      Dy4x_UmurU0THadir: response.data['Dy4x_UmurU0THadir'],
      Dy4x_UmurU1THadir: response.data['Dy4x_UmurU1THadir'],
      Dy4x_UmurU2THadir: response.data['Dy4x_UmurU2THadir'],
      Dy4x_UmurU3THadir: response.data['Dy4x_UmurU3THadir'],
      Dy4x_UmurU4THadir: response.data['Dy4x_UmurU4THadir'],
      Dy4x_UmurU5THadir: response.data['Dy4x_UmurU5THadir'],
      Dy4x_UmurU6THadir: response.data['Dy4x_UmurU6THadir'],
      Dy4x_UmurU7THadir: response.data['Dy4x_UmurU7THadir'],
      Dy4x_UmurU0PuTHadir: response.data['Dy4x_UmurU0PuTHadir'],
      Dy4x_UmurU1PuTHadir: response.data['Dy4x_UmurU1PuTHadir'],
      Dy4x_UmurU2PuTHadir: response.data['Dy4x_UmurU2PuTHadir'],
      Dy4x_UmurU3PuTHadir: response.data['Dy4x_UmurU3PuTHadir'],
      Dy4x_UmurU4PuTHadir: response.data['Dy4x_UmurU4PuTHadir'],
      Dy4x_UmurU5PuTHadir: response.data['Dy4x_UmurU5PuTHadir'],
      Dy4x_UmurU6PuTHadir: response.data['Dy4x_UmurU6PuTHadir'],
      Dy4x_UmurU7PuTHadir: response.data['Dy4x_UmurU7PuTHadir'],

      Banci_KaumM: response.data['Banci_KaumM'],
      BBanci_KaumM: response.data['BBanci_KaumM'],
      Banci_KaumC: response.data['Banci_KaumC'],
      BBanci_KaumC: response.data['BBanci_KaumC'],
      Banci_KaumI: response.data['Banci_KaumI'],
      BBanci_KaumI: response.data['BBanci_KaumI'],
      Banci_KaumL: response.data['Banci_KaumL'],
      BBanci_KaumL: response.data['BBanci_KaumL'],

      Stx_OT: response.data['Stx_OT'],
      Stx_OT_KaumM: response.data['Stx_OT_KaumM'],
      Stx_OT_KaumC: response.data['Stx_OT_KaumC'],
      Stx_OT_KaumI: response.data['Stx_OT_KaumI'],
      Stx_OT_KaumL: response.data['Stx_OT_KaumL'],

      Kpi_Pemilih: response.data['Kpi_Pemilih'],
      // Kpi_Per_Hadir_PRULepas: response.data['Kpi_Per_Hadir_PRULepas'],
      // Kpi_PemilihHadir: response.data['Kpi_PemilihHadir'],
      // Kpi_Undi_AsasMenang: response.data['Kpi_Undi_AsasMenang'],
      // Kpi_P100: response.data['Kpi_P100'],
      // Kpi_BukanP100: response.data['Kpi_BukanP100'],
      // Kpi_P100_Undi_AsasMenang: response.data['Kpi_P100_Undi_AsasMenang'],
      // Kpi_Status_Simulasi_Majoriti100: response.data['Kpi_Status_Simulasi_Majoriti100'],
      // Kpi_Status_Majoriti100: response.data['Kpi_Status_Majoriti100'],
      // Kpi_Status_Majoriti95: response.data['Kpi_Status_Majoriti95'],
      // Kpi_Status_Majoriti90: response.data['Kpi_Status_Majoriti90'],
      // Kpi_Status_Majoriti85: response.data['Kpi_Status_Majoriti85'],
      // Kpi_Status_Majoriti80: response.data['Kpi_Status_Majoriti80'],
      // Kpi_Status_Majoriti75: response.data['Kpi_Status_Majoriti75'],


      Parlimen_JumRETAIN: response.data['Parlimen_JumRETAIN'],
      Parlimen_JumREGAIN: response.data['Parlimen_JumREGAIN'],
      Parlimen_JumREDUCE: response.data['Parlimen_JumREDUCE'],
      Parlimen_JumMENANG: response.data['Parlimen_JumMENANG'],
      Parlimen_JumKALAH: response.data['Parlimen_JumKALAH'],
      Parlimen_All: response.data['Parlimen_All'],

      DUN_JumRETAIN: response.data['DUN_JumRETAIN'],
      DUN_JumREGAIN: response.data['DUN_JumREGAIN'],
      DUN_JumREDUCE: response.data['DUN_JumREDUCE'],
      DUN_JumMENANG: response.data['DUN_JumMENANG'],
      DUN_JumKALAH: response.data['DUN_JumKALAH'],
      DUN_All: response.data['DUN_All'],

      DM_JumRETAIN: response.data['DM_JumRETAIN'],
      DM_JumREGAIN: response.data['DM_JumREGAIN'],
      DM_JumREDUCE: response.data['DM_JumREDUCE'],
      DM_JumMENANG: response.data['DM_JumMENANG'],
      DM_JumKALAH: response.data['DM_JumKALAH'],
      DM_All: response.data['DM_All'],



      PRUBefore_Pemilih: response.data['PRUBefore_Pemilih'],
      PRUBefore_Peratusan_Hadir: response.data['PRUBefore_Peratusan_Hadir'],
      PRUBefore_Pemilih_Hadir: response.data['PRUBefore_Pemilih_Hadir'],
      PRUBefore_NamaParti: response.data['PRUBefore_NamaParti'],
      PRUBefore_NamaKomponen: response.data['PRUBefore_NamaKomponen'],
      PRUBefore_UndiDapat: response.data['PRUBefore_UndiDapat'],


      PRUBefore_NamaParti2: response.data['PRUBefore_NamaParti2'],
      PRUBefore_NamaKomponen2: response.data['PRUBefore_NamaKomponen2'],
      PRUBefore_UndiDapat2: response.data['PRUBefore_UndiDapat2'],
      PRUBefore_Majoriti: response.data['PRUBefore_Majoriti'],
      PRUBefore_PartiMenang: response.data['PRUBefore_PartiMenang'],
      PRUBefore_Status_Kawasan: response.data['PRUBefore_Status_Kawasan'],
      PRUBefore_Name: response.data['PRUBefore_Name'],

      St_Pacu_Cawangan_ByPar:  response.data['St_Pacu_Cawangan_ByPar'],
      St_Pacu_Cawangan_ByPar_AdaDM:  response.data['St_Pacu_Cawangan_ByPar_AdaDM'],
      St_Pacu_Cawangan_ByPar_TiadaDM:  response.data['St_Pacu_Cawangan_ByPar_TiadaDM'],
      St_Pacu_Cawangan:  response.data['St_Pacu_Cawangan'],
      St_Pacu_Ahli:  response.data['St_Pacu_Ahli'],
      St_Pacu_Ahli_G:  response.data['St_Pacu_Ahli_G'],
      St_Pacu_Ahli_W:  response.data['St_Pacu_Ahli_W'],
      St_Pacu_Ahli_Y:  response.data['St_Pacu_Ahli_Y'],
      St_Pacu_Ahli_P:  response.data['St_Pacu_Ahli_P'],
      St_Pacu_Ahli_Pemilih:  response.data['St_Pacu_Ahli_Pemilih'],
      St_Pacu_Ahli_G_Pemilih:  response.data['St_Pacu_Ahli_G_Pemilih'],
      St_Pacu_Ahli_W_Pemilih:  response.data['St_Pacu_Ahli_W_Pemilih'],
      St_Pacu_Ahli_Y_Pemilih:  response.data['St_Pacu_Ahli_Y_Pemilih'],
      St_Pacu_Ahli_P_Pemilih:  response.data['St_Pacu_Ahli_P_Pemilih'],
      St_Pacu_Ahli_Pemilih_AhliDPar:  response.data['St_Pacu_Ahli_Pemilih_AhliDPar'],
      St_Pacu_Ahli_Pemilih_AhliLPar:  response.data['St_Pacu_Ahli_Pemilih_AhliLPar'],
      Kpi_Pacu_JCaw:  response.data['Kpi_Pacu_JCaw'],
      Kpi_Pacu_JCaw_JejakAhli:  response.data['Kpi_Pacu_JCaw_JejakAhli'],
      Kpi_Pacu_JCaw_JejakAhliPemilih:  response.data['Kpi_Pacu_JCaw_JejakAhliPemilih'],
      Dy0b_Pacu_JCaw:  response.data['Dy0b_Pacu_JCaw'],
      Dy0b_Pacu_JCaw_JejakAhli:  response.data['Dy0b_Pacu_JCaw_JejakAhli'],
      Dy0b_Pacu_JCaw_JejakAhliPemilih:  response.data['Dy0b_Pacu_JCaw_JejakAhliPemilih'],
      Dy0b_Pacu_JCaw_Matching:  response.data['Dy0b_Pacu_JCaw_Matching'],

      Dy1__Pacu_JCaw_MatchingP:  response.data['Dy1__Pacu_JCaw_MatchingP'],
      Dy1__Pacu_JCaw_MatchingK:  response.data['Dy1__Pacu_JCaw_MatchingK'],
      Dy1__Pacu_JCaw_MatchingH:  response.data['Dy1__Pacu_JCaw_MatchingH'],
      Dy1__Pacu_JCaw_MatchingT:  response.data['Dy1__Pacu_JCaw_MatchingT'],
      Dy1__Pacu_JCaw_MatchingM:  response.data['Dy1__Pacu_JCaw_MatchingM'],
      Dy1__Pacu_JCaw_MatchingBanci:  response.data['Dy1__Pacu_JCaw_MatchingBanci'],
      Dy1__Pacu_JCaw_MatchingBBanci:  response.data['Dy1__Pacu_JCaw_MatchingBBanci'],

      Dy5_JCaw_P_Dt0: response.data['Dy5_JCaw_P_Dt0'],
      Dy5_JCaw_P_Dt1: response.data['Dy5_JCaw_P_Dt1'],
      Dy5_JCaw_P_Dt2: response.data['Dy5_JCaw_P_Dt2'],
      Dy5_JCaw_P_Dt3: response.data['Dy5_JCaw_P_Dt3'],
      Dy5_JCaw_P_Dt4: response.data['Dy5_JCaw_P_Dt4'],
      Dy5_JCaw_P_Dt5: response.data['Dy5_JCaw_P_Dt5'],
      Dy5_JCaw_P_Dt6: response.data['Dy5_JCaw_P_Dt6'],
      Dy5_JCaw_P_Dt7: response.data['Dy5_JCaw_P_Dt7'],
      Dy5_JR_P_Dt0: response.data['Dy5_JR_P_Dt0'],
      Dy5_JR_P_Dt1: response.data['Dy5_JR_P_Dt1'],
      Dy5_JR_P_Dt2: response.data['Dy5_JR_P_Dt2'],
      Dy5_JR_P_Dt3: response.data['Dy5_JR_P_Dt3'],
      Dy5_JR_P_Dt4: response.data['Dy5_JR_P_Dt4'],
      Dy5_JR_P_Dt5: response.data['Dy5_JR_P_Dt5'],
      Dy5_JR_P_Dt6: response.data['Dy5_JR_P_Dt6'],
      Dy5_JR_P_Dt7: response.data['Dy5_JR_P_Dt7'],
      Dy5_NoTel_HF_Dt0: response.data['Dy5_NoTel_HF_Dt0'],
      Dy5_NoTel_HF_Dt1: response.data['Dy5_NoTel_HF_Dt1'],
      Dy5_NoTel_HF_Dt2: response.data['Dy5_NoTel_HF_Dt2'],
      Dy5_NoTel_HF_Dt3: response.data['Dy5_NoTel_HF_Dt3'],
      Dy5_NoTel_HF_Dt4: response.data['Dy5_NoTel_HF_Dt4'],
      Dy5_NoTel_HF_Dt5: response.data['Dy5_NoTel_HF_Dt5'],
      Dy5_NoTel_HF_Dt6: response.data['Dy5_NoTel_HF_Dt6'],
      Dy5_NoTel_HF_Dt7: response.data['Dy5_NoTel_HF_Dt7'],





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