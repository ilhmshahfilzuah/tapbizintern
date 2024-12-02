import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show File, Platform, sleep;

import 'package:TapBiz/subui_tapbiz/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/records/well_known/uri.dart';
import 'package:ndef/utilities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../devkit/config/constant.dart';
import '../subconfig/AppSettings.dart';
import '../subdata/model/DbCategory_Model.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/model/user_model.dart';
import '../subdata/model/usergroupTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home_PageGroups_QRScanner.dart';
import 'home_subUserCard_Mngt.dart';
import 'ndef_record/raw_record_setting.dart';
import 'ndef_record/text_record_setting.dart';
import 'ndef_record/uri_record_setting.dart';

import 'package:universal_io/io.dart' as IO;

class PageGroups extends StatefulWidget {
  const PageGroups({
    Key? key,
    required this.dataSource,
    required this.dataId,
    required this.dataName,
  }) : super(key: key);
  final String dataSource;
  final String dataId;
  final String dataName;

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => PageGroups(
              dataSource: '',
              dataId: '',
              dataName: '',
            ));
    // return MaterialPageRoute<void>(builder: (_) => HomePage(tabIndex: 15));
  }

  @override
  _PageGroupsState createState() => _PageGroupsState();
}

class _PageGroupsState extends State<PageGroups> with SingleTickerProviderStateMixin {
  Color ColorAppBar = AppSettings.ColorMain;
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';

  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _tagSIRI;
  String? _result, _writeResult, _mifareResult;
  late TabController _tabSubController;
  List<ndef.NDEFRecord>? _records;

  String? CategoryGroup;
  String? CategoryidGroupQuery;

  int? _groupValue;
  String? userGroupidQuery;
  String? userGroupQuery;
  String? userQuery;
  String? userFlagdelQuery;
  String? userNFCTAGidQuery;
  String? userQueryAction;
  String? userQueryActionField;
  String? userQueryActionFieldName;

  String? actionQuery;
  String? actionTextQuery;

  String? jumGroupCard = '';
  String? jumGroupCard_New = '';
  String? jumGroupCard_DoneNFC = '';
  String? jumGroupCard_Pending = '';

  int? SleepDuration = 400;

  UserModel? userCls;

  String? userEmailSearchQuery;

  List<DbCategoryCls> listDb_CategoryGroup = [];
  int listDb_CategoryGroupCount = 0;

  List<UserGroupTapBizModel> listDb_UserGroup_setState = [];
  List<UserGroupTapBizModel> listDb_UserGroup = [];
  int listDb_UserGroupCount = 0;

  List<UserTapBizModel> listDb_UserDemo_setState = [];
  List<UserTapBizModel> listDb_UserDemo = [];

  int listDb_UserDemoCount = 0;

  List<UserModel> listDb_DataUserSearch = [];
  int listDb_DataUserSearchCount = 0;

  List<UserTapBizModel> listDb_DataByUserSearch = [];
  int listDb_DataByUserSearchCount = 0;

  List<UserTapBizModel> listDb_DataSearch = [];
  int listDb_DataSearchCount = 0;

  var loading = false;
  var loadingDel = false;

  var loadingListCard = false;

  // var loading_WritingNFC = false;

  String loading_WritingNFC = '-';
  int _writeLoading = 0;

  int? Groupid;
  String? Groupname;

  String CardAuth = '-';
  String CardType = '-';
  String Username = '-';
  String imageURL = '';
  String User_Name = '-';
  String User_IC = '-';
  String User_Birthday = '-';
  String User_Headline = '-';
  String User_Title = '-';
  String User_Dept = '-';
  String User_Company = '-';
  String User_Email = '-';
  String User_NoTel = '-';
  String User_WS = '-';
  String User_Telegram = '-';
  String User_X = '-';
  String User_FB = '-';
  String User_Instagram = '-';
  String User_TikTok = '-';
  String User_YouTube = '-';

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';

  File? _image;
  final _picker = ImagePicker();
  dynamic _selectedFile;

  var _formKey = GlobalKey<FormState>();

  String? navSearchView;
  String? navScanQRView;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? resultData;
  Barcode? resultScan;
  Barcode? scanData;

  String? resultSearch;

  TextEditingController controllerFilter = TextEditingController();
  String _searchResult = '';
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    _tabSubController.dispose();
    if (_selectedFile != null && _selectedFile!.existsSync()) {
      _selectedFile!.deleteSync();
    }
    _selectedFile = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getLocalData();
    if (widget.dataSource != '') {
      userGroupidQuery = widget.dataId.toString();
      userGroupQuery = widget.dataName;
      _listDb_GroupCard_ByGroupid(userGroupidQuery!).then((_) {
        // listDb_UserDemo = (this.listDb_UserDemo.where((dblist) => dblist.Username == this.listDb_DataByUserSearch[position].Username)).toList();
      });
    }
    navSearchView = '';
    resultData = '';
    userQuery = null;
    _listCategoryGroup();
    _listDb_Group();

    // userQuery = 'buck';
    // resultData = 'buck';
    // _searchResult = 'buck';
    // controllerFilter.text = _searchResult;
    // _getDb_GroupCard(resultData!).then((_) {});
    //-------
    //-------
    if (!kIsWeb)
      _platformVersion = '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    else
      _platformVersion = 'Web';
    initPlatformState();
    _tabSubController = new TabController(length: 2, vsync: this);
    _records = [];
  }

  Future<bool> _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CategoryidGroupQuery = prefs.getString('CategoryidGroupQuery') ?? '';
    setState(() {
      if (CategoryidGroupQuery == '') {
        prefs.setString('CategoryidGroupQuery', 'All');
        CategoryidGroupQuery = prefs.getString('CategoryidGroupQuery') ?? '';
      } else {
        CategoryidGroupQuery = CategoryidGroupQuery;
      }
    });

    return true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
      _availability = availability;
    });
  }

  //------------------PickUp Image
  //------------------PickUp Image
  // Future requestPermission(Permission permission) async {
  //   final result = await permission.request();
  //   return result;
  // }

  // void _askPermissionCamera() {
  //   requestPermission(Permission.camera).then(_onStatusRequestedCamera);
  // }

  // void _askPermissionStorage() {
  //   requestPermission(Permission.storage).then(_onStatusRequested);
  // }

  // void _askPermissionPhotos() {
  //   requestPermission(Permission.photos).then(_onStatusRequested);
  // }

  // void _onStatusRequested(status) {
  //   if (status != PermissionStatus.granted) {
  //     if (IO.Platform.isIOS) {
  //       openAppSettings();
  //     } else {
  //       if (status == PermissionStatus.permanentlyDenied) {
  //         openAppSettings();
  //       }
  //     }
  //   } else {
  //     _getImage(ImageSource.gallery);
  //   }
  // }

  // void _onStatusRequestedCamera(status) {
  //   if (status != PermissionStatus.granted) {
  //     if (IO.Platform.isIOS) {
  //       openAppSettings();
  //     } else {
  //       if (status == PermissionStatus.permanentlyDenied) {
  //         openAppSettings();
  //       }
  //     }
  //   } else {
  //     _getImage(ImageSource.camera);
  //   }
  // }

  // //------------------PickUp Image
  // Widget _getImageWidget() {
  //   final double profilePictureSize = MediaQuery.of(context).size.width / 4;
  //   if (_selectedFile != null) {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Image.file(
  //           _selectedFile!,
  //           width: profilePictureSize - 4,
  //           fit: BoxFit.fill,
  //         ),
  //       ],
  //     );
  //   } else {
  //     return Image.asset(
  //       'assets/devkit/images/placeholder.jpg',
  //       width: profilePictureSize - 4,
  //       fit: BoxFit.fill,
  //     );
  //   }
  // }

  // void _getImage(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source, maxWidth: 640, imageQuality: 100);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     }
  //   });

  //   if (_image != null) {
  //     this.setState(() {
  //       if (!kIsWeb) {
  //         if (_selectedFile != null && _selectedFile!.existsSync()) {
  //           _selectedFile!.deleteSync();
  //         }
  //       }
  //       if (kIsWeb) {
  //         _selectedFile = pickedFile;
  //       } else {
  //         _selectedFile = _image;
  //       }

  //       _image = null;
  //     });
  //   }
  // }

  // void _removeImage() async {
  //   setState(() {
  //     _selectedFile = null;
  //   });
  // }

  // void _removeImageServer() async {
  //   setState(() {
  //     imageURL = '';
  //   });
  // }

  // void compressImage(File file) async {
  //   final filePath = file.absolute.path;
  //   int lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  //   final splitted = filePath.substring(0, (lastIndex));
  //   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  //   final compressedImage = await FlutterImageCompress.compressAndGetFile(filePath, outPath, minWidth: 1000, minHeight: 1000, quality: 5);
  // }
  //------------------PickUp Image
  //------------------PickUp Image

  //---------------------
  Widget _buildQrView(BuildContext context, String scanStatus) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewIn,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewIn(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        resultScan = scanData;
        navScanQRView = '2';
      });
      // String cameraScanResult = utf8.decode(base64.decode(scanData.code!));
      String cameraScanResult = scanData.code!;
      cameraScanResult = cameraScanResult.replaceAll('https://tapcard.tapbiz.my/tc/', '');
      cameraScanResult = cameraScanResult.replaceAll('http://tapcard.tapbiz.my/tc/', '');
      setState(() {
        resultData = cameraScanResult;
      });
      _getDb_GroupCard(resultData!).then((_) {
        listDb_UserDemo_setState = (this.listDb_UserDemo.where((dblist) => dblist.Username == resultData)).toList();
      });

      // List<String> qRData = cameraScanResult.toString().split(",");
      // print(qRData);
      // if (qRData[0] == clinicId) {
      // Navigator.pushReplacement(
      //     context,
      //     new MaterialPageRoute(
      //         builder: (context) => MyEmployerClinicMainInres(
      //             clinicId,
      //             dateQuery.toString(),
      //             'menuQuery',
      //             scanStatus,
      //             qRData[0],
      //             qRData[1],
      //             userCls.userUser_Email,
      //             userCls.userUser_Name,
      //             userCls.userUser_IC,
      //             userCls.userUser_NoTel)));
      // } else {
      // _showAlertDialog('Status:', 'QR Code Not Valid For This Clinic');
      // }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double profilePictureSize = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      // backgroundColor: Colors.white,

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  //-------------
                  // leading: Builder(
                  //   builder: (context) => IconButton(icon: Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
                  // ),

                  //-------------
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  elevation: 0,
                  backgroundColor: ColorAppBar,

                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildCacheNetworkImage(height: 60, url: UIimageURL),
                      Spacer(),

                      InkWell(
                        onTap: () async {
                          setState(() {
                            resultSearch = null;
                            listDb_DataUserSearch = [];
                            listDb_DataByUserSearch = [];
                            listDb_DataSearch = [];
                            navSearchView = '1';
                            userQuery = null;
                            userFlagdelQuery = null;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              FontAwesome5.search,
                              // size: 40,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      Text(' | '),
                      InkWell(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                        },
                        child: Row(
                          children: [
                            Icon(
                              FontAwesome5.home,
                              // size: 40,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      // InkWell(
                      //     onTap: () async {
                      //       Navigator.pop(context);
                      //     },
                      //     child: Row(
                      //       children: [
                      //         Icon(
                      //           Icons.arrow_back_ios,
                      //           color: Colors.white,
                      //         ),
                      //         Text('Back ',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),),

                      //       ],
                      //     ))
                      // InkWell(
                      //   onTap: () async {
                      //     setState(() {
                      //       navScanQRView = '1';
                      //     });
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         'Scan QR Data ',
                      //         style: TextStyle(fontSize: 12, color: Colors.white),
                      //       ),
                      //       Icon(
                      //         FontAwesome5.qrcode,
                      //         // size: 40,
                      //         color: Colors.white,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // InkWell(
                      //     onTap: () async {
                      //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                      //     },
                      //     child: Icon(
                      //       Icons.home,
                      //       color: Colors.white,
                      //     ))
                    ],
                  ),
                ),
              ];
            },
            body: (navSearchView == '1' || navScanQRView == '1')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (navSearchView == '1' && navScanQRView != '1')
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5.0),
                                  Text(
                                    'SEARCH DATA',
                                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        resultSearch = null;
                                        listDb_DataUserSearch = [];
                                        listDb_DataByUserSearch = [];
                                        listDb_DataSearch = [];
                                        navSearchView = null;
                                      });
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
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              navSearchView = '0';
                                              navScanQRView = '1';
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Scan QR Data ',
                                                style: TextStyle(fontSize: 12, color: Colors.black),
                                              ),
                                              Icon(
                                                FontAwesome5.qrcode,
                                                // size: 40,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ------------------
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: _searchForm(),
                                  ),
                                  (loading)
                                      ? Container()
                                      : SizedBox(
                                          height: 30,
                                        ),
                                  (loading)
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
                                      : (listDb_DataUserSearch.length > 0 || listDb_DataSearch.length > 0)
                                          ? Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                child: Column(
                                                  children: [
                                                    Text('Result....'),
                                                    InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            resultSearch = null;
                                                            listDb_DataUserSearch = [];
                                                            listDb_DataByUserSearch = [];
                                                            listDb_DataSearch = [];
                                                          });
                                                        },
                                                        child: Text('[Clear Result]')),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    (userEmailSearchQuery == null)
                                                        ? Expanded(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'TapBiz Account',
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                      ),
                                                                      Expanded(
                                                                        child: (userEmailSearchQuery == null && listDb_DataUserSearch.length > 0) ? SizedBox(width: 200, child: getListViewBuilder_DataUserSearch()) : Container(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'TapBiz Card',
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                      ),
                                                                      Expanded(
                                                                        child: (userEmailSearchQuery == null && listDb_DataSearch.length > 0) ? SizedBox(width: 200, child: getListViewBuilder_DataSearch()) : Container(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                    (userEmailSearchQuery != null)
                                                        ? Column(
                                                            children: [
                                                              SizedBox(height: 20),
                                                              InkWell(
                                                                  onTap: () async {
                                                                    setState(() {
                                                                      userEmailSearchQuery = null;
                                                                      listDb_DataByUserSearch = [];
                                                                    });
                                                                  },
                                                                  child: Text('Close')),
                                                            ],
                                                          )
                                                        : Container(),
                                                    // ----------------------
                                                    (userEmailSearchQuery != null && listDb_DataByUserSearch.length > 0)
                                                        ? Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(child: Text('TapBiz Account: $userEmailSearchQuery', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  'TapBiz Card',
                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                                Expanded(child: SizedBox(width: 200, child: getListViewBuilder_DataByUserSearch())),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                    // ----------------------
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                (resultSearch != null) ? Text('$resultSearch') : Container(),
                                              ],
                                            ),
                                  // ------------------
                                ],
                              ),
                            )
                          : Container(),
                      (navSearchView != '1' && navScanQRView == '1') ? Expanded(flex: 4, child: _buildQrView(context, 'scanIn')) : Container(),
                    ],
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // ---------------------------------------------------ListView
                      // ---------------------------------------------------ListView
                      (resultData == '')
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('QR Data: $resultData'),
                                  (Groupid == 0)
                                      ? Row(
                                          children: [
                                            Text('No Card found    '),
                                            InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  resultData = '';
                                                  userGroupidQuery = null;
                                                  userGroupQuery = null;

                                                  actionQuery = null;
                                                  actionTextQuery = null;
                                                  dataObj = '';
                                                  dataObjController.text = '';
                                                });
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
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                      // ---------------------------------------------------ListView
                      // ---------------------------------------------------ListView
                      (userQuery == null)
                          ? Column(
                              children: [
                                // --------------
                                (userGroupQuery == null)
                                    ? (resultData != '')
                                        ? Container()
                                        : Column(
                                            children: [
                                              (actionQuery == null)
                                                  ? Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text('GROUPS MNGT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                              Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                child: _searchForm(),
                                              ),
                                              (loading)
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
                                                  : (listDb_DataUserSearch.length > 0 || listDb_DataSearch.length > 0)
                                                      ? Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                            child: Column(
                                                              children: [
                                                                Text('Result....'),
                                                                InkWell(
                                                                    onTap: () async {
                                                                      setState(() {
                                                                        resultSearch = null;
                                                                        listDb_DataUserSearch = [];
                                                                        listDb_DataByUserSearch = [];
                                                                        listDb_DataSearch = [];
                                                                      });
                                                                    },
                                                                    child: Text('[Clear Result]')),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                (userEmailSearchQuery == null)
                                                                    ? Expanded(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    'TapBiz Account',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: (userEmailSearchQuery == null && listDb_DataUserSearch.length > 0) ? SizedBox(width: 200, child: getListViewBuilder_DataUserSearch()) : Container(),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    'TapBiz Card',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: (userEmailSearchQuery == null && listDb_DataSearch.length > 0) ? SizedBox(width: 200, child: getListViewBuilder_DataSearch()) : Container(),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                (userEmailSearchQuery != null)
                                                                    ? Column(
                                                                        children: [
                                                                          SizedBox(height: 20),
                                                                          InkWell(
                                                                              onTap: () async {
                                                                                setState(() {
                                                                                  userEmailSearchQuery = null;
                                                                                  listDb_DataByUserSearch = [];
                                                                                });
                                                                              },
                                                                              child: Text('Close')),
                                                                        ],
                                                                      )
                                                                    : Container(),
                                                                // ----------------------
                                                                (userEmailSearchQuery != null && listDb_DataByUserSearch.length > 0)
                                                                    ? Expanded(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Expanded(child: Text('TapBiz Account: $userEmailSearchQuery', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            Text(
                                                                              'TapBiz Card',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                            ),
                                                                            Expanded(child: SizedBox(width: 200, child: getListViewBuilder_DataByUserSearch())),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                // ----------------------
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Column(
                                                          children: [
                                                            (resultSearch != null) ? Text('$resultSearch') : Container(),
                                                          ],
                                                        ),
                                              Row(
                                                children: [
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        actionQuery = 'AddGroup';
                                                      });
                                                    },
                                                    child: Card(
                                                      surfaceTintColor: AppSettings.ColorUnderline2,
                                                      elevation: 1,
                                                      // color: Colors.grey.shade200,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Create Group ',
                                                              style: TextStyle(color: AppSettings.ColorMain),
                                                            ),
                                                            Icon(
                                                              Typicons.plus_outline,
                                                              size: 20,
                                                              color: AppSettings.ColorMain,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              (actionQuery == 'AddGroup')
                                                  ? Column(
                                                      children: [
                                                        Text('Create Group'),
                                                        // ------------------
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                          child: _addForm(),
                                                        ),
                                                        // ------------------
                                                      ],
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Card(
                                                          surfaceTintColor: AppSettings.ColorUnderline2,
                                                          elevation: 10,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'LIST GROUPS',
                                                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text('${listDb_UserGroup.length} - ${listDb_UserGroup_setState.length}'),
                                                                    Text(
                                                                      'Filter By: ',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                    _GroupCategory(),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                getListViewBuilder_Group(),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                            ],
                                          )
                                    : Container(),
                                (loading)
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
                                    : (userGroupQuery != null)
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('GROUPS MNGT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 6,
                                                      child: Text(
                                                        'GROUP: $userGroupQuery',
                                                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (widget.dataSource == 'Group HR/Admin') {
                                                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                        } else {
                                                          setState(() {
                                                            resultData = '';
                                                            userGroupidQuery = null;
                                                            userGroupQuery = null;

                                                            actionQuery = null;
                                                            actionTextQuery = null;
                                                            dataObj = '';
                                                            dataObjController.text = '';
                                                          });
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text('Close Group '),
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
                                              (resultData != '')
                                                  ? Container()
                                                  : (userGroupQuery == 'Demo' || userGroupQuery == 'Demo TAP ID' || userGroupQuery == 'Demo TAP VISITOR')
                                                      ? Container()
                                                      : (actionQuery == null)
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          (widget.dataSource == 'Group HR/Admin')
                                                                              ? Container()
                                                                              : Card(
                                                                                  color: Colors.blue.shade50,
                                                                                  elevation: 10,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Container(
                                                                                      // height: 200,
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text('STATISTIK - NFC Status'),
                                                                                          Text('   All: ${this.listDb_UserDemo.length}'),
                                                                                          Text('   Total New: $jumGroupCard_New'),
                                                                                          Text('   Total Done NFC: $jumGroupCard_DoneNFC'),
                                                                                          // Text('   Total Pending: $jumGroupCard_Pending'),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          Text(''),
                                                                        ],
                                                                      ),
                                                                      Spacer(),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          (widget.dataSource == 'Group HR/Admin')
                                                                              ? Container()
                                                                              : InkWell(
                                                                                  onTap: () async {
                                                                                    setState(() {
                                                                                      actionQuery = 'AddCard';
                                                                                    });
                                                                                  },
                                                                                  child: Card(
                                                                                    surfaceTintColor: AppSettings.ColorUnderline2,
                                                                                    elevation: 1,
                                                                                    // color: Colors.grey.shade200,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            'Create Card ',
                                                                                            style: TextStyle(color: AppSettings.ColorMain),
                                                                                          ),
                                                                                          Icon(
                                                                                            Typicons.plus_outline,
                                                                                            size: 20,
                                                                                            color: AppSettings.ColorMain,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          SizedBox(
                                                                            height: 8,
                                                                          ),
                                                                          const Divider(
                                                                            height: 10,
                                                                            thickness: 1,
                                                                            indent: 10,
                                                                            endIndent: 10,
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                              (actionQuery == 'AddCard')
                                                  ? Column(
                                                      children: [
                                                        Text('Add Card'),
                                                        // ------------------
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                                          child: _addForm(),
                                                        ),
                                                        // ------------------
                                                      ],
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Card(
                                                          surfaceTintColor: AppSettings.ColorUnderline2,
                                                          elevation: 10,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            // padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                                                            child: (listDb_UserDemo.length == 0)
                                                                ? (resultData != '')
                                                                    ? Container()
                                                                    : (loadingListCard)
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
                                                                              Text(
                                                                                'No Card recorded under this Group',
                                                                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 4,
                                                                              ),
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    showCupertinoDialog<void>(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) => CupertinoAlertDialog(
                                                                                        title: Text('Delete Group'),
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
                                                                                              // -------
                                                                                              _delDb_Group(userGroupQuery!).then((_) {
                                                                                                _listDb_Group().then((_) {
                                                                                                  setState(() {
                                                                                                    userGroupidQuery = null;
                                                                                                    userGroupQuery = null;

                                                                                                    actionQuery = null;
                                                                                                    actionTextQuery = null;
                                                                                                    dataObj = '';
                                                                                                    dataObjController.text = '';
                                                                                                  });
                                                                                                  Navigator.pop(context);
                                                                                                });
                                                                                              });
                                                                                              // -------
                                                                                            },
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  child: Text('Delete Group'))
                                                                            ],
                                                                          )
                                                                : Column(
                                                                    children: [
                                                                      (resultData != '')
                                                                          ? Container()
                                                                          : Text(
                                                                              'ALL CARDS',
                                                                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                      SizedBox(
                                                                        height: 4,
                                                                      ),
                                                                      //-----------------Carian
                                                                      SizedBox(
                                                                        // height: 30
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(4.0),
                                                                          child: new ListTile(
                                                                            visualDensity: VisualDensity(vertical: 3),
                                                                            dense: true,
                                                                            leading: new Icon(Icons.search),
                                                                            title: new TextField(
                                                                                controller: controllerFilter,
                                                                                decoration: new InputDecoration(hintText: 'Search Name', border: InputBorder.none),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    _searchResult = value;
                                                                                    listDb_UserDemo_setState = listDb_UserDemo.where((user) => user.User_Name.toLowerCase().contains(_searchResult)).toList();
                                                                                  });
                                                                                }),
                                                                            trailing: new IconButton(
                                                                              icon: new Icon(Icons.cancel),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  controllerFilter.clear();
                                                                                  _searchResult = '';
                                                                                  listDb_UserDemo_setState = listDb_UserDemo;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      //-----------------Carian
                                                                      (widget.dataSource == 'Group HR/Admin')
                                                                          ?
                                                                          // Container():
                                                                          getListViewBuilder_GroupCard_ByGroupHRAdmin()
                                                                          : getListViewBuilder_GroupCard(),
                                                                    ],
                                                                  ),
                                                          )),
                                                    ),
                                            ],
                                          )
                                        : Container(),
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
                                    Text(
                                      'Group: $userGroupQuery',
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              (userNFCTAGidQuery == null || userFlagdelQuery == 'Yes')
                                                  ? showCupertinoDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) => CupertinoAlertDialog(
                                                        title: Text('Delete'),
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
                                                              Navigator.pop(context);

                                                              // -------
                                                              _delDb_GroupCard(userQuery!).then((_) {
                                                                setState(() {
                                                                  userFlagdelQuery = null;
                                                                  loadingDel = false;
                                                                  userQuery = null;
                                                                  listDb_UserDemo_setState = [];
                                                                });
                                                                _listDb_GroupCard_ByGroupid(userGroupidQuery!).then((_) {});
                                                              });

                                                              // -------
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : null;
                                            },
                                            child: Card(
                                              surfaceTintColor: (userFlagdelQuery == 'Yes') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Typicons.trash,
                                                      size: 20,
                                                      color: (userFlagdelQuery == 'Yes') ? Colors.black : Colors.grey.shade400,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(' | '),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                userQuery = null;
                                                userFlagdelQuery = null;
                                                _listDb_GroupCard_ByGroupid(userGroupidQuery!);
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
                                    (widget.dataSource == 'Group HR/Admin') ? PageUserCard_Mngt(parentQuery: 'Home', userQuery: userQuery!) : PageUserCard_Mngt(parentQuery: '', userQuery: userQuery!),
                                  ],
                                )
                      // ---------------------------------------------------ListView
                    ],
                  )),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   final double profilePictureSize = MediaQuery.of(context).size.width / 4;
  //   return ;
  // }

  Widget _searchForm() {
    userQueryActionFieldName = 'Username / Email';

    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 30),
          // Text('$userQueryActionField'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    minLines: 1, //Normal textInputField will be displayed
                    // maxLines: 6, // when user presses enter it will adapt to it
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
                      // updateObj();
                    },
                  ),
                ),
              ),
              Text(' '),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // navSearchView = null;
                      userEmailSearchQuery = null;
                      listDb_DataByUserSearch = [];
                    });
                    _getDb_Search(dataObj).then((_) {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    });
                  },
                  child: SizedBox(
                    height: 60,
                    child: Card(
                      color: AppSettings.ColorMain,
                      surfaceTintColor: AppSettings.ColorMain,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      navSearchView = '0';
                      navScanQRView = '1';
                    });
                  },
                  child: SizedBox(
                    height: 60,
                    child: Card(
                      color: AppSettings.ColorMain,
                      surfaceTintColor: AppSettings.ColorMain,
                      child: Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // (actionTextQuery == null) ? Container() : Text('$actionTextQuery'),
          // Text('  '),
          // Row(
          //   children: [
          //     Expanded(
          //       child: SizedBox(
          //         height: 25,
          //         child: ElevatedButton(
          //           style: ButtonStyle(
          //             backgroundColor: MaterialStateProperty.resolveWith((states) {
          //               return AppSettings.ColorMain;
          //               // return Colors.grey;
          //             }),
          //           ),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(
          //                 Icons.search,
          //                 color: Colors.white,
          //                 size: 20,
          //               ),
          //               SizedBox(
          //                 width: 4.0,
          //               ),
          //               Text("Search", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
          //             ],
          //           ),
          //           onPressed: () {
          //             setState(() {
          //               // navSearchView = null;
          //               userEmailSearchQuery = null;
          //               listDb_DataByUserSearch = [];
          //             });
          //             // _getDb_Search(dataObj).then((_) {
          //             //   SystemChannels.textInput.invokeMethod('TextInput.hide');
          //             // });
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _searchFormxxx() {
    userQueryActionFieldName = 'Name, Email, Username';

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
              // maxLines: 6, // when user presses enter it will adapt to it
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
          Text('  '),
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
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("Search", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        // navSearchView = null;
                        userEmailSearchQuery = null;
                        listDb_DataByUserSearch = [];
                      });
                      _getDb_Search(dataObj).then((_) {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
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

  Widget _addForm() {
    userQueryActionFieldName = '';
    if (actionQuery == 'AddGroup') {
      userQueryActionFieldName = 'GROUP NAME';
    }
    if (actionQuery == 'AddCard') {
      userQueryActionFieldName = 'CARD ID';
    }

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
          Text('  '),
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
                          size: 14,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("Add", style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        actionTextQuery = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (actionQuery == 'AddGroup') {
                          _addDb_Group();
                        }
                        if (actionQuery == 'AddCard') {
                          _addDb_GroupCard();
                        }
                      }
                    },
                  ),
                ),
              ),
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
                          size: 14,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        actionTextQuery = null;
                        if (actionQuery == 'AddGroup') {
                          // _listDb_GroupCard_ByGroupid(userGroupidQuery!);
                        }
                        if (actionQuery == 'AddCard') {
                          _listDb_GroupCard_ByGroupid(userGroupidQuery!);
                        }
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

  ListView getListViewBuilder_Group() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_UserGroup_setState.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 10,
          surfaceTintColor: (this.listDb_UserGroup_setState[position].GroupCategory == 'Activated') ? AppSettings.ColorMain : AppSettings.ColorUnderline2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    // _getDb_GroupCard(this.listDb_UserDemo[position].Username);
                    setState(() {
                      userGroupidQuery = this.listDb_UserGroup_setState[position].id;
                      userGroupQuery = this.listDb_UserGroup_setState[position].GroupName;
                      _listDb_GroupCard_ByGroupid(this.listDb_UserGroup_setState[position].id);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${position + 1}. ${this.listDb_UserGroup_setState[position].GroupName}',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Category: ${this.listDb_UserGroup_setState[position].GroupCategory}',
                              style: TextStyle(color: Colors.black, fontSize: 10),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Group ID: ${this.listDb_UserGroup_setState[position].id}',
                              style: TextStyle(color: Colors.black, fontSize: 10),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      showCupertinoDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoAlertDialog(
                                          title: Column(
                                            children: [
                                              Text('Renew Activation Code'),
                                              Text('Under Construction'),
                                            ],
                                          ),
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
                                                // -------
                                                // _delDb_Group(userGroupQuery!).then((_) {
                                                //   _listDb_Group_setState().then((_) {
                                                //     setState(() {
                                                //       userGroupidQuery = null;
                                                //       userGroupQuery = null;

                                                //       actionQuery = null;
                                                //       actionTextQuery = null;
                                                //       dataObj = '';
                                                //       dataObjController.text = '';
                                                //     });
                                                Navigator.pop(context);
                                                //   });
                                                // });
                                                // -------
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Typicons.loop_outline,
                                      size: 16,
                                    )),
                                Text(
                                  '      Activation Code: ${this.listDb_UserGroup_setState[position].GroupActivationCode}',
                                  style: TextStyle(color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${this.listDb_UserGroup[position].TotalUser}  ',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Typicons.vcard,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            Text(
                              ' ',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {},
                      child: Card(
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Typicons.edit,
                                  size: 12,
                                  color: Colors.green,
                                ),
                                Text(' Group Info', style: TextStyle(color: Colors.green, fontSize: 10)),
                              ],
                            ),
                          )),
                    ),
                    // Spacer(),
                    // InkWell(
                    //   onTap: () async {},
                    //   child: Card(
                    //       surfaceTintColor: AppSettings.ColorUnderline2,
                    //       elevation: 10,
                    //       child: Padding(
                    //         padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    //         child: Text('Edit Group', style: TextStyle(color: Colors.green, fontSize: 10)),
                    //       )),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView getListViewBuilder_GroupCard_ByGroupHRAdmin() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_UserDemo_setState.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 10,
          surfaceTintColor: (this.listDb_UserDemo_setState[position].NFCTAGid == '-') ? AppSettings.ColorUnderline2 : Colors.amber.shade100,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      userQuery = this.listDb_UserDemo_setState[position].Username;
                      userFlagdelQuery = this.listDb_UserDemo_setState[position].Flagdel;
                      userNFCTAGidQuery = this.listDb_UserDemo_setState[position].NFCTAGid;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (this.listDb_UserDemo_setState[position].imageURL == '')
                          ? Expanded(
                              flex: 2,
                              child: Text(
                                '${position + 1}',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${position + 1}',
                                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Card(
                                      surfaceTintColor: AppSettings.ColorUnderline2,
                                      elevation: 20,
                                      child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: 50, url: this.listDb_UserDemo_setState[position].imageURL))),
                                ],
                              )),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   'CARD ID: ${this.listDb_UserDemo_setState[position].Username}',
                            //   style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                            // ),
                            (this.listDb_UserDemo_setState[position].User_Name == '')
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CARD NAME: ',
                                        style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Typicons.warning,
                                        size: 13,
                                        color: Colors.red,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'NAME: ${this.listDb_UserDemo_setState[position].User_Name.toUpperCase()}',
                                          style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'EMAIL: ${this.listDb_UserDemo_setState[position].User_Mail}',
                                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Phone: ${this.listDb_UserDemo_setState[position].User_NoTel}',
                              style: TextStyle(color: Colors.black, fontSize: 11),
                            ),
                            // Text(
                            //   'Type: ${this.listDb_UserDemo_setState[position].CardType}',
                            //   style: TextStyle(color: Colors.black, fontSize: 11),
                            // ),
                            // Text(
                            //   'NFC Tag Serial No: ${this.listDb_UserDemo_setState[position].NFCTAGid}',
                            //   style: TextStyle(color: Colors.black, fontSize: 11),
                            // ),

                            // (this.listDb_UserDemo_setState[position].CardType == 'tapcard')
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            //           Text('https://tapcard.tapbiz.my/tc/${this.listDb_UserDemo_setState[position].Username}', style: TextStyle(fontSize: 10)),
                            //         ],
                            //       )
                            //     : Container(),
                            // (this.listDb_UserDemo_setState[position].CardType == 'tapid')
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            //           Text('https://tapid.tapbiz.my/ti/${this.listDb_UserDemo_setState[position].Username}', style: TextStyle(fontSize: 10)),
                            //         ],
                            //       )
                            //     : Container(),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Row(
                            //   children: [
                            //     Icon(
                            //       Typicons.key_outline,
                            //       size: 14,
                            //     ),
                            //     Text(
                            //       ': ${this.listDb_UserDemo_setState[position].CardAuth}',
                            //       style: TextStyle(color: (this.listDb_UserDemo_setState[position].CardAuth == 'Yes') ? Colors.black : Colors.red, fontSize: 11),
                            //     ),
                            //   ],
                            // ),
                            (this.listDb_UserDemo_setState[position].CardAuth == 'Yes')
                                ? Icon(
                                    Typicons.lock_filled,
                                    size: 14,
                                  )
                                : Icon(
                                    Typicons.lock_open,
                                    size: 14,
                                  ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'TP: ${this.listDb_UserDemo_setState[position].UserCounter_View}',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'SC: ${this.listDb_UserDemo_setState[position].UserCounter_SaveContact}',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView getListViewBuilder_GroupCard() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_UserDemo_setState.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 10,
          surfaceTintColor: (this.listDb_UserDemo_setState[position].NFCTAGid == '-')
              ? AppSettings.ColorUnderline2
              : (this.listDb_UserDemo_setState[position].Username != this.listDb_UserDemo_setState[position].User_Email)
                  ? AppSettings.ColorMain
                  : Colors.blue.shade100,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      userQuery = this.listDb_UserDemo_setState[position].Username;
                      userFlagdelQuery = this.listDb_UserDemo_setState[position].Flagdel;
                      userNFCTAGidQuery = this.listDb_UserDemo_setState[position].NFCTAGid;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (this.listDb_UserDemo_setState[position].themeURL == '')
                          ? Expanded(
                              flex: 2,
                              child: Text(
                                '${position + 1}',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${position + 1}',
                                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Card(
                                      surfaceTintColor: AppSettings.ColorUnderline2,
                                      elevation: 20,
                                      child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: 50, url: this.listDb_UserDemo_setState[position].imageURL))),
                                ],
                              )),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   'CARD ID: ${this.listDb_UserDemo_setState[position].Username}',
                            //   style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                            // ),
                            (this.listDb_UserDemo_setState[position].User_Name == '')
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CARD NAME: ',
                                        style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Typicons.warning,
                                        size: 13,
                                        color: Colors.red,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'CARD NAME: ${this.listDb_UserDemo_setState[position].User_Name.toUpperCase()}',
                                          style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'ACC ID: ${this.listDb_UserDemo_setState[position].Userid}',
                                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'ACC EMAIL: ${this.listDb_UserDemo_setState[position].User_Email}',
                                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Card ID: ${this.listDb_UserDemo_setState[position].Username}',
                              style: TextStyle(color: Colors.black, fontSize: 11),
                            ),
                            // Text(
                            //   'Type: ${this.listDb_UserDemo_setState[position].CardType}',
                            //   style: TextStyle(color: Colors.black, fontSize: 11),
                            // ),
                            Text(
                              'NFC Tag Serial No: ${this.listDb_UserDemo_setState[position].NFCTAGid}',
                              style: TextStyle(color: Colors.black, fontSize: 11),
                            ),

                            // (this.listDb_UserDemo_setState[position].CardType == 'tapcard')
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            //           Text('https://tapcard.tapbiz.my/tc/${this.listDb_UserDemo_setState[position].Username}', style: TextStyle(fontSize: 10)),
                            //         ],
                            //       )
                            //     : Container(),
                            // (this.listDb_UserDemo_setState[position].CardType == 'tapid')
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            //           Text('https://tapid.tapbiz.my/ti/${this.listDb_UserDemo_setState[position].Username}', style: TextStyle(fontSize: 10)),
                            //         ],
                            //       )
                            //     : Container(),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Row(
                            //   children: [
                            //     Icon(
                            //       Typicons.key_outline,
                            //       size: 14,
                            //     ),
                            //     Text(
                            //       ': ${this.listDb_UserDemo_setState[position].CardAuth}',
                            //       style: TextStyle(color: (this.listDb_UserDemo_setState[position].CardAuth == 'Yes') ? Colors.black : Colors.red, fontSize: 11),
                            //     ),
                            //   ],
                            // ),
                            (this.listDb_UserDemo_setState[position].CardAuth == 'Yes')
                                ? Icon(
                                    Typicons.lock_filled,
                                    size: 14,
                                  )
                                : Icon(
                                    Typicons.lock_open,
                                    size: 14,
                                  ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'TP: ${this.listDb_UserDemo_setState[position].UserCounter_View}',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'SC: ${this.listDb_UserDemo_setState[position].UserCounter_SaveContact}',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                ),
                (loading_WritingNFC != '-' && loading_WritingNFC == this.listDb_UserDemo_setState[position].Username)
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
                    : Container(),
                (_writeLoading == position + 1)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Tap NFC tag to Phone....."),
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _writeLoading = 0;
                                      });
                                    },
                                    child: Text("Cancel")),
                              ],
                            ),
                            Text(''),
                            SizedBox(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black26,
                                valueColor: new AlwaysStoppedAnimation<Color>(AppSettings.ColorMain),
                              ),
                              //height: 20.0,
                              width: 50.0,
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // InkWell(
                          //   onTap: () async {},
                          //   child: Card(
                          //       surfaceTintColor: AppSettings.ColorUnderline2,
                          //       elevation: 10,
                          //       child: Padding(
                          //         padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          //         child: Text('Change Group', style: TextStyle(color: Colors.green, fontSize: 10)),
                          //       )),
                          // ),
                          InkWell(
                            onTap: () async {},
                            child: Card(
                                surfaceTintColor: AppSettings.ColorUnderline2,
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Typicons.loop,
                                        size: 12,
                                        color: Colors.green,
                                      ),
                                      Text(' Transfer Card To Another Group', style: TextStyle(color: Colors.green, fontSize: 10)),
                                    ],
                                  ),
                                )),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                // _updateDb_GroupCard(this.listDb_UserDemo_setState[position].Username, 'NFCTAGid', (position+1).toString(), null);
                                // this.listDb_UserDemo_setState[position].NFCTAGid = (position + 1).toString();
                                // jumGroupCard_New = (this.listDb_UserDemo_setState.where((dblist) => dblist.NFCTAGid == '-').length).toString();
                                // jumGroupCard_DoneNFC = (this.listDb_UserDemo_setState.where((dblist) => dblist.NFCTAGid != '-').length).toString();
                                // jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();
                              });
                              // ---------------
                              _records = [];
                              String _url = 'tapcard.tapbiz.my/tc/${this.listDb_UserDemo_setState[position].Username}';
                              if (CardType == 'tapid') {
                                _url = 'tapid.tapbiz.my/ti/${this.listDb_UserDemo_setState[position].Username}';
                              }
                              UriRecord uriRecord = ndef.UriRecord(
                                prefix: "https://",
                                content: _url,
                              );
                              _records?.add(uriRecord);
                              setState(() {
                                _writeLoading = position + 1;
                              });
                              // --------------
                              if (_records!.length != 0) {
                                try {
                                  NFCTag tag = await FlutterNfcKit.poll();
                                  setState(() {
                                    _tag = tag;
                                    _tagSIRI = tag.id;
                                  });
                                  if (tag.type == NFCTagType.mifare_ultralight || tag.type == NFCTagType.mifare_classic || tag.type == NFCTagType.iso15693) {
                                    String tagId = tag.id;

                                    //TODO: Check/Verify tagId is allowed to use or not.

                                    String version = await FlutterNfcKit.transceive("60");
                                    // String isPasswordProtected = await FlutterNfcKit.transceive("1B01020304");

                                    await FlutterNfcKit.writeNDEFRecords(_records!);
                                    setState(() {
                                      _writeResult = 'OK';
                                      _updateDb_GroupCard(this.listDb_UserDemo_setState[position].Username, 'NFCTAGid', _tagSIRI.toString(), null);
                                      this.listDb_UserDemo_setState[position].NFCTAGid = _tagSIRI!;
                                      jumGroupCard_New = (this.listDb_UserDemo_setState.where((dblist) => dblist.NFCTAGid == '-').length).toString();
                                      jumGroupCard_DoneNFC = (this.listDb_UserDemo_setState.where((dblist) => dblist.NFCTAGid != '-').length).toString();
                                      jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();
                                    });
                                  } else {
                                    setState(() {
                                      _writeResult = 'error: NDEF not supported: ${tag.type}';
                                      this.listDb_UserDemo_setState[position].NFCTAGid = '-';
                                    });
                                  }
                                } catch (e, stacktrace) {
                                  setState(() {
                                    _writeResult = 'error: $e';
                                    this.listDb_UserDemo_setState[position].NFCTAGid = '-';
                                  });
                                  print(stacktrace);
                                } finally {
                                  sleep(new Duration(milliseconds: SleepDuration!));
                                  await FlutterNfcKit.finish();

                                  showCupertinoDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        String _content = '';
                                        if (_writeResult == 'OK') {
                                          _content = "Successfully updated the name card - $_tagSIRI";
                                        } else {
                                          _content = "No NFC Tag Detected, Pls try again";
                                        }
                                        return CupertinoAlertDialog(
                                          title: Text('Status'),
                                          content: Text('${_content}'),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              child: Text('OK'),
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                setState(() {
                                                  _writeLoading = 0;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              } else {
                                setState(() {
                                  _writeResult = 'error: No record';
                                  _writeLoading = 0;
                                });
                              }
                              // --------------
                            },
                            child: Card(
                                surfaceTintColor: AppSettings.ColorUnderline2,
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                  child: Text('Write To NFC Tag', style: TextStyle(color: Colors.black, fontSize: 10)),
                                )),
                          )
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _GroupCategory() {
    return Container(
      // height: (_menuDataSuperAdmin.length > 1) ? 180 : 180,
      child: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 8),
        childAspectRatio: 1.0,
        shrinkWrap: true,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        crossAxisCount: 4,
        // scrollDirection: Axis.horizontal,
        children: List.generate(listDb_CategoryGroup.length, (index) {
          int TotalGroup = 0;
          if (this.listDb_CategoryGroup[index].CategoryId == '1') {
            TotalGroup = listDb_UserGroup.length;
          } else {
            TotalGroup = (this.listDb_UserGroup.where((dblist) => dblist.GroupCategoryid == this.listDb_CategoryGroup[index].CategoryId)).length;
          }

          return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString('CategoryidGroupQuery', this.listDb_CategoryGroup[index].CategoryId);
                  CategoryidGroupQuery = prefs.getString('CategoryidGroupQuery') ?? '';
                  if (CategoryidGroupQuery == '1') {
                    listDb_UserGroup_setState = listDb_UserGroup;
                  } else {
                    listDb_UserGroup_setState = (this.listDb_UserGroup.where((dblist) => dblist.GroupCategoryid == CategoryidGroupQuery)).toList();
                  }
                });
              },
              child: Column(children: [
                Flexible(
                  child: Card(
                    color: (CategoryidGroupQuery == this.listDb_CategoryGroup[index].CategoryId) ? AppSettings.ColorMain : Colors.white,
                    surfaceTintColor: (CategoryidGroupQuery == this.listDb_CategoryGroup[index].CategoryId) ? AppSettings.ColorMain : Colors.white,
                    // margin: EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            '$TotalGroup',
                            style: TextStyle(
                              // color: _color2,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${this.listDb_CategoryGroup[index].Category}',
                            style: TextStyle(
                              // color: _color2,
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]));
        }),
      ),
    );
  }

  Future<Null> _listCategoryGroup() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {};
    apiUrl = 'DbGeneralV2/listCategoryGroup';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata = (response.data as Map<String, dynamic>)['DbCategoryGroup'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<DbCategoryCls> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(DbCategoryCls.fromJson(listdata[i]));
          listDb_CategoryGroup = _listData;
          listDb_CategoryGroupCount = _listData.length;

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

  Future<Null> _listDb_Group() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {};
    apiUrl = 'GroupV2/listGroup';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata = (response.data as Map<String, dynamic>)['UserGroupList'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserGroupTapBizModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserGroupTapBizModel.fromJson(listdata[i]));
          listDb_UserGroup = _listData;
          listDb_UserGroupCount = _listData.length;

          if (CategoryidGroupQuery == '1') {
            listDb_UserGroup_setState = listDb_UserGroup;
          } else {
            listDb_UserGroup_setState = (this.listDb_UserGroup.where((dblist) => dblist.GroupCategoryid == CategoryidGroupQuery)).toList();
          }

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

  Future<Null> _addDb_Group() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"GroupName": dataObj.toUpperCase(), "dataObj": dataObj});

    apiUrl = 'GroupV2/addGroup';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        if (response.data['success'] == true) {
          setState(() {
            _listDb_Group();
            actionQuery = null;
            dataObj = '';
            dataObjController.text = '';
            loading = false;
          });
        } else {
          setState(() {
            actionTextQuery = response.data['message'];
            // _listDb_GroupCard_ByGroupid(userGroupidQuery!);
            // actionQuery = null;
            // dataObj = '';
            // dataObjController.text = '';
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

  Future<Null> _updateDb_Group(
      // String Username,
      // String userQueryActionField,
      // String dataObj,
      // File? image,
      ) async {
    // if (mounted) {
    //   setState(() {
    //     loading_WritingNFC = Username;
    //   });
    // }
    // // late var postdata;
    // late String apiUrl;
    // FormData postdata = FormData.fromMap({"Username": Username, "nedField": userQueryActionField, "nedField_Data": dataObj});

    // if (image != null) {
    //   postdata.files.add(MapEntry(
    //       "image",
    //       await MultipartFile.fromFile(
    //         image!.path,
    //         filename: image!.path.split('/').last,
    //       )));
    // }

    // apiUrl = 'GroupCardV2/updateGroupCard';
    // final response = await ApiProvider().postConnect(apiUrl, postdata);
    // if (response.statusCode == 200) {
    //   //--- fetchdata
    //   //--- Set State
    //   if (mounted) {
    //     setState(() {
    //       loading_WritingNFC = '-';
    //     });
    //   }
    //   // --- Set State

    //   //--------------------------------------------------------------
    // } else {
    //   // --- DialogBox
    //   // if (_showAlertDialogStatus == 0) {
    //   //   _showAlertDialog('Status:', 'Check Connection');
    //   //   setState(() {
    //   //     _showAlertDialogStatus = 1;
    //   //   });
    //   // }
    //   // --- DialogBox
    // }
  }

  Future<Null> _delDb_Group(String userGroupQuery) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "GroupName": userGroupQuery,
    };
    apiUrl = 'GroupV2/delGroup';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        setState(() {
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

  Future<Null> _listDb_GroupCard_ByGroupid(String groupId) async {
    if (mounted) {
      setState(() {
        loadingListCard = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {Userid};
    postdata = {
      "Groupid": groupId,
    };
    apiUrl = 'GroupCardV2/listGroupCard_ByGroupid';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata = (response.data as Map<String, dynamic>)['UserDemoList'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserTapBizModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserTapBizModel.fromJson(listdata[i]));
          listDb_UserDemo = _listData;
          listDb_UserDemoCount = _listData.length;
          jumGroupCard_New = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid == '-').length).toString();
          jumGroupCard_DoneNFC = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid != '-').length).toString();
          // jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();
          listDb_UserDemo_setState = listDb_UserDemo;

          loadingListCard = false;
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

  Future<Null> _getDb_GroupCard(String Username) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "Username": Username,
    };
    apiUrl = 'GroupCardV2/getGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        setState(() {
          Groupid = response.data['Groupid'] ?? 0;
          Groupname = response.data['Groupname'] ?? '';
          if (Groupid == 0) {
            userGroupidQuery = null;
            userGroupQuery = null;
          } else {
            userGroupidQuery = Groupid.toString();
            userGroupQuery = Groupname;
            _listDb_GroupCard_ByGroupid(userGroupidQuery!).then((_) {
              listDb_UserDemo = (this.listDb_UserDemo.where((dblist) => dblist.Username == Username)).toList();
            });
          }

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

  Future<Null> _addDb_GroupCard() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"Groupid": userGroupidQuery, "Username": dataObj, "dataObj": dataObj});

    apiUrl = 'GroupCardV2/addGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        if (response.data['success'] == true) {
          setState(() {
            _listDb_GroupCard_ByGroupid(userGroupidQuery!);
            actionQuery = null;
            dataObj = '';
            dataObjController.text = '';
            loading = false;
          });
        } else {
          setState(() {
            actionTextQuery = response.data['message'];
            // _listDb_GroupCard_ByGroupid(userGroupidQuery!);
            // actionQuery = null;
            // dataObj = '';
            // dataObjController.text = '';
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

  Future<Null> _updateDb_GroupCard(
    String Username,
    String userQueryActionField,
    String dataObj,
    File? image,
  ) async {
    if (mounted) {
      setState(() {
        loading_WritingNFC = Username;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"Username": Username, "nedField": userQueryActionField, "nedField_Data": dataObj});

    if (image != null) {
      postdata.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            image!.path,
            filename: image!.path.split('/').last,
          )));
    }

    apiUrl = 'GroupCardV2/updateGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      //--- Set State
      if (mounted) {
        setState(() {
          loading_WritingNFC = '-';
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

  Future<Null> _delDb_GroupCard(String Username) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "Username": Username,
    };
    apiUrl = 'GroupCardV2/delGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        setState(() {
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

  Future<Null> _getDb_Search(String Data) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "Data": Data,
    };
    apiUrl = 'GroupCardV2/searchData';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata

      final listUserdata = (response.data as Map<String, dynamic>)['CarianUser'];
      final listdata = (response.data as Map<String, dynamic>)['CarianUserDemo'];
      //--- Set State
      if (mounted) {
        setState(() {
          // ----------
          List<UserModel> _listUserData = [];
          for (int i = 0; i < listUserdata.length; i++) _listUserData.add(UserModel.fromJson(listUserdata[i]));
          listDb_DataUserSearch = _listUserData;
          listDb_DataUserSearchCount = _listUserData.length;

          // ----------
          // ----------
          List<UserTapBizModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserTapBizModel.fromJson(listdata[i]));
          listDb_DataSearch = _listData;
          listDb_DataSearchCount = _listData.length;

          // ----------
          if (listDb_DataUserSearchCount == 0 && listDb_DataSearchCount == 0) {
            resultSearch = 'Record Not Found';
          } else {
            resultSearch = 'Record Found';
          }
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

  Future<Null> _getDb_Search_DataByUser(String Data) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "Data": Data,
    };
    apiUrl = 'GroupCardV2/searchDataByuser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata = (response.data as Map<String, dynamic>)['CarianUserDemo'];
      //--- Set State
      if (mounted) {
        setState(() {
          // ----------
          List<UserTapBizModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserTapBizModel.fromJson(listdata[i]));
          listDb_DataByUserSearch = _listData;
          listDb_DataByUserSearchCount = _listData.length;

          // ----------
          if (listDb_DataUserSearchCount == 0 && listDb_DataSearchCount == 0) {
            resultSearch = 'Record Not Found';
          } else {
            resultSearch = 'Record Found';
          }
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

  Future<Null> _delDb_UserProfile(String userId) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"userId": userId});

    apiUrl = 'userDelete';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      _getDb_Search(dataObj);

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

  ListView getListViewBuilder_DataUserSearch() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_DataUserSearch.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () async {
            if (this.listDb_DataUserSearch[position].userData != '0') {
              userEmailSearchQuery = this.listDb_DataUserSearch[position].userUser_Email;
              _getDb_Search_DataByUser(this.listDb_DataUserSearch[position].userUser_Email);
            }

            // setState(() {
            // navSearchView = null;
            // Groupid = int.parse(this.listDb_DataSearch[position].Groupid);
            // Groupname = this.listDb_DataSearch[position].Groupname;
            // if (Groupid == 0) {
            //   userGroupidQuery = null;
            //   userGroupQuery = null;
            // } else {
            //   userGroupidQuery = Groupid.toString();
            //   userGroupQuery = Groupname;
            //   _listDb_GroupCard_ByGroupid(userGroupidQuery!).then((_) {
            //     listDb_UserDemo = (this.listDb_UserDemo.where((dblist) => dblist.Username == this.listDb_DataSearch[position].Username)).toList();
            //   });
            // }
            // });
          },
          child: Card(
            elevation: 10,
            // surfaceTintColor: AppSettings.ColorUnderline2,
            color: (int.parse(this.listDb_DataUserSearch[position].userData) > 0) ? AppSettings.ColorMain : Colors.white,
            surfaceTintColor: (int.parse(this.listDb_DataUserSearch[position].userData) > 0) ? AppSettings.ColorMain : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (this.listDb_DataUserSearch[position].userUser_Name == '')
                      ? Text(
                          'Name: -',
                          style: TextStyle(fontSize: 11),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(fontSize: 11),
                            ),
                            Expanded(
                              child: Text(
                                '${this.listDb_DataUserSearch[position].userUser_Name}',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                  (this.listDb_DataUserSearch[position].userUser_Email == '')
                      ? Text(
                          'Email: -',
                          style: TextStyle(fontSize: 11),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email:',
                              style: TextStyle(fontSize: 11),
                            ),
                            Expanded(
                              child: Text(
                                '${this.listDb_DataUserSearch[position].userUser_Email}',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Text(
                        'Total Card: ${this.listDb_DataUserSearch[position].userData}',
                        style: TextStyle(fontSize: 11),
                      ),
                      Spacer(),
                      (int.parse(this.listDb_DataUserSearch[position].userData) == 0)
                          ? InkWell(
                              onTap: () {
                                showCupertinoDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: Text('Delete'),
                                    content: Column(
                                      children: [
                                        Text('${this.listDb_DataUserSearch[position].userUser_Email}'),
                                        Text('Are you sure?'),
                                      ],
                                    ),
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
                                          Navigator.pop(context);

                                          // -------
                                          _delDb_UserProfile(this.listDb_DataUserSearch[position].userId);

                                          // -------
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Card(
                                surfaceTintColor: Colors.grey.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Typicons.trash,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ListView getListViewBuilder_DataByUserSearch() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_DataByUserSearch.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () async {
            setState(() {
              navSearchView = null;
              Groupid = int.parse(this.listDb_DataByUserSearch[position].Groupid);
              Groupname = this.listDb_DataByUserSearch[position].Groupname;
              if (Groupid == 0) {
                userGroupidQuery = null;
                userGroupQuery = null;
              } else {
                userGroupidQuery = Groupid.toString();
                userGroupQuery = Groupname;
                _listDb_GroupCard_ByGroupid(userGroupidQuery!).then((_) {
                  listDb_UserDemo_setState = (this.listDb_UserDemo.where((dblist) => dblist.Username == this.listDb_DataByUserSearch[position].Username)).toList();
                });
              }
            });
          },
          child: Card(
            elevation: 10,
            surfaceTintColor: AppSettings.ColorUnderline2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username: ',
                        style: TextStyle(fontSize: 11),
                      ),
                      Expanded(
                        child: Text(
                          '${this.listDb_DataByUserSearch[position].Username}',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(fontSize: 9),
                      ),
                      Expanded(
                        child: Text(
                          '${this.listDb_DataByUserSearch[position].User_Email}',
                          style: TextStyle(fontSize: 9),
                        ),
                      )
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

  ListView getListViewBuilder_DataSearch() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_DataSearch.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () async {
            setState(() {
              navSearchView = null;
              Groupid = int.parse(this.listDb_DataSearch[position].Groupid);
              Groupname = this.listDb_DataSearch[position].Groupname;
              if (Groupid == 0) {
                userGroupidQuery = null;
                userGroupQuery = null;
              } else {
                userGroupidQuery = Groupid.toString();
                userGroupQuery = Groupname;
                _listDb_GroupCard_ByGroupid(userGroupidQuery!).then((_) {
                  listDb_UserDemo_setState = (this.listDb_UserDemo.where((dblist) => dblist.Username == this.listDb_DataSearch[position].Username)).toList();
                });
              }
            });
          },
          child: Card(
            elevation: 10,
            surfaceTintColor: AppSettings.ColorUnderline2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Username: ',
                        style: TextStyle(fontSize: 11),
                      ),
                      Expanded(
                        child: Text(
                          '${this.listDb_DataSearch[position].Username}',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(fontSize: 9),
                      ),
                      Expanded(
                        child: Text(
                          '${this.listDb_DataSearch[position].User_Email}',
                          style: TextStyle(fontSize: 9),
                        ),
                      )
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
}