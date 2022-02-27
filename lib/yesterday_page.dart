import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/settings_page.dart';
import 'package:sizer/sizer.dart';
import 'func.dart';
import 'main.dart';

class YesterdayPage extends StatefulWidget {
  YesterdayPage({Key? key}) : super(key: key);

  @override
  _YesterdayPageState createState() => _YesterdayPageState();
}

class _YesterdayPageState extends State<YesterdayPage> {


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
                title: Text("Tasks for yesterday", style: TextStyle(color: purple, fontSize: 18),),
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
                  itemCount: indexesForYesterday.length,
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
                                        buildDialogAboutDelete(indexesForYesterday[i]);
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      numRemData = indexesForYesterday[i];
                                      Navigator.pushNamed(context, detailsPage);
                                    },
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForYesterday[i]].title,
                                                style: TextStyle(color: Colors.black54,fontSize: 14.sp),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if(arr[indexesForYesterday[i]].note != '')
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForYesterday[i]].note,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForYesterday[i]].date,
                                                style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForYesterday[i]].time,
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
