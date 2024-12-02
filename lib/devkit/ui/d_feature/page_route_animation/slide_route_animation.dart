import 'package:TapBiz/devkit/library/route_transition/slide_route.dart';
import 'package:TapBiz/devkit/ui/d_feature/page_route_animation/destination.dart';
import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class SlideRouteAnimationPage extends StatefulWidget {
  @override
  _SlideRouteAnimationPageState createState() =>
      _SlideRouteAnimationPageState();
}

class _SlideRouteAnimationPageState extends State<SlideRouteAnimationPage> {
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
              _globalWidget.createDetailWidget(
                  title: 'Slide Page Route Animation',
                  desc:
                      'This is the example to create custom page transition (slide transition).'),
              // to used this animation, create the class first, you can check at lib/library/route_transition/slide_route.dart
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: _globalWidget.createButton(
                    buttonName: 'Slide from left',
                    onPressed: () {
                      Navigator.push(
                          context, SlideRoute(page: DestinationPage()));
                    }),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: _globalWidget.createButton(
                    buttonName: 'Slide from right',
                    onPressed: () {
                      Navigator.push(
                          context,
                          SlideRoute(
                              page: DestinationPage(), slideFrom: 'right'));
                    }),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: _globalWidget.createButton(
                    buttonName: 'Slide from top',
                    onPressed: () {
                      Navigator.push(
                          context,
                          SlideRoute(
                              page: DestinationPage(), slideFrom: 'top'));
                    }),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                // this is the start of example
                child: _globalWidget.createButton(
                    buttonName: 'Slide from bottom',
                    onPressed: () {
                      Navigator.push(
                          context,
                          SlideRoute(
                              page: DestinationPage(), slideFrom: 'bottom'));
                    }),
              ),
            ],
          ),
        ));
  }
}