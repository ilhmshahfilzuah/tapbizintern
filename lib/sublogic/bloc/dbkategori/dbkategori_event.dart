import 'package:meta/meta.dart';

@immutable
abstract class DbKategoriEvent {}

class GetDbKategori extends DbKategoriEvent {
  final String flag;
  GetDbKategori(this.flag);
}