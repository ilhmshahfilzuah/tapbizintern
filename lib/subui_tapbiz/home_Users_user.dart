import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show File, Platform, sleep;

import 'package:TapBiz/subui_tapbiz/home.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/model/user_model.dart';
import '../subdata/model/usergroupTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home_Users.dart';
import 'home_subUserCard_Mngt.dart';

class PageUsers_User extends StatefulWidget {
  const PageUsers_User({
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
        builder: (_) => PageUsers_User(
              dataSource: '',
              dataId: '1',
              dataName: 'buck769@gmail.com',
            ));
  }

  @override
  _PageUsers_UserState createState() => _PageUsers_UserState();
}

class _PageUsers_UserState extends State<PageUsers_User> with SingleTickerProviderStateMixin {
  Color ColorAppBar = AppSettings.ColorMain;
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';

  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _tagSIRI;
  String? _result, _writeResult, _mifareResult;
  late TabController _tabSubController;

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

  List<UserModel> listDb_ListDbUser = [];
  int listDb_ListDbUserCount = 0;

  List<UserGroupTapBizModel> listDb_UserGroup = [];
  int listDb_UserGroupCount = 0;

  List<UserTapBizModel> listDb_UserDemo_setState = [];
  List<UserTapBizModel> listDb_UserDemo = [];

  int listDb_UserDemoCount = 0;

  List<UserModel> listDb_DataUserSearch = [];
  int listDb_DataUserSearchCount = 0;

  List<UserGroupTapBizModel> listDb_UserGroupAgent = [];
  int listDb_UserGroupAgentCount = 0;

  List<UserGroupTapBizModel> listDb_UserGroupHRAdmin = [];
  int listDb_UserGroupHRAdminCount = 0;

  // List<UserTapBizModel> listDb_DataSearch = [];
  // int listDb_DataSearchCount = 0;

  var loading = false;
  var loadingDel = false;

  TextEditingController dataObjController = TextEditingController();
  String dataObj = '';

  var _formKey = GlobalKey<FormState>();

  String? navSearchView;
  String? navScanQRView;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? resultData;

  String? resultSearch;

  TextEditingController dataAddObjController = TextEditingController();
  String dataAddObj = '';

  String? User_Name;

  bool _ValLevel = false;
  bool _ValLevel_Agent = false;
  bool _ValLevel_HRAdmin = false;
  String? Access_Level;
  String? Access_Level_Agent;
  String? Access_Level_HRAdmin;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getDb_DbUser().then((_) {
      _getGroupMngt_ByUser();
    });
  }

  Future<Null> _getDb_DbUser() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {};
    postdata = {
      "userId": widget.dataId,
    };
    apiUrl = 'DbUserV2/getDbUser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final userModel = (response.data as Map<String, dynamic>)['user'];
      //--- Set State

      // -----

      if (mounted) {
        setState(() {
          User_Name = userModel['User_Name'] ?? "";
          Access_Level = userModel['Access_Level'] ?? "";
          if (Access_Level == '1') {
            _ValLevel = true;
          } else {
            _ValLevel = false;
          }

          Access_Level_Agent = userModel['Access_Level_Agent'] ?? "";
          if (Access_Level_Agent == '1') {
            _ValLevel_Agent = true;
          } else {
            _ValLevel_Agent = false;
          }
          Access_Level_HRAdmin = userModel['Access_Level_HRAdmin'] ?? "";
          if (Access_Level_HRAdmin == '1') {
            _ValLevel_HRAdmin = true;
          } else {
            _ValLevel_HRAdmin = false;
          }
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

  Future<Null> _getGroupMngt_ByUser() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {};
    postdata = {
      "userId": widget.dataId,
    };
    apiUrl = 'GroupV2/getGroupMngt_ByUser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata1 = (response.data as Map<String, dynamic>)['UserActivationCodeGroupByUser_Agent'];
      final listdata2 = (response.data as Map<String, dynamic>)['UserActivationCodeGroupByUser_HRAdmin'];
      //--- Set State

      // -----
      if (mounted) {
        setState(() {
          List<UserGroupTapBizModel> _listData1 = [];
          for (int i = 0; i < listdata1.length; i++) _listData1.add(UserGroupTapBizModel.fromJson(listdata1[i]));
          listDb_UserGroupAgent = _listData1;
          listDb_UserGroupAgentCount = _listData1.length;

          List<UserGroupTapBizModel> _listData2 = [];
          for (int i = 0; i < listdata2.length; i++) _listData2.add(UserGroupTapBizModel.fromJson(listdata2[i]));
          listDb_UserGroupHRAdmin = _listData2;
          listDb_UserGroupHRAdminCount = _listData2.length;
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

                      // InkWell(
                      //   onTap: () async {
                      //     setState(() {
                      //       resultSearch = null;
                      //       listDb_DataUserSearch = [];
                      //       listDb_DataByUserSearch = [];
                      //       listDb_DataSearch = [];
                      //       navSearchView = '1';
                      //       userQuery = null;
                      //       userFlagdelQuery = null;
                      //     });
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         FontAwesome5.search,
                      //         // size: 40,
                      //         color: Colors.white,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Text(' | '),
                      // InkWell(
                      //   onTap: () async {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         FontAwesome5.home,
                      //         // size: 40,
                      //         color: Colors.white,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              Text(
                                'Back ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ];
            },
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
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
                    : Column(
                        children: [
                          // --------------
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('USERS MNGT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('${widget.dataName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          Spacer(),
                                          InkWell(
                                              onTap: () async {
                                                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => PageUsers(dataSource: '', dataId: '', dataName: '')));
                                              },
                                              child: Text('[ X ]'))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'NAME: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text('$User_Name')
                                              ],
                                            ),
                                          )),
                                          Card(
                                              child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Black List',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          )),
                                          SizedBox(height: 20),
                                          Card(
                                              child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Super Admin',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      child: Transform.scale(
                                                        scale: 0.6,
                                                        child: CupertinoSwitch(
                                                          activeColor: AppSettings.ColorMain,
                                                          value: _ValLevel!,
                                                          onChanged: (bool value) async {
                                                            showCupertinoDialog<void>(
                                                              context: context,
                                                              builder: (BuildContext context) => CupertinoAlertDialog(
                                                                title: Column(
                                                                  children: [
                                                                    value == true ? Text('On Super Admin') : Text('Remove Super Admin'),
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
                                                                      setState(() {
                                                                        _ValLevel = value;
                                                                        if (_ValLevel == true) {
                                                                          Access_Level = '1';
                                                                        } else {
                                                                          Access_Level = '0';
                                                                        }
                                                                        _updateDb_UserDemo(widget.dataId, 'Access_Level', Access_Level!, '', null, '', '', '');
                                                                      });
                                                                      Navigator.pop(context);
                                                                      // -------
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                          Card(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Agent',
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          child: Transform.scale(
                                                            scale: 0.6,
                                                            child: CupertinoSwitch(
                                                              activeColor: AppSettings.ColorMain,
                                                              value: _ValLevel_Agent!,
                                                              onChanged: (bool value) async {
                                                                showCupertinoDialog<void>(
                                                                  context: context,
                                                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                                                    title: Column(
                                                                      children: [
                                                                        value == true ? Text('On Agent') : Text('Remove Agent'),
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
                                                                          setState(() {
                                                                            _ValLevel_Agent = value;
                                                                            if (_ValLevel_Agent == true) {
                                                                              Access_Level_Agent = '1';
                                                                            } else {
                                                                              Access_Level_Agent = '0';
                                                                            }
                                                                            _updateDb_UserDemo(widget.dataId, 'Access_Level_Agent', Access_Level_Agent!, '', null, '', '', '');
                                                                          });
                                                                          Navigator.pop(context);
                                                                          // -------
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    (Access_Level_Agent == '1')
                                                        ? Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              (userQueryAction == 'AddGroup_As_Agent')
                                                                  ? InkWell(
                                                                      onTap: () async {
                                                                        setState(() {
                                                                          userQueryAction = '';
                                                                        });
                                                                      },
                                                                      child: Card(
                                                                        color: Colors.white,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(2.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(
                                                                                Typicons.cancel,
                                                                                size: 20,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : InkWell(
                                                                      onTap: () async {
                                                                        setState(() {
                                                                          userQueryAction = 'AddGroup_As_Agent';
                                                                        });
                                                                      },
                                                                      child: Card(
                                                                        color: Colors.white,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(2.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(
                                                                                Typicons.plus_outline,
                                                                                size: 20,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              (userQueryAction == 'AddGroup_As_Agent')
                                                                  ? Column(
                                                                      children: [
                                                                        Text('Add Group ID as Agent'),
                                                                        Container(
                                                                          width: 120,
                                                                          child: DottedBorder(
                                                                            color: Colors.grey.shade300,
                                                                            dashPattern: [8, 4],
                                                                            strokeWidth: 2,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: __addGroupForm(widget.dataId, 'HRAdmin'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(width: 8)
                                                  ],
                                                ),
                                                // (userQueryAction == 'AddGroup_As_Agent')
                                                //     ? Column(
                                                //         children: [Text('Add Group ID as Agent'), __addGroupForm(widget.dataId, 'Agent')],
                                                //       )
                                                //     : Container(),
                                                const Divider(
                                                  height: 20,
                                                  thickness: 1,
                                                  indent: 0,
                                                  endIndent: 10,
                                                  color: Colors.grey,
                                                ),
                                                Text('Total Groups: ${listDb_UserGroupAgent.length}'),
                                                (listDb_UserGroupAgent.length == 0)
                                                    ? Text('   -', style: TextStyle(color: Colors.black, fontSize: 10))
                                                    : ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemCount: listDb_UserGroupAgent.length,
                                                        itemBuilder: (BuildContext context, int positionSub) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) => PageGroups(
                                                              //               dataSource: 'Agent',
                                                              //               dataId: this.listDb_UserGroupAgent[positionSub].userId,
                                                              //               dataName: this.listDb_UserGroupAgent[positionSub].userUser_Email,
                                                              //             )));
                                                            },
                                                            child: Container(
                                                              // color: ((position + 1).isOdd) ? Colors.grey.shade50 : Colors.transparent,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                                                                child: Row(
                                                                  children: [
                                                                    Text('${positionSub + 1}) ', style: TextStyle(color: Colors.black, fontSize: 10)),
                                                                    Text(' ID: ${this.listDb_UserGroupAgent[positionSub].id} - ${this.listDb_UserGroupAgent[positionSub].GroupName}', style: TextStyle(color: Colors.black, fontSize: 10)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                // Text('Total Cards: '),
                                                // Text('Total Profile: '),
                                              ],
                                            ),
                                          )),
                                          Card(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'HR/Admin',
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          child: Transform.scale(
                                                            scale: 0.6,
                                                            child: CupertinoSwitch(
                                                              activeColor: AppSettings.ColorMain,
                                                              value: _ValLevel_HRAdmin!,
                                                              onChanged: (bool value) async {
                                                                showCupertinoDialog<void>(
                                                                  context: context,
                                                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                                                    title: Column(
                                                                      children: [
                                                                        value == true ? Text('On HR/Admin') : Text('Remove HR/Admin'),
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
                                                                          setState(() {
                                                                            _ValLevel_HRAdmin = value;
                                                                            if (_ValLevel_HRAdmin == true) {
                                                                              Access_Level_HRAdmin = '1';
                                                                            } else {
                                                                              Access_Level_HRAdmin = '0';
                                                                            }
                                                                            _updateDb_UserDemo(widget.dataId, 'Access_Level_HRAdmin', Access_Level_HRAdmin!, '', null, '', '', '');
                                                                          });
                                                                          Navigator.pop(context);
                                                                          // -------
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    (Access_Level_HRAdmin == '1')
                                                        ? Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              (userQueryAction == 'AddGroup_As_HRAdmin')
                                                                  ? InkWell(
                                                                      onTap: () async {
                                                                        setState(() {
                                                                          userQueryAction = '';
                                                                        });
                                                                      },
                                                                      child: Card(
                                                                        color: Colors.white,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(2.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(
                                                                                Typicons.cancel,
                                                                                size: 20,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : InkWell(
                                                                      onTap: () async {
                                                                        setState(() {
                                                                          userQueryAction = 'AddGroup_As_HRAdmin';
                                                                        });
                                                                      },
                                                                      child: Card(
                                                                        color: Colors.white,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(2.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(
                                                                                Typicons.plus_outline,
                                                                                size: 20,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              (userQueryAction == 'AddGroup_As_HRAdmin')
                                                                  ? Column(
                                                                      children: [
                                                                        Text('Add Group ID as HRAdmin'),
                                                                        Container(
                                                                          width: 120,
                                                                          child: DottedBorder(
                                                                            color: Colors.grey.shade300,
                                                                            dashPattern: [8, 4],
                                                                            strokeWidth: 2,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: __addGroupForm(widget.dataId, 'HRAdmin'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(width: 8)
                                                  ],
                                                ),
                                                // (userQueryAction == 'AddGroup_As_HRAdmin')
                                                //     ? Column(
                                                //         children: [
                                                //           Text('Add Group ID as HRAdmin'),
                                                //           Container(
                                                //             width: 120,
                                                //             child: DottedBorder(
                                                //               dashPattern: [8, 4],
                                                //               strokeWidth: 2,
                                                //               child: Padding(
                                                //                 padding: const EdgeInsets.all(8.0),
                                                //                 child: __addGroupForm(widget.dataId, 'HRAdmin'),
                                                //               ),
                                                //             ),
                                                //           ),

                                                //         ],
                                                //       )
                                                //     : Container(),
                                                const Divider(
                                                  height: 20,
                                                  thickness: 1,
                                                  indent: 0,
                                                  endIndent: 10,
                                                  color: Colors.grey,
                                                ),
                                                Text('Total Groups: ${listDb_UserGroupHRAdmin.length}'),
                                                (listDb_UserGroupHRAdmin.length == 0)
                                                    ? Text('   -', style: TextStyle(color: Colors.black, fontSize: 10))
                                                    : ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemCount: listDb_UserGroupHRAdmin.length,
                                                        itemBuilder: (BuildContext context, int positionSub) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) => PageGroups(
                                                              //               dataSource: 'Agent',
                                                              //               dataId: this.listDb_UserGroupAgent[positionSub].userId,
                                                              //               dataName: this.listDb_UserGroupAgent[positionSub].userUser_Email,
                                                              //             )));
                                                            },
                                                            child: Container(
                                                              // color: ((position + 1).isOdd) ? Colors.grey.shade50 : Colors.transparent,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                                                                child: Row(
                                                                  children: [
                                                                    Text('${positionSub + 1}) ', style: TextStyle(color: Colors.black, fontSize: 10)),
                                                                    Text(' ID: ${this.listDb_UserGroupHRAdmin[positionSub].id} - ${this.listDb_UserGroupHRAdmin[positionSub].GroupName}', style: TextStyle(color: Colors.black, fontSize: 10)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                // Text('Total Cards: '),
                                                // Text('Total Profile: '),
                                              ],
                                            ),
                                          )),
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
              ],
            )),
      ),
    );
  }

  updateObj() {
    setState(() {
      dataObj = dataObjController.text;
    });
  }

  Future<Null> _updateDb_UserDemo(String userId, String userQueryActionField, String dataObj, String flgdataObj, File? image, String Data1, String Data2, String Data3) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // late var postdata;
    late String apiUrl;
    FormData postdata = FormData.fromMap({"Data1": Data1, "Data2": Data2, "userId": userId, "nedField": userQueryActionField, "nedField_Data": dataObj, "nedField_Flg_Data": flgdataObj});

    apiUrl = 'DbUserV2/updateDbUser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      // final listdata = (response.data as Map<String, dynamic>)['UserDemo'];
      final userModel = (response.data as Map<String, dynamic>)['user'];
      //--- Set State
      if (mounted) {
        setState(() {
          User_Name = userModel['User_Name'] ?? "";
          Access_Level = userModel['Access_Level'] ?? "";
          if (Access_Level == '1') {
            _ValLevel = true;
          } else {
            _ValLevel = false;
          }

          Access_Level_Agent = userModel['Access_Level_Agent'] ?? "";
          if (Access_Level_Agent == '1') {
            _ValLevel_Agent = true;
          } else {
            _ValLevel_Agent = false;
          }
          Access_Level_HRAdmin = userModel['Access_Level_HRAdmin'] ?? "";
          if (Access_Level_HRAdmin == '1') {
            _ValLevel_HRAdmin = true;
          } else {
            _ValLevel_HRAdmin = false;
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

  Widget __addGroupForm(String userId, String level) {
    userQueryActionFieldName = 'Group ID';
    userQueryActionField = 'CardProfileRename';
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
              // minLines: 1, //Normal textInputField will be displayed
              // maxLines: 6, // when user presses enter it will adapt to it
              controller: dataAddObjController,
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter $userQueryActionFieldName' : null,
              onFieldSubmitted: (value) {},

              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                labelText: '$userQueryActionFieldName',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (value) {
                updateAddObj();
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
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("Add ", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      // _addDb_UserDemo_Profile(widget.userQuery).then((_) {
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

  updateAddObj() {
    setState(() {
      dataAddObj = dataAddObjController.text;
    });
  }
}
