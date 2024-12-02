class NotifikasiLogsCls {
  //b1---------Parameter Key
  late String _user_id;  
  late String _notificationLogsId;
  late String _notificationLogs_DateDD;
  late String _notificationLogs_DateMM;
  late String _notificationLogs_DateYY;
  late String _notificationLogs_Date;
  late String _notificationLogs_Time;
  late String _notificationLogs_Title;
  late String _notificationLogs_Body;
  late String _notificationLogs_Status;
  //b1'-------------------------------------------------------

  //b2---------Constructor
  NotifikasiLogsCls(
  this._user_id,
  this._notificationLogsId,
  this._notificationLogs_DateDD,
  this._notificationLogs_DateMM,
  this._notificationLogs_DateYY,
  this._notificationLogs_Date,
  this._notificationLogs_Time,
  this._notificationLogs_Title,
  this._notificationLogs_Body,
  this._notificationLogs_Status,
  );

      
  //b2'-------------------------------------------------------

  //b3---------Getter
  String get user_id => _user_id;
  String get notificationLogsId => _notificationLogsId;
  String get notificationLogs_DateDD => _notificationLogs_DateDD;
  String get notificationLogs_DateMM => _notificationLogs_DateMM;
  String get notificationLogs_DateYY => _notificationLogs_DateYY;
  String get notificationLogs_Date => _notificationLogs_Date;
  String get notificationLogs_Time => _notificationLogs_Time;
  String get notificationLogs_Title => _notificationLogs_Title;
  String get notificationLogs_Body => _notificationLogs_Body;
  String get notificationLogs_Status => _notificationLogs_Status;




  
  //b3'-------------------------------------------------------

  //b4---------Setter
  set user_id(String newuser_id) => this._user_id = newuser_id;
  set notificationLogsId(String newnotificationLogsId) => this._notificationLogsId = newnotificationLogsId;
  set notificationLogs_DateDD(String newnotificationLogs_DateDD) => this._notificationLogs_DateDD = newnotificationLogs_DateDD;
  set notificationLogs_DateMM(String newnotificationLogs_DateMM) => this._notificationLogs_DateMM = newnotificationLogs_DateMM;
  set notificationLogs_DateYY(String newnotificationLogs_DateYY) => this._notificationLogs_DateYY = newnotificationLogs_DateYY;
  set notificationLogs_Date(String newnotificationLogs_Date) => this._notificationLogs_Date = newnotificationLogs_Date;

  set notificationLogs_Time(String newnotificationLogs_Time) => this._notificationLogs_Time = newnotificationLogs_Time;
  set notificationLogs_Title(String newnotificationLogs_Title) => this._notificationLogs_Title = newnotificationLogs_Title;
  set notificationLogs_Body(String newnotificationLogs_Body) => this._notificationLogs_Body = newnotificationLogs_Body;
  set notificationLogs_Status(String newnotificationLogs_Status) => this._notificationLogs_Status = newnotificationLogs_Status;
  //b4'-------------------------------------------------------

  //b5---------Map Object to RS Object
  NotifikasiLogsCls.fromJson(Map<String, dynamic> rs) {
    this._user_id = rs['User_id'].toString();
    this._notificationLogsId = rs['id'].toString();
    this._notificationLogs_DateDD = rs['Notifikasi_DateDD'].toString();
    this._notificationLogs_DateMM = rs['Notifikasi_DateMM'].toString();
    this._notificationLogs_DateYY = rs['Notifikasi_DateYY'].toString();
    this._notificationLogs_Date = rs['Notifikasi_Date'];
    this._notificationLogs_Time = rs['Notifikasi_Time'];
    this._notificationLogs_Title = rs['Notifikasi_Title'];
    this._notificationLogs_Body = rs['Notifikasi_Body'];
    this._notificationLogs_Status = rs['Notifikasi_Status'].toString();
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
