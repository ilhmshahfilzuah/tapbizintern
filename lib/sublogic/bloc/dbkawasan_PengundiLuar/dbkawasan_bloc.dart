import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanBloc_PengundiLuar extends Bloc<DbKawasanEvent, DbKawasanState> {
  DbKawasanBloc_PengundiLuar() : super(InitialDbKawasanState()) {
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

  // emit(GetDbKawasanWaiting());
  try {
    late var postdata;
    late String apiUrl;
    if (event.paparanQuery == 'Senarai Negeri') {
      postdata = {
        "flag": event.flag,
        "stateCode": event.kodNegeriQuerySub,
        "parlimenCode": event.kodParlimenQuerySub,
        "dunCode": event.kodDunQuerySub,
        "dmCode": event.kodDmQuerySub
      };
      apiUrl = 'dbKODKawasan/listKODState';
    }
    if (event.paparanQuery == 'Senarai Parlimen/Bhgn') {
      postdata = {
        "flag": event.flag,
        "stateCode": event.kodNegeriQuerySub,
        "parlimenCode": event.kodParlimenQuerySub,
        "dunCode": event.kodDunQuerySub,
        "dmCode": event.kodDmQuerySub
      };
      apiUrl = 'dbKODKawasan/listKODStateArea';
    }
    if (event.paparanQuery == 'Senarai Dun') {
      postdata = {
        "flag": event.flag,
        "stateCode": event.kodNegeriQuerySub,
        "parlimenCode": event.kodParlimenQuerySub,
        "dunCode": event.kodDunQuerySub,
        "dmCode": event.kodDmQuerySub
      };
      apiUrl = 'dbKODKawasan/listKODStateAreaDun';
    }
    if (event.paparanQuery == 'Senarai Dm') {
      postdata = {
        "flag": event.flag,
        "stateCode": event.kodNegeriQuerySub,
        "parlimenCode": event.kodParlimenQuerySub,
        "dunCode": event.kodDunQuerySub,
        "dmCode": event.kodDmQuerySub
      };
      apiUrl = 'dbKODKawasan/listKODStateAreaDunDm';
    }
    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      if (event.paparanQuery == 'Senarai Negeri') {
        data = (response.data as Map<String, dynamic>)['DbState'];
      }
      if (event.paparanQuery == 'Senarai Parlimen/Bhgn') {
        data = (response.data as Map<String, dynamic>)['DbStateArea'];
      }
      if (event.paparanQuery == 'Senarai Dun') {
        data = (response.data as Map<String, dynamic>)['DbStateAreaDun'];
      }
      if (event.paparanQuery == 'Paparan Dun') {
        data = (response.data as Map<String, dynamic>)['DbStateAreaDunDm'];
      }
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    if (event.paparanQuery == 'Paparan Dm') {
      emit(GetDbKawasanSuccess(
        listDbKawasan: datajson,
      ));
    } else {
      emit(GetDbKawasanSuccess(
        listDbKawasan: datajson,
        //----
        JumPemilih: 0,
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