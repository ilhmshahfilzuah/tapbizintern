import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

import 'dart:convert';

class DbKawasanSubBloc extends Bloc<DbKawasanSubEvent, DbKawasanSubState> {
  DbKawasanSubBloc() : super(InitialDbKawasanSubState()) {
    on(_getDbKawasanSubWaiting);
    on<GetDbKawasanSubQuery>(_getDbKawasanSubQuery);
  }
}

_getDbKawasanSubWaiting(GetDbKawasanSubWaiting event, Emitter<DbKawasanSubState> emit) {
  emit(GetDbKawasanSubWaiting());
}

// --------------ByQuery
void _getDbKawasanSubQuery(GetDbKawasanSubQuery event, Emitter<DbKawasanSubState> emit) async {
  ApiProvider _apiProvider = ApiProvider();

  // emit(GetDbKawasanSubWaiting());
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
    emit(GetDbKawasanSubQuerySuccess(
      listDbKawasan: datajson,
    ));

    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbKawasanSubError(errorMessage: ex.toString()));
    }
  }
}
// --------------ByQuery