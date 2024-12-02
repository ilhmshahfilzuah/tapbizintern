part of 'kwsn_cubit.dart';

@immutable
abstract class KwsnState {}

class KwsnInitial extends KwsnState {}

class WaitingSuccess extends KwsnState{
  WaitingSuccess();
}

class SyncKawasanSuccess extends KwsnState {
  final String kodNegeri;
  final String knamaNegeri;
  final String kodParlimen;
  final String namaParlimen;
  final String kodDun;
  final String namaDun;
  final String kodDm;
  final String namaDm;
  final String kodLok;
  final String namaLok;

  final String kodNegeriQuery;
  final String namaNegeriQuery;
  final String kodParlimenQuery;
  final String namaParlimenQuery;
  final String kodDunQuery;
  final String namaDunQuery;
  final String kodDmQuery;
  final String namaDmQuery;
  final String kodLokQuery;
  final String namaLokQuery;

  final String paparanQuery;
  final String paparanSenaraiQuery;

  final String paparanSubPusatQuery;
  final String paparanSubNQuery;
  final String paparanSubPQuery;
  final String paparanSubDmQuery;
  SyncKawasanSuccess(
      this.kodNegeri,
      this.knamaNegeri,
      this.kodParlimen,
      this.namaParlimen,
      this.kodDun,
      this.namaDun,
      this.kodDm,
      this.namaDm,
      this.kodLok,
      this.namaLok,
      this.kodNegeriQuery,
      this.namaNegeriQuery,
      this.kodParlimenQuery,
      this.namaParlimenQuery,
      this.kodDunQuery,
      this.namaDunQuery,
      this.kodDmQuery,
      this.namaDmQuery,
      this.kodLokQuery,
      this.namaLokQuery,
      this.paparanQuery,
      this.paparanSenaraiQuery,
      this.paparanSubPusatQuery,
      this.paparanSubNQuery,
      this.paparanSubPQuery,this.paparanSubDmQuery);
}

// part of 'kwsn_cubit.dart';

// abstract class KwsnState extends Equatable {
//   const KwsnState();

//   @override
//   List<Object> get props => [];
// }

// class KwsnInitial extends KwsnState {}

// class SyncKawasanSuccess extends KwsnState {
//   final String kodNegeri;
//   final String knamaNegeri;
//   final String kodParlimen;
//   final String namaParlimen;
//   final String kodDun;
//   final String namaDun;
//   final String kodDm;
//   final String namaDm;
//   final String kodLok;
//   final String namaLok;

//   final String kodNegeriQuery;
//   final String namaNegeriQuery;
//   final String kodParlimenQuery;
//   final String namaParlimenQuery;
//   final String kodDunQuery;
//   final String namaDunQuery;
//   final String kodDmQuery;
//   final String namaDmQuery;
//   final String kodLokQuery;
//   final String namaLokQuery;

//   final String paparanQuery;
//   final String paparanSenaraiQuery;

//   final String paparanSubNQuery;
//   final String paparanSubPQuery;

  
//   SyncKawasanSuccess(
//       this.kodNegeri,
//       this.knamaNegeri,
//       this.kodParlimen,
//       this.namaParlimen,
//       this.kodDun,
//       this.namaDun,
//       this.kodDm,
//       this.namaDm,
//       this.kodLok,
//       this.namaLok,
//       this.kodNegeriQuery,
//       this.namaNegeriQuery,
//       this.kodParlimenQuery,
//       this.namaParlimenQuery,
//       this.kodDunQuery,
//       this.namaDunQuery,
//       this.kodDmQuery,
//       this.namaDmQuery,
//       this.kodLokQuery,
//       this.namaLokQuery,
//       this.paparanQuery,
//       this.paparanSenaraiQuery,
//       this.paparanSubNQuery,
//       this.paparanSubPQuery);
// }
