import 'package:meta/meta.dart';

@immutable
abstract class DbTemplateEvent {}

class GetDbTemplate extends DbTemplateEvent {
  // final String flag;
  // final String IC_Pengguna;
  final String ID_Pengguna;
  GetDbTemplate(this.ID_Pengguna);
}