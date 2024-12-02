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
  //----
  GetDbKawasanSuccess({required this.listDbKawasan
      //----
      //----
      });
}
//---------------