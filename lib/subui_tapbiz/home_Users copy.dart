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

import '../subconfig/AppSettings.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/model/user_model.dart';
import '../subdata/model/usergroupTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home_subUserCard_Mngt.dart';

class PageUsers extends StatefulWidget {
  const PageUsers({
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
        builder: (_) => PageUsers(
              dataSource: '',
              dataId: '',
              dataName: '',
            ));
    // return MaterialPageRoute<void>(builder: (_) => HomePage(tabIndex: 15));
  }

  @override
  _PageUsersState createState() => _PageUsersState();
}

class _PageUsersState extends State<PageUsers> with SingleTickerProviderStateMixin {
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

  TextEditingController controllerFilter = TextEditingController();
  String _searchResult = '';

  // int? Access_Level_0;
  // int? Access_Level_1;
  // int? Access_Level_2;
  // int? Access_Level_3;

  int? Access_Users;

  int? Total_Group;
  int? Total_Card;
  int? Total_Profile;

  int? Access_Level_SuperAdmin;
  int? Access_Level_Agent;
  int? Access_Level_HRAdmin;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    navSearchView = '';
    resultData = '';
    _getDb_StatDbUser();
  }

  Future<Null> _getDb_StatDbUser() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      // "Username": Username,
    };
    apiUrl = 'DbUserV2/statDbUser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      //--- Set State
      if (mounted) {
        setState(() {
          // Access_Level_0 = response.data['Access_Level_0'] ?? 0;
          // Access_Level_1 = response.data['Access_Level_1'] ?? 1;
          // Access_Level_2 = response.data['Access_Level_2'] ?? 2;
          // Access_Level_3 = response.data['Access_Level_3'] ?? 3;

          Access_Users = response.data['Access_Users'] ?? 0;

          Total_Group = response.data['Total_Group'] ?? 0;
          Total_Card = response.data['Total_Card'] ?? 0;
          Total_Profile = response.data['Total_Profile'] ?? 0;

          Access_Level_SuperAdmin = response.data['Access_Level_SuperAdmin'] ?? 0;
          Access_Level_Agent = response.data['Access_Level_Agent'] ?? 0;
          Access_Level_HRAdmin = response.data['Access_Level_HRAdmin'] ?? 0;

          loading = false;
        });
        // _listThemeBlade_ByPersonal();
        // _listTheme_ByPersonal();
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

  Future<Null> _listDb_ListDbUser(String ListBy) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {
      "ListBy": ListBy,
    };
    apiUrl = 'DbUserV2/listDbUser';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata = (response.data as Map<String, dynamic>)['listUser'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserModel> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(UserModel.fromJson(listdata[i]));
          listDb_ListDbUser = _listData;
          listDb_ListDbUserCount = _listData.length;

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
    apiUrl = 'DbUserV2/searchData';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata

      final listUserdata = (response.data as Map<String, dynamic>)['CarianUser'];
      //--- Set State
      if (mounted) {
        setState(() {
          // ----------
          List<UserModel> _listUserData = [];
          for (int i = 0; i < listUserdata.length; i++) _listUserData.add(UserModel.fromJson(listUserdata[i]));
          listDb_DataUserSearch = _listUserData;
          listDb_DataUserSearchCount = _listUserData.length;

          // ----------
          if (listDb_DataUserSearchCount == 0) {
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
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('USERS MNGT - TapBiz Registered Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: _searchForm(),
                                ),
                                (actionQuery == 'Search Data')
                                    ? Column(
                                        children: [
                                          SizedBox(height: 5.0),
                                          Text(
                                            'SEARCH DATA',
                                            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                actionQuery = null;
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
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Card(
                                                      color: (actionQuery == 'List Users - Super Admin') ? AppSettings.ColorMain : Colors.blue.shade50,
                                                      surfaceTintColor: (actionQuery == 'List Users - Super Admin') ? AppSettings.ColorMain : Colors.blue.shade50,
                                                      elevation: 20,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text('Super Admin'),
                                                          ],
                                                        ),
                                                      )),
                                                  Icon(Icons.person, size: 30, color: Colors.blue),
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Card(
                                                      color: (actionQuery == 'List Users - Agent') ? AppSettings.ColorMain : Colors.red.shade50,
                                                      surfaceTintColor: (actionQuery == 'List Users - Agent') ? AppSettings.ColorMain : Colors.red.shade50,
                                                      elevation: 20,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text('Agent'),
                                                          ],
                                                        ),
                                                      )),
                                                  Icon(Icons.person, size: 30, color: Colors.purple),
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Card(
                                                      color: (actionQuery == 'List Users - HR / Admin') ? AppSettings.ColorMain : Colors.yellow.shade50,
                                                      surfaceTintColor: (actionQuery == 'List Users - HR / Admin') ? AppSettings.ColorMain : Colors.yellow.shade50,
                                                      elevation: 20,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text('HR/Admin'),
                                                          ],
                                                        ),
                                                      )),
                                                  Icon(Icons.person, size: 30, color: Colors.green),
                                                ],
                                              )),
                                            ],
                                          ),
                                          (listDb_DataUserSearch.length > 0) ? _listDbUserSearch() : Container(),
                                        ],
                                      )
                                    : Container(),
                                (actionQuery == 'Search Data')
                                    ? Container()
                                    : Row(
                                        children: [
                                          Expanded(
                                              child: Card(
                                                  color: Colors.white,
                                                  surfaceTintColor: Colors.white,
                                                  elevation: 20,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 16.0, right: 24.0),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                '$Access_Users',
                                                                style: TextStyle(fontSize: 45),
                                                              ),
                                                              Text('Users'),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Total Groups: $Total_Group'),
                                                              Text('Total Cards: $Total_Card'),
                                                              Text('    Free: xxx', style: TextStyle(fontSize: 10)),
                                                              Text('    Pain: xxx', style: TextStyle(fontSize: 10)),
                                                              Text('Total Profiles: $Total_Profile'),
                                                              Text('    Free: xxx', style: TextStyle(fontSize: 10)),
                                                              Text('    Pain: xxx', style: TextStyle(fontSize: 10)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                (actionQuery == 'Search Data')
                                    ? Container()
                                    : Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    listDb_ListDbUser = [];
                                                    listDb_DataUserSearch = [];
                                                    actionQuery = 'List Users - Super Admin';
                                                  });
                                                  _listDb_ListDbUser('SuperAdmin');
                                                },
                                                child: Card(
                                                    color: (actionQuery == 'List Users - Super Admin') ? AppSettings.ColorMain : Colors.blue.shade50,
                                                    surfaceTintColor: (actionQuery == 'List Users - Super Admin') ? AppSettings.ColorMain : Colors.blue.shade50,
                                                    elevation: 20,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '$Access_Level_SuperAdmin',
                                                            style: TextStyle(fontSize: 35),
                                                          ),
                                                          Text('Super Admin'),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              Icon(Icons.person, size: 30, color: Colors.blue),
                                            ],
                                          )),
                                          Expanded(
                                              child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    listDb_ListDbUser = [];
                                                    listDb_DataUserSearch = [];
                                                    actionQuery = 'List Users - Agent';
                                                  });
                                                  _listDb_ListDbUser('Agent');
                                                },
                                                child: Card(
                                                    color: (actionQuery == 'List Users - Agent') ? AppSettings.ColorMain : Colors.red.shade50,
                                                    surfaceTintColor: (actionQuery == 'List Users - Agent') ? AppSettings.ColorMain : Colors.red.shade50,
                                                    elevation: 20,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '$Access_Level_Agent',
                                                            style: TextStyle(fontSize: 35),
                                                          ),
                                                          Text('Agent'),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              Icon(Icons.person, size: 30, color: Colors.purple),
                                            ],
                                          )),
                                          Expanded(
                                              child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    listDb_ListDbUser = [];
                                                    listDb_DataUserSearch = [];
                                                    actionQuery = 'List Users - HR / Admin';
                                                  });
                                                  _listDb_ListDbUser('HRAdmin');
                                                },
                                                child: Card(
                                                    color: (actionQuery == 'List Users - HR / Admin') ? AppSettings.ColorMain : Colors.yellow.shade50,
                                                    surfaceTintColor: (actionQuery == 'List Users - HR / Admin') ? AppSettings.ColorMain : Colors.yellow.shade50,
                                                    elevation: 20,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '$Access_Level_HRAdmin',
                                                            style: TextStyle(fontSize: 35),
                                                          ),
                                                          Text('HR/Admin'),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              Icon(Icons.person, size: 30, color: Colors.green),
                                            ],
                                          )),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                (listDb_ListDbUser.length > 0) ? _listDbUser() : Container(),
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

  Widget _listDbUser() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            '$actionQuery',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              itemCount: listDb_ListDbUser.length,
              itemBuilder: (BuildContext context, int position) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text('${this.listDb_ListDbUser[position].userUser_Email}'),
                        Spacer(),
                        (this.listDb_ListDbUser[position].userAccess_Level == '1') ? Icon(Icons.person, size: 18, color: Colors.blue) : Container(),
                        (this.listDb_ListDbUser[position].userAccess_Level_Agent == '1') ? Icon(Icons.person, size: 18, color: Colors.purple) : Container(),
                        (this.listDb_ListDbUser[position].userAccess_Level_HRAdmin == '1') ? Icon(Icons.person, size: 18, color: Colors.green) : Container(),
                        Text(' [ '),
                        Icon(Typicons.vcard, size: 12, color: Colors.orange),
                        Text(' ${this.listDb_ListDbUser[position].userData} ]'),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
                    // onFieldSubmitted: (value) {
                    //   if (_formKey.currentState!.validate()) {
                    //   }
                    // },

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
              ),
              Text(' '),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        listDb_ListDbUser = [];
                        listDb_DataUserSearch = [];
                        actionQuery = 'Search Data';
                        _getDb_Search(dataObj);
                      });
                    }
                  },
                  child: SizedBox(
                    height: 60,
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Icon(
                        Icons.search,
                        color: AppSettings.ColorMain,
                        size: 30,
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

  Widget _listDbUserSearch() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            '$actionQuery',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              itemCount: listDb_DataUserSearch.length,
              itemBuilder: (BuildContext context, int position) {
                return Row(
                  children: [
                    Text('${this.listDb_DataUserSearch[position].userUser_Email}'),
                    Spacer(),
                    (this.listDb_DataUserSearch[position].userAccess_Level == '1') ? Icon(Icons.person, size: 18, color: Colors.blue) : Container(),
                    (this.listDb_DataUserSearch[position].userAccess_Level_Agent == '1') ? Icon(Icons.person, size: 18, color: Colors.purple) : Container(),
                    (this.listDb_DataUserSearch[position].userAccess_Level_HRAdmin == '1') ? Icon(Icons.person, size: 18, color: Colors.green) : Container(),
                    Text(' [ '),
                    Icon(Typicons.vcard, size: 12, color: Colors.orange),
                    Text(' ${this.listDb_DataUserSearch[position].userData} ]'),
                  ],
                );
              },
            ),
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
}
