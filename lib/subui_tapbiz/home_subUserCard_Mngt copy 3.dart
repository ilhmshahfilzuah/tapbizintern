import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform, sleep;

import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:crop_image/crop_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/records/well_known/uri.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/DbCategory_Model.dart';
import '../subdata/model/TapBizStatus_model.dart';
import '../subdata/model/TapBizTheme_model.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/model/user_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';

import 'package:universal_io/io.dart' as IO;

class PageUserCard_Mngt extends StatefulWidget {
  const PageUserCard_Mngt({Key? key, required this.parentQuery, required this.userQuery}) : super(key: key);
  final String parentQuery;
  final String userQuery;
  @override
  _PageUserCard_MngtState createState() => _PageUserCard_MngtState();
}

class _PageUserCard_MngtState extends State<PageUserCard_Mngt> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _tagSIRI;
  String? _result, _writeResult, _mifareResult;
  late TabController _tabSubController;
  List<ndef.NDEFRecord>? _records;

  int? _groupValue;
  // String? userQuery;
  String? userQueryAction;
  String? userQueryActionField;
  String? userQueryActionFieldName;
  String? userQueryActionFieldURL;

  String? userQueryActionSub;

  String? userQueryProfile;

  String? actionQuery;
  String? actionTextQuery;

  var _formKey = GlobalKey<FormState>();

  UserModel? userCls;

  List<UserTapBizModel> listDb_UserDemo = [];
  int listDb_UserDemoCount = 0;

  List<UserTapBizModel> listDb_UserDemoProfile = [];
  int listDb_UserDemoProfileCount = 0;

  var loading = false;
  var _writeLoading = false;

  String CardProfile_collapse = 'Yes';

  bool _ValCardAuth = false;
  bool _ValCardData = true;

  String uuid = '';
  int? Userid = null;
  int? Groupid = null;

  String NFCTAGid = '-';

  String Flagdel = '';
  String CardAuth = '';
  String CardData = 'main';
  int CardProfilePermission = 2;
  int CardProfileid = 0;
  String CardProfile = 'Default';
  String CardType = '';
  String Username = '';
  String UsernameQR = '';
  String imageURL = '';
  String themeURL = '';

  String User_Name = '';
  String User_IC = '';
  String User_Birthday = '';
  String User_Headline = '';
  String User_Title = '';
  String User_Dept = '';
  String User_Company = '';
  String User_Email = '';
  String User_NoTel = '';
  String User_NoTel2 = '';
  String User_NoTelOffice = '';
  String User_WS = '';
  String User_Telegram = '';

  String User_Mail = '';
  String User_Emergency_Contact = '';

  String User_X = '';
  String User_FB = '';
  String User_Instagram = '';
  String User_TikTok = '';
  String User_YouTube = '';

  String UserTapID_Category = '';
  String UserTapID_IC = '';
  String UserTapID_Passport = '';
  String UserTapID_Work_Permit_No = '';
  String UserTapID_Country_Of_Origin = '';

  String UserTapID_Department = '';
  String UserTapID_Company = '';
  String UserTapID_Employee_id = '';
  String UserTapID_Contact = '';
  String UserTapID_Emergency_Contact = '';

  String UserTapID_Blood_Type = '';
  String UserTapID_Allergies = '';
  String UserTapID_Medical_Records = '';
  String UserTapID_Critical_Illness = '';
  String UserTapID_Status_Card = '';

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';
  String dataObjFinal = '';

  String ViewWebURL = '';
  double webViewHeight = 1;
  WebViewController? controller;

  final cropcontroller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  File? _image;
  final _picker = ImagePicker();
  dynamic _selectedFile;
  dynamic _selectedCropFile;

  List<TapBizThemeModel> listDb_Theme = [];
  int listDb_ThemeCount = 0;

  List<TapBizStatusModel> listDb_Status = [];
  int listDb_StatusCount = 0;

  List<DbCategoryCls> _listCategory = [];

  String? _mySelectionDbStatusOld;
  String? _mySelectionDbStatus;

  Color _color = Color(0xFF515151);
  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);
  Color _color3 = Color(0xff777777);

  String? AccSetQuery;

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

    // _listDb_UserDemo();
    userQueryAction = 'View';
    //-------
    _getUserInfo();
    _getDb_UserDemo(widget.userQuery).then((_) {});

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

  Future<bool> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        final userJson = prefs.getString('user') ?? '';
        Map<String, dynamic> map = jsonDecode(userJson);
        userCls = UserModel.fromJson(map);
      });
    }
    return true;
  }

  @override
  bool get wantKeepAlive => true;

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

  updateHeight() async {
    double height = double.parse(await controller!.runJavascriptReturningResult('document.documentElement.scrollHeight;'));
    if (webViewHeight != height) {
      setState(() {
        webViewHeight = height;
      });
    }
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
        // if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
        // }
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
      return (_selectedCropFile != null)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.file(
                  _selectedFile!,
                  width: profilePictureSize - 4,
                  fit: BoxFit.fill,
                ),
              ],
            )
          : Container();
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
      _selectedCropFile = null;
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

  Future<void> _launchInBrowser(String url) async {
    Uri urlUri = Uri.parse(url);
    if (!await launchUrl(
      urlUri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxImageSize = ((MediaQuery.of(context).size.width) - 24) / 2 - 12;
    final double profilePictureSize = MediaQuery.of(context).size.width / 6;
    if (CardType == 'tapcard') {
      ViewWebURL = 'https://tapcard.tapbiz.my/tc/${widget.userQuery}';
    }
    if (CardType == 'tapid') {
      ViewWebURL = 'https://tapid.tapbiz.my/ti/${widget.userQuery}';
    }

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
        : Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                (widget.parentQuery == 'Home')
                    ? Container()
                    : Column(
                        children: [
                          Text('${CardType.toUpperCase()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Card: ${widget.userQuery}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('UserID: $Userid | GroupID: $Groupid'),
                            ],
                          ),

                          // -----------Email
                          // (userQueryActionField != null)
                          //     ? Container()
                          //     : Padding(
                          //         padding: const EdgeInsets.all(4.0),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: <Widget>[
                          //             Expanded(
                          //               child: (User_Email != '')
                          //                   ? Column(
                          //                       mainAxisAlignment: MainAxisAlignment.center,
                          //                       crossAxisAlignment: CrossAxisAlignment.center,
                          //                       children: [
                          //                         Text(' Pls update this email for pairing with Mobile Apps Account: ', style: TextStyle(color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.bold)),
                          //                         Row(
                          //                           mainAxisAlignment: MainAxisAlignment.center,
                          //                           crossAxisAlignment: CrossAxisAlignment.center,
                          //                           children: [
                          //                             InkWell(
                          //                               onTap: () {
                          //                                 setState(() {
                          //                                   userQueryAction = 'Edit';
                          //                                   _groupValue = 2;
                          //                                   userQueryActionField = 'User_Email';
                          //                                   userQueryActionFieldName = 'Email';
                          //                                   dataObjController.text = User_Email;
                          //                                   // -----------
                          //                                   userQueryActionFieldURL = '';
                          //                                   if (User_Email != '') {
                          //                                     User_Email = User_Email.replaceAll(userQueryActionFieldURL!, '');
                          //                                     dataObjController.text = User_Email;
                          //                                   }
                          //                                   // -----------
                          //                                 });
                          //                               },
                          //                               child: Icon(
                          //                                 FontAwesome5.edit,
                          //                                 size: 14.0,
                          //                                 color: AppSettings.ColorMain,
                          //                               ),
                          //                             ),
                          //                             Text(' $User_Email', style: TextStyle(color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.bold)),
                          //                           ],
                          //                         ),
                          //                       ],
                          //                     )
                          //                   : Text(
                          //                       'Pls Update Email!',
                          //                       style: TextStyle(color: Colors.grey),
                          //                     ),
                          //             ),
                          //             // Text(' '),
                          //             // (userQueryActionField != null)
                          //             //     ? Container()
                          //             //     : InkWell(
                          //             //         onTap: () {
                          //             //           setState(() {
                          //             //             userQueryAction = 'Edit';
                          //             //             _groupValue = 2;
                          //             //             userQueryActionField = 'User_Email';
                          //             //             userQueryActionFieldName = 'Email';
                          //             //             dataObjController.text = User_Email;
                          //             //             // -----------
                          //             //             userQueryActionFieldURL = '';
                          //             //             if (User_Email != '') {
                          //             //               User_Email = User_Email.replaceAll(userQueryActionFieldURL!, '');
                          //             //               dataObjController.text = User_Email;
                          //             //             }
                          //             //             // -----------
                          //             //           });
                          //             //         },
                          //             //         child: Icon(
                          //             //           FontAwesome5.edit,
                          //             //           size: 20.0,
                          //             //           color: AppSettings.ColorMain,
                          //             //         ),
                          //             //       )
                          //           ],
                          //         ),
                          //       ),
                          // -----------Email
                        ],
                      ),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            userQueryAction = 'View';
                          });
                        },
                        child: Card(
                          surfaceTintColor: (userQueryAction == 'View' || userQueryAction == 'Edit') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: (userQueryAction == 'View' || userQueryAction == 'Edit') ? AppSettings.ColorMain : Colors.black,
                                ),
                                // Text('Main', style: TextStyle(color: (userQueryAction == 'View') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'View') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () async {
                      //     setState(() {
                      //       userQueryAction = 'Edit';
                      //       _groupValue = 0;
                      //     });
                      //   },
                      //   child: Card(
                      //     surfaceTintColor: (userQueryAction == 'Edit') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         children: [
                      //           Text('Edit', style: TextStyle(color: (userQueryAction == 'Edit') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'Edit') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      InkWell(
                        onTap: () async {
                          setState(() {
                            userQueryAction = 'Preview';
                            webViewHeight = 1;
                          });
                        },
                        child: Card(
                          surfaceTintColor: (userQueryAction == 'Preview') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('Card Preview', style: TextStyle(color: (userQueryAction == 'Preview') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'Preview') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      (widget.parentQuery != 'Home')
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  userQueryAction = 'Share';
                                  webViewHeight = 1;
                                });
                              },
                              child: Card(
                                surfaceTintColor: (userQueryAction == 'Share') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('Card Share', style: TextStyle(color: (userQueryAction == 'Share') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'Share') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      // InkWell(
                      //   onTap: () async {
                      //     setState(() {
                      //       userQueryAction = 'QR Code';
                      //     });
                      //   },
                      //   child: Card(
                      //     color: (userQueryAction == 'QR Code') ? Colors.grey.shade100 : Colors.white,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         children: [
                      //           Text('QR', style: TextStyle(color: (userQueryAction == 'QR Code') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'DownloadQR') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      (widget.parentQuery == 'Home')
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  userQueryAction = 'WriteNFC';
                                });
                              },
                              child: Card(
                                surfaceTintColor: (userQueryAction == 'WriteNFC') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('Write To NFC',
                                          style: TextStyle(color: (userQueryAction == 'WriteNFC') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'WriteNFC') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            userQueryAction = 'Card Setting';
                          });
                        },
                        child: Card(
                          surfaceTintColor: (userQueryAction == 'Card Setting') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Typicons.cog_outline,
                                      size: 20,
                                      color: (userQueryAction == 'Card Setting') ? AppSettings.ColorMain : Colors.black,
                                      // color: (userQueryAction == 'Setting') ? AppSettings.ColorMain : Colors.grey.shade400,
                                    ),
                                    Text((widget.parentQuery == 'Home') ? ' Card Setting' : '',
                                        style: TextStyle(color: (userQueryAction == 'Card Setting') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'DownloadQR') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // ((userQueryAction != 'WriteNFC' && userQueryAction != 'QR Code' && userQueryAction != 'Preview') && CardType == 'tapcard')

                Column(
                  children: [
                    const Divider(
                      height: 20,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40,
                      color: Colors.grey,
                    ),
                    (userQueryAction == 'View' || userQueryAction == 'Edit')
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.blue.shade50,
                                  surfaceTintColor: Colors.blue.shade50,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
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
                                                          Text("Profile Data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                          Text("Total Profile: xxx / $CardProfilePermission", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
                                                          Text("Current Profile: $CardProfile", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(height: 10),
                                                  (CardProfile_collapse == '')
                                                      ? InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              CardProfile_collapse = 'Yes';
                                                              userQueryProfile = null;
                                                            });
                                                          },
                                                          child: Icon(Typicons.down_outline))
                                                      : Container(),
                                                  (CardProfile_collapse == 'Yes')
                                                      ? InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              CardProfile_collapse = '';
                                                            });
                                                          },
                                                          child: Icon(Typicons.cancel_outline))
                                                      : Container(),
                                                  SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                            Text('   '),
                                          ],
                                        ),
                                      ),
                                      (CardProfile_collapse == '')
                                          ? Container()
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5),
                                                InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        dataObjController.text = CardProfile;
                                                        userQueryAction = 'AddProfileName';
                                                      });
                                                    },
                                                    child: Text("[Add New Profile]", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16))),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      // Expanded(
                                                      //   flex: 1,
                                                      //   child: Column(
                                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                                      //     children: [
                                                      //       Column(
                                                      //         mainAxisAlignment: MainAxisAlignment.start,
                                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                                      //         children: [
                                                      //           Column(
                                                      //             mainAxisAlignment: MainAxisAlignment.start,
                                                      //             crossAxisAlignment: CrossAxisAlignment.start,
                                                      //             children: [
                                                      //               Text("[Add New Profile]", style: TextStyle(fontWeight: FontWeight.normal)),
                                                      //             ],
                                                      //           ),
                                                      //           SizedBox(height: 5),
                                                      //         ],
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // InkWell(
                                                            //   onTap: () async {
                                                            //     setState(() {
                                                            //       CardProfile = 'Default';
                                                            //       CardProfileid = 0;
                                                            //       _updateDb_UserDemo(widget.userQuery, 'CardProfile', CardProfile, null, '', '').then((_) {
                                                            //         _getDb_UserDemo(widget.userQuery).then((_) {
                                                            //           CardProfile_collapse = '';
                                                            //         });
                                                            //       });
                                                            //     });
                                                            //   },
                                                            //   child: Padding(
                                                            //     padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                            //     child: Row(
                                                            //       children: [
                                                            //         (CardProfile == 'Default')
                                                            //             ? Icon(
                                                            //                 FontAwesome5.check_square,
                                                            //                 size: 20,
                                                            //                 color: Colors.green,
                                                            //               )
                                                            //             : Icon(
                                                            //                 FontAwesome5.square,
                                                            //                 size: 18,
                                                            //               ),
                                                            //         Text("  Default Profile ", style: TextStyle(fontSize: 12)),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            // SizedBox(height: 2),
                                                            ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              shrinkWrap: true,
                                                              primary: false,
                                                              itemCount: listDb_UserDemoProfile.length,
                                                              itemBuilder: (BuildContext context, int position) {
                                                                return Container(
                                                                  // color: ((position + 1).isOdd) ? Colors.grey.shade50 : Colors.transparent,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 6,
                                                                          child: Card(
                                                                            color: Colors.white,
                                                                            surfaceTintColor: Colors.white,
                                                                            child: Row(
                                                                              children: [
                                                                                (this.listDb_UserDemoProfile[position].imageURL != '')
                                                                                    ? Container(
                                                                                        width: profilePictureSize,
                                                                                        height: profilePictureSize,
                                                                                        child: GestureDetector(
                                                                                          onTap: () {},
                                                                                          child: CircleAvatar(
                                                                                            backgroundColor: Colors.grey[200],
                                                                                            radius: profilePictureSize,
                                                                                            child: CircleAvatar(
                                                                                              backgroundColor: Colors.white,
                                                                                              radius: profilePictureSize - 4,
                                                                                              child: Hero(
                                                                                                tag: 'profilePicture',
                                                                                                child: (this.listDb_UserDemoProfile[position].imageURL != '')
                                                                                                    ? ClipOval(
                                                                                                        child: buildCacheNetworkImage(width: 50, height: 50, url: '${this.listDb_UserDemoProfile[position].imageURL}'),
                                                                                                      )
                                                                                                    : Container(),
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
                                                                                Column(
                                                                                  children: [
                                                                                    Text("  ${this.listDb_UserDemoProfile[position].ProfileName} ", style: TextStyle(fontSize: 12)),
                                                                                    Text("  ${this.listDb_UserDemoProfile[position].ProfileName} ", style: TextStyle(fontSize: 12)),
                                                                                    Text("  ${this.listDb_UserDemoProfile[position].ProfileName} ", style: TextStyle(fontSize: 12)),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: InkWell(
                                                                            onTap: () async {
                                                                              setState(() {
                                                                                CardProfile = this.listDb_UserDemoProfile[position].ProfileName;
                                                                                CardProfileid = int.parse(listDb_UserDemoProfile[position].id);
                                                                                // _updateDb_UserDemo(widget.userQuery, 'CardProfile', CardProfile, null, '', '');
                                                                                _updateDb_UserDemo(widget.userQuery, 'CardProfile', CardProfile, null, '', '').then((_) {
                                                                                  _getDb_UserDemo(widget.userQuery).then((_) {
                                                                                    CardProfile_collapse = '';
                                                                                    userQueryProfile = this.listDb_UserDemoProfile[position].CardProfile;
                                                                                  });
                                                                                });
                                                                              });
                                                                            },
                                                                            child: (CardProfile == this.listDb_UserDemoProfile[position].ProfileName)
                                                                                ? Icon(
                                                                                    FontAwesome5.check_square,
                                                                                    size: 30,
                                                                                    color: AppSettings.ColorMain,
                                                                                  )
                                                                                : Icon(
                                                                                    FontAwesome5.square,
                                                                                    size: 30,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 8.0,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    (userQueryAction == 'AddProfileName')
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Add New Profile:   ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    userQueryAction = 'View';
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  size: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                child: _addProfileNameForm(uuid, CardProfileid.toString()),
                              )
                            ],
                          )
                        : Container(),
                    (userQueryProfile == null)
                        ? Container()
                        : (userQueryAction == 'AddProfileName')
                            ? Container()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Profile Data Live On Card:   ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(
                                      //   FontAwesome5.database,
                                      //   size: 16,
                                      // ),
                                      Text('($CardProfileid)'),
                                      Text('  $CardProfile   '),

                                      (CardProfile == 'Default')
                                          ? Container()
                                          : (userQueryAction == 'EditProfileName')
                                              ? InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      userQueryAction = 'View';
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    size: 18,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      dataObjController.text = CardProfile;
                                                      userQueryAction = 'EditProfileName';
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 18,
                                                  ),
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                    (userQueryAction == 'EditProfileName')
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: _updateProfileNameForm(uuid, CardProfileid.toString()),
                          )
                        : Container(),
                    (userQueryProfile == null)
                        ? Container()
                        : (userQueryAction == 'View' || userQueryAction == 'Edit')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        userQueryAction = 'View';
                                      });
                                    },
                                    child: Card(
                                      surfaceTintColor: (userQueryAction == 'View') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text('View', style: TextStyle(color: (userQueryAction == 'View') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'View') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        userQueryAction = 'Edit';
                                        _groupValue = 0;
                                      });
                                    },
                                    child: Card(
                                      surfaceTintColor: (userQueryAction == 'Edit') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text('Edit', style: TextStyle(color: (userQueryAction == 'Edit') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'Edit') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showCupertinoDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoAlertDialog(
                                          title: Text('Delete Profile'),
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
                                                //   _listDb_UserGroup().then((_) {
                                                //     setState(() {
                                                //       userGroupidQuery = null;
                                                //       userGroupQuery = null;

                                                //       actionQuery = null;
                                                //       actionTextQuery = null;
                                                //       dataObj = '';
                                                //       dataObjController.text = '';
                                                //   });
                                                Navigator.pop(context);
                                                // });
                                                // });
                                                // -------
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Card(
                                      surfaceTintColor: (userQueryAction == 'Delete') ? Colors.grey.shade100 : AppSettings.ColorUnderline2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text('Delete', style: TextStyle(color: (userQueryAction == 'Delete') ? AppSettings.ColorMain : Colors.black, fontWeight: (userQueryAction == 'Delete') ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                    const Divider(
                      height: 20,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40,
                      color: Colors.grey,
                    ),
                  ],
                ),
                (userQueryProfile == null)
                    ? Container()
                    : (userQueryAction == 'View')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        (imageURL != '')
                                            ? Container(
                                                width: profilePictureSize,
                                                height: profilePictureSize,
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.grey[200],
                                                    radius: profilePictureSize,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      radius: profilePictureSize - 4,
                                                      child: Hero(
                                                        tag: 'profilePicture',
                                                        child: (imageURL != '')
                                                            ? ClipOval(
                                                                child: buildCacheNetworkImage(width: profilePictureSize - 4, height: profilePictureSize - 4, url: '$imageURL'),
                                                              )
                                                            : Container(),
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
                                        SizedBox(width: boxImageSize * 50 / 100),
                                        (themeURL == '')
                                            ? Container()
                                            : Card(
                                                surfaceTintColor: AppSettings.ColorUnderline2,
                                                elevation: 20,
                                                child: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize * 60 / 100, url: themeURL))),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                          width: 2,
                                          height: (CardType == 'tapcard') ? 80 : 280,
                                          color: Colors.grey[600],
                                        ),
                                        // -------------------------------TAPCARD
                                        (CardType == 'tapcard')
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Text('Name: $User_Name'),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (User_Name != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (User_Name != '') ? Text('${User_Name.toUpperCase()}') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (User_Title != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Title: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (User_Title != '') ? Text('${User_Title.toUpperCase()}') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (User_Dept != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Department: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (User_Dept != '') ? Text('${User_Dept.toUpperCase()}') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (User_Company != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Company: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (User_Company != '') ? Text('${User_Company.toUpperCase()}') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (User_Headline != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Headline: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (User_Headline != '') ? Text('${User_Headline.toUpperCase()}') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Text('----------'),
                                                  Text(''),
                                                ],
                                              )
                                            : Container(),
                                        // -------------------------------TAPCARD
                                        // -------------------------------TAPID
                                        (CardType == 'tapid')
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${UserTapID_Category.toUpperCase()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Status_Card != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('STATUS: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Status_Card != '') ? Text('${UserTapID_Status_Card.toUpperCase()}') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (User_Name != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (User_Name != '') ? Text('$User_Name') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Department != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Department: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Department != '') ? Text('$UserTapID_Department') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Company != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Company: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Company != '') ? Text('$UserTapID_Company') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Employee_id != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Employee Id: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Employee_id != '') ? Text('$UserTapID_Employee_id') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Text(''),
                                                  (UserTapID_Category == 'Local')
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: (UserTapID_IC != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                          children: [
                                                            Text('IC: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                            (UserTapID_IC != '') ? Text('$UserTapID_IC') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                          ],
                                                        )
                                                      : Container(),
                                                  (UserTapID_Category == 'Foreigner')
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: (UserTapID_Passport != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                          children: [
                                                            Text('Passport: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                            (UserTapID_Passport != '') ? Text('$UserTapID_Passport') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                          ],
                                                        )
                                                      : Container(),
                                                  (UserTapID_Category == 'Foreigner')
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: (UserTapID_Work_Permit_No != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                          children: [
                                                            Text('Work Permit No: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                            (UserTapID_Work_Permit_No != '') ? Text('$UserTapID_Work_Permit_No') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                          ],
                                                        )
                                                      : Container(),
                                                  (UserTapID_Category == 'Foreigner')
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: (UserTapID_Country_Of_Origin != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                          children: [
                                                            Text('Country Of Origin: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                            (UserTapID_Country_Of_Origin != '') ? Text('$UserTapID_Country_Of_Origin') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                          ],
                                                        )
                                                      : Container(),
                                                  Text(''),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Contact != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Contact: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Contact != '') ? Text('$UserTapID_Contact') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Emergency_Contact != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Emergency Contact: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Emergency_Contact != '') ? Text('$UserTapID_Emergency_Contact') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Text(''),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Blood_Type != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Blood Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Blood_Type != '') ? Text('$UserTapID_Blood_Type') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Allergies != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Allergies: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Allergies != '') ? Text('$UserTapID_Allergies') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Medical_Records != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Medical Records: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Medical_Records != '') ? Text('$UserTapID_Medical_Records') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: (UserTapID_Critical_Illness != '') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Critical Illness: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      (UserTapID_Critical_Illness != '') ? Text('$UserTapID_Critical_Illness') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                                    ],
                                                  ),
                                                  Text(''),
                                                  Text('----------'),
                                                  Text(''),
                                                ],
                                              )
                                            : Container(),
                                        // -------------------------------TAPID
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(Typicons.mobile))),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Phone: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                            (User_NoTel != '') ? Text('$User_NoTel') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(Typicons.mobile))),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Phone 2: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                            (User_NoTel2 != '') ? Text('$User_NoTel2') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(Typicons.phone_outline))),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Phone Office: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                            (User_NoTelOffice != '') ? Text('$User_NoTelOffice') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.whatsapp))),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [Text('WhatsApp: ', style: TextStyle(fontWeight: FontWeight.bold)), (User_WS != '') ? Text('$User_WS') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.telegram))),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Telegram: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                            (User_Telegram != '') ? Text('$User_Telegram') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.envelope))),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                            (User_Mail != '') ? Text('$User_Mail') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                          ],
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    // Row(
                                    //   children: [
                                    //     // Card(elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.envelope))),
                                    //     Row(
                                    //       mainAxisAlignment: MainAxisAlignment.start,
                                    //       crossAxisAlignment: CrossAxisAlignment.end,
                                    //       children: [
                                    //         Text('EMERGENCY CONTACT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    //         (UserTapID_Emergency_Contact != '') ? Text('$UserTapID_Emergency_Contact') : Text('Pls complete this field', style: TextStyle(color: Colors.red.shade300, fontSize: 10))
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 30),
                                    (User_YouTube == '' && User_FB == '' && User_Instagram == '' && User_X == '' && User_TikTok == '')
                                        ? Container()
                                        : Row(
                                            children: [
                                              Text(' Social'),
                                            ],
                                          ),
                                    Row(
                                      children: [
                                        (User_FB == '')
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _launchInBrowser(User_FB);
                                                },
                                                child: Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.facebook)))),
                                        (User_FB == '') ? Container() : SizedBox(width: 2),
                                        (User_Instagram == '')
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _launchInBrowser(User_Instagram);
                                                },
                                                child: Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.instagram)))),
                                        (User_Instagram == '') ? Container() : SizedBox(width: 2),
                                        (User_X == '')
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _launchInBrowser(User_X);
                                                },
                                                child: Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.xTwitter)))),
                                        (User_X == '') ? Container() : SizedBox(width: 2),
                                        (User_TikTok == '')
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _launchInBrowser(User_TikTok);
                                                },
                                                child: Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.tiktok)))),
                                        (User_TikTok == '') ? Container() : SizedBox(width: 2),
                                        (User_YouTube == '')
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _launchInBrowser(User_YouTube);
                                                },
                                                child: Card(surfaceTintColor: AppSettings.ColorUnderline2, elevation: 10, child: Padding(padding: const EdgeInsets.all(2.0), child: FaIcon(FontAwesomeIcons.youtube)))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                //---------------------------View
                //---------------------------Edit
                (userQueryAction == 'Edit')
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Card(
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: CupertinoSlidingSegmentedControl<int>(
                                      backgroundColor: Colors.grey.shade50,
                                      thumbColor: AppSettings.ColorMain,
                                      groupValue: _groupValue,
                                      children: {
                                        0: Text('Display', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12)),
                                        1: Text('Information', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12)),
                                        2: Text('Others', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12)),
                                      },
                                      onValueChanged: (groupValue) {
                                        print(groupValue);
                                        setState(() {
                                          _groupValue = groupValue;
                                          userQueryActionField = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // --------------

                                (_groupValue == 0)
                                    ? _editDisplay(
                                        widget.userQuery!,
                                      )
                                    : Container(),
                                (_groupValue == 1) ? _editInformation(widget.userQuery!) : Container(),
                                // (_groupValue == 2) ? _editOthers(widget.userQuery!) : Container(),
                                (_groupValue == 2) ? Container() : Container(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                //---------------------------Edit
                //---------------------------Preview
                (userQueryAction == 'Preview')
                    ? Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Authorization Code: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('$CardAuth'),
                                ],
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              activeColor: AppSettings.ColorMain,
                              value: _ValCardAuth!,
                              onChanged: (bool value) async {
                                setState(() {
                                  _ValCardAuth = value;
                                  if (_ValCardAuth == true) {
                                    CardAuth = 'Yes';
                                  } else {
                                    CardAuth = 'No';
                                  }
                                  _updateDb_UserDemo(widget.userQuery, 'CardAuth', CardAuth, null, '', '');
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: webViewHeight, // or any other height
                            width: MediaQuery.of(context).size.width - 50,
                            child: WebView(
                              initialUrl: ViewWebURL,
                              onWebViewCreated: (WebViewController c) {
                                controller = c;
                              },
                              javascriptMode: JavascriptMode.unrestricted,
                              gestureNavigationEnabled: true,
                              onPageStarted: (String url) {
                                // setState(() {
                                //   loading = true;
                                // });
                                print('Page started loading: $url');
                              },
                              onPageFinished: (_) async {
                                double height = double.parse(await controller!.runJavascriptReturningResult('document.documentElement.scrollHeight;'));
                                if (webViewHeight != height) {
                                  setState(() {
                                    webViewHeight = height;
                                  });
                                }
                                setState(() {
                                  loading = false;
                                });
                              },
                              // onPageFinished: (String url) {
                              //   updateHeight();
                              //   setState(() {
                              //     loading = false;
                              //   });
                              //   print('Page finished loading: $url');
                              // },
                            ),
                          ),
                          (loading)
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(),
                //---------------------------Preview
                //---------------------------Share
                (userQueryAction == 'Share')
                    ? Column(
                        children: [Text('TEXT')],
                      )
                    : Container(),
                //---------------------------QR Code
                //---------------------------WriteNFC
                (userQueryAction == 'WriteNFC')
                    ? (_writeLoading)
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
                                            _writeLoading = false;
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
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('Current NFC Serial Number'),
                                  Text(
                                    '$NFCTAGid',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text('Write To NFC'),
                              ElevatedButton(
                                onPressed: () async {
                                  _records = [];
                                  String _url = 'tapcard.tapbiz.my/tc/${widget.userQuery}';
                                  if (CardType == 'tapid') {
                                    _url = 'tapid.tapbiz.my/ti/${widget.userQuery}';
                                  }
                                  UriRecord uriRecord = ndef.UriRecord(
                                    prefix: "https://",
                                    content: _url,
                                  );
                                  _records?.add(uriRecord);
                                  setState(() {
                                    _writeLoading = true;
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
                                          _updateDb_UserDemo(Username, 'NFCTAGid', _tagSIRI.toString(), null, '', '');
                                          NFCTAGid = _tagSIRI!;
                                          // jumGroupCard_New = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid == '-').length).toString();
                                          // jumGroupCard_DoneNFC = (this.listDb_UserDemo.where((dblist) => dblist.NFCTAGid != '-').length).toString();
                                          // jumGroupCard_Pending = (int.parse(jumGroupCard_New!) + int.parse(jumGroupCard_DoneNFC!)).toString();
                                        });
                                      } else {
                                        setState(() {
                                          _writeResult = 'error: NDEF not supported: ${tag.type}';
                                          NFCTAGid = '-';
                                        });
                                      }
                                    } catch (e, stacktrace) {
                                      setState(() {
                                        _writeResult = 'error: $e';
                                        NFCTAGid = '-';
                                      });
                                      print(stacktrace);
                                    } finally {
                                      sleep(new Duration(milliseconds: 400!));
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
                                                      _writeLoading = false;
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
                                      _writeLoading = false;
                                    });
                                  }
                                  // --------------
                                },
                                child: Text("Start writing........."),
                              ),
                            ],
                          )
                    : Container(),
                //---------------------------WriteNFC

                //---------------------------Setting
                (userQueryAction == 'Card Setting')
                    ? (AccSetQuery == null)
                        ? Card(
                            surfaceTintColor: AppSettings.ColorUnderline2,
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _launchInBrowser('https://tapcard.tapbiz.my/tc/${widget.userQuery}');
                                          },
                                          child: Card(
                                            color: Colors.green.shade50,
                                            surfaceTintColor: Colors.green.shade50,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Typicons.cloud,
                                                        size: 14,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 4.0,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text("Launch", style: TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold)),
                                                          Text("Digital Card", style: TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold)),
                                                          Text("Web", style: TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  (CardType == 'tapcard')
                                                      ? QrImageView(
                                                          data: 'https://tapcard.tapbiz.my/tc/${widget.userQuery}',
                                                          version: QrVersions.auto,
                                                          size: 70.0,
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text('  '),
                                        InkWell(
                                          onTap: () async {
                                            await Clipboard.setData(ClipboardData(text: "https://tapcard.tapbiz.my/tc_edit/$uuid"));
                                          },
                                          child: Card(
                                            color: Colors.green.shade50,
                                            surfaceTintColor: Colors.green.shade50,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Typicons.edit,
                                                        size: 14,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 4.0,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text("Copy", style: TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold)),
                                                          Text("Editing URL", style: TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold)),
                                                          Text("To Clipboard", style: TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold)),
                                                        ],
                                                      ),

                                                      // Text("Copy Editing URL To Clipboard", style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  (CardType == 'tapcard')
                                                      ? QrImageView(
                                                          data: 'https://tapcard.tapbiz.my/tc_edit/$uuid',
                                                          version: QrVersions.auto,
                                                          size: 70.0,
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  // InkWell(
                                  //   onTap: () async {
                                  //     setState(() {
                                  //       AccSetQuery = 'Main Profile';
                                  //     });
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  //     child: SizedBox(
                                  //       height: 45,
                                  //       child: Card(
                                  //         color: Colors.yellow.shade50,
                                  //         surfaceTintColor: Colors.yellow.shade50,
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Row(
                                  //             mainAxisAlignment: MainAxisAlignment.start,
                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                  //             children: [
                                  //               Column(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Column(
                                  //                     mainAxisAlignment: MainAxisAlignment.start,
                                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                                  //                     children: [
                                  //                       Text("Main Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                                  //                     ],
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // (widget.parentQuery == 'Home') ? Container():SizedBox(height: 2),
                                  // (widget.parentQuery == 'Home') ? Container():
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        AccSetQuery = 'Account & Card';
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: SizedBox(
                                        height: 45,
                                        child: Card(
                                          color: Colors.purple.shade50,
                                          surfaceTintColor: Colors.purple.shade50,
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
                                                        Text("Account & Card - Link", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: SizedBox(
                                      height: 45,
                                      child: Card(
                                        color: Colors.blue.shade50,
                                        surfaceTintColor: Colors.blue.shade50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Authorization Code", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Transform.scale(
                                                scale: 0.6,
                                                child: CupertinoSwitch(
                                                  activeColor: AppSettings.ColorMain,
                                                  value: _ValCardAuth!,
                                                  onChanged: (bool value) async {
                                                    setState(() {
                                                      _ValCardAuth = value;
                                                      if (_ValCardAuth == true) {
                                                        CardAuth = 'Yes';
                                                      } else {
                                                        CardAuth = 'No';
                                                      }
                                                      _updateDb_UserDemo(widget.userQuery, 'CardAuth', CardAuth, null, '', '');
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 2),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  //   child: Card(
                                  //     color: Colors.blue.shade50,
                                  //     surfaceTintColor: Colors.blue.shade50,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.start,
                                  //         crossAxisAlignment: CrossAxisAlignment.center,
                                  //         children: [
                                  //           Column(
                                  //             mainAxisAlignment: MainAxisAlignment.start,
                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                  //             children: [
                                  //               Column(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Text("Profile Data", style: TextStyle(fontWeight: FontWeight.bold)),
                                  //                   Row(
                                  //                     children: [
                                  //                       Icon(
                                  //                         FontAwesome5.database,
                                  //                         size: 16,
                                  //                       ),
                                  //                       Text("  On - TapBiz Account ", style: TextStyle(fontSize: 12)),
                                  //                       (CardData == 'Default')
                                  //                           ? Icon(
                                  //                               Icons.check,
                                  //                               size: 16,
                                  //                               color: Colors.green,
                                  //                             )
                                  //                           : Container(),
                                  //                     ],
                                  //                   ),
                                  //                   SizedBox(height: 2),
                                  //                   Row(
                                  //                     children: [
                                  //                       Icon(
                                  //                         FontAwesome5.database,
                                  //                         size: 16,
                                  //                       ),
                                  //                       Text("  Off - Card ", style: TextStyle(fontSize: 12)),
                                  //                       (CardData == 'local')
                                  //                           ? Icon(
                                  //                               Icons.check,
                                  //                               size: 16,
                                  //                               color: Colors.green,
                                  //                             )
                                  //                           : Container(),
                                  //                     ],
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //           Spacer(),
                                  //           Transform.scale(
                                  //             scale: 0.6,
                                  //             child: CupertinoSwitch(activeColor: AppSettings.ColorMain, value: _ValCardData!, onChanged: null
                                  //                 // (bool value) async {
                                  //                 //   setState(() {
                                  //                 //     _ValCardData = value;
                                  //                 //     if (_ValCardData == true) {
                                  //                 //       CardData = 'main';
                                  //                 //     } else {
                                  //                 //       CardData = 'local';
                                  //                 //     }
                                  //                 //     _updateDb_UserDemo(widget.userQuery, 'CardData', CardData, null);
                                  //                 //   });
                                  //                 // },
                                  //                 ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(height: 8),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  //   child: SizedBox(
                                  //     height: 45,
                                  //     child: Card(
                                  //       color: Colors.red.shade50,
                                  //       surfaceTintColor: Colors.red.shade50,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.start,
                                  //           crossAxisAlignment: CrossAxisAlignment.center,
                                  //           children: [
                                  //             Column(
                                  //               mainAxisAlignment: MainAxisAlignment.start,
                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                  //               children: [
                                  //                 Column(
                                  //                   mainAxisAlignment: MainAxisAlignment.start,
                                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     Text("Pause Card", style: TextStyle(fontWeight: FontWeight.bold)),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //             Spacer(),
                                  //             Transform.scale(
                                  //               scale: 0.6,
                                  //               child: CupertinoSwitch(
                                  //                 activeColor: AppSettings.ColorMain,
                                  //                 value: _ValCardAuth!,
                                  //                 onChanged: (bool value) async {
                                  //                   setState(() {
                                  //                     _ValCardAuth = value;
                                  //                     if (_ValCardAuth == true) {
                                  //                       CardAuth = 'Yes';
                                  //                     } else {
                                  //                       CardAuth = 'No';
                                  //                     }
                                  //                     _updateDb_UserDemo(widget.userQuery, 'CardAuth', CardAuth, null, '', '');
                                  //                   });
                                  //                 },
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Text('$AccSetQuery', style: TextStyle(fontWeight: FontWeight.bold)),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    AccSetQuery = null;
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
                                height: 12,
                              ),
                              // -------------------------Main Profile
                              (AccSetQuery == 'Main Profile')
                                  ? Column(
                                      children: [
                                        Text('Main Profile'),
                                      ],
                                    )
                                  : Container(),
                              // -------------------------Main Profile
                              // -------------------------Main Profile
                              (AccSetQuery == 'Account & Card')
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: const Divider(
                                            height: 20,
                                            thickness: 1,
                                            indent: 40,
                                            endIndent: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Card(
                                          elevation: 20,
                                          color: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: _updateAccountForm('xxx', User_Email),
                                            ),
                                          ),
                                        ),
                                        // Text('Account Email: ${userCls!.userUser_Email}'),
                                        // Text('Card Email: $User_Email'),
                                        SizedBox(
                                          width: 200,
                                          child: const Divider(
                                            height: 20,
                                            thickness: 1,
                                            indent: 40,
                                            endIndent: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        // Text(''),
                                        // Text(''),
                                        // (userCls == null) ? Container() : Text('Account Email Data: ${userCls!.userUser_Email}'),
                                        // Text('Card Email Data: $User_Email'),
                                        // Text(''),
                                        // Text(''),
                                        // Text('Account Phone Data: ${userCls!.userUser_NoTel}'),
                                        // Text('Card Phone Data: $User_NoTel'),
                                        // Text(''),
                                        // Text(''),
                                        // Text(''),
                                        // Text(''),
                                        // Text('Account UsernameURL: $Username'),
                                        // Text('Card UsernameQr: $UsernameQR'),
                                      ],
                                    )
                                  : Container(),
                              // -------------------------Main Profile
                            ],
                          )
                    : Container(),
                //---------------------------Setting
                //---------------------------Setting
                (userQueryAction == 'Setting')
                    ? Card(
                        color: AppSettings.ColorUnderline2,
                        surfaceTintColor: AppSettings.ColorUnderline2,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('$userQueryActionSub', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                child: _addForm(userQueryActionSub!, Userid!, Groupid!),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                //---------------------------Setting
              ],
            ),
          );
  }

  Widget _addForm(String userQueryActionSub, int Userid, int Groupid) {
    userQueryActionFieldName = '';
    if (userQueryActionSub == 'Setting User ID') {
      userQueryActionFieldName = 'New User ID';
    }
    if (userQueryActionSub == 'Setting Group ID') {
      userQueryActionFieldName = 'New Group ID';
    }

    dataObj = dataObjController.text;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          (userQueryActionSub == 'Setting User ID') ? Text('Current User ID: $Userid') : Container(),
          (userQueryActionSub == 'Setting Group ID') ? Text('Current Group ID: $Groupid') : Container(),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
            child: TextFormField(
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
                        Text("Update", style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // _addDb_UserDemo();
                      }
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

  Future<Null> _addDb_UserDemo() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"Username": dataObj});

    apiUrl = 'GroupCardV2/addGroupCard';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        if (response.data['success'] == true) {
          setState(() {
            // _listDb_UserDemo_ByGroupid(userGroupidQuery!);
            // actionQuery = null;
            // dataObj = '';
            // dataObjController.text = '';
            // loading = false;
          });
        } else {
          setState(() {
            // actionTextQuery = response.data['message'];
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

  Future<Null> _listDb_Status(String Category) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {Userid};
    postdata = {
      "Category": Category,
    };
    apiUrl = 'GroupCardV2/listUserStatus';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdataStatus = (response.data as Map<String, dynamic>)['UserStatusList'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<TapBizStatusModel> _listDataStatus = [];
          for (int i = 0; i < listdataStatus.length; i++) _listDataStatus.add(TapBizStatusModel.fromJson(listdataStatus[i]));
          listDb_Status = _listDataStatus;
          listDb_StatusCount = _listDataStatus.length;

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

  Future<Null> _listDb_UserDemo() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {};
    apiUrl = 'GroupCardV2/listGroupCard';
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

  Future<Null> _getDb_UserDemo(String Username) async {
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
      final listdata = (response.data as Map<String, dynamic>)['UserDemoProfileList'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserTapBizModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserTapBizModel.fromJson(listdata[i]));
          listDb_UserDemoProfile = _listData;
          listDb_UserDemoProfileCount = _listData.length;

          uuid = response.data['uuid'] ?? "";
          Userid = response.data['Userid'] ?? null;
          Groupid = response.data['Groupid'] ?? null;
          NFCTAGid = response.data['NFCTAGid'] ?? '-';

          Flagdel = response.data['Flagdel'] ?? "";
          CardAuth = response.data['CardAuth'] ?? "";
          if (CardAuth == 'Yes') {
            _ValCardAuth = true;
          } else {
            _ValCardAuth = false;
          }

          CardData = response.data['CardData'] ?? "main";
          if (CardData == 'main') {
            _ValCardData = true;
          } else {
            _ValCardData = false;
          }

          CardProfilePermission = response.data['CardProfilePermission'] ?? 2;
          CardProfileid = response.data['CardProfileid'];
          CardProfile = response.data['CardProfile'] ?? "Default";

          CardType = response.data['CardType'] ?? "";
          Username = response.data['Username'] ?? "";
          UsernameQR = response.data['UsernameQR'] ?? "";
          imageURL = response.data['imageURL'] ?? "";
          themeURL = response.data['themeURL'] ?? "";

          User_Name = response.data['User_Name'] ?? "";
          User_IC = response.data['User_IC'] ?? "";
          User_Birthday = response.data['User_Birthday'] ?? "";
          User_Headline = response.data['User_Headline'] ?? "";

          User_Title = response.data['User_Title'] ?? "";
          User_Dept = response.data['User_Dept'] ?? "";
          User_Company = response.data['User_Company'] ?? "";
          User_Email = response.data['User_Email'] ?? "";
          User_NoTel = response.data['User_NoTel'] ?? "";
          User_NoTel2 = response.data['User_NoTel2'] ?? "";
          User_NoTelOffice = response.data['User_NoTelOffice'] ?? "";
          User_WS = response.data['User_WS'] ?? "";
          User_Telegram = response.data['User_Telegram'] ?? "";

          User_Mail = response.data['User_Mail'] ?? "";
          User_Emergency_Contact = response.data['User_Emergency_Contact'] ?? "";

          User_X = response.data['User_X'] ?? "";
          User_Instagram = response.data['User_Instagram'] ?? "";
          User_TikTok = response.data['User_TikTok'] ?? "";
          User_YouTube = response.data['User_YouTube'] ?? "";
          User_FB = response.data['User_FB'] ?? "";

          UserTapID_Category = response.data['UserTapID_Category'] ?? "";
          UserTapID_IC = response.data['UserTapID_IC'] ?? "";
          UserTapID_Passport = response.data['UserTapID_Passport'] ?? "";
          UserTapID_Work_Permit_No = response.data['UserTapID_Work_Permit_No'] ?? "";
          UserTapID_Country_Of_Origin = response.data['UserTapID_Country_Of_Origin'] ?? "";

          UserTapID_Department = response.data['UserTapID_Department'] ?? "";
          UserTapID_Company = response.data['UserTapID_Company'] ?? "";
          UserTapID_Employee_id = response.data['UserTapID_Employee_id'] ?? "";
          UserTapID_Contact = response.data['UserTapID_Contact'] ?? "";
          UserTapID_Emergency_Contact = response.data['UserTapID_Emergency_Contact'] ?? "";

          UserTapID_Blood_Type = response.data['UserTapID_Blood_Type'] ?? "";
          UserTapID_Allergies = response.data['UserTapID_Allergies'] ?? "";
          UserTapID_Medical_Records = response.data['UserTapID_Medical_Records'] ?? "";
          UserTapID_Critical_Illness = response.data['UserTapID_Critical_Illness'] ?? "";
          UserTapID_Status_Card = response.data['UserTapID_Status_Card'] ?? "";

          loading = false;
        });
        _listDb_UserDemo_ByUserid('1');
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

  Future<Null> _listDb_UserDemo_ByUserid(String userId) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {Userid};
    postdata = {
      "Userid": userId,
    };
    apiUrl = 'Theme/listTheme_ByPersonal';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdataTheme = (response.data as Map<String, dynamic>)['ThemeList'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<TapBizThemeModel> _listDataTheme = [];
          for (int i = 0; i < listdataTheme.length; i++) _listDataTheme.add(TapBizThemeModel.fromJson(listdataTheme[i]));
          listDb_Theme = _listDataTheme;
          listDb_ThemeCount = _listDataTheme.length;

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

  Future<Null> _updateDb_UserDemo(String Username, String userQueryActionField, String dataObj, File? image, String Data1, String Data2) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"Data1": Data1, "Data2": Data2, "Username": Username, "nedField": userQueryActionField, "nedField_Data": dataObj});

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
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      //--- Set State
      if (mounted) {
        setState(() {
          // List<UserTapBizModel> _listData = [];
          // for (int i = 0; i < listdata.length; i++) _listData.add(UserTapBizModel.fromJson(listdata[i]));
          // listDb_UserDemo = _listData;
          // listDb_UserDemoCount = _listData.length;

          uuid = response.data['uuid'] ?? "";
          Userid = response.data['Userid'] ?? null;
          Groupid = response.data['Groupid'] ?? null;

          Flagdel = response.data['Flagdel'] ?? "";
          CardAuth = response.data['CardAuth'] ?? "";
          if (CardAuth == 'Yes') {
            _ValCardAuth = true;
          } else {
            _ValCardAuth = false;
          }

          CardData = response.data['CardData'] ?? "main";
          if (CardData == 'main') {
            _ValCardData = true;
          } else {
            _ValCardData = false;
          }

          CardProfilePermission = response.data['CardProfilePermission'] ?? 2;
          CardProfileid = response.data['CardProfileid'];
          CardProfile = response.data['CardProfile'] ?? "Default";
          CardType = response.data['CardType'] ?? "";
          Username = response.data['Username'] ?? "";
          UsernameQR = response.data['UsernameQR'] ?? "";
          imageURL = response.data['imageURL'] ?? "";
          themeURL = response.data['themeURL'] ?? "";

          User_Name = response.data['User_Name'] ?? "";
          User_IC = response.data['User_IC'] ?? "";
          User_Birthday = response.data['User_Birthday'] ?? "";
          User_Headline = response.data['User_Headline'] ?? "";

          User_Title = response.data['User_Title'] ?? "";
          User_Dept = response.data['User_Dept'] ?? "";
          User_Company = response.data['User_Company'] ?? "";
          User_Email = response.data['User_Email'] ?? "";
          User_NoTel = response.data['User_NoTel'] ?? "";
          User_NoTel2 = response.data['User_NoTel2'] ?? "";
          User_NoTelOffice = response.data['User_NoTelOffice'] ?? "";
          User_WS = response.data['User_WS'] ?? "";
          User_Telegram = response.data['User_Telegram'] ?? "";

          User_Mail = response.data['User_Mail'] ?? "";
          User_Emergency_Contact = response.data['User_Emergency_Contact'] ?? "";

          User_X = response.data['User_X'] ?? "";
          User_Instagram = response.data['User_Instagram'] ?? "";
          User_TikTok = response.data['User_TikTok'] ?? "";
          User_YouTube = response.data['User_YouTube'] ?? "";
          User_FB = response.data['User_FB'] ?? "";

          UserTapID_Category = response.data['UserTapID_Category'] ?? "";
          UserTapID_IC = response.data['UserTapID_IC'] ?? "";
          UserTapID_Passport = response.data['UserTapID_Passport'] ?? "";
          UserTapID_Work_Permit_No = response.data['UserTapID_Work_Permit_No'] ?? "";
          UserTapID_Country_Of_Origin = response.data['UserTapID_Country_Of_Origin'] ?? "";

          UserTapID_Department = response.data['UserTapID_Department'] ?? "";
          UserTapID_Company = response.data['UserTapID_Company'] ?? "";
          UserTapID_Employee_id = response.data['UserTapID_Employee_id'] ?? "";
          UserTapID_Contact = response.data['UserTapID_Contact'] ?? "";
          UserTapID_Emergency_Contact = response.data['UserTapID_Emergency_Contact'] ?? "";

          UserTapID_Blood_Type = response.data['UserTapID_Blood_Type'] ?? "";
          UserTapID_Allergies = response.data['UserTapID_Allergies'] ?? "";
          UserTapID_Medical_Records = response.data['UserTapID_Medical_Records'] ?? "";
          UserTapID_Critical_Illness = response.data['UserTapID_Critical_Illness'] ?? "";
          UserTapID_Status_Card = response.data['UserTapID_Status_Card'] ?? "";

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

  Widget _editDisplay(String userQuery) {
    final double profilePictureSize = MediaQuery.of(context).size.width / 4;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppSettings.ColorUnderline2,
          surfaceTintColor: AppSettings.ColorUnderline2,
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                  color: Colors.grey,
                ),
                (_selectedFile == null)
                    ? Container()
                    : (_selectedCropFile == null)
                        ? Column(
                            children: [
                              Center(
                                child: CropImage(
                                  controller: cropcontroller,
                                  image: Image.file(
                                    _selectedFile!,
                                  ),
                                  paddingSize: 25.0,
                                  alwaysMove: false,
                                  alwaysShowThirdLines: true,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                                        return AppSettings.ColorMain;
                                        // return Colors.red;
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
                                        Text("Crop", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    onPressed: () async {
                                      DateTime now = DateTime.now();
                                      final tempDir = await getApplicationDocumentsDirectory();
                                      File file = File("${tempDir.path}/$now.png");
                                      ui.Image bitmap = await cropcontroller.croppedBitmap();
                                      ByteData? data = await bitmap.toByteData(format: ImageByteFormat.png);
                                      var bytes = data!.buffer.asUint8List();
                                      file = await file.writeAsBytes(bytes, flush: true);

                                      setState(() {
                                        _selectedFile = file;
                                        _selectedCropFile = file;
                                      });
                                      // _finished();
                                    },
                                  ),
                                  Text(' '),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                                        return Colors.red;
                                        // return Colors.red;
                                      }),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedFile = null;
                                        _selectedCropFile = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                // (_selectedCropFile != null)?Container():
                Column(
                  children: [
                    Text('DISPLAY'),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (_selectedFile == null && imageURL != '')
                                ? Container(
                                    width: profilePictureSize,
                                    height: profilePictureSize,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius: profilePictureSize,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: profilePictureSize - 4,
                                          child: Hero(
                                            tag: 'profilePicture',
                                            child: (imageURL != '')
                                                ? ClipOval(
                                                    child: buildCacheNetworkImage(width: profilePictureSize - 4, height: profilePictureSize - 4, url: '$imageURL'),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : _getImageWidget(),
                            // (_selectedCropFile!=null)?
                            // _getImageWidget():Container(),
                            // -----------------
                            SizedBox(
                              height: 4,
                            ),
                            (_selectedFile == null && imageURL != '')
                                ? SizedBox(
                                    height: 25,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                                          // return AppSettings.ColorMain;
                                          return Colors.grey.shade50;
                                        }),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Typicons.trash, size: 16, color: AppSettings.ColorMain),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Text("Delete", style: TextStyle(color: Colors.black, fontSize: 12.0)),
                                        ],
                                      ),
                                      onPressed: () {
                                        showCupertinoDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) => CupertinoAlertDialog(
                                            title: Text('Delete'),
                                            content: Text('Are you sure?'),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                child: Text('No', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('Yes', style: TextStyle(color: AppSettings.ColorMain, fontWeight: FontWeight.bold)),
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  // -------
                                                  if (_selectedFile != null) {
                                                    int lastIndex = _selectedFile.absolute.path.lastIndexOf(new RegExp(r'.jp'));
                                                    if (lastIndex < 0) {
                                                    } else {
                                                      compressImage(_selectedFile);
                                                    }
                                                  }
                                                  _image = _selectedFile;
                                                  _updateDb_UserDemo(userQuery, 'image', '', _image, '', '');
                                                  _selectedFile = null;
                                                  // -------
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),

                            (_selectedCropFile != null)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // bottomNavigationBar: _buildButtons(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 25,
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                  return AppSettings.ColorMain;
                                                  // return Colors.red;
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
                                                  Text("Save", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              onPressed: () {
                                                if (_selectedFile != null) {
                                                  int lastIndex = _selectedFile.absolute.path.lastIndexOf(new RegExp(r'.jp'));
                                                  if (lastIndex < 0) {
                                                  } else {
                                                    compressImage(_selectedFile);
                                                  }
                                                }
                                                _image = _selectedFile;
                                                _updateDb_UserDemo(userQuery, 'image', '', _image, '', '');
                                                _selectedCropFile = null;
                                                _selectedFile = null;
                                                // context.read<DbDataProfilBloc_Profil>().add(UpdateDbDataProfil(widget.userCls!.userUser_IC, widget.nedField!, '', _image));
                                              },
                                            ),
                                            Text(' '),
                                            (_selectedCropFile != null)
                                                ? InkWell(
                                                    onTap: () {
                                                      _removeImage();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.cancel_outlined,
                                                          color: Colors.red,
                                                          size: 16,
                                                        ),
                                                        Text(' Remove')
                                                      ],
                                                    ))
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (!kIsWeb)
                                ? SizedBox(
                                    height: 25,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                                          // return AppSettings.ColorMain;
                                          return Colors.grey.shade50;
                                        }),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_alt, size: 16, color: AppSettings.ColorMain),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Text("Camera", style: TextStyle(color: Colors.black, fontSize: 12.0)),
                                        ],
                                      ),
                                      onPressed: () {
                                        _selectedCropFile = null;
                                        _askPermissionCamera();
                                      },
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Container(
                              height: 10,
                            ),
                            SizedBox(
                              height: 25,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                    // return AppSettings.ColorMain;
                                    return Colors.grey.shade50;
                                  }),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo, size: 16, color: AppSettings.ColorMain),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text("Gallery", style: TextStyle(color: Colors.black, fontSize: 12.0)),
                                  ],
                                ),
                                onPressed: () {
                                  _selectedCropFile = null;
                                  if (kIsWeb) {
                                    _getImage(ImageSource.gallery);
                                  } else {
                                    if (IO.Platform.isIOS) {
                                      _askPermissionStorage();
                                    } else {
                                      _askPermissionPhotos();
                                    }
                                  }
                                },
                              ),
                            ),
                            // GestureDetector(
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: <Widget>[
                            //       Icon(
                            //         Icons.photo,
                            //         color: AppSettings.ColorMain,
                            //         size: 30,
                            //       ),
                            //       SizedBox(width: 10),
                            //       Text('Gallery'),
                            //     ],
                            //   ),
                            //   onTap: () {
                            //     if (kIsWeb) {
                            //       _getImage(ImageSource.gallery);
                            //     } else {
                            //       if (IO.Platform.isIOS) {
                            //         _askPermissionStorage();
                            //       } else {
                            //         _askPermissionPhotos();
                            //       }
                            //     }
                            //   },
                            // ),
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

        (_selectedFile != null)
            ? Container()
            : Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        indent: 40,
                        endIndent: 40,
                        color: Colors.grey,
                      ),
                      Text('THEMES'),
                      _AllTheme(userQuery),
                    ],
                  ),
                ),
              ),

        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     Expanded(
        //       child: ElevatedButton(
        //         style: ButtonStyle(
        //           backgroundColor: MaterialStateProperty.resolveWith((states) {
        //             // return AppSettings.ColorUpperline;
        //             return Colors.grey;
        //           }),
        //         ),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             // Icon(LineariconsFree.rocket),
        //             SizedBox(
        //               width: 8.0,
        //             ),
        //             Text("Padam Gambar", style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold)),
        //           ],
        //         ),
        //         onPressed: () {
        //           if (_selectedFile != null) {
        //             int lastIndex = _selectedFile.absolute.path.lastIndexOf(new RegExp(r'.jp'));
        //             if (lastIndex < 0) {
        //             } else {
        //               compressImage(_selectedFile);
        //             }
        //           }
        //           _image = _selectedFile;
        //           // context.read<DbDataProfilBloc_Profil>().add(UpdateDbDataProfil(widget.userCls!.userUser_IC, widget.nedField!, '', _image));
        //         },
        //       ),
        //     ),
        //     Text('   '),
        //     Expanded(
        //       child: ElevatedButton(
        //         style: ButtonStyle(
        //           backgroundColor: MaterialStateProperty.resolveWith((states) {
        //             // return AppSettings.ColorUpperline;
        //             return Colors.grey;
        //           }),
        //         ),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             // Icon(LineariconsFree.rocket),
        //             SizedBox(
        //               width: 8.0,
        //             ),
        //             Text("Batal", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
        //           ],
        //         ),
        //         onPressed: () {
        //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyPageProfil()));
        //         },
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _AllTheme(String userQuery) {
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
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildItemTheme(index, userQuery);
                },
                childCount: listDb_Theme.length,
              ),
            ),
          ),
        ])
      ],
    );
  }

  Widget _buildItemTheme(index, userQuery) {
    final double boxImageSize = ((MediaQuery.of(context).size.width) - 24) / 2 - 16;
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        surfaceTintColor: (listDb_Theme[index].themeURL != themeURL) ? AppSettings.ColorUnderline2 : AppSettings.ColorMain,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              if (listDb_Theme[index].themeURL != themeURL) {
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('Change Theme'),
                    content: Text('Are you sure?'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: Text('No', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('Yes', style: TextStyle(color: AppSettings.ColorMain, fontWeight: FontWeight.bold)),
                        isDestructiveAction: true,
                        onPressed: () {
                          // -------
                          _updateDb_UserDemo(userQuery, 'themeURL', listDb_Theme[index].themeURL, null, '', '');
                          // -------
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              }
            });
          },
          child: Column(
            children: <Widget>[
              // Text('boxImageSize: $boxImageSize'),
              (this.listDb_Theme[index].themeURL == '')
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: 'https://storage.googleapis.com/tapbiz/theme_card/webcard/covertapbiz3.jpg'))
                  : ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: this.listDb_Theme[index].themeURL)),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (listDb_Theme[index].themeURL == themeURL) ? Icon(Typicons.ok, size: 16, color: _color1) : Icon(Typicons.download, size: 16, color: _color1),
                    Text(
                      '  ${listDb_Theme[index].ThemeName}',
                      style: TextStyle(fontSize: 10, color: _color1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Text(
                    //   listDb_Theme[index].themeURL,
                    //   style: TextStyle(fontSize: 12, color: _color1),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // Text(
                    //   themeURL,
                    //   style: TextStyle(fontSize: 12, color: _color1),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
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

  Widget _editInformation(String Username) {
    // final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (CardType == 'tapcard')
                ?
                // -------------------------------TAPCARD
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (userQueryActionField == null ||
                              userQueryActionField == 'User_Name' ||
                              userQueryActionField == 'User_Title' ||
                              userQueryActionField == 'User_Dept' ||
                              userQueryActionField == 'User_Company' ||
                              userQueryActionField == 'User_Headline')
                          ? Text('INFORMATION')
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'User_Name')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (User_Name != '')
                                          ? Row(
                                              children: [
                                                Text('NAME: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$User_Name')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Name',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'User_Name';
                                                userQueryActionFieldName = 'NAME';
                                                dataObjController.text = User_Name;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (User_Name != '') {
                                                  User_Name = User_Name.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = User_Name;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'User_Title')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (User_Title != '')
                                          ? Row(
                                              children: [
                                                Text('TITLE: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$User_Title')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Title',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'User_Title';
                                                userQueryActionFieldName = 'TITLE';
                                                dataObjController.text = User_Title;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (User_Title != '') {
                                                  User_Title = User_Title.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = User_Title;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'User_Dept')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (User_Dept != '')
                                          ? Row(
                                              children: [
                                                Text('DEPARTMENT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$User_Dept')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Department',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'User_Dept';
                                                userQueryActionFieldName = 'DEPARTMENT';
                                                dataObjController.text = User_Dept;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (User_Dept != '') {
                                                  User_Dept = User_Dept.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = User_Dept;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'User_Company')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (User_Company != '')
                                          ? Row(
                                              children: [
                                                Text('COMPANY: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$User_Company')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Company',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'User_Company';
                                                userQueryActionFieldName = 'COMPANY';
                                                dataObjController.text = User_Company;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (User_Company != '') {
                                                  User_Company = User_Company.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = User_Company;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'User_Headline')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (User_Headline != '')
                                          ? Row(
                                              children: [
                                                Text('HEADLINE: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$User_Headline')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Headline',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'User_Headline';
                                                userQueryActionFieldName = 'HEADLINE';
                                                dataObjController.text = User_Headline;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (User_Headline != '') {
                                                  User_Headline = User_Headline.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = User_Headline;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),

            // -------------------------------TAPCARD
            // -------------------------------TAPID
            (CardType == 'tapid')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INFORMATION'),
                      // ---------
                      SizedBox(
                        height: 10,
                      ),
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Status_Card')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Status_Card != '')
                                          ? Row(
                                              children: [
                                                Text('STATUS: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('${UserTapID_Status_Card.toUpperCase()}')),
                                              ],
                                            )
                                          : Text(
                                              'Enter STATUS',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(''),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Status_Card';
                                                userQueryActionFieldName = 'STATUS';
                                                dataObjController.text = UserTapID_Status_Card;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Status_Card != '') {
                                                  UserTapID_Status_Card = UserTapID_Status_Card.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Status_Card;
                                                }
                                                // -----------
                                                _listDb_Status(UserTapID_Category);
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      SizedBox(
                        height: 10,
                      ),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'User_Name')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (User_Name != '')
                                          ? Row(
                                              children: [
                                                Text('NAME: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$User_Name')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Name',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'User_Name';
                                                userQueryActionFieldName = 'NAME';
                                                dataObjController.text = User_Name;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (User_Name != '') {
                                                  User_Name = User_Name.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = User_Name;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Department')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Department != '')
                                          ? Row(
                                              children: [
                                                Text('DEPARTMENT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Department')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Department',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Department';
                                                userQueryActionFieldName = 'DEPARTMENT';
                                                dataObjController.text = UserTapID_Department;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Department != '') {
                                                  UserTapID_Department = UserTapID_Department.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Department;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Company')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Company != '')
                                          ? Row(
                                              children: [
                                                Text('COMPANY: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Company')),
                                              ],
                                            )
                                          : Text(
                                              'Enter Company',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Company';
                                                userQueryActionFieldName = 'COMPANY';
                                                dataObjController.text = UserTapID_Company;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Company != '') {
                                                  UserTapID_Company = UserTapID_Company.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Company;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),

                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Employee_id')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Employee_id != '')
                                          ? Row(
                                              children: [
                                                Text('EMPLOYEE ID: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Employee_id')),
                                              ],
                                            )
                                          : Text(
                                              'Enter EMPLOYEE ID',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Employee_id';
                                                userQueryActionFieldName = 'EMPLOYEE ID';
                                                dataObjController.text = UserTapID_Employee_id;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Employee_id != '') {
                                                  UserTapID_Employee_id = UserTapID_Employee_id.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Employee_id;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      Text(''),
                      Text(''),
                      // ---------
                      ((UserTapID_Category == 'Local') && (userQueryActionField == null || userQueryActionField == 'UserTapID_IC'))
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_IC != '')
                                          ? Row(
                                              children: [
                                                Text('IC: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_IC')),
                                              ],
                                            )
                                          : Text(
                                              'Enter IC',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_IC';
                                                userQueryActionFieldName = 'IC';
                                                dataObjController.text = UserTapID_IC;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_IC != '') {
                                                  UserTapID_IC = UserTapID_IC.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_IC;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // Text(''),
                      // Text(''),
                      // ---------
                      ((UserTapID_Category == 'Foreigner') && (userQueryActionField == null || userQueryActionField == 'UserTapID_Passport'))
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Passport != '')
                                          ? Row(
                                              children: [
                                                Text('PASSPORT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Passport')),
                                              ],
                                            )
                                          : Text(
                                              'Enter PASSPORT',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Passport';
                                                userQueryActionFieldName = 'PASSPORT';
                                                dataObjController.text = UserTapID_Passport;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Passport != '') {
                                                  UserTapID_Passport = UserTapID_Passport.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Passport;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // ---------
                      ((UserTapID_Category == 'Foreigner') && (userQueryActionField == null || userQueryActionField == 'UserTapID_Work_Permit_No'))
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Work_Permit_No != '')
                                          ? Row(
                                              children: [
                                                Text('WORK PERMIT NO: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Work_Permit_No')),
                                              ],
                                            )
                                          : Text(
                                              'Enter WORK PERMIT NO',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Work_Permit_No';
                                                userQueryActionFieldName = 'WORK PERMIT NO';
                                                dataObjController.text = UserTapID_Work_Permit_No;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Work_Permit_No != '') {
                                                  UserTapID_Work_Permit_No = UserTapID_Work_Permit_No.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Work_Permit_No;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // ---------
                      ((UserTapID_Category == 'Foreigner') && (userQueryActionField == null || userQueryActionField == 'UserTapID_Country_Of_Origin'))
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Country_Of_Origin != '')
                                          ? Row(
                                              children: [
                                                Text('COUNTRY OF ORIGIN: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Country_Of_Origin')),
                                              ],
                                            )
                                          : Text(
                                              'Enter COUNTRY OF ORIGIN',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Country_Of_Origin';
                                                userQueryActionFieldName = 'COUNTRY OF ORIGIN';
                                                dataObjController.text = UserTapID_Country_Of_Origin;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Country_Of_Origin != '') {
                                                  UserTapID_Country_Of_Origin = UserTapID_Country_Of_Origin.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Country_Of_Origin;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      Text(''),
                      Text(''),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Contact')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Contact != '')
                                          ? Row(
                                              children: [
                                                Text('CONTACT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Contact')),
                                              ],
                                            )
                                          : Text(
                                              'Enter CONTACT',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Contact';
                                                userQueryActionFieldName = 'CONTACT';
                                                dataObjController.text = UserTapID_Contact;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Contact != '') {
                                                  UserTapID_Contact = UserTapID_Contact.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Contact;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Emergency_Contact')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Emergency_Contact != '')
                                          ? Row(
                                              children: [
                                                Text('EMERGENCY CONTACT: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Emergency_Contact')),
                                              ],
                                            )
                                          : Text(
                                              'Enter EMERGENCY CONTACT',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Emergency_Contact';
                                                userQueryActionFieldName = 'EMERGENCY CONTACT';
                                                dataObjController.text = UserTapID_Emergency_Contact;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Emergency_Contact != '') {
                                                  UserTapID_Emergency_Contact = UserTapID_Emergency_Contact.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Emergency_Contact;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      Text(''),
                      Text(''),
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Blood_Type')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Blood_Type != '')
                                          ? Row(
                                              children: [
                                                Text('BLOOD TYPE: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Blood_Type')),
                                              ],
                                            )
                                          : Text(
                                              'Enter BLOOD TYPE',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Blood_Type';
                                                userQueryActionFieldName = 'BLOOD TYPE';
                                                dataObjController.text = UserTapID_Blood_Type;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Blood_Type != '') {
                                                  UserTapID_Blood_Type = UserTapID_Blood_Type.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Blood_Type;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Allergies')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Allergies != '')
                                          ? Row(
                                              children: [
                                                Text('ALLERGIES: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Allergies')),
                                              ],
                                            )
                                          : Text(
                                              'Enter ALLERGIES',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Allergies';
                                                userQueryActionFieldName = 'ALLERGIES';
                                                dataObjController.text = UserTapID_Allergies;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Allergies != '') {
                                                  UserTapID_Allergies = UserTapID_Allergies.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Allergies;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Medical_Records')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Medical_Records != '')
                                          ? Row(
                                              children: [
                                                Text('MEDICAL RECORDS: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Medical_Records')),
                                              ],
                                            )
                                          : Text(
                                              'Enter MEDICAL RECORDS',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Medical_Records';
                                                userQueryActionFieldName = 'MEDICAL RECORDS';
                                                dataObjController.text = UserTapID_Medical_Records;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Medical_Records != '') {
                                                  UserTapID_Medical_Records = UserTapID_Medical_Records.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Medical_Records;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                      // ---------
                      (userQueryActionField == null || userQueryActionField == 'UserTapID_Critical_Illness')
                          ? Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: (UserTapID_Critical_Illness != '')
                                          ? Row(
                                              children: [
                                                Text('CRITICAL ILLNESS: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Expanded(child: Text('$UserTapID_Critical_Illness')),
                                              ],
                                            )
                                          : Text(
                                              'Enter CRITICAL ILLNESS',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                    ),
                                    Text(' '),
                                    (userQueryActionField != null)
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                userQueryActionField = 'UserTapID_Critical_Illness';
                                                userQueryActionFieldName = 'CRITICAL ILLNESS';
                                                dataObjController.text = UserTapID_Critical_Illness;
                                                // -----------
                                                userQueryActionFieldURL = '';
                                                if (UserTapID_Critical_Illness != '') {
                                                  UserTapID_Critical_Illness = UserTapID_Critical_Illness.replaceAll(userQueryActionFieldURL!, '');
                                                  dataObjController.text = UserTapID_Critical_Illness;
                                                }
                                                // -----------
                                              });
                                            },
                                            child: Icon(
                                              FontAwesome5.edit,
                                              size: 20.0,
                                              color: AppSettings.ColorMain,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // ---------
                    ],
                  )
                : Container(),

            // String UserTapID_IC = '';xxx
            // String UserTapID_Passport = '';xxx
            // String UserTapID_Work_Permit_No = '';xxx
            // String UserTapID_Country_Of_Origin = '';xxx

            // String UserTapID_Department = '';xxx
            // String UserTapID_Company = '';xxx
            // String UserTapID_Employee_id = '';xxx
            // String UserTapID_Contact = '';
            // String UserTapID_Emergency_Contact = '';

            // String UserTapID_Blood_Type = '';
            // String UserTapID_Allergies = '';
            // String UserTapID_Medical_Records = '';
            // String UserTapID_Critical_Illness = '';
            // String UserTapID_Status_Card = '';

            // -------------------------------TAPID
            (userQueryActionField == null ||
                    userQueryActionField == 'User_NoTel' ||
                    userQueryActionField == 'User_NoTel2' ||
                    userQueryActionField == 'User_NoTelOffice' ||
                    userQueryActionField == 'User_WS' ||
                    userQueryActionField == 'User_Telegram' ||
                    userQueryActionField == 'User_Mail' ||
                    userQueryActionField == 'User_Emergency_Contact')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(''),
                      Text('CONTACT'),
                    ],
                  )
                : Container(),
            // ---------
            (userQueryActionField == null || userQueryActionField == 'User_NoTel')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    Typicons.mobile,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_NoTel != '')
                                ? Text('$User_NoTel')
                                : Text(
                                    'Enter Phone',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_NoTel';
                                      userQueryActionFieldName = 'Phone';
                                      dataObjController.text = User_NoTel;
                                      // -----------
                                      userQueryActionFieldURL = '';
                                      if (User_NoTel != '') {
                                        User_NoTel = User_NoTel.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_NoTel;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_NoTel2')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    Typicons.mobile,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_NoTel2 != '')
                                ? Text('$User_NoTel2')
                                : Text(
                                    'Enter Phone 2',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_NoTel2';
                                      userQueryActionFieldName = 'Phone 2';
                                      dataObjController.text = User_NoTel2;
                                      // -----------
                                      userQueryActionFieldURL = '';
                                      if (User_NoTel2 != '') {
                                        User_NoTel2 = User_NoTel2.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_NoTel2;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_NoTelOffice')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    Typicons.phone_outline,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_NoTelOffice != '')
                                ? Text('$User_NoTelOffice')
                                : Text(
                                    'Enter Phone Office',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_NoTelOffice';
                                      userQueryActionFieldName = 'Phone Office';
                                      dataObjController.text = User_NoTelOffice;
                                      // -----------
                                      userQueryActionFieldURL = '';
                                      if (User_NoTelOffice != '') {
                                        User_NoTelOffice = User_NoTelOffice.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_NoTelOffice;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_WS')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_WS != '')
                                ? Text('$User_WS')
                                : Text(
                                    'Enter WhatsApp',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_WS';
                                      userQueryActionFieldName = 'WhatsApp';
                                      dataObjController.text = User_WS;
                                      // -----------
                                      userQueryActionFieldURL = '+6';
                                      if (User_WS != '') {
                                        User_WS = User_WS.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_WS;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_Telegram')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.telegram,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_Telegram != '')
                                ? Text('$User_Telegram')
                                : Text(
                                    'Enter Telegram',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_Telegram';
                                      userQueryActionFieldName = 'Telegram';
                                      dataObjController.text = User_Telegram;
                                      // -----------
                                      userQueryActionFieldURL = '+6';
                                      if (User_Telegram != '') {
                                        User_Telegram = User_Telegram.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_Telegram;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_Mail')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.envelope,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_Mail != '')
                                ? Text('$User_Mail')
                                : Text(
                                    'Enter Email',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_Mail';
                                      userQueryActionFieldName = 'Email';
                                      dataObjController.text = User_Mail;
                                      // -----------
                                      userQueryActionFieldURL = '';
                                      if (User_Mail != '') {
                                        User_Mail = User_Mail.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_Mail;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            // ---------
            // (userQueryActionField == null || userQueryActionField == 'UserTapID_Emergency_Contact')
            //     ? Card(
            //         color: AppSettings.ColorUnderline2,
            //         surfaceTintColor: AppSettings.ColorUnderline2,
            //         elevation: 10,
            //         child: Padding(
            //           padding: const EdgeInsets.all(4.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: <Widget>[
            //               Expanded(
            //                 child: (UserTapID_Emergency_Contact != '')
            //                     ? Row(
            //                         children: [
            //                           Text('EMERGENCY CONTACT: ', style: TextStyle(fontWeight: FontWeight.bold)),
            //                           Expanded(child: Text('$UserTapID_Emergency_Contact')),
            //                         ],
            //                       )
            //                     : Text(
            //                         'Enter EMERGENCY CONTACT',
            //                         style: TextStyle(color: Colors.grey),
            //                       ),
            //               ),
            //               Text(' '),
            //               (userQueryActionField != null)
            //                   ? Container()
            //                   : InkWell(
            //                       onTap: () {
            //                         setState(() {
            //                           userQueryActionField = 'UserTapID_Emergency_Contact';
            //                           userQueryActionFieldName = 'EMERGENCY CONTACT';
            //                           dataObjController.text = UserTapID_Emergency_Contact;
            //                           // -----------
            //                           userQueryActionFieldURL = '';
            //                           if (UserTapID_Emergency_Contact != '') {
            //                             UserTapID_Emergency_Contact = UserTapID_Emergency_Contact.replaceAll(userQueryActionFieldURL!, '');
            //                             dataObjController.text = UserTapID_Emergency_Contact;
            //                           }
            //                           // -----------
            //                         });
            //                       },
            //                       child: Icon(
            //                         FontAwesome5.edit,
            //                         size: 20.0,
            //                         color: AppSettings.ColorMain,
            //                       ),
            //                     )
            //             ],
            //           ),
            //         ),
            //       )
            //     : Container(),
            Text(''),
            (userQueryActionField == null || userQueryActionField == 'User_YouTube' || userQueryActionField == 'User_FB' || userQueryActionField == 'User_Instagram' || userQueryActionField == 'User_X' || userQueryActionField == 'User_TikTok')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(''),
                      Text('SOCIAL'),
                    ],
                  )
                : Container(),

            (userQueryActionField == null || userQueryActionField == 'User_FB')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_FB != '')
                                ? Text('${User_FB.replaceAll('https://www.facebook.com/', ' ')}')
                                : Text(
                                    'Enter Facebook User Name',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_FB';
                                      userQueryActionFieldName = 'Facebook User Name';
                                      dataObjController.text = User_FB;
                                      // -----------
                                      userQueryActionFieldURL = 'https://www.facebook.com/';
                                      if (User_FB != '') {
                                        User_FB = User_FB.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_FB;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_Instagram')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_Instagram != '')
                                ? Text('${User_Instagram.replaceAll('https://www.instagram.com/', ' ')}')
                                : Text(
                                    'Enter Instagram User Name',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_Instagram';
                                      userQueryActionFieldName = 'Instagram User Name';
                                      dataObjController.text = User_Instagram;
                                      // -----------
                                      userQueryActionFieldURL = 'https://www.instagram.com/';
                                      if (User_Instagram != '') {
                                        User_Instagram = User_Instagram.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_Instagram;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_X')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.xTwitter,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_X != '')
                                ? Text('${User_X.replaceAll('https://www.twitter.com/', ' ')}')
                                : Text(
                                    'Enter X User Name',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_X';
                                      userQueryActionFieldName = 'X User Name';
                                      dataObjController.text = User_X;
                                      // -----------
                                      userQueryActionFieldURL = 'https://www.twitter.com/';
                                      if (User_X != '') {
                                        User_X = User_X.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_X;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_TikTok')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.tiktok,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_TikTok != '')
                                ? Text('${User_TikTok.replaceAll('https://www.tiktok.com/@', ' ')}')
                                : Text(
                                    'Enter TikTok User Name',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_TikTok';
                                      userQueryActionFieldName = 'TikTok User Name';
                                      dataObjController.text = User_TikTok;
                                      // -----------
                                      userQueryActionFieldURL = 'https://www.tiktok.com/@';
                                      if (User_TikTok != '') {
                                        User_TikTok = User_TikTok.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_TikTok;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField == null || userQueryActionField == 'User_YouTube')
                ? Card(
                    color: AppSettings.ColorUnderline2,
                    surfaceTintColor: AppSettings.ColorUnderline2,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                              color: AppSettings.ColorUnderline2,
                              surfaceTintColor: AppSettings.ColorUnderline2,
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.youtube,
                                    size: 20,
                                  ))),
                          Expanded(
                            child: (User_YouTube != '')
                                ? Text('${User_YouTube.replaceAll('https://www.youtube.com/@', ' ')}')
                                : Text(
                                    'Enter Youtube User Name',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'User_YouTube';
                                      userQueryActionFieldName = 'Youtube User Name';
                                      dataObjController.text = User_YouTube;
                                      // -----------
                                      userQueryActionFieldURL = 'https://www.youtube.com/@';
                                      if (User_YouTube != '') {
                                        User_YouTube = User_YouTube.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = User_YouTube;
                                      }
                                      // -----------
                                    });
                                  },
                                  child: Icon(
                                    FontAwesome5.edit,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                : Container(),
            (userQueryActionField != null) ? _editForm(widget.userQuery!) : Container(),
          ],
        ),
      ],
    );
  }

  Widget _editOthers(String Username) {
    // final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('_editOthers'),
        // Text(''),
        (userQueryActionField == null ||
                userQueryActionField == 'User_NoTel' ||
                userQueryActionField == 'User_NoTel2' ||
                userQueryActionField == 'User_NoTelOffice' ||
                userQueryActionField == 'User_WS' ||
                userQueryActionField == 'User_Telegram' ||
                userQueryActionField == 'User_Mail')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(''),
                  Text('CONTACT'),
                ],
              )
            : Container(),
        // ---------
        (userQueryActionField == null || userQueryActionField == 'User_NoTel')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                Typicons.mobile,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_NoTel != '')
                            ? Text('$User_NoTel')
                            : Text(
                                'Enter Phone',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_NoTel';
                                  userQueryActionFieldName = 'Phone';
                                  dataObjController.text = User_NoTel;
                                  // -----------
                                  userQueryActionFieldURL = '';
                                  if (User_NoTel != '') {
                                    User_NoTel = User_NoTel.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_NoTel;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_NoTel2')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                Typicons.mobile,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_NoTel2 != '')
                            ? Text('$User_NoTel2')
                            : Text(
                                'Enter Phone 2',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_NoTel2';
                                  userQueryActionFieldName = 'Phone 2';
                                  dataObjController.text = User_NoTel2;
                                  // -----------
                                  userQueryActionFieldURL = '';
                                  if (User_NoTel2 != '') {
                                    User_NoTel2 = User_NoTel2.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_NoTel2;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_NoTelOffice')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                Typicons.phone_outline,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_NoTelOffice != '')
                            ? Text('$User_NoTelOffice')
                            : Text(
                                'Enter Phone Office',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_NoTelOffice';
                                  userQueryActionFieldName = 'Phone Office';
                                  dataObjController.text = User_NoTelOffice;
                                  // -----------
                                  userQueryActionFieldURL = '';
                                  if (User_NoTelOffice != '') {
                                    User_NoTelOffice = User_NoTelOffice.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_NoTelOffice;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_WS')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.whatsapp,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_WS != '')
                            ? Text('$User_WS')
                            : Text(
                                'Enter WhatsApp',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_WS';
                                  userQueryActionFieldName = 'WhatsApp';
                                  dataObjController.text = User_WS;
                                  // -----------
                                  userQueryActionFieldURL = '+6';
                                  if (User_WS != '') {
                                    User_WS = User_WS.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_WS;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_Telegram')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.telegram,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_Telegram != '')
                            ? Text('$User_Telegram')
                            : Text(
                                'Enter Telegram',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_Telegram';
                                  userQueryActionFieldName = 'Telegram';
                                  dataObjController.text = User_Telegram;
                                  // -----------
                                  userQueryActionFieldURL = '+6';
                                  if (User_Telegram != '') {
                                    User_Telegram = User_Telegram.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_Telegram;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_Mail')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.envelope,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_Mail != '')
                            ? Text('$User_Mail')
                            : Text(
                                'Enter Email',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_Mail';
                                  userQueryActionFieldName = 'Email';
                                  dataObjController.text = User_Mail;
                                  // -----------
                                  userQueryActionFieldURL = '';
                                  if (User_Mail != '') {
                                    User_Mail = User_Mail.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_Mail;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        Text(''),
        (userQueryActionField == null || userQueryActionField == 'User_YouTube' || userQueryActionField == 'User_FB' || User_Telegram == 'User_Instagram' || User_Telegram == 'User_X' || User_Telegram == 'User_TikTok')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(''),
                  Text('SOCIAL'),
                ],
              )
            : Container(),

        (userQueryActionField == null || userQueryActionField == 'User_FB')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_FB != '')
                            ? Text('${User_FB.replaceAll('https://www.facebook.com/', ' ')}')
                            : Text(
                                'Enter Facebook User Name',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_FB';
                                  userQueryActionFieldName = 'Facebook User Name';
                                  dataObjController.text = User_FB;
                                  // -----------
                                  userQueryActionFieldURL = 'https://www.facebook.com/';
                                  if (User_FB != '') {
                                    User_FB = User_FB.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_FB;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_Instagram')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.instagram,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_Instagram != '')
                            ? Text('${User_Instagram.replaceAll('https://www.instagram.com/', ' ')}')
                            : Text(
                                'Enter Instagram User Name',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_Instagram';
                                  userQueryActionFieldName = 'Instagram User Name';
                                  dataObjController.text = User_Instagram;
                                  // -----------
                                  userQueryActionFieldURL = 'https://www.instagram.com/';
                                  if (User_Instagram != '') {
                                    User_Instagram = User_Instagram.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_Instagram;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_X')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.xTwitter,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_X != '')
                            ? Text('${User_X.replaceAll('https://www.twitter.com/', ' ')}')
                            : Text(
                                'Enter X User Name',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_X';
                                  userQueryActionFieldName = 'X User Name';
                                  dataObjController.text = User_X;
                                  // -----------
                                  userQueryActionFieldURL = 'https://www.twitter.com/';
                                  if (User_X != '') {
                                    User_X = User_X.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_X;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_TikTok')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.tiktok,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_TikTok != '')
                            ? Text('${User_TikTok.replaceAll('https://www.tiktok.com/@', ' ')}')
                            : Text(
                                'Enter TikTok User Name',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_TikTok';
                                  userQueryActionFieldName = 'TikTok User Name';
                                  dataObjController.text = User_TikTok;
                                  // -----------
                                  userQueryActionFieldURL = 'https://www.tiktok.com/@';
                                  if (User_TikTok != '') {
                                    User_TikTok = User_TikTok.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_TikTok;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField == null || userQueryActionField == 'User_YouTube')
            ? Card(
                color: AppSettings.ColorUnderline2,
                surfaceTintColor: AppSettings.ColorUnderline2,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          color: AppSettings.ColorUnderline2,
                          surfaceTintColor: AppSettings.ColorUnderline2,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FaIcon(
                                FontAwesomeIcons.youtube,
                                size: 20,
                              ))),
                      Expanded(
                        child: (User_YouTube != '')
                            ? Text('${User_YouTube.replaceAll('https://www.youtube.com/@', ' ')}')
                            : Text(
                                'Enter Youtube User Name',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                      Text(' '),
                      (userQueryActionField != null)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  userQueryActionField = 'User_YouTube';
                                  userQueryActionFieldName = 'Youtube User Name';
                                  dataObjController.text = User_YouTube;
                                  // -----------
                                  userQueryActionFieldURL = 'https://www.youtube.com/@';
                                  if (User_YouTube != '') {
                                    User_YouTube = User_YouTube.replaceAll(userQueryActionFieldURL!, '');
                                    dataObjController.text = User_YouTube;
                                  }
                                  // -----------
                                });
                              },
                              child: Icon(
                                FontAwesome5.edit,
                                size: 20.0,
                                color: AppSettings.ColorMain,
                              ),
                            )
                    ],
                  ),
                ),
              )
            : Container(),
        (userQueryActionField != null) ? _editForm(widget.userQuery!) : Container(),
      ],
    );
  }

  Widget _editForm(String userQuery) {
    // final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    // dataObj = dataObjController.text;
    // userQueryActionFieldURL = '';
    // ----------------
    if (userQueryActionField == 'User_YouTube') {
      // userQueryActionFieldURL = 'https://www.youtube.com/';
      // if (dataObj != '') {
      //   dataObj = dataObj.replaceAll(userQueryActionFieldURL!, '');
      //   dataObjController.text = dataObj;
      // }
    }
    // -------
    // if (userQueryActionField == 'User_FB') {
    //   userQueryActionFieldURL = 'https://www.facebook.com/';
    //   if (dataObj != '') {
    //     dataObj = dataObj.replaceAll(userQueryActionFieldURL!, '');
    //     dataObjController.text = dataObj;
    //   }
    // }
    // -------
    // if (userQueryActionField == 'User_Instagram') {
    //   userQueryActionFieldURL = 'https://www.instagram.com/';
    //   if (dataObj != '') {
    //     dataObj = dataObj.replaceAll(userQueryActionFieldURL!, '');
    //     dataObjController.text = dataObj;
    //   }
    // }
    // -------
    // if (userQueryActionField == 'User_X') {
    //   userQueryActionFieldURL = 'https://www.twitter.com/';
    //   if (dataObj != '') {
    //     dataObj = dataObj.replaceAll(userQueryActionFieldURL!, '');
    //     dataObjController.text = dataObj;
    //   }
    // }
    // -------
    // if (userQueryActionField == 'User_TikTok') {
    //   userQueryActionFieldURL = 'https://www.tiktok.com/';
    //   if (dataObj != '') {
    //     dataObj = dataObj.replaceAll(userQueryActionFieldURL!, '');
    //     dataObjController.text = dataObj;
    //   }
    // }
    // ----------------

    if (userQueryActionField == 'UserTapID_Status_Card') {
      _mySelectionDbStatus = UserTapID_Status_Card;
    } else {
      _mySelectionDbStatus = '';
      dataObjFinal = '$userQueryActionFieldURL${dataObjController.text}';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        (userQueryActionField == 'UserTapID_Status_Card')
            ? Container()
            : Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (userQueryActionFieldURL == '')
                        ? Container()
                        : Row(
                            children: [
                              Text('$userQueryActionFieldURL'),
                              Text('${dataObjController.text}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                    SizedBox(height: 5),
                    TextFormField(
                      // minLines: 1, //Normal textInputField will be displayed
                      // maxLines: 6, // when user presses enter it will adapt to it
                      controller: dataObjController,
                      validator: (value) => value!.isEmpty ? 'Enter $userQueryActionFieldName' : null,
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
                  ],
                ),
              ),
        // (widget.nedField == '' || widget.nedField == 'Laporan_Kategori')
        //               ?
        // List<DbCategoryCls> _list = [];
        // final dataJson = jsonDecode(state.DbCategory);
        // for (int i = 0; i < dataJson.length; i++) _list.add(DbCategoryCls.fromJson(dataJson[i]));
        // _listCategory = _list;
        //-----------------
        (userQueryActionField == 'UserTapID_Status_Card')
            ? Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 16.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                      items: listDb_Status.map((TapBizStatusModel map) {
                        return DropdownMenuItem<String>(
                          value: map.Status,
                          child: Text(
                            map.Status.toUpperCase(),
                            style: TextStyle(fontSize: 12.0),
                          ),
                        );
                      }).toList(),
                      isDense: true,
                      hint: new Text("  Status"),
                      value: _mySelectionDbStatus,
                      validator: (valueDbSelectedByUser) => valueDbSelectedByUser == null ? '  Select Status' : null,
                      onChanged: (valueDbSelectedByUser) {
                        setState(() {
                          _mySelectionDbStatusOld = _mySelectionDbStatus;
                          _mySelectionDbStatus = valueDbSelectedByUser;
                          // dataObj = valueDbSelectedByUser!;
                          // dataObjFinal = valueDbSelectedByUser;
                          updateStatusObj(_mySelectionDbStatus);
                        });
                      }),
                ),
              )
            : Container(),
        // : Container(),
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
                      Text("Save", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  onPressed: () {
                    _updateDb_UserDemo(userQuery, userQueryActionField!, dataObjFinal, null, '', '');
                    userQueryActionField = null;
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
                      userQueryActionField = null;
                    });
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PageDemo()));
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  updateObj() {
    setState(() {
      dataObj = dataObjController.text;
      dataObjFinal = '$userQueryActionFieldURL$dataObj';
    });
  }

  updateStatusObj(_mySelectionDbStatus) {
    setState(() {
      dataObj = _mySelectionDbStatus;
      dataObjFinal = _mySelectionDbStatus;
    });
  }

  Widget _updateProfileNameForm(String uuid, String CardProfileid) {
    userQueryActionFieldName = 'User ID, Userrname, Email';
    userQueryActionField = 'CardProfileRename';

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
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
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

              // decoration: InputDecoration(
              //   contentPadding: EdgeInsets.all(8.0),
              //   labelText: '$userQueryActionFieldName',
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(5.0),
              //   ),
              // ),
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
                        Text("Update Profile Name", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      _updateDb_UserDemo(widget.userQuery, 'CardProfileRename', dataObj, null, uuid, CardProfileid).then((_) {
                        _getDb_UserDemo(widget.userQuery).then((_) {
                          setState(() {
                            userQueryAction = 'View';
                          });
                        });
                      });

                      //   _updateDb_UserDemo(userQuery, userQueryActionField!, dataObjFinal, null);
                      // userQueryActionField = null;

                      // _getDb_Search(dataObj).then((_) {});
                      // if (_formKey.currentState!.validate()) {
                      //   if (actionQuery == 'AddGroup') {
                      //     _addDb_Group();
                      //   }
                      //   if (actionQuery == 'AddCard') {
                      //     _addDb_UserDemo();
                      //   }
                      // }
                    },
                  ),
                ),
              ),
            ],
          ),
          // Text('Under Construction - $dataObj')
        ],
      ),
    );
  }

  Widget _addProfileNameForm(String uuid, String CardProfileid) {
    userQueryActionFieldName = 'User ID, Userrname, Email';
    userQueryActionField = 'CardProfileRename';

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
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
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

              // decoration: InputDecoration(
              //   contentPadding: EdgeInsets.all(8.0),
              //   labelText: '$userQueryActionFieldName',
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(5.0),
              //   ),
              // ),
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
                        Text("Add New Profile", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      // _updateDb_UserDemo(widget.userQuery, 'CardProfileRename', dataObj, null, uuid, CardProfileid).then((_) {
                      //   _getDb_UserDemo(widget.userQuery).then((_) {
                      //     setState(() {
                      //       userQueryAction = 'View';
                      //     });
                      //   });
                      // });
                    },
                  ),
                ),
              ),
            ],
          ),
          Text('Under Construction - $dataObj')
        ],
      ),
    );
  }

  Widget _updateAccountForm(String uuid, String Email) {
    userQueryActionFieldName = 'User ID, Userrname, Email';
    userQueryActionField = 'CardProfileRename';
    dataObjController.text = Email;

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
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
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

              // decoration: InputDecoration(
              //   contentPadding: EdgeInsets.all(8.0),
              //   labelText: '$userQueryActionFieldName',
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(5.0),
              //   ),
              // ),
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
                        Text("Update Email", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      // _updateDb_UserDemo(widget.userQuery, 'CardProfileRename', dataObj, null, uuid, CardProfileid).then((_) {
                      //   _getDb_UserDemo(widget.userQuery).then((_) {
                      //     setState(() {
                      //       userQueryAction = 'View';
                      //     });
                      //   });
                      // });
                    },
                  ),
                ),
              ),
            ],
          ),
          // Text('Under Construction - $dataObj')
        ],
      ),
    );
  }
}
