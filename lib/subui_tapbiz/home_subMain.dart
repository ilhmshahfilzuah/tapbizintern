import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../devkit/config/constant.dart';
import '../devkit/model/feature/category_model.dart';
import '../subconfig/AppSettings.dart';
import '../subdata/model/devkit/product_model.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/model/usergroupTapBiz_model.dart';
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
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../subdata/model/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'home_PageLogMonitoring.dart';
import 'home_PageGroups.dart';
import 'home_PageSetSuperAdmin.dart';
import 'home_PageThemes.dart';
import 'home_subUserCard_Mngt.dart';
import 'home_Users.dart';

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

  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);

  Color _bulletColor = Color(0xff01aed6);

  int _currentImageSlider = 0;

  List<BannerSliderModel> _bannerData = [];
  List<CategoryModel> _categoryData = [];
  List<ProductModel> _trendingData = [];
  List<ProductModel> _productData = [];

  List<CategoryModel> _menuDataSuperAdmin = [];
  List<CategoryModel> _menuDataAgent = [];
  List<CategoryModel> _menuDataHR = [];

  UserModel? userCls;
  String? token;
  bool? isDDay;
  String? gerakKerjaMod;
  String? accessCatSubIndex;
  bool? isSwitchedStatus;

  String? PinNama;
  String? PinNamaQuery;
  String? PinNamaViewQuery;
  String? Pengumuman1Query;
  String? Pengumuman1Query_Tajuk;
  String? Pengumuman1Query_Keterangan;
  String? Pengumuman1Query_Keterangan2;

  var loadingmain = false;
  var loading = false;
  var loading_listCard = false;

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

  List<UserGroupTapBizModel> listDb_UserGroup = [];
  int listDb_UserGroupCount = 0;

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
    _menuDataSuperAdmin.add(CategoryModel(id: 1, name: 'Users Mngt', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataSuperAdmin.add(CategoryModel(id: 2, name: 'Groups Mngt', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataSuperAdmin.add(CategoryModel(id: 3, name: 'Themes Mngt', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataSuperAdmin.add(CategoryModel(id: 4, name: 'Log Monitoring', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataSuperAdmin.add(CategoryModel(id: 5, name: 'Super Admin Setting', image: GLOBAL_URL + '/category/smartphone.png'));

    _menuDataAgent.add(CategoryModel(id: 1, name: 'Menu 1', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataAgent.add(CategoryModel(id: 2, name: 'Menu 2', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataAgent.add(CategoryModel(id: 3, name: 'Menu 3', image: GLOBAL_URL + '/category/smartphone.png'));
    _menuDataAgent.add(CategoryModel(id: 4, name: 'Menu 4', image: GLOBAL_URL + '/category/smartphone.png'));

    dd_data = DateTime.parse(_currentDate.toString()).day;
    mm_data = DateTime.parse(_currentDate.toString()).month;
    yy_data = DateTime.parse(_currentDate.toString()).year;

    _getDb_UI().then((_) {
      _getUserInfo().then((_) {
        if (userCls != null && userCls!.userUser_Email != null) {
          _getUserCheck();
          _listDb_UserDemo_ByUserid(userCls!.userId);
        }
      });
    });
    //------temp hot reload
    // userQuery = 'buck';
    //------temp hot reload

    // _getData();

    super.initState();
  }

  Future<Null> _getUserCheck() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {};
    postdata = {
      "userId": userCls!.userId,
    };
    apiUrl = 'getUser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final userModel = (response.data as Map<String, dynamic>)['user'];
      final listdata = (response.data as Map<String, dynamic>)['UserActivationCodeGroup'];
      //--- Set State

      // -----
      Map<String, dynamic> map = userModel;
      String user = jsonEncode(map);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user);

      if (mounted) {
        setState(() {
          final userJson = prefs.getString('user') ?? '';
          Map<String, dynamic> map = jsonDecode(userJson);
          userCls = UserModel.fromJson(map);

          List<UserGroupTapBizModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserGroupTapBizModel.fromJson(listdata[i]));
          listDb_UserGroup = _listData;
          listDb_UserGroupCount = _listData.length;
          loading = false;
        });
      }

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

  // @override
  // void dispose() {
  //   _timerDummy?.cancel();
  //   if (_focusNode != null) {
  //     _focusNode.dispose();
  //   }
  //   super.dispose();
  // }

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

    if (mounted) {
      setState(() {
        token = prefs.getString('token') ?? '';
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
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    wsc = MediaQuery.of(context).size.width;
    hsc = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
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
        (loading)
            ? Container()
            : (userQuery != null)
                ? Container()
                : Stack(
                    children: [
                      Column(
                        children: [
                          ClipPath(
                            clipper: WaveClipperOne(),
                            child: Container(
                              height: 200,
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
                                        // Text('userAccess_Level: ${userCls!.userAccess_Level}'),
                                        // Text('userAccess_Level_Agent: ${userCls!.userAccess_Level_Agent}'),
                                        // Text('userAccess_Level_HRAdmin: ${userCls!.userAccess_Level_HRAdmin}'),
                                        (userCls != null && (userCls!.userAccess_Level == '1' || userCls!.userAccess_Level_Agent == '1' || userCls!.userAccess_Level_HRAdmin == '1'))
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child: Card(
                                                  color: Colors.blue.shade50,
                                                  surfaceTintColor: Colors.blue.shade50,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        (userCls != null && (userCls!.userAccess_Level == '1' || userCls!.userAccess_Level_Agent == '1' || userCls!.userAccess_Level_HRAdmin == '1'))
                                                            ? Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Management Tools", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          (userCls!.userAccess_Level == '1')
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                        prefs.setInt('_groupValueSub', 0);
                                                                                        prefs.setString('PinNamaQuery', 'Superadmin');
                                                                                        setState(() {
                                                                                          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                                        });
                                                                                        // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                                      },
                                                                                      child: (PinNamaQuery == 'Superadmin')
                                                                                          ? Text('# Super Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))
                                                                                          : Text("# Super Admin", style: TextStyle(fontSize: 11)),
                                                                                    ),
                                                                                    Text(" | "),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          (userCls!.userAccess_Level_Agent == '1')
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                        prefs.setInt('_groupValueSub', 0);
                                                                                        prefs.setString('PinNamaQuery', 'Agent');
                                                                                        setState(() {
                                                                                          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                                        });
                                                                                        // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                                      },
                                                                                      child: (PinNamaQuery == 'Agent') ? Text('# Agent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)) : Text("# Agent", style: TextStyle(fontSize: 11)),
                                                                                    ),
                                                                                    Text(" | "),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          (userCls!.userAccess_Level_HRAdmin == '1')
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                        prefs.setInt('_groupValueSub', 0);
                                                                                        prefs.setString('PinNamaQuery', 'Group HR/Admin');
                                                                                        setState(() {
                                                                                          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                                        });
                                                                                        // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                                      },
                                                                                      child: (PinNamaQuery == 'Group HR/Admin')
                                                                                          ? Text('# HR/Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))
                                                                                          : Text("# HR/Admin", style: TextStyle(fontSize: 11)),
                                                                                    ),
                                                                                    Text(" | "),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                              prefs.setInt('_groupValueSub', 0);
                                                                              prefs.setString('PinNamaQuery', 'Personal');
                                                                              setState(() {
                                                                                PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                              });
                                                                              // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                            },
                                                                            child: (PinNamaQuery == 'Personal' || PinNamaQuery == '')
                                                                                ? Text('# Personal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))
                                                                                : Text("# Personal", style: TextStyle(fontSize: 11)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        // SizedBox(height: 10),
                                        (userCls != null && userCls!.userAccess_Level == '2')
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child: Card(
                                                  color: Colors.blue.shade50,
                                                  surfaceTintColor: Colors.blue.shade50,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                    Text("Agent Tools: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                        prefs.setInt('_groupValueSub', 0);
                                                                        prefs.setString('PinNamaQuery', 'Agent');
                                                                        setState(() {
                                                                          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                        });
                                                                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                      },
                                                                      child: (PinNamaQuery == 'Agent') ? Text('# Agent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)) : Text("# Agent", style: TextStyle(fontSize: 11)),
                                                                    ),
                                                                    Text(" | "),
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                        prefs.setInt('_groupValueSub', 0);
                                                                        prefs.setString('PinNamaQuery', 'Group HR/Admin');
                                                                        setState(() {
                                                                          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                        });
                                                                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                      },
                                                                      child: (PinNamaQuery == 'Group HR/Admin') ? Text('# HR/Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)) : Text("# HR/Admin", style: TextStyle(fontSize: 11)),
                                                                    ),
                                                                    Text(" | ", style: TextStyle(fontSize: 11)),
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
                                                                      child: (PinNamaQuery == 'Personal' || PinNamaQuery == '')
                                                                          ? Text('# Personal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))
                                                                          : Text("# Personal", style: TextStyle(fontSize: 11)),
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
                                              )
                                            : Container(),
                                        // SizedBox(height: 10),
                                        (userCls != null && userCls!.userAccess_Level == '3')
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child: Card(
                                                  color: Colors.blue.shade50,
                                                  surfaceTintColor: Colors.blue.shade50,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                    Text('HR/Admin Tools: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                        prefs.setInt('_groupValueSub', 0);
                                                                        prefs.setString('PinNamaQuery', 'Group HR/Admin');
                                                                        setState(() {
                                                                          PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                                                                        });
                                                                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                                      },
                                                                      child: (PinNamaQuery == 'Group HR/Admin') ? Text('# HR/Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)) : Text("# HR/Admin", style: TextStyle(fontSize: 11)),
                                                                    ),
                                                                    Text(" | ", style: TextStyle(fontSize: 11)),
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
                                                                      child: (PinNamaQuery == 'Personal' || PinNamaQuery == '')
                                                                          ? Text('# Personal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))
                                                                          : Text("# Personal", style: TextStyle(fontSize: 11)),
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
                                              )
                                            : Container(),

                                        (PinNamaQuery == 'Superadmin')
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 8,
                                                  ),
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
                                                      // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
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
                                                    ),
                                                  ),
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
                                                  SizedBox(
                                                    height: 8,
                                                  ),
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
                                                      // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
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
                                                    ),
                                                  ),
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
                                                  SizedBox(
                                                    height: 8,
                                                  ),
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
                                                      // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
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
                                                    ),
                                                  ),
                                                  // _menuSuperAdmin(),
                                                  const Divider(
                                                    height: 10,
                                                    thickness: 1,
                                                    indent: 40,
                                                    endIndent: 40,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(''),
                                                  ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: listDb_UserGroup.length,
                                                    itemBuilder: (BuildContext context, int position) {
                                                      return InkWell(
                                                        onTap: () async {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => PageGroups(
                                                                        dataSource: 'Group HR/Admin',
                                                                        dataId: this.listDb_UserGroup[position].id,
                                                                        dataName: this.listDb_UserGroup[position].GroupName,
                                                                      )));
                                                        },
                                                        child: Container(
                                                          // color: ((position + 1).isOdd) ? Colors.grey.shade50 : Colors.transparent,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                                                            child: Row(
                                                              children: [
                                                                Text('${position + 1}) '),
                                                                Text('${this.listDb_UserGroup[position].GroupName}'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (userCls != null)
                    ? (userCls != null)
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (userCls == null)
                                        ? Container()
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Hi, ${userCls!.userUser_Name}',
                                                style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              (userCls!.userAccess_Level == '1' || userCls!.userAccess_Level_Agent == '1' || userCls!.userAccess_Level_HRAdmin == '1')
                                                  ? Container()
                                                  : Text(
                                                      'Account Type: PERSONAL',
                                                      style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                              (userCls!.userAccess_Level == '1')
                                                  ? Text(
                                                      'Account Type: SUPER ADMIN',
                                                      style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  : Container(),
                                              (userCls!.userAccess_Level == '0' && userCls!.userAccess_Level_Agent == '1')
                                                  ? Text(
                                                      'Account Type: AGENT',
                                                      style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  : Container(),
                                              (userCls!.userAccess_Level == '0' && userCls!.userAccess_Level_HRAdmin == '1')
                                                  ? Text(
                                                      'Account Type: HR/ADMIN',
                                                      style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                    Spacer(),
                                    (userCls == null)
                                        ? Container()
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showCupertinoDialog<void>(
                                                    context: context,
                                                    builder: (BuildContext context) => CupertinoAlertDialog(
                                                      title: Text('Sign Out'),
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
                                                child: Text('Sign Out', style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
                                              ),
                                              Text(
                                                'ID: ${userCls!.userId}',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // InkWell(
                                    //     onTap: () async {
                                    //       setState(() {
                                    //         // _currentIndex = 0;
                                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(tabIndex: 1)));
                                    //       });
                                    //     },
                                    //     child: Icon(
                                    //       Typicons.cog_outline,
                                    //       size: 30,
                                    //     )),
                                    // Text('  '),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Email: ${userCls!.userUser_Email}',
                                        //   style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                        //   maxLines: 2,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                        // Text(
                                        //   'Phone: ${userCls!.userUser_NoTel}',
                                        //   style: TextStyle(color: _color2, fontWeight: FontWeight.bold, fontSize: 12),
                                        //   maxLines: 1,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container()
                    : Container(),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 4),
          //   width: 1,
          //   height: 80,
          //   color: Colors.grey[300],
          // ),
          // Column(
          //   children: [
          //     SizedBox(
          //       height: 2,
          //     ),
          //     (userCls == null)
          //         ? Container()
          //         : Text(
          //             'ID: ${userCls!.userId}',
          //             style: TextStyle(fontSize: 10),
          //           ),
          //     GestureDetector(
          //       onTap: () {
          //         showCupertinoDialog<void>(
          //           context: context,
          //           builder: (BuildContext context) => CupertinoAlertDialog(
          //             title: Text('Sign Out'),
          //             content: Text('Are you sure?'),
          //             actions: <CupertinoDialogAction>[
          //               CupertinoDialogAction(
          //                 child: Text('No'),
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //               ),
          //               CupertinoDialogAction(
          //                 child: Text('Yes'),
          //                 isDestructiveAction: true,
          //                 onPressed: () {
          //                   context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
          //                 },
          //               )
          //             ],
          //           ),
          //         );
          //       },
          //       child: Text('Sign Out', style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
          //     ),
          //   ],
          // )
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
      // height: (_menuDataSuperAdmin.length > 1) ? 180 : 180,
      child: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 8),
        childAspectRatio: 1.6,
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 3,
        // scrollDirection: Axis.horizontal,
        children: List.generate(_menuDataSuperAdmin.length, (index) {
          return GestureDetector(
              onTap: () {
                if (index == 100) {
                  Fluttertoast.showToast(msg: 'Click ' + _menuDataSuperAdmin[index].name, toastLength: Toast.LENGTH_SHORT);
                }

                if (index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageUsers(
                                dataSource: '',
                                dataId: '',
                                dataName: '',
                              )));
                }
                if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageGroups(
                                dataSource: '',
                                dataId: '',
                                dataName: '',
                              )));
                }
                if (index == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PageThemes()));
                }
                if (index == 3) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PageLogMonitoring()));
                }
                if (index == 4) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PageSetSuperAdmin()));
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
                            : (listDb_UserDemoAll.length > 0)
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child: Text('All TapBiz Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  )
                                : Container(),
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
                                  if (userCls != null && userCls!.userUser_Email != null) {
                                    _getUserCheck();
                                    _listDb_UserDemo_ByUserid(userCls!.userId);
                                  }
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
        // loading_listCard = true;
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
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserTapBizModel> _listDataAll = [];
          for (int i = 0; i < listdataAll.length; i++) _listDataAll.add(UserTapBizModel.fromJson(listdataAll[i]));
          listDb_UserDemoAll = _listDataAll;
          listDb_UserDemoAllCount = _listDataAll.length;

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
                childAspectRatio: 0.7,
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
    final double profilePictureSize = MediaQuery.of(context).size.width / 12;
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 20,
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
              // Text('User_Theme: ${this.listDb_UserDemoAll[index].User_Theme}'),
              (this.listDb_UserDemoAll[index].themeCustomURL == '')
                  ? Container()
                  : (this.listDb_UserDemoAll[index].User_Theme == 0)
                      ? ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: this.listDb_UserDemoAll[index].themeCustomURL))
                      : Container(),
              (this.listDb_UserDemoAll[index].themeURL == '')
                  ? Container()
                  : (this.listDb_UserDemoAll[index].User_Theme == 1)
                      ? ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: this.listDb_UserDemoAll[index].themeURL))
                      : Container(),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        (this.listDb_UserDemoAll[index].imageURL != '')
                            ? Container(
                                width: profilePictureSize,
                                height: profilePictureSize,
                                child: GestureDetector(
                                  onTap: () {
                                    showCupertinoDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) => _viewiMage(this.listDb_UserDemoAll[index].imageURL),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    radius: profilePictureSize,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: profilePictureSize - 4,
                                      child: ClipOval(
                                        child: buildCacheNetworkImage(width: 50, height: 50, url: '${this.listDb_UserDemoAll[index].imageURL}'),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Image.asset(
                                'assets/devkit/images/placeholder.jpg',
                                width: profilePictureSize - 4,
                                fit: BoxFit.fill,
                              ),
                        Text('  '),
                        Expanded(
                          child: Text(
                            '${listDb_UserDemoAll[index].CardProfile}',
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listDb_UserDemoAll[index].User_Name.toUpperCase(),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${listDb_UserDemoAll[index].User_Title.toUpperCase()}',
                            style: TextStyle(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${listDb_UserDemoAll[index].User_Dept.toUpperCase()}',
                            style: TextStyle(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${listDb_UserDemoAll[index].User_Company.toUpperCase()}',
                            style: TextStyle(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
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

  Widget _viewiMage(String imageURL) {
    return CupertinoAlertDialog(
      title: Column(
        children: [(imageURL != '') ? buildCacheNetworkImage(width: 300, height: 300, url: '${imageURL}') : Container()],
      ),
      // content: Text('Are you sure?'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          child: Text('Close'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
