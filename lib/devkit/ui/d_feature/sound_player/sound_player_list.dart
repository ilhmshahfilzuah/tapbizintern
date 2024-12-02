import 'package:TapBiz/devkit/config/constant.dart';
import 'package:TapBiz/devkit/ui/d_feature/sound_player/sound_player1.dart';
import 'package:TapBiz/devkit/ui/d_feature/sound_player/sound_player2.dart';
import 'package:TapBiz/devkit/ui/d_feature/sound_player/sound_player3.dart';
import 'package:TapBiz/devkit/ui/d_feature/sound_player/sound_player4.dart';
import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class SoundPlayerListPage extends StatefulWidget {
  @override
  _SoundPlayerListPageState createState() => _SoundPlayerListPageState();
}

class _SoundPlayerListPageState extends State<SoundPlayerListPage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _globalWidget.globalAppBar(),
        body: ListView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          children: [
            Container(
              child: Text('Sound Player',
                  style: TextStyle(
                      fontSize: 18,
                      color: BLACK21,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Row(
                children: [
                  Flexible(
                      flex: 5,
                      child: Container(
                        child: Text('Sound player used to play a audio.',
                            style: TextStyle(
                                fontSize: 15,
                                color: BLACK77,
                                letterSpacing: 0.5)),
                      )),
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.music_note,
                              size: 50, color: SOFT_BLUE)))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 48),
              child: Text('List',
                  style: TextStyle(
                      fontSize: 18,
                      color: BLACK21,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 18),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Sound Player 1 (Audio mp3 from local source / assets)',
                page: SoundPlayer1Page()),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Sound Player 2 (Audio mp3 from network)',
                page: SoundPlayer2Page()),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Sound Player 3 (Audio using wav format)',
                page: SoundPlayer3Page()),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Sound Player 4 (With player control)',
                page: SoundPlayer4Page()),
          ],
        ));
  }
}
