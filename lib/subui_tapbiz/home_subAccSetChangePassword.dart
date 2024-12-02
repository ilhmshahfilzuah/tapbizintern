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

class PageAccSetChangePassword extends StatefulWidget {
  const PageAccSetChangePassword({Key? key, required this.parentQuery, required this.userQuery}) : super(key: key);
  final String parentQuery;
  final String userQuery;
  @override
  _PageAccSetChangePasswordState createState() => _PageAccSetChangePasswordState();
}

class _PageAccSetChangePasswordState extends State<PageAccSetChangePassword> with SingleTickerProviderStateMixin {
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
  String? userQueryActionFieldName2;
  String? userQueryActionFieldURL;

  String? userQueryActionSub;

  String? actionQuery;
  String? actionTextQuery;

  var _formKey = GlobalKey<FormState>();

  UserModel? userCls;

  List<UserTapBizModel> listDb_UserDemo = [];
  int listDb_UserDemoCount = 0;
  var loading = false;
  var _writeLoading = false;

  bool _ValCardAuth = false;
  bool _ValCardData = true;

  String uuid = '';
  int? Userid = null;
  int? Groupid = null;

  String NFCTAGid = '-';

  String Flagdel = '';
  String CardAuth = '';
  String CardData = 'main';
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

  String User_Password = '';

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';
  String dataObjFinal = '';

  TextEditingController data2ObjController = TextEditingController();
  String data2Obj = '';
  String data2ObjFinal = '';

  String ViewWebURL = '';
  double webViewHeight = 1;
  WebViewController? controller;

  List<TapBizThemeModel> listDb_Theme = [];
  int listDb_ThemeCount = 0;

  List<TapBizStatusModel> listDb_Status = [];
  int listDb_StatusCount = 0;

  String? AccSetQuery;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //-------
    _getUserInfo();
    //-------
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

  @override
  Widget build(BuildContext context) {
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
        : 
        (userCls!=null)?
        Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Card(
              surfaceTintColor: AppSettings.ColorUnderline2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _editInformation(),
                  ],
                ),
              ),
            ),
          ):Container();
  }

  Future<Null> _updateDb_UserProfile(String userQueryActionField, String dataObj) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"userId": userCls!.userId, "nedField": userQueryActionField, "nedField_Data": dataObj});

    apiUrl = 'userEdit';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      _getUserCheck();

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

  Widget _editInformation() {
    // final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(''),
              ],
            ),
            // ---------
            (userQueryActionField == null || userQueryActionField == 'userPassword')
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
                            child: (userCls!.userPassword != '')
                                ? Row(
                                    children: [
                                      Text('PASSWORD: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Expanded(child: Text('${userCls!.userPassword}')),
                                    ],
                                  )
                                : Text(
                                    'Enter New Password',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Text(' '),
                          (userQueryActionField != null)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      userQueryActionField = 'userPassword';
                                      userQueryActionFieldName = 'NEW PASSWORD';
                                      dataObjController.text = userCls!.userPassword;
                                      // -----------
                                      userQueryActionFieldURL = '';
                                      if (userCls!.userPassword != '') {
                                        // userCls!.userUser_Name = userCls!.userUser_Name.replaceAll(userQueryActionFieldURL!, '');
                                        dataObjController.text = userCls!.userPassword;
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
         
            SizedBox(
              height: 20,
            ),           
            (userQueryActionField != null) ? _editForm(widget.userQuery!) : Container(),
          ],
        ),
      ],
    );
  }

  Widget _editForm(String userQuery) {
    dataObj = dataObjController.text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Padding(
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
                      Text("Update", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  onPressed: () {
                    _updateDb_UserProfile(userQueryActionField!, dataObjFinal);
                    userQueryActionField = null;
                  },
                ),
              ),
            ),
            Text('  '),
            // (userQueryActionField == 'User_Password')
            //     ? Expanded(
            //         child: SizedBox(
            //           height: 25,
            //           child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.resolveWith((states) {
            //                 // return AppSettings.ColorUpperline;
            //                 return Colors.grey;
            //               }),
            //             ),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   Typicons.cancel_outline,
            //                   size: 16,
            //                 ),
            //                 SizedBox(
            //                   width: 4.0,
            //                 ),
            //                 Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
            //               ],
            //             ),
            //             onPressed: () {
            //               setState(() {
            //                 userQueryActionField = null;
            //               });
            //               // Navigator.push(context, MaterialPageRoute(builder: (context) => PageDemo()));
            //             },
            //           ),
            //         ),
            //       )
            //     : Container(),
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

  update2Obj() {
    setState(() {
      data2Obj = data2ObjController.text;
      data2ObjFinal = '$userQueryActionFieldURL$data2Obj';
    });
  }
}
