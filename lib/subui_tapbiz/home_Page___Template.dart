import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subconfig/AppSettings.dart';
import '../subui/reusable/cache_image_network.dart';
import 'home.dart';

class PageSetSuperAdmin extends StatefulWidget {
  @override
  _PageSetSuperAdminState createState() => _PageSetSuperAdminState();
}

class _PageSetSuperAdminState extends State<PageSetSuperAdmin> with SingleTickerProviderStateMixin {
  Color ColorAppBar = AppSettings.ColorMain;
  String UIimageURL = 'https://storage.googleapis.com/tapbiz/logo/LOGO%20tapbiz%20putih_%23f78d1e-02H100.png';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                
              ],
            )),
      ),
    );
  }
}
