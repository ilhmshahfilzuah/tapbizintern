import 'package:meta/meta.dart';

@immutable
abstract class DbPemilihEvent {}

class GetDbPemilih extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String dataFilterLokaliti;
  final String dataFilterJantina;
  final String dataFilterKaum;
  final String dataFilterUG;
  GetDbPemilih(this.flag, this.IC_Pengguna, this.dataFilterLokaliti, this.dataFilterJantina, this.dataFilterKaum, this.dataFilterUG);
}

//-----------JR Jagaaan
class GetDbPemilihListByJRJagaan extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  
  GetDbPemilihListByJRJagaan(this.flag,this.IC_Pengguna);
}
//-----------JCaw Jagaaan
class GetDbPemilihListByJCawJagaan extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  
  GetDbPemilihListByJCawJagaan(this.flag,this.IC_Pengguna);
}

//-----------Fav
class GetDbPemilihListByFav extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  
  GetDbPemilihListByFav(this.flag,this.IC_Pengguna);
}
class AddDbPemilihListByFav extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String IC_Pemilih;
  final String KodNegeri_Pemilih;
  final String KodParlimen_Pemilih;
  
  AddDbPemilihListByFav(this.flag,this.IC_Pengguna,this.IC_Pemilih,this.KodNegeri_Pemilih,this.KodParlimen_Pemilih);
}
class RemoveDbPemilihListByFav extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String IC_Pemilih;
  
  RemoveDbPemilihListByFav(this.flag,this.IC_Pengguna,this.IC_Pemilih);
}

//-----------Fav
//-----------WstL
class GetDbPemilihListByWstL1 extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  
  GetDbPemilihListByWstL1(this.flag,this.IC_Pengguna);
}
class GetDbPemilihListByWstL2 extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  
  GetDbPemilihListByWstL2(this.flag,this.IC_Pengguna);
}
class AddBlastQueDbPemilihListByWstL1 extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String Nama_Pemilih;
  final String IC_Pemilih;
  final String NoTel_Pemilih;
  final String KodNegeri_Pemilih;
  final String KodParlimen_Pemilih;
  
  AddBlastQueDbPemilihListByWstL1(this.flag,this.IC_Pengguna,this.Nama_Pemilih,this.IC_Pemilih,this.NoTel_Pemilih,this.KodNegeri_Pemilih,this.KodParlimen_Pemilih);
}

class AddBlastQueDbPemilihListByWstL2 extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String Nama_Pemilih;
  final String IC_Pemilih;
  final String NoTel_Pemilih;
  final String KodNegeri_Pemilih;
  final String KodParlimen_Pemilih;
  
  AddBlastQueDbPemilihListByWstL2(this.flag,this.IC_Pengguna,this.Nama_Pemilih,this.IC_Pemilih,this.NoTel_Pemilih,this.KodNegeri_Pemilih,this.KodParlimen_Pemilih);
}

class AddDbPemilihListByWstL extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String Nama_Pemilih;
  final String IC_Pemilih;
  final String NoTel_Pemilih;
  final String KodNegeri_Pemilih;
  final String KodParlimen_Pemilih;
  
  AddDbPemilihListByWstL(this.flag,this.IC_Pengguna,this.Nama_Pemilih,this.IC_Pemilih,this.NoTel_Pemilih,this.KodNegeri_Pemilih,this.KodParlimen_Pemilih);
}
class RemoveDbPemilihListByWstL extends DbPemilihEvent {
  final String flag;
  final String IC_Pengguna;
  final String IC_Pemilih;
  
  RemoveDbPemilihListByWstL(this.flag,this.IC_Pengguna,this.IC_Pemilih);
}

//-----------WstL





class UpdateDbPemilihUpdateSikap extends DbPemilihEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String sikap;
  UpdateDbPemilihUpdateSikap(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.sikap);
}
class UpdateDbPemilihUpdateStatus extends DbPemilihEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String status;
  UpdateDbPemilihUpdateStatus(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.status);
}
class UpdateDbPemilihUpdateSikapM extends DbPemilihEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String sikapM;
  UpdateDbPemilihUpdateSikapM(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.sikapM);
}

class UpdateDbPemilihUpdateNoTel extends DbPemilihEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String NoTel;
  UpdateDbPemilihUpdateNoTel(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.NoTel);
}
class UpdateDbPemilihUpdateCatatan extends DbPemilihEvent {
  final String KodNegeri_Pemilih;
  final String KodDm_Pemilih;
  final String IC_Pemilih;
  final String Catatan;
  UpdateDbPemilihUpdateCatatan(this.KodNegeri_Pemilih, this.KodDm_Pemilih, this.IC_Pemilih, this.Catatan);
}

class UpdateDbPemilihUpdateMaklumatPenuh extends DbPemilihEvent {
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
  UpdateDbPemilihUpdateMaklumatPenuh(
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






class GetDbPemilihCheckIC extends DbPemilihEvent {
  final String   KodDm_Pengguna;
  final String IC_Pengguna;
  final String IC_Pemilih;
  GetDbPemilihCheckIC(this.KodDm_Pengguna, this.IC_Pengguna, this.IC_Pemilih);
}





// class GetDbPemilih_AksesKawasan extends DbPemilihEvent {
//   final String flag;
//   final String paparanQuery;
//   final String paparanSubPusatQuery;
//   final String paparanSubNQuery;
//   final String paparanSubPQuery;
//   final String paparanSubDmQuery;
//   GetDbPemilih_AksesKawasan(this.flag, this.paparanQuery, this.paparanSubPusatQuery, this.paparanSubNQuery, this.paparanSubPQuery, this.paparanSubDmQuery);
// }

// class GetDbPemilih_StatST extends DbPemilihEvent {
//   final String flag;
//   final String paparanQuery;
//   final String paparanSubPusatQuery;
//   final String paparanSubNQuery;
//   final String paparanSubPQuery;
//   final String paparanSubDmQuery;
//   GetDbPemilih_StatST(this.flag, this.paparanQuery, this.paparanSubPusatQuery, this.paparanSubNQuery, this.paparanSubPQuery, this.paparanSubDmQuery);
// }