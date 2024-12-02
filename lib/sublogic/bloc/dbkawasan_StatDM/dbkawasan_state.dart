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

  int? St_Pemilih;
  int? St_Awal;
  int? St_Pos;
  int? St_Awam;
  int? St_JantinaL;
  int? St_JantinaP;
  int? St_KaumM;
  int? St_KaumC;
  int? St_KaumI;
  int? St_KaumL;
  int? St_UmurU0;
  int? St_UmurU1;
  int? St_UmurU2;
  int? St_UmurU3;
  int? St_UmurU4;
  int? St_UmurU5;
  int? St_UmurU6;
  int? St_UmurU7;
  int? St_UmurU0L;
  int? St_UmurU0LM;
  int? St_UmurU0LC;
  int? St_UmurU0LI;
  int? St_UmurU0LL;
  int? St_UmurU0P;
  int? St_UmurU0PM;
  int? St_UmurU0PC;
  int? St_UmurU0PI;
  int? St_UmurU0PL;
  int? St_UmurU1L;
  int? St_UmurU1LM;
  int? St_UmurU1LC;
  int? St_UmurU1LI;
  int? St_UmurU1LL;
  int? St_UmurU1P;
  int? St_UmurU1PM;
  int? St_UmurU1PC;
  int? St_UmurU1PI;
  int? St_UmurU1PL;
  int? St_UmurU2L;
  int? St_UmurU2LM;
  int? St_UmurU2LC;
  int? St_UmurU2LI;
  int? St_UmurU2LL;
  int? St_UmurU2P;
  int? St_UmurU2PM;
  int? St_UmurU2PC;
  int? St_UmurU2PI;
  int? St_UmurU2PL;
  int? St_UmurU3L;
  int? St_UmurU3LM;
  int? St_UmurU3LC;
  int? St_UmurU3LI;
  int? St_UmurU3LL;
  int? St_UmurU3P;
  int? St_UmurU3PM;
  int? St_UmurU3PC;
  int? St_UmurU3PI;
  int? St_UmurU3PL;
  int? St_UmurU4L;
  int? St_UmurU4LM;
  int? St_UmurU4LC;
  int? St_UmurU4LI;
  int? St_UmurU4LL;
  int? St_UmurU4P;
  int? St_UmurU4PM;
  int? St_UmurU4PC;
  int? St_UmurU4PI;
  int? St_UmurU4PL;
  int? St_UmurU5L;
  int? St_UmurU5LM;
  int? St_UmurU5LC;
  int? St_UmurU5LI;
  int? St_UmurU5LL;
  int? St_UmurU5P;
  int? St_UmurU5PM;
  int? St_UmurU5PC;
  int? St_UmurU5PI;
  int? St_UmurU5PL;
  int? St_UmurU6L;
  int? St_UmurU6LM;
  int? St_UmurU6LC;
  int? St_UmurU6LI;
  int? St_UmurU6LL;
  int? St_UmurU6P;
  int? St_UmurU6PM;
  int? St_UmurU6PC;
  int? St_UmurU6PI;
  int? St_UmurU6PL;
  int? St_UmurU7L;
  int? St_UmurU7LM;
  int? St_UmurU7LC;
  int? St_UmurU7LI;
  int? St_UmurU7LL;
  int? St_UmurU7P;
  int? St_UmurU7PM;
  int? St_UmurU7PC;
  int? St_UmurU7PI;
  int? St_UmurU7PL;
  int? St_AhliG;
  int? St_AhliW;
  int? St_AhliY;
  int? St_AhliP;
  int? Dy0a_JumJR;
  int? Dy0a_JumJRAktif_queDel;
  int? Dy0a_JumJRAktif_DMSPR_queDel;
  int? Dy0a_JumJRAktif_DMAkses_queDel;
  int? Dy0a_JumJRXAktif_queDel;
  int? Dy1_P;
  int? Dy1_K;
  int? Dy1_H;
  int? Dy1_T;
  int? Dy1_M;
  int? Dy1_BB;
  int? Dy1_Aktif;
  int? Dy1_LN;
  int? Dy1_LP;
  int? Dy1_LD;
  int? Dy1_LM;
  int? Dy1_PLuar;
  int? Dy1_AktifPu;
  int? Dy1_LNPu;
  int? Dy1_LPPu;
  int? Dy1_LDPu;
  int? Dy1_LMPu;
  int? Dy1_PLuarPu;
  int? Dy1_JantinaLPu;
  int? Dy1_JantinaLK;
  int? Dy1_JantinaLH;
  int? Dy1_JantinaLT;
  int? Dy1_JantinaLM;
  int? Dy1_JantinaLPLuar;
  int? Dy1_JantinaPPu;
  int? Dy1_JantinaPK;
  int? Dy1_JantinaPH;
  int? Dy1_JantinaPT;
  int? Dy1_JantinaPM;
  int? Dy1_JantinaPPLuar;
  int? Dy1_KaumMPu;
  int? Dy1_KaumMK;
  int? Dy1_KaumMH;
  int? Dy1_KaumMT;
  int? Dy1_KaumMM;
  int? Dy1_KaumMPLuar;
  int? Dy1_KaumCPu;
  int? Dy1_KaumCK;
  int? Dy1_KaumCH;
  int? Dy1_KaumCT;
  int? Dy1_KaumCM;
  int? Dy1_KaumCPLuar;
  int? Dy1_KaumIPu;
  int? Dy1_KaumIK;
  int? Dy1_KaumIH;
  int? Dy1_KaumIT;
  int? Dy1_KaumIM;
  int? Dy1_KaumIPLuar;
  int? Dy1_KaumLPu;
  int? Dy1_KaumLK;
  int? Dy1_KaumLH;
  int? Dy1_KaumLT;
  int? Dy1_KaumLM;
  int? Dy1_KaumLPLuar;
  int? Dy1_UmurU0Pu;
  int? Dy1_UmurU1Pu;
  int? Dy1_UmurU2Pu;
  int? Dy1_UmurU3Pu;
  int? Dy1_UmurU4Pu;
  int? Dy1_UmurU5Pu;
  int? Dy1_UmurU6Pu;
  int? Dy1_UmurU7Pu;
  int? Dy1_AhliGPu;
  int? Dy1_AhliWPu;
  int? Dy1_AhliYPu;
  int? Dy1_AhliPPu;
  int? Dy1__XMatchingM;
  int? Dy1__XMatchingMP;
  int? Dy1__MatchingM;
  int? Dy1__MatchingMP;
  int? Dy1__MatchingMK;
  int? Dy1__MatchingMH;
  int? Dy1__MatchingMT;
  int? Dy1__MatchingMM;
  int? Dy1__MatchingMBanci;
  int? Dy1__MatchingMBBanci;
  int? Dy1__MatchingC;
  int? Dy1__MatchingI;
  int? Dy1__MatchingL;
  int? Dy1___KaumM_L_1;
  int? Dy1___KaumM_L_1_P;
  int? Dy1___KaumM_L_1_K;
  int? Dy1___KaumM_L_1_H;
  int? Dy1___KaumM_L_1_T;
  int? Dy1___KaumM_L_1_M;
  int? Dy1___KaumM_L_1_Banci;
  int? Dy1___KaumM_L_1_BBanci;
  int? Dy1___KaumM_P_2;
  int? Dy1___KaumM_P_2_P;
  int? Dy1___KaumM_P_2_K;
  int? Dy1___KaumM_P_2_H;
  int? Dy1___KaumM_P_2_T;
  int? Dy1___KaumM_P_2_M;
  int? Dy1___KaumM_P_2_Banci;
  int? Dy1___KaumM_P_2_BBanci;
  int? Dy1___KaumM_L_3;
  int? Dy1___KaumM_L_3_P;
  int? Dy1___KaumM_L_3_K;
  int? Dy1___KaumM_L_3_H;
  int? Dy1___KaumM_L_3_T;
  int? Dy1___KaumM_L_3_M;
  int? Dy1___KaumM_L_3_Banci;
  int? Dy1___KaumM_L_3_BBanci;
  int? Dy1___KaumM_P_4;
  int? Dy1___KaumM_P_4_P;
  int? Dy1___KaumM_P_4_K;
  int? Dy1___KaumM_P_4_H;
  int? Dy1___KaumM_P_4_T;
  int? Dy1___KaumM_P_4_M;
  int? Dy1___KaumM_P_4_Banci;
  int? Dy1___KaumM_P_4_BBanci;
  int? Dy1___KaumM_L_3_SikapM_Banci;
  int? Dy1___KaumM_L_3_SikapM_Banci_P;
  int? Dy1___KaumM_L_3_SikapM_Banci_K;
  int? Dy1___KaumM_L_3_SikapM_Banci_H;
  int? Dy1___KaumM_L_3_StatusM_Banci_T;
  int? Dy1___KaumM_L_3_StatusM_Banci_M;
  int? Dy1___KaumM_L_3_SikapM_1;
  int? Dy1___KaumM_L_3_SikapM_2;
  int? Dy1___KaumM_L_3_SikapM_3;
  int? Dy1___KaumM_L_3_SikapM_4;
  int? Dy1___KaumM_L_3_SikapM_5;
  int? Dy1___KaumM_L_3_SikapM_6;
  int? Dy1___KaumM_L_3_SikapM_7;
  int? Dy1___KaumM_L_3_SikapM_8;
  int? Dy1___KaumM_L_3_SikapM_9;
  int? Dy1___KaumM_L_3_SikapM_10;
  int? Dy1___KaumM_L_3_SikapM_11;
  int? Dy1___KaumM_L_3_StatusM_T;
  int? Dy1___KaumM_L_3_StatusM_M;
  int? Dy1___L_3_Jumlah_Petugas;
  int? Dy1___KaumM_P_4_SikapM_Banci;
  int? Dy1___KaumM_P_4_SikapM_Banci_P;
  int? Dy1___KaumM_P_4_SikapM_Banci_K;
  int? Dy1___KaumM_P_4_SikapM_Banci_H;
  int? Dy1___KaumM_P_4_StatusM_Banci_T;
  int? Dy1___KaumM_P_4_StatusM_Banci_M;
  int? Dy1___KaumM_P_4_SikapM_1;
  int? Dy1___KaumM_P_4_SikapM_2;
  int? Dy1___KaumM_P_4_SikapM_3;
  int? Dy1___KaumM_P_4_SikapM_4;
  int? Dy1___KaumM_P_4_SikapM_5;
  int? Dy1___KaumM_P_4_SikapM_6;
  int? Dy1___KaumM_P_4_SikapM_7;
  int? Dy1___KaumM_P_4_SikapM_8;
  int? Dy1___KaumM_P_4_SikapM_9;
  int? Dy1___KaumM_P_4_SikapM_10;
  int? Dy1___KaumM_P_4_SikapM_11;
  int? Dy1___KaumM_P_4_StatusM_T;
  int? Dy1___KaumM_P_4_StatusM_M;
  int? Dy1___P_4_Jumlah_Petugas;

  int? Dy1___KaumM_L_3_SikapP_SikapMP;
  int? Dy1___KaumM_L_3_SikapP_SikapMNotP;
  int? Dy1___KaumM_L_3_SikapNotP_SikapMP;

  int? Dy1___KaumM_P_4_SikapP_SikapMP;
  int? Dy1___KaumM_P_4_SikapP_SikapMNotP;
  int? Dy1___KaumM_P_4_SikapNotP_SikapMP;



  
  int? Dy2_HB1;
  int? Dy2_PHB1;
  int? Dy2_KHB1;
  int? Dy2_HHB1;
  int? Dy2_THB1;
  int? Dy2_MHB1;
  int? Dy2_BBHB1;
  int? Dy2_JantinaLHB1;
  int? Dy2_JantinaPHB1;
  int? Dy2_JantinaLPuHB1;
  int? Dy2_JantinaPPuHB1;
  int? Dy2_KaumMHB1;
  int? Dy2_KaumCHB1;
  int? Dy2_KaumIHB1;
  int? Dy2_KaumLHB1;
  int? Dy2_KaumMPuHB1;
  int? Dy2_KaumCPuHB1;
  int? Dy2_KaumIPuHB1;
  int? Dy2_KaumLPuHB1;
  int? Dy2_UmurU0HB1;
  int? Dy2_UmurU1HB1;
  int? Dy2_UmurU2HB1;
  int? Dy2_UmurU3HB1;
  int? Dy2_UmurU4HB1;
  int? Dy2_UmurU5HB1;
  int? Dy2_UmurU6HB1;
  int? Dy2_UmurU7HB1;
  int? Dy2_UmurU0PuHB1;
  int? Dy2_UmurU1PuHB1;
  int? Dy2_UmurU2PuHB1;
  int? Dy2_UmurU3PuHB1;
  int? Dy2_UmurU4PuHB1;
  int? Dy2_UmurU5PuHB1;
  int? Dy2_UmurU6PuHB1;
  int? Dy2_UmurU7PuHB1;
  int? Dy2_AhliGHB1;
  int? Dy2_AhliWHB1;
  int? Dy2_AhliYHB1;
  int? Dy2_AhliPHB1;
  int? Dy2_AhliGPuHB1;
  int? Dy2_AhliWPuHB1;
  int? Dy2_AhliYPuHB1;
  int? Dy2_AhliPPuHB1;
  int? Dy3_HB2;
  int? Dy3_PHB2;
  int? Dy3_KHB2;
  int? Dy3_HHB2;
  int? Dy3_THB2;
  int? Dy3_MHB2;
  int? Dy3_BBHB2;
  int? Dy3_JantinaLHB2;
  int? Dy3_JantinaPHB2;
  int? Dy3_JantinaLPuHB2;
  int? Dy3_JantinaPPuHB2;
  int? Dy3_KaumMHB2;
  int? Dy3_KaumCHB2;
  int? Dy3_KaumIHB2;
  int? Dy3_KaumLHB2;
  int? Dy3_KaumMPuHB2;
  int? Dy3_KaumCPuHB2;
  int? Dy3_KaumIPuHB2;
  int? Dy3_KaumLPuHB2;
  int? Dy3_UmurU0HB2;
  int? Dy3_UmurU1HB2;
  int? Dy3_UmurU2HB2;
  int? Dy3_UmurU3HB2;
  int? Dy3_UmurU4HB2;
  int? Dy3_UmurU5HB2;
  int? Dy3_UmurU6HB2;
  int? Dy3_UmurU7HB2;
  int? Dy3_UmurU0PuHB2;
  int? Dy3_UmurU1PuHB2;
  int? Dy3_UmurU2PuHB2;
  int? Dy3_UmurU3PuHB2;
  int? Dy3_UmurU4PuHB2;
  int? Dy3_UmurU5PuHB2;
  int? Dy3_UmurU6PuHB2;
  int? Dy3_UmurU7PuHB2;
  int? Dy3_AhliGHB2;
  int? Dy3_AhliWHB2;
  int? Dy3_AhliYHB2;
  int? Dy3_AhliPHB2;
  int? Dy3_AhliGPuHB2;
  int? Dy3_AhliWPuHB2;
  int? Dy3_AhliYPuHB2;
  int? Dy3_AhliPPuHB2;
  int? Dy4_Hadir;
  int? Dy4_PHadir;
  int? Dy4_KHadir;
  int? Dy4_HHadir;
  int? Dy4_THadir;
  int? Dy4_MHadir;
  int? Dy4_BBHadir;
  int? Dy4_AktifHadir;
  int? Dy4_LNHadir;
  int? Dy4_LPHadir;
  int? Dy4_LDHadir;
  int? Dy4_LMHadir;
  int? Dy4_AktifPuHadir;
  int? Dy4_LNPuHadir;
  int? Dy4_LPPuHadir;
  int? Dy4_LDPuHadir;
  int? Dy4_LMPuHadir;
  int? Dy4_JantinaLHadir;
  int? Dy4_JantinaPHadir;
  int? Dy4_JantinaLPuHadir;
  int? Dy4_JantinaPPuHadir;
  int? Dy4_KaumMHadir;
  int? Dy4_KaumCHadir;
  int? Dy4_KaumIHadir;
  int? Dy4_KaumLHadir;
  int? Dy4_KaumMPuHadir;
  int? Dy4_KaumCPuHadir;
  int? Dy4_KaumIPuHadir;
  int? Dy4_KaumLPuHadir;
  int? Dy4_UmurU0Hadir;
  int? Dy4_UmurU1Hadir;
  int? Dy4_UmurU2Hadir;
  int? Dy4_UmurU3Hadir;
  int? Dy4_UmurU4Hadir;
  int? Dy4_UmurU5Hadir;
  int? Dy4_UmurU6Hadir;
  int? Dy4_UmurU7Hadir;
  int? Dy4_UmurU0PuHadir;
  int? Dy4_UmurU1PuHadir;
  int? Dy4_UmurU2PuHadir;
  int? Dy4_UmurU3PuHadir;
  int? Dy4_UmurU4PuHadir;
  int? Dy4_UmurU5PuHadir;
  int? Dy4_UmurU6PuHadir;
  int? Dy4_UmurU7PuHadir;
  int? Dy4_AhliGHadir;
  int? Dy4_AhliWHadir;
  int? Dy4_AhliYHadir;
  int? Dy4_AhliPHadir;
  int? Dy4_AhliGPuHadir;
  int? Dy4_AhliWPuHadir;
  int? Dy4_AhliYPuHadir;
  int? Dy4_AhliPPuHadir;
  String? Kpi_Per_Hadir_PRULepas;
  String? Kpi_PemilihHadir;
  String? Kpi_Undi_AsasMenang;
  String? Kpi_P100;
  String? Kpi_BukanP100;
  String? Kpi_P100_Undi_AsasMenang;
  String? Kpi_Status_Simulasi_Majoriti100;
  String? Kpi_Status_Majoriti100;
  String? Kpi_P95;
  String? Kpi_BukanP95;
  String? Kpi_P95_Undi_AsasMenang;
  String? Kpi_Status_Simulasi_Majoriti95;
  String? Kpi_Status_Majoriti95;
  String? Kpi_P90;
  String? Kpi_BukanP90;
  String? Kpi_P90_Undi_AsasMenang;
  String? Kpi_Status_Simulasi_Majoriti90;
  String? Kpi_Status_Majoriti90;
  String? Kpi_P85;
  String? Kpi_BukanP85;
  String? Kpi_P85_Undi_AsasMenang;
  String? Kpi_Status_Simulasi_Majoriti85;
  String? Kpi_Status_Majoriti85;
  String? Kpi_P80;
  String? Kpi_BukanP80;
  String? Kpi_P80_Undi_AsasMenang;
  String? Kpi_Status_Simulasi_Majoriti80;
  String? Kpi_Status_Majoriti80;
  String? Kpi_P75;
  String? Kpi_BukanP75;
  String? Kpi_P75_Undi_AsasMenang;
  String? Kpi_Status_Simulasi_Majoriti75;
  String? Kpi_Status_Majoriti75;

  int? Dy0ax_JumJRAktif;
  int? Dy0ax_JumJRXAktif;
  int? Dy1x_Banci;
  int? Dy1x_BBanci;
  int? Dy1x_KaumMBanci;
  int? Dy1x_KaumMBBanci;
  int? Dy4x_THadir;
  int? Dy4x_PTHadir;
  int? Dy4x_KTHadir;
  int? Dy4x_HTHadir;
  int? Dy4x_TTHadir;
  int? Dy4x_MTHadir;
  int? Dy4x_BBTHadir;
  int? Dy4x_JantinaLTHadir;
  int? Dy4x_JantinaPTHadir;
  int? Dy4x_JantinaLPuTHadir;
  int? Dy4x_JantinaPPuTHadir;
  int? Dy4x_KaumMTHadir;
  int? Dy4x_KaumCTHadir;
  int? Dy4x_KaumITHadir;
  int? Dy4x_KaumLTHadir;
  int? Dy4x_KaumMPuTHadir;
  int? Dy4x_KaumCPuTHadir;
  int? Dy4x_KaumIPuTHadir;
  int? Dy4x_KaumLPuTHadir;
  int? Dy4x_UmurU0THadir;
  int? Dy4x_UmurU1THadir;
  int? Dy4x_UmurU2THadir;
  int? Dy4x_UmurU3THadir;
  int? Dy4x_UmurU4THadir;
  int? Dy4x_UmurU5THadir;
  int? Dy4x_UmurU6THadir;
  int? Dy4x_UmurU7THadir;
  int? Dy4x_UmurU0PuTHadir;
  int? Dy4x_UmurU1PuTHadir;
  int? Dy4x_UmurU2PuTHadir;
  int? Dy4x_UmurU3PuTHadir;
  int? Dy4x_UmurU4PuTHadir;
  int? Dy4x_UmurU5PuTHadir;
  int? Dy4x_UmurU6PuTHadir;
  int? Dy4x_UmurU7PuTHadir;

  int? Banci_KaumM;
  int? BBanci_KaumM;
  int? Banci_KaumC;
  int? BBanci_KaumC;
  int? Banci_KaumI;
  int? BBanci_KaumI;
  int? Banci_KaumL;
  int? BBanci_KaumL;

  int? Stx_OT;
  int? Stx_OT_KaumM;
  int? Stx_OT_KaumC;
  int? Stx_OT_KaumI;
  int? Stx_OT_KaumL;


  int? Kpi_Pemilih;
  // String? Kpi_Per_Hadir_PRULepas;
  // String? Kpi_PemilihHadir;
  // String? Kpi_Undi_AsasMenang;
  // String? Kpi_P100;

  // String? Kpi_BukanP100;
  // String? Kpi_P100_Undi_AsasMenang;
  // String? Kpi_Status_Simulasi_Majoriti100;
  // String? Kpi_Status_Majoriti100;
  // String? Kpi_Status_Majoriti95;
  // String? Kpi_Status_Majoriti90;
  // String? Kpi_Status_Majoriti85;
  // String? Kpi_Status_Majoriti80;
  // String? Kpi_Status_Majoriti75;
  
  int? Parlimen_JumRETAIN;
  int? Parlimen_JumREGAIN;
  int? Parlimen_JumREDUCE;
  int? Parlimen_JumMENANG;
  int? Parlimen_JumKALAH;
  int? Parlimen_All;


  


  int? DUN_JumRETAIN;
  int? DUN_JumREGAIN;
  int? DUN_JumREDUCE;
  int? DUN_JumMENANG;
  int? DUN_JumKALAH;
  int? DUN_All;

  int? DM_JumRETAIN;
  int? DM_JumREGAIN;
  int? DM_JumREDUCE;
  int? DM_JumMENANG;
  int? DM_JumKALAH;
  int? DM_All;

  int? PRUBefore_Pemilih;
  String? PRUBefore_Peratusan_Hadir;
  int? PRUBefore_Pemilih_Hadir;
  String? PRUBefore_NamaParti;
  String? PRUBefore_NamaKomponen;
  int? PRUBefore_UndiDapat;

  String? PRUBefore_NamaParti2;
  String? PRUBefore_NamaKomponen2;
  int? PRUBefore_UndiDapat2;
  int? PRUBefore_Majoriti;
  String? PRUBefore_PartiMenang;
  String? PRUBefore_Status_Kawasan;
  String? PRUBefore_Name;

  int? St_Pacu_Cawangan_ByPar;
  int? St_Pacu_Cawangan_ByPar_AdaDM;
  int? St_Pacu_Cawangan_ByPar_TiadaDM;
  int? St_Pacu_Cawangan;
  int? St_Pacu_Ahli;
  int? St_Pacu_Ahli_G;
  int? St_Pacu_Ahli_W;
  int? St_Pacu_Ahli_Y;
  int? St_Pacu_Ahli_P;
  int? St_Pacu_Ahli_Pemilih;
  int? St_Pacu_Ahli_G_Pemilih;
  int? St_Pacu_Ahli_W_Pemilih;
  int? St_Pacu_Ahli_Y_Pemilih;
  int? St_Pacu_Ahli_P_Pemilih;
  int? St_Pacu_Ahli_Pemilih_AhliDPar;
  int? St_Pacu_Ahli_Pemilih_AhliLPar;
  int? Kpi_Pacu_JCaw;
  int? Kpi_Pacu_JCaw_JejakAhli;
  int? Kpi_Pacu_JCaw_JejakAhliPemilih;
  int? Dy0b_Pacu_JCaw;
  int? Dy0b_Pacu_JCaw_JejakAhli;
  int? Dy0b_Pacu_JCaw_JejakAhliPemilih;
  int? Dy0b_Pacu_JCaw_Matching;
  int? Dy1__Pacu_JCaw_MatchingP;
  int? Dy1__Pacu_JCaw_MatchingK;
  int? Dy1__Pacu_JCaw_MatchingH;
  int? Dy1__Pacu_JCaw_MatchingT;
  int? Dy1__Pacu_JCaw_MatchingM;
  int? Dy1__Pacu_JCaw_MatchingBanci;
  int? Dy1__Pacu_JCaw_MatchingBBanci;

  int? Dy5_JCaw_P_Dt0;
  int? Dy5_JCaw_P_Dt1;
  int? Dy5_JCaw_P_Dt2;
  int? Dy5_JCaw_P_Dt3;
  int? Dy5_JCaw_P_Dt4;
  int? Dy5_JCaw_P_Dt5;
  int? Dy5_JCaw_P_Dt6;
  int? Dy5_JCaw_P_Dt7;
  int? Dy5_JR_P_Dt0;
  int? Dy5_JR_P_Dt1;
  int? Dy5_JR_P_Dt2;
  int? Dy5_JR_P_Dt3;
  int? Dy5_JR_P_Dt4;
  int? Dy5_JR_P_Dt5;
  int? Dy5_JR_P_Dt6;
  int? Dy5_JR_P_Dt7;
  int? Dy5_NoTel_HF_Dt0;
  int? Dy5_NoTel_HF_Dt1;
  int? Dy5_NoTel_HF_Dt2;
  int? Dy5_NoTel_HF_Dt3;
  int? Dy5_NoTel_HF_Dt4;
  int? Dy5_NoTel_HF_Dt5;
  int? Dy5_NoTel_HF_Dt6;
  int? Dy5_NoTel_HF_Dt7;



  //----
  GetDbKawasanSuccess({
    required this.listDbKawasan,
    //----
    required this.JumNegeri,
    required this.JumParlimen,
    required this.JumDUN,
    required this.JumDM,
    required this.JumLokaliti,

    //-------------------Stat_DM###
    this.St_Pemilih,
    this.St_Awal,
    this.St_Pos,
    this.St_Awam,
    this.St_JantinaL,
    this.St_JantinaP,
    this.St_KaumM,
    this.St_KaumC,
    this.St_KaumI,
    this.St_KaumL,
    this.St_UmurU0,
    this.St_UmurU1,
    this.St_UmurU2,
    this.St_UmurU3,
    this.St_UmurU4,
    this.St_UmurU5,
    this.St_UmurU6,
    this.St_UmurU7,
    this.St_UmurU0L,
    this.St_UmurU0LM,
    this.St_UmurU0LC,
    this.St_UmurU0LI,
    this.St_UmurU0LL,
    this.St_UmurU0P,
    this.St_UmurU0PM,
    this.St_UmurU0PC,
    this.St_UmurU0PI,
    this.St_UmurU0PL,
    this.St_UmurU1L,
    this.St_UmurU1LM,
    this.St_UmurU1LC,
    this.St_UmurU1LI,
    this.St_UmurU1LL,
    this.St_UmurU1P,
    this.St_UmurU1PM,
    this.St_UmurU1PC,
    this.St_UmurU1PI,
    this.St_UmurU1PL,
    this.St_UmurU2L,
    this.St_UmurU2LM,
    this.St_UmurU2LC,
    this.St_UmurU2LI,
    this.St_UmurU2LL,
    this.St_UmurU2P,
    this.St_UmurU2PM,
    this.St_UmurU2PC,
    this.St_UmurU2PI,
    this.St_UmurU2PL,
    this.St_UmurU3L,
    this.St_UmurU3LM,
    this.St_UmurU3LC,
    this.St_UmurU3LI,
    this.St_UmurU3LL,
    this.St_UmurU3P,
    this.St_UmurU3PM,
    this.St_UmurU3PC,
    this.St_UmurU3PI,
    this.St_UmurU3PL,
    this.St_UmurU4L,
    this.St_UmurU4LM,
    this.St_UmurU4LC,
    this.St_UmurU4LI,
    this.St_UmurU4LL,
    this.St_UmurU4P,
    this.St_UmurU4PM,
    this.St_UmurU4PC,
    this.St_UmurU4PI,
    this.St_UmurU4PL,
    this.St_UmurU5L,
    this.St_UmurU5LM,
    this.St_UmurU5LC,
    this.St_UmurU5LI,
    this.St_UmurU5LL,
    this.St_UmurU5P,
    this.St_UmurU5PM,
    this.St_UmurU5PC,
    this.St_UmurU5PI,
    this.St_UmurU5PL,
    this.St_UmurU6L,
    this.St_UmurU6LM,
    this.St_UmurU6LC,
    this.St_UmurU6LI,
    this.St_UmurU6LL,
    this.St_UmurU6P,
    this.St_UmurU6PM,
    this.St_UmurU6PC,
    this.St_UmurU6PI,
    this.St_UmurU6PL,
    this.St_UmurU7L,
    this.St_UmurU7LM,
    this.St_UmurU7LC,
    this.St_UmurU7LI,
    this.St_UmurU7LL,
    this.St_UmurU7P,
    this.St_UmurU7PM,
    this.St_UmurU7PC,
    this.St_UmurU7PI,
    this.St_UmurU7PL,
    this.St_AhliG,
    this.St_AhliW,
    this.St_AhliY,
    this.St_AhliP,
    this.Dy0a_JumJR,
    this.Dy0a_JumJRAktif_queDel,
    this.Dy0a_JumJRAktif_DMSPR_queDel,
    this.Dy0a_JumJRAktif_DMAkses_queDel,
    this.Dy0a_JumJRXAktif_queDel,
    this.Dy1_P,
    this.Dy1_K,
    this.Dy1_H,
    this.Dy1_T,
    this.Dy1_M,
    this.Dy1_BB,
    this.Dy1_Aktif,
    this.Dy1_LN,
    this.Dy1_LP,
    this.Dy1_LD,
    this.Dy1_LM,
    this.Dy1_PLuar,
    this.Dy1_AktifPu,
    this.Dy1_LNPu,
    this.Dy1_LPPu,
    this.Dy1_LDPu,
    this.Dy1_LMPu,
    this.Dy1_PLuarPu,
    this.Dy1_JantinaLPu,
    this.Dy1_JantinaLK,
    this.Dy1_JantinaLH,
    this.Dy1_JantinaLT,
    this.Dy1_JantinaLM,
    this.Dy1_JantinaLPLuar,
    this.Dy1_JantinaPPu,
    this.Dy1_JantinaPK,
    this.Dy1_JantinaPH,
    this.Dy1_JantinaPT,
    this.Dy1_JantinaPM,
    this.Dy1_JantinaPPLuar,
    this.Dy1_KaumMPu,
    this.Dy1_KaumMK,
    this.Dy1_KaumMH,
    this.Dy1_KaumMT,
    this.Dy1_KaumMM,
    this.Dy1_KaumMPLuar,
    this.Dy1_KaumCPu,
    this.Dy1_KaumCK,
    this.Dy1_KaumCH,
    this.Dy1_KaumCT,
    this.Dy1_KaumCM,
    this.Dy1_KaumCPLuar,
    this.Dy1_KaumIPu,
    this.Dy1_KaumIK,
    this.Dy1_KaumIH,
    this.Dy1_KaumIT,
    this.Dy1_KaumIM,
    this.Dy1_KaumIPLuar,
    this.Dy1_KaumLPu,
    this.Dy1_KaumLK,
    this.Dy1_KaumLH,
    this.Dy1_KaumLT,
    this.Dy1_KaumLM,
    this.Dy1_KaumLPLuar,
    this.Dy1_UmurU0Pu,
    this.Dy1_UmurU1Pu,
    this.Dy1_UmurU2Pu,
    this.Dy1_UmurU3Pu,
    this.Dy1_UmurU4Pu,
    this.Dy1_UmurU5Pu,
    this.Dy1_UmurU6Pu,
    this.Dy1_UmurU7Pu,
    this.Dy1_AhliGPu,
    this.Dy1_AhliWPu,
    this.Dy1_AhliYPu,
    this.Dy1_AhliPPu,
    this.Dy1__XMatchingM,
    this.Dy1__XMatchingMP,
    this.Dy1__MatchingM,
    this.Dy1__MatchingMP,
    this.Dy1__MatchingMK,
    this.Dy1__MatchingMH,
    this.Dy1__MatchingMT,
    this.Dy1__MatchingMM,
    this.Dy1__MatchingMBanci,
    this.Dy1__MatchingMBBanci,
    this.Dy1__MatchingC,
    this.Dy1__MatchingI,
    this.Dy1__MatchingL,
    this.Dy1___KaumM_L_1,
    this.Dy1___KaumM_L_1_P,
    this.Dy1___KaumM_L_1_K,
    this.Dy1___KaumM_L_1_H,
    this.Dy1___KaumM_L_1_T,
    this.Dy1___KaumM_L_1_M,
    this.Dy1___KaumM_L_1_Banci,
    this.Dy1___KaumM_L_1_BBanci,
    this.Dy1___KaumM_P_2,
    this.Dy1___KaumM_P_2_P,
    this.Dy1___KaumM_P_2_K,
    this.Dy1___KaumM_P_2_H,
    this.Dy1___KaumM_P_2_T,
    this.Dy1___KaumM_P_2_M,
    this.Dy1___KaumM_P_2_Banci,
    this.Dy1___KaumM_P_2_BBanci,
    this.Dy1___KaumM_L_3,
    this.Dy1___KaumM_L_3_P,
    this.Dy1___KaumM_L_3_K,
    this.Dy1___KaumM_L_3_H,
    this.Dy1___KaumM_L_3_T,
    this.Dy1___KaumM_L_3_M,
    this.Dy1___KaumM_L_3_Banci,
    this.Dy1___KaumM_L_3_BBanci,
    this.Dy1___KaumM_P_4,
    this.Dy1___KaumM_P_4_P,
    this.Dy1___KaumM_P_4_K,
    this.Dy1___KaumM_P_4_H,
    this.Dy1___KaumM_P_4_T,
    this.Dy1___KaumM_P_4_M,
    this.Dy1___KaumM_P_4_Banci,
    this.Dy1___KaumM_P_4_BBanci,
    this.Dy1___KaumM_L_3_SikapM_Banci,
    this.Dy1___KaumM_L_3_SikapM_Banci_P,
    this.Dy1___KaumM_L_3_SikapM_Banci_K,
    this.Dy1___KaumM_L_3_SikapM_Banci_H,
    this.Dy1___KaumM_L_3_StatusM_Banci_T,
    this.Dy1___KaumM_L_3_StatusM_Banci_M,
    this.Dy1___KaumM_L_3_SikapM_1,
    this.Dy1___KaumM_L_3_SikapM_2,
    this.Dy1___KaumM_L_3_SikapM_3,
    this.Dy1___KaumM_L_3_SikapM_4,
    this.Dy1___KaumM_L_3_SikapM_5,
    this.Dy1___KaumM_L_3_SikapM_6,
    this.Dy1___KaumM_L_3_SikapM_7,
    this.Dy1___KaumM_L_3_SikapM_8,
    this.Dy1___KaumM_L_3_SikapM_9,
    this.Dy1___KaumM_L_3_SikapM_10,
    this.Dy1___KaumM_L_3_SikapM_11,
    this.Dy1___KaumM_L_3_StatusM_T,
    this.Dy1___KaumM_L_3_StatusM_M,
    this.Dy1___L_3_Jumlah_Petugas,
    this.Dy1___KaumM_P_4_SikapM_Banci,
    this.Dy1___KaumM_P_4_SikapM_Banci_P,
    this.Dy1___KaumM_P_4_SikapM_Banci_K,
    this.Dy1___KaumM_P_4_SikapM_Banci_H,
    this.Dy1___KaumM_P_4_StatusM_Banci_T,
    this.Dy1___KaumM_P_4_StatusM_Banci_M,
    this.Dy1___KaumM_P_4_SikapM_1,
    this.Dy1___KaumM_P_4_SikapM_2,
    this.Dy1___KaumM_P_4_SikapM_3,
    this.Dy1___KaumM_P_4_SikapM_4,
    this.Dy1___KaumM_P_4_SikapM_5,
    this.Dy1___KaumM_P_4_SikapM_6,
    this.Dy1___KaumM_P_4_SikapM_7,
    this.Dy1___KaumM_P_4_SikapM_8,
    this.Dy1___KaumM_P_4_SikapM_9,
    this.Dy1___KaumM_P_4_SikapM_10,
    this.Dy1___KaumM_P_4_SikapM_11,
    this.Dy1___KaumM_P_4_StatusM_T,
    this.Dy1___KaumM_P_4_StatusM_M,
    this.Dy1___P_4_Jumlah_Petugas,

    this.Dy1___KaumM_L_3_SikapP_SikapMP,
    this.Dy1___KaumM_L_3_SikapP_SikapMNotP,
    this.Dy1___KaumM_L_3_SikapNotP_SikapMP,

    this.Dy1___KaumM_P_4_SikapP_SikapMP,
    this.Dy1___KaumM_P_4_SikapP_SikapMNotP,
    this.Dy1___KaumM_P_4_SikapNotP_SikapMP,

    this.Dy2_HB1,
    this.Dy2_PHB1,
    this.Dy2_KHB1,
    this.Dy2_HHB1,
    this.Dy2_THB1,
    this.Dy2_MHB1,
    this.Dy2_BBHB1,
    this.Dy2_JantinaLHB1,
    this.Dy2_JantinaPHB1,
    this.Dy2_JantinaLPuHB1,
    this.Dy2_JantinaPPuHB1,
    this.Dy2_KaumMHB1,
    this.Dy2_KaumCHB1,
    this.Dy2_KaumIHB1,
    this.Dy2_KaumLHB1,
    this.Dy2_KaumMPuHB1,
    this.Dy2_KaumCPuHB1,
    this.Dy2_KaumIPuHB1,
    this.Dy2_KaumLPuHB1,
    this.Dy2_UmurU0HB1,
    this.Dy2_UmurU1HB1,
    this.Dy2_UmurU2HB1,
    this.Dy2_UmurU3HB1,
    this.Dy2_UmurU4HB1,
    this.Dy2_UmurU5HB1,
    this.Dy2_UmurU6HB1,
    this.Dy2_UmurU7HB1,
    this.Dy2_UmurU0PuHB1,
    this.Dy2_UmurU1PuHB1,
    this.Dy2_UmurU2PuHB1,
    this.Dy2_UmurU3PuHB1,
    this.Dy2_UmurU4PuHB1,
    this.Dy2_UmurU5PuHB1,
    this.Dy2_UmurU6PuHB1,
    this.Dy2_UmurU7PuHB1,
    this.Dy2_AhliGHB1,
    this.Dy2_AhliWHB1,
    this.Dy2_AhliYHB1,
    this.Dy2_AhliPHB1,
    this.Dy2_AhliGPuHB1,
    this.Dy2_AhliWPuHB1,
    this.Dy2_AhliYPuHB1,
    this.Dy2_AhliPPuHB1,
    this.Dy3_HB2,
    this.Dy3_PHB2,
    this.Dy3_KHB2,
    this.Dy3_HHB2,
    this.Dy3_THB2,
    this.Dy3_MHB2,
    this.Dy3_BBHB2,
    this.Dy3_JantinaLHB2,
    this.Dy3_JantinaPHB2,
    this.Dy3_JantinaLPuHB2,
    this.Dy3_JantinaPPuHB2,
    this.Dy3_KaumMHB2,
    this.Dy3_KaumCHB2,
    this.Dy3_KaumIHB2,
    this.Dy3_KaumLHB2,
    this.Dy3_KaumMPuHB2,
    this.Dy3_KaumCPuHB2,
    this.Dy3_KaumIPuHB2,
    this.Dy3_KaumLPuHB2,
    this.Dy3_UmurU0HB2,
    this.Dy3_UmurU1HB2,
    this.Dy3_UmurU2HB2,
    this.Dy3_UmurU3HB2,
    this.Dy3_UmurU4HB2,
    this.Dy3_UmurU5HB2,
    this.Dy3_UmurU6HB2,
    this.Dy3_UmurU7HB2,
    this.Dy3_UmurU0PuHB2,
    this.Dy3_UmurU1PuHB2,
    this.Dy3_UmurU2PuHB2,
    this.Dy3_UmurU3PuHB2,
    this.Dy3_UmurU4PuHB2,
    this.Dy3_UmurU5PuHB2,
    this.Dy3_UmurU6PuHB2,
    this.Dy3_UmurU7PuHB2,
    this.Dy3_AhliGHB2,
    this.Dy3_AhliWHB2,
    this.Dy3_AhliYHB2,
    this.Dy3_AhliPHB2,
    this.Dy3_AhliGPuHB2,
    this.Dy3_AhliWPuHB2,
    this.Dy3_AhliYPuHB2,
    this.Dy3_AhliPPuHB2,
    this.Dy4_Hadir,
    this.Dy4_PHadir,
    this.Dy4_KHadir,
    this.Dy4_HHadir,
    this.Dy4_THadir,
    this.Dy4_MHadir,
    this.Dy4_BBHadir,
    this.Dy4_AktifHadir,
    this.Dy4_LNHadir,
    this.Dy4_LPHadir,
    this.Dy4_LDHadir,
    this.Dy4_LMHadir,
    this.Dy4_AktifPuHadir,
    this.Dy4_LNPuHadir,
    this.Dy4_LPPuHadir,
    this.Dy4_LDPuHadir,
    this.Dy4_LMPuHadir,
    this.Dy4_JantinaLHadir,
    this.Dy4_JantinaPHadir,
    this.Dy4_JantinaLPuHadir,
    this.Dy4_JantinaPPuHadir,
    this.Dy4_KaumMHadir,
    this.Dy4_KaumCHadir,
    this.Dy4_KaumIHadir,
    this.Dy4_KaumLHadir,
    this.Dy4_KaumMPuHadir,
    this.Dy4_KaumCPuHadir,
    this.Dy4_KaumIPuHadir,
    this.Dy4_KaumLPuHadir,
    this.Dy4_UmurU0Hadir,
    this.Dy4_UmurU1Hadir,
    this.Dy4_UmurU2Hadir,
    this.Dy4_UmurU3Hadir,
    this.Dy4_UmurU4Hadir,
    this.Dy4_UmurU5Hadir,
    this.Dy4_UmurU6Hadir,
    this.Dy4_UmurU7Hadir,
    this.Dy4_UmurU0PuHadir,
    this.Dy4_UmurU1PuHadir,
    this.Dy4_UmurU2PuHadir,
    this.Dy4_UmurU3PuHadir,
    this.Dy4_UmurU4PuHadir,
    this.Dy4_UmurU5PuHadir,
    this.Dy4_UmurU6PuHadir,
    this.Dy4_UmurU7PuHadir,
    this.Dy4_AhliGHadir,
    this.Dy4_AhliWHadir,
    this.Dy4_AhliYHadir,
    this.Dy4_AhliPHadir,
    this.Dy4_AhliGPuHadir,
    this.Dy4_AhliWPuHadir,
    this.Dy4_AhliYPuHadir,
    this.Dy4_AhliPPuHadir,
    this.Kpi_Per_Hadir_PRULepas,
    this.Kpi_PemilihHadir,
    this.Kpi_Undi_AsasMenang,
    this.Kpi_P100,
    this.Kpi_BukanP100,
    this.Kpi_P100_Undi_AsasMenang,
    this.Kpi_Status_Simulasi_Majoriti100,
    this.Kpi_Status_Majoriti100,
    this.Kpi_P95,
    this.Kpi_BukanP95,
    this.Kpi_P95_Undi_AsasMenang,
    this.Kpi_Status_Simulasi_Majoriti95,
    this.Kpi_Status_Majoriti95,
    this.Kpi_P90,
    this.Kpi_BukanP90,
    this.Kpi_P90_Undi_AsasMenang,
    this.Kpi_Status_Simulasi_Majoriti90,
    this.Kpi_Status_Majoriti90,
    this.Kpi_P85,
    this.Kpi_BukanP85,
    this.Kpi_P85_Undi_AsasMenang,
    this.Kpi_Status_Simulasi_Majoriti85,
    this.Kpi_Status_Majoriti85,
    this.Kpi_P80,
    this.Kpi_BukanP80,
    this.Kpi_P80_Undi_AsasMenang,
    this.Kpi_Status_Simulasi_Majoriti80,
    this.Kpi_Status_Majoriti80,
    this.Kpi_P75,
    this.Kpi_BukanP75,
    this.Kpi_P75_Undi_AsasMenang,
    this.Kpi_Status_Simulasi_Majoriti75,
    this.Kpi_Status_Majoriti75,
    //-------------------Stat_DM###
    this.Dy0ax_JumJRAktif,
    this.Dy0ax_JumJRXAktif,
    this.Dy1x_Banci,
    this.Dy1x_BBanci,
    this.Dy1x_KaumMBanci,
    this.Dy1x_KaumMBBanci,
    this.Dy4x_THadir,
    this.Dy4x_PTHadir,
    this.Dy4x_KTHadir,
    this.Dy4x_HTHadir,
    this.Dy4x_TTHadir,
    this.Dy4x_MTHadir,
    this.Dy4x_BBTHadir,
    this.Dy4x_JantinaLTHadir,
    this.Dy4x_JantinaPTHadir,
    this.Dy4x_JantinaLPuTHadir,
    this.Dy4x_JantinaPPuTHadir,
    this.Dy4x_KaumMTHadir,
    this.Dy4x_KaumCTHadir,
    this.Dy4x_KaumITHadir,
    this.Dy4x_KaumLTHadir,
    this.Dy4x_KaumMPuTHadir,
    this.Dy4x_KaumCPuTHadir,
    this.Dy4x_KaumIPuTHadir,
    this.Dy4x_KaumLPuTHadir,
    this.Dy4x_UmurU0THadir,
    this.Dy4x_UmurU1THadir,
    this.Dy4x_UmurU2THadir,
    this.Dy4x_UmurU3THadir,
    this.Dy4x_UmurU4THadir,
    this.Dy4x_UmurU5THadir,
    this.Dy4x_UmurU6THadir,
    this.Dy4x_UmurU7THadir,
    this.Dy4x_UmurU0PuTHadir,
    this.Dy4x_UmurU1PuTHadir,
    this.Dy4x_UmurU2PuTHadir,
    this.Dy4x_UmurU3PuTHadir,
    this.Dy4x_UmurU4PuTHadir,
    this.Dy4x_UmurU5PuTHadir,
    this.Dy4x_UmurU6PuTHadir,
    this.Dy4x_UmurU7PuTHadir,

    this.Banci_KaumM,
    this.BBanci_KaumM,
    this.Banci_KaumC,
    this.BBanci_KaumC,
    this.Banci_KaumI,
    this.BBanci_KaumI,
    this.Banci_KaumL,
    this.BBanci_KaumL,

    this.Stx_OT,
    this.Stx_OT_KaumM,
    this.Stx_OT_KaumC,
    this.Stx_OT_KaumI,
    this.Stx_OT_KaumL,

    this.Kpi_Pemilih,
    // this.Kpi_Per_Hadir_PRULepas,
    // this.Kpi_PemilihHadir,
    // this.Kpi_Undi_AsasMenang,
    // this.Kpi_P100,
    // this.Kpi_BukanP100,
    // this.Kpi_P100_Undi_AsasMenang,
    // this.Kpi_Status_Simulasi_Majoriti100,

    // this.Kpi_Status_Majoriti100,
    // this.Kpi_Status_Majoriti95,
    // this.Kpi_Status_Majoriti90,
    // this.Kpi_Status_Majoriti85,
    // this.Kpi_Status_Majoriti80,
    // this.Kpi_Status_Majoriti75,


    this.Parlimen_JumRETAIN,
    this.Parlimen_JumREGAIN,
    this.Parlimen_JumREDUCE,
    this.Parlimen_JumMENANG,
    this.Parlimen_JumKALAH,
    this.Parlimen_All,




    this.DUN_JumRETAIN,
    this.DUN_JumREGAIN,
    this.DUN_JumREDUCE,
    this.DUN_JumMENANG,
    this.DUN_JumKALAH,
    this.DUN_All,

    this.DM_JumRETAIN,
    this.DM_JumREGAIN,
    this.DM_JumREDUCE,
    this.DM_JumMENANG,
    this.DM_JumKALAH,
    this.DM_All,

    this.PRUBefore_Pemilih,
    this.PRUBefore_Peratusan_Hadir,
    this.PRUBefore_Pemilih_Hadir,
    this.PRUBefore_NamaParti,
    this.PRUBefore_NamaKomponen,
    this.PRUBefore_UndiDapat,

    this.PRUBefore_NamaParti2,
    this.PRUBefore_NamaKomponen2,
    this.PRUBefore_UndiDapat2,
    this.PRUBefore_Majoriti,
    this.PRUBefore_PartiMenang,
    this.PRUBefore_Status_Kawasan,
    this.PRUBefore_Name,

    this.St_Pacu_Cawangan_ByPar,
    this.St_Pacu_Cawangan_ByPar_AdaDM,
    this.St_Pacu_Cawangan_ByPar_TiadaDM,
    this.St_Pacu_Cawangan,
    this.St_Pacu_Ahli,
    this.St_Pacu_Ahli_G,
    this.St_Pacu_Ahli_W,
    this.St_Pacu_Ahli_Y,
    this.St_Pacu_Ahli_P,
    this.St_Pacu_Ahli_Pemilih,
    this.St_Pacu_Ahli_G_Pemilih,
    this.St_Pacu_Ahli_W_Pemilih,
    this.St_Pacu_Ahli_Y_Pemilih,
    this.St_Pacu_Ahli_P_Pemilih,
    this.St_Pacu_Ahli_Pemilih_AhliDPar,
    this.St_Pacu_Ahli_Pemilih_AhliLPar,
    this.Kpi_Pacu_JCaw,
    this.Kpi_Pacu_JCaw_JejakAhli,
    this.Kpi_Pacu_JCaw_JejakAhliPemilih,
    this.Dy0b_Pacu_JCaw,
    this.Dy0b_Pacu_JCaw_JejakAhli,
    this.Dy0b_Pacu_JCaw_JejakAhliPemilih,
    this.Dy0b_Pacu_JCaw_Matching,
    this.Dy1__Pacu_JCaw_MatchingP,
    this.Dy1__Pacu_JCaw_MatchingK,
    this.Dy1__Pacu_JCaw_MatchingH,
    this.Dy1__Pacu_JCaw_MatchingT,
    this.Dy1__Pacu_JCaw_MatchingM,
    this.Dy1__Pacu_JCaw_MatchingBanci,
    this.Dy1__Pacu_JCaw_MatchingBBanci,

    this.Dy5_JCaw_P_Dt0,
    this.Dy5_JCaw_P_Dt1,
    this.Dy5_JCaw_P_Dt2,
    this.Dy5_JCaw_P_Dt3,
    this.Dy5_JCaw_P_Dt4,
    this.Dy5_JCaw_P_Dt5,
    this.Dy5_JCaw_P_Dt6,
    this.Dy5_JCaw_P_Dt7,
    this.Dy5_JR_P_Dt0,
    this.Dy5_JR_P_Dt1,
    this.Dy5_JR_P_Dt2,
    this.Dy5_JR_P_Dt3,
    this.Dy5_JR_P_Dt4,
    this.Dy5_JR_P_Dt5,
    this.Dy5_JR_P_Dt6,
    this.Dy5_JR_P_Dt7,
    this.Dy5_NoTel_HF_Dt0,
    this.Dy5_NoTel_HF_Dt1,
    this.Dy5_NoTel_HF_Dt2,
    this.Dy5_NoTel_HF_Dt3,
    this.Dy5_NoTel_HF_Dt4,
    this.Dy5_NoTel_HF_Dt5,
    this.Dy5_NoTel_HF_Dt6,
    this.Dy5_NoTel_HF_Dt7,

    //----
  });
}
//---------------