import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc_StatST extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc_StatST() : super(InitialDbKawasanState()) {
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
      JumLokaliti: response.data['JumLokaliti'],
      JumPemilih: response.data['JumPemilih'],
      JumPemilihLelaki: response.data['JumPemilihLelaki'],
      JumPemilihPerempuan: response.data['JumPemilihPerempuan'],
      JumPemilihM: response.data['JumPemilihM'],
      JumPemilihC: response.data['JumPemilihC'],
      JumPemilihI: response.data['JumPemilihI'],
      JumPemilihL: response.data['JumPemilihL'],
      JumPemilihU0: response.data['JumPemilihU0'],
      JumPemilihU1: response.data['JumPemilihU1'],
      JumPemilihU2: response.data['JumPemilihU2'],
      JumPemilihU3: response.data['JumPemilihU3'],
      JumPemilihU4: response.data['JumPemilihU4'],
      JumPemilihU5: response.data['JumPemilihU5'],
      JumPemilihU6: response.data['JumPemilihU6'],
      JumPemilihU7: response.data['JumPemilihU7'],
      // JumPemilihU0L: response.data['JumPemilihU0L'],
      // JumPemilihU0LM: response.data['JumPemilihU0LM'],
      // JumPemilihU0LC: response.data['JumPemilihU0LC'],
      // JumPemilihU0LI: response.data['JumPemilihU0LI'],
      // JumPemilihU0LL: response.data['JumPemilihU0LL'],
      // JumPemilihU0P: response.data['JumPemilihU0P'],
      // JumPemilihU0PM: response.data['JumPemilihU0PM'],
      // JumPemilihU0PC: response.data['JumPemilihU0PC'],
      // JumPemilihU0PI: response.data['JumPemilihU0PI'],
      // JumPemilihU0PL: response.data['JumPemilihU0PL'],
      // JumPemilih01L: response.data['JumPemilih01L'],
      // JumPemilih01LM: response.data['JumPemilih01LM'],
      // JumPemilih01LC: response.data['JumPemilih01LC'],
      // JumPemilih01LI: response.data['JumPemilih01LI'],
      // JumPemilih01LL: response.data['JumPemilih01LL'],
      // JumPemilih01P: response.data['JumPemilih01P'],
      // JumPemilih01PM: response.data['JumPemilih01PM'],
      // JumPemilih01PC: response.data['JumPemilih01PC'],
      // JumPemilih01PI: response.data['JumPemilih01PI'],
      // JumPemilih01PL: response.data['JumPemilih01PL'],
      // JumPemilih02L: response.data['JumPemilih02L'],
      // JumPemilih02LM: response.data['JumPemilih02LM'],
      // JumPemilih02LC: response.data['JumPemilih02LC'],
      // JumPemilih02LI: response.data['JumPemilih02LI'],
      // JumPemilih02LL: response.data['JumPemilih02LL'],
      // JumPemilih02P: response.data['JumPemilih02P'],
      // JumPemilih02PM: response.data['JumPemilih02PM'],
      // JumPemilih02PC: response.data['JumPemilih02PC'],
      // JumPemilih02PI: response.data['JumPemilih02PI'],
      // JumPemilih02PL: response.data['JumPemilih02PL'],
      // JumPemilih03L: response.data['JumPemilih03L'],
      // JumPemilih03LM: response.data['JumPemilih03LM'],
      // JumPemilih03LC: response.data['JumPemilih03LC'],
      // JumPemilih03LI: response.data['JumPemilih03LI'],
      // JumPemilih03LL: response.data['JumPemilih03LL'],
      // JumPemilih03P: response.data['JumPemilih03P'],
      // JumPemilih03PM: response.data['JumPemilih03PM'],
      // JumPemilih03PC: response.data['JumPemilih03PC'],
      // JumPemilih03PI: response.data['JumPemilih03PI'],
      // JumPemilih03PL: response.data['JumPemilih03PL'],
      // JumPemilih04L: response.data['JumPemilih04L'],
      // JumPemilih04LM: response.data['JumPemilih04LM'],
      // JumPemilih04LC: response.data['JumPemilih04LC'],
      // JumPemilih04LI: response.data['JumPemilih04LI'],
      // JumPemilih04LL: response.data['JumPemilih04LL'],
      // JumPemilih04P: response.data['JumPemilih04P'],
      // JumPemilih04PM: response.data['JumPemilih04PM'],
      // JumPemilih04PC: response.data['JumPemilih04PC'],
      // JumPemilih04PI: response.data['JumPemilih04PI'],
      // JumPemilih04PL: response.data['JumPemilih04PL'],
      // JumPemilih05L: response.data['JumPemilih05L'],
      // JumPemilih05LM: response.data['JumPemilih05LM'],
      // JumPemilih05LC: response.data['JumPemilih05LC'],
      // JumPemilih05LI: response.data['JumPemilih05LI'],
      // JumPemilih05LL: response.data['JumPemilih05LL'],
      // JumPemilih05P: response.data['JumPemilih05P'],
      // JumPemilih05PM: response.data['JumPemilih05PM'],
      // JumPemilih05PC: response.data['JumPemilih05PC'],
      // JumPemilih05PI: response.data['JumPemilih05PI'],
      // JumPemilih05PL: response.data['JumPemilih05PL'],
      // JumPemilih06L: response.data['JumPemilih06L'],
      // JumPemilih06LM: response.data['JumPemilih06LM'],
      // JumPemilih06LC: response.data['JumPemilih06LC'],
      // JumPemilih06LI: response.data['JumPemilih06LI'],
      // JumPemilih06LL: response.data['JumPemilih06LL'],
      // JumPemilih06P: response.data['JumPemilih06P'],
      // JumPemilih06PM: response.data['JumPemilih06PM'],
      // JumPemilih06PC: response.data['JumPemilih06PC'],
      // JumPemilih06PI: response.data['JumPemilih06PI'],
      // JumPemilih06PL: response.data['JumPemilih06PL'],
      // JumPemilih07L: response.data['JumPemilih07L'],
      // JumPemilih07LM: response.data['JumPemilih07LM'],
      // JumPemilih07LC: response.data['JumPemilih07LC'],
      // JumPemilih07LI: response.data['JumPemilih07LI'],
      // JumPemilih07LL: response.data['JumPemilih07LL'],
      // JumPemilih07P: response.data['JumPemilih07P'],
      // JumPemilih07PM: response.data['JumPemilih07PM'],
      // JumPemilih07PC: response.data['JumPemilih07PC'],
      // JumPemilih07PI: response.data['JumPemilih07PI'],
      // JumPemilih07PL: response.data['JumPemilih07PL'],
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