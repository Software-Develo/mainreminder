import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/calendar_page.dart';
import 'package:reminder/func.dart';
import 'package:reminder/home_screen.dart';
import 'package:reminder/settings_page.dart';
import 'package:reminder/tomorrow_page.dart';
import 'package:reminder/yesterday_page.dart';
import 'package:sizer/sizer.dart';
import 'package:get_storage/get_storage.dart';
import 'details_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'l10n/l10n.dart';

Color purple = Color.fromRGBO(150, 50, 240, 1);

Color darkpurple = Color.fromRGBO(92, 4, 187, 1);
Color lightpurple = Color.fromRGBO(139, 100, 253, 1);
Color white = Color.fromRGBO(255, 255, 255, 1);
Color graywhite = Color.fromRGBO(255, 255, 255, 0.8);
Color gray = Color.fromRGBO(255, 255, 255, 0.6);
Color dark = Color.fromRGBO(26, 17, 37, 1);
Color lightdark = Color.fromRGBO(38, 29, 50, 1);

final data = GetStorage();

var mainPage = '/main';
var homePage = '/home';
var yesterdayPage = '/yesterday';
var tomorrowPage = '/tomorrow';
var detailsPage = '/-/details';
var calendarPage = '/-/calendar';
var settingsPage = '/-/settings';

int? numRemData;

const int MAX = 5;


void main() async {
  await GetStorage.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      //title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

      //home: MyHomePage(title: AppLocalizations.of(context)!.todayTit),
      initialRoute: mainPage,
      routes: {
        mainPage: (context) => MyHomePage(title: ""),
        homePage: (context) => HomePage(),
        yesterdayPage: (context) => YesterdayPage(),
        tomorrowPage: (context) => TomorrowPage(),
        detailsPage: (context) => DetailsPage(),
        calendarPage: (context) => CalendarPage(),
        settingsPage: (context) => SettingsPage()
      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var currentIndex = 1;
  final screen = [
    YesterdayPage(),
    HomePage(),
    TomorrowPage()
  ];
  @override
  void initState(){
    super.initState();
    getSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadStartData(context);
  }
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
              body: screen[currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                //backgroundColor: Color.fromRGBO(255, 103, 104, 1),
                backgroundColor: Color.fromRGBO(38, 29, 50, 1),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedIconTheme: IconThemeData(
                  //color: Colors.white,
                  //opacity: 1.0
                  color: Color.fromRGBO(139, 100, 253, 1),
                  opacity: 1.0
                ),
                unselectedIconTheme: IconThemeData(
                  //color: Colors.white,
                  //opacity: 0.5,
                   color: Color.fromRGBO(255, 255, 255, 0.8),
                   opacity: 0.5
                ),
                //selectedItemColor: Colors.white,
                //unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.5),
                selectedItemColor: Color.fromRGBO(139, 100, 253, 1),
                unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.8),

                onTap: (index) => setState(() => currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.navigate_before_outlined),
                      label: AppLocalizations.of(context)!.yesterday,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: AppLocalizations.of(context)!.today,
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.navigate_next_outlined),
                      label: AppLocalizations.of(context)!.tomorrow,
                  ),
                ],
              ),

          );
        }
    );
  }
}
