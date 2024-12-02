class DbCategoryCls {
  //b1---------Parameter Key
  late String _module;
  late String _CategoryId;
  late String _Category;
  late String _Category_Papar;
  late String _sort;
  late String _categoriBankisuCount;
  late String _categoriBankisu1Count;
  late String _categoriBankisuUserNCount;
  late String _categoriInfografikCount;
  late String _categoriInfografik1Count;
  late String _categoriInfografikUserNCount;
  late String _categoriIsu1Count;
  late String _categoriIsu4Count;
  late String _categoriIsuCount;

  late String _categoriAktiviti1Count;
  late String _categoriAktiviti2Count;
  late String _categoriAktivitiCount;
  late String _categoriAktivitiUserNCount;
  late String _categoriVideoCount;
  late String _categoriVideoUserNCount;
  //b1'-------------------------------------------------------

  //b2---------Constructor
  DbCategoryCls(
    this._module,
    this._CategoryId,
    this._Category,
    this._Category_Papar,
    this._sort,
    this._categoriBankisuCount,
    this._categoriBankisu1Count,
    this._categoriBankisuUserNCount,
    this._categoriInfografikCount,
    this._categoriInfografik1Count,
    this._categoriInfografikUserNCount,
    this._categoriIsu1Count,
    this._categoriIsu4Count,
    this._categoriIsuCount,
    this._categoriAktiviti1Count,
    this._categoriAktiviti2Count,
    this._categoriAktivitiCount,
    this._categoriAktivitiUserNCount,
    this._categoriVideoCount,
    this._categoriVideoUserNCount,
  );
  //b2'-------------------------------------------------------

  //b3---------Getter
  String get module => _module;
  String get CategoryId => _CategoryId;
  String get Category => _Category;
  String get Category_Papar => _Category_Papar;
  String get sort => _sort;
  String get categoriBankisuCount => _categoriBankisuCount;
  String get categoriBankisu1Count => _categoriBankisu1Count;
  String get categoriBankisuUserNCount => _categoriBankisuUserNCount;
  String get categoriInfografikCount => _categoriInfografikCount;
  String get categoriInfografik1Count => _categoriInfografik1Count;
  String get categoriInfografikUserNCount => _categoriInfografikUserNCount;
  String get categoriIsu1Count => _categoriIsu1Count;
  String get categoriIsu4Count => _categoriIsu4Count;
  String get categoriIsuCount => _categoriIsuCount;
  String get categoriAktiviti1Count => _categoriAktiviti1Count;
  String get categoriAktiviti2Count => _categoriAktiviti2Count;
  String get categoriAktivitiCount => _categoriAktivitiCount;
  String get categoriAktivitiUserNCount => _categoriAktivitiUserNCount;
  String get categoriVideoCount => _categoriVideoCount;
  String get categoriVideoUserNCount => _categoriVideoUserNCount;
  //b3'-------------------------------------------------------

  //b4---------Setter
  set module(String newmodule) => this._module = newmodule;
  set CategoryId(String newCategoryId) => this._CategoryId = newCategoryId;
  set Category(String newCategory) => this._Category = newCategory;
  set Category_Papar(String newCategory_Papar) => this._Category_Papar = newCategory_Papar;
  set sort(String newsort) => this._sort = newsort;
  set categoriBankisuCount(String newcategoriBankisuCount) => this._categoriBankisuCount = newcategoriBankisuCount;
  set categoriBankisu1Count(String newcategoriBankisu1Count) => this._categoriBankisu1Count = newcategoriBankisu1Count;
  set categoriBankisuUserNCount(String newcategoriBankisuUserNCount) => this._categoriBankisuUserNCount = newcategoriBankisuUserNCount;
  set categoriInfografikCount(String newcategoriInfografikCount) => this._categoriInfografikCount = newcategoriInfografikCount;
  set categoriInfografik1Count(String newcategoriInfografik1Count) => this._categoriInfografik1Count = newcategoriInfografik1Count;
  set categoriInfografikUserNCount(String newcategoriInfografikUserNCount) => this._categoriInfografikUserNCount = newcategoriInfografikUserNCount;
  set categoriIsu1Count(String newcategoriIsu1Count) => this._categoriIsu1Count = newcategoriIsu1Count;
  set categoriIsu4Count(String newcategoriIsu4Count) => this._categoriIsu4Count = newcategoriIsu4Count;
  set categoriIsuCount(String newcategoriIsuCount) => this._categoriIsuCount = newcategoriIsuCount;
  set categoriAktiviti1Count(String newcategoriAktiviti1Count) => this._categoriAktiviti1Count = newcategoriAktiviti1Count;
  set categoriAktiviti2Count(String newcategoriAktiviti2Count) => this._categoriAktiviti2Count = newcategoriAktiviti2Count;
  set categoriAktivitiCount(String newcategoriAktivitiCount) => this._categoriAktivitiCount = newcategoriAktivitiCount;
  set categoriAktivitiUserNCount(String newcategoriAktivitiUserNCount) => this._categoriAktivitiUserNCount = newcategoriAktivitiUserNCount;
  set categoriVideoCount(String newcategoriVideoCount) => this._categoriVideoCount = newcategoriVideoCount;
  set categoriVideoUserNCount(String newcategoriVideoUserNCount) => this._categoriVideoUserNCount = newcategoriVideoUserNCount;
  //b4'-------------------------------------------------------

  //b5---------Map Object to RS Object
  DbCategoryCls.fromJson(Map<String, dynamic> rs) {
    this._module = rs['Module'] ?? "";
    this._CategoryId = rs['id'].toString() ?? "";
    this._Category = rs['Category'] ?? "";
    this._Category_Papar = rs['Kategori_Papar'] ?? "";
    this._sort = rs['Sort'].toString() ?? "";
    this._categoriBankisuCount = rs['KategoriBankisuCount'].toString() ?? "";
    this._categoriBankisu1Count = rs['KategoriBankisu1Count'].toString() ?? "";
    this._categoriBankisuUserNCount = rs['KategoriBankisuUserNCount'].toString() ?? "";
    this._categoriInfografikCount = rs['KategoriInfografikCount'].toString() ?? "";
    this._categoriInfografik1Count = rs['KategoriInfografik1Count'].toString() ?? "";
    this._categoriInfografikUserNCount = rs['KategoriInfografikUserNCount'].toString() ?? "";
    this._categoriIsu1Count = rs['KategoriIsu1Count'].toString() ?? "";
    this._categoriIsu4Count = rs['KategoriIsu4Count'].toString() ?? "";
    this._categoriIsuCount = rs['KategoriIsuCount'].toString() ?? "";
    this._categoriAktiviti1Count = rs['KategoriAktiviti1Count'].toString() ?? "";
    this._categoriAktiviti2Count = rs['KategoriAktiviti2Count'].toString() ?? "";
    this._categoriAktivitiCount = rs['KategoriAktivitiCount'].toString() ?? "";
    this._categoriAktivitiUserNCount = rs['KategoriAktivitiUserNCount'].toString() ?? "";
    this._categoriVideoCount = rs['KategoriVideoCount'].toString() ?? "";
    this._categoriVideoUserNCount = rs['KategoriVideoUserNCount'].toString() ?? "";
  }

  
  //b5'------------------------------------------------------
}
