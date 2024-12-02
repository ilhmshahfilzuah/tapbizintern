import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/user_model.dart';
import '../subdata/network/api_provider.dart';
import '../sublogic/bloc/dbkawasan/bloc.dart';

import '../sublogic/cubit/kwsn/kwsn_cubit.dart';
import 'package:fluttericon/typicons_icons.dart';
import '../subconfig/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_subAdminTools.dart';
import 'home_subGroups.dart';
import 'home_subMain.dart';
import 'home_subNFCTools.dart';
import 'home_subThemes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.tabIndex}) : super(key: key);
  final int tabIndex;

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage(tabIndex: 0));
    // return MaterialPageRoute<void>(builder: (_) => HomePage(tabIndex: 15));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int? _groupValue;
  int? _groupValueSub;
  // int? _modeSuperAdmin;
  double _modeSuperAdmin = 0;

  String tabFlag = "";

  TabBar? _tabBar;
  int _tabIndex = 1;

  TabController? _tabController;

  // -----------
  var selected = 0;
  var heart = false;
  PageController controller = PageController();
  // -----------

  UserModel? userCls;
  String? PinNama;
  String? PinNamaQuery;

  String? _appVersion;
  String? _appBuildNumber;

  String? _modPengguna = '';

//-----------------
//-----------------
  List<Tab> _tabBarList = [];
  List<Widget> _tabContentList = <Widget>[];

  //-------------------------------------------------------------------------------------------//TopTabView
  //------------------------------------------------------------------Superadmin
  List<Tab> _tabBarList__Superadmin = [
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.home_outline),
        SizedBox(height: 2),
        Text(
          'Home',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.vcard),
        SizedBox(height: 2),
        Text(
          'Groups',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.picture_outline),
        SizedBox(height: 2),
        Text(
          'Themes',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.rss_outline),
        SizedBox(height: 2),
        Text(
          'NFC Tools',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.cog_outline),
        SizedBox(height: 2),
        Text(
          'Admin Tools',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
  ];
  List<Widget> _tabContentList__Superadmin = <Widget>[HomeSubMainPage(), PageSubGroups(dataSource:'',dataId:'',dataName:'',), PageThemes(), PageNFCTools(), PageAdminTools()];
  //------------------------------------------------------------------Superadmin
  //------------------------------------------------------------------Agent
  List<Tab> _tabBarList__Agent = [
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.home_outline),
        SizedBox(height: 2),
        Text(
          'Home',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.vcard),
        SizedBox(height: 2),
        Text(
          'Groups',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
  ];
  List<Widget> _tabContentList__Agent = <Widget>[HomeSubMainPage(), PageSubGroups(dataSource:'',dataId:'',dataName:'',)];
  //------------------------------------------------------------------Superadmin
  //------------------------------------------------------------------Agent
  List<Tab> _tabBarList__GroupHrAdmin = [
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.home_outline),
        SizedBox(height: 2),
        Text(
          'Home',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
  ];
  List<Widget> _tabContentList__GroupHrAdmin = <Widget>[HomeSubMainPage()];
  //------------------------------------------------------------------GroupHrAdmin
  //------------------------------------------------------------------Personal
  // List<Tab> _tabBarList__Personal = [];
  // List<Widget> _tabContentList__Personal = <Widget>[];
  List<Tab> _tabBarList__Personal = [
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.home_outline),
        SizedBox(height: 2),
        Text(
          'Home',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
    Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Typicons.cog_outline),
        SizedBox(height: 2),
        Text(
          'Setting',
          style: TextStyle(fontSize: 12),
        ),
      ],
    )),
  ];
  List<Widget> _tabContentList__Personal = <Widget>[HomeSubMainPage(), PageAdminTools()];
  //------------------------------------------------------------------Personal
  //-------------------------------------------------------------------------------------------//TopTabView

  @override
  void initState() {
    _getUserInfo().then((_) {
      syncPin().then((_) {});
    });
    syncSuperAdminMenu();
    _tabIndex = widget.tabIndex;
    print('--------$PinNamaQuery');

    _getAppVersion();
    _checkAppVersionUpdate();

    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  //---------------------------------------_getUserInfo
  Future<bool> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _modPengguna = prefs.getString('_modPengguna') ?? '';
        final userJson = prefs.getString('user') ?? '';
        Map<String, dynamic> map = jsonDecode(userJson);
        userCls = UserModel.fromJson(map);
      });
    }
    return true;
  }

  //---------------------------------------_getUserInfo
  // syncPin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _tabBarList = _tabBarList;
  //   _tabContentList = _tabContentList;
  //   //-------------------------------------------------------------------------------------------//TopTabView
  //   _tabController = new TabController(vsync: this, length: _tabBarList.length, initialIndex: _tabIndex);
  //   //-------------------------------------------------------------------------------------------//TopTabView
  // }
  //---------------------------------------_getUserInfo
  syncPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userCls != null) {
      //-------- localStorage
      prefs.setString('PinNama', userCls!.userUser_Kod_KeselamatanSubNama);
      PinNama = prefs.getString('PinNama');
      PinNamaQuery = prefs.getString('PinNamaQuery');

      if (PinNamaQuery == '') {
        prefs.setString('PinNamaQuery', PinNama ?? "");
        PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
      } else {
        PinNamaQuery = PinNamaQuery;
      }
      //-------------------------------------------------------------------------------------------//TopTabView
      switch (PinNamaQuery) {
        case 'Superadmin':
          _tabBarList = _tabBarList__Superadmin;
          _tabContentList = _tabContentList__Superadmin;
          break;
        case 'Agent':
          _tabBarList = _tabBarList__Agent;
          _tabContentList = _tabContentList__Agent;
          break;
        case 'Group HR/Admin':
          _tabBarList = _tabBarList__GroupHrAdmin;
          _tabContentList = _tabContentList__GroupHrAdmin;
          break;
        case 'Personal':
          _tabBarList = _tabBarList__Personal;
          _tabContentList = _tabContentList__Personal;
          break;

        default:
          _tabBarList = _tabBarList__Personal;
          _tabContentList = _tabContentList__Personal;
      }
      _tabController = new TabController(vsync: this, length: _tabBarList.length, initialIndex: _tabIndex);
      //-------------------------------------------------------------------------------------------//TopTabView
    }
  }

  syncSuperAdminMenu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _groupValue = prefs.getInt('_groupValue') ?? 0;
      _groupValueSub = prefs.getInt('_groupValueSub') ?? 0;
      _modeSuperAdmin = prefs.getDouble('_modeSuperAdmin') ?? 0;
    });

    if (_groupValue == 0) {
      prefs.setInt('_groupValue', 0);
    }
    if (_groupValueSub == 0) {
      prefs.setInt('_groupValueSub', 0);
    }
    if (_modeSuperAdmin == 0) {
      prefs.setDouble('_modeSuperAdmin', 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        child: DefaultTabController(
          length: _tabBarList.length,
          child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    //-------------
                    leading: Builder(
                      builder: (context) => IconButton(icon: Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
                    ),
                    actions: [
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 0.0),
                      //   child: GestureDetector(
                      //       onTap: () {
                      //         Navigator.push(context, new MaterialPageRoute(builder: (context) => MyPageTrendCarian()));
                      //       },
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Icon(
                      //             Typicons.chart_outline,
                      //             size: 14,
                      //           ),
                      //           // Icon(Icons.bar_chart_outlined, color: Colors.black),
                      //           Text(
                      //             ' T.Carian',
                      //             style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                      //           ),
                      //           Text('  '),
                      //         ],
                      //       )),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => JoinScreen(
                      //                   userName: (userCls == null) ? "" : userCls!.userUser_Name,
                      //                   participantId: userCls!.userId,
                      //                 )));
                      //   },
                      //   child: Icon(Icons.video_call_rounded),
                      // ),
                    ],
                    //-------------
                    automaticallyImplyLeading: false,
                    iconTheme: IconThemeData(
                      color: Colors.black, //change your color here
                    ),
                    elevation: 0,
                    // backgroundColor: Colors.white,
                    backgroundColor: Color(0xffcbdbe5),

                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Image.asset('${AppSettings.AppLogoAppBarTr}', height: 60),
                        // Text(
                        //   ' ${AppSettings.AppTitle1AppBar}',
                        //   style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        // ),
                        // Text(
                        //   '${AppSettings.AppTitle2AppBar}',
                        //   style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        // ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'Version BETA 2.2',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '15/1/2024',
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    bottom: PreferredSize(
                        child: Column(
                          children: [
                            // Text('PinNamaQuery:$PinNamaQuery'),
                            (PinNamaQuery == '' || PinNamaQuery == 'Personal')
                                ? Container()
                                : (_tabController != null)
                                    ? _tabBar = TabBar(
                                        controller: _tabController,
                                        onTap: (position) {
                                          // BlocProvider.of<KwsnCubit>(context).waitingData();
                                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                                          // prefs.setString('positionTap', position.toString());
                                          // context.read<DbKawasanBloc>().emit(GetDbKawasanWaiting());
                                          setState(() {
                                            _tabIndex = position;
                                          });
                                        },
                                        isScrollable: true,
                                        // labelColor: BLACK21,
                                        labelColor: AppSettings.ColorMain,
                                        labelStyle: TextStyle(fontSize: 14),
                                        indicatorSize: TabBarIndicatorSize.label,
                                        indicatorWeight: 4,
                                        // indicatorColor: BLACK21,
                                        indicatorColor: AppSettings.ColorMain,

                                        unselectedLabelColor: SOFT_GREY,
                                        labelPadding: EdgeInsets.symmetric(horizontal: 25.0),
                                        tabs: _tabBarList,
                                      )
                                    : Container(),
                            // Container(
                            //   color: Colors.grey[200],
                            //   height: 1.0,
                            // )
                          ],
                        ),
                        preferredSize: (_tabBar != null) ? Size.fromHeight(_tabBar!.preferredSize.height + 1) : Size.fromHeight(1)),
                  ),
                ];
              },
              body: 
              PageView(
          controller: controller,
          children: const [
            Center(child: Text('Home')),
            Center(child: Text('Star')),
            Center(child: Text('Style')),
            Center(child: Text('Profile')),
          ],
        ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
                        
              //     // Text('_groupValue: $_groupValue'),
              //     // Text('_groupValueSub: $_groupValueSub'),
              //     // Text('_modeSuperAdmin: $_modeSuperAdmin'),
              //     //-------------------------------------------------------------------------------------------//TopTabView
              //     Expanded(
              //       child: TabBarView(
              //         controller: _tabController,
              //         physics: NeverScrollableScrollPhysics(),
              //         children: _tabContentList.map((Widget content) {
              //           return content;
              //         }).toList(),
              //       ),
              //     ),
              //     //-------------------------------------------------------------------------------------------//TopTabView
              //   ],
              // ),
              ),
        ),
      ),
      drawer: buildDrawer(),
      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          // iconSize: 32,
          barStyle: BubbleBarStyle.horizotnal,
          bubbleFillStyle: BubbleFillStyle.outlined,
          // opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.abc),
            title: const Text('Abc'),
            backgroundColor: Colors.red,

            // selectedColor: Colors.pink,
            selectedIcon: const Icon(Icons.read_more),
            badge: const Badge(),
            showBadge: true,
          ),
          BottomBarItem(
            icon: const Icon(Icons.safety_divider),
            title: const Text('Safety'),
            selectedColor: Colors.orange,
            backgroundColor: Colors.orange,
          ),
          BottomBarItem(
            icon: const Icon(Icons.cabin),
            title: const Text('Cabin'),
            backgroundColor: Colors.purple,
          ),
          BottomBarItem(
            icon: const Icon(Icons.cabin),
            title: const Text('Cabin'),
            backgroundColor: Colors.purple,
          ),
          BottomBarItem(
            icon: const Icon(Icons.cabin),
            title: const Text('Cabin'),
            backgroundColor: Colors.purple,
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        onTap: (index) {
          setState(() {
            selected = index;
            controller.jumpToPage(index);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            heart = !heart;
          });
        },
        backgroundColor: Colors.white,
        child: Icon(
          // CupertinoIcons.heart,
          heart ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // body: SafeArea(
      //   child: PageView(
      //     controller: controller,
      //     children: const [
      //       Center(child: Text('Home')),
      //       Center(child: Text('Star')),
      //       Center(child: Text('Style')),
      //       Center(child: Text('Profile')),
      //     ],
      //   ),
      // ),
      // )
    );
  }

  Widget buildDrawer() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: AppSettings.ColorMain,
          ),
          accountName: Text((userCls != null) ? "${userCls!.userUser_Name}" : ""),
          accountEmail: Text((userCls != null) ? "" : ""),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: (userCls != null)
                ? Column(
                    children: [
                      QrImageView(
                        data: '${userCls!.userUser_Name}, ${userCls!.userUser_Email}',
                        version: QrVersions.auto,
                        size: 60.0,
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ver: $_appVersion ($_appBuildNumber)',
                style: TextStyle(
                  fontSize: 14.0,
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Local Version: ${AppSettings.AppVersion}',
                style: TextStyle(
                  fontSize: 14.0,
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ((userCls != null && userCls!.userAccess_Level != '1'))
            ? Container()
            : ListTile(
                title: Text('Super Admin Tools'),
              ),
        ((userCls != null && userCls!.userAccess_Level != '1'))
            ? Container()
            : ExpansionTile(
                title: Text("Account Type Query"),
                leading: Icon(Typicons.code), //add icon
                childrenPadding: EdgeInsets.only(left: 60, top: 4, bottom: 4), //children padding
                expandedAlignment: Alignment.centerLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: (PinNamaQuery == 'Superadmin') ? Text('# Super Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : Text("# Super Admin"),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt('_groupValueSub', 0);
                      prefs.setString('PinNamaQuery', 'Superadmin');
                      setState(() {
                        PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                      });
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                    },
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: (PinNamaQuery == 'Agent') ? Text('# Agent', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : Text("# Agent"),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt('_groupValueSub', 0);
                      prefs.setString('PinNamaQuery', 'Agent');
                      setState(() {
                        PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                      });
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                    },
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: (PinNamaQuery == 'Group HR/Admin') ? Text('# Group HR/Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : Text("# Group HR/Admin"),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt('_groupValueSub', 0);
                      prefs.setString('PinNamaQuery', 'Group HR/Admin');
                      setState(() {
                        PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                      });
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                    },
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: (PinNamaQuery == 'Personal') ? Text('# Personal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : Text("# Personal"),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt('_groupValueSub', 0);
                      prefs.setString('PinNamaQuery', 'Personal');
                      setState(() {
                        PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                      });
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                    },
                  ),
                ],
              ),
      ],
    ));
  }

  void _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        this._appVersion = packageInfo.version;
        this._appBuildNumber = packageInfo.buildNumber;
      });
    }
  }

  //----Api NonBloc
  void _checkAppVersionUpdate() async {
    // String url;
    // url = 'app-version/check';

    String os = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'unknown');

    // String fcmToken = AppSettings.localStorage.getString("fcm_token") ?? "";

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;

    debugPrint("packageName: " + packageName);
    debugPrint("version: " + version);
    //-------------
    late var postdata;
    late String apiUrl;
    postdata = {
      "device_app_version_number": version,
      "os": os,
      "app_id": packageName,
      // "fcm_code": fcmToken
    };
    apiUrl = 'app-version/check';
    final response = await ApiProvider().postConnect_NonBloc(apiUrl, postdata);
    //-------------

    if (response.statusCode == 200) {
      dynamic data;
      if (response.data['success']) {
        var versionInfo = response.data["data"];

        if (versionInfo["got_update"]) {
          if (!mounted) return;
          showDialog(
            barrierDismissible: false,
            // context: _navigator.context,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                scrollable: true,
                title: Text(
                  "Sila muat turun versi baru",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(versionInfo["app"]["remark"]),
                      Text("Versi: " + versionInfo["app"]["version_number"]),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  // new TextButton(
                  //   child: new Text("Tutup"),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  new TextButton(
                    child: new Text("Muat turun"),
                    onPressed: () {
                      launch(versionInfo["app"]["url"]);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } else {}
  }

  bool isIOSPlatform() {
    return Platform.isIOS || Platform.isMacOS;
  }
}
