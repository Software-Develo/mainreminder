import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/details_page.dart';
import 'package:reminder/settings_page.dart';
import 'package:sizer/sizer.dart';
import 'calendar_page.dart';
import 'main.dart';
import 'func.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:animations/animations.dart';

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

//  String time = '';
  late String title;
  late String addevent;
  late String ddo;
  late String ddt;
  late String delete;
  late String cancel;
//  String note = '';
//  String date = '';
//  String extime = '';

  DateTime dateTime1 = DateTime.now();
  DateTime dateTime2 = DateTime.now();

//  SvgPicture pict_reminder = SvgPicture.asset('assets/not_completed.svg', width: 30, height: 30, color: purple);

  @override
  void initState(){
    super.initState();
    getVal();
//    sort();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    title = AppLocalizations.of(context)!.todayTit;
    addevent = AppLocalizations.of(context)!.addevent;
    ddo = AppLocalizations.of(context)!.ddo;
    ddt = AppLocalizations.of(context)!.ddt;
    delete = AppLocalizations.of(context)!.delete;
    cancel = AppLocalizations.of(context)!.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: whitecolor,
                title: Text(title, style: TextStyle(color: mediumblue, fontSize: 15.sp),),
                centerTitle: true,

                leading: IconButton(
                  icon: SvgPicture.asset('assets/settings.svg', width: 30, height: 30, color: mediumblue),
                  onPressed: () {
                    Navigator.pushNamed(context, settingsPage);
                  },
                ),
                actions: [
/*                  OpenContainer(
                    //transitionDuration: Duration(seconds: 1),
                      openBuilder: (context, _) => CalendarPage(),
                      //numRemData = null;
                      closedBuilder: (context, openButton) => Container(

                        child: SvgPicture.asset('assets/calendar.svg', height: 30, width: 30,color: mediumblue),
                      )
                  ),

 */
                  IconButton(
                    icon: SvgPicture.asset('assets/calendar.svg', height: 30, width: 30,color: mediumblue),
                    onPressed: () {
                      Navigator.pushNamed(context, calendarPage);
                    },
                  )
                ],
              ),
              floatingActionButton: OpenContainer(
                //transitionDuration: Duration(seconds: 1),
                openBuilder: (context, _) => DetailsPage(numRemData: numRemData = null),
                  //numRemData = null;
                  closedShape: CircleBorder(),
                closedElevation: 5,
                closedBuilder: (context, openButton) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffe8ecf0),

                  ),
                  height: 56,
                  width: 56,
                  child: Icon(Icons.add, color: mediumblue),
                )
              ),
/*              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    numRemData = null;
                  });
                  Navigator.pushNamed(context, detailsPage);
                },
                backgroundColor: Color(0xffe8ecf0),
                child: Icon(Icons.add, color: mediumblue),
              ),
 */             body: Container(
                color: whitecolor,
                child: ListView.builder(
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
                                      icon: SvgPicture.asset('assets/not_completed.svg', width: 30, height: 30, color: mediumblue),
                                      onPressed: () {
                                        setState(() {
                                          buildDialogAboutDelete(indexesForToday[i]);
                                        });
                                      },
                                    ),
                                  ),
                                  OpenContainer(
                                      closedElevation: 0,
                                      closedColor: whitecolor,
                                    //transitionDuration: Duration(seconds: 1),
                                      openBuilder: (context, _) => DetailsPage(numRemData: numRemData = indexesForToday[i]),
                                      //numRemData = null;
                                      closedBuilder: (context, openButton) => Container(
                                          color: whitecolor,
                                          padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].title,
                                                  style: TextStyle(color: mediumblue,fontSize: 14.sp),
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
                                                    style: TextStyle(color: lightblue, fontSize: 12.sp),
                                                    maxLines: 2,
                                                  ),
                                                ),
/*                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].date,
                                                  style: TextStyle(color: graywhite, fontSize: 12.sp),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
 */
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].time,
                                                  style: TextStyle(color: lightblue, fontSize: 12.sp),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                  ),
 /*                                 TextButton(
                                      onPressed: () {
                                        numRemData = indexesForToday[i];
                                        Navigator.pushNamed(context, detailsPage);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].title,
                                                  style: TextStyle(color: mediumblue,fontSize: 14.sp),
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
                                                    style: TextStyle(color: lightblue, fontSize: 12.sp),
                                                    maxLines: 2,
                                                  ),
                                                ),
/*                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].date,
                                                  style: TextStyle(color: graywhite, fontSize: 12.sp),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
 */
                                              Container(
                                                width: 70.w,
                                                child: Text(
                                                  arr[indexesForToday[i]].time,
                                                  style: TextStyle(color: lightblue, fontSize: 12.sp),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                  )
*/
                                ]
                            ),
                          )
                        ],
                      );
                    }
                ),
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
        return Theme(
          data: ThemeData.dark(),
          child: CupertinoAlertDialog(
            title: Text(ddo),
            content: Text(ddt),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(delete, style: TextStyle(color: Colors.red),),
                onPressed: () {
                  deleteData(ind);

                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, mainPage);
                },
              ),
              CupertinoDialogAction(
                child: Text(cancel, style: TextStyle(color: lightpurple),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );

      },
    );
  }
}
