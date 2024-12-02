class userLogCls {
  //b1---------Parameter Key
  late String _uId;
  late String _id;
  late String _userVersion;
  late String _userVersionPIN;
  late String _username;
  late String _userNoTel;
  late String _userid;
  late String _kodNegeri;
  late String _namaNegeri;
  late String _kodParlimen;
  late String _namaParlimen;
  late String _kodDun;
  late String _namaDun;
  late String _kodDm;
  late String _namaDm;
  late String _accessType;
  late String _activity;
  late String _activitySub;
  late String _activityCat;
  late String _activityCatData1;
  late String _activityTimestamp;
  late String _activityDD;
  late String _activityMM;
  late String _activityYY;
  late String _namaPengundi;
  late String _iCPengundi;
  late String _status;
  late String _sikap;
  late String _updatedat;
  late String _createdat;

  //b1'-------------------------------------------------------

  //b2---------Constructor
  userLogCls(
      this._uId,

      this._id,
      this._userVersion,
      this._userVersionPIN,
      this._username,
      this._userNoTel,
      this._userid,
      this._kodNegeri,
      this._namaNegeri,
      this._kodParlimen,
      this._namaParlimen,
      this._kodDun,
      this._namaDun,
      this._kodDm,
      this._namaDm,
      this._accessType,
      this._activity, 
      this._activitySub,  
      this._activityCat,
      this._activityCatData1,    
      this._activityTimestamp, 
      this._activityDD, 
      this._activityMM, 
      this._activityYY, 
      this._namaPengundi, 
      this._iCPengundi, 
      this._status, 
      this._sikap,  
      this._updatedat,
      this._createdat,     
      );
    
  //b2'-------------------------------------------------------
      // this._id,
      // this._user_name,
      // this._user_id,


      // this._updated_at,
      // this._created_at,   
  //b3---------Getter
  String get uId => _uId;
  String get id => _id;
  String get userVersion => _userVersion;
  String get userVersionPIN => _userVersionPIN;
  String get username => _username;
  String get userNoTel => _userNoTel;
  String get userid => _userid;
  String get kodNegeri => _kodNegeri;
  String get namaNegeri => _namaNegeri;
  String get kodParlimen => _kodParlimen;
  String get namaParlimen => _namaParlimen;
  String get kodDun => _kodDun;
  String get namaDun => _namaDun;
  String get kodDm => _kodDm;
  String get namaDm => _namaDm;
  String get accessType => _accessType;
  String get activity => _activity;
  String get activitySub => _activitySub;
  String get activityCat => _activityCat;
  String get activityCatData1 => _activityCatData1;
  String get activityTimestamp => _activityTimestamp;
  String get activityDD => _activityDD;
  String get activityMM => _activityMM;
  String get activityYY => _activityYY;
  String get namaPengundi => _namaPengundi;
  String get iCPengundi => _iCPengundi;
  String get status => _status;
  String get sikap => _sikap;
  String get updatedat => _updatedat;
  String get createdat => _createdat;
  //b3'-------------------------------------------------------

  //b4---------Setter
  set uId(String newuId) => this._uId = newuId;
  set id(String newid) => this._id = newid;
  set userVersion(String newuserVersion) => this._userVersion = newuserVersion;
  set userVersionPIN(String newuserVersionPIN) => this._userVersionPIN = newuserVersionPIN;
  set username(String newusername) => this._username = newusername;
  set userNoTel(String newuserNoTel) => this._userNoTel = newuserNoTel;
  set userid(String newuserid) => this._userid = newuserid;
  set kodNegeri(String newkodNegeri) => this._kodNegeri = newkodNegeri;
  set namaNegeri(String newnamaNegeri) => this._namaNegeri = newnamaNegeri;
  set kodParlimen(String newkodParlimen) => this._kodParlimen = newkodParlimen;
  set namaParlimen(String newnamaParlimen) => this._namaParlimen = newnamaParlimen;
  set kodDun(String newkodDun) => this._kodDun = newkodDun;
  set namaDun(String newnamaDun) => this._namaDun = newnamaDun;
  set kodDm(String newkodDm) => this._kodDm = newkodDm;
  set namaDm(String newnamaDm) => this._namaDm = newnamaDm;
  set accessType(String newaccessType) => this._accessType = newaccessType;
  set activity(String newactivity) => this._activity = newactivity;
  set activitySub(String newactivitySub) => this._activitySub = newactivitySub;
  set activityCat(String newactivityCat) => this._activityCat = newactivityCat;
  set activityCatData1(String newactivityCatData1) => this._activityCatData1 = newactivityCatData1;
  set activityTimestamp(String newactivityTimestamp) => this._activityTimestamp = newactivityTimestamp;
  set activityDD(String newactivityDD) => this._activityDD = newactivityDD;
  set activityMM(String newactivityMM) => this._activityMM = newactivityMM;
  set activityYY(String newactivityYY) => this._activityYY = newactivityYY;
  set namaPengundi(String newnamaPengundi) => this._namaPengundi = newnamaPengundi;
  set iCPengundi(String newiCPengundi) => this._iCPengundi = newiCPengundi;
  set status(String newstatus) => this._status = newstatus;
  set sikap(String newsikap) => this._sikap = newsikap;
  set updatedat(String newupdatedat) => this._updatedat = newupdatedat;
  set createdat(String newcreatedat) => this._createdat = newcreatedat;
  //b4'-------------------------------------------------------

  //b5---------Map Object to RS Object
  userLogCls.fromJson(Map<String, dynamic> rs) {
    this._uId = rs['uid'].toString();
    this._id = rs['id'].toString();
    this._userVersion = rs['User_Version'] ?? "";
    this._userVersionPIN = rs['User_VersionPIN'] ?? "";
    this._username = rs['User_name'] ?? "";
    this._userNoTel = rs['User_NoTel'] ?? "";
    this._userid = rs['User_id'] ?? "";
    this._kodNegeri = rs['User_Kod_Negeri'] ?? "";
    this._namaNegeri = rs['User_Nama_Negeri'] ?? "";
    this._kodParlimen = rs['User_Kod_Parlimen'] ?? "";
    this._namaParlimen = rs['User_Nama_Parlimen'] ?? "";
    this._kodDun = rs['User_Kod_Dun'] ?? "";
    this._namaDun = rs['User_Nama_Dun'] ?? "";
    this._kodDm = rs['User_Kod_Dm'] ?? "";
    this._namaDm = rs['User_Nama_Dm'] ?? "";
    this._accessType = rs['Access_Type'] ?? "";
    this._activity = rs['Activity'] ?? "";
    this._activitySub = rs['ActivitySub'] ?? "";
    this._activityCat = rs['ActivityCat'] ?? "";
    this._activityCatData1 = rs['ActivityCatData1'] ?? "";
    this._activityTimestamp = rs['Activity_Timestamp'] ?? "";
    this._activityDD = rs['Aktiviti_DateDD'] ?? "";
    this._activityMM = rs['Aktiviti_DateMM'] ?? "";
    this._activityYY = rs['Aktiviti_DateYY'] ?? "";
    this._namaPengundi = rs['NamaPengundi'] ?? "";
    this._iCPengundi = rs['ICPengundi'] ?? "";
    this._status = rs['Status'] ?? "";
    this._sikap = rs['Sikap'] ?? "";
    this._updatedat = rs['updated_at'] ?? "";
    this._createdat = rs['created_at'] ?? "";
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
