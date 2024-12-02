import 'package:meta/meta.dart';

@immutable
abstract class DbNotifikasiEvent {}

class GetDbNotifikasi extends DbNotifikasiEvent {
  // final String flag;
  // final String IC_Pengguna;
  final String ID_Pengguna;
  GetDbNotifikasi(this.ID_Pengguna);
}

class UpdateDbNotifikasiStatus1 extends DbNotifikasiEvent {
  final String notificationLogsId;
  UpdateDbNotifikasiStatus1(this.notificationLogsId);
}



//-----------Fav
class GetDbNotifikasiListByFav extends DbNotifikasiEvent {
  final String flag;
  final String IC_Pengguna;
  
  GetDbNotifikasiListByFav(this.flag,this.IC_Pengguna);
}
class AddDbNotifikasiListByFav extends DbNotifikasiEvent {
  final String flag;
  final String IC_Pengguna;
  final String IC_Notifikasi;
  final String KodNegeri_Notifikasi;
  final String KodParlimen_Notifikasi;
  
  AddDbNotifikasiListByFav(this.flag,this.IC_Pengguna,this.IC_Notifikasi,this.KodNegeri_Notifikasi,this.KodParlimen_Notifikasi);
}
class RemoveDbNotifikasiListByFav extends DbNotifikasiEvent {
  final String flag;
  final String IC_Pengguna;
  final String IC_Notifikasi;
  
  RemoveDbNotifikasiListByFav(this.flag,this.IC_Pengguna,this.IC_Notifikasi);
}

//-----------Fav
