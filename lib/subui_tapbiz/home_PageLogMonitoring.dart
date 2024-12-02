import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home.dart';

class PageLogMonitoring extends StatefulWidget {
  @override
  _PageLogMonitoringState createState() => _PageLogMonitoringState();
}

class _PageLogMonitoringState extends State<PageLogMonitoring> with SingleTickerProviderStateMixin {
  Color ColorAppBar = AppSettings.ColorMain;
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';

  List<UserTapBizModel> listDb_CardLog_setState = [];

  List<UserTapBizModel> listDb_CardLog = [];
  int listDb_CardLogCount = 0;

  List<UserTapBizModel> listDb_CardMngtLog = [];
  int listDb_CardMngtLogCount = 0;

  var loading = false;
  String? TypeLog;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _listDb_CardLog().then((_) {
      _getLocalData();
    });
    super.initState();
  }

  Future<bool> _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TypeLog = prefs.getString('TypeLog') ?? '';

    if (TypeLog == 'Card Mngt Log') {
      listDb_CardLog_setState = listDb_CardMngtLog;
    }
    if (TypeLog == 'Card Taps Log') {
      listDb_CardLog_setState = listDb_CardLog;
    }

    return true;
  }

  Future<Null> _listDb_CardLog() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {};
    apiUrl = 'GroupCardV2/CardLog';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdataAll = (response.data as Map<String, dynamic>)['User__CardLog'];
      final listdataAll_Mngt = (response.data as Map<String, dynamic>)['User__CardMngtLog'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserTapBizModel> _listDataAll = [];
          for (int i = 0; i < listdataAll.length; i++) _listDataAll.add(UserTapBizModel.fromJson(listdataAll[i]));
          listDb_CardLog = _listDataAll;
          listDb_CardLogCount = _listDataAll.length;

          List<UserTapBizModel> _listDataAll_Mngt = [];
          for (int i = 0; i < listdataAll_Mngt.length; i++) _listDataAll_Mngt.add(UserTapBizModel.fromJson(listdataAll_Mngt[i]));
          listDb_CardMngtLog = _listDataAll_Mngt;
          listDb_CardMngtLogCount = _listDataAll_Mngt.length;

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

  void reload() {
    _listDb_CardLog();
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
                    ],
                  ),
                ),
              ];
            },
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'LOG MONITORING MNGT',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 120,
                  endIndent: 120,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('TypeLog', 'Card Mngt Log');
                                    setState(() {
                                      TypeLog = prefs.getString('TypeLog') ?? '';
                                      listDb_CardLog_setState = listDb_CardMngtLog;
                                    });
                                  },
                                  child: Card(
                                      color: (TypeLog == 'Card Mngt Log') ? AppSettings.ColorMain : Colors.white,
                                      surfaceTintColor: (TypeLog == 'Card Mngt Log') ? AppSettings.ColorMain : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Card Mngt Log'),
                                      ))),
                              InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('TypeLog', 'Card Taps Log');
                                    setState(() {
                                      TypeLog = prefs.getString('TypeLog') ?? '';
                                      listDb_CardLog_setState = listDb_CardLog;
                                    });
                                  },
                                  child: Card(
                                      color: (TypeLog == 'Card Taps Log') ? AppSettings.ColorMain : Colors.white,
                                      surfaceTintColor: (TypeLog == 'Card Taps Log') ? AppSettings.ColorMain : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Card Taps Log'),
                                      ))),
                            ],
                          ),
                          (TypeLog == null) ? Container() : Text('TypeLog: $TypeLog'),
                          (listDb_CardLog_setState.length == 0) ? Container() : Text('Last ${listDb_CardLog_setState.length} $TypeLog', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () {
                          reload();
                        },
                        child: Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          elevation: 10,
                          child: SizedBox(
                            height: 60,
                            // width: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Typicons.loop_alt_outline,
                                    size: 20.0,
                                    color: AppSettings.ColorMain,
                                  ),
                                  Text('   Reload'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Container(padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: Text('Under Construction')),
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
                    : Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: listDb_CardLog_setState.length,
                          itemBuilder: (BuildContext context, int position) {
                            return InkWell(
                              onTap: () async {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => PageGroups(
                                //               dataSource: 'Group HR/Admin',
                                //               dataId: this.listDb_CardLog_setState[position].id,
                                //               dataName: this.listDb_UserGroup[position].GroupName,
                                //             )));
                              },
                              child: Container(
                                // color: ((position + 1).isOdd) ? Colors.grey.shade50 : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('${position + 1}) '),
                                          Text(
                                            '${this.listDb_CardLog_setState[position].logTimestamp}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${this.listDb_CardLog_setState[position].Username.toLowerCase()}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          (TypeLog == 'Card Mngt Log')
                                              ? Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${this.listDb_CardLog_setState[position].Source}',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Text(
                                        '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            )),
      ),
    );
  }
}
