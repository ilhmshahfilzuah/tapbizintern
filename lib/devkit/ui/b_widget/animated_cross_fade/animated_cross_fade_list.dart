import 'package:TapBiz/devkit/config/constant.dart';
import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:TapBiz/devkit/ui/b_widget/animated_cross_fade/animated_cross_fade1.dart';
import 'package:TapBiz/devkit/ui/b_widget/animated_cross_fade/animated_cross_fade2.dart';
import 'package:flutter/material.dart';

class AnimatedCrossFadeListPage extends StatefulWidget {
  @override
  _AnimatedCrossFadeListPageState createState() =>
      _AnimatedCrossFadeListPageState();
}

class _AnimatedCrossFadeListPageState extends State<AnimatedCrossFadeListPage> {
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
              child: Text('Animated Cross Fade',
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
                        child: Text(
                            'A widget that cross-fades between two given children and animates itself between their sizes.',
                            style: TextStyle(
                                fontSize: 15,
                                color: BLACK77,
                                letterSpacing: 0.5)),
                      )),
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.animation,
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
                title: 'Animated Cross Fade 1 - Standart',
                page: AnimatedCrossFade1Page()),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Animated Cross Fade 2 - Between Widget',
                page: AnimatedCrossFade2Page()),
          ],
        ));
  }
}
