import 'package:bloc/bloc.dart';
import '../../../subdata/network/api_provider.dart';
import './bloc.dart';

import 'dart:convert';

class DbKategoriBloc extends Bloc<DbKategoriEvent, DbKategoriState> {
  DbKategoriBloc() : super(InitialDbKategoriState()) {
    on(_getDbKategoriWaiting);
    on<GetDbKategori>(_getDbKategori);
  }
}

_getDbKategoriWaiting(GetDbKategoriWaiting event, Emitter<DbKategoriState> emit) {
  emit(GetDbKategoriWaiting());
}

void _getDbKategori(GetDbKategori event, Emitter<DbKategoriState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  emit(GetDbKategoriWaiting());
  try {
    late var postdata;
    late String apiUrl;

    postdata = {
      
      // "flag": event.flag,
      // "IC_Pengguna": event.IC_Pengguna,
      // "userId": event.ID_Pengguna
    };

    if(event.flag=='Aktiviti'){
    apiUrl = 'dbCategory/listCategoryAktiviti';
    }
    if(event.flag=='Isu'){
    apiUrl = 'dbCategory/listCategoryIsu';
    }
    if(event.flag=='Portfolio'){
    apiUrl = 'dbCategory/listCategoryPortfolio';
    }


    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      data = (response.data as Map<String, dynamic>)['DbCategory'];
    }
    //------------------------------------------------------------
    String datajson = jsonEncode(data);
    emit(GetDbKategoriSuccess(
      DbCategory: datajson,
      //----
      //----
    ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbKategoriError(errorMessage: ex.toString()));
    }
  }
}