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
  final int? JumJR;
  final int? JumJRAktif;
  final int? JumJRXAktif;
  final int? KaumM;
  final int? JumPemilihM;
  final int? KaumMPu;
  final int? KaumMK;
  final int? KaumMH;
  final int? KaumMT;
  final int? KaumMM;
  final int? KaumMBanci;
  final int? KaumMBBanci;
  
  
  final int? XMatchingM;
  final int? MatchingM;
  final int? XMatchingMP;
  final int? MatchingMP;
  final int? MatchingMK;
  final int? MatchingMH;
  final int? MatchingMT;
  final int? MatchingMM;
  final int? MatchingMBanci;
  final int? MatchingMBBanci;
  final int? P;
  final int? K;
  final int? H;
  final int? T;
  final int? M;
  final int? Banci;
  final int? BBanci;
  final int? GOTVBB;
  final int? GOTVP;
  final int? GOTVK;
  final int? GOTVH;
  final int? GOTVT;
  final int? GOTVM;
  final int? XJR;
  final int? XJR_BB;
  final int? XJR_P;
  final int? XJR_K;
  final int? XJR_H;
  final int? XJR_T;
  final int? XJR_M;

  final int? XJR_BB_GOTVBB;
  final int? XJR_BB_GOTVP;
  final int? XJR_BB_GOTVK;
  final int? XJR_BB_GOTVH;
  final int? XJR_BB_GOTVT;
  final int? XJR_BB_GOTVM;
  final int? XJR_P_GOTVBB;
  final int? XJR_P_GOTVP;
  final int? XJR_P_GOTVK;
  final int? XJR_P_GOTVH;
  final int? XJR_P_GOTVT;
  final int? XJR_P_GOTVM;
  final int? XJR_K_GOTVBB;
  final int? XJR_K_GOTVP;
  final int? XJR_K_GOTVK;
  final int? XJR_K_GOTVH;
  final int? XJR_K_GOTVT;
  final int? XJR_K_GOTVM;
  final int? XJR_H_GOTVBB;
  final int? XJR_H_GOTVP;
  final int? XJR_H_GOTVK;
  final int? XJR_H_GOTVH;
  final int? XJR_H_GOTVT;
  final int? XJR_H_GOTVM;
  final int? XJR_T_GOTVBB;
  final int? XJR_T_GOTVP;
  final int? XJR_T_GOTVK;
  final int? XJR_T_GOTVH;
  final int? XJR_T_GOTVT;
  final int? XJR_T_GOTVM;
  final int? XJR_M_GOTVBB;
  final int? XJR_M_GOTVP;
  final int? XJR_M_GOTVK;
  final int? XJR_M_GOTVH;
  final int? XJR_M_GOTVT;
  final int? XJR_M_GOTVM;
  final int? U18_40;
  final int? U18_40_XJR;
  final int? U18_40_XJR_BB;
  final int? U18_40_XJR_P;
  final int? U18_40_XJR_K;
  final int? U18_40_XJR_H;
  final int? U18_40_XJR_T;
  final int? U18_40_XJR_M;

  final int? U18_40_BB;
  final int? U18_40_P;
  final int? U18_40_K;
  final int? U18_40_H;
  final int? U18_40_T;
  final int? U18_40_M;
  final int? Hadir2;
  final int? U18_40_Hadir2;

  final int? UmurU0LM;
  final int? UmurU0PM;
  final int? UmurU1LM;
  final int? UmurU1PM;
  final int? UmurU2LM;
  final int? UmurU2PM;


  final int? XJRM;
  final int? XJRM_GOTVP;
  final int? XJRM_GOTVK;
  final int? XJRM_GOTVH;
  final int? XJRM_GOTVT;
  final int? XJRM_GOTVM;
  final int? XJRM_GOTVBB;

  final int? JRM;
  final int? JRM_GOTVP;
  final int? JRM_GOTVK;
  final int? JRM_GOTVH;
  final int? JRM_GOTVT;
  final int? JRM_GOTVM;
  final int? JRM_GOTVBB;

  final int? JRM_PKHM;
  final int? JRM_PKHM_GOTVP;
  final int? JRM_PKHM_GOTVK;
  final int? JRM_PKHM_GOTVH;
  final int? JRM_PKHM_GOTVT;
  final int? JRM_PKHM_GOTVM;
  final int? JRM_PKHM_GOTVBB;

  final int? JRM_T;
  final int? JRM_T_GOTVP;
  final int? JRM_T_GOTVK;
  final int? JRM_T_GOTVH;
  final int? JRM_T_GOTVT;
  final int? JRM_T_GOTVM;
  final int? JRM_T_GOTVBB;

  final int? JRM_BB;
  final int? JRM_BB_GOTVP;
  final int? JRM_BB_GOTVK;
  final int? JRM_BB_GOTVH;
  final int? JRM_BB_GOTVT;
  final int? JRM_BB_GOTVM;
  final int? JRM_BB_GOTVBB;

  final int? MUDA_XJRM;
  final int? MUDA_XJRM_GOTVP;
  final int? MUDA_XJRM_GOTVK;
  final int? MUDA_XJRM_GOTVH;
  final int? MUDA_XJRM_GOTVT;
  final int? MUDA_XJRM_GOTVM;
  final int? MUDA_XJRM_GOTVBB;

  final int? MUDA_JRM_T;
  final int? MUDA_JRM_T_GOTVP;
  final int? MUDA_JRM_T_GOTVK;
  final int? MUDA_JRM_T_GOTVH;
  final int? MUDA_JRM_T_GOTVT;
  final int? MUDA_JRM_T_GOTVM;
  final int? MUDA_JRM_T_GOTVBB;

  final int? MUDA_JRM_BB;
  final int? MUDA_JRM_BB_GOTVP;
  final int? MUDA_JRM_BB_GOTVK;
  final int? MUDA_JRM_BB_GOTVH;
  final int? MUDA_JRM_BB_GOTVT;
  final int? MUDA_JRM_BB_GOTVM;
  final int? MUDA_JRM_BB_GOTVBB;

  final int? SARGOTV_Keseluruhan_m;
  final int? SARGOTV_JJR_m;
  final int? SARGOTV_JGOTV_m;
  final int? SARGOTV_JGOTV_m_GOTVP;
  final int? SARGOTV_JGOTV_m_GOTVBB;

  final int? MUDA_Keseluruhan_m;
  final int? MUDA_JJR_m;
  final int? MUDA_JBM_m;
  final int? MUDA_JBM_m_GOTVP;
  final int? MUDA_JBM_m_GOTVBB;
  final int? KaumM_L_1;
  final int? KaumM_L_1_P;
  final int? KaumM_L_1_K;
  final int? KaumM_L_1_H;
  final int? KaumM_L_1_T;
  final int? KaumM_L_1_M;
  final int? KaumM_L_1_Banci;
  final int? KaumM_L_1_BBanci;

  final int? KaumM_P_2;
  final int? KaumM_P_2_P;
  final int? KaumM_P_2_K;
  final int? KaumM_P_2_H;
  final int? KaumM_P_2_T;
  final int? KaumM_P_2_M;
  final int? KaumM_P_2_Banci;
  final int? KaumM_P_2_BBanci;

  final int? KaumM_L_3;
  final int? KaumM_L_3_P;
  final int? KaumM_L_3_K;
  final int? KaumM_L_3_H;
  final int? KaumM_L_3_T;
  final int? KaumM_L_3_M;
  final int? KaumM_L_3_Banci;
  final int? KaumM_L_3_BBanci;

  final int? KaumM_P_4;
  final int? KaumM_P_4_P;
  final int? KaumM_P_4_K;
  final int? KaumM_P_4_H;
  final int? KaumM_P_4_T;
  final int? KaumM_P_4_M;
  final int? KaumM_P_4_Banci;
  final int? KaumM_P_4_BBanci;
  //----
  GetDbKawasanSuccess({
    required this.listDbKawasan,
    //----
    required this.JumNegeri,
    required this.JumParlimen,
    required this.JumDUN,
    required this.JumDM,
    required this.JumLokaliti,
    required this.JumPemilih,
    this.JumJR,
    this.JumJRAktif,
    this.JumJRXAktif,
    this.KaumM,
    this.JumPemilihM,
    this.KaumMPu,
    this.KaumMK,
    this.KaumMH,
    this.KaumMT,
    this.KaumMM,
    this.KaumMBanci,
    this.KaumMBBanci,
    this.XMatchingM,
    this.MatchingM,
    this.XMatchingMP,
    this.MatchingMP,
    this.MatchingMK,
    this.MatchingMH,
    this.MatchingMT,
    this.MatchingMM,
    this.MatchingMBanci,
    this.MatchingMBBanci,
    this.P,
    this.K,
    this.H,
    this.T,
    this.M,
    this.Banci,
    this.BBanci,
    this.GOTVBB,
    this.GOTVP,
    this.GOTVK,
    this.GOTVH,
    this.GOTVT,
    this.GOTVM,
    this.XJR,
    this.XJR_BB,
    this.XJR_P,
    this.XJR_K,
    this.XJR_H,
    this.XJR_T,
    this.XJR_M,

    this.XJR_BB_GOTVBB,
    this.XJR_BB_GOTVP,
    this.XJR_BB_GOTVK,
    this.XJR_BB_GOTVH,
    this.XJR_BB_GOTVT,
    this.XJR_BB_GOTVM,
    this.XJR_P_GOTVBB,
    this.XJR_P_GOTVP,
    this.XJR_P_GOTVK,
    this.XJR_P_GOTVH,
    this.XJR_P_GOTVT,
    this.XJR_P_GOTVM,
    this.XJR_K_GOTVBB,
    this.XJR_K_GOTVP,
    this.XJR_K_GOTVK,
    this.XJR_K_GOTVH,
    this.XJR_K_GOTVT,
    this.XJR_K_GOTVM,
    this.XJR_H_GOTVBB,
    this.XJR_H_GOTVP,
    this.XJR_H_GOTVK,
    this.XJR_H_GOTVH,
    this.XJR_H_GOTVT,
    this.XJR_H_GOTVM,
    this.XJR_T_GOTVBB,
    this.XJR_T_GOTVP,
    this.XJR_T_GOTVK,
    this.XJR_T_GOTVH,
    this.XJR_T_GOTVT,
    this.XJR_T_GOTVM,
    this.XJR_M_GOTVBB,
    this.XJR_M_GOTVP,
    this.XJR_M_GOTVK,
    this.XJR_M_GOTVH,
    this.XJR_M_GOTVT,
    this.XJR_M_GOTVM,
    this.U18_40,
    this.U18_40_XJR,
    this.U18_40_XJR_BB,
    this.U18_40_XJR_P,
    this.U18_40_XJR_K,
    this.U18_40_XJR_H,
    this.U18_40_XJR_T,
    this.U18_40_XJR_M,

    this.U18_40_BB,
    this.U18_40_P,
    this.U18_40_K,
    this.U18_40_H,
    this.U18_40_T,
    this.U18_40_M,
    this.Hadir2,
    this.U18_40_Hadir2,

    this.UmurU0LM,
    this.UmurU0PM,
    this.UmurU1LM,
    this.UmurU1PM,
    this.UmurU2LM,
    this.UmurU2PM,


    this.XJRM,
    this.XJRM_GOTVP,
    this.XJRM_GOTVK,
    this.XJRM_GOTVH,
    this.XJRM_GOTVT,
    this.XJRM_GOTVM,
    this.XJRM_GOTVBB,

    this.JRM,
    this.JRM_GOTVP,
    this.JRM_GOTVK,
    this.JRM_GOTVH,
    this.JRM_GOTVT,
    this.JRM_GOTVM,
    this.JRM_GOTVBB,

    this.JRM_PKHM,
    this.JRM_PKHM_GOTVP,
    this.JRM_PKHM_GOTVK,
    this.JRM_PKHM_GOTVH,
    this.JRM_PKHM_GOTVT,
    this.JRM_PKHM_GOTVM,
    this.JRM_PKHM_GOTVBB,

    this.JRM_T,
    this.JRM_T_GOTVP,
    this.JRM_T_GOTVK,
    this.JRM_T_GOTVH,
    this.JRM_T_GOTVT,
    this.JRM_T_GOTVM,
    this.JRM_T_GOTVBB,

    this.JRM_BB,
    this.JRM_BB_GOTVP,
    this.JRM_BB_GOTVK,
    this.JRM_BB_GOTVH,
    this.JRM_BB_GOTVT,
    this.JRM_BB_GOTVM,
    this.JRM_BB_GOTVBB,

    this.MUDA_XJRM,
    this.MUDA_XJRM_GOTVP,
    this.MUDA_XJRM_GOTVK,
    this.MUDA_XJRM_GOTVH,
    this.MUDA_XJRM_GOTVT,
    this.MUDA_XJRM_GOTVM,
    this.MUDA_XJRM_GOTVBB,

    this.MUDA_JRM_T,
    this.MUDA_JRM_T_GOTVP,
    this.MUDA_JRM_T_GOTVK,
    this.MUDA_JRM_T_GOTVH,
    this.MUDA_JRM_T_GOTVT,
    this.MUDA_JRM_T_GOTVM,
    this.MUDA_JRM_T_GOTVBB,

    this.MUDA_JRM_BB,
    this.MUDA_JRM_BB_GOTVP,
    this.MUDA_JRM_BB_GOTVK,
    this.MUDA_JRM_BB_GOTVH,
    this.MUDA_JRM_BB_GOTVT,
    this.MUDA_JRM_BB_GOTVM,
    this.MUDA_JRM_BB_GOTVBB,

    this.SARGOTV_Keseluruhan_m,
    this.SARGOTV_JJR_m,
    this.SARGOTV_JGOTV_m,
    this.SARGOTV_JGOTV_m_GOTVP,
    this.SARGOTV_JGOTV_m_GOTVBB,

    this.MUDA_Keseluruhan_m,
    this.MUDA_JJR_m,
    this.MUDA_JBM_m,
    this.MUDA_JBM_m_GOTVP,
    this.MUDA_JBM_m_GOTVBB,
    this.KaumM_L_1,
    this.KaumM_L_1_P,
    this.KaumM_L_1_K,
    this.KaumM_L_1_H,
    this.KaumM_L_1_T,
    this.KaumM_L_1_M,
    this.KaumM_L_1_Banci,
    this.KaumM_L_1_BBanci,

    this.KaumM_P_2,
    this.KaumM_P_2_P,
    this.KaumM_P_2_K,
    this.KaumM_P_2_H,
    this.KaumM_P_2_T,
    this.KaumM_P_2_M,
    this.KaumM_P_2_Banci,
    this.KaumM_P_2_BBanci,

    this.KaumM_L_3,
    this.KaumM_L_3_P,
    this.KaumM_L_3_K,
    this.KaumM_L_3_H,
    this.KaumM_L_3_T,
    this.KaumM_L_3_M,
    this.KaumM_L_3_Banci,
    this.KaumM_L_3_BBanci,

    this.KaumM_P_4,
    this.KaumM_P_4_P,
    this.KaumM_P_4_K,
    this.KaumM_P_4_H,
    this.KaumM_P_4_T,
    this.KaumM_P_4_M,
    this.KaumM_P_4_Banci,
    this.KaumM_P_4_BBanci,
    
    //----
  });
}
//---------------