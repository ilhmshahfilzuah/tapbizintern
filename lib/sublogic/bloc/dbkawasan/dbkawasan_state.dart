import 'package:meta/meta.dart';

@immutable
abstract class DbKawasanState {}

class InitialDbKawasanState extends DbKawasanState {}

class GetDbKawasanWaiting extends DbKawasanState {}

//---------------
class GetDbKawasanError extends DbKawasanState {
  final String errorMessage;
  GetDbKawasanError({
    required this.errorMessage,
  });
}
//---------------

//---------------
class GetDbKawasanSuccess extends DbKawasanState {
  final String listDbKawasan;
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
  GetDbKawasanSuccess({required this.listDbKawasan,
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
//---------------
//---------------
class GetDbKawasanQuerySuccess extends DbKawasanState {
  final String listDbKawasan;
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
  GetDbKawasanQuerySuccess({required this.listDbKawasan,
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
//---------------
