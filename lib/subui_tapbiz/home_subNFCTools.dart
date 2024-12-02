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

class PageNFCTools extends StatefulWidget {
  @override
  _PageNFCToolsState createState() => _PageNFCToolsState();
}

class _PageNFCToolsState extends State<PageNFCTools> with SingleTickerProviderStateMixin {
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
        //---------------------------- SizedBox(height: 25),
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
                0: Text('Read'),
                1: Text('Write'),
                2: Text('Others'),
                3: Text('Tasks'),
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
        // // --------------
        (_groupValue == 0)
            ? Padding(
              padding: const EdgeInsets.only(left:16.0,right:16.0),
              child: Column(
                  children: [
                    SizedBox(height: 25),
                    _readTab(),
                  ],
                ),
            )
            : Container(),
        (_groupValue == 1)
            ? _writeTab()
            // Column(
            //     children: [
            //       SizedBox(height: 25),
            //       Text('Write'),
            //     ],
            //   )
            : Container(),
        (_groupValue == 2)
            ? Column(
                children: [
                  SizedBox(height: 25),
                  Text('Under Construction'),
                ],
              )
            : Container(),
        (_groupValue == 3)
            ? Column(
                children: [
                  SizedBox(height: 25),
                  Text('Under Construction'),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _readTab() {
    return Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    const SizedBox(height: 20),
                    Text('Running on: $_platformVersion\nNFC: $_availability'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          NFCTag tag = await FlutterNfcKit.poll();
                          setState(() {
                            _tag = tag;
                          });
                          await FlutterNfcKit.setIosAlertMessage("Working on it...");
                          _mifareResult = null;
                          if (tag.standard == "ISO 14443-4 (Type B)") {
                            String result1 = await FlutterNfcKit.transceive("00B0950000");
                            String result2 = await FlutterNfcKit.transceive("00A4040009A00000000386980701");
                            setState(() {
                              _result = '1: $result1\n2: $result2\n';
                            });
                          } else if (tag.type == NFCTagType.iso18092) {
                            String result1 = await FlutterNfcKit.transceive("060080080100");
                            setState(() {
                              _result = '1: $result1\n';
                            });
                          } else if (tag.ndefAvailable ?? false) {
                            var ndefRecords = await FlutterNfcKit.readNDEFRecords();
                            var ndefString = '';
                            for (int i = 0; i < ndefRecords.length; i++) {
                              ndefString += '${i + 1}: ${ndefRecords[i]}\n';
                            }
                            setState(() {
                              _result = ndefString;
                            });
                          } else if (tag.type == NFCTagType.webusb) {
                            var r = await FlutterNfcKit.transceive("00A4040006D27600012401");
                            print(r);
                          }
                        } catch (e) {
                          setState(() {
                            _result = 'error: $e';
                          });
                        }

                        // Pretend that we are working
                        if (!kIsWeb) sleep(new Duration(seconds: 1));
                        await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
                      },
                      child: Text('Start polling'),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _tag != null
                            ? Text(
                                'ID: ${_tag!.id}\nStandard: ${_tag!.standard}\nType: ${_tag!.type}\nATQA: ${_tag!.atqa}\nSAK: ${_tag!.sak}\nHistorical Bytes: ${_tag!.historicalBytes}\nProtocol Info: ${_tag!.protocolInfo}\nApplication Data: ${_tag!.applicationData}\nHigher Layer Response: ${_tag!.hiLayerResponse}\nManufacturer: ${_tag!.manufacturer}\nSystem Code: ${_tag!.systemCode}\nDSF ID: ${_tag!.dsfId}\nNDEF Available: ${_tag!.ndefAvailable}\nNDEF Type: ${_tag!.ndefType}\nNDEF Writable: ${_tag!.ndefWritable}\nNDEF Can Make Read Only: ${_tag!.ndefCanMakeReadOnly}\nNDEF Capacity: ${_tag!.ndefCapacity}\nMifare Info:${_tag!.mifareInfo} Transceive Result:\n$_result\n\nBlock Message:\n$_mifareResult')
                            : const Text('No tag polled yet.')),
                  ]));
  }
  Widget _writeTab() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (_records!.length != 0) {
                  try {
                    NFCTag tag = await FlutterNfcKit.poll();
                    setState(() {
                      _tag = tag;
                    });
                    if (tag.type == NFCTagType.mifare_ultralight || tag.type == NFCTagType.mifare_classic || tag.type == NFCTagType.iso15693) {
                      await FlutterNfcKit.writeNDEFRecords(_records!);
                      setState(() {
                        _writeResult = 'OK';
                      });
                    } else {
                      setState(() {
                        _writeResult = 'error: NDEF not supported: ${tag.type}';
                      });
                    }
                  } catch (e, stacktrace) {
                    setState(() {
                      _writeResult = 'error: $e';
                    });
                    print(stacktrace);
                  } finally {
                    await FlutterNfcKit.finish();
                  }
                } else {
                  setState(() {
                    _writeResult = 'error: No record';
                  });
                }
              },
              child: Text("Start writing"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(title: Text("Record Type"), children: <Widget>[
                        SimpleDialogOption(
                          child: Text("Text Record"),
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return NDEFTextRecordSetting();
                            }));
                            if (result != null) {
                              if (result is ndef.TextRecord) {
                                setState(() {
                                  _records!.add(result);
                                });
                              }
                            }
                          },
                        ),
                        SimpleDialogOption(
                          child: Text("Uri Record"),
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return NDEFUriRecordSetting();
                            }));
                            if (result != null) {
                              if (result is ndef.UriRecord) {
                                setState(() {
                                  _records!.add(result);
                                });
                              }
                            }
                          },
                        ),
                        SimpleDialogOption(
                          child: Text("Raw Record"),
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return NDEFRecordSetting();
                            }));
                            if (result != null) {
                              if (result is ndef.NDEFRecord) {
                                setState(() {
                                  _records!.add(result);
                                });
                              }
                            }
                          },
                        ),
                      ]);
                    });
              },
              child: Text("Add record"),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text('Result: $_writeResult'),
        const SizedBox(height: 10),
        ListView(
            shrinkWrap: true,
            children: List<Widget>.generate(
                _records!.length,
                (index) => GestureDetector(
                      child:
                          Padding(padding: const EdgeInsets.all(10), child: Text('id:${_records![index].idString}\ntnf:${_records![index].tnf}\ntype:${_records![index].type?.toHexString()}\npayload:${_records![index].payload?.toHexString()}\n')),
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return NDEFRecordSetting(record: _records![index]);
                        }));
                        if (result != null) {
                          if (result is ndef.NDEFRecord) {
                            setState(() {
                              _records![index] = result;
                            });
                          } else if (result is String && result == "Delete") {
                            _records!.removeAt(index);
                          }
                        }
                      },
                    ))),
      ]),
    );
  }
}