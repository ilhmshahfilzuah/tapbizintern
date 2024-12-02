import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';
import '../subdata/model/user_model.dart';
import '../subdata/network/api_provider.dart';
import '../sublogic/bloc/auth/authentication_bloc.dart';
import 'home.dart';
import 'home_subAccSetAccountCard.dart';
import 'home_subAccSetAgent.dart';
import 'home_subAccSetHRAdmin.dart';
import 'home_subAccSetMainProfile.dart';

class PageAccSet extends StatefulWidget {
  @override
  _PageAccSetState createState() => _PageAccSetState();
}

class _PageAccSetState extends State<PageAccSet> with SingleTickerProviderStateMixin {
  UserModel? userCls;
  String? PinNama;
  String? PinNamaQuery;

  String? AccSetQuery;
  // String? actionQuery;
  // String? actionTextQuery;
  var loading = false;

  String? Access_Level;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _getUserInfo().then((_) {
      // syncPin().then((_) {});
    });
    super.initState();
  }

  Future<bool> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        final userJson = prefs.getString('user') ?? '';
        Map<String, dynamic> map = jsonDecode(userJson);
        userCls = UserModel.fromJson(map);
      });
      _getUserCheck();
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
      // final UIList_By_home_content = (response.data as Map<String, dynamic>)['UIList_By_home_content'];
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 25),
        // -----------
        (AccSetQuery == 'Main Profile')
            ? Column(
                children: [
                  // -----------
                  Column(
                    children: [
                      Text('MAIN PROFILE'),
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
                    ],
                  ),
                  // -----------
                  (userCls != null) ? PageAccSetMainProfile(parentQuery: 'Home', userQuery: 'buck') : Container(),
                ],
              )
            : Container(),
        (AccSetQuery == 'Account & Card')
            ? Column(
                children: [
                  // -----------
                  Column(
                    children: [
                      Text('ACCOUNT & CARD - LINK'),
                      // Text('Under Construction'),
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
                    ],
                  ),
                  // -----------
                  PageAccSetAccountCard(),
                ],
              )
            : Container(),
        (AccSetQuery == 'Agent Setting')
            ? Column(
                children: [
                  // -----------
                  Column(
                    children: [
                      Text('AGENT VERIFICATION'),
                      // Text('Under Construction'),
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
                    ],
                  ),
                  // -----------
                  PageAccSetAgent(),
                ],
              )
            : Container(),

        (AccSetQuery == 'HR/Admin Setting')
            ? Column(
                children: [
                  // -----------
                  Column(
                    children: [
                      Text('HR/ADMIN VERIFICATION'),
                      // Text('Under Construction'),
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
                    ],
                  ),
                  // -----------
                  PageAccSetHRAdmin(),
                ],
              )
            : Container(),

        (AccSetQuery != null)
            ? Container()
            : Column(
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        AccSetQuery = 'Main Profile';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        color: Colors.yellow.shade50,
                        surfaceTintColor: Colors.yellow.shade50,
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
                                      Text("Main Profile", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  SizedBox(height: 2),
                  // InkWell(
                  //   onTap: () async {
                  //     setState(() {
                  //       AccSetQuery = 'Account & Card';
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  //     child: Card(
                  //       color: Colors.purple.shade50,
                  //       surfaceTintColor: Colors.purple.shade50,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text("Account & Card - Link", style: TextStyle(fontWeight: FontWeight.bold)),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              AccSetQuery = 'Agent Setting';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Card(
                              color: Colors.green.shade50,
                              surfaceTintColor: Colors.green.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Agent", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Verification", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Code", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              AccSetQuery = 'HR/Admin Setting';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Card(
                              color: Colors.red.shade50,
                              surfaceTintColor: Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("HR/Admin", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Verification", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Code", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 40,
                    endIndent: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  //  (userCls != null && userCls!.userAccess_Level == '1')
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  //         child: Card(
                  //           color: Colors.blue.shade50,
                  //           surfaceTintColor: Colors.blue.shade50,
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 (userCls != null && userCls!.userAccess_Level != '1')
                  //                     ? Container()
                  //                     : Column(
                  //                         mainAxisAlignment: MainAxisAlignment.start,
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text('Super Admin Tools'),
                  //                           Column(
                  //                             mainAxisAlignment: MainAxisAlignment.start,
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               Text("Change Access: "),
                  //                               SizedBox(height: 8),
                  //                               Column(
                  //                                 mainAxisAlignment: MainAxisAlignment.start,
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                       prefs.setInt('_groupValueSub', 0);
                  //                                       prefs.setString('PinNamaQuery', 'Superadmin');
                  //                                       setState(() {
                  //                                         PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                       });
                  //                                       Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                                     },
                  //                                     child: (PinNamaQuery == 'Superadmin') ? Text('# Super Admin', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# Super Admin"),
                  //                                   ),
                  //                                   // Text(" | "),
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                       prefs.setInt('_groupValueSub', 0);
                  //                                       prefs.setString('PinNamaQuery', 'Agent');
                  //                                       setState(() {
                  //                                         PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                       });
                  //                                       Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                                     },
                  //                                     child: (PinNamaQuery == 'Agent') ? Text('# Agent', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# Agent"),
                  //                                   ),
                  //                                   // Text(" | "),
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                       prefs.setInt('_groupValueSub', 0);
                  //                                       prefs.setString('PinNamaQuery', 'Group HR/Admin');
                  //                                       setState(() {
                  //                                         PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                       });
                  //                                       Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                                     },
                  //                                     child: (PinNamaQuery == 'Group HR/Admin') ? Text('# HR/Admin', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# HR/Admin"),
                  //                                   ),
                  //                                   // Text(" | "),
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                       prefs.setInt('_groupValueSub', 0);
                  //                                       prefs.setString('PinNamaQuery', 'Personal');
                  //                                       setState(() {
                  //                                         PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                       });
                  //                                       Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                                     },
                  //                                     child: (PinNamaQuery == 'Personal' || PinNamaQuery == '') ? Text('# Personal', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# Personal"),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ],
                  //                       ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ):Container(),
                  // SizedBox(height: 10),
                  // (userCls != null && userCls!.userAccess_Level == '2')
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  //         child: Card(
                  //           color: Colors.blue.shade50,
                  //           surfaceTintColor: Colors.blue.shade50,
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text('Agent Tools'),
                  //                     Column(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text("Change Access: "),
                  //                         SizedBox(height: 8),
                  //                         Row(
                  //                           mainAxisAlignment: MainAxisAlignment.start,
                  //                           crossAxisAlignment: CrossAxisAlignment.start,
                  //                           children: [
                  //                             InkWell(
                  //                               onTap: () async {
                  //                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                 prefs.setInt('_groupValueSub', 0);
                  //                                 prefs.setString('PinNamaQuery', 'Agent');
                  //                                 setState(() {
                  //                                   PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                 });
                  //                                 Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                               },
                  //                               child: (PinNamaQuery == 'Agent') ? Text('# Agent', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# Agent"),
                  //                             ),
                  //                             Text(" | "),
                  //                             InkWell(
                  //                               onTap: () async {
                  //                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                 prefs.setInt('_groupValueSub', 0);
                  //                                 prefs.setString('PinNamaQuery', 'Personal');
                  //                                 setState(() {
                  //                                   PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                 });
                  //                                 Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                               },
                  //                               child: (PinNamaQuery == 'Personal' || PinNamaQuery == '') ? Text('# Personal', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# Personal"),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ):Container(),
                  // SizedBox(height: 10),
                  // (userCls != null && userCls!.userAccess_Level == '3')
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  //         child: Card(
                  //           color: Colors.blue.shade50,
                  //           surfaceTintColor: Colors.blue.shade50,
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Column(
                  //                         mainAxisAlignment: MainAxisAlignment.start,
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text('HR/Admin Tools'),
                  //                           Column(
                  //                             mainAxisAlignment: MainAxisAlignment.start,
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               Text("Change Access: "),
                  //                               SizedBox(height: 8),
                  //                               Row(
                  //                                 mainAxisAlignment: MainAxisAlignment.start,
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                       prefs.setInt('_groupValueSub', 0);
                  //                                       prefs.setString('PinNamaQuery', 'Group HR/Admin');
                  //                                       setState(() {
                  //                                         PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                       });
                  //                                       Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                                     },
                  //                                     child: (PinNamaQuery == 'Group HR/Admin') ? Text('# HR/Admin', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# HR/Admin"),
                  //                                   ),
                  //                                   Text(" | "),
                  //                                   InkWell(
                  //                                     onTap: () async {
                  //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //                                       prefs.setInt('_groupValueSub', 0);
                  //                                       prefs.setString('PinNamaQuery', 'Personal');
                  //                                       setState(() {
                  //                                         PinNamaQuery = prefs.getString('PinNamaQuery') ?? '';
                  //                                       });
                  //                                       Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomePage(tabIndex: 0)));
                  //                                     },
                  //                                     child: (PinNamaQuery == 'Personal' || PinNamaQuery == '') ? Text('# Personal', style: TextStyle(fontWeight: FontWeight.bold)) : Text("# Personal"),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ],
                  //                       ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ):Container(),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Sign Out'),
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
                                context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Delete Account'),
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
                                _updateDb_UserProfile('Account_Status', '0');
                                context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
      ],
    );
  }
}
