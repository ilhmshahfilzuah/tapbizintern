import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/DbCategory_Model.dart';
import '../subdata/model/TapBizTheme_model.dart';
import '../subdata/model/userTapBiz_model.dart';
import '../subdata/network/api_provider.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home.dart';

class PageThemes extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => PageThemes());
  }

  @override
  _PageThemesState createState() => _PageThemesState();
}

class _PageThemesState extends State<PageThemes> with SingleTickerProviderStateMixin {
  Color _color = Color(0xFF515151);
  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);
  Color _color3 = Color(0xff777777);

  Color ColorAppBar = AppSettings.ColorMain;
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';

  List<UserTapBizModel> listDb_CardLog_setState = [];

  List<UserTapBizModel> listDb_CardLog = [];
  int listDb_CardLogCount = 0;

  List<UserTapBizModel> listDb_CardMngtLog = [];
  int listDb_CardMngtLogCount = 0;

  List<DbCategoryCls> listDb_CategoryTheme_DropdownMenuItem = [];
  List<DbCategoryCls> listDb_CategoryTheme = [];
  int listDb_CategoryThemeCount = 0;

  List<TapBizThemeModel> listDb_Theme_setState = [];
  List<TapBizThemeModel> listDb_Theme = [];
  int listDb_ThemeCount = 0;

  var loading = false;
  String? TypeTheme;

  String? CategoryThemeFilterQuery;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    
    _getLocalData();
    _listCategoryTheme().then((_) {
      _listDb_Theme();
    });
    super.initState();
  }

  Future<bool> _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TypeTheme = prefs.getString('TypeTheme') ?? '';
    CategoryThemeFilterQuery = prefs.getString('CategoryThemeFilterQuery') ?? '';

    return true;
  }

  Future<Null> _listCategoryTheme() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {};
    apiUrl = 'DbGeneralV2/listCategoryTheme';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final listdata = (response.data as Map<String, dynamic>)['DbCategoryTheme'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<DbCategoryCls> _listData = [];
          for (int i = 0; i < listdata.length; i++) _listData.add(DbCategoryCls.fromJson(listdata[i]));
          listDb_CategoryTheme = _listData;
          listDb_CategoryThemeCount = _listData.length;

          // listDb_CategoryTheme_DropdownMenuItem = (listDb_CategoryTheme.where((dblist) => dblist.CategoryId != '1')).toList();

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

  Future<Null> _listDb_Theme() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    postdata = {};
    apiUrl = 'ThemeV2/listTheme';
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

          listDb_Theme_setState = (this.listDb_Theme.where((dblist) => dblist.ThemeType == CategoryThemeFilterQuery)).toList();

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

  // Future<Null> _listDb_CardLog() async {
  //   if (mounted) {
  //     setState(() {
  //       loading = true;
  //     });
  //   }
  //   late var postdata;
  //   late String apiUrl;

  //   postdata = {};
  //   apiUrl = 'GroupCardV2/CardLog';
  //   final response = await ApiProvider().postConnect(apiUrl, postdata);
  //   if (response.statusCode == 200) {
  //     //--- fetchdata
  //     final listdataAll = (response.data as Map<String, dynamic>)['User__CardLog'];
  //     final listdataAll_Mngt = (response.data as Map<String, dynamic>)['User__CardMngtLog'];
  //     //--- Set State
  //     if (mounted) {
  //       setState(() {
  //         List<UserTapBizModel> _listDataAll = [];
  //         for (int i = 0; i < listdataAll.length; i++) _listDataAll.add(UserTapBizModel.fromJson(listdataAll[i]));
  //         listDb_CardLog = _listDataAll;
  //         listDb_CardLogCount = _listDataAll.length;

  //         List<UserTapBizModel> _listDataAll_Mngt = [];
  //         for (int i = 0; i < listdataAll_Mngt.length; i++) _listDataAll_Mngt.add(UserTapBizModel.fromJson(listdataAll_Mngt[i]));
  //         listDb_CardMngtLog = _listDataAll_Mngt;
  //         listDb_CardMngtLogCount = _listDataAll_Mngt.length;

  //         loading = false;
  //       });
  //     }
  //     // --- Set State

  //     //--------------------------------------------------------------
  //   } else {
  //     // --- DialogBox
  //     // if (_showAlertDialogStatus == 0) {
  //     //   _showAlertDialog('Status:', 'Check Connection');
  //     //   setState(() {
  //     //     _showAlertDialogStatus = 1;
  //     //   });
  //     // }
  //     // --- DialogBox
  //   }
  // }

  void reload() {
    // _listDb_CardLog();
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Themes Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('TypeTheme', 'Custom Themes');
                                    setState(() {
                                      TypeTheme = prefs.getString('TypeTheme') ?? '';
                                      listDb_CardLog_setState = listDb_CardMngtLog;
                                    });
                                  },
                                  child: Card(
                                      color: (TypeTheme == 'Custom Themes') ? AppSettings.ColorMain : Colors.white,
                                      surfaceTintColor: (TypeTheme == 'Custom Themes') ? AppSettings.ColorMain : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Custom Themes'),
                                      ))),
                              InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('TypeTheme', 'Free Themes');
                                    setState(() {
                                      TypeTheme = prefs.getString('TypeTheme') ?? '';
                                      listDb_CardLog_setState = listDb_CardLog;
                                    });
                                  },
                                  child: Card(
                                      color: (TypeTheme == 'Free Themes') ? AppSettings.ColorMain : Colors.white,
                                      surfaceTintColor: (TypeTheme == 'Free Themes') ? AppSettings.ColorMain : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Free Themes'),
                                      ))),
                            ],
                          ),
                          (TypeTheme == null) ? Container() : Text('Theme: $TypeTheme'),
                          SizedBox(
                            height: 20,
                          ),

                          // (listDb_CardLog_setState.length == 0) ? Container() : Text('Last ${listDb_CardLog_setState.length} $TypeTheme', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // Spacer(),
                    // Padding(
                    //   padding: const EdgeInsets.only(right:16.0),
                    //   child: InkWell(
                    //     onTap: () {
                    //       reload();
                    //     },
                    //     child: Card(
                    //       color: Colors.white,
                    //       surfaceTintColor: Colors.white,
                    //       elevation: 10,
                    //       child: SizedBox(
                    //         height: 60,
                    //         // width: 100,
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Icon(
                    //                 Typicons.loop_alt_outline,
                    //                 size: 20.0,
                    //                 color: AppSettings.ColorMain,
                    //               ),
                    //               Text('   Reload'),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
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
                    : Column(
                        children: [
                          (TypeTheme == 'Free Themes')
                              ? Column(
                                  children: [
                                    _ThemeCategory(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                                      child: _listDisplay_Theme(),
                                    )
                                  ],
                                )
                              : Container(),
                          // Container(
                          //     padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          //     child: ListView.builder(
                          //       padding: EdgeInsets.zero,
                          //       shrinkWrap: true,
                          //       primary: false,
                          //       itemCount: listDb_CardLog_setState.length,
                          //       itemBuilder: (BuildContext context, int position) {
                          //         return InkWell(
                          //           onTap: () async {
                          //             // Navigator.push(
                          //             //     context,
                          //             //     MaterialPageRoute(
                          //             //         builder: (context) => PageGroups(
                          //             //               dataSource: 'Group HR/Admin',
                          //             //               dataId: this.listDb_CardLog_setState[position].id,
                          //             //               dataName: this.listDb_UserGroup[position].GroupName,
                          //             //             )));
                          //           },
                          //           child: Container(
                          //             // color: ((position + 1).isOdd) ? Colors.grey.shade50 : Colors.transparent,
                          //             child: Padding(
                          //               padding: const EdgeInsets.only(top: 0, bottom: 0),
                          //               child: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.start,
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   Row(
                          //                     children: [
                          //                       Text('${position + 1}) '),
                          //                       Text(
                          //                         '${this.listDb_CardLog_setState[position].logTimestamp}',
                          //                         style: TextStyle(fontSize: 12),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                   Row(
                          //                     children: [
                          //                       Text(
                          //                         '${this.listDb_CardLog_setState[position].Username.toLowerCase()}',
                          //                         style: TextStyle(fontSize: 12),
                          //                       ),
                          //                     ],
                          //                   ),

                          //                   Text(
                          //                     '',
                          //                     style: TextStyle(fontSize: 12),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ),
                        ],
                      ),
              ],
            )),
      ),
    );
  }

  Widget _ThemeCategory() {
    return Container(
      // height: (_menuDataSuperAdmin.length > 1) ? 180 : 180,
      child: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 16),
        childAspectRatio: 1.6,
        shrinkWrap: true,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        crossAxisCount: 4,
        // scrollDirection: Axis.horizontal,
        children: List.generate(listDb_CategoryTheme.length, (index) {
          int TotalTheme = 0;
          TotalTheme = (this.listDb_Theme.where((dblist) => dblist.ThemeType == this.listDb_CategoryTheme[index].Category)).length;

          return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString('CategoryThemeFilterQuery', this.listDb_CategoryTheme[index].Category);
                  CategoryThemeFilterQuery = prefs.getString('CategoryThemeFilterQuery') ?? '';
                  if (CategoryThemeFilterQuery == '') {
                    listDb_Theme_setState = listDb_Theme;
                  } else {
                    listDb_Theme_setState = (this.listDb_Theme.where((dblist) => dblist.ThemeType == CategoryThemeFilterQuery)).toList();
                  }
                });
              },
              child: Column(children: [
                Flexible(
                  child: Card(
                    elevation: 10,
                    color: (CategoryThemeFilterQuery == this.listDb_CategoryTheme[index].Category) ? AppSettings.ColorMain : Colors.white,
                    surfaceTintColor: (CategoryThemeFilterQuery == this.listDb_CategoryTheme[index].Category) ? AppSettings.ColorMain : Colors.white,
                    // margin: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$TotalTheme',
                                style: TextStyle(
                                  // color: _color2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${this.listDb_CategoryTheme[index].Category}',
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
                      ],
                    ),
                  ),
                )
              ]));
        }),
      ),
    );
  }

  Widget _listDisplay_Theme() {
    final double boxImageSize = ((MediaQuery.of(context).size.width) - 24) / 2 - 16;
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
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      color: AppSettings.ColorUnderline2,
                      surfaceTintColor: AppSettings.ColorUnderline2,
                      child: Column(
                        children: <Widget>[
                          (this.listDb_Theme_setState[index].themeURL == '')
                              ? ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  child: buildCacheNetworkImage(width: boxImageSize, url: 'https://storage.googleapis.com/tapbiz/theme_card/webcard/covertapbiz3.jpg'))
                              : ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: buildCacheNetworkImage(width: boxImageSize, url: this.listDb_Theme_setState[index].themeURL)),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                
                                Text(
                                  '  ${listDb_Theme_setState[index].ThemeName}',
                                  style: TextStyle(fontSize: 10, color: _color1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                Icon(Typicons.trash, size: 16, color: _color1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: listDb_Theme_setState.length,
              ),
            ),
          ),
        ])
      ],
    );
  }
}
