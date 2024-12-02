import 'dart:convert';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import '../../../subdata/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'kwsn_state.dart';

class KwsnCubit extends Cubit<KwsnState> {
  KwsnCubit() : super(KwsnInitial());
  late UserModel userClsCubit;
  String? token;
  String? gerakKerjaMod;
  String? accessCatSubIndex;
  bool? isSwitchedStatus;
  //--------Paparan
  late String kodNegeri;
  late String namaNegeri;
  late String kodParlimen;
  late String namaParlimen;
  late String kodDun;
  late String namaDun;
  late String kodDm;
  late String namaDm;
  late String kodLok;
  late String namaLok;

  late String kodNegeriQuery;
  late String namaNegeriQuery;
  late String kodParlimenQuery;
  late String namaParlimenQuery;
  late String kodDunQuery;
  late String namaDunQuery;
  late String kodDmQuery;
  late String namaDmQuery;
  late String kodLokQuery;
  late String namaLokQuery;
  late String paparanQuery;
  late String paparanSenaraiQuery;

  late String paparanSubPusatQuery;
  late String paparanSubNQuery;
  late String paparanSubPQuery;
  late String paparanSubDmQuery;

  void waitingData(){
    emit(WaitingSuccess());
  }

  getUserClsCubit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //---------------------------------------------------------------------------------------

    final userJson = prefs.getString('user') ?? '';
    Map<String, dynamic> map = jsonDecode(userJson);
    userClsCubit = UserModel.fromJson(map);
    //---------------------------------------------------------------------------------------
    //--------Paparan
    if (userClsCubit.userAccess_Type == 'Pusat') {
      prefs.setString('kodNegeri', "");
      prefs.setString('namaNegeri', "");
      prefs.setString('kodParlimen', "");
      prefs.setString('namaParlimen', "");
      prefs.setString('kodDun', "");
      prefs.setString('namaDun', "");
      prefs.setString('kodDm', "");
      prefs.setString('namaDm', "");
      prefs.setString('kodLok', "");
      prefs.setString('namaLok', "");
    }
    if (userClsCubit!.userAccess_Type == 'N') {
      prefs.setString('kodNegeri', userClsCubit!.userUser_Kod_Negeri);
      prefs.setString('namaNegeri', userClsCubit!.userUser_Nama_Negeri);
      prefs.setString('kodParlimen', "");
      prefs.setString('namaParlimen', "");
      prefs.setString('kodDun', "");
      prefs.setString('namaDun', "");
      prefs.setString('kodDm', "");
      prefs.setString('namaDm', "");
      prefs.setString('kodLok', "");
      prefs.setString('namaLok', "");
    }
    if (userClsCubit!.userAccess_Type == 'P') {
      prefs.setString('kodNegeri', userClsCubit!.userUser_Kod_Negeri);
      prefs.setString('namaNegeri', userClsCubit!.userUser_Nama_Negeri);
      prefs.setString('kodParlimen', userClsCubit!.userUser_Kod_Parlimen);
      prefs.setString('namaParlimen', userClsCubit!.userUser_Nama_Parlimen);
      prefs.setString('kodDun', "");
      prefs.setString('namaDun', "");
      prefs.setString('kodDm', "");
      prefs.setString('namaDm', "");
      prefs.setString('kodLok', "");
      prefs.setString('namaLok', "");
    }
    if (userClsCubit!.userAccess_Type == 'Dun') {
      prefs.setString('kodNegeri', userClsCubit!.userUser_Kod_Negeri);
      prefs.setString('namaNegeri', userClsCubit!.userUser_Nama_Negeri);
      prefs.setString('kodParlimen', userClsCubit!.userUser_Kod_Parlimen);
      prefs.setString('namaParlimen', userClsCubit!.userUser_Nama_Parlimen);
      prefs.setString('kodDun', userClsCubit!.userUser_Kod_Dun);
      prefs.setString('namaDun', userClsCubit!.userUser_Nama_Dun);
      prefs.setString('kodDm', "");
      prefs.setString('namaDm', "");
      prefs.setString('kodLok', "");
      prefs.setString('namaLok', "");
    }
    if (userClsCubit!.userAccess_Type == 'Dm') {
      prefs.setString('kodNegeri', userClsCubit!.userUser_Kod_Negeri);
      prefs.setString('namaNegeri', userClsCubit!.userUser_Nama_Negeri);
      prefs.setString('kodParlimen', userClsCubit!.userUser_Kod_Parlimen);
      prefs.setString('namaParlimen', userClsCubit!.userUser_Nama_Parlimen);
      prefs.setString('kodDun', userClsCubit!.userUser_Kod_Dun);
      prefs.setString('namaDun', userClsCubit!.userUser_Nama_Dun);
      prefs.setString('kodDm', userClsCubit!.userUser_Kod_Dm);
      prefs.setString('namaDm', userClsCubit!.userUser_Nama_Dm);
      prefs.setString('kodLok', "");
      prefs.setString('namaLok', "");
    }

    //----
    kodNegeri = prefs.getString('kodNegeri') ?? '';
    namaNegeri = prefs.getString('namaNegeri') ?? '';
    kodParlimen = prefs.getString('kodParlimen') ?? '';
    namaParlimen = prefs.getString('namaParlimen') ?? '';
    kodDun = prefs.getString('kodDun') ?? '';
    namaDun = prefs.getString('namaDun') ?? '';
    kodDm = prefs.getString('kodDm') ?? '';
    namaDm = prefs.getString('namaDm') ?? '';
    kodLok = prefs.getString('kodLok') ?? '';
    namaLok = prefs.getString('namaLok') ?? '';

    //-----
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
    kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
    namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
    kodDunQuery = prefs.getString('kodDunQuery') ?? '';
    namaDunQuery = prefs.getString('namaDunQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
    namaDmQuery = prefs.getString('namaDmQuery') ?? '';
    kodLokQuery = prefs.getString('kodLokQuery') ?? '';
    namaLokQuery = prefs.getString('namaLokQuery') ?? '';
    //----
    // syncKawasan();
    //-------- localStorage
    //--------Paparan
    // emit(ChangeThemeSuccess(isDarkMode));
  }

  syncKawasanCubit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //----
    kodNegeri = prefs.getString('kodNegeri') ?? '';
    namaNegeri = prefs.getString('namaNegeri') ?? '';
    kodParlimen = prefs.getString('kodParlimen') ?? '';
    namaParlimen = prefs.getString('namaParlimen') ?? '';
    kodDun = prefs.getString('kodDun') ?? '';
    namaDun = prefs.getString('namaDun') ?? '';
    kodDm = prefs.getString('kodDm') ?? '';
    namaDm = prefs.getString('namaDm') ?? '';
    kodLok = prefs.getString('kodLok') ?? '';
    namaLok = prefs.getString('namaLok') ?? '';

    //-----
    kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
    namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
    kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
    namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
    kodDunQuery = prefs.getString('kodDunQuery') ?? '';
    namaDunQuery = prefs.getString('namaDunQuery') ?? '';
    kodDmQuery = prefs.getString('kodDmQuery') ?? '';
    namaDmQuery = prefs.getString('namaDmQuery') ?? '';
    kodLokQuery = prefs.getString('kodLokQuery') ?? '';
    namaLokQuery = prefs.getString('namaLokQuery') ?? '';
    //----
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------peringkatQuery
    if (kodNegeriQuery == '') {
      prefs.setString('kodNegeriQuery', prefs.getString('kodNegeri') ?? '');
      kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
      print(kodNegeriQuery);
    }
    if (namaNegeriQuery == '') {
      prefs.setString('namaNegeriQuery', prefs.getString('namaNegeri') ?? '');
      namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
    }
    if (kodParlimenQuery == '') {
      prefs.setString('kodParlimenQuery', prefs.getString('kodParlimen') ?? '');
      kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
    }
    if (namaParlimenQuery == '') {
      prefs.setString(
          'namaParlimenQuery', prefs.getString('namaParlimen') ?? '');
      namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
    }
    if (kodDunQuery == '') {
      prefs.setString('kodDunQuery', prefs.getString('kodDun') ?? '');
      kodDunQuery = prefs.getString('kodDunQuery') ?? '';
    }
    if (namaDunQuery == '') {
      prefs.setString('namaDunQuery', prefs.getString('namaDun') ?? '');
      namaDunQuery = prefs.getString('namaDunQuery') ?? '';
    }
    if (kodDmQuery == '') {
      prefs.setString('kodDmQuery', prefs.getString('kodDm') ?? '');
      kodDmQuery = prefs.getString('kodDmQuery') ?? '';
    }
    if (namaDmQuery == '') {
      prefs.setString('namaDmQuery', prefs.getString('namaDm') ?? '');
      namaDmQuery = prefs.getString('namaDmQuery') ?? '';
    }
    if (kodLokQuery == '') {
      prefs.setString('kodLokQuery', prefs.getString('kodLok') ?? '');
      kodLokQuery = prefs.getString('kodLokQuery') ?? '';
    }
    if (namaLokQuery == '') {
      prefs.setString('namaLokQuery', prefs.getString('namaLok') ?? '');
      namaLokQuery = prefs.getString('namaLokQuery') ?? '';
    }
    //---------------------------------------------------peringkatQuery
    //---------------------------------------------------paparanQuery
    // ------
    paparanSubPusatQuery = prefs.getString('paparanSubPusatQuery') ?? '';
    if (paparanSubPusatQuery == '') {
      prefs.setString('paparanSubPusatQuery', 'Pusat Negeri');
      paparanSubPusatQuery = 'Pusat Negeri';
    }

    paparanSubNQuery = prefs.getString('paparanSubNQuery') ?? '';
    if (paparanSubNQuery == '') {
      prefs.setString('paparanSubNQuery', 'Negeri Parlimen');
      paparanSubNQuery = 'Negeri Parlimen';
    }
    paparanSubPQuery = prefs.getString('paparanSubPQuery') ?? '';
    if (paparanSubPQuery == '') {
      prefs.setString('paparanSubPQuery', 'Parlimen DUN');
      paparanSubPQuery = 'Parlimen DUN';
    }
    paparanSubDmQuery = prefs.getString('paparanSubDmQuery') ?? '';
    if (paparanSubDmQuery == '') {
      prefs.setString('paparanSubDmQuery', 'DM Lok');
      paparanSubDmQuery = 'DM Lok';
    }
    // ------

    if ((kodLokQuery != '')) {
      prefs.setString('paparanQuery', 'Paparan Lok');
    }
    if ((kodDmQuery != '' && kodLokQuery == '')) {
      prefs.setString('paparanQuery', 'Paparan Dm');
    }
    if ((kodDunQuery != '' && kodDmQuery == '')) {
      prefs.setString('paparanQuery', 'Paparan Dun');
    }

    if ((kodParlimenQuery != '' && kodDunQuery == '')) {
      prefs.setString('paparanQuery', 'Paparan Parlimen/Bhgn');
    }
    if ((kodNegeriQuery != '' && kodParlimenQuery == '')) {
      prefs.setString('paparanQuery', 'Paparan Negeri');
    }
    if ((kodNegeriQuery == '' && kodParlimenQuery == '')) {
      prefs.setString('paparanQuery', 'Paparan Pusat');
    }

    paparanQuery = prefs.getString('paparanQuery') ?? '';
    print('-------');
    //--------------
    if (paparanQuery == 'Paparan Pusat') {
      if (paparanSubPusatQuery == 'Pusat Negeri') {
        paparanSenaraiQuery = 'Senarai Negeri';
      } else {
        paparanSenaraiQuery = 'Senarai Parlimen';
      }      
    }
    if (paparanQuery == 'Paparan Negeri') {
      if (paparanSubNQuery == 'Negeri Parlimen') {
        paparanSenaraiQuery = 'Senarai Parlimen';
      } else {
        paparanSenaraiQuery = 'Senarai DUN';
      }
    }
    if (paparanQuery == 'Paparan Parlimen/Bhgn') {
      if (paparanSubPQuery == 'Parlimen DUN') {
        paparanSenaraiQuery = 'Senarai DUN';
      } else {
        paparanSenaraiQuery = 'Senarai DM';
      }
    }
    if (paparanQuery == 'Paparan Dun') {
      paparanSenaraiQuery = 'Senarai DM';
    }
    if (paparanQuery == 'Paparan Dm') {
      if (paparanSubDmQuery == 'DM Lok') {
        paparanSenaraiQuery = 'Senarai Lok';
      } else {
        paparanSenaraiQuery = 'Senarai Caw';
      }
    }
    //--------------
    //---------------------------------------------------paparanQuery
    paparanQuery = prefs.getString('paparanQuery') ?? '';
    print('paparanQuery: $paparanQuery');

    emit(SyncKawasanSuccess(
        this.kodNegeri,
        this.namaNegeri,
        this.kodParlimen,
        this.namaParlimen,
        this.kodDun,
        this.namaDun,
        this.kodDm,
        this.namaDm,
        this.kodLok,
        this.namaLok,
        this.kodNegeriQuery,
        this.namaNegeriQuery,
        this.kodParlimenQuery,
        this.namaParlimenQuery,
        this.kodDunQuery,
        this.namaDunQuery,
        this.kodDmQuery,
        this.namaDmQuery,
        this.kodLokQuery,
        this.namaLokQuery,
        this.paparanQuery,
        this.paparanSenaraiQuery,
        this.paparanSubPusatQuery,
        this.paparanSubNQuery,
        this.paparanSubPQuery,this.paparanSubDmQuery));
        
  }

  //---------------------------------------_syncKawasan
}
