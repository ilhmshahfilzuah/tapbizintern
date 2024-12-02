class TapBizThemeModel {
  //b1---------Parameter Key
  late String _id;
  late String _ThemeCat;
  late String _ThemeName;
  late String _themeURL;
  late String _themePATH;
  late String _ThemeType;
  late int _TotalData;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  TapBizThemeModel(
      this._id,
      this._ThemeCat,
      this._ThemeName,
      this._themeURL,
      this._themePATH,
      this._ThemeType,
      this._TotalData
      );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get ThemeCat	 => _ThemeCat;
  String get ThemeName	 => _ThemeName;
  String get themeURL	 => _themeURL;
  String get themePATH	 => _themePATH;
  String get ThemeType	 => _ThemeType;
  int get TotalData	 => _TotalData;
  
  //b3'-------------------------------------------------------
  //b4---------Setter
  set id(String new_id) => this._id = new_id;
  set ThemeCat(String newThemeCat) => this._ThemeCat = newThemeCat;
  set ThemeName(String newThemeName) => this._ThemeName = newThemeName;
  set themeURL(String newthemeURL) => this._themeURL = newthemeURL;
  set themePATH(String newthemePATH) => this._themePATH = newthemePATH;
  set ThemeType(String newThemeType) => this._ThemeType = newThemeType;
  set TotalData(int newTotalData) => this._TotalData = newTotalData;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  TapBizThemeModel.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._ThemeCat = rs['ThemeCat'] ?? "";
    this._ThemeName = rs['ThemeName'] ?? "";
    this._themeURL = rs['themeURL'] ?? "";
    this._themePATH = rs['themePATH'] ?? "";
    this._ThemeType = rs['ThemeType'] ?? "";
    this._TotalData = rs['TotalData'] ?? 0;
    //
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
