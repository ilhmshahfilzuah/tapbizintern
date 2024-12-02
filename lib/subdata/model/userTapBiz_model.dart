
class UserTapBizModel {
  //b1---------Parameter Key
  late String _id;
  late String _Userid;
  late String _Groupid;
  late String _Groupname;
  
  late String _NFCTAGid ;
  late String _uuid;
  late String _Flagdel;
  late String _CardAuth;
  late String _CardData;
  late int _CardProfilePermission;
  late String _CardProfile;
  late String _CardType;
  late String _ProfileName;
  late String _Username;
  late String _UsernameQR;
  late String _themeURL;
  late String _imageURL;

  late String _themeCustomURL;
  late String _pdfURL;
  late int _User_Theme;

  
  
  late String _Source;
  late String _logTimestamp;
  
  late String _User_Email;
  
  late String _User_Name;
  late String _User_Title;
  late String _User_Dept;
  late String _User_Company;
  late String _User_Headline;

  late String _User_NoTel;
  late String _User_NoTel2;
  late String _User_NoTelOffice;
  late String _User_WS;
  late String _User_Telegram;

  late String _User_Mail;
  late String _User_Emergency_Contact;

  late String _User_FB;
  late String _User_Instagram;
  late String _User_X;
  late String _User_TikTok;
  late String _User_YouTube;

  late int _UserCounter_SaveContact;
  late int _UserCounter_View;
  late String _UserUMNO_KP;
  late String _UserUMNO_Bahagian;
  late String _UserUMNO_Negeri;
  late String _UserUMNO_NoAhli;
  late String _UserUMNO_AhliSejak;

  late String _UserTapID_Category;
  late String _UserTapID_IC;
  late String _UserTapID_Passport;
  late String _UserTapID_Work_Permit_No;
  late String _UserTapID_Country_Of_Origin;
  late String _UserTapID_Department;
  late String _UserTapID_Company;
  late String _UserTapID_Employee_id;
  late String _UserTapID_Contact;
  late String _UserTapID_Emergency_Contact;
  late String _UserTapID_Blood_Type;
  late String _UserTapID_Allergies;
  late String _UserTapID_Medical_Records;
  late String _UserTapID_Critical_Illness;
  late String _UserTapID_Status_Card;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  UserTapBizModel(
      this._id,
      this._Userid,
      this._Groupid,
      this._Groupname,
      this._NFCTAGid ,
      this._uuid,
      this._Flagdel,
      this._CardAuth,
      this._CardData,
      this._CardProfilePermission,
      this._CardProfile,
      this._CardType,
      this._ProfileName,
      this._Username,
      this._UsernameQR,
      this._themeURL,
      this._imageURL,

      this._themeCustomURL,
      this._pdfURL,
      this._User_Theme,

      this._Source,
      this._logTimestamp,
      

      this._User_Email,

      this._User_Name,
      this._User_Title,
      this._User_Dept,
      this._User_Company,
      this._User_Headline,
      
      this._User_NoTel,
      this._User_NoTel2,
      this._User_NoTelOffice,
      this._User_WS,
      this._User_Telegram,

      this._User_Mail,
      this._User_Emergency_Contact,

      this._User_FB,
      this._User_Instagram,
      this._User_X,
      this._User_TikTok,
      this._User_YouTube,

      this._UserCounter_SaveContact,
      this._UserCounter_View,
      this._UserUMNO_KP,
      this._UserUMNO_Bahagian,
      this._UserUMNO_Negeri,
      this._UserUMNO_NoAhli,
      this._UserUMNO_AhliSejak,
      
      this._UserTapID_Category,
      this._UserTapID_IC,
      this._UserTapID_Passport,
      this._UserTapID_Work_Permit_No,
      this._UserTapID_Country_Of_Origin,
      this._UserTapID_Department,
      this._UserTapID_Company,
      this._UserTapID_Employee_id,
      this._UserTapID_Contact,
      this._UserTapID_Emergency_Contact,
      this._UserTapID_Blood_Type,
      this._UserTapID_Allergies,
      this._UserTapID_Medical_Records,
      this._UserTapID_Critical_Illness,
      this._UserTapID_Status_Card


      );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get Userid => _Userid;
  String get Groupid => _Groupid;
  String get Groupname => _Groupname;
  String get NFCTAGid 	 => _NFCTAGid ;
  String get uuid	 => _uuid;
  String get Flagdel	 => _Flagdel;
  String get CardAuth	 => _CardAuth;
  String get CardData	 => _CardData;
  int get CardProfilePermission	 => _CardProfilePermission;
  String get CardProfile	 => _CardProfile;
  String get CardType	 => _CardType;
  String get ProfileName	 => _ProfileName;
  String get Username	 => _Username;
  String get UsernameQR	 => _UsernameQR;
  String get themeURL	 => _themeURL;
  String get imageURL	 => _imageURL;

  String get themeCustomURL	 => _themeCustomURL;
  String get pdfURL	 => _pdfURL;
  int get User_Theme	 => _User_Theme;
  
  String get Source	 => _Source;
  String get logTimestamp	 => _logTimestamp;
  
  String get User_Email	 => _User_Email;

  String get User_Name	 => _User_Name;
  String get User_Title	 => _User_Title;
  String get User_Dept	 => _User_Dept;
  String get User_Company	 => _User_Company;
  String get User_Headline	 => _User_Headline;

  String get User_NoTel	 => _User_NoTel;
  String get User_NoTel2	 => _User_NoTel2;
  String get User_NoTelOffice	 => _User_NoTelOffice;
  String get User_WS	 => _User_WS;
  String get User_Telegram	 => _User_Telegram;

  String get User_Mail	 => _User_Mail;
  String get User_Emergency_Contact	 => _User_Emergency_Contact;

  String get User_FB	 => _User_FB;
  String get User_Instagram	 => _User_Instagram;
  String get User_X	 => _User_X;
  String get User_TikTok	 => _User_TikTok;
  String get User_YouTube	 => _User_YouTube;

  int get UserCounter_SaveContact => _UserCounter_SaveContact;
  int get UserCounter_View => _UserCounter_View;
  String get UserUMNO_KP => _UserUMNO_KP;
  String get UserUMNO_Bahagian => _UserUMNO_Bahagian;
  String get UserUMNO_Negeri => _UserUMNO_Negeri;
  String get UserUMNO_NoAhli => _UserUMNO_NoAhli;
  String get UserUMNO_AhliSejak => _UserUMNO_AhliSejak;

  String get UserTapID_Category => _UserTapID_Category;
  String get UserTapID_IC => _UserTapID_IC;
  String get UserTapID_Passport => _UserTapID_Passport;
  String get UserTapID_Work_Permit_No => _UserTapID_Work_Permit_No;
  String get UserTapID_Country_Of_Origin => _UserTapID_Country_Of_Origin;
  String get UserTapID_Department => _UserTapID_Department;
  String get UserTapID_Company => _UserTapID_Company;
  String get UserTapID_Employee_id => _UserTapID_Employee_id;
  String get UserTapID_Contact => _UserTapID_Contact;
  String get UserTapID_Emergency_Contact => _UserTapID_Emergency_Contact;
  String get UserTapID_Blood_Type => _UserTapID_Blood_Type;
  String get UserTapID_Allergies => _UserTapID_Allergies;
  String get UserTapID_Medical_Records => _UserTapID_Medical_Records;
  String get UserTapID_Critical_Illness => _UserTapID_Critical_Illness;
  String get UserTapID_Status_Card => _UserTapID_Status_Card;
  

  //b3'-------------------------------------------------------
  //b4---------Setter
  set id(String new_id) => this._id = new_id;
  set Userid(String new_Userid) => this._Userid = new_Userid;
  set Groupid(String new_Groupid) => this._Groupid = new_Groupid;
  set Groupname(String new_Groupname) => this._Groupname = new_Groupname;
  set NFCTAGid (String newNFCTAGid ) => this._NFCTAGid  = newNFCTAGid ;
  set uuid(String newuuid) => this._uuid = newuuid;
  set Flagdel(String newFlagdel) => this._Flagdel = newFlagdel;
  set CardAuth(String newCardAuth) => this._CardAuth = newCardAuth;
  set CardData(String newCardData) => this._CardData = newCardData;
  set CardProfilePermission(int newCardProfilePermission) => this._CardProfilePermission = newCardProfilePermission;
  set CardProfile(String newCardProfile) => this._CardProfile = newCardProfile;
  set CardType(String newCardType) => this._CardType = newCardType;
  set ProfileName(String newProfileName) => this._ProfileName = newProfileName;
  set Username(String newUsername) => this._Username = newUsername;
  set UsernameQR(String newUsernameQR) => this._UsernameQR = newUsernameQR;
  set themeURL(String newthemeURL) => this._themeURL = newthemeURL;
  set imageURL(String newimageURL) => this._imageURL = newimageURL;

  set themeCustomURL(String newthemeCustomURL) => this._themeCustomURL = newthemeCustomURL;
  set pdfURL(String newpdfURL) => this._pdfURL = newpdfURL;
  set User_Theme(int newUser_Theme) => this._User_Theme = newUser_Theme;

  
  set Source(String newSource) => this._Source = newSource;
  set logTimestamp(String newlogTimestamp) => this._logTimestamp = newlogTimestamp;
  
  set User_Email(String newUser_Email) => this._User_Email;
  
  set User_Name(String newUser_Name) => this._User_Name = newUser_Name;
  set User_Title(String newUser_Title) => this._User_Title = newUser_Title;
  set User_Dept(String newUser_Dept) => this._User_Dept = newUser_Dept;
  set User_Company(String newUser_Company) => this._User_Company = newUser_Company;
  set User_Headline(String newUser_Headline) => this._User_Headline = newUser_Headline;

  set User_NoTel(String newUser_NoTel) => this._User_NoTel;
  set User_NoTel2(String newUser_NoTel2) => this._User_NoTel2;
  set User_NoTelOffice(String newUser_NoTelOffice) => this._User_NoTelOffice;
  set User_WS(String newUser_WS) => this._User_WS;
  set User_Telegram(String newUser_Telegram) => this._User_Telegram;

  set User_Mail(String newUser_Mail) => this._User_Mail;
  set User_Emergency_Contact(String newUser_Emergency_Contact) => this._User_Emergency_Contact;

  set User_FB(String newUser_FB) => this._User_FB;
  set User_Instagram(String newUser_Instagram) => this._User_Instagram;
  set User_X(String newUser_X) => this._User_X;
  set User_TikTok(String newUser_TikTok) => this._User_TikTok;
  set User_YouTube(String newUser_YouTube) => this._User_YouTube;

  set UserCounter_SaveContact(int newUserCounter_SaveContact) => this._UserCounter_SaveContact = newUserCounter_SaveContact;
  set UserCounter_View(int newUserCounter_View) => this._UserCounter_View = newUserCounter_View;
  set UserUMNO_KP(String newUserUMNO_KP) => this._UserUMNO_KP = newUserUMNO_KP;
  set UserUMNO_Bahagian(String newUserUMNO_Bahagian) => this._UserUMNO_Bahagian = newUserUMNO_Bahagian;
  set UserUMNO_Negeri(String newUserUMNO_Negeri) => this._UserUMNO_Negeri = newUserUMNO_Negeri;
  set UserUMNO_NoAhli(String newUserUMNO_NoAhli) => this._UserUMNO_NoAhli = newUserUMNO_NoAhli;
  set UserUMNO_AhliSejak(String newUserUMNO_AhliSejak) => this._UserUMNO_AhliSejak = newUserUMNO_AhliSejak;

  set UserTapID_Category	(String newUserTapID_Category	) => this._UserTapID_Category = newUserTapID_Category;
  set UserTapID_IC	(String newUserTapID_IC	) => this._UserTapID_IC = newUserTapID_IC;
  set UserTapID_Passport	(String newUserTapID_Passport	) => this._UserTapID_Passport = newUserTapID_Passport;
  set UserTapID_Work_Permit_No	(String newUserTapID_Work_Permit_No	) => this._UserTapID_Work_Permit_No = newUserTapID_Work_Permit_No;
  set UserTapID_Country_Of_Origin	(String newUserTapID_Country_Of_Origin	) => this._UserTapID_Country_Of_Origin = newUserTapID_Country_Of_Origin;
  set UserTapID_Department	(String newUserTapID_Department	) => this._UserTapID_Department = newUserTapID_Department;
  set UserTapID_Company	(String newUserTapID_Company	) => this._UserTapID_Company = newUserTapID_Company;
  set UserTapID_Employee_id	(String newUserTapID_Employee_id	) => this._UserTapID_Employee_id = newUserTapID_Employee_id;
  set UserTapID_Contact	(String newUserTapID_Contact	) => this._UserTapID_Contact = newUserTapID_Contact;
  set UserTapID_Emergency_Contact	(String newUserTapID_Emergency_Contact	) => this._UserTapID_Emergency_Contact = newUserTapID_Emergency_Contact;
  set UserTapID_Blood_Type	(String newUserTapID_Blood_Type	) => this._UserTapID_Blood_Type = newUserTapID_Blood_Type;
  set UserTapID_Allergies	(String newUserTapID_Allergies	) => this._UserTapID_Allergies = newUserTapID_Allergies;
  set UserTapID_Medical_Records	(String newUserTapID_Medical_Records	) => this._UserTapID_Medical_Records = newUserTapID_Medical_Records;
  set UserTapID_Critical_Illness	(String newUserTapID_Critical_Illness	) => this._UserTapID_Critical_Illness = newUserTapID_Critical_Illness;
  set UserTapID_Status_Card	(String newUserTapID_Status_Card	) => this._UserTapID_Status_Card = newUserTapID_Status_Card;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  UserTapBizModel.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._Userid = rs['Userid'].toString();
    this._Groupid = rs['Groupid'].toString();
    this._Groupname = rs['Groupname'] ?? "";
    this._NFCTAGid  = rs['NFCTAGid'] ?? "-";
    this._uuid = rs['uuid'] ?? "";
    this._Flagdel = rs['Flagdel'] ?? "";
    this._CardAuth = rs['CardAuth'] ?? "";
    this._CardData = rs['CardData'] ?? "main";
    this._CardProfilePermission = rs['CardProfilePermission'] ?? 2;
    this._CardProfile = rs['CardProfile'] ?? "Default";
    this._CardType = rs['CardType'] ?? "";
    this._ProfileName = rs['ProfileName'] ?? "";
    this._Username = rs['Username'] ?? "";
    this._UsernameQR = rs['UsernameQR'] ?? "";
    this._themeURL = rs['themeURL'] ?? "";
    this._imageURL = rs['imageURL'] ?? "";

    this._themeCustomURL = rs['themeCustomURL'] ?? "";
    this._pdfURL = rs['pdfURL'] ?? "";
    this._User_Theme = rs['User_Theme'] ?? 1;

    this._Source = rs['Source'] ?? "";
    this._logTimestamp = rs['logTimestamp'] ?? "";
    
    this._User_Email = rs['User_Email'] ?? "";
    
    this._User_Name = rs['User_Name'] ?? "";
    this._User_Title = rs['User_Title'] ?? "";
    this._User_Dept = rs['User_Dept'] ?? "";
    this._User_Company = rs['User_Company'] ?? "";
    this._User_Headline = rs['User_Headline'] ?? "";
    
    this._User_NoTel = rs['User_NoTel'] ?? "";
    this._User_NoTel2 = rs['User_NoTel2'] ?? "";
    this._User_NoTelOffice = rs['_User_NoTelOffice'] ?? "";
    this._User_WS = rs['User_WS'] ?? "";
    this._User_Telegram = rs['User_Telegram'] ?? "";

    this._User_Mail = rs['User_Mail'] ?? "";
    this._User_Emergency_Contact = rs['User_Emergency_Contact'] ?? "";
    
    this._User_FB = rs['User_FB'] ?? "";
    this._User_Instagram = rs['User_Instagram'] ?? "";
    this._User_X = rs['User_X'] ?? "";
    this._User_TikTok = rs['User_TikTok'] ?? "";
    this._User_YouTube = rs['User_YouTube'] ?? "";

    this._UserCounter_SaveContact	 = rs['UserCounter_SaveContact'] ?? 0;
    this._UserCounter_View	 = rs['UserCounter_View'] ?? 0;
    this._UserUMNO_KP	 = rs['UserUMNO_KP'] ?? "";
    this._UserUMNO_Bahagian	 = rs['UserUMNO_Bahagian'] ?? "";
    this._UserUMNO_Negeri	 = rs['UserUMNO_Negeri'] ?? "";
    this._UserUMNO_NoAhli	 = rs['UserUMNO_NoAhli'] ?? "";
    this._UserUMNO_AhliSejak	 = rs['UserUMNO_AhliSejak'] ?? "";

    this._UserTapID_Category = rs['UserTapID_Category'] ?? "";
    this._UserTapID_IC = rs['UserTapID_IC'] ?? "";
    this._UserTapID_Passport = rs['UserTapID_Passport'] ?? "";
    this._UserTapID_Work_Permit_No = rs['UserTapID_Work_Permit_No'] ?? "";
    this._UserTapID_Country_Of_Origin = rs['UserTapID_Country_Of_Origin'] ?? "";
    this._UserTapID_Department = rs['UserTapID_Department'] ?? "";
    this._UserTapID_Company = rs['UserTapID_Company'] ?? "";
    this._UserTapID_Employee_id = rs['UserTapID_Employee_id'] ?? "";
    this._UserTapID_Contact = rs['UserTapID_Contact'] ?? "";
    this._UserTapID_Emergency_Contact = rs['UserTapID_Emergency_Contact'] ?? "";
    this._UserTapID_Blood_Type = rs['UserTapID_Blood_Type'] ?? "";
    this._UserTapID_Allergies = rs['UserTapID_Allergies'] ?? "";
    this._UserTapID_Medical_Records = rs['UserTapID_Medical_Records'] ?? "";
    this._UserTapID_Critical_Illness = rs['UserTapID_Critical_Illness'] ?? "";
    this._UserTapID_Status_Card = rs['UserTapID_Status_Card'] ?? "";
    
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
