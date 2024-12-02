import 'package:TapBiz/devkit/config/constant.dart';
import 'package:TapBiz/devkit/ui/d_feature/backdrop/backdrop1.dart';
import 'package:TapBiz/devkit/ui/d_feature/backdrop/backdrop2.dart';
import 'package:TapBiz/devkit/ui/d_feature/backdrop/backdrop3.dart';
import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class BackdropListPage extends StatefulWidget {
  @override
  _BackdropListPageState createState() => _BackdropListPageState();
}

class _BackdropListPageState extends State<BackdropListPage> {
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
              child: Text('Badges',
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
                        child: Text('Backdrop.',
                            style: TextStyle(
                                fontSize: 15,
                                color: BLACK77,
                                letterSpacing: 0.5)),
                      )),
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.menu, size: 50, color: SOFT_BLUE)))
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
                title: 'Backdrop 1 - Default Backdrop',
                page: Backdrop1Page()),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Backdrop 2 - Customize Backdrop',
                page: Backdrop2Page()),
            _globalWidget.screenDetailList(
                context: context,
                title: 'Backdrop 3 - Backdrop With Navigation',
                page: Backdrop3Page()),
          ],
        ));
  }
}
