import 'package:meta/meta.dart';

@immutable
abstract class DbPenggunaLogEvent {}

class GetDbPenggunaLog_ByPengundi extends DbPenggunaLogEvent {
  final String IC_Pengguna;
  final String IC_Pengundi;

  GetDbPenggunaLog_ByPengundi(this.IC_Pengguna, this.IC_Pengundi);
}
class GetDbPenggunaLog_ByPeringkat extends DbPenggunaLogEvent {
  final String IC_Pengguna;
  final String IC_Pengundi;

  GetDbPenggunaLog_ByPeringkat(this.IC_Pengguna, this.IC_Pengundi);
}

class GetDbPenggunaLog_ByPeringkat_Daftar extends DbPenggunaLogEvent {
  final String IC_Pengguna;
  final String IC_Pengundi;

  GetDbPenggunaLog_ByPeringkat_Daftar(this.IC_Pengguna, this.IC_Pengundi);
}


class GetDbPenggunaLog_ByPeringkat_Pelaporan extends DbPenggunaLogEvent {
  final String IC_Pengguna;
  final String IC_Pengundi;

  GetDbPenggunaLog_ByPeringkat_Pelaporan(this.IC_Pengguna, this.IC_Pengundi);
}