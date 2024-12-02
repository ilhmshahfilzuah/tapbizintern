import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PageInsights extends StatefulWidget {
  @override
  _PageInsightsState createState() => _PageInsightsState();
}

class _PageInsightsState extends State<PageInsights> with SingleTickerProviderStateMixin {

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
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 25),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Column(
        //       children: [
        //         Text('INSIGHTS'),
        //         Text('Under Construction'),
        //       ],
        //     ),            
        //   ],
        // ),
      ],
    );
  }
}

