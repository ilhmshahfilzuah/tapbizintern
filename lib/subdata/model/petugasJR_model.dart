class PetugasJRModelCls {
  //b1---------Parameter Key
  late String _userJRId;
  late String _userJR_Name;
  late String _userJR_IC;
  late String _userJR_NoTel;
  late String _userJR_Alamat1;
  late String _userJR_Alamat2;
  late String _userJR_Alamat3;
  late String _userJR_Poskod;
  late String _userJR_Alamat4;

  late String _userJR_Kod_Negeri;
  late String _userJR_Nama_Negeri;
  late String _userJR_Kod_Parlimen;
  late String _userJR_Nama_Parlimen;
  late String _userJR_Kod_Dun;
  late String _userJR_Nama_Dun;
  late String _userJR_Kod_Dm;
  late String _userJR_Nama_Dm;

  late String _userJR_Jagaan;
  late String _userJR_JagaanBanci;
  late String _userJR_JagaanP;
  late String _userJR_JagaanK;
  late String _userJR_JagaanH;
  late String _userJR_JagaanT;
  late String _userJR_JagaanM;
  late String _userJR_JagaanBBanci;
  late String _userJR_StatusJRAktif;
  late String _userJR_StatusJRKod_Laluan;
  late String _userJR_StatusJRKod_Laluan_Flag;
  //b1'-------------------------------------------------------
  //b2---------Constructor
  PetugasJRModelCls(    
      this._userJRId,
      this._userJR_NoTel,
      this._userJR_Alamat1,
      this._userJR_Alamat2,
      this._userJR_Alamat3,
      this._userJR_Poskod,
      this._userJR_Alamat4,

      this._userJR_Kod_Negeri,
      this._userJR_Nama_Negeri,
      this._userJR_Kod_Parlimen,
      this._userJR_Nama_Parlimen,
      this._userJR_Kod_Dun,
      this._userJR_Nama_Dun,
      this._userJR_Kod_Dm,
      this._userJR_Nama_Dm,

      this._userJR_Jagaan,
      this._userJR_JagaanBanci,
      this._userJR_JagaanP,
      this._userJR_JagaanK,
      this._userJR_JagaanH,
      this._userJR_JagaanT,
      this._userJR_JagaanM,
      this._userJR_JagaanBBanci,
      this._userJR_StatusJRAktif,
      this._userJR_StatusJRKod_Laluan,
      this._userJR_StatusJRKod_Laluan_Flag,

      );  
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get userJRId => _userJRId;
  String get userJR_IC => _userJR_IC;
  String get userJR_Name => _userJR_Name;
  String get userJR_NoTel => _userJR_NoTel;
  String get userJR_Alamat1 => _userJR_Alamat1;
  String get userJR_Alamat2 => _userJR_Alamat2;
  String get userJR_Alamat3 => _userJR_Alamat3;
  String get userJR_Poskod => _userJR_Poskod;
  String get userJR_Alamat4 => _userJR_Alamat4;

  String get userJR_Kod_Negeri => _userJR_Kod_Negeri;
  String get userJR_Nama_Negeri => _userJR_Nama_Negeri;
  String get userJR_Kod_Parlimen => _userJR_Kod_Parlimen;
  String get userJR_Nama_Parlimen => _userJR_Nama_Parlimen;
  String get userJR_Kod_Dun => _userJR_Kod_Dun;
  String get userJR_Nama_Dun => _userJR_Nama_Dun;
  String get userJR_Kod_Dm => _userJR_Kod_Dm;
  String get userJR_Nama_Dm => _userJR_Nama_Dm;

  String get userJR_Jagaan => _userJR_Jagaan;
  String get userJR_JagaanBanci => _userJR_JagaanBanci;
  String get userJR_JagaanP => _userJR_JagaanP;
  String get userJR_JagaanK => _userJR_JagaanK;
  String get userJR_JagaanH => _userJR_JagaanH;
  String get userJR_JagaanT => _userJR_JagaanT;
  String get userJR_JagaanM => _userJR_JagaanM;
  String get userJR_JagaanBBanci => _userJR_JagaanBBanci;
  String get userJR_StatusJRAktif => _userJR_StatusJRAktif;
  String get userJR_StatusJRKod_Laluan => _userJR_StatusJRKod_Laluan;
  String get userJR_StatusJRKod_Laluan_Flag => _userJR_StatusJRKod_Laluan_Flag;
  //b3'-------------------------------------------------------
  //b4---------Setter
  set userJRId(String new_userJRId) => this._userJRId = new_userJRId;
  set userJR_IC(String newuserJR_IC) => this._userJR_IC = newuserJR_IC;
  set userJR_Name(String newuserJR_Name) => this._userJR_Name = newuserJR_Name;
  set userJR_NoTel(String newuserJR_NoTel) => this._userJR_NoTel = newuserJR_NoTel;
  set userJR_Alamat1(String newuserJR_Alamat1) => this._userJR_Alamat1 = newuserJR_Alamat1;
  set userJR_Alamat2(String newuserJR_Alamat2) => this._userJR_Alamat2 = newuserJR_Alamat2;
  set userJR_Alamat3(String newuserJR_Alamat3) => this._userJR_Alamat3 = newuserJR_Alamat3;
  set userJR_Poskod(String newuserJR_Poskod) => this._userJR_Poskod = newuserJR_Poskod;
  set userJR_Alamat4(String newuserJR_Alamat4) => this._userJR_Alamat4 = newuserJR_Alamat4;

  set userJR_Kod_Negeri(String newuserJR_Kod_Negeri) => this._userJR_Kod_Negeri = newuserJR_Kod_Negeri;
  set userJR_Nama_Negeri(String newuserJR_Nama_Negeri) => this._userJR_Nama_Negeri = newuserJR_Nama_Negeri;
  set userJR_Kod_Parlimen(String newuserJR_Kod_Parlimen) => this._userJR_Kod_Parlimen = newuserJR_Kod_Parlimen;
  set userJR_Nama_Parlimen(String newuserJR_Nama_Parlimen) => this._userJR_Nama_Parlimen = newuserJR_Nama_Parlimen;

  set userJR_Kod_Dun(String newuserJR_Kod_Dun) => this._userJR_Kod_Dun = newuserJR_Kod_Dun;
  set userJR_Nama_Dun(String newuserJR_Nama_Dun) => this._userJR_Nama_Dun = newuserJR_Nama_Dun;
  set userJR_Kod_Dm(String newuserJR_Kod_Dm) => this._userJR_Kod_Dm = newuserJR_Kod_Dm;
  set userJR_Nama_Dm(String newuserJR_Nama_Dm) => this._userJR_Nama_Dm = newuserJR_Nama_Dm;

  set userJR_Jagaan(String newuserJR_Jagaan) => this._userJR_Jagaan = newuserJR_Jagaan;
  set userJR_JagaanBanci(String newuserJR_JagaanBanci) => this._userJR_JagaanBanci = newuserJR_JagaanBanci;
  set userJR_JagaanP(String newuserJR_JagaanP) => this._userJR_JagaanP = newuserJR_JagaanP;
  set userJR_JagaanK(String newuserJR_JagaanK) => this._userJR_JagaanK = newuserJR_JagaanK;
  set userJR_JagaanH(String newuserJR_JagaanH) => this._userJR_JagaanH = newuserJR_JagaanH;
  set userJR_JagaanT(String newuserJR_JagaanT) => this._userJR_JagaanT = newuserJR_JagaanT;
  set userJR_JagaanM(String newuserJR_JagaanM) => this._userJR_JagaanM = newuserJR_JagaanM;
  set userJR_JagaanBBanci(String newuserJR_JagaanBBanci) => this._userJR_JagaanBBanci = newuserJR_JagaanBBanci;
  set userJR_StatusJRAktif(String newuserJR_StatusJRAktif) => this._userJR_StatusJRAktif = newuserJR_StatusJRAktif;
  set userJR_StatusJRKod_Laluan(String newuserJR_StatusJRKod_Laluan) => this._userJR_StatusJRKod_Laluan = newuserJR_StatusJRKod_Laluan;
  set userJR_StatusJRKod_Laluan_Flag(String newuserJR_StatusJRKod_Laluan_Flag) => this._userJR_StatusJRKod_Laluan_Flag = newuserJR_StatusJRKod_Laluan_Flag;
  //b4'-------------------------------------------------------
  //b5---------Map Object to RS Object
  PetugasJRModelCls.fromJson(Map<String, dynamic> rs) { 
    this._userJRId = rs['idjr'].toString();
    this._userJR_IC = rs['no_kpt'];    
    this._userJR_Name = rs['nama'];
    this._userJR_NoTel = rs['no_tel1'] ?? "";
    this._userJR_Alamat1 = rs['alamat1'] ?? "";
    this._userJR_Alamat2 = rs['alamat2'] ?? "";
    this._userJR_Alamat3 = rs['alamat3'] ?? "";
    this._userJR_Poskod = rs['poskod'].toString() ?? "";
    this._userJR_Alamat4 = rs['alamat4'] ?? "";

    
    
    this._userJR_Kod_Negeri = rs['KodNegeri'] ?? "";
    this._userJR_Nama_Negeri = rs['Negeri'] ?? "";
    this._userJR_Kod_Parlimen = rs['KodParlimen'] ?? "";
    this._userJR_Nama_Parlimen = rs['NamaParlimen'] ?? "";

    this._userJR_Kod_Dun = rs['KodDUN'] ?? "";
    this._userJR_Nama_Dun = rs['NamaDun'] ?? "";
    this._userJR_Kod_Dm = rs['KodDM'] ?? "";
    this._userJR_Nama_Dm = rs['NamaDM'] ?? "";

    this._userJR_Jagaan = rs['SPRPemilihJagaan'].toString() ?? "";
    this._userJR_JagaanBanci = rs['SPRPemilihJagaanBanci'].toString() ?? "";
    this._userJR_JagaanP = rs['SPRPemilihJagaanP'].toString() ?? "";
    this._userJR_JagaanK = rs['SPRPemilihJagaanK'].toString() ?? "";
    this._userJR_JagaanH = rs['SPRPemilihJagaanH'].toString() ?? "";
    this._userJR_JagaanT = rs['SPRPemilihJagaanT'].toString() ?? "";
    this._userJR_JagaanM = rs['SPRPemilihJagaanM'].toString() ?? "";
    this._userJR_JagaanBBanci = rs['SPRPemilihJagaanBBanci'].toString() ?? "";
    this._userJR_StatusJRAktif = rs['StatusJRAktif'].toString() ?? "";
    this._userJR_StatusJRKod_Laluan = rs['StatusJRKod_Laluan'].toString() ?? "";
    this._userJR_StatusJRKod_Laluan_Flag = rs['StatusJRKod_Laluan_Flag'].toString() ?? "";
  }
  //b6---------RS Object to Map Object
  //b6'------------------------------------------------------
}
