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
  final int JumNegeri;
  final int JumParlimen;
  final int JumDUN;
  final int JumDM;
  final int JumLokaliti;
  final int JumPemilih;
  //----
  final int? JumPemilihAwal;
  final int? JumPemilihAwalHadir;
  final int? JumPemilihHadir;
  final int? JumPemilihTHadir;
  final int? JumPemilihLelaki;
  final int? JumPemilihPerempuan;
  final int? JumPemilihLelaki_Hadir;
  final int? JumPemilihPerempuan_Hadir;
  final int? JumPemilihLelaki_THadir;
  final int? JumPemilihPerempuan_THadir;
  final int? JumPemilihLelaki_P;
  final int? JumPemilihPerempuan_P;
  final int? JumPemilihLelaki_P_Hadir;
  final int? JumPemilihPerempuan_P_Hadir;
  final int? JumPemilihLelaki_P_THadir;
  final int? JumPemilihPerempuan_P_THadir;
  final int? JumPemilihM;
  final int? JumPemilihC;
  final int? JumPemilihI;
  final int? JumPemilihL;
  final int? JumPemilihM_Hadir;
  final int? JumPemilihC_Hadir;
  final int? JumPemilihI_Hadir;
  final int? JumPemilihL_Hadir;
  final int? JumPemilihM_THadir;
  final int? JumPemilihC_THadir;
  final int? JumPemilihI_THadir;
  final int? JumPemilihL_THadir;
  final int? JumPemilihM_P;
  final int? JumPemilihC_P;
  final int? JumPemilihI_P;
  final int? JumPemilihL_P;
  final int? JumPemilihM_P_Hadir;
  final int? JumPemilihC_P_Hadir;
  final int? JumPemilihI_P_Hadir;
  final int? JumPemilihL_P_Hadir;
  final int? JumPemilihM_P_THadir;
  final int? JumPemilihC_P_THadir;
  final int? JumPemilihI_P_THadir;
  final int? JumPemilihL_P_THadir;
  final int? JumPemilihU0;
  final int? JumPemilihU1;
  final int? JumPemilihU2;
  final int? JumPemilihU3;
  final int? JumPemilihU4;
  final int? JumPemilihU5;
  final int? JumPemilihU6;
  final int? JumPemilihU7;
  final int? JumPemilihU0_Hadir;
  final int? JumPemilihU1_Hadir;
  final int? JumPemilihU2_Hadir;
  final int? JumPemilihU3_Hadir;
  final int? JumPemilihU4_Hadir;
  final int? JumPemilihU5_Hadir;
  final int? JumPemilihU6_Hadir;
  final int? JumPemilihU7_Hadir;
  final int? JumPemilihU0_THadir;
  final int? JumPemilihU1_THadir;
  final int? JumPemilihU2_THadir;
  final int? JumPemilihU3_THadir;
  final int? JumPemilihU4_THadir;
  final int? JumPemilihU5_THadir;
  final int? JumPemilihU6_THadir;
  final int? JumPemilihU7_THadir;
  final int? JumPemilihU0_P;
  final int? JumPemilihU1_P;
  final int? JumPemilihU2_P;
  final int? JumPemilihU3_P;
  final int? JumPemilihU4_P;
  final int? JumPemilihU5_P;
  final int? JumPemilihU6_P;
  final int? JumPemilihU7_P;
  final int? JumPemilihU0_P_Hadir;
  final int? JumPemilihU1_P_Hadir;
  final int? JumPemilihU2_P_Hadir;
  final int? JumPemilihU3_P_Hadir;
  final int? JumPemilihU4_P_Hadir;
  final int? JumPemilihU5_P_Hadir;
  final int? JumPemilihU6_P_Hadir;
  final int? JumPemilihU7_P_Hadir;
  final int? JumPemilihU0_P_THadir;
  final int? JumPemilihU1_P_THadir;
  final int? JumPemilihU2_P_THadir;
  final int? JumPemilihU3_P_THadir;
  final int? JumPemilihU4_P_THadir;
  final int? JumPemilihU5_P_THadir;
  final int? JumPemilihU6_P_THadir;
  final int? JumPemilihU7_P_THadir;
  final int? JumPemilih_P;
  final int? JumPemilih_K;
  final int? JumPemilih_H;
  final int? JumPemilih_T;
  final int? JumPemilih_M;
  final int? JumPemilih_BB;
  final int? JumPemilih_P_Hadir;
  final int? JumPemilih_K_Hadir;
  final int? JumPemilih_H_Hadir;
  final int? JumPemilih_T_Hadir;
  final int? JumPemilih_M_Hadir;
  final int? JumPemilih_BB_Hadir;
  final int? JumPemilih_P_THadir;
  final int? JumPemilih_K_THadir;
  final int? JumPemilih_H_THadir;
  final int? JumPemilih_T_THadir;
  final int? JumPemilih_M_THadir;
  final int? JumPemilih_BB_THadir;

  GetDbKawasanSuccess({
    required this.listDbKawasan,
    //----
    required this.JumNegeri,
    required this.JumParlimen,
    required this.JumDUN,
    required this.JumDM,
    required this.JumLokaliti,
    required this.JumPemilih,
    //----
    this.	JumPemilihAwal,
    this.	JumPemilihAwalHadir,
    this.	JumPemilihHadir,
    this.	JumPemilihTHadir,
    this.	JumPemilihLelaki,
    this.	JumPemilihPerempuan,
    this.	JumPemilihLelaki_Hadir,
    this.	JumPemilihPerempuan_Hadir,
    this.	JumPemilihLelaki_THadir,
    this.	JumPemilihPerempuan_THadir,
    this.	JumPemilihLelaki_P,
    this.	JumPemilihPerempuan_P,
    this.	JumPemilihLelaki_P_Hadir,
    this.	JumPemilihPerempuan_P_Hadir,
    this.	JumPemilihLelaki_P_THadir,
    this.	JumPemilihPerempuan_P_THadir,
    this.	JumPemilihM,
    this.	JumPemilihC,
    this.	JumPemilihI,
    this.	JumPemilihL,
    this.	JumPemilihM_Hadir,
    this.	JumPemilihC_Hadir,
    this.	JumPemilihI_Hadir,
    this.	JumPemilihL_Hadir,
    this.	JumPemilihM_THadir,
    this.	JumPemilihC_THadir,
    this.	JumPemilihI_THadir,
    this.	JumPemilihL_THadir,
    this.	JumPemilihM_P,
    this.	JumPemilihC_P,
    this.	JumPemilihI_P,
    this.	JumPemilihL_P,
    this.	JumPemilihM_P_Hadir,
    this.	JumPemilihC_P_Hadir,
    this.	JumPemilihI_P_Hadir,
    this.	JumPemilihL_P_Hadir,
    this.	JumPemilihM_P_THadir,
    this.	JumPemilihC_P_THadir,
    this.	JumPemilihI_P_THadir,
    this.	JumPemilihL_P_THadir,
    this.	JumPemilihU0,
    this.	JumPemilihU1,
    this.	JumPemilihU2,
    this.	JumPemilihU3,
    this.	JumPemilihU4,
    this.	JumPemilihU5,
    this.	JumPemilihU6,
    this.	JumPemilihU7,
    this.	JumPemilihU0_Hadir,
    this.	JumPemilihU1_Hadir,
    this.	JumPemilihU2_Hadir,
    this.	JumPemilihU3_Hadir,
    this.	JumPemilihU4_Hadir,
    this.	JumPemilihU5_Hadir,
    this.	JumPemilihU6_Hadir,
    this.	JumPemilihU7_Hadir,
    this.	JumPemilihU0_THadir,
    this.	JumPemilihU1_THadir,
    this.	JumPemilihU2_THadir,
    this.	JumPemilihU3_THadir,
    this.	JumPemilihU4_THadir,
    this.	JumPemilihU5_THadir,
    this.	JumPemilihU6_THadir,
    this.	JumPemilihU7_THadir,
    this.	JumPemilihU0_P,
    this.	JumPemilihU1_P,
    this.	JumPemilihU2_P,
    this.	JumPemilihU3_P,
    this.	JumPemilihU4_P,
    this.	JumPemilihU5_P,
    this.	JumPemilihU6_P,
    this.	JumPemilihU7_P,
    this.	JumPemilihU0_P_Hadir,
    this.	JumPemilihU1_P_Hadir,
    this.	JumPemilihU2_P_Hadir,
    this.	JumPemilihU3_P_Hadir,
    this.	JumPemilihU4_P_Hadir,
    this.	JumPemilihU5_P_Hadir,
    this.	JumPemilihU6_P_Hadir,
    this.	JumPemilihU7_P_Hadir,
    this.	JumPemilihU0_P_THadir,
    this.	JumPemilihU1_P_THadir,
    this.	JumPemilihU2_P_THadir,
    this.	JumPemilihU3_P_THadir,
    this.	JumPemilihU4_P_THadir,
    this.	JumPemilihU5_P_THadir,
    this.	JumPemilihU6_P_THadir,
    this.	JumPemilihU7_P_THadir,
    this.	JumPemilih_P,
    this.	JumPemilih_K,
    this.	JumPemilih_H,
    this.	JumPemilih_T,
    this.	JumPemilih_M,
    this.	JumPemilih_BB,
    this.	JumPemilih_P_Hadir,
    this.	JumPemilih_K_Hadir,
    this.	JumPemilih_H_Hadir,
    this.	JumPemilih_T_Hadir,
    this.	JumPemilih_M_Hadir,
    this.	JumPemilih_BB_Hadir,
    this.	JumPemilih_P_THadir,
    this.	JumPemilih_K_THadir,
    this.	JumPemilih_H_THadir,
    this.	JumPemilih_T_THadir,
    this.	JumPemilih_M_THadir,
    this.	JumPemilih_BB_THadir,
  });
}
//---------------