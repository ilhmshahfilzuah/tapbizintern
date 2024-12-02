import 'package:meta/meta.dart';

@immutable
abstract class DbPemilihCrudEvent {}


class UpdateDbPemilihCrudUpdateSikap_Caw extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String sikap_Caw;
  UpdateDbPemilihCrudUpdateSikap_Caw(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.sikap_Caw);
}
class UpdateDbPemilihCrudUpdateStatus_Caw extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String status_Caw;
  UpdateDbPemilihCrudUpdateStatus_Caw(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.status_Caw);
}

class UpdateDbPemilihCrudUpdateSikap extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String sikap;
  UpdateDbPemilihCrudUpdateSikap(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.sikap);
}
class UpdateDbPemilihCrudUpdateStatus extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String status;
  UpdateDbPemilihCrudUpdateStatus(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.status);
}



class UpdateDbPemilihCrudUpdateKawasan_Luar extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String Kawasan_Luar;
  UpdateDbPemilihCrudUpdateKawasan_Luar(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.Kawasan_Luar);
}
class UpdateDbPemilihCrudUpdateSikapM extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String sikapM;
  UpdateDbPemilihCrudUpdateSikapM(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.sikapM);
}
class UpdateDbPemilihCrudUpdateSikapM_myjr extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String sikapM;
  UpdateDbPemilihCrudUpdateSikapM_myjr(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.sikapM);
}


class UpdateDbPemilihCrudUpdateNoTel extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String NoTel;
  UpdateDbPemilihCrudUpdateNoTel(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.NoTel);
}
class UpdateDbPemilihCrudUpdateCatatan extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String Catatan;
  UpdateDbPemilihCrudUpdateCatatan(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.Catatan);
}

class UpdateDbPemilihCrudUpdateMaklumatPenuh extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String NoTel;
  final String KodRumah;
  final String Alamat1;
  final String Alamat2;
  final String Alamat3;
  final String Alamat_Poskod;
  final String Alamat_Bandar;
  final String Alamat_Negeri;
  final String Catatan;
  UpdateDbPemilihCrudUpdateMaklumatPenuh(
    this.KodNegeri_Pemilih, 
    this.KodDm_Pemilih, 
    this.IC_Pemilih, 
    this.NoTel, 
    this.KodRumah, 
    this.Alamat1, 
    this.Alamat2, 
    this.Alamat3, 
    this.Alamat_Poskod, 
    this.Alamat_Bandar, 
    this.Alamat_Negeri,this.Catatan);
}


class UpdateDbPemilihCrudUpdateHB1 extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String hb1;
  UpdateDbPemilihCrudUpdateHB1(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.hb1);
}
class UpdateDbPemilihCrudUpdateHB2 extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String hb2;
  UpdateDbPemilihCrudUpdateHB2(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.hb2);
}

class UpdateDbPemilihCrudUpdateHadir extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String KodTMQuery;
  
  final String IC_Pemilih;
  final String hadir;
  UpdateDbPemilihCrudUpdateHadir(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.KodTMQuery, this.IC_Pemilih, this.hadir);
}
class UpdateDbPemilihCrudUpdateHadir2 extends DbPemilihCrudEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String hadir2;
  UpdateDbPemilihCrudUpdateHadir2(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.hadir2);
}