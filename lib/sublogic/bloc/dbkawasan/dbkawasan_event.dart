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

class GetDbKawasanQuery extends DbKawasanEvent {
  final String flag;
  final String kawasanQuery;
  final String kawasanKodQuery;

  GetDbKawasanQuery(this.flag, this.kawasanQuery, this.kawasanKodQuery);
}

