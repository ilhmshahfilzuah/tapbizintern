import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAccSetAccountCard extends StatefulWidget {
  @override
  _PageAccSetAccountCardState createState() => _PageAccSetAccountCardState();
}

class _PageAccSetAccountCardState extends State<PageAccSetAccountCard> with SingleTickerProviderStateMixin {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('PageAccSetAccountCard'),
          ],
        ),
      ],
    );
  }
}
