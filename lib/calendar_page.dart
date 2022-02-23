import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/func.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import 'main.dart';

int yearForGet = 0;
int monthForGet = 0;
int dayForGet = 0;

bool createRemWithCalendar = false;
bool itIsCalendarPage = false;
DateTime dateTimeCalendarForCreate = DateTime.now();

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late String title;
  late String note;

  String? _titleText = '',
      _noteText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  int value = arr.length;
  int year = 0, month = 0, day = 0;
  int? hour, minute;

  Meeting? _selectedAppointment;
  MeetingDataSource? events;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

//    int value = data.read('val')??0;

  @override
  void initState(){
    super.initState();
    events = _getDataSource();
  }

  MeetingDataSource _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];

    if(value != 0){
      for(int i = 0; i < value; i++) {
        if (arr[i].delete == false) {
          title = arr[i].title;
          note = arr[i].note;
          year = arr[i].year;
          month = arr[i].month;
          day = arr[i].day;
          hour = arr[i].hour;
          minute = arr[i].minute;
          if (hour == null) {
            switchMorning = arr[i].morning;
            switchAfternoon = arr[i].afternoon;
            switchEvening = arr[i].evening;
            switchNight = arr[i].night;
            switchAllday = arr[i].allday;
            if (switchMorning) {
              startTime = DateTime(year, month, day, morningStart, 0, 0);
              endTime = DateTime(year, month, day, morningEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
            }
            if (switchAfternoon) {
              startTime = DateTime(year, month, day, morningEnd, 0, 0);
              endTime = DateTime(year, month, day, afternoonEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
            }
            if (switchEvening) {
              startTime = DateTime(year, month, day, afternoonEnd, 0, 0);
              endTime = DateTime(year, month, day, eveningEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
            }
            if (switchNight) {
              if (morningStart == 0) {
                startTime = DateTime(year, month, day, eveningEnd, 0, 0);
                endTime = DateTime(year, month, day, 23, 59, 59);
                meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
              } else if (eveningEnd == 0) {
                startTime = DateTime(year, month, day + 1, 0, 0, 0);
                endTime = DateTime(year, month, day + 1, morningStart, 0, 0);
                meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
              } else {
                startTime = DateTime(year, month, day, eveningEnd, 0, 0);
                endTime = DateTime(year, month, day, 24, 0, 0);
                meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));

                startTime = DateTime(year, month, day + 1, 0, 0, 0);
                endTime = DateTime(year, month, day + 1, morningStart, 0, 0);
                meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
              }
            }
            if (switchAllday) {
              startTime = DateTime(year, month, day, alldayStart, 0, 0);
              endTime = DateTime(year, month, day, alldayEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
            }
          } else {
            startTime = DateTime(year, month, day, hour!, minute!, 0);
            endTime = DateTime(year, month, day, hour!, minute!, 0);
            meetings.add(
                Meeting(i, title, note, startTime, endTime, Color(0xFF0F8644)));
          }
        }
      }
    }
    return MeetingDataSource(meetings);
  }


  //Быстрое нажатие на напоминалку
  void calendarTapped(CalendarTapDetails details){
    if(details.targetElement == CalendarElement.appointment || details.targetElement == CalendarElement.agenda){
      Meeting appointmentDetails = details.appointments![0];
      _selectedAppointment = appointmentDetails;

      //Запись данных
      _titleText = appointmentDetails.eventName;
      _noteText = appointmentDetails.note;
      _startTimeText = DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      _endTimeText = DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      _dateText = DateFormat('MMMM dd, yyyy').format(appointmentDetails.from).toString();
      _timeDetails = '$_startTimeText - $_endTimeText';

      //Всплывающее окно снизу
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 2.h,),

                //Заголовок
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.center,
                  child: Text(
                    '$_titleText',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),

                SizedBox(height: 1.h,),

                //Заметка
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.center,
                  child: Text(
                    '$_noteText',
                    style: TextStyle(fontSize: 13.sp),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(height: 1.h,),

                //Время
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$_timeDetails',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 1.h,),

                //Дата
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$_dateText',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 1.h,),

                //Кнопки
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      //Редактирование напоминалки
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                            onPressed: (){
                              setState(() {
                                numRemData = appointmentDetails.index;
                                itIsCalendarPage = true;
                              });
                              Navigator.of(context).pop();
                              Navigator.popAndPushNamed(context, detailsPage);
                            },
                              icon: SvgPicture.asset('assets/edit.svg', height: 5.h, width: 5.h,color: purple,),
                          label: Text('')
                        ),
                      ),

                      //Удаление напоминалки
                      Container(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                            onPressed: (){
                              buildDialogAboutDelete();
                            },
                            icon: SvgPicture.asset('assets/trash.svg', height: 5.h, width: 5.h,color: Colors.black,),
                            label: Text('')
                        ),
                      ),


                      //Закрытие всплывающего окна
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.check,size: 5.h, color: purple,),
                          label: Text(''),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.h,)
              ],
            );
          });
    }
  }


  //Долгое нажатие на ячейку календаря
  void calendarLongPressed(CalendarLongPressDetails details){

    yearForGet = details.date!.year;
    monthForGet = details.date!.month;
    dayForGet = details.date!.day;


    if(details.date!.difference(DateTime.now()).inDays >= 0) {
      itIsCalendarPage = true;
      createRemWithCalendar = true;
      numRemData = null;

      Navigator.popAndPushNamed(context, detailsPage);
    } else {
      yearForGet = 0;
      monthForGet = 0;
      dayForGet = 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType){
          return Scaffold(
            appBar: AppBar(
              title: Text("Calendar", style: TextStyle(color: purple, fontSize: 18),),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: SvgPicture.asset('assets/left.svg', width: 30,
                    height: 30,
                    color: Color.fromRGBO(150, 50, 240, 1)),
                onPressed: () {
                  Navigator.popAndPushNamed(context, mainPage);
                },
              ),
            ),
            body: SfCalendar(
              dataSource: events,
              onTap: calendarTapped,
              onLongPress: calendarLongPressed,
              appointmentTimeTextFormat: 'HH:mm',
              viewNavigationMode: ViewNavigationMode.snap,
              allowViewNavigation: true,
              timeZone: '',
              view: CalendarView.month,
              showDatePickerButton: true,
              showNavigationArrow: true,
              firstDayOfWeek: 1,

              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Color.fromRGBO(150, 50, 240, 1), width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                shape: BoxShape.rectangle,
              ),

              weekNumberStyle: const WeekNumberStyle(
                backgroundColor: Color.fromRGBO(150, 50, 240, 1),
                textStyle: TextStyle(color: Colors.white, fontSize: 15),
              ),

              todayHighlightColor: Color.fromRGBO(150, 50, 240, 1),

              monthViewSettings: MonthViewSettings(
                dayFormat: 'EEE',
                navigationDirection: MonthNavigationDirection.horizontal,
                showAgenda: true,

                agendaStyle: AgendaStyle(
                  appointmentTextStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),

                agendaViewHeight: 40.h,
              ),

            ),
          );
        }
    );
  }



  Future<void> buildDialogAboutDelete() async {
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
                events!.appointments!.removeAt(
                    events!.appointments!.indexOf(_selectedAppointment));
                events!.notifyListeners(CalendarDataSourceAction.remove,
                    <Meeting>[]..add(_selectedAppointment!));

                deleteData(_selectedAppointment?.index);

                Navigator.pop(context);
                Navigator.pop(context);
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



class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to as DateTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName as String;
  }

  @override
  String getNotes(int index) {
    return appointments![index].note as String;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background as Color;
  }

  int getIndex(int index) {
    return appointments![index].index as int;
  }

}

class Meeting {
  Meeting(this.index, this.eventName, this.note, this.from, this.to, this.background);

  int index;
  String eventName;
  String note;
  DateTime from;
  DateTime to;
  Color background;
}
