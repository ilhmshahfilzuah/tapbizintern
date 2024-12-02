class TapBizUIContentModel {
  //b1---------Parameter Key
  late String _id;
  late String _UITitle;
  late String _UIBody;
  late String _UIimageURL;
  late String _UIimageOpacity;
  late String _UIColorBg1;
  late String _UIColorBg2;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  TapBizUIContentModel(
      this._id,
      this._UITitle,
      this._UIBody,
      this._UIimageURL,
      this._UIimageOpacity,
      this._UIColorBg1,
      this._UIColorBg2
      );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get UITitle	 => _UITitle;
  String get UIBody	 => _UIBody;
  String get UIimageURL	 => _UIimageURL;
  String get UIimageOpacity	 => _UIimageOpacity;
  String get UIColorBg1	 => _UIColorBg1;
  String get UIColorBg2	 => _UIColorBg2;
  
  //b3'-------------------------------------------------------
  //b4---------Setter
  set id(String new_id) => this._id = new_id;
  set UITitle(String newUITitle) => this._UITitle = newUITitle;
  set UIBody(String newUIBody) => this._UIBody = newUIBody;
  set UIimageURL(String newUIimageURL) => this._UIimageURL = newUIimageURL;
  set UIimageOpacity(String newUIimageOpacity) => this._UIimageOpacity = newUIimageOpacity;
  set UIColorBg1(String newUIColorBg1) => this._UIColorBg1 = newUIColorBg1;
  set UIColorBg2(String newUIColorBg2) => this._UIColorBg2 = newUIColorBg2;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  TapBizUIContentModel.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._UITitle = rs['UITitle'] ?? "";
    this._UIBody = rs['UIBody'] ?? "";
    this._UIimageURL = rs['UIimageURL'] ?? "";
    this._UIimageOpacity = rs['UIimageOpacity'] ?? "";
    this._UIColorBg1 = rs['UIColorBg1'] ?? "";
    this._UIColorBg2 = rs['UIColorBg2'] ?? "";
    //
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
