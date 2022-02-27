import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/settings_page.dart';
import 'package:sizer/sizer.dart';
import 'main.dart';
import 'func.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//List<bool> unfinished = [];
//List<String> titles = [];
//List<String> notes = [];
//List<String> dates = [];
//List<String> times = [];



class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int i = 0, j = 0;

  String time = '';
  String title = '';
  String note = '';
  String date = '';
  String extime = '';

  DateTime dateTime1 = DateTime.now();
  DateTime dateTime2 = DateTime.now();

  SvgPicture pict_reminder = SvgPicture.asset('assets/not_completed.svg', width: 30, height: 30, color: purple);

  @override
  void initState(){
    super.initState();
    getVal();
//    sort();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.todayTit, style: TextStyle(color: purple, fontSize: 18),),
                centerTitle: true,

                leading: IconButton(
                  icon: SvgPicture.asset('assets/settings.svg', width: 30, height: 30, color: purple),
                  onPressed: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => SettingsPage()));
                  },
                ),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset('assets/calendar.svg', height: 30, width: 30,color: purple),
                    onPressed: () {
                      Navigator.pushNamed(context, calendarPage);
                    },
                  )
                ],
                backgroundColor: Colors.white,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    numRemData = null;
                  });

                  Navigator.pushNamed(context, detailsPage);
                },
                backgroundColor: purple,
                icon: Icon(Icons.add),
                label: Text('Add Event'),
              ),
              body: ListView.builder(
                  itemCount: indexesForToday.length,
                  itemBuilder: (context, i){
                    return Column(
                      children: [
                        Container(
                          width: 90.w,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10.w,
                                  child: IconButton(
                                    icon: pict_reminder,
                                    onPressed: () {
                                      setState(() {
                                        buildDialogAboutDelete(indexesForToday[i]);
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      numRemData = indexesForToday[i];
                                      Navigator.pushNamed(context, detailsPage);
                                    },
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForToday[i]].title,
                                                style: TextStyle(color: Colors.black54,fontSize: 14.sp),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if(arr[indexesForToday[i]].note != '')
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].note,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForToday[i]].date,
                                                style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForToday[i]].time,
                                                style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                )
                              ]
                          ),
                        )
                      ],
                    );
                  }
              )
          );
        }
    );
  }




  Future<void> buildDialogAboutDelete(int ind) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Removing reminders'),
          content: Text('Are you sure you want to delete the reminder?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Delete', style: TextStyle(color: Colors.red),),
              onPressed: () {
                deleteData(ind);

                Navigator.pop(context);
                Navigator.popAndPushNamed(context, mainPage);
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel', style: TextStyle(color: Color.fromRGBO(150, 50, 240, 1)),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
