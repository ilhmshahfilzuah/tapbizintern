import 'dart:async';
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
import 'package:qr_flutter/qr_flutter.dart';

import '../devkit/config/constant.dart';
import '../subconfig/AppSettings.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/model/user_model.dart';
import '../subdata/model/usergroupTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home_subUserCard_Mngt.dart';
import 'ndef_record/raw_record_setting.dart';
import 'ndef_record/text_record_setting.dart';
import 'ndef_record/uri_record_setting.dart';

import 'package:universal_io/io.dart' as IO;

class PageGroups extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => PageGroups());
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

  int? _groupValue;
  String? userGroupidQuery;
  String? userGroupQuery;
  String? userQuery;
  String? userFlagdelQuery;
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

  List<UserGroupTapBizModel> listDb_UserGroup = [];
  int listDb_UserGroupCount = 0;

  List<UserTapBizModel> listDb_UserDemo = [];
  int listDb_UserDemoCount = 0;
  var loading = false;
  // var loading_WritingNFC = false;

  String loading_WritingNFC = '-';
  int _writeLoading = 0;

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

  @override
  void dispose() {
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
    userQuery = null;
    // userQueryAction = 'View';
    _listDb_UserGroup();

    //-------
    // userQuery = 'buck';
    // _getDb_UserDemo('buck');
    // userQueryAction = 'Edit';
    // _groupValue = 0;
    //-------
    if (!kIsWeb)
      _platformVersion = '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    else
      _platformVersion = 'Web';
    initPlatformState();
    _tabSubController = new TabController(length: 2, vsync: this);
    _records = [];
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
  Future requestPermission(Permission permission) async {
    final result = await permission.request();
    return result;
  }

  void _askPermissionCamera() {
    requestPermission(Permission.camera).then(_onStatusRequestedCamera);
  }

  void _askPermissionStorage() {
    requestPermission(Permission.storage).then(_onStatusRequested);
  }

  void _askPermissionPhotos() {
    requestPermission(Permission.photos).then(_onStatusRequested);
  }

  void _onStatusRequested(status) {
    if (status != PermissionStatus.granted) {
      if (IO.Platform.isIOS) {
        openAppSettings();
      } else {
        if (status == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        }
      }
    } else {
      _getImage(ImageSource.gallery);
    }
  }

  void _onStatusRequestedCamera(status) {
    if (status != PermissionStatus.granted) {
      if (IO.Platform.isIOS) {
        openAppSettings();
      } else {
        if (status == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        }
      }
    } else {
      _getImage(ImageSource.camera);
    }
  }

  //------------------PickUp Image
  Widget _getImageWidget() {
    final double profilePictureSize = MediaQuery.of(context).size.width / 4;
    if (_selectedFile != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(
            _selectedFile!,
            width: profilePictureSize - 4,
            fit: BoxFit.fill,
          ),
        ],
      );
    } else {
      return Image.asset(
        'assets/devkit/images/placeholder.jpg',
        width: profilePictureSize - 4,
        fit: BoxFit.fill,
      );
    }
  }

  void _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, maxWidth: 640, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    if (_image != null) {
      this.setState(() {
        if (!kIsWeb) {
          if (_selectedFile != null && _selectedFile!.existsSync()) {
            _selectedFile!.deleteSync();
          }
        }
        if (kIsWeb) {
          _selectedFile = pickedFile;
        } else {
          _selectedFile = _image;
        }

        _image = null;
      });
    }
  }

  void _removeImage() async {
    setState(() {
      _selectedFile = null;
    });
  }

  void _removeImageServer() async {
    setState(() {
      imageURL = '';
    });
  }

  void compressImage(File file) async {
    final filePath = file.absolute.path;
    int lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final compressedImage = await FlutterImageCompress.compressAndGetFile(filePath, outPath, minWidth: 1000, minHeight: 1000, quality: 5);
  }
  //------------------PickUp Image
  //------------------PickUp Image

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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                          },
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ];
            },
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                (userQuery == null)
                    ? Column(
                        children: [
                          // --------------
                          (userGroupQuery == null)
                              ? Column(
                                  children: [
                                    (actionQuery == null)
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('GROUP MNGT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text('Close Group Mngt'),
                                                      Icon(
                                                        Typicons.cancel_outline,
                                                        size: 30,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
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
                                            elevation: 1,
                                            // color: Colors.grey.shade200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
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
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Row(
                                    //     children: [
                                    //       Spacer(),
                                    //       Text(
                                    //         'Create Group ',
                                    //         style: TextStyle(color: Colors.grey.shade400),
                                    //       ),
                                    //       Icon(
                                    //         Typicons.plus_outline,
                                    //         size: 20,
                                    //         color: Colors.grey.shade400,
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
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
                                                elevation: 10,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  // padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'ALL GROUPS',
                                                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      getListViewBuilder_DataUserGroup(),
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
                                          child: Text('GROUP MNGT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'GROUP: $userGroupQuery',
                                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    userGroupidQuery = null;
                                                    userGroupQuery = null;

                                                    actionQuery = null;
                                                    actionTextQuery = null;
                                                    dataObj = '';
                                                    dataObjController.text = '';
                                                  });
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
                                        (userGroupQuery == 'Demo' || userGroupQuery == 'Demo TAP ID' || userGroupQuery == 'Demo TAP VISITOR')
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
                                                                Card(
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
                                                                          Text('   Total Pending: $jumGroupCard_Pending'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(''),
                                                                Row(
                                                                  children: [
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets.only(left: 16.0),
                                                                    //   child: Column(
                                                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                                    //     children: [
                                                                    //       Text(
                                                                    //         'NFC Writing Tools',
                                                                    //         style: TextStyle(fontSize: 14),
                                                                    //       ),
                                                                    //       Text(
                                                                    //         'Delay Setting ',
                                                                    //         style: TextStyle(fontSize: 14),
                                                                    //       ),
                                                                    //       InkWell(
                                                                    //         onTap: () {
                                                                    //           setState(() {
                                                                    //             SleepDuration = 0;
                                                                    //           });
                                                                    //         },
                                                                    //         child: Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                                                    //           crossAxisAlignment: CrossAxisAlignment.end,
                                                                    //           children: [
                                                                    //             (SleepDuration == 0)
                                                                    //                 ? Icon(
                                                                    //                     Icons.check,
                                                                    //                     size: 16,
                                                                    //                     color: Colors.green,
                                                                    //                   )
                                                                    //                 : Container(),
                                                                    //             Text(
                                                                    //               ' Delay 0 Second',
                                                                    //               style: TextStyle(fontSize: 14),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ),
                                                                    //       InkWell(
                                                                    //         onTap: () {
                                                                    //           setState(() {
                                                                    //             SleepDuration = 200;
                                                                    //           });
                                                                    //         },
                                                                    //         child: Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                                    //           crossAxisAlignment: CrossAxisAlignment.end,
                                                                    //           children: [
                                                                    //             (SleepDuration == 200)
                                                                    //                 ? Icon(
                                                                    //                     Icons.check,
                                                                    //                     size: 16,
                                                                    //                     color: Colors.green,
                                                                    //                   )
                                                                    //                 : Container(),
                                                                    //             Text(
                                                                    //               ' Delay 0.2 Second',
                                                                    //               style: TextStyle(fontSize: 14),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ),
                                                                    //       InkWell(
                                                                    //         onTap: () {
                                                                    //           setState(() {
                                                                    //             SleepDuration = 400;
                                                                    //           });
                                                                    //         },
                                                                    //         child: Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                                    //           crossAxisAlignment: CrossAxisAlignment.end,
                                                                    //           children: [
                                                                    //             (SleepDuration == 400)
                                                                    //                 ? Icon(
                                                                    //                     Icons.check,
                                                                    //                     size: 16,
                                                                    //                     color: Colors.green,
                                                                    //                   )
                                                                    //                 : Container(),
                                                                    //             Text(
                                                                    //               ' Delay 0.4 Second',
                                                                    //               style: TextStyle(fontSize: 14),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ),
                                                                    //       InkWell(
                                                                    //         onTap: () {
                                                                    //           setState(() {
                                                                    //             SleepDuration = 600;
                                                                    //           });
                                                                    //         },
                                                                    //         child: Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                                    //           crossAxisAlignment: CrossAxisAlignment.end,
                                                                    //           children: [
                                                                    //             (SleepDuration == 600)
                                                                    //                 ? Icon(
                                                                    //                     Icons.check,
                                                                    //                     size: 16,
                                                                    //                     color: Colors.green,
                                                                    //                   )
                                                                    //                 : Container(),
                                                                    //             Text(
                                                                    //               ' Delay 0.6 Second',
                                                                    //               style: TextStyle(fontSize: 14),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ),
                                                                    //       InkWell(
                                                                    //         onTap: () {
                                                                    //           setState(() {
                                                                    //             SleepDuration = 800;
                                                                    //           });
                                                                    //         },
                                                                    //         child: Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                                    //           crossAxisAlignment: CrossAxisAlignment.end,
                                                                    //           children: [
                                                                    //             (SleepDuration == 800)
                                                                    //                 ? Icon(
                                                                    //                     Icons.check,
                                                                    //                     size: 16,
                                                                    //                     color: Colors.green,
                                                                    //                   )
                                                                    //                 : Container(),
                                                                    //             Text(
                                                                    //               ' Delay 0.8 Second',
                                                                    //               style: TextStyle(fontSize: 14),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ),
                                                                    //       InkWell(
                                                                    //         onTap: () {
                                                                    //           setState(() {
                                                                    //             SleepDuration = 1000;
                                                                    //           });
                                                                    //         },
                                                                    //         child: Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                                    //           crossAxisAlignment: CrossAxisAlignment.end,
                                                                    //           children: [
                                                                    //             (SleepDuration == 1000)
                                                                    //                 ? Icon(
                                                                    //                     Icons.check,
                                                                    //                     size: 16,
                                                                    //                     color: Colors.green,
                                                                    //                   )
                                                                    //                 : Container(),
                                                                    //             Text(
                                                                    //               ' Delay 1.0 Second',
                                                                    //               style: TextStyle(fontSize: 14),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ),
                                                                    //     ],
                                                                    //   ),
                                                                    // ),
                                                                    // // Spacer(),
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets.only(left: 16.0),
                                                                    //   child: Column(
                                                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                                    //     children: [
                                                                    //       Text(
                                                                    //         'NFC Writing Tools',
                                                                    //         style: TextStyle(fontSize: 14),
                                                                    //       ),
                                                                    //       Text(
                                                                    //         'Delay Setting ',
                                                                    //         style: TextStyle(fontSize: 14),
                                                                    //       ),
                                                                    //     ],
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () async {
                                                                    setState(() {
                                                                      actionQuery = 'AddCard';
                                                                    });
                                                                  },
                                                                  child: Card(
                                                                    elevation: 1,
                                                                    // color: Colors.grey.shade200,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(2.0),
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
                                                                Row(
                                                                  children: [
                                                                    Text('Scan   '),
                                                                    Icon(
                                                                      Typicons.camera_outline,
                                                                      size: 40,
                                                                    ),
                                                                  ],
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
                                                        Row(
                                                          children: [
                                                            Card(
                                                              elevation: 5,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // ------------- //
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      setState(() {
                                                                        // Navigator.push(context, new MaterialPageRoute(builder: (context) => Onboarding1Page(parentQuery: 'PageMore')));
                                                                      });
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Container(
                                                                                // height: 80,
                                                                                // color: Colors.lightBlue.shade50,
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.lightBlue.shade50,
                                                                                    border: Border.all(
                                                                                      color: Colors.lightBlue.shade50,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                                                                                  child: Center(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Icon(color: Colors.lightBlue.shade900, size: 40, Typicons.info_outline),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 16,
                                                                              ),
                                                                              Text('Intro', style: TextStyle(color: Colors.lightBlue.shade900, fontSize: 12, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  // ------------- //
                                                                ],
                                                              ),
                                                            ),
                                                            Card(
                                                              elevation: 5,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // ------------- //
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      setState(() {
                                                                        // Navigator.push(context, new MaterialPageRoute(builder: (context) => Onboarding1Page(parentQuery: 'PageMore')));
                                                                      });
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Container(
                                                                                // height: 80,
                                                                                // color: Colors.lightBlue.shade50,
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.lightBlue.shade50,
                                                                                    border: Border.all(
                                                                                      color: Colors.lightBlue.shade50,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                                                                                  child: Center(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Icon(color: Colors.lightBlue.shade900, size: 40, Typicons.info_outline),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 16,
                                                                              ),
                                                                              Text('Intro', style: TextStyle(color: Colors.lightBlue.shade900, fontSize: 12, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  // ------------- //
                                                                ],
                                                              ),
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
                                                    elevation: 10,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      // padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                                                      child: (listDb_UserDemo.length == 0)
                                                          ? Column(
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
                                                                                  _listDb_UserGroup().then((_) {
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
                                                                Text(
                                                                  'ALL CARDS',
                                                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                getListViewBuilder_DataUserDemo(),
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
                                    // Column(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     Text(
                                    //       'Card: $userQuery',
                                    //       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                    //     ),
                                    //   ],
                                    // ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        (userFlagdelQuery == 'Yes')
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
                                                        // -------
                                                        _delDb_UserDemo(userQuery!).then((_) {
                                                          _listDb_UserDemo_ByGroupid(userGroupidQuery!).then((_) {
                                                            setState(() {
                                                              userQuery = null;
                                                              userFlagdelQuery = null;
                                                            });
                                                            Navigator.pop(context);
                                                          });
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
                                        color: (userFlagdelQuery == 'Yes') ? Colors.grey.shade100 : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
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
                                    // InkWell(
                                    //   onTap: () {
                                    //     (userFlagdelQuery == 'Yes')
                                    //         ? showCupertinoDialog<void>(
                                    //             context: context,
                                    //             builder: (BuildContext context) => CupertinoAlertDialog(
                                    //               title: Text('Delete'),
                                    //               content: Text('Are you sure?'),
                                    //               actions: <CupertinoDialogAction>[
                                    //                 CupertinoDialogAction(
                                    //                   child: Text('No'),
                                    //                   onPressed: () {
                                    //                     Navigator.pop(context);
                                    //                   },
                                    //                 ),
                                    //                 CupertinoDialogAction(
                                    //                   child: Text('Yes'),
                                    //                   isDestructiveAction: true,
                                    //                   onPressed: () {
                                    //                     // -------
                                    //                     _delDb_UserDemo(userQuery!).then((_) {
                                    //                       _listDb_UserDemo_ByGroupid(userGroupidQuery!).then((_) {
                                    //                         setState(() {
                                    //                           userQuery = null;
                                    //                           userFlagdelQuery = null;
                                    //                         });
                                    //                         Navigator.pop(context);
                                    //                       });
                                    //                     });

                                    //                     // -------
                                    //                   },
                                    //                 )
                                    //               ],
                                    //             ),
                                    //           )
                                    //         : null;
                                    //   },
                                    //   child: Card(
                                    //     color: (userFlagdelQuery == 'Yes') ? Colors.grey.shade100 : Colors.white,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(2.0),
                                    //       child: Column(
                                    //         children: [
                                    //           Icon(
                                    //             Typicons.edit,
                                    //             size: 20,
                                    //             color: (userFlagdelQuery == 'Yes') ? Colors.black : Colors.grey.shade400,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Text(' | '),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          userQuery = null;
                                          userFlagdelQuery = null;
                                          _listDb_UserDemo_ByGroupid(userGroupidQuery!);
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
                              PageUserCard_Mngt(parentQuery: '', userQuery: userQuery!),
                            ],
                          )
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
                      if (_formKey.currentState!.validate()) {
                        if (actionQuery == 'AddGroup') {
                          _addDb_Group();
                        }
                        if (actionQuery == 'AddCard') {
                          _addDb_UserDemo();
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
                        if (actionQuery == 'AddGroup') {
                          // _listDb_UserDemo_ByGroupid(userGroupidQuery!);
                        }
                        if (actionQuery == 'AddCard') {
                          _listDb_UserDemo_ByGroupid(userGroupidQuery!);
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
            _listDb_UserGroup();
            actionQuery = null;
            dataObj = '';
            dataObjController.text = '';
            loading = false;
          });
        } else {
          setState(() {
            actionTextQuery = response.data['message'];
            // _listDb_UserDemo_ByGroupid(userGroupidQuery!);
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

  Future<Null> _addDb_UserDemo() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"Groupid": userGroupidQuery, "Username": dataObj.toUpperCase(), "dataObj": dataObj});

    apiUrl = 'GroupCardV2/addGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        if (response.data['success'] == true) {
          setState(() {
            _listDb_UserDemo_ByGroupid(userGroupidQuery!);
            actionQuery = null;
            dataObj = '';
            dataObjController.text = '';
            loading = false;
          });
        } else {
          setState(() {
            actionTextQuery = response.data['message'];
            // _listDb_UserDemo_ByGroupid(userGroupidQuery!);
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

  // -----------------
  ListView getListViewBuilder_DataUserGroup() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_UserGroup.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () async {
            // _getDb_UserDemo(this.listDb_UserDemo[position].Username);
            setState(() {
              userGroupidQuery = this.listDb_UserGroup[position].id;
              userGroupQuery = this.listDb_UserGroup[position].GroupName;
              _listDb_UserDemo_ByGroupid(this.listDb_UserGroup[position].id);
            });
          },
          child: Card(
            elevation: 10,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
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
                          '${position + 1}. ${this.listDb_UserGroup[position].GroupName}',
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Group ID: ${this.listDb_UserGroup[position].id}',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Activation Code: xxxx',
                          style: TextStyle(color: Colors.black, fontSize: 10),
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
          ),
        );
      },
    );
  }

  ListView getListViewBuilder_DataUserDemo() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: listDb_UserDemo.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 10,
          color: (this.listDb_UserDemo[position].NFCTAGid == '-') ? Colors.white : Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      userQuery = this.listDb_UserDemo[position].Username;
                      userFlagdelQuery = this.listDb_UserDemo[position].Flagdel;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (this.listDb_UserDemo[position].themeURL == '')
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
                                      elevation: 20,
                                      child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: 50, url: this.listDb_UserDemo[position].themeURL))),
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
                            //   'CARD ID: ${this.listDb_UserDemo[position].Username}',
                            //   style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                            // ),
                            (this.listDb_UserDemo[position].User_Name == '')
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
                                          'CARD NAME: ${this.listDb_UserDemo[position].User_Name.toUpperCase()}',
                                          style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'EMAIL: ${this.listDb_UserDemo[position].User_Email}',
                                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Card ID: ${this.listDb_UserDemo[position].Username}',
                              style: TextStyle(color: Colors.black, fontSize: 11),
                            ),
                            // Text(
                            //   'Type: ${this.listDb_UserDemo[position].CardType}',
                            //   style: TextStyle(color: Colors.black, fontSize: 11),
                            // ),
                            Text(
                              'NFC Tag Serial No: ${this.listDb_UserDemo[position].NFCTAGid}',
                              style: TextStyle(color: Colors.black, fontSize: 11),
                            ),

                            // (this.listDb_UserDemo[position].CardType == 'tapcard')
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            //           Text('https://tapcard.tapbiz.my/tc/${this.listDb_UserDemo[position].Username}', style: TextStyle(fontSize: 10)),
                            //         ],
                            //       )
                            //     : Container(),
                            // (this.listDb_UserDemo[position].CardType == 'tapid')
                            //     ? Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text('URL: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            //           Text('https://tapid.tapbiz.my/ti/${this.listDb_UserDemo[position].Username}', style: TextStyle(fontSize: 10)),
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
                            //       ': ${this.listDb_UserDemo[position].CardAuth}',
                            //       style: TextStyle(color: (this.listDb_UserDemo[position].CardAuth == 'Yes') ? Colors.black : Colors.red, fontSize: 11),
                            //     ),
                            //   ],
                            // ),
                            (this.listDb_UserDemo[position].CardAuth == 'Yes')
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
                              'TP: ${this.listDb_UserDemo[position].UserCounter_View}',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'SC: ${this.listDb_UserDemo[position].UserCounter_SaveContact}',
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
                (loading_WritingNFC != '-' && loading_WritingNFC == this.listDb_UserDemo[position].Username)
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
                          InkWell(
                            onTap: () async {
                              setState(() {
                                // _updateDb_UserDemo(this.listDb_UserDemo[position].Username, 'NFCTAGid', (position+1).toString(), null);
                                // this.listDb_UserDemo[position].NFCTAGid = (position + 1).toString();
                                // jumGroupCard_New = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid == '-').length).toString();
                                // jumGroupCard_DoneNFC = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid != '-').length).toString();
                                // jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();
                              });
                              // ---------------
                              _records = [];
                              String _url = 'tapcard.tapbiz.my/tc/${this.listDb_UserDemo[position].Username}';
                              if (CardType == 'tapid') {
                                _url = 'tapid.tapbiz.my/ti/${this.listDb_UserDemo[position].Username}';
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

                                      _updateDb_UserDemo(this.listDb_UserDemo[position].Username, 'NFCTAGid', _tagSIRI.toString(), null);
                                      this.listDb_UserDemo[position].NFCTAGid = _tagSIRI!;
                                      jumGroupCard_New = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid == '-').length).toString();
                                      jumGroupCard_DoneNFC = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid != '-').length).toString();
                                      jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();
                                    });
                                  } else {
                                    setState(() {
                                      _writeResult = 'error: NDEF not supported: ${tag.type}';
                                      this.listDb_UserDemo[position].NFCTAGid = '-';
                                    });
                                  }
                                } catch (e, stacktrace) {
                                  setState(() {
                                    _writeResult = 'error: $e';
                                    this.listDb_UserDemo[position].NFCTAGid = '-';
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

  Future<Null> _listDb_UserGroup() async {
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

  Future<Null> _listDb_UserDemo_ByGroupid(String groupId) async {
    if (mounted) {
      setState(() {
        loading = true;
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
          jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();

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

  Future<Null> _delDb_UserDemo(String Username) async {
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

  Future<Null> _updateDb_UserDemo(
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
}
