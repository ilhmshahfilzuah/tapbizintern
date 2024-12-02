import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import './bloc.dart';

import 'dart:convert';

class DbTemplateBloc extends Bloc<DbTemplateEvent, DbTemplateState> {
  DbTemplateBloc() : super(InitialDbTemplateState()) {
    on(_getDbTemplateWaiting);
    on<GetDbTemplate>(_getDbTemplate);
  }
}

_getDbTemplateWaiting(GetDbTemplateWaiting event, Emitter<DbTemplateState> emit) {
  emit(GetDbTemplateWaiting());
}

void _getDbTemplate(GetDbTemplate event, Emitter<DbTemplateState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  emit(GetDbTemplateWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      
      // "flag": event.flag,
      // "IC_Pengguna": event.IC_Pengguna,
      "userId": event.ID_Pengguna
    };

    apiUrl = 'Templatelogs/listTemplateByUser';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['UserTemplateLogs'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbTemplateSuccess(
      UserTemplateLogs: datajson,
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbTemplateError(errorMessage: ex.toString()));
    }
  }
}