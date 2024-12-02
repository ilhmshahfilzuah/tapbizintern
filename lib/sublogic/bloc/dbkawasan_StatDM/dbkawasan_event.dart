import 'package:meta/meta.dart';

@immutable
abstract class DbKawasanEvent {}

class GetDbKawasan extends DbKawasanEvent {
  final String flag;
  final String paparanQuery;
  final String paparanSubPusatQuery;
  final String paparanSubNQuery;
  final String paparanSubPQuery;
  final String paparanSubDmQuery;
  GetDbKawasan(this.flag, this.paparanQuery, this.paparanSubPusatQuery, this.paparanSubNQuery, this.paparanSubPQuery, this.paparanSubDmQuery);
}

// class GetDbKawasan_AksesKawasan extends DbKawasanEvent {
//   final String flag;
//   final String paparanQuery;
//   final String paparanSubPusatQuery;
//   final String paparanSubNQuery;
//   final String paparanSubPQuery;
//   final String paparanSubDmQuery;
//   GetDbKawasan_AksesKawasan(this.flag, this.paparanQuery, this.paparanSubPusatQuery, this.paparanSubNQuery, this.paparanSubPQuery, this.paparanSubDmQuery);
// }

// class GetDbKawasan_StatST extends DbKawasanEvent {
//   final String flag;
//   final String paparanQuery;
//   final String paparanSubPusatQuery;
//   final String paparanSubNQuery;
//   final String paparanSubPQuery;
//   final String paparanSubDmQuery;
//   GetDbKawasan_StatST(this.flag, this.paparanQuery, this.paparanSubPusatQuery, this.paparanSubNQuery, this.paparanSubPQuery, this.paparanSubDmQuery);
// }