import 'dart:io';

import 'package:meta/meta.dart';

@immutable
abstract class DbDataProfilEvent {}

class GetDbDataProfil extends DbDataProfilEvent {
  final String IC_Pengguna;
  GetDbDataProfil(this.IC_Pengguna);
}

class UpdateDbDataProfil extends DbDataProfilEvent {
  final String IC_Pengguna;
  final String nedField;
  final String nedField_Data;
  final File? image;

  UpdateDbDataProfil(this.IC_Pengguna, this.nedField, this.nedField_Data,this.image,);
}

class ResetKodLaluanDbDataProfil extends DbDataProfilEvent {
  final String IC_Pengguna;
  final String nedField;
  final String nedField_Data;
  final File? image;

  ResetKodLaluanDbDataProfil(this.IC_Pengguna, this.nedField, this.nedField_Data,this.image,);
}

