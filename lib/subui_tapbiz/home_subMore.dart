import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';

import '../onboarding1.dart';
import '../subconfig/AppSettings.dart';

class PageMore extends StatefulWidget {
  @override
  _PageMoreState createState() => _PageMoreState();
}

class _PageMoreState extends State<PageMore> with SingleTickerProviderStateMixin {
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
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: GridView.count(
          padding: EdgeInsets.all(8),
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
          children: List.generate(1, (index) {
            return Card(
              color: AppSettings.ColorUnderline2,
              surfaceTintColor: AppSettings.ColorUnderline2,
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------- //
                  (index == 0)
                      ? InkWell(
                          onTap: () async {
                            setState(() {
                              Navigator.push(context, new MaterialPageRoute(builder: (context) => Onboarding1Page(parentQuery: 'PageMore')));
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      // height: 80,
                                      // color: Colors.lightBlue.shade50,
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue.shade50,
                                          border: Border.all(
                                            color: Colors.lightBlue.shade50,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Icon(color: Colors.lightBlue.shade900, size: 40, Typicons.info_outline),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text('Intro', style: TextStyle(color: Colors.lightBlue.shade900, fontSize: 12, fontWeight: FontWeight.bold)),
                                    Text('TapBiz Product & Service Introduction',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.lightBlue.shade900,
                                          fontSize: 11,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  // ------------- //
                  (index == 1)
                      ? InkWell(
                          onTap: () async {
                            setState(() {
                              // Navigator.push(context, new MaterialPageRoute(builder: (context) => Onboarding1Page(parentQuery: 'PageMore')));
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      // height: 80,
                                      // color: Colors.lightBlue.shade50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          border: Border.all(
                                            color: Colors.grey.shade50,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Icon(color: Colors.grey.shade400, size: 40, Typicons.bookmark),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text('FAQ', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                                    Text('TapBiz Frequently Asked Question',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 11,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  (index == 0 || index == 1)
                      ? Container()
                      : Container(
                          child: Center(
                            child: Text((index + 1).toString()),
                          ),
                        ),
                  // ------------- //
                ],
              ),
            );
          })),
    );
  }
}
