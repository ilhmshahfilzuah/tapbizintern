import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc_StatJPMPuteri extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc_StatJPMPuteri() : super(InitialDbKawasanState()) {
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
        JumJR: response.data['JumJR'],
        JumJRAktif: response.data['JumJRAktif'],
        JumJRXAktif: response.data['JumJRXAktif'],
        JumPemilihM: response.data['JumPemilihM'],
        KaumMPu: response.data['KaumMPu'],
        KaumMK: response.data['KaumMK'],
        KaumMH: response.data['KaumMH'],
        KaumMT: response.data['KaumMT'],
        KaumMM: response.data['KaumMM'],
        KaumMBanci: response.data['KaumMBanci'],
        KaumMBBanci: response.data['KaumMBBanci'],
        XMatchingM: response.data['XMatchingM'],
        MatchingM: response.data['MatchingM'],
        XMatchingMP: response.data['XMatchingMP'],
        MatchingMP: response.data['MatchingMP'],
        MatchingMK: response.data['MatchingMK'],
        MatchingMH: response.data['MatchingMH'],
        MatchingMT: response.data['MatchingMT'],
        MatchingMM: response.data['MatchingMM'],
        MatchingMBanci: response.data['MatchingMBanci'],
        MatchingMBBanci: response.data['MatchingMBBanci'],
        P: response.data['P'],
        K: response.data['K'],
        H: response.data['H'],
        T: response.data['T'],
        M: response.data['M'],
        Banci: response.data['Banci'],
        BBanci: response.data['BBanci'],
        GOTVBB: response.data['GOTVBB'],
        GOTVP: response.data['GOTVP'],
        GOTVK: response.data['GOTVK'],
        GOTVH: response.data['GOTVH'],
        GOTVT: response.data['GOTVT'],
        GOTVM: response.data['GOTVM'],
        XJR: response.data['XJR'],
        XJR_BB: response.data['XJR_BB'],
        XJR_P: response.data['XJR_P'],
        XJR_K: response.data['XJR_K'],
        XJR_H: response.data['XJR_H'],
        XJR_T: response.data['XJR_T'],
        XJR_M: response.data['XJR_M'],

        XJR_BB_GOTVBB: response.data['XJR_BB_GOTVBB'],
        XJR_BB_GOTVP: response.data['XJR_BB_GOTVP'],
        XJR_BB_GOTVK: response.data['XJR_BB_GOTVK'],
        XJR_BB_GOTVH: response.data['XJR_BB_GOTVH'],
        XJR_BB_GOTVT: response.data['XJR_BB_GOTVT'],
        XJR_BB_GOTVM: response.data['XJR_BB_GOTVM'],
        XJR_P_GOTVBB: response.data['XJR_P_GOTVBB'],
        XJR_P_GOTVP: response.data['XJR_P_GOTVP'],
        XJR_P_GOTVK: response.data['XJR_P_GOTVK'],
        XJR_P_GOTVH: response.data['XJR_P_GOTVH'],
        XJR_P_GOTVT: response.data['XJR_P_GOTVT'],
        XJR_P_GOTVM: response.data['XJR_P_GOTVM'],
        XJR_K_GOTVBB: response.data['XJR_K_GOTVBB'],
        XJR_K_GOTVP: response.data['XJR_K_GOTVP'],
        XJR_K_GOTVK: response.data['XJR_K_GOTVK'],
        XJR_K_GOTVH: response.data['XJR_K_GOTVH'],
        XJR_K_GOTVT: response.data['XJR_K_GOTVT'],
        XJR_K_GOTVM: response.data['XJR_K_GOTVM'],
        XJR_H_GOTVBB: response.data['XJR_H_GOTVBB'],
        XJR_H_GOTVP: response.data['XJR_H_GOTVP'],
        XJR_H_GOTVK: response.data['XJR_H_GOTVK'],
        XJR_H_GOTVH: response.data['XJR_H_GOTVH'],
        XJR_H_GOTVT: response.data['XJR_H_GOTVT'],
        XJR_H_GOTVM: response.data['XJR_H_GOTVM'],
        XJR_T_GOTVBB: response.data['XJR_T_GOTVBB'],
        XJR_T_GOTVP: response.data['XJR_T_GOTVP'],
        XJR_T_GOTVK: response.data['XJR_T_GOTVK'],
        XJR_T_GOTVH: response.data['XJR_T_GOTVH'],
        XJR_T_GOTVT: response.data['XJR_T_GOTVT'],
        XJR_T_GOTVM: response.data['XJR_T_GOTVM'],
        XJR_M_GOTVBB: response.data['XJR_M_GOTVBB'],
        XJR_M_GOTVP: response.data['XJR_M_GOTVP'],
        XJR_M_GOTVK: response.data['XJR_M_GOTVK'],
        XJR_M_GOTVH: response.data['XJR_M_GOTVH'],
        XJR_M_GOTVT: response.data['XJR_M_GOTVT'],
        XJR_M_GOTVM: response.data['XJR_M_GOTVM'],
        U18_40: response.data['U18_40'],
        U18_40_XJR: response.data['U18_40_XJR'],
        U18_40_XJR_BB: response.data['U18_40_XJR_BB'],
        U18_40_XJR_P: response.data['U18_40_XJR_P'],
        U18_40_XJR_K: response.data['U18_40_XJR_K'],
        U18_40_XJR_H: response.data['U18_40_XJR_H'],
        U18_40_XJR_T: response.data['U18_40_XJR_T'],
        U18_40_XJR_M: response.data['U18_40_XJR_M'],

        U18_40_BB: response.data['U18_40_BB'],
        U18_40_P: response.data['U18_40_P'],
        U18_40_K: response.data['U18_40_K'],
        U18_40_H: response.data['U18_40_H'],
        U18_40_T: response.data['U18_40_T'],
        U18_40_M: response.data['U18_40_M'],
        Hadir2: response.data['Hadir2'],
        U18_40_Hadir2: response.data['U18_40_Hadir2'],

        UmurU0LM: response.data['UmurU0LM'],
        UmurU0PM: response.data['UmurU0PM'],
        UmurU1LM: response.data['UmurU1LM'],
        UmurU1PM: response.data['UmurU1PM'],
        UmurU2LM: response.data['UmurU2LM'],
        UmurU2PM: response.data['UmurU2PM'],


        XJRM: response.data['XJRM'],
        XJRM_GOTVP: response.data['XJRM_GOTVP'],
        XJRM_GOTVK: response.data['XJRM_GOTVK'],
        XJRM_GOTVH: response.data['XJRM_GOTVH'],
        XJRM_GOTVT: response.data['XJRM_GOTVT'],
        XJRM_GOTVM: response.data['XJRM_GOTVM'],
        XJRM_GOTVBB: response.data['XJRM_GOTVBB'],

        JRM: response.data['JRM'],
        JRM_GOTVP: response.data['JRM_GOTVP'],
        JRM_GOTVK: response.data['JRM_GOTVK'],
        JRM_GOTVH: response.data['JRM_GOTVH'],
        JRM_GOTVT: response.data['JRM_GOTVT'],
        JRM_GOTVM: response.data['JRM_GOTVM'],
        JRM_GOTVBB: response.data['JRM_GOTVBB'],

        JRM_PKHM: response.data['JRM_PKHM'],
        JRM_PKHM_GOTVP: response.data['JRM_PKHM_GOTVP'],
        JRM_PKHM_GOTVK: response.data['JRM_PKHM_GOTVK'],
        JRM_PKHM_GOTVH: response.data['JRM_PKHM_GOTVH'],
        JRM_PKHM_GOTVT: response.data['JRM_PKHM_GOTVT'],
        JRM_PKHM_GOTVM: response.data['JRM_PKHM_GOTVM'],
        JRM_PKHM_GOTVBB: response.data['JRM_PKHM_GOTVBB'],

        JRM_T: response.data['JRM_T'],
        JRM_T_GOTVP: response.data['JRM_T_GOTVP'],
        JRM_T_GOTVK: response.data['JRM_T_GOTVK'],
        JRM_T_GOTVH: response.data['JRM_T_GOTVH'],
        JRM_T_GOTVT: response.data['JRM_T_GOTVT'],
        JRM_T_GOTVM: response.data['JRM_T_GOTVM'],
        JRM_T_GOTVBB: response.data['JRM_T_GOTVBB'],

        JRM_BB: response.data['JRM_BB'],
        JRM_BB_GOTVP: response.data['JRM_BB_GOTVP'],
        JRM_BB_GOTVK: response.data['JRM_BB_GOTVK'],
        JRM_BB_GOTVH: response.data['JRM_BB_GOTVH'],
        JRM_BB_GOTVT: response.data['JRM_BB_GOTVT'],
        JRM_BB_GOTVM: response.data['JRM_BB_GOTVM'],
        JRM_BB_GOTVBB: response.data['JRM_BB_GOTVBB'],

        MUDA_XJRM: response.data['MUDA_XJRM'],
        MUDA_XJRM_GOTVP: response.data['MUDA_XJRM_GOTVP'],
        MUDA_XJRM_GOTVK: response.data['MUDA_XJRM_GOTVK'],
        MUDA_XJRM_GOTVH: response.data['MUDA_XJRM_GOTVH'],
        MUDA_XJRM_GOTVT: response.data['MUDA_XJRM_GOTVT'],
        MUDA_XJRM_GOTVM: response.data['MUDA_XJRM_GOTVM'],
        MUDA_XJRM_GOTVBB: response.data['MUDA_XJRM_GOTVBB'],

        MUDA_JRM_T: response.data['MUDA_JRM_T'],
        MUDA_JRM_T_GOTVP: response.data['MUDA_JRM_T_GOTVP'],
        MUDA_JRM_T_GOTVK: response.data['MUDA_JRM_T_GOTVK'],
        MUDA_JRM_T_GOTVH: response.data['MUDA_JRM_T_GOTVH'],
        MUDA_JRM_T_GOTVT: response.data['MUDA_JRM_T_GOTVT'],
        MUDA_JRM_T_GOTVM: response.data['MUDA_JRM_T_GOTVM'],
        MUDA_JRM_T_GOTVBB: response.data['MUDA_JRM_T_GOTVBB'],

        MUDA_JRM_BB: response.data['MUDA_JRM_BB'],
        MUDA_JRM_BB_GOTVP: response.data['MUDA_JRM_BB_GOTVP'],
        MUDA_JRM_BB_GOTVK: response.data['MUDA_JRM_BB_GOTVK'],
        MUDA_JRM_BB_GOTVH: response.data['MUDA_JRM_BB_GOTVH'],
        MUDA_JRM_BB_GOTVT: response.data['MUDA_JRM_BB_GOTVT'],
        MUDA_JRM_BB_GOTVM: response.data['MUDA_JRM_BB_GOTVM'],
        MUDA_JRM_BB_GOTVBB: response.data['MUDA_JRM_BB_GOTVBB'], 

        SARGOTV_Keseluruhan_m: response.data['SARGOTV_Keseluruhan_m'], 
        SARGOTV_JJR_m: response.data['SARGOTV_JJR_m'], 
        SARGOTV_JGOTV_m: response.data['SARGOTV_JGOTV_m'], 
        SARGOTV_JGOTV_m_GOTVP: response.data['SARGOTV_JGOTV_m_GOTVP'], 
        SARGOTV_JGOTV_m_GOTVBB: response.data['SARGOTV_JGOTV_m_GOTVBB'],      

 
        MUDA_Keseluruhan_m: response.data['SARGOTV_Keseluruhan_m'], 
        MUDA_JJR_m: response.data['SARGOTV_JJR_m'], 
        MUDA_JBM_m: response.data['SARGOTV_JGOTV_m'], 
        MUDA_JBM_m_GOTVP: response.data['SARGOTV_JGOTV_m_GOTVP'], 
        MUDA_JBM_m_GOTVBB: response.data['SARGOTV_JGOTV_m_GOTVBB'],   

        KaumM_L_1: response.data['KaumM_L_1'],  
        KaumM_L_1_P: response.data['KaumM_L_1_P'],       
        KaumM_L_1_K: response.data['KaumM_L_1_K'],       
        KaumM_L_1_H: response.data['KaumM_L_1_H'],       
        KaumM_L_1_T: response.data['KaumM_L_1_T'],       
        KaumM_L_1_M: response.data['KaumM_L_1_M'],       
        KaumM_L_1_Banci: response.data['KaumM_L_1_Banci'],
        KaumM_L_1_BBanci: response.data['KaumM_L_1_BBanci'],     

        KaumM_P_2: response.data['KaumM_P_2'],  
        KaumM_P_2_P: response.data['KaumM_P_2_P'],       
        KaumM_P_2_K: response.data['KaumM_P_2_K'],       
        KaumM_P_2_H: response.data['KaumM_P_2_H'],       
        KaumM_P_2_T: response.data['KaumM_P_2_T'],       
        KaumM_P_2_M: response.data['KaumM_P_2_M'],       
        KaumM_P_2_Banci: response.data['KaumM_P_2_Banci'],
        KaumM_P_2_BBanci: response.data['KaumM_P_2_BBanci'],     

        KaumM_L_3: response.data['KaumM_L_3'],  
        KaumM_L_3_P: response.data['KaumM_L_3_P'],       
        KaumM_L_3_K: response.data['KaumM_L_3_K'],       
        KaumM_L_3_H: response.data['KaumM_L_3_H'],       
        KaumM_L_3_T: response.data['KaumM_L_3_T'],       
        KaumM_L_3_M: response.data['KaumM_L_3_M'],       
        KaumM_L_3_Banci: response.data['KaumM_L_3_Banci'],
        KaumM_L_3_BBanci: response.data['KaumM_L_3_BBanci'],     

        KaumM_P_4: response.data['KaumM_P_4'],  
        KaumM_P_4_P: response.data['KaumM_P_4_P'],       
        KaumM_P_4_K: response.data['KaumM_P_4_K'],       
        KaumM_P_4_H: response.data['KaumM_P_4_H'],       
        KaumM_P_4_T: response.data['KaumM_P_4_T'],       
        KaumM_P_4_M: response.data['KaumM_P_4_M'],       
        KaumM_P_4_Banci: response.data['KaumM_P_4_Banci'],
        KaumM_P_4_BBanci: response.data['KaumM_P_4_BBanci'],     
    
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