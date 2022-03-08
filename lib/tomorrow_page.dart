import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/settings_page.dart';
import 'package:sizer/sizer.dart';
import 'func.dart';
import 'main.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

bool createWithTomorrowPage = false;

class TomorrowPage extends StatefulWidget {
  TomorrowPage({Key? key}) : super(key: key);

  @override
  _TomorrowPageState createState() => _TomorrowPageState();
}

class _TomorrowPageState extends State<TomorrowPage> {


  int i = 0, j = 0;

  late String title;
  late String addevent;
  late String ddo;
  late String ddt;
  late String delete;
  late String cancel;

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
    title = AppLocalizations.of(context)!.tomorrowTit;
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
            backgroundColor: dark,
              appBar: AppBar(
                title: Text(title, style: TextStyle(color: white, fontSize: 18),),
                centerTitle: true,

                leading: IconButton(
                  icon: SvgPicture.asset('assets/settings.svg', width: 30, height: 30, color: white),
                  onPressed: () {
                    Navigator.pushNamed(context, settingsPage);
                  },
                ),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset('assets/calendar.svg', height: 30, width: 30,color: white),
                    onPressed: () {
                      Navigator.pushNamed(context, calendarPage);
                    },
                  )
                ],
                backgroundColor: darkpurple,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    numRemData = null;
                    createWithTomorrowPage = true;
                  });

                  Navigator.pushNamed(context, detailsPage);
                },
                backgroundColor: lightdark,
                icon: Icon(Icons.add, color: lightpurple,),
                label: Text(addevent),
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
                                    icon: SvgPicture.asset('assets/not_completed.svg', width: 30, height: 30, color: white),
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
                                                style: TextStyle(color: white,fontSize: 14.sp),
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
                                                  style: TextStyle(color: graywhite, fontSize: 12.sp),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForTomorrow[i]].date,
                                                style: TextStyle(color: graywhite, fontSize: 12.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: 70.w,
                                              child: Text(
                                                arr[indexesForTomorrow[i]].time,
                                                style: TextStyle(color: graywhite, fontSize: 12.sp),
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
