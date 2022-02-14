import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Utils extends StatefulWidget {
  Utils({Key? key, required this.title}) : super(key: key);

  final String title;

  static void showSheet(
      BuildContext context, {
        required Widget child,
        required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              child,
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Done'),
              onPressed: onClicked,
            ),
          ),
      );
  @override
  _UtilsPageState createState() => _UtilsPageState();
}

class _UtilsPageState extends State<Utils> {

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold();
        }
    );
  }
}