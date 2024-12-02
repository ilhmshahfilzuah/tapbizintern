import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PageShare extends StatefulWidget {
  @override
  _PageShareState createState() => _PageShareState();
}

class _PageShareState extends State<PageShare> with SingleTickerProviderStateMixin {

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
        //         Text('SHARE'),
        //         Text('Under Construction'),
        //       ],
        //     ),            
        //   ],
        // ),
      ],
    );
  }
}

