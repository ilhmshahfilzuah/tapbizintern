import 'package:meta/meta.dart';

@immutable
abstract class DbNotifikasiState {}

class InitialDbNotifikasiState extends DbNotifikasiState {}

class GetDbNotifikasiWaiting extends DbNotifikasiState {}

//---------------
class GetDbNotifikasiError extends DbNotifikasiState {
  final String errorMessage;
  GetDbNotifikasiError({
    required this.errorMessage,
  });
}
//---------------

//---------------
class GetDbNotifikasiSuccess extends DbNotifikasiState {
  final String UserNotifikasiLogs;
  //----
  //----
  GetDbNotifikasiSuccess({
    required this.UserNotifikasiLogs,
    //----
    //----
  });
}

class UpdateDbNotifikasiSuccess extends DbNotifikasiState {
  //----
  UpdateDbNotifikasiSuccess();
}
//---------------


