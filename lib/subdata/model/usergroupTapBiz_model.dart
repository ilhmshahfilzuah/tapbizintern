
class UserGroupTapBizModel {
  //b1---------Parameter Key
  late String _id;
  late String _GroupName;
  late int _TotalUser;
  late String _GroupCategory;
  late String _GroupActivationCode;
  late String _GroupCategoryid;
  late String _User_IC;
  late String _User_Birthday;
  late String _User_Headline;


  late String _User_Title;
  late String _User_Dept;
  late String _User_Company;
  late String _User_Email;
  late String _User_NoTel;
  late String _User_WS;
  late String _User_Telegram;

  late String _User_X;
  late String _User_FB;
  late String _User_Instagram;
  late String _User_TikTok;
  late String _User_YouTube;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  UserGroupTapBizModel(
      this._id,
      this._GroupName,
      this._TotalUser,
      this._GroupCategory,
      this._GroupActivationCode,
      this._GroupCategoryid,
      this._User_IC,
      this._User_Birthday,
      this._User_Headline,

      this._User_Title,
      this._User_Dept,
      this._User_Company,
      this._User_Email,
      this._User_NoTel,
      this._User_WS,

      this._User_Telegram,
      this._User_X,
      this._User_FB,
      this._User_Instagram,
      this._User_TikTok,
      this._User_YouTube
      );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get GroupName	 => _GroupName;
  int get TotalUser	 => _TotalUser;
  String get GroupCategory	 => _GroupCategory;
  String get GroupActivationCode	 => _GroupActivationCode;
  String get GroupCategoryid	 => _GroupCategoryid;
  String get User_IC	 => _User_IC;
  String get User_Birthday	 => _User_Birthday;
  String get User_Headline	 => _User_Headline;
  String get User_Title	 => _User_Title;
  String get User_Dept	 => _User_Dept;
  String get User_Company	 => _User_Company;
  String get User_Email	 => _User_Email;
  String get User_NoTel	 => _User_NoTel;
  String get User_WS	 => _User_WS;
  String get User_Telegram	 => _User_Telegram;
  String get User_X	 => _User_X;
  String get User_FB	 => _User_FB;
  String get User_Instagram	 => _User_Instagram;
  String get User_TikTok	 => _User_TikTok;
  String get User_YouTube	 => _User_YouTube;
  

  //b3'-------------------------------------------------------
  //b4---------Setter
  set id(String new_id) => this._id = new_id;
  set GroupName(String newGroupName) => this._GroupName = newGroupName	;
  set TotalUser(int newTotalUser) => this._TotalUser = newTotalUser	;
  set GroupCategory(String newGroupCategory) => this._GroupCategory = newGroupCategory	;
  set GroupActivationCode(String newGroupActivationCode) => this._GroupActivationCode = newGroupActivationCode	;
  set GroupCategoryid(String newGroupCategoryid) => this._GroupCategoryid = newGroupCategoryid	;
  set User_IC(String newUser_IC) => this._User_IC = newUser_IC	;
  set User_Birthday(String newUser_Birthday) => this._User_Birthday = newUser_Birthday	;
  set User_Headline(String newUser_Headline) => this._User_Headline = newUser_Headline	;
  set User_Title(String newUser_Title) => this._User_Title = newUser_Title	;
  set User_Dept(String newUser_Dept) => this._User_Dept = newUser_Dept	;
  set User_Company(String newUser_Company) => this._User_Company = newUser_Company	;
  set User_Email(String newUser_Email) => this._User_Email;
  set User_NoTel(String newUser_NoTel) => this._User_NoTel;
  set User_WS(String newUser_WS) => this._User_WS;
  set User_Telegram(String newUser_Telegram) => this._User_Telegram;
  set User_X(String newUser_X) => this._User_X;
  set User_FB(String newUser_FB) => this._User_FB;
  set User_Instagram(String newUser_Instagram) => this._User_Instagram;
  set User_TikTok(String newUser_TikTok) => this._User_TikTok;
  set User_YouTube(String newUser_YouTube) => this._User_YouTube;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  UserGroupTapBizModel.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._GroupName = rs['GroupName'] ?? "";
    this._TotalUser = rs['TotalUser'] ?? 0;
    this._GroupCategory = rs['GroupCategory'] ?? "";
    this._GroupActivationCode = rs['GroupActivationCode'] ?? "";
    this._GroupCategoryid = rs['GroupCategoryid'].toString() ?? "";
    this._User_IC = rs['User_IC'] ?? "";
    this._User_Birthday = rs['User_Birthday'] ?? "";
    this._User_Headline = rs['User_Headline'] ?? "";
    this._User_Title = rs['User_Title'] ?? "";
    this._User_Dept = rs['User_Dept'] ?? "";
    this._User_Company = rs['User_Company'] ?? "";
    this._User_Email = rs['User_Email'] ?? "";
    this._User_NoTel = rs['User_NoTel'] ?? "";
    this._User_WS = rs['User_WS'] ?? "";
    this._User_Telegram = rs['User_Telegram'] ?? "";
    this._User_X = rs['User_X'] ?? "";
    this._User_FB = rs['User_FB'] ?? "";
    this._User_Instagram = rs['User_Instagram'] ?? "";
    this._User_TikTok = rs['User_TikTok'] ?? "";
    this._User_YouTube = rs['User_YouTube'] ?? "";
    //
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
