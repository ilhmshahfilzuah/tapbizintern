class DbBahanKempenCls {
  //b1---------Parameter Key
  late String _id;
  late String _flag;

  late String _kod_Negeri;
  late String _nama_Negeri;
  late String _kod_Parlimen;
  late String _nama_Parlimen;
  late String _kod_Dun;
  late String _nama_Dun;
  late String _kod_Dm;
  late String _nama_Dm;

  late String _user_IC;
  late String _user_pinname;

  late String _tarikh;
  late String _masa;
  late String _tarikhDD;
  late String _tarikhMM;
  late String _tarikhYY;

  late String _status;
  late String _imageURL;

  late String _laporan_Tajuk;
  late String _laporan_Keterangan;
  late String _laporan_Latlong;
  late String _laporan_Lokasi;
  late String _laporan_Kategori;
  late String _laporan_Penganjur;
  late String _laporan_Tahap;
  late String _laporan_Peringkat;
  late String _laporan_Portfolio;
  //b1'-------------------------------------------------------

  //b2---------Constructor
  DbBahanKempenCls(
    this._id, 
    this._flag, 

    this._kod_Negeri, 
    this._nama_Negeri, 
    this._kod_Parlimen, 
    this._nama_Parlimen, 
    this._kod_Dun, 
    this._nama_Dun, 
    this._kod_Dm, 
    this._nama_Dm, 

    this._user_IC, 
    this._user_pinname, 

    this._tarikh, 
    this._masa, 
    this._tarikhDD, 
    this._tarikhMM, 
    this._tarikhYY, 

    this._status, 
    this._imageURL, 

    this._laporan_Tajuk, 
    this._laporan_Keterangan, 
    this._laporan_Latlong, 

    this._laporan_Lokasi, 
    this._laporan_Kategori, 
    this._laporan_Penganjur, 
    this._laporan_Tahap, 
    this._laporan_Peringkat, 
    this._laporan_Portfolio, 

    );
  //b2'-------------------------------------------------------
  //b3---------Getter
  String get id => _id;
  String get flag => _flag;

  String get kod_Negeri => _kod_Negeri;
  String get nama_Negeri => _nama_Negeri;
  String get kod_Parlimen => _kod_Parlimen;
  String get nama_Parlimen => _nama_Parlimen;
  String get kod_Dun => _kod_Dun;
  String get nama_Dun => _nama_Dun;
  String get kod_Dm => _kod_Dm;
  String get nama_Dm => _nama_Dm;

  String get user_IC => _user_IC;
  String get user_pinname => _user_pinname;

  String get tarikh => _tarikh;
  String get masa => _masa;
  String get tarikhDD => _tarikhDD;
  String get tarikhMM => _tarikhMM;
  String get tarikhYY => _tarikhYY;

  String get status => _status;
  String get imageURL => _imageURL;

  String get laporan_Tajuk => _laporan_Tajuk;
  String get laporan_Keterangan => _laporan_Keterangan;
  String get laporan_Latlong => _laporan_Latlong;

  String get laporan_Lokasi => _laporan_Lokasi;
  String get laporan_Kategori => _laporan_Kategori;
  String get laporan_Penganjur => _laporan_Penganjur;
  String get laporan_Tahap => _laporan_Tahap;
  String get laporan_Peringkat => _laporan_Peringkat;
  String get laporan_Portfolio => _laporan_Portfolio;


  //b3'-------------------------------------------------------

  //b4---------Setter
  set id(String newid) => this._id = newid;
  set flag(String newflag) => this._flag = newflag;

  set kod_Negeri(String newkod_Negeri) => this._kod_Negeri = newkod_Negeri;
  set nama_Negeri(String newnama_Negeri) => this._nama_Negeri = newnama_Negeri;
  set kod_Parlimen(String newkod_Parlimen) => this._kod_Parlimen = newkod_Parlimen;
  set nama_Parlimen(String newnama_Parlimen) => this._nama_Parlimen = newnama_Parlimen;
  set kod_Dun(String newkod_Dun) => this._kod_Dun = newkod_Dun;
  set nama_Dun(String newnama_Dun) => this._nama_Dun = newnama_Dun;
  set kod_Dm(String newkod_Dm) => this._kod_Dm = newkod_Dm;
  set nama_Dm(String newnama_Dm) => this._nama_Dm = newnama_Dm;

  set user_IC(String newuser_IC) => this._user_IC = newuser_IC;
  set user_pinname(String newuser_pinname) => this._user_pinname = newuser_pinname;

  set tarikh(String newtarikh) => this._tarikh = newtarikh;
  set masa(String newmasa) => this._masa = newmasa;
  set tarikhDD(String newtarikhDD) => this._tarikhDD = newtarikhDD;
  set tarikhMM(String newtarikhMM) => this._tarikhMM = newtarikhMM;
  set tarikhYY(String newtarikhYY) => this._tarikhYY = newtarikhYY;

  set status(String newstatus) => this._status = newstatus;
  set imageURL(String newimageURL) => this._imageURL = newimageURL;

  set laporan_Tajuk(String newlaporan_Tajuk) => this._laporan_Tajuk = newlaporan_Tajuk;
  set laporan_Keterangan(String newlaporan_Keterangan) => this._laporan_Keterangan = newlaporan_Keterangan;
  set laporan_Latlong(String newlaporan_Latlong) => this._laporan_Latlong = newlaporan_Latlong;

  set laporan_Lokasi(String newlaporan_Lokasi) => this._laporan_Lokasi = newlaporan_Lokasi;
  set laporan_Kategori(String newlaporan_Kategori) => this._laporan_Kategori = newlaporan_Kategori;
  set laporan_Penganjur(String newlaporan_Penganjur) => this._laporan_Penganjur = newlaporan_Penganjur;
  set laporan_Tahap(String newlaporan_Tahap) => this._laporan_Tahap = newlaporan_Tahap;
  set laporan_Peringkat(String newlaporan_Peringkat) => this._laporan_Peringkat = newlaporan_Peringkat;
  set laporan_Portfolio(String newlaporan_Portfolio) => this._laporan_Portfolio = newlaporan_Portfolio;
  
  //b4'-------------------------------------------------------

  //b5---------Map Object to RS Object
  DbBahanKempenCls.fromJson(Map<String, dynamic> rs) {
    this._id = rs['id'].toString();
    this._flag = rs['Flag'] ?? "";
    this._kod_Negeri = rs['Kod_Negeri'] ?? "";
    this._nama_Negeri = rs['Nama_Negeri'] ?? "";
    this._kod_Parlimen = rs['Kod_Parlimen'] ?? "";
    this._nama_Parlimen = rs['Nama_Parlimen'] ?? "";
    this._kod_Dun = rs['Kod_Dun'] ?? "";
    this._nama_Dun = rs['Nama_Dun'] ?? "";
    this._kod_Dm = rs['Kod_Dm'] ?? "";
    this._nama_Dm = rs['Nama_Dm'] ?? "";

    this._user_IC = rs['User_IC'] ?? "";
    this._user_pinname = rs['User_pinname'] ?? "";

    this._tarikh = rs['Tarikh'] ?? "";
    this._masa = rs['Masa'] ?? "";
    this._tarikhDD = rs['TarikhDD'].toString();
    this._tarikhMM = rs['TarikhMM'].toString();
    this._tarikhYY = rs['TarikhYY'].toString();

    this._status = rs['Status'] ?? "";
    this._imageURL = rs['imageURL'] ?? "";

    this._laporan_Tajuk = rs['Laporan_Tajuk'] ?? "";
    this._laporan_Keterangan = rs['Laporan_Keterangan'] ?? "";
    this._laporan_Latlong = rs['Laporan_Latlong'] ?? "";

    this._laporan_Lokasi = rs['Laporan_Lokasi'] ?? "";
    this._laporan_Kategori = rs['Laporan_Kategori'] ?? "";
    this._laporan_Penganjur = rs['Laporan_Penganjur'] ?? "";
    this._laporan_Tahap = rs['Laporan_Tahap'] ?? "";
    this._laporan_Peringkat = rs['Laporan_Peringkat'] ?? "";
    this._laporan_Portfolio = rs['Laporan_Portfolio'] ?? "";
  }
  //b5'------------------------------------------------------

  //b6---------RS Object to Map Object  
  //b6'------------------------------------------------------
}