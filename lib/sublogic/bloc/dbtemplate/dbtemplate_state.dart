import 'package:meta/meta.dart';

@immutable
abstract class DbTemplateState {}

class InitialDbTemplateState extends DbTemplateState {}

class GetDbTemplateWaiting extends DbTemplateState {}

//---------------
class GetDbTemplateError extends DbTemplateState {
  final String errorMessage;
  GetDbTemplateError({
    required this.errorMessage,
  });
}
//---------------

//---------------
class GetDbTemplateSuccess extends DbTemplateState {
  final String UserTemplateLogs;
  //----
  //----
  GetDbTemplateSuccess({
    required this.UserTemplateLogs,
    //----
    //----
  });
}