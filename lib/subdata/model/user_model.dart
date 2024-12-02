
class UserModel {
  //b1---------Parameter Key
  late String _userId;
  late String _userData;
  late String _userName;
  late String _userPassword;
  late String _userUser_Name;
  late String _userUser_Email;
  late String _userUser_NoTel;
  late String _userUser_NoTelSub;
  late String _userUser_Version;
  late String _userUser_LastLog;
  late String _userUser_Gender;

  late String _userAccess_Cat;
  late String _userAccess_CatSub;
  late String _userAccess_Status;
  late String _userAccess_Level;
  late String _userAccess_Level_Agent;
  late String _userAccess_Level_HRAdmin;

  late String _userAccess_Type;
  late String _userAccess_TypePosition;
  late String _userUser_Kod_Negeri;
  late String _userUser_Nama_Negeri;
  late String _userUser_Kod_Parlimen;
  late String _userUser_Nama_Parlimen;
  late String _userUser_Kod_Dun;
  late String _userUser_Nama_Dun;
  late String _userUser_Kod_Dm;
  late String _userUser_Nama_Dm;
  late String _userUser_Kod_Kawasan;
  late String _userUser_Kod_Keselamatan;
  late String _userUser_Kod_KeselamatanSub;
  late String _userUser_Kod_KeselamatanSubNama;
  late String _userUser_Kod_Laluan;
  late String _userUser_Kod_Laluan_Flag;

  late String _userUser_Birthday;
  late String _imageURL;
  late String _updated_at;

  late String _Account_Status;
  late String _NFC_Status;
  late String _arkibVideo;
  late String _arkibIsu;
  late String _arkibAktiviti;
  late String _log;
  late int _vidCall_Status;

  

  //b1'-------------------------------------------------------
  //b2---------Constructor
  UserModel(
      this._userId,
      this._userData,
      this._userName,
      this._userPassword,
      this._userUser_Name,
      this._userUser_Email,
      this._userUser_NoTel,
      this._userUser_NoTelSub,
      this._userUser_Version,
      this._userUser_LastLog,
      this._userUser_Gender,
      this._userAccess_Cat,
      this._userAccess_CatSub,
      this._userAccess_Status,
      this._userAccess_Level,
      this._userAccess_Level_Agent,
      this._userAccess_Level_HRAdmin,
      this._userAccess_Type,
      this._userAccess_TypePosition,
      this._userUser_Kod_Negeri,
      this._userUser_Nama_Negeri,
      this._userUser_Kod_Parlimen,
      this._userUser_Nama_Parlimen,
      this._userUser_Kod_Dun,
      this._userUser_Nama_Dun,
      this._userUser_Kod_Dm,
      this._userUser_Nama_Dm,
      this._userUser_Kod_Kawasan,
      this._userUser_Kod_Keselamatan,
      this._userUser_Kod_KeselamatanSub,
      this._userUser_Kod_KeselamatanSubNama,
      this._userUser_Kod_Laluan,
      this._userUser_Kod_Laluan_Flag,
      this._userUser_Birthday,
      this._imageURL,
      this._updated_at,
      this._Account_Status,
      this._NFC_Status,
      this._arkibVideo,
      this._arkibIsu,
      this._arkibAktiviti,
      this._log,
      this._vidCall_Status);
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get userId => _userId;
  String get userData => _userData;
  String get userName => _userName;
  String get userPassword => _userPassword;
  String get userUser_Email => _userUser_Email;
  String get userUser_Name => _userUser_Name;
  String get userUser_NoTel => _userUser_NoTel;
  String get userUser_NoTelSub => _userUser_NoTelSub;
  String get userUser_Version => _userUser_Version;
  String get userUser_LastLog => _userUser_LastLog;
  String get userUser_Gender => _userUser_Gender;

  String get userAccess_Cat => _userAccess_Cat;
  String get userAccess_CatSub => _userAccess_CatSub;
  String get userAccess_Status => _userAccess_Status;
  String get userAccess_Level => _userAccess_Level;
  String get userAccess_Level_Agent => _userAccess_Level_Agent;
  String get userAccess_Level_HRAdmin => _userAccess_Level_HRAdmin;
  String get userAccess_Type => _userAccess_Type;
  String get userAccess_TypePosition => _userAccess_TypePosition;
  String get userUser_Kod_Negeri => _userUser_Kod_Negeri;
  String get userUser_Nama_Negeri => _userUser_Nama_Negeri;
  String get userUser_Kod_Parlimen => _userUser_Kod_Parlimen;
  String get userUser_Nama_Parlimen => _userUser_Nama_Parlimen;
  String get userUser_Kod_Dun => _userUser_Kod_Dun;
  String get userUser_Nama_Dun => _userUser_Nama_Dun;
  String get userUser_Kod_Dm => _userUser_Kod_Dm;
  String get userUser_Nama_Dm => _userUser_Nama_Dm;
  String get userUser_Kod_Kawasan => _userUser_Kod_Kawasan;
  String get userUser_Kod_Keselamatan => _userUser_Kod_Keselamatan;
  String get userUser_Kod_KeselamatanSub => _userUser_Kod_KeselamatanSub;
  String get userUser_Kod_KeselamatanSubNama => _userUser_Kod_KeselamatanSubNama;
  String get userUser_Kod_Laluan => _userUser_Kod_Laluan;
  String get userUser_Kod_Laluan_Flag => _userUser_Kod_Laluan_Flag;

  String get userUser_Birthday => _userUser_Birthday;
  String get imageURL => _imageURL;
  String get updated_at => _updated_at;

  String get Account_Status => _Account_Status;
  String get NFC_Status => _NFC_Status;
  String get arkibVideo => _arkibVideo;
  String get arkibIsu => _arkibIsu;
  String get arkibAktiviti => _arkibAktiviti;
  String get log => _log;
  int get vidCall_Status => _vidCall_Status;

  //b3'-------------------------------------------------------
  //b4---------Setter
  set userId(String new_userId) => this._userId = new_userId;
  set userData(String new_userData) => this._userData = new_userData;
  set userName(String new_userName) => this._userName = new_userName;
  set userPassword(String new_userPassword) => this._userPassword = new_userPassword;
  set userUser_Email(String newuserUser_Email) => this._userUser_Email = newuserUser_Email;
  set userUser_Name(String newuserUser_Name) => this._userUser_Name = newuserUser_Name;
  set userUser_NoTel(String newuserUser_NoTel) => this._userUser_NoTel = newuserUser_NoTel;
  set userUser_NoTelSub(String newuserUser_NoTelSub) => this._userUser_NoTelSub = newuserUser_NoTelSub;
  set userUser_Version(String newuserUser_Version) => this._userUser_Version = newuserUser_Version;
  set userUser_LastLog(String newuserUser_LastLog) => this._userUser_LastLog = newuserUser_LastLog;
  set userUser_Gender(String newuserUser_Gender) => this._userUser_Gender = newuserUser_Gender;

  set userAccess_Cat(String newuserAccess_Cat) => this._userAccess_Cat = newuserAccess_Cat;
  set userAccess_CatSub(String newuserAccess_CatSub) => this._userAccess_CatSub = newuserAccess_CatSub;
  set userAccess_Status(String newuserAccess_Status) => this._userAccess_Status = newuserAccess_Status;
  set userAccess_Level(String newuserAccess_Level) => this._userAccess_Level = newuserAccess_Level;
  set userAccess_Level_Agent(String newuserAccess_Level_Agent) => this._userAccess_Level_Agent = newuserAccess_Level_Agent;
  set userAccess_Level_HRAdmin(String newuserAccess_Level_HRAdmin) => this._userAccess_Level_HRAdmin = newuserAccess_Level_HRAdmin;
  set userAccess_Type(String newuserAccess_Type) => this._userAccess_Type = newuserAccess_Type;
  set userAccess_TypePosition(String newuserAccess_TypePosition) => this._userAccess_TypePosition = newuserAccess_TypePosition;
  set userUser_Kod_Negeri(String newuserUser_Kod_Negeri) => this._userUser_Kod_Negeri = newuserUser_Kod_Negeri;
  set userUser_Nama_Negeri(String newuserUser_Nama_Negeri) => this._userUser_Nama_Negeri = newuserUser_Nama_Negeri;
  set userUser_Kod_Parlimen(String newuserUser_Kod_Parlimen) => this._userUser_Kod_Parlimen = newuserUser_Kod_Parlimen;
  set userUser_Nama_Parlimen(String newuserUser_Nama_Parlimen) => this._userUser_Nama_Parlimen = newuserUser_Nama_Parlimen;

  set userUser_Kod_Dun(String newuserUser_Kod_Dun) => this._userUser_Kod_Dun = newuserUser_Kod_Dun;
  set userUser_Nama_Dun(String newuserUser_Nama_Dun) => this._userUser_Nama_Dun = newuserUser_Nama_Dun;
  set userUser_Kod_Dm(String newuserUser_Kod_Dm) => this._userUser_Kod_Dm = newuserUser_Kod_Dm;
  set userUser_Nama_Dm(String newuserUser_Nama_Dm) => this._userUser_Nama_Dm = newuserUser_Nama_Dm;

  set userUser_Kod_Kawasan(String newuserUser_Kod_Kawasan) => this._userUser_Kod_Kawasan = newuserUser_Kod_Kawasan;
  set userUser_Kod_Keselamatan(String newuserUser_Kod_Keselamatan) => this._userUser_Kod_Keselamatan = newuserUser_Kod_Keselamatan;
  set userUser_Kod_KeselamatanSub(String newuserUser_Kod_KeselamatanSub) => this._userUser_Kod_KeselamatanSub = newuserUser_Kod_KeselamatanSub;
  set userUser_Kod_KeselamatanSubNama(String newuserUser_Kod_KeselamatanSubNama) =>
      this._userUser_Kod_KeselamatanSubNama = newuserUser_Kod_KeselamatanSubNama;
  set userUser_Kod_Laluan(String newuserUser_Kod_Laluan) => this._userUser_Kod_Laluan = newuserUser_Kod_Laluan;
  set userUser_Kod_Laluan_Flag(String newuserUser_Kod_Laluan_Flag) => this._userUser_Kod_Laluan_Flag = newuserUser_Kod_Laluan_Flag;

  set userUser_Birthday(String newuserUser_Birthday) => this._userUser_Birthday = newuserUser_Birthday;
  set imageURL(String newimageURL) => this._imageURL = newimageURL;
  set updated_at(String newupdated_at) => this._updated_at = newupdated_at;

  set Account_Status(String newAccount_Status) => this._Account_Status = newAccount_Status;
  set NFC_Status(String newNFC_Status) => this._NFC_Status = newNFC_Status;
  set arkibVideo(String newarkibVideo) => this._arkibVideo = newarkibVideo;
  set arkibIsu(String newarkibIsu) => this._arkibIsu = newarkibIsu;
  set arkibAktiviti(String newarkibAktiviti) => this._arkibAktiviti = newarkibAktiviti;
  set log(String newlog) => this._log = newlog;
  set vidCall_Status(int newvidCall_Status) => this._vidCall_Status = newvidCall_Status;

  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  UserModel.fromJson(Map<String, dynamic> rs) {
    this._userId = rs['id'].toString();
    this._userData = rs['UserData'].toString();
    this._userName = rs['Username'] ?? "";
    this._userPassword = rs['Password'] ?? "";
    
    this._userUser_Email = rs['User_Email'] ?? "";
    this._userUser_Name = rs['User_Name'] ?? "";
    this._userUser_NoTel = rs['User_NoTel'] ?? "";
    this._userUser_NoTelSub = rs['User_NoTelSub'] ?? "";
    this._userUser_Version = rs['User_Version'] ?? "";
    this._userUser_LastLog = rs['User_LastLog'] ?? "";
    this._userUser_Gender = rs['User_Gender'] ?? "";

    this._userAccess_Cat = rs['Access_Cat'].toString();
    this._userAccess_CatSub = rs['Access_CatSub'] ?? "".toString();
    this._userAccess_Status = rs['Access_Status'].toString();
    this._userAccess_Level = rs['Access_Level'] ?? "";
    this._userAccess_Level_Agent = rs['Access_Level_Agent'] ?? "";
    this._userAccess_Level_HRAdmin = rs['Access_Level_HRAdmin'] ?? "";
    this._userAccess_Type = rs['Access_Type'] ?? "";
    this._userAccess_TypePosition = rs['Access_TypePosition'] ?? "";
    this._userUser_Kod_Negeri = rs['User_Kod_Negeri'] ?? "";
    this._userUser_Nama_Negeri = rs['User_Nama_Negeri'] ?? "";
    this._userUser_Kod_Parlimen = rs['User_Kod_Parlimen'] ?? "";
    this._userUser_Nama_Parlimen = rs['User_Nama_Parlimen'] ?? "";

    this._userUser_Kod_Dun = rs['User_Kod_Dun'] ?? "";
    this._userUser_Nama_Dun = rs['User_Nama_Dun'] ?? "";
    this._userUser_Kod_Dm = rs['User_Kod_Dm'] ?? "";
    this._userUser_Nama_Dm = rs['User_Nama_Dm'] ?? "";

    this._userUser_Kod_Kawasan = rs['User_Kod_Kawasan'] ?? "";
    this._userUser_Kod_Keselamatan = rs['User_Kod_Keselamatan'] ?? "";
    this._userUser_Kod_KeselamatanSub = rs['User_Kod_KeselamatanSub'] ?? "";
    this._userUser_Kod_KeselamatanSubNama = rs['User_Kod_KeselamatanSubNama'] ?? "";
    this._userUser_Kod_Laluan = rs['User_Kod_Laluan'] ?? "";
    this._userUser_Kod_Laluan_Flag = rs['User_Kod_Laluan_Flag'].toString();

    this._userUser_Birthday = rs['User_Birthday'] ?? "";
    this._imageURL = rs['imageURL'] ?? "";
    this._updated_at = rs['updated_at'] ?? "";

    this._Account_Status = rs['Account_Status'].toString();
    this._NFC_Status = rs['NFC_Status'].toString();
    this._arkibVideo = rs['ArkibVideo'].toString();
    this._arkibIsu = rs['ArkibIsu'].toString();
    this._arkibAktiviti = rs['ArkibAktiviti'].toString();
    this._log = rs['Log'].toString();
    this._vidCall_Status = rs['VidCall_Status'] ?? 0;

    //
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
