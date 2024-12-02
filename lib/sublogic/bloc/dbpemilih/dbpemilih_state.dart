import 'package:meta/meta.dart';

@immutable
abstract class DbPemilihState {}

class InitialDbPemilihState extends DbPemilihState {}

class GetDbPemilihWaiting extends DbPemilihState {}

class GetDbPemilihFavWaiting extends DbPemilihState {}

class UpdateDbPemilihWaiting extends DbPemilihState {}

class GetDbPemilihError extends DbPemilihState {
  final String errorMessage;
  GetDbPemilihError({
    required this.errorMessage,
  });
}

//-----------Fav
class AddDbPemilihFavSuccess extends DbPemilihState {
  //----
  AddDbPemilihFavSuccess();
}

class RemoveDbPemilihFavSuccess extends DbPemilihState {
  //----
  RemoveDbPemilihFavSuccess();
}

class GetDbPemilihFavSuccess extends DbPemilihState {
  final String listDbPemilih;
  //----
  //----
  GetDbPemilihFavSuccess({
    required this.listDbPemilih,
    //----
    //----
  });
}

//-----------Fav
//-----------WstL
class AddDbPemilihWstLSuccess extends DbPemilihState {
  //----
  AddDbPemilihWstLSuccess();
}

class RemoveDbPemilihWstLSuccess extends DbPemilihState {
  //----
  RemoveDbPemilihWstLSuccess();
}
//-----------WstL

class UpdateDbPemilihSuccess extends DbPemilihState {
  //----
  UpdateDbPemilihSuccess();
}

class GetDbPemilihSuccessDone extends DbPemilihState {
  //----
  GetDbPemilihSuccessDone();
}

//---------------

class GetDbPemilihSuccess extends DbPemilihState {
  final String listDbPemilih;
  //----
  final int? JumPemilih;
  final int? JumPemilihL;
  final int? JumPemilihLM;
  final int? JumPemilihLM_40Bawah;
  final int? JumPemilihLM_40Bawah_P;
  final int? JumPemilihLM_40Bawah_K;
  final int? JumPemilihLM_40Bawah_H;
  final int? JumPemilihLM_40Bawah_T;
  final int? JumPemilihLM_40Bawah_M;
  final int? JumPemilihLM_40Bawah_Banci;
  final int? JumPemilihLM_40Bawah_BBanci;
  final int? JumPemilihLM_40Bawah_Parti_Banci;
  final int? JumPemilihLM_40Bawah_Parti_BBanci;

  final int? JumPemilihP;
  final int? JumPemilihPM;
  final int? JumPemilihPM_40Bawah;
  final int? JumPemilihPM_40Bawah_P;
  final int? JumPemilihPM_40Bawah_K;
  final int? JumPemilihPM_40Bawah_H;
  final int? JumPemilihPM_40Bawah_T;
  final int? JumPemilihPM_40Bawah_M;
  final int? JumPemilihPM_40Bawah_Banci;
  final int? JumPemilihPM_40Bawah_BBanci;
  final int? JumPemilihPM_40Bawah_Parti_Banci;
  final int? JumPemilihPM_40Bawah_Parti_BBanci;

  //----
  GetDbPemilihSuccess({
    required this.listDbPemilih,
    //----
    this.JumPemilih,
    this.JumPemilihL,
    this.JumPemilihLM,
    this.JumPemilihLM_40Bawah,
    this.JumPemilihLM_40Bawah_P,
    this.JumPemilihLM_40Bawah_K,
    this.JumPemilihLM_40Bawah_H,
    this.JumPemilihLM_40Bawah_T,
    this.JumPemilihLM_40Bawah_M,
    this.JumPemilihLM_40Bawah_Banci,
    this.JumPemilihLM_40Bawah_BBanci,
    this.JumPemilihLM_40Bawah_Parti_Banci,
    this.JumPemilihLM_40Bawah_Parti_BBanci,
    this.JumPemilihP,
    this.JumPemilihPM,
    this.JumPemilihPM_40Bawah,
    this.JumPemilihPM_40Bawah_P,
    this.JumPemilihPM_40Bawah_K,
    this.JumPemilihPM_40Bawah_H,
    this.JumPemilihPM_40Bawah_T,
    this.JumPemilihPM_40Bawah_M,
    this.JumPemilihPM_40Bawah_Banci,
    this.JumPemilihPM_40Bawah_BBanci,
    this.JumPemilihPM_40Bawah_Parti_Banci,
    this.JumPemilihPM_40Bawah_Parti_BBanci,
    //----
  });
}

class GetDbPemilihByICSuccess extends DbPemilihState {
  final String? semakICStatus;
  final String? semakICFavStatus;
  final String? semakICWstLStatus;
  final String? Nama;
  final String? IC;
  final String? Jantina;
  final String? KodNegeri;
  final String? KodDM;
  final String? KodParlimen;
  final String? NamaParlimen;
  final String? NamaDUN;
  final String? NamaDM;
  final String? NamaLokaliti;
  final String? NoSaluran;
  final String? tm;
  final String? ALAMAT1_JPN;
  final String? ALAMAT2_JPN;
  final String? ALAMAT3_JPN;
  final String? POSKOD_JPN;
  final String? BANDAR_JPN;

  final String? Sikap;
  final String? Status;
  final String? SikapM;

  final String? NO_TEL_JPN;
  final String? Catatan;
  final String? HandbilDigitalTxt;

  final String? DataPetugasJR;
  final String? DataUserAccess;
  final String? User_Kod_Kawasan;
  final String? User_Kod_Keselamatan;
  final String? User_Kod_Laluan;
  final int? User_Kod_Laluan_Flag;
  // if (user_Kod_Laluan_Flag == '1') {
  //   user_Kod_Laluan_Flag = 'Perlu Kemaskini Kod Laluan Baru';
  // } else {
  //   user_Kod_Laluan_Flag = '-';
  // }
  final String? PetugasJR_Negeri;
  final String? PetugasJR_NamaParlimen;
  final String? PetugasJR_NamaDun;
  final String? PetugasJR_NamaDM;
  final int? PetugasJR_Jagaan;

  //----
  GetDbPemilihByICSuccess({
    //----
    this.semakICStatus,
    this.semakICFavStatus,
    this.semakICWstLStatus,
    this.Nama,
    this.IC,
    this.Jantina,
    this.KodNegeri,
    this.KodDM,
    this.KodParlimen,
    this.NamaParlimen,
    this.NamaDUN,
    this.NamaDM,
    this.NamaLokaliti,
    this.NoSaluran,
    this.tm,
    this.ALAMAT1_JPN,
    this.ALAMAT2_JPN,
    this.ALAMAT3_JPN,
    this.POSKOD_JPN,
    this.BANDAR_JPN,
    this.Sikap,
    this.Status,
    this.SikapM,
    this.NO_TEL_JPN,
    this.Catatan,
    this.HandbilDigitalTxt,

    this.DataPetugasJR,
    this.DataUserAccess,
    this.User_Kod_Kawasan,
    this.User_Kod_Keselamatan,
    this.User_Kod_Laluan,
    this.User_Kod_Laluan_Flag,
    this.PetugasJR_Negeri,
    this.PetugasJR_NamaParlimen,
    this.PetugasJR_NamaDun,
    this.PetugasJR_NamaDM,
    this.PetugasJR_Jagaan,
    //----
  });
}

//---------------


