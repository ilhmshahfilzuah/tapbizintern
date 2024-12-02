import 'package:meta/meta.dart';

@immutable
abstract class DbDataProfilState {}

class InitialDbDataProfilState extends DbDataProfilState {}

class GetDbDataProfilWaiting extends DbDataProfilState {}

//---------------
class GetDbDataProfilError extends DbDataProfilState {
  final String errorMessage;
  GetDbDataProfilError({
    required this.errorMessage,
  });
}
//---------------

//---------------
// class GetDbDataProfilSuccess extends DbDataProfilState {
//   GetDbDataProfilSuccess();
// }
class GetDbDataProfilSuccess extends DbDataProfilState {
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

  final String? JRNegeri;
  final String? JRNamaParlimen;
  final String? JRNamaDun;
  final String? JRNamaDM;
  final String? JRnama;
  final String? JRno_tel1;
  //----
  GetDbDataProfilSuccess({
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

    this.JRNegeri,
    this.JRNamaParlimen,
    this.JRNamaDun,
    this.JRNamaDM,
    this.JRnama,
    this.JRno_tel1,
    //----
  });

  
}

class AddDbDataProfilSuccess extends DbDataProfilState {
  //----
  AddDbDataProfilSuccess();
}

class DelDbDataProfilSuccess extends DbDataProfilState {
  //----
  DelDbDataProfilSuccess();
}

class UpdateDbDataProfilSuccess extends DbDataProfilState {
  //----
  UpdateDbDataProfilSuccess();
}
