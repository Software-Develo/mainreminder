import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reminder/calendar_page.dart';
import 'package:reminder/tomorrow_page.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'func.dart';
import 'main.dart';

//int year = 0, month = 0, day = 0;
//int? hour, minute;


//bool active = false;
//bool delete = false;

class DetailsPage extends StatefulWidget {

  DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  String date = 'Date', extime = 'Exact time', textTitle = '';
  String textNotes = '', timeString = '';

  bool haveAptime = false, change = false, click = false, result = false;
  bool active = false, delete = false;

  int year = 0, month = 0, day = 0;
  int? hour, minute;

  DateTime dateTimeNow = DateTime.now(), dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    getRemData(numRemData);
    getVal();
//    getSettings();
  }


  void getRemData(int? i){// Забираем данные
    switchMorning = switchAfternoon = switchEvening = switchNight = switchAllday = false;

    if(i != null) {
      setState(() {
        textTitle = arr[i].title;
        textNotes = arr[i].note;
        date = arr[i].date;
        extime = arr[i].extime;
//        print("time = $extime");
        switchMorning = arr[i].morning;
        switchAfternoon = arr[i].afternoon;
        switchEvening = arr[i].evening;
        switchNight = arr[i].night;
        switchAllday = arr[i].allday;

        year = arr[i].year;
        month = arr[i].month;
        day = arr[i].day;
        hour = arr[i].hour;
        minute = arr[i].minute;
        if (extime != 'Exact time') {
//          print("enter");
          dateTime = new DateTime(year, month, day, hour!, minute!);
//          print(dateTime);
        }
        else
          dateTime = new DateTime(year, month, day, dateTime.hour, dateTime.minute);
        change = true;
        val_rem = i;
      });
    }
    if(createRemWithCalendar){
      dateTime = new DateTime(yearForGet, monthForGet, dayForGet, dateTime.hour, dateTime.minute);
      date = DateFormat('dd/MM/yyyy').format(dateTime);
      createRemWithCalendar = false;
    }
    if(createWithTomorrowPage){
      dateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day + 1, dateTime.hour, dateTime.minute);
      createWithTomorrowPage = false;
    }

  }

  void setDetails(int i) {// Сохраняем данные
    if(extime == 'Exact time') hour = minute = null;
    else{
      hour = dateTime.hour;
      minute = dateTime.minute;
    }

    day = dateTime.day;
    year = dateTime.year;
    month = dateTime.month;

    data.write('delete$i', delete);
    data.write('active$i', active);
    data.write('title$i', textTitle);
    data.write('note$i', textNotes);
    data.write('date$i', date);
    data.write('ex_time$i', extime);
    data.write('morning$i', switchMorning);
    data.write('afternoon$i', switchAfternoon);
    data.write('evening$i', switchEvening);
    data.write('night$i', switchNight);
    data.write('allday$i', switchAllday);
    data.write('year$i', year);
    data.write('month$i', month);
    data.write('day$i', day);
    data.write('hour$i', hour);
    data.write('minute$i', minute);

    timeString = timeToString(extime);
    if(!change) {
      arr.add(DataOfRem(delete, active, textTitle, textNotes, date, timeString, extime,
          switchMorning, switchAfternoon, switchEvening, switchNight, switchAllday, year, month, day, hour, minute));

      val_rem += 1;
      setVal(val_rem);

      if (!arr[i].delete! && arr[i].date == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
        indexesForToday.add(i);
      }
      else if(!arr[i].delete! && arr[i].date == DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))){
        indexesForTomorrow.add(i);
      }
      else if(!arr[i].delete! && arr[i].date == DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1))){
        indexesForYesterday.add(i);
      }
      freeIndexes.remove(i);

    }
    else{
      arr[numRemData!] = DataOfRem(delete, active, textTitle, textNotes, date, timeString, extime,
          switchMorning, switchAfternoon, switchEvening, switchNight, switchAllday, year, month, day, hour, minute);
    }
    sort();
  }

  checkTime(){
    if(date == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
      if (extime != 'Exact time')
        if (dateTime.difference(DateTime.now()).inHours >= 0 && dateTime.difference(DateTime.now()).inMinutes >= 10) return true;
        else return false;
      else {
        if (switchMorning)
          if ((morningEnd - DateTime.now().hour == 1 && 60 - DateTime.now().minute >= 9) || morningEnd - DateTime.now().hour > 1) return true;
        if (switchAfternoon)
          if ((afternoonEnd - DateTime.now().hour == 1 && 60 - DateTime.now().minute >= 9) || afternoonEnd - DateTime.now().hour > 1) return true;
        if (switchEvening)
          if ((eveningEnd - DateTime.now().hour == 1 && 60 - DateTime.now().minute >= 9) || eveningEnd - DateTime.now().hour > 1) return true;
        if (switchNight) {
          if (eveningEnd != 24)
            if ((night == 1 && 60 - DateTime.now().minute >= 9) || night > 1) return true;
        }
        if (switchAllday) return true;
        return false;
      }
    }
    else if(dateTime.difference(DateTime.now()).inDays < 0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Details",
                  style: TextStyle(
                      color: Color.fromRGBO(150, 50, 240, 1),
                      fontSize: 18
                  ),
                ),
                centerTitle: true,

                leading: IconButton(
                  icon: SvgPicture.asset('assets/left.svg', width: 30, height: 30, color: purple),
                  onPressed: () {
//                    numRemData = null;
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  CupertinoButton(
                    child: Text(
                      'Save',
                      style: TextStyle(color: purple),
                    ),
                    onPressed: () {
                        if (switchMorning || switchAfternoon ||
                          switchEvening || switchNight ||
                          switchAllday) haveAptime = true;// Если есть приблизительное время

                        if(textTitle != '' && date != 'Date') {// Если есть название и дата
                          if (!haveAptime && extime == 'Exact time') buildAlertDialogAboutFields();// Если нет приблизительного и точного времени, то строим всплывающее окно
                          else {
                            if(!change) // Если это не изменение уже существующей напоминалки
                              if (val_rem <= MAX) // Если количество напоминаний меньше 5
                                if(checkTime()) {
                                  delete = false;
                                  active = true;
                                  setDetails(freeIndexes[0]);
                                  setVal(val_rem + 1);
//                                  print("Details");
//                                  loadStartData();
                                  numRemData = null;
                                  if(!itIsCalendarPage) Navigator.popAndPushNamed(context, mainPage);
                                  else{
                                    itIsCalendarPage = false;
                                    Navigator.popAndPushNamed(context, calendarPage);
                                  }
                                }
                                else buildAlertDialogAboutTime();
                              else buildAlertDialogReminder();
                            else
                              if(checkTime()){
                                setDetails(numRemData!);
//                                loadStartData();
                                if(!itIsCalendarPage) Navigator.popAndPushNamed(context, mainPage);
                                else Navigator.popAndPushNamed(context, calendarPage);
                              }
                              else buildAlertDialogAboutTime();
                          }
                        }
                        else buildAlertDialogAboutFields();
                    }
                  )
                ],
                backgroundColor: Colors.white,
              ),
              body:
              ListView(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Column(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children:[
                          Container(// Title
                              alignment: Alignment.centerLeft,
                              width: 90.w,
                              height: 60,
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              foregroundDecoration: BoxDecoration(
                                border: Border.all(color: purple, width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                              TextFormField(
                                initialValue: textTitle,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                maxLength: 50,
                                cursorColor: purple,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: purple)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: purple)
                                    ),
                                    fillColor: gray,
                                    filled: true,
                                    counterText: "",
                                    contentPadding: EdgeInsets.all(20),
                                    hintText: "Title"
                                ),
                                onChanged: (text) {textTitle = text;},
                              )
                          ),
                          Container(// Notes
                            alignment: Alignment.topLeft,
                            width: 90.w,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(color: purple, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              initialValue: textNotes,
                              keyboardType: TextInputType.text,
                              cursorColor: purple,
                              maxLines: 4,
                              maxLength: 200,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: purple)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: purple)
                                ),
                                fillColor: gray,
                                filled: true,
                                counterText: "",
                                contentPadding: EdgeInsets.all(20),
                                hintText: "Notes",
                              ),
                              onChanged: (text){ textNotes = text;},
                            ),
                          ),
                          Container(// Date
                            alignment: Alignment.centerLeft,
                            width: 90.w,
                            height: 60,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(color: purple, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: gray,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(fontSize: 13.sp),
                                shadowColor: gray,
                                primary: gray
                              ),
                              child:Row(
                                children: [
                                  SizedBox(width: 3.w,),
                                  SvgPicture.asset('assets/calendar.svg', height: 30, width: 30,color: purple,),
                                  SizedBox(width: 1.w,),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 50.w,
                                    height: 60,
                                    child: Text(
                                      date,
                                      style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoActionSheet(
                                    actions: [
                                      buildDatePicker()
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      child: Text('Done'),
                                      onPressed: () {
                                        setState(() {
                                          date = DateFormat('dd/MM/yyyy').format(dateTime);
                                        });
                                        Navigator.pop(context);
                                        },
                                    ),
                                  ),
                                );
                              },
                            )
                          ),
                          Container(// Exact Time
                            alignment: Alignment.centerLeft,
                            width: 90.w,
                            height: 60,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(color: purple, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: gray,
                            ),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    textStyle: TextStyle(fontSize: 13.sp),
                                    shadowColor: gray,
                                    primary: gray
                                ),
                                child:Row(
                                  children: [
                                    SizedBox(width: 3.w,),
                                    SvgPicture.asset('assets/time.svg', height: 30, width: 30,color: purple,),
                                    SizedBox(width: 1.w,),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 50.w,
                                      height: 60,
                                      child: Text(
                                        extime,
                                        style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      actions: [
                                        buildTimePicker()
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text('Done'),
                                        onPressed: () {
                                          setState(() {
                                            extime = DateFormat('HH:mm').format(dateTime);
                                          });
                                          Navigator.pop(context);
                                          setState(() {
                                            switchMorning = false;
                                            switchAfternoon = false;
                                            switchEvening = false;
                                            switchNight = false;
                                            switchAllday = false;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                            )
                          ),
                          Container(// Approximate time
                              alignment: Alignment.centerLeft,
                              width: 90.w,
                              height: 365,
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              foregroundDecoration: BoxDecoration(
                                border: Border.all(color: purple, width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: gray,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox( width: 5.w,),
                                      SvgPicture.asset('assets/time.svg', height: 30, width: 30,color: purple,),
                                      SizedBox( width: 2,),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 60.w,
                                        height: 60,
                                        child: Text(
                                          'Approximate time',
                                          style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: 45.w,
                                          height: 60,
                                          child: Row(
                                            children: [
                                              SizedBox( width: 5.w,),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 100,
                                                height: 25,
                                                child: Text(
                                                  'Morning',
                                                  style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 42.w,
                                        height: 60,
                                        child: CupertinoSwitch(
                                          value: switchMorning,
                                          onChanged: (value){
                                              setState(() { switchMorning = value;});
                                              if(switchMorning == true)
                                                setState(() {
                                                  switchAllday = false;

                                                  extime = 'Exact time';
                                                });
                                          },
                                          activeColor: purple,
                                        ),
                                      ),
                                      SizedBox( width: 3.w,)
                                    ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 45.w,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          SizedBox( width: 5.w,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 100,
                                            height: 25,
                                            child: Text(
                                              'Afternoon',
                                              style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 42.w,
                                    height: 60,
                                    child: CupertinoSwitch(
                                      value: switchAfternoon,
                                      onChanged: (value){
                                        setState(() { switchAfternoon = value;});
                                        if(switchAfternoon == true)
                                          setState(() {
                                            switchAllday = false;
                                            extime = 'Exact time';
                                          });
                                      },
                                      activeColor: purple,
                                    ),
                                  ),
                                  SizedBox( width: 3.w,)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 45.w,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          SizedBox( width: 5.w,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 100,
                                            height: 25,
                                            child: Text(
                                              'Evening',
                                              style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 42.w,
                                    height: 60,
                                    child: CupertinoSwitch(
                                      value: switchEvening,
                                      onChanged: (value){
                                        setState(() { switchEvening = value;});
                                        if(switchEvening == true)
                                          setState(() {
                                            switchAllday = false;
                                            extime = 'Exact time';
                                          });
                                      },
                                      activeColor: purple,
                                    ),
                                  ),
                                  SizedBox( width: 3.w,)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 45.w,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          SizedBox( width: 5.w,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 100,
                                            height: 25,
                                            child: Text(
                                              'Night',
                                              style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 42.w,
                                    height: 60,
                                    child: CupertinoSwitch(
                                      value: switchNight,
                                      onChanged: (value){
                                        setState(() { switchNight = value;});
                                        if(switchNight == true)
                                          setState(() {
                                            switchAllday = false;
                                            extime = 'Exact time';
                                          });
                                      },
                                      activeColor: purple,
                                    ),
                                  ),
                                  SizedBox( width: 3.w,)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 45.w,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          SizedBox( width: 5.w,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 100,
                                            height: 25,
                                            child: Text(
                                              'All day',
                                              style: TextStyle(color: Color.fromRGBO(102, 97, 97, 1.0), fontSize: 13.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 42.w,
                                    height: 60,
                                    child: CupertinoSwitch(
                                      value: switchAllday,
                                      onChanged: (value){
                                        setState(() { switchAllday = value;});
                                        if(switchAllday == true)
                                          setState(() {
                                            switchMorning = false;
                                            switchAfternoon = false;
                                            switchEvening = false;
                                            switchNight = false;
                                            extime = 'Exact time';
                                          });
                                      },
                                      activeColor: purple,
                                    ),
                                  ),
                                  SizedBox( width: 3.w,),
                                ],
                              ),
                            ],
                          )
                        ),
                    ])
              ])
          );
        }
    );
  }

  Widget buildDatePicker() => SizedBox(
      height: 180,
      child:
      CupertinoDatePicker(
        minimumDate: dateTimeNow,
        minimumYear: dateTimeNow.year,
        maximumYear: 2024,
        initialDateTime:  dateTime,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (dateTime) =>
            setState(() => this.dateTime = dateTime),
      )
  );

  Widget buildTimePicker() => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
      initialDateTime: dateTime,
      mode: CupertinoDatePickerMode.time,
      minimumDate: dateTimeNow,
      use24hFormat: true,
      onDateTimeChanged: (dateTime) =>
        setState(() => this.dateTime = dateTime),
    ),
  );

  Future<void> buildAlertDialogAboutFields() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('These fields must be filled in'),
          content: Text('"Title", "Date", "Exact time" or "Approximate time"'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok', style: TextStyle(color: Color.fromRGBO(150, 50, 240, 1)),),
              onPressed: () { Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  Future<void> buildAlertDialogAboutTime() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("The timing isn't right"),
          content: Text('The interval between the time you have chosen and the time at the moment should be at least 10 minutes'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok', style: TextStyle(color: Color.fromRGBO(150, 50, 240, 1)),),
              onPressed: () { Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  Future<void> buildAlertDialogReminder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('This is a free version'),
          content: Text('You can create only $MAX reminders. If you want to create a reminder, delete one'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok', style: TextStyle(color: Color.fromRGBO(150, 50, 240, 1)),),
              onPressed: () { Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }
}
