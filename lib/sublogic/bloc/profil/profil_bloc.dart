import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../subdata/network/api_provider.dart';
import './bloc.dart';

import 'dart:convert';

class DbDataProfilBloc_Profil extends Bloc<DbDataProfilEvent, DbDataProfilState> {
  DbDataProfilBloc_Profil() : super(InitialDbDataProfilState()) {
    on<GetDbDataProfil>(_getDbDataProfil);
    on<UpdateDbDataProfil>(_updateDbDataProfil);
    on<ResetKodLaluanDbDataProfil>(_resetKodLaluan);
  }
}


void _getDbDataProfil(GetDbDataProfil event, Emitter<DbDataProfilState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  emit(GetDbDataProfilWaiting());
  try {
    // late var postdata;
    late String apiUrl;

    FormData postdata = FormData.fromMap({
      "User_IC": event.IC_Pengguna, 
      });

    apiUrl = 'getProfil';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;

    if (response.data['success'] == true) {

    }


    //------------------------------------------------------------
      emit(GetDbDataProfilSuccess(
        //--------------butiran pemilih
      Nama: response.data['Nama'],
      IC: response.data['IC'],
      Jantina: response.data['Jantina'],

      KodNegeri: response.data['KodNegeri'],
      KodDM: response.data['KodDM'],
      KodParlimen: response.data['KodParlimen'],
      NamaParlimen: response.data['NamaParlimen'],
      NamaDUN: response.data['NamaDUN'],
      NamaDM: response.data['NamaDM'],
      NamaLokaliti: response.data['NamaLokaliti'],

      NoSaluran: response.data['NoSaluran'],
      tm: response.data['tm'],

      ALAMAT1_JPN: response.data['ALAMAT1_JPN'],
      ALAMAT2_JPN: response.data['ALAMAT2_JPN'],
      ALAMAT3_JPN: response.data['ALAMAT3_JPN'],
      POSKOD_JPN: response.data['POSKOD_JPN'],
      BANDAR_JPN: response.data['BANDAR_JPN'],
      Sikap: response.data['Sikap'],
      Status: response.data['Status'],
      SikapM: response.data['SikapM'],
      NO_TEL_JPN: response.data['NO_TEL_JPN'],
      Catatan: response.data['Catatan'],
      HandbilDigitalTxt: response.data['HandbilDigitalTxt'],
      //--------
      JRNegeri: response.data['JRNegeri'],
      JRNamaParlimen: response.data['JRNamaParlimen'],
      JRNamaDun: response.data['JRNamaDun'],
      JRNamaDM: response.data['JRNamaDM'],
      JRnama: response.data['JRnama'],
      JRno_tel1: response.data['JRno_tel1'],
        //--------------butiran pemilih
      ));
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbDataProfilError(errorMessage: ex.toString()));
    }
  }
}

void _updateDbDataProfil(UpdateDbDataProfil event, Emitter<DbDataProfilState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  emit(GetDbDataProfilWaiting());
  try {
    // late var postdata;
    late String apiUrl;

    FormData postdata = FormData.fromMap({
      "User_IC": event.IC_Pengguna, 
      "nedField": event.nedField, 
      "nedField_Data": event.nedField_Data
      });

    if (event.image != null) {
      postdata.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            event.image!.path,
            filename: event.image!.path.split('/').last,
          )));
    }

    apiUrl = 'updateProfil';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      final userModel = (response.data as Map<String, dynamic>)['User'];
      Map<String, dynamic> map = userModel;
      String user = jsonEncode(map);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user);
    }
    //------------------------------------------------------------
      emit(UpdateDbDataProfilSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbDataProfilError(errorMessage: ex.toString()));
    }
  }
}
void _resetKodLaluan(ResetKodLaluanDbDataProfil event, Emitter<DbDataProfilState> emit) async {
  ApiProvider _apiProvider = ApiProvider();
  emit(GetDbDataProfilWaiting());
  try {
    // late var postdata;
    late String apiUrl;

    FormData postdata = FormData.fromMap({
      "User_IC": event.IC_Pengguna, 
      "nedField": event.nedField, 
      "nedField_Data": event.nedField_Data
      });

    if (event.image != null) {
      postdata.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            event.image!.path,
            filename: event.image!.path.split('/').last,
          )));
    }

    apiUrl = 'resetKodLaluan';

    //---------------------------------------------------
    final response = await _apiProvider.postConnect(apiUrl, postdata);
    dynamic data;
    if (response.data['success'] == true) {
      final userModel = (response.data as Map<String, dynamic>)['User'];
      Map<String, dynamic> map = userModel;
      String user = jsonEncode(map);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user);
    }
    //------------------------------------------------------------
      emit(UpdateDbDataProfilSuccess());
    //------------------------------------------------------------
  } catch (ex) {
    if (ex != 'cancel') {
      emit(GetDbDataProfilError(errorMessage: ex.toString()));
    }
  }
}