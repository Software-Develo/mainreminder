import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/settings_page.dart';
import 'package:sizer/sizer.dart';
import 'func.dart';
import 'main.dart';

bool createWithTomorrowPage = false;

class TomorrowPage extends StatefulWidget {
  TomorrowPage({Key? key}) : super(key: key);

  @override
  _TomorrowPageState createState() => _TomorrowPageState();
}

class _TomorrowPageState extends State<TomorrowPage> {


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
                title: Text("Tasks for tomorrow", style: TextStyle(color: purple, fontSize: 18),),
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
                  itemCount: indexesForTomorrow.length,
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
                                        buildDialogAboutDelete(indexesForTomorrow[i]);
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      numRemData = indexesForTomorrow[i];
                                      createWithTomorrowPage = true;
                                      Navigator.pushNamed(context, detailsPage);
                                    },
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForTomorrow[i]].title,
                                                style: TextStyle(color: Colors.black54,fontSize: 14.sp),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if(arr[indexesForTomorrow[i]].note != '')
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForTomorrow[i]].note,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForTomorrow[i]].date,
                                                style: TextStyle(color: Colors.black26, fontSize: 12.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForTomorrow[i]].time,
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
                Navigator.popAndPushNamed(context, homePage);
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
