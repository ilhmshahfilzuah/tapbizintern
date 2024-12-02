import 'package:flutter/widgets.dart';

class CategoryModel {
  late int id;
  late String headername;
  late String name;
  late String name2;
  late String peringkat;
  late String pinNama;
  late String pinNama2;
  late Icon icon;
  late Icon icondisable;
  late StatefulWidget route;

  CategoryModel(
      {required this.id,
      required this.headername,
      required this.name,
      required this.name2,
      required this.peringkat,
      required this.pinNama,
      required this.pinNama2,
      required this.icon,
      required this.icondisable,
      required this.route});
}
