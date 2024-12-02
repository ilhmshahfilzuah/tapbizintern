import 'package:meta/meta.dart';

@immutable
abstract class DbKawasanSubEvent {}

class GetDbKawasanSubQuery extends DbKawasanSubEvent {
  final String flag;
  final String kawasanQuery;
  final String kawasanKodQuery;

  GetDbKawasanSubQuery(this.flag, this.kawasanQuery, this.kawasanKodQuery);
}

