import 'package:meta/meta.dart';

@immutable
abstract class DbPemilihCrudState {}

class InitialDbPemilihCrudState extends DbPemilihCrudState {}

class GetDbPemilihCrudWaiting extends DbPemilihCrudState {}
class UpdateDbPemilihCrudWaiting extends DbPemilihCrudState {}

class GetDbPemilihCrudError extends DbPemilihCrudState {
  final String errorMessage;
  GetDbPemilihCrudError({
    required this.errorMessage,
  });
}

class UpdateDbPemilihCrudSuccess extends DbPemilihCrudState {
  //----
  UpdateDbPemilihCrudSuccess();
}
class UpdateDbPemilihCrudSuccessDone extends DbPemilihCrudState {
  //----
  UpdateDbPemilihCrudSuccessDone();
}
