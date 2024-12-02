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
  final int? JumIsuAll;
  final int? JumIsu0;
  final int? JumIsu1;
  final int? JumIsu2;
  final int? JumIsu3;
  final int? JumIsu4;
  final int? JumIsu5;
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
    this.JumIsuAll,
    this.JumIsu0,
    this.JumIsu1,
    this.JumIsu2,
    this.JumIsu3,
    this.JumIsu4,
    this.JumIsu5,
    //----
  });
}
//---------------