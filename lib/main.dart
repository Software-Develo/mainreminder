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

Color purple = Color.fromRGBO(150, 50, 240, 1);
Color gray = CupertinoColors.extraLightBackgroundGray;

final data = GetStorage();

var mainPage = '/main';
var homePage = '/home';
var yesterdayPage = '/yesterday';
var tomorrowPage = '/tomorrow';
var detailsPage = '/-/details';
var calendarPage = '/-/calendar';
var settingsPage = '/-/settings';

int? numRemData;


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
      title: 'Flutter Demo',
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
      home: MyHomePage(title: 'Tasks for today'),
      initialRoute: mainPage,
      routes: {
        mainPage: (context) => MyHomePage(title: 'Tasks for today'),
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

  void initState(){
    super.initState();
    loadData();
    getSettings();
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
                backgroundColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedIconTheme: IconThemeData(
                  //color: Colors.white,
                  //opacity: 1.0
                  color: Color.fromRGBO(150, 50, 240, 1),
                  opacity: 1.0
                ),
                unselectedIconTheme: IconThemeData(
                  //color: Colors.white,
                  //opacity: 0.5,
                   color: Color.fromRGBO(102, 97, 97, 1.0),
                   opacity: 0.5
                ),
                //selectedItemColor: Colors.white,
                //unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.5),
                selectedItemColor: Color.fromRGBO(150, 50, 240, 1),
                unselectedItemColor: Color.fromRGBO(102, 97, 97, 1.0),

                onTap: (index) => setState(() => currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.navigate_before_outlined),
                      label: 'Yesterday',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Today',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.navigate_next_outlined),
                      label: 'Tomorrow',
                  ),
                ],
              ),

          );
        }
    );
  }
}
