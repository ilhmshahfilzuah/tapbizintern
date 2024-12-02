// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io' show Platform, sleep;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:logging/logging.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/utilities.dart';

import '../subconfig/AppSettings.dart';
import 'ndef_record/raw_record_setting.dart';
import 'ndef_record/text_record_setting.dart';
import 'ndef_record/uri_record_setting.dart';

class PageThemes extends StatefulWidget {
  @override
  _PageThemesState createState() => _PageThemesState();
}

class _PageThemesState extends State<PageThemes> with SingleTickerProviderStateMixin {
  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _result, _writeResult, _mifareResult;
  late TabController _tabSubController;
  List<ndef.NDEFRecord>? _records;

  int? _groupValue;

  @override
  void dispose() {
    _tabSubController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb)
      _platformVersion = '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    else
      _platformVersion = 'Web';
    initPlatformState();
    _tabSubController = new TabController(length: 2, vsync: this);
    _records = [];
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
      _availability = availability;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            SizedBox(height: 25),
            // Text('Under Construction'),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: Colors.grey.shade50,
                  thumbColor: AppSettings.ColorUnderline,
                  groupValue: _groupValue,
                  children: {
                    0: Text('Personal Theme'),
                    1: Text('Others Theme'),
                  },
                  onValueChanged: (groupValue) {
                    print(groupValue);
                    setState(() {
                      _groupValue = groupValue;
                    });
                  },
                ),
              ),
            ),
            // --------------
            (_groupValue == 0) ? Container() : Container(),
            (_groupValue == 1) ? Container() : Container(),
            
          ],
        );
  }
}
