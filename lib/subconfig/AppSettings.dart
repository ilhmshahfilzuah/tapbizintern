import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {

  static SharedPreferences? localStorage;

  static const String AppToken =
      "BJ8Yo0KgqCIUH8KYwsINtpurzxJOP0Xj3Js2QwYYDqNuF9OVqoi0EWT7qcpI5Ec0cOXC0";
  
  static const String AppPoweredBy = "DTA";
  static const String AppPoweredBy2 = "Network";

  static const String AppLogo = 'assets/subimages/MasterLogo1024x1024Tr.png';
  static const String AppLogo500 = 'assets/subimages/MasterLogo500x210Tr.png';
  

  static const Color ColorMain = Color(0xfff78d1e);//-------------------------------900
  static const Color ColorMainGrey = Color.fromARGB(255, 212, 211, 211);//-##-//
  static const Color ColorActive = Color(0xFF000000);//-##-//
  static const Color ColorNonActive = Color(0xff777777);//-##-//

  static const Color ColorGradientTop = Color(0xFFFFD54F);//-------------------------------300
  static const Color ColorBradientBottom = Color(0xFFFFECB3);//-------------------------------100

  static const Color ColorUpperline = Color(0xFFFFD54F);//-------------------------------300
  static const Color ColorCenterline = Color(0xFFFFECB3);//-------------------------------100
  static const Color ColorUnderline = Color.fromARGB(255, 212, 211, 211);//-##-//

  static const Color ColorUpperline2 = Color(0xFFFFECB3);//-------------------------------100
  static const Color ColorUnderline2 = Color(0xFFFFFFFF);//-##-//

  static const Color SOFT_BLUE = Color(0xff01aed6);

  static const String ColorAppBar = '0xFFFFFFFF';
  static const String AppLogoAppBar = 'assets/subimages/logo_horizontal_tapbiz.png';
  static const String AppLogoAppBarTr = 'assets/subimages/LOGOtapbiz putih_#f78d1e-01.png';
  static const String AppTitle1AppBar = '';
  static const String AppTitle2AppBar = '';

  
  static const String AppId = "mlf.techworq.TapBiz";
  static const String AppKey = 'tapbiz';
  static const String AppKey2 = '';

  static const String Auth_Type = 'PASSWORD';
  static const String flagAPI = 'v2-TapBiz';
  static const String urlAPI = 'https://tapapi.tapbiz.my/api/';
  static const String AppVersion = "07022024-1.0";
  static const int AppVersionBuilt = 1;
  static const bool ValPaparanKeseluruhan = true;

  static const String PoweredBy = 'assets/subimages/dta.png';

}

