class TapBizStatusModel {
  //b1---------Parameter Key
  late String _id;
  late String _Category;
  late String _Status;
  late String _Status_Papar;
  late String _Sort;
  late String _themexxxURL;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  TapBizStatusModel(
      this._id,
      this._Category,
      this._Status,
      this._Status_Papar,
      this._Sort,
      this._themexxxURL
      );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get Category	 => _Category;
  String get Status	 => _Status;
  String get Status_Papar	 => _Status_Papar;
  String get Sort	 => _Sort;
  String get themexxxURL	 => _themexxxURL;
  
  //b3'-------------------------------------------------------
  //b4---------Setter
  set id(String new_id) => this._id = new_id;
  set Category(String newCategory) => this._Category = newCategory;
  set Status(String newStatus) => this._Status = newStatus;
  set Status_Papar(String newStatus_Papar) => this._Status_Papar = newStatus_Papar;
  set Sort(String newSort) => this._Sort = newSort;
  set themexxxURL(String newthemexxxURL) => this._themexxxURL = newthemexxxURL;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  TapBizStatusModel.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._Category = rs['Category'] ?? "";
    this._Status = rs['Status'] ?? "";
    this._Status_Papar = rs['Status_Papar'] ?? "";
    this._Sort = rs['Sort'] ?? "";
    this._themexxxURL = rs['themexxxURL'] ?? "";
    //
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
