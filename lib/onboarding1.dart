import 'package:TapBiz/devkit/config/constant.dart';
import 'overboard.dart';
import 'package:TapBiz/devkit/library/flutter_overboard/page_model.dart';
import 'package:TapBiz/subdata/model/TapBizUIContent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'subconfig/AppSettings.dart';
import 'subdata/network/api_provider.dart';

class Onboarding1Page extends StatefulWidget {
  const Onboarding1Page({Key? key, required this.parentQuery}) : super(key: key);
  final String parentQuery;
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => Onboarding1Page(parentQuery:''));
    // return MaterialPageRoute<void>(builder: (_) => HomePage(tabIndex: 15));
  }

  @override
  _Onboarding1PageState createState() => _Onboarding1PageState();
}

class _Onboarding1PageState extends State<Onboarding1Page> {
  // create each page of onBoard here
  // final listpageUI = [
  //   PageModel(
  //       color: Colors.amber,
  //       imageFromUrl: 'https://storage.googleapis.com/tapbiz/home_content/Home_TapBiz_Tutorial_1.png',
  //       title: 'What is TapBiz?',
  //       body:
  //           'TapBiz is a technology company specializing in Near Field Communication (NFC) solutions. We offer innovative products like TapCard (Digital Business Card) and TapID (ID Verification), leveraging NFC technology for seamless, secure, and environmentally conscious interactions.',
  //       doAnimateImage: true),
  //   PageModel(
  //       color: Colors.white,
  //       imageFromUrl: 'https://storage.googleapis.com/tapbiz/home_content/Home_TapBiz_Tutorial_1.png',
  //       title: 'How does TapCard work?',
  //       body: 'TapCard utilizes NFC technology for digital business card sharing. Users input their details into the card digital interface and share information by tapping the card against an NFC-enabled device.',
  //       doAnimateImage: true),
  //   PageModel(
  //       color: Colors.white,
  //       imageFromUrl: 'https://storage.googleapis.com/tapbiz/home_content/Home_TapBiz_Tutorial_1.png',
  //       title: 'What is TapID used for?',
  //       body: 'TapID is designed for secure identity verification. It stores multiple data points within a single card, streamlining ID verification processes for businesses while contributing to environmental sustainability.',
  //       doAnimateImage: true),
  //   PageModel(
  //       color: Colors.white,
  //       imageFromUrl: 'https://storage.googleapis.com/tapbiz/home_content/Home_TapBiz_Tutorial_1.png',
  //       title: 'How secure are TapBiz products?',
  //       body:
  //           'Security is a top priority for TapBiz. Our products feature advanced security measures, including unique authorization codes and nonrewritable data, ensuring the integrity of information and protecting against unauthorized access or modifications.',
  //       doAnimateImage: true),
  //   PageModel(
  //       color: Colors.white,
  //       imageFromUrl: 'https://storage.googleapis.com/tapbiz/home_content/Home_TapBiz_Tutorial_1.png',
  //       title: 'Can TapCard be customized?',
  //       body: 'Yes, TapCard is highly customizable. Users can tailor their digital presence dynamically, reflecting their unique identity and preferences, making digital networking a more personalized.',
  //       doAnimateImage: true),
  //   PageModel(
  //       color: Colors.white,
  //       imageFromUrl: 'https://storage.googleapis.com/tapbiz/home_content/Home_TapBiz_Tutorial_1.png',
  //       title: 'Is TapBiz environmentally friendly?',
  //       body: 'Absolutely. Our commitment to sustainability is evident in our #katanakgreen initiative. By reducing paper waste associated with traditional business cards and plastic card usage, we actively contribute to a greener environment.',
  //       doAnimateImage: true),
  // ];

  var loading = false;

  List<TapBizUIContentModel> listpageUI = [];
  int listpageUICount = 0;

  @override
  void initState() {
    _listDb_UI();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _listDb_UI() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    late var postdata;
    late String apiUrl;

    // postdata = {Userid};
    postdata = {};
    apiUrl = 'UI/listUI_By_home_content';
    final response = await ApiProvider().postConnect(apiUrl, postdata);
    if (response.statusCode == 200) {
      //--- fetchdata
      final UIList_By_home_content = (response.data as Map<String, dynamic>)['UIList_By_home_content'];
      //--- Set State
      if (mounted) {
        setState(() {
          List<TapBizUIContentModel> _UIList_By_home_content = [];
          for (int i = 0; i < UIList_By_home_content.length; i++) _UIList_By_home_content.add(TapBizUIContentModel.fromJson(UIList_By_home_content[i]));
          listpageUI = _UIList_By_home_content;
          listpageUICount = _UIList_By_home_content.length;

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
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //             title: Image.asset('${AppSettings.AppLogoAppBarTr}', height: 60),
        //             centerTitle: true,
        //           ),
        body: 
        (loading)?Container():
        AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: OverBoard(
        parentQuery: widget.parentQuery,
        pages: listpageUI,
        showBullets: true,
        finishCallback: () {
          Fluttertoast.showToast(msg: 'Click finish', toastLength: Toast.LENGTH_SHORT);
        },
      ),
    ));
  }
}
