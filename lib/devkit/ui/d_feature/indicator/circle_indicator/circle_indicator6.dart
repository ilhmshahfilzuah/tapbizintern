/*
https://pub.dev/packages/percent_indicator
*/
import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircleIndicator6Page extends StatefulWidget {
  @override
  _CircleIndicator6PageState createState() => _CircleIndicator6PageState();
}

class _CircleIndicator6PageState extends State<CircleIndicator6Page> {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: _globalWidget.createDetailWidget(
                  title: 'Circle Indicator - Mask Filter',
                  desc:
                      'This is the example of circle indicator with mask filter'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 12.0,
                percent: 0.6,
                circularStrokeCap: CircularStrokeCap.round,
                maskFilter: MaskFilter.blur(BlurStyle.solid, 5),
                center: Text('60%'),
                backgroundColor: Colors.grey,
                progressColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
