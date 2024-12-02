class TapBizThemeBladeModel {

  



  //b1---------Parameter Key
  late String _id;
  late String _ThemeBlade;
  late String _ThemeBladeName;
  late String _themeBladeURL;
  late String _themePATH;
  late String _themexxxURL;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  TapBizThemeBladeModel(
      this._id,
      this._ThemeBlade,
      this._ThemeBladeName,
      this._themeBladeURL,
      this._themePATH,
      this._themexxxURL
      );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get ThemeBlade	 => _ThemeBlade;
  String get ThemeBladeName	 => _ThemeBladeName;
  String get themeBladeURL	 => _themeBladeURL;
  String get themePATH	 => _themePATH;
  String get themexxxURL	 => _themexxxURL;
  
  //b3'-------------------------------------------------------
  //b4---------Setter
  set id(String new_id) => this._id = new_id;
  set ThemeBlade(String newThemeBlade) => this._ThemeBlade = newThemeBlade;
  set ThemeBladeName(String newThemeBladeName) => this._ThemeBladeName = newThemeBladeName;
  set themeBladeURL(String newthemeBladeURL) => this._themeBladeURL = newthemeBladeURL;
  set themePATH(String newthemePATH) => this._themePATH = newthemePATH;
  set themexxxURL(String newthemexxxURL) => this._themexxxURL = newthemexxxURL;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  TapBizThemeBladeModel.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._ThemeBlade = rs['ThemeBlade'] ?? "";
    this._ThemeBladeName = rs['ThemeBladeName'] ?? "";
    this._themeBladeURL = rs['themeBladeURL'] ?? "";
    this._themePATH = rs['themePATH'] ?? "";
    this._themexxxURL = rs['themexxxURL'] ?? "";
    //
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
