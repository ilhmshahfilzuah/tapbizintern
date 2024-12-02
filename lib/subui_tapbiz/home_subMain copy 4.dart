import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:js_interop';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:url_launcher/url_launcher.dart';

import '../devkit/config/constant.dart';
import '../devkit/model/feature/category_model.dart';
import '../subconfig/AppSettings.dart';
import '../subdata/model/devkit/product_model.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../sublogic/bloc/auth/authentication_bloc.dart';
import '../sublogic/bloc/dbkawasan/bloc.dart';
import '../devkit/model/feature/banner_slider_model.dart';
import '../subui/reusable/cache_image_network.dart';
import '../subui/reusable/global_function.dart';
import '../subui/reusable/global_widget.dart';
import '../subui/reusable/shimmer_loading.dart';

import 'home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../subdata/model/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'home_PageGroups.dart';
import 'home_subGroups.dart';
import 'home_subUserCard_Mngt.dart';

class HomeSubMainPage extends StatefulWidget {
  const HomeSubMainPage({Key? key}) : super(key: key);
  @override
  _HomeSubMainPageState createState() => _HomeSubMainPageState();
}

class _HomeSubMainPageState extends State<HomeSubMainPage> {
  final _globalWidget = GlobalWidget();
  final _globalFunction = GlobalFunction();
  final _shimmerLoading = ShimmerLoading();

  bool _loading = true;
  Timer? _timerDummy;

  Color _color = Color(0xFF515151);
  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);
  Color _color3 = Color(0xff777777);

  Color _bulletColor = Color(0xff01aed6);

  int _currentImageSlider = 0;

  List<BannerSliderModel> _bannerData = [];
  List<CategoryModel> _categoryData = [];
  List<ProductModel> _trendingData = [];
  List<ProductModel> _productData = [];

  List<CategoryModel> _menuDataSuperAdmin = [];
  List<CategoryModel> _menuDataAgent = [];
  List<CategoryModel> _menuDataHR = [];

  // List<CategoryModel> _categoryDataDm = [];
  // List<CategoryModel> _categoryDataDm_mysmpr = [];
  // List<CategoryModel> _categoryDataDm_myjr = [];
  // List<CategoryModel> _categoryDataDm_myjpm_pemuda = [];
  // List<CategoryModel> _categoryDataDm_myjpm_puteri = [];
  // List<CategoryModel> _categoryDataDm_penaziran = [];

  // List<CategoryModel> _categoryDataDm_infopumas = [];

  // List<CategoryModel> _categoryDataApps = [];

  UserModel? userCls;
  String? token;
  bool? isDDay;
  String? gerakKerjaMod;
  String? accessCatSubIndex;
  bool? isSwitchedStatus;
  //--------Paparan
  String? kodNegeri;
  String? namaNegeri;
  String? kodParlimen;
  String? namaParlimen;
  String? kodDun;
  String? namaDun;
  String? kodDm;
  String? namaDm;
  String? kodLok;
  String? namaLok;

  String? kodNegeriQuery;
  String? namaNegeriQuery;
  String? kodParlimenQuery;
  String? namaParlimenQuery;
  String? kodDunQuery;
  String? namaDunQuery;
  String? kodDmQuery;
  String? namaDmQuery;
  String? kodLokQuery;
  String? namaLokQuery;
  String? paparanQuery;
  String? paparanSenaraiQuery;

  String? paparanSubPusatQuery;
  String? paparanSubNQuery;
  String? paparanSubPQuery;
  String? paparanSubDmQuery;

  String? pilihKawasan;
  String? _menuMyumno;
  //--------Paparan

  String? PinNama;
  String? PinNamaQuery;
  String? PinNamaViewQuery;
  String? Pengumuman1Query;
  String? Pengumuman1Query_Tajuk;
  String? Pengumuman1Query_Keterangan;
  String? Pengumuman1Query_Keterangan2;

  // List<PapanFesCls> listPapanFes = [];
  // int listPapanFesCount = 0;

  // List<PapanutamaCls> listPapanutama = [];
  // int listPapanutamaCount = 0;

  // List<PapankeduaCls> listPapankedua = [];
  // int listPapankeduaCount = 0;

  // List<PengumumanCls> listPengumuman1 = [];
  // int listPengumuman1Count = 0;

  var loadingmain = false;
  var loading = false;
  var loadingListN = false;
  var loadingListP = false;
  var loadingListNDun = false;
  var loadingListPDun = false;
  var loadingListDm = false;
  var loadingListPDm = false;
  var loadingListDunDm = false;
  var loadingListLok = false;
  var loadingPapanutama = false;
  var loadingPapankedua = false;
  var loadingPengumuman = false;
  var loadingAktiviti = false;

  late DbKawasanBloc _dbkawasanBloc;
  int? _groupValue;
  // int? _groupValueSub;
  double _modeSuperAdmin = 0;

  DateTime now = new DateTime.now();
  DateTime _currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int? dd_data;
  int? mm_data;
  int? yy_data;

  // late ScreenshotCallback screenshotCallback;
  String text = "Ready..";

  FocusNode _focusNode = FocusNode();
  String? _appVersion;
  String? _appBuildNumber;

  String? NoAhli;

  String? KodNegeriAhli;
  String? KodBahagianAhli;
  String? KodCawanganAhli;
  String? NamaNegeriAhli;
  String? NamaBahagianAhli;
  String? NamaCawanganAhli;
  String? Status_UserPetugasJR;

  late double wsc;
  late double hsc;

  String? _modPengguna = '';
  String _modQr = '0';

  String? userQuery;

  List<UserTapBizModel> listDb_UserDemo = [];
  int listDb_UserDemoCount = 0;

  List<UserTapBizModel> listDb_UserDemoAll = [];
  int listDb_UserDemoAllCount = 0;


  List<UserTapBizModel> listDb_UserDemoPersonal = [];
  int listDb_UserDemoPersonalCount = 0;

  List<UserTapBizModel> listDb_UserDemoOther = [];
  int listDb_UserDemoOtherCount = 0;

  String? actionQuery;
  String? userQueryAction;
  String? userQueryActionField;
  String? userQueryActionFieldName;

  String? actionTextQuery;

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';
  var _formKey = GlobalKey<FormState>();

  Color ColorAppBar = Color(int.parse(AppSettings.ColorAppBar));
  late String UIColorBg1;

  @override
  void initState() {
    _getDb_UI();
    _menuDataSuperAdmin.add(CategoryModel(id: 1, name: 'Group Mngt', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 2, name: 'Menu 2', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 3, name: 'Menu 3', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 4, name: 'Menu 4', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 5, name: 'Menu 5', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 6, name: 'Menu 6', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 7, name: 'Menu 7', image: GLOBAL_URL + '/category/smartphone.png'));
    // _menuDataSuperAdmin.add(CategoryModel(id: 8, name: 'Menu 8', image: GLOBAL_URL + '/category/smartphone.png'));

    _menuDataAgent.add(CategoryModel(id: 1, name: 'Menu 1', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataAgent.add(CategoryModel(id: 2, name: 'Menu 2', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataAgent.add(CategoryModel(id: 3, name: 'Menu 3', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataAgent.add(CategoryModel(id: 4, name: 'Menu 4', image: GLOBAL_URL + '/category/smartphone.png'));
    // _add2DataPageMenu();
    _groupValue = 0;
    dd_data = DateTime.parse(_currentDate.toString()).day;
    mm_data = DateTime.parse(_currentDate.toString()).month;
    yy_data = DateTime.parse(_currentDate.toString()).year;

    // context.read<DbKawasanBloc>().emit(GetDbKawasanWaiting());

    _getUserInfo().then((_) {
      if (userCls != null && userCls!.userUser_Email != null) {
        _listDb_UserDemo_ByUserid(userCls!.userId);
      }

      // syncPin().then((_) {
      //   switch (PinNamaQuery) {
      //     case '101superadmin':
      //       PinNamaViewQuery = 'Super Admin';
      //       break;
      //     case '101top5':
      //       PinNamaViewQuery = 'TOP 5';
      //       break;

      //     default:
      //       PinNamaViewQuery = '-';
      //   }
      // });
    });

    _getData();

    super.initState();
  }

  @override
  void dispose() {
    _timerDummy?.cancel();
    if (_focusNode != null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Future<Null> _getDb_UI() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {Userid};
    postdata = {};
    apiUrl = 'UI/getUI';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final UIList_By_home_content = (response.data as Map<String, dynamic>)['UIList_By_home_content'];
      //--- Set State
      if (mounted) {
        setState(() {
          UIColorBg1 = response.data['UIColorBg1'] ?? "";
          ColorAppBar = Color(int.parse(UIColorBg1));
          loading = false;
        });
      }
      // --- Set State
      //--------------------------------------------------------------
    } else {
      // --- DialogBox
      // if (_showAlertDialogStatus == 0) {
      //   _showAlertDialog('Status:', 'Check Connection');
      //   setState(() {
      //     _showAlertDialogStatus = 1;
      //   });
      // }
      // --- DialogBox
    }
  }

  void _getData() {
    _timerDummy = Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  //----------------------------------

  //---------------------------------------_getUserInfo
  Future<bool> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // setState(() {
    //   _modPengguna = prefs.getString('_modPengguna') ?? '';
    //   _menuMyumno = prefs.getString('_menuMyumno') ?? '';
    // });

    prefs.setString('kodTMQuery', '');
    prefs.setString('tMQuery', '');

    accessCatSubIndex = prefs.getString('accessCatSubIndex') ?? '';
    gerakKerjaMod = prefs.getString('gerakKerjaMod') ?? '';
    if (gerakKerjaMod == null) {
      await prefs.setString('gerakKerjaMod', "0");
      gerakKerjaMod = '0';
    }
    if (mounted) {
      setState(() {
        token = prefs.getString('token') ?? '';
        isDDay = prefs.getBool('isDDay') ?? true;

        final userJson = prefs.getString('user') ?? '';
        Map<String, dynamic> map = jsonDecode(userJson);
        userCls = UserModel.fromJson(map);

        prefs.setString('PinNama', userCls!.userUser_Kod_KeselamatanSubNama);
        PinNama = prefs.getString('PinNama');
        PinNamaQuery = prefs.getString('PinNamaQuery');

        if (PinNamaQuery == '') {
          prefs.setString('PinNamaQuery', PinNama ?? "");
          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
        } else {
          PinNamaQuery = PinNamaQuery;
        }

        //--------Paparan
        if (userCls != null) {
          //-------- localStorage
          if (gerakKerjaMod == '0') {
            isSwitchedStatus = false;
          } else {
            isSwitchedStatus = true;
          }
          if (userCls!.userAccess_Type == 'Pusat') {
            prefs.setString('kodNegeri', "");
            prefs.setString('namaNegeri', "");
            prefs.setString('kodParlimen', "");
            prefs.setString('namaParlimen', "");
            prefs.setString('kodDun', "");
            prefs.setString('namaDun', "");
            prefs.setString('kodDm', "");
            prefs.setString('namaDm', "");
            prefs.setString('kodLok', "");
            prefs.setString('namaLok', "");
          }
          if (userCls!.userAccess_Type == 'N') {
            prefs.setString('kodNegeri', userCls!.userUser_Kod_Negeri);
            prefs.setString('namaNegeri', userCls!.userUser_Nama_Negeri);
            prefs.setString('kodParlimen', "");
            prefs.setString('namaParlimen', "");
            prefs.setString('kodDun', "");
            prefs.setString('namaDun', "");
            prefs.setString('kodDm', "");
            prefs.setString('namaDm', "");
            prefs.setString('kodLok', "");
            prefs.setString('namaLok', "");
          }
          if (userCls!.userAccess_Type == 'P') {
            prefs.setString('kodNegeri', userCls!.userUser_Kod_Negeri);
            prefs.setString('namaNegeri', userCls!.userUser_Nama_Negeri);
            prefs.setString('kodParlimen', userCls!.userUser_Kod_Parlimen);
            prefs.setString('namaParlimen', userCls!.userUser_Nama_Parlimen);
            prefs.setString('kodDun', "");
            prefs.setString('namaDun', "");
            prefs.setString('kodDm', "");
            prefs.setString('namaDm', "");
            prefs.setString('kodLok', "");
            prefs.setString('namaLok', "");
          }
          if (userCls!.userAccess_Type == 'Dun') {
            prefs.setString('kodNegeri', userCls!.userUser_Kod_Negeri);
            prefs.setString('namaNegeri', userCls!.userUser_Nama_Negeri);
            prefs.setString('kodParlimen', userCls!.userUser_Kod_Parlimen);
            prefs.setString('namaParlimen', userCls!.userUser_Nama_Parlimen);
            prefs.setString('kodDun', userCls!.userUser_Kod_Dun);
            prefs.setString('namaDun', userCls!.userUser_Nama_Dun);
            prefs.setString('kodDm', "");
            prefs.setString('namaDm', "");
            prefs.setString('kodLok', "");
            prefs.setString('namaLok', "");
          }
          if (userCls!.userAccess_Type == 'Dm') {
            prefs.setString('kodNegeri', userCls!.userUser_Kod_Negeri);
            prefs.setString('namaNegeri', userCls!.userUser_Nama_Negeri);
            prefs.setString('kodParlimen', userCls!.userUser_Kod_Parlimen);
            prefs.setString('namaParlimen', userCls!.userUser_Nama_Parlimen);
            prefs.setString('kodDun', userCls!.userUser_Kod_Dun);
            prefs.setString('namaDun', userCls!.userUser_Nama_Dun);
            prefs.setString('kodDm', userCls!.userUser_Kod_Dm);
            prefs.setString('namaDm', userCls!.userUser_Nama_Dm);
            prefs.setString('kodLok', "");
            prefs.setString('namaLok', "");
          }
          //----
          kodNegeri = prefs.getString('kodNegeri') ?? '';
          namaNegeri = prefs.getString('namaNegeri') ?? '';
          kodParlimen = prefs.getString('kodParlimen') ?? '';
          namaParlimen = prefs.getString('namaParlimen') ?? '';
          kodDun = prefs.getString('kodDun') ?? '';
          namaDun = prefs.getString('namaDun') ?? '';
          kodDm = prefs.getString('kodDm') ?? '';
          namaDm = prefs.getString('namaDm') ?? '';
          kodLok = prefs.getString('kodLok') ?? '';
          namaLok = prefs.getString('namaLok') ?? '';

          //-----
          kodNegeriQuery = prefs.getString('kodNegeriQuery') ?? '';
          namaNegeriQuery = prefs.getString('namaNegeriQuery') ?? '';
          kodParlimenQuery = prefs.getString('kodParlimenQuery') ?? '';
          namaParlimenQuery = prefs.getString('namaParlimenQuery') ?? '';
          kodDunQuery = prefs.getString('kodDunQuery') ?? '';
          namaDunQuery = prefs.getString('namaDunQuery') ?? '';
          kodDmQuery = prefs.getString('kodDmQuery') ?? '';
          namaDmQuery = prefs.getString('namaDmQuery') ?? '';
          kodLokQuery = prefs.getString('kodLokQuery') ?? '';
          namaLokQuery = prefs.getString('namaLokQuery') ?? '';
          //----

          //-------- localStorage
        }
        //--------Paparan
      });
    }

    return true;
  }

  //---------------------------------------_getUserInfo
  syncPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userCls != null) {
      //-------- localStorage
      prefs.setString('PinNama', userCls!.userUser_Kod_KeselamatanSubNama);
      PinNama = prefs.getString('PinNama');
      PinNamaQuery = prefs.getString('PinNamaQuery');

      if (PinNamaQuery == '') {
        prefs.setString('PinNamaQuery', PinNama ?? "");
        PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
      } else {
        PinNamaQuery = PinNamaQuery;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    wsc = MediaQuery.of(context).size.width;
    hsc = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Container(
        //   padding: EdgeInsets.only(left: 20, right: 20, bottom: 0),
        //   child: Column(
        //     children: [
        //       Text('wsc: $wsc'),
        //       Text('hsc: $hsc'),
        //     ],
        //   ),
        // ),
        // ClipPath(
        //     clipper: OvalTopBorderClipper(),
        //     child: Container(
        //       height: 320,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
        //         color: Colors.orange,
        //       ),
        //       child: Center(child: Text("RoundedDiagonalPathClipper()")),
        //     ),
        //   ),
        // SizedBox(
        //   height: 4,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8),
        //   child: Card(
        //       elevation: 20,
        //       child: Padding(
        //         padding: const EdgeInsets.all(4.0),
        //         child: _HomeBannerSlider1(),
        //       )),
        // ),
        Stack(
          children: [
            (_bannerData.length == 0)
                ? Container()
                : CarouselSlider(
                    items: _bannerData
                        .map((item) => Container(
                              child: buildCacheNetworkImage(width: 0, height: 0, url: item.image),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        aspectRatio: 2,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 6),
                        autoPlayAnimationDuration: Duration(milliseconds: 300),
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageSlider = index;
                          });
                        }),
                  ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _bannerData.map((item) {
                  int index = _bannerData.indexOf(item);
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: _currentImageSlider == index ? 16.0 : 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentImageSlider == index ? _bulletColor : Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        // _HomeBannerSlider1(),
        // Text('$userQuery'),
        (userQuery != null)
            ? Container()
            : Stack(
                children: [
                  Column(
                    children: [
                      ClipPath(
                        clipper: WaveClipperOne(),
                        child: Container(
                          height: 100,
                          color: ColorAppBar,
                          child: Center(child: Text("")),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8),
                    child: Card(
                        color: AppSettings.ColorUnderline2,
                        surfaceTintColor: AppSettings.ColorUnderline2,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (_modQr == '1')
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _modQr = '0';
                                        });
                                      },
                                      child: QrImageView(
                                        data: '${userCls!.userUser_Name}, ${userCls!.userUser_Email}',
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    ),
                                    (userCls != null)
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              (userCls != null)
                                                  ? Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Access Name: ${userCls!.userUser_Name}',
                                                          style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                          'ID: ${userCls!.userId}',
                                                          style: TextStyle(fontSize: 12),
                                                        ),
                                                        SizedBox(height: 4),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _buildTop(),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    (PinNamaQuery == 'Superadmin')
                                        ? Column(
                                            children: [
                                              const Divider(
                                                height: 10,
                                                thickness: 1,
                                                indent: 40,
                                                endIndent: 40,
                                                color: Colors.grey,
                                              ),
                                              Text('SUPER ADMIN MENU', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('_groupValueSub', 0);
                                                    prefs.setString('PinNamaQuery', 'Personal');
                                                    setState(() {
                                                      PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                    });
                                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                  },
                                                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesome5.window_close,
                              size: 20.0,
                              color: AppSettings.ColorMain,
                            ),
                            Text('  [Close]')
                          ],
                        ),),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              _menuSuperAdmin(),
                                              const Divider(
                                                height: 10,
                                                thickness: 1,
                                                indent: 40,
                                                endIndent: 40,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    (PinNamaQuery == 'Agent')
                                        ? Column(
                                            children: [
                                              const Divider(
                                                height: 10,
                                                thickness: 1,
                                                indent: 40,
                                                endIndent: 40,
                                                color: Colors.grey,
                                              ),
                                              Text('AGENT MENU', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('_groupValueSub', 0);
                                                    prefs.setString('PinNamaQuery', 'Personal');
                                                    setState(() {
                                                      PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                    });
                                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                  },
                                                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesome5.window_close,
                              size: 20.0,
                              color: AppSettings.ColorMain,
                            ),
                            Text('  [Close]')
                          ],
                        ),),
                                              // _menuSuperAdmin(),
                                              const Divider(
                                                height: 10,
                                                thickness: 1,
                                                indent: 40,
                                                endIndent: 40,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    (PinNamaQuery == 'Group HR/Admin')
                                        ? Column(
                                            children: [
                                              const Divider(
                                                height: 10,
                                                thickness: 1,
                                                indent: 40,
                                                endIndent: 40,
                                                color: Colors.grey,
                                              ),
                                              Text('HR/ADMIN MENU', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('_groupValueSub', 0);
                                                    prefs.setString('PinNamaQuery', 'Personal');
                                                    setState(() {
                                                      PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                    });
                                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                  },
                                                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesome5.window_close,
                              size: 20.0,
                              color: AppSettings.ColorMain,
                            ),
                            Text('  [Close]')
                          ],
                        ),),
                                              // _menuSuperAdmin(),
                                              const Divider(
                                                height: 10,
                                                thickness: 1,
                                                indent: 40,
                                                endIndent: 40,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                        )),
                  ),
                ],
              ),

        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: _buildCard(),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (userCls != null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (userCls != null)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi, ${userCls!.userUser_Name}',
                                        style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Email: ${userCls!.userUser_Email}',
                                        style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Phone: ${userCls!.userUser_NoTel}',
                                        style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Column(
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 4),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.asset('${AppSettings.AppLogo500}', height: 40),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Ver: ${AppSettings.AppVersion}',
                style: TextStyle(fontSize: 10),
              ),
              GestureDetector(
                onTap: () {
                  showCupertinoDialog<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text('Log Out'),
                      content: Text('Are you sure?'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('Yes'),
                          isDestructiveAction: true,
                          onPressed: () {
                            context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                          },
                        )
                      ],
                    ),
                  );
                },
                child: Text('Log Out', style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Future<void> _launchInBrowser(String url) async {
  //   Uri urlUri = Uri.parse(url);
  //   if (!await launchUrl(
  //     urlUri,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }

  Widget _menuSuperAdmin() {
    return Container(
      height: (_menuDataSuperAdmin.length > 1) ? 180 : 180,
      child: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 8),
        childAspectRatio: 1.3,
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        children: List.generate(_menuDataSuperAdmin.length, (index) {
          return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PageGroups(dataSource:'',dataId:'',dataName:'',)));
                } else {
                  Fluttertoast.showToast(msg: 'Click ' + _menuDataSuperAdmin[index].name, toastLength: Toast.LENGTH_SHORT);
                }
              },
              child: Column(children: [
                ClipOval(
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey[300]!),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        padding: EdgeInsets.all(5),
                        child: buildCacheNetworkImage(width: 30, height: 30, url: _menuDataSuperAdmin[index].image, plColor: Colors.transparent))),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      _menuDataSuperAdmin[index].name,
                      style: TextStyle(
                        color: _color2,
                        fontWeight: FontWeight.normal,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ]));
        }),
      ),
    );
  }

  Widget _createTrending() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Isu-Isu Semasa (Trending)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'Click trending', toastLength: Toast.LENGTH_SHORT);
                },
                child: Text('Papar Semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: PRIMARY_COLOR), textAlign: TextAlign.end),
              )
            ],
          ),
        ),
        GridView.count(
          padding: EdgeInsets.all(12),
          primary: false,
          childAspectRatio: 4 / 1.6,
          shrinkWrap: true,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            return _buildTrendingProductCard(index);
          }),
        ),
      ],
    );
  }

  Widget _buildTrendingProductCard(index) {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(msg: 'Click ' + _trendingData[index].name, toastLength: Toast.LENGTH_SHORT);
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          color: AppSettings.ColorUnderline2,
          surfaceTintColor: AppSettings.ColorUnderline2,
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  child: buildCacheNetworkImage(width: (MediaQuery.of(context).size.width / 2) * (1.6 / 4) - 12 - 1, height: (MediaQuery.of(context).size.width / 2) * (1.6 / 4) - 12 - 1, url: _trendingData[index].image)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(_trendingData[index].name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), SizedBox(height: 4)],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _MedSos_Slider(String title, String icon) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                  color: AppSettings.ColorUnderline2,
                  surfaceTintColor: AppSettings.ColorUnderline2,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        (icon == 'YouTube') ? Icon(FontAwesome5.youtube) : Container(),
                        (icon == 'FB') ? Icon(Icons.facebook_outlined) : Container(),
                        (icon == 'TikTok') ? Icon(Icons.tiktok_rounded) : Container(),
                        (icon == 'LL') ? Icon(Icons.menu) : Container(),
                        (icon == 'Infografik') ? Icon(Icons.image) : Container(),
                      ],
                    ),
                  )),
              Text(' $title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'Click last search', toastLength: Toast.LENGTH_SHORT);
                },
                child: Text('Papar Semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: PRIMARY_COLOR), textAlign: TextAlign.end),
              )
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
            height: boxImageSize * 1.80,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _productData.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildLastSearchCard(index, boxImageSize);
              },
            )),
      ],
    );
  }

  Widget _buildLastSearchCard(index, boxImageSize) {
    return Container(
      width: boxImageSize,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: AppSettings.ColorUnderline2,
        surfaceTintColor: AppSettings.ColorUnderline2,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Fluttertoast.showToast(msg: 'Click ' + _productData[index].name, toastLength: Toast.LENGTH_SHORT);
          },
          child: Column(
            children: <Widget>[
              ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: _productData[index].image)),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _productData[index].name,
                      style: TextStyle(fontSize: 12, color: _color1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 5),
                    //   child: Text('\$ ' + _globalFunction.removeDecimalZeroFormat(_productData[index].price!), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 5),
                    //   child: Row(
                    //     children: [_globalWidget.createRatingBar(rating: _productData[index].rating!, size: 12), Text('(' + _productData[index].review.toString() + ')', style: TextStyle(fontSize: 11, color: SOFT_GREY))],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------

  //---------------------------------
  Widget _buildCard() {
    return (loading)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 8, 8),
            child: SizedBox(
              child: LinearProgressIndicator(
                backgroundColor: Colors.black26,
                valueColor: new AlwaysStoppedAnimation<Color>(AppSettings.ColorMain),
              ),
              width: 50.0,
            ),
          )
        : (userQuery == null)
            ? Column(
                children: [
                  // --------------
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        (actionQuery == 'AddCard')
                            ? Container()
                            : Container(
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Text('All TapBiz Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                        Spacer(),
                        // InkWell(
                        //   onTap: () async {
                        //     setState(() {
                        //       actionQuery = 'AddCard';
                        //     });
                        //   },
                        //   child: Row(
                        //     children: [
                        //       Text('Add Personal Card '),
                        //       Icon(
                        //         Typicons.plus_outline,
                        //         size: 20,
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  (actionQuery == 'AddCard')
                      ? Column(
                          children: [
                            Text('Add New Card'),
                            // InkWell(
                            //   onTap: () async {
                            //     setState(() {
                            //       actionQuery = null;
                            //     });
                            //   },
                            //   child: Icon(
                            //     Typicons.cancel_outline,
                            //     size: 20,
                            //   ),
                            // ),
                            // ------------------
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              child: _addForm(),
                            ),
                            // ------------------
                          ],
                        )
                      : _AllCard('All'),

                  // -------------
                  // (actionQuery == 'AddCard')
                  //     ? Container()
                  //     : (listDb_UserDemoOther.length == 0)
                  //         ? Container()
                  //         : Column(
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Row(
                  //                   children: [
                  //                     Container(
                  //                       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  //                       child: Text('Others Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               _AllCard('Other')
                  //             ],
                  //           ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 8),
                  //     child: Column(
                  //       children: [
                  //         getListViewBuilder_Data(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : (loading)
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 8, 8),
                    child: SizedBox(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.black26,
                        valueColor: new AlwaysStoppedAnimation<Color>(AppSettings.ColorMain),
                      ),
                      width: 50.0,
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // Text(
                            //   'Card Query: $userQuery',
                            //   style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            // ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  userQuery = null;
                                  _listDb_UserDemo_ByUserid(userCls!.userId);
                                });
                              },
                              child: Row(
                                children: [
                                  Text('Close Card '),
                                  Icon(
                                    Typicons.cancel_outline,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PageUserCard_Mngt(parentQuery: 'Home', userQuery: userQuery!),
                    ],
                  );
  }

  // -----------------
  ListView getListViewBuilder_Data() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_UserDemo.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () async {
            // _getDb_UserDemo(this.listDb_UserDemo[position].Username);
            setState(() {
              userQuery = this.listDb_UserDemo[position].Username;
            });
          },
          child: Card(
            elevation: 10,
            color: AppSettings.ColorUnderline2,
            surfaceTintColor: AppSettings.ColorUnderline2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CARD ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text('${this.listDb_UserDemo[position].Username}', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CARD TYPE: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text('${this.listDb_UserDemo[position].CardType}', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CARD NAME: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text('${this.listDb_UserDemo[position].User_Name}', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          (this.listDb_UserDemo[position].CardType == 'tapcard')
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    Text('https://tapcard.tapbiz.my/tc/${this.listDb_UserDemo[position].Username}', style: TextStyle(fontSize: 10)),
                                  ],
                                )
                              : Container(),
                          (this.listDb_UserDemo[position].CardType == 'tapid')
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                    Text('https://tapid.tapbiz.my/ti/${this.listDb_UserDemo[position].Username}', style: TextStyle(fontSize: 10)),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Text(
                          //   'Type: ${this.listDb_UserDemo[position].CardType}',
                          //   style: TextStyle(color: Colors.black, fontSize: 11),
                          // ),
                          Row(
                            children: [
                              Icon(
                                Typicons.key_outline,
                                size: 14,
                              ),
                              Text(
                                '${this.listDb_UserDemo[position].CardAuth}',
                                style: TextStyle(color: (this.listDb_UserDemo[position].CardAuth == 'Yes') ? Colors.black : Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Null> _listDb_UserDemo_ByUserid(String userId) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "Userid": userId,
    };
    apiUrl = 'GroupCardV2/listGroupCard_ByUserid';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdataAll = (response.data as Map<String, dynamic>)['UserDemoList'];
      final listdataPersonal = (response.data as Map<String, dynamic>)['UserDemoListPersonal'];
      final listdataOther = (response.data as Map<String, dynamic>)['UserDemoListOther'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserTapBizModel> _listDataAll = [];
          for (int i = 0; i < listdataAll.length; i++) _listDataAll.add(UserTapBizModel.fromJson(listdataAll[i]));
          listDb_UserDemoAll = _listDataAll;
          listDb_UserDemoAllCount = _listDataAll.length;


          List<UserTapBizModel> _listDataPersonal = [];
          for (int i = 0; i < listdataPersonal.length; i++) _listDataPersonal.add(UserTapBizModel.fromJson(listdataPersonal[i]));
          listDb_UserDemoPersonal = _listDataPersonal;
          listDb_UserDemoPersonalCount = _listDataPersonal.length;

          List<UserTapBizModel> _listDataOther = [];
          for (int i = 0; i < listdataOther.length; i++) _listDataOther.add(UserTapBizModel.fromJson(listdataOther[i]));
          listDb_UserDemoOther = _listDataOther;
          listDb_UserDemoOtherCount = _listDataOther.length;

          loading = false;
        });
      }
      // --- Set State

      //--------------------------------------------------------------
    } else {
      // --- DialogBox
      // if (_showAlertDialogStatus == 0) {
      //   _showAlertDialog('Status:', 'Check Connection');
      //   setState(() {
      //     _showAlertDialogStatus = 1;
      //   });
      // }
      // --- DialogBox
    }
  }

  Future refreshData() async {
    setState(() {
      _productData.clear();
      _loading = true;
      _getData();
    });
  }

  // Widget _AllCardPersonal() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomScrollView(primary: false, shrinkWrap: true, slivers: <Widget>[
  //         SliverPadding(
  //           padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
  //           sliver: SliverGrid(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3,
  //               mainAxisSpacing: 8,
  //               crossAxisSpacing: 8,
  //               childAspectRatio: 1.0,
  //             ),
  //             delegate: SliverChildBuilderDelegate(
  //               (BuildContext context, int index) {
  //                 return _buildItem(index);
  //               },
  //               childCount: listDb_UserDemo.length,
  //             ),
  //           ),
  //         ),
  //       ])
  //     ],
  //   );
  // }

  Widget _AllCard(String CatCard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomScrollView(primary: false, shrinkWrap: true, slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildItemAll(index);
                },
                childCount: listDb_UserDemoAll.length,
              ),
            ),
          ),
        ])
      ],
    );
  }

  Widget _buildItemAll(index) {
    final double boxImageSize = ((MediaQuery.of(context).size.width) - 24) / 2 - 12;
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: AppSettings.ColorUnderline2,
        surfaceTintColor: AppSettings.ColorUnderline2,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              userQuery = this.listDb_UserDemoAll[index].Username;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text('boxImageSize: $boxImageSize'),
              (this.listDb_UserDemoAll[index].themeURL == '')
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: 'https://storage.googleapis.com/tapbiz/theme_card/webcard/covertapbiz.jpg'))
                  : ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: this.listDb_UserDemoAll[index].themeURL)),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   listDb_UserDemoAll[index].User_Name,
                    //   style: TextStyle(fontSize: 12, color: _color1),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    Text(
                      listDb_UserDemoAll[index].Username,
                      style: TextStyle(fontSize: 12, color: _color1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   listDb_UserDemoAll[index].CardType,
                    //   style: TextStyle(fontSize: 12, color: _color1),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Text(
                    //           'Authorization Code: ',
                    //           style: TextStyle(fontSize: 12, color: _color1),
                    //           maxLines: 2,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //         Text(
                    //           '${this.listDb_UserDemoAll[index].CardAuth}',
                    //           style: TextStyle(color: (this.listDb_UserDemoAll[index].CardAuth == 'Yes') ? Colors.black : Colors.red, fontSize: 11),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildItemOther(index) {
  //   final double boxImageSize = ((MediaQuery.of(context).size.width) - 24) / 2 - 12;
  //   return Container(
  //     child: Card(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       elevation: 2,
  //       color: AppSettings.ColorUnderline2,
  //       surfaceTintColor: AppSettings.ColorUnderline2,
  //       child: GestureDetector(
  //         behavior: HitTestBehavior.translucent,
  //         onTap: () {
  //           setState(() {
  //             userQuery = this.listDb_UserDemoOther[index].Username;
  //           });
  //         },
  //         child: Column(
  //           children: <Widget>[
  //             // Text('boxImageSize: $boxImageSize'),
  //             (this.listDb_UserDemoOther[index].themeURL == '')
  //                 ? ClipRRect(
  //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: 'https://storage.googleapis.com/tapbiz/theme_card/webcard/covertapbiz.jpg'))
  //                 : ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: this.listDb_UserDemoOther[index].themeURL)),
  //             Container(
  //               margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Text(
  //                   //   listDb_UserDemoOther[index].User_Name,
  //                   //   style: TextStyle(fontSize: 12, color: _color1),
  //                   //   maxLines: 2,
  //                   //   overflow: TextOverflow.ellipsis,
  //                   // ),
  //                   Text(
  //                     listDb_UserDemoOther[index].Username,
  //                     style: TextStyle(fontSize: 12, color: _color1),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   // Text(
  //                   //   listDb_UserDemoOther[index].CardType,
  //                   //   style: TextStyle(fontSize: 12, color: _color1),
  //                   //   maxLines: 2,
  //                   //   overflow: TextOverflow.ellipsis,
  //                   // ),
  //                   // Column(
  //                   //   mainAxisAlignment: MainAxisAlignment.end,
  //                   //   crossAxisAlignment: CrossAxisAlignment.end,
  //                   //   children: [
  //                   //     Row(
  //                   //       children: [
  //                   //         Text(
  //                   //           'Authorization Code: ',
  //                   //           style: TextStyle(fontSize: 12, color: _color1),
  //                   //           maxLines: 2,
  //                   //           overflow: TextOverflow.ellipsis,
  //                   //         ),
  //                   //         Text(
  //                   //           '${this.listDb_UserDemoOther[index].CardAuth}',
  //                   //           style: TextStyle(color: (this.listDb_UserDemoOther[index].CardAuth == 'Yes') ? Colors.black : Colors.red, fontSize: 11),
  //                   //         ),
  //                   //       ],
  //                   //     ),
  //                   //   ],
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _addForm() {
    userQueryActionFieldName = 'CARD ID';
    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 30),
          // Text('$userQueryActionField'),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
            child: TextFormField(
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 6, // when user presses enter it will adapt to it
              controller: dataObjController,
              validator: (value) => value!.isEmpty ? 'Enter $userQueryActionFieldName' : null,
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  // _updateHadir(dataICNOSIRI!);
                }
              },

              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                labelText: '$userQueryActionFieldName',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (value) {
                updateObj();
              },
            ),
          ),
          (actionTextQuery == null) ? Container() : Text('$actionTextQuery'),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        return AppSettings.ColorMain;
                        // return Colors.grey;
                      }),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Typicons.ok_outline,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("Add", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      // _updateDb_UserDemo(userQuery, userQueryActionField!, dataObj, null);
                      // userQueryActionField = null;
                      if (_formKey.currentState!.validate()) {
                        _addDb_UserDemo();
                      }
                    },
                  ),
                ),
              ),
              Text('  '),
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        // return AppSettings.ColorUpperline;
                        return Colors.grey;
                      }),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Typicons.cancel_outline,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        // _listDb_UserDemo_ByGroupid(userGroupidQuery!);
                        actionQuery = null;
                        actionTextQuery = null;
                        dataObj = '';
                        dataObjController.text = '';
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  updateObj() {
    setState(() {
      dataObj = dataObjController.text;
    });
  }

  Future<Null> _addDb_UserDemo() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"User_Email": userCls!.userUser_Email, "Userid": userCls!.userId, "Groupid": '2', "Username": dataObj});

    apiUrl = 'GroupCardV2/addGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        if (response.data['success'] == true) {
          setState(() {
            _listDb_UserDemo_ByUserid(userCls!.userId);
            actionQuery = null;
            dataObj = '';
            dataObjController.text = '';
            loading = false;
          });
        } else {
          setState(() {
            actionTextQuery = response.data['message'];
            _listDb_UserDemo_ByUserid(userCls!.userId);
            actionQuery = null;
            dataObj = '';
            dataObjController.text = '';
            loading = false;
          });
        }
      }
      // --- Set State

      //--------------------------------------------------------------
    } else {
      // --- DialogBox
      // if (_showAlertDialogStatus == 0) {
      //   _showAlertDialog('Status:', 'Check Connection');
      //   setState(() {
      //     _showAlertDialogStatus = 1;
      //   });
      // }
      // --- DialogBox
    }
  }
}
