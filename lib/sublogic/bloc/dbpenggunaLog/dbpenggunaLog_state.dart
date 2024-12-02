import 'package:meta/meta.dart';

@immutable
abstract class DbPenggunaLogState {}

class InitialDbPenggunaLogState extends DbPenggunaLogState {}

class GetDbPenggunaLogWaiting extends DbPenggunaLogState {}

class GetDbPenggunaLogError extends DbPenggunaLogState {
  final String errorMessage;
  GetDbPenggunaLogError({
    required this.errorMessage,
  });
}

class GetDbPenggunaLogSuccess extends DbPenggunaLogState {
  final String listDbPenggunaLog;
  GetDbPenggunaLogSuccess({
    required this.listDbPenggunaLog,
  });
}

class GetDbPenggunaLog_Daftar_Success extends DbPenggunaLogState {
  final String listDbPenggunaLog;
  GetDbPenggunaLog_Daftar_Success({
    required this.listDbPenggunaLog,
  });
}
class GetDbPenggunaLog_Pelaporan_Success extends DbPenggunaLogState {
  final String listDbPenggunaLog;
  GetDbPenggunaLog_Pelaporan_Success({
    required this.listDbPenggunaLog,
  });
}
