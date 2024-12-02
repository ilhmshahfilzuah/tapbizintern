import 'package:meta/meta.dart';

@immutable
abstract class DbKawasanEvent {}

class GetDbKawasan extends DbKawasanEvent {
  final String flag;
  final String paparanQuery;
  final String kodNegeriQuerySub;
  final String kodParlimenQuerySub;
  final String kodDunQuerySub;
  final String kodDmQuerySub;
  GetDbKawasan(this.flag, this.paparanQuery, this.kodNegeriQuerySub, this.kodParlimenQuerySub, this.kodDunQuerySub, this.kodDmQuerySub);
}
                                  String paparanQuery = 'Senarai Negeri';
                                  String kodNegeriQuerySub = '';
                                  String kodParlimenQuerySub = '';
                                  String kodDunQuerySub = '';
                                  String kodDmQuerySub = '';
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