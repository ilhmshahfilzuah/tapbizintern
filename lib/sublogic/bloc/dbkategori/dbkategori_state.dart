import 'package:meta/meta.dart';

@immutable
abstract class DbKategoriState {}

class InitialDbKategoriState extends DbKategoriState {}

class GetDbKategoriWaiting extends DbKategoriState {}

//---------------
class GetDbKategoriError extends DbKategoriState {
  final String errorMessage;
  GetDbKategoriError({
    required this.errorMessage,
  });
}
//---------------

//---------------
class GetDbKategoriSuccess extends DbKategoriState {
  final String DbCategory;
  //----
  //----
  GetDbKategoriSuccess({
    required this.DbCategory,
    //----
    //----
  });
}