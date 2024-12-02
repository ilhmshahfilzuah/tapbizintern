import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home.dart';

class PageCardLog extends StatefulWidget {
  @override
  _PageCardLogState createState() => _PageCardLogState();
}

class _PageCardLogState extends State<PageCardLog> with SingleTickerProviderStateMixin {
  Color ColorAppBar = AppSettings.ColorMain;
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';

  List<UserTapBizModel> listDb_CardLog = [];
  int listDb_CardLogCount = 0;

  var loading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _listDb_CardLog();
    super.initState();
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
      //--- Set State
      if (mounted) {
        setState(() {
          List<UserTapBizModel> _listDataAll = [];
          for (int i = 0; i < listdataAll.length; i++) _listDataAll.add(UserTapBizModel.fromJson(listdataAll[i]));
          listDb_CardLog = _listDataAll;
          listDb_CardLogCount = _listDataAll.length;

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
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Last 50 Log', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
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
                : Container(padding: EdgeInsets.fromLTRB(16, 0, 16, 0), child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: listDb_CardLog.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => PageGroups(
                              //               dataSource: 'Group HR/Admin',
                              //               dataId: this.listDb_CardLog[position].id,
                              //               dataName: this.listDb_UserGroup[position].GroupName,
                              //             )));
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('${position + 1}) '),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${this.listDb_CardLog[position].Username}'),
                                        Text('${this.listDb_CardLog[position].logTimestamp}'),
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
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
