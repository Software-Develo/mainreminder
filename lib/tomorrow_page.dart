import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/calendar_page.dart';
import 'package:reminder/settings_page.dart';
import 'package:sizer/sizer.dart';
import 'package:reminder/details_page.dart';

import 'main.dart';

class TomorrowPage extends StatefulWidget {
  TomorrowPage({Key? key}) : super(key: key);

  @override
  _TomorrowPageState createState() => _TomorrowPageState();
}

class _TomorrowPageState extends State<TomorrowPage> {

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Tasks for tomorrow", style: TextStyle(color: Color.fromRGBO(150, 50, 240, 1), fontSize: 18)),
                centerTitle: true,
                leading: IconButton(
                  icon: SvgPicture.asset('assets/settings.svg', width: 30, height: 30, color: Color.fromRGBO(150, 50, 240, 1)),
                  onPressed: () {
                    Navigator.pushNamed(context, settingsPage);
                  },
                ),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset('assets/calendar.svg', height: 30, width: 30,color: Color.fromRGBO(150, 50, 240, 1)),
                    onPressed: () {
                      Navigator.pushNamed(context, calendarPage);
                    },
                  )
                ],
                backgroundColor: Colors.white,
//                flexibleSpace: Container(
//                  decoration: BoxDecoration(
//                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xff2b4c88), Color(0xff3562b5), Color(0xff3b61a8)], ),
//                  ),
//                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color.fromRGBO(150, 50, 240, 1),
                onPressed: (){
//                  Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailsPage()));
                  Navigator.pushNamed(context, detailsPage);
                },
                child: Icon(Icons.add),
              ),
              body: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  // new
                  children: []
              )

          );
        }
    );
  }
}