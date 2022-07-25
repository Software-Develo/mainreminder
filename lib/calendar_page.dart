import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/details_page.dart';
import 'package:reminder/func.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  String title = "";
  String note = "";
  String rangeTimeString = "";

  String? _titleText = '',
      _noteText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  int value = arr.length, len = 0;
  int year = 0, month = 0, day = 0;
  int j = 0;
  int? a = null;
  int? hour, minute;

  Meeting? _selectedAppointment;
  MeetingDataSource? events;
  CalendarController _calendarController = CalendarController();

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();


  List<Meeting> detailsInd = [];
  List<bool> switches = [];
  final List<Meeting> meetings = <Meeting>[];

//    int value = data.read('val')??0;

  @override
  void initState(){
    super.initState();
    _calendarController.displayDate = DateTime.now();
    events = _getDataSource();
  }

  MeetingDataSource _getDataSource() {
    int meet_int = 0;
    bool flag = false;
    interim.clear();

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
            flag = false;
            int len = 4;
            j = 0;
            startTime = endTime = DateTime(year, month, day);
            switches.add(switchMorning = arr[i].morning);
            switches.add(switchAfternoon = arr[i].afternoon);
            switches.add(switchEvening = arr[i].evening);
            switches.add(switchNight = arr[i].night);
            switchAllday = arr[i].allday;

            while(j < len) {
              for (j; j < len; j++) {
                if (switches[j]) {
                  if (j == 3)
                    if (eveningEnd == 0) {
                      rangeTimeString = "00:00";
                      startTime = DateTime(year, month, day, 0);
                    }
                    else{
                      rangeTimeString = "$eveningEnd:00";
                      startTime = DateTime(year, month, day, eveningEnd);
                    }

                  else {
                    rangeTimeString = "${rangeTime[j]}:00";
                    startTime = DateTime(year, month, day, rangeTime[j]);
                  }
                  break;
                }
              }
              if (j == 3) j--;
              for (++j; j < len; j++) {
                if (j != 3) {
                  if(!switches[j]){
                    rangeTimeString += "-${rangeTime[j]}:00";
                    endTime = DateTime(year, month, day, rangeTime[j]);
                    meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
                    break;
                  }
                  else if (switches[j] && !switches[j + 1]) {
                    rangeTimeString += "-${rangeTime[j + 1]}:00";
                    endTime = DateTime(year, month, day, rangeTime[j + 1]);
                    meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
                    break;
                  }
                  else if (j == 2 && switches[j + 1]) {
                    if (morningStart != 0) {
                      rangeTimeString += "-23:59";
                      endTime = DateTime(year, month, day, 23, 59);
                      meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
                      rangeTimeString = "00:00-$morningStart:00";
                      meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, DateTime(year, month, day + 1, 0), DateTime(year, month, day + 1, morningStart), lightpurple));
                      flag = true;
                      break;

                    }
                    else {
                      rangeTimeString += "-23:59";
                      endTime = DateTime(year, month, day, 23, 59);
                      meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
                    }
                  }
                }
                else if(j == 3 && switchNight) {
                  rangeTimeString += "-23:59";
                  endTime = DateTime(year, month, day, 23, 59);
                  meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
                  if (morningStart != 0) {
                    rangeTimeString = "00:00-$morningStart:00";
                    meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, DateTime(year, month, day + 1, 0), DateTime(year, month, day + 1, morningStart), lightpurple));
                    flag = true;
                    break;
                  }
                }
                else if(j == 3){
                  rangeTimeString += "-${rangeTime[j]}:00";
                  endTime = DateTime(year, month, day, rangeTime[j], 00);
                  meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
                }
              }
              if(flag) break;
              j++;
            }
            if(switchAllday){
              if(alldayEnd != 0) {
                rangeTimeString = "$alldayStart:00-$alldayEnd:00";
                startTime = DateTime(year, month, day, alldayStart);
                endTime = DateTime(year, month, day, alldayEnd);
              }
              else {
                rangeTimeString = "$alldayStart:00-23:59";
                startTime = DateTime(year, month, day, alldayStart);
                endTime = DateTime(year, month, day, 23, 59);
              }
              meetings.add(Meeting(i, meet_int++, rangeTimeString, title, note, startTime, endTime, lightpurple));
            }
/*            if (switchMorning) {
              startTime = DateTime(year, month, day, morningStart, 0, 0);
              endTime = DateTime(year, month, day, morningEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
            }
            if (switchAfternoon) {
              startTime = DateTime(year, month, day, morningEnd, 0, 0);
              endTime = DateTime(year, month, day, afternoonEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
            }
            if (switchEvening) {
              startTime = DateTime(year, month, day, afternoonEnd, 0, 0);
              endTime = DateTime(year, month, day, eveningEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
            }
            if (switchNight) {
              if (morningStart == 0) {
                startTime = DateTime(year, month, day, eveningEnd, 0, 0);
                endTime = DateTime(year, month, day, 23, 59, 59);
                meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
              } else if (eveningEnd == 0) {
                startTime = DateTime(year, month, day + 1, 0, 0, 0);
                endTime = DateTime(year, month, day + 1, morningStart, 0, 0);
                meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
              } else {
                startTime = DateTime(year, month, day, eveningEnd, 0, 0);
                endTime = DateTime(year, month, day, 24, 0, 0);
                meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));

                startTime = DateTime(year, month, day + 1, 0, 0, 0);
                endTime = DateTime(year, month, day + 1, morningStart, 0, 0);
                meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
              }
            }
            if (switchAllday) {
              startTime = DateTime(year, month, day, alldayStart, 0, 0);
              endTime = DateTime(year, month, day, alldayEnd, 0, 0);
              meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
            }

 */
            switches.clear();
          }
/*          else {
            startTime = DateTime(year, month, day, hour!, minute!, 0);
            endTime = DateTime(year, month, day, hour!, minute!, 0);
            meetings.add(Meeting(i, title, note, startTime, endTime, lightpurple));
          }

 */
        }
      }
    }
    return MeetingDataSource(meetings);
  }



  //Быстрое нажатие на напоминание
  void calendarTapped(CalendarTapDetails tapDetails){
    if(tapDetails.targetElement == CalendarElement.calendarCell){
      setState(() {
        detailsInd.clear();
        Meeting appointmentDetails, temp;
        int diff;
        len = tapDetails.appointments!.length;
        for(int i = 0; i < len; i++){
          appointmentDetails = tapDetails.appointments![i];
          detailsInd.add(appointmentDetails);
        }

        for(int i = 0; i < len; i++){
          for(int j = 0; j < len - i - 1; j++){
            diff = detailsInd[j].from.difference(detailsInd[j + 1].from).inHours;
            if(diff > 0){
              temp = detailsInd[j];
              detailsInd[j] = detailsInd[j + 1];
              detailsInd[j + 1] = temp;
            }
            else if(diff == 0){
              diff = detailsInd[j].from.difference(detailsInd[j + 1].from).inMinutes;
              if(diff < 0){
                temp = detailsInd[j];
                detailsInd[j] = detailsInd[j + 1];
                detailsInd[j + 1] = temp;
              }
            }
          }
        }
      });

/*      Meeting appointmentDetails = tapDetails.appointments![0];
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
            //borderRadius: BorderRadius.circular(30)
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
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

    */
    }
  }
  //Долгое нажатие на ячейку календаря
  void calendarLongPressed(CalendarLongPressDetails longPressDetails){

    yearForGet = longPressDetails.date!.year;
    monthForGet = longPressDetails.date!.month;
    dayForGet = longPressDetails.date!.day;


    if(longPressDetails.date!.difference(DateTime.now()).inDays >= 0) {
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
              backgroundColor: whitecolor,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.calendarTit, style: TextStyle(color: mediumblue, fontSize: 15.sp),),
              backgroundColor: whitecolor,
              centerTitle: true,
              leading: IconButton(
                icon: SvgPicture.asset('assets/left.svg', width: 30,
                    height: 30,
                    color: mediumblue),
                onPressed: () {
                  currentTime = DateTime.now();
                  Navigator.popAndPushNamed(context, mainPage);
                },
              ),
            ),
            body: Container(
              color: whitecolor,
              child: Column(
                mainAxisSize: MainAxisSize.max,

                children: [
                  Container(
                    height: 50.h,
                    child: SfCalendar(
                      cellBorderColor: whitecolor,
                      backgroundColor: whitecolor,
                      controller: _calendarController,
                      dataSource: events,
                      onTap: calendarTapped,
                      onLongPress: calendarLongPressed,
                      appointmentTimeTextFormat: 'HH:mm',
                      viewNavigationMode: ViewNavigationMode.snap,
                      allowViewNavigation: false,
                      timeZone: '',
                      todayHighlightColor: mediumblue,
                      showNavigationArrow: true,
                      showDatePickerButton: false,
                      firstDayOfWeek: 1,
                      view: CalendarView.month,
                      headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          backgroundColor: whitecolor,
                          textStyle: TextStyle(
                              color: mediumblue,
                              fontSize: 15.sp
                          )
                      ),
                      viewHeaderStyle: ViewHeaderStyle(
                          backgroundColor: whitecolor,
                          dayTextStyle: TextStyle(
                              fontSize: 14.sp,
                              color: lightblue,
                              fontWeight: FontWeight.w500)
                      ),
      //              allowedViews: [
      //                CalendarView.schedule,
      //                CalendarView.day,
      //                CalendarView.week,
      //                CalendarView.timelineMonth
      //              ],
                      selectionDecoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: mediumblue, width: 2),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        shape: BoxShape.rectangle,
                      ),
                      weekNumberStyle: WeekNumberStyle(
                        //backgroundColor: lightdark,
                        textStyle: TextStyle(color: lightblue, fontSize: 15),
                      ),
                      monthViewSettings: MonthViewSettings(
                        monthCellStyle: MonthCellStyle(
                          textStyle: TextStyle(color: lightblue),
                          leadingDatesTextStyle: TextStyle(color: Color(0xff7f7bce)),
                          trailingDatesTextStyle: TextStyle(color: Color(0xff7f7bce)),
                        ),
                        dayFormat: 'EEE',
                        navigationDirection: MonthNavigationDirection.horizontal,
                        showAgenda: false,
                        agendaStyle: AgendaStyle(
                          appointmentTextStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          ),
                          dateTextStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 19,
                              fontWeight: FontWeight.w300,
                              color: white),
                          dayTextStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: white),
                        ),
                        agendaViewHeight: 40.h,
                      ),
                    ),
                  ),
                  Container(
                    height: 35.h,
                    child: ListView.builder(
                      itemCount: detailsInd.length,
                      itemBuilder: (context, i){
                        return Slidable(
                            key: UniqueKey(),
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  label: AppLocalizations.of(context)!.delete,
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  onPressed: (context) {
                                    buildDialogAboutDelete(detailsInd[i].meet_ind, i, detailsInd[i].index, detailsInd[i].from);
                                  },
                                ),
                              ],
                            ),

                            child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 3.w,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 5,
                                          color: darkpurple,
                                        ),
                                        Column(
                                          //mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 85.w,
                                                //decoration: BoxDecoration(
                                                //    color: mediumblue,
                                                //    borderRadius: BorderRadius.only(topRight: const Radius.circular(40), bottomRight: const Radius.circular(40))
                                                //),

                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 3.w,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        OpenContainer(
                                                          //transitionDuration: Duration(seconds: 1),
                                                            openBuilder: (context, _) => DetailsPage(numRemData: numRemData = detailsInd[i].index,itIsCalendarPage: itIsCalendarPage = true),
                                                            //numRemData = null;
                                                          closedColor: whitecolor,
                                                            closedElevation: 0,

                                                            closedBuilder: (context, openButton) => Container(
                                                                  color: whitecolor,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        Container(
                                                                          width: 70.w,
                                                                          child: Text(
                                                                            detailsInd[i].eventName,
                                                                            style: TextStyle(color: mediumblue,fontSize: 14.sp),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        if(detailsInd[i].note != '')
                                                                          Container(
                                                                            width: 70.w,
                                                                            child: Text(
                                                                              detailsInd[i].note,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: lightblue, fontSize: 12.sp),
                                                                              maxLines: 2,
                                                                            ),
                                                                          ),
                                                                        Container(
                                                                          width: 70.w,
                                                                          child: Text(
                                                                            detailsInd[i].range,
                                                                            style: TextStyle(color: lightblue, fontSize: 12.sp),
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    )
                                                                )
                                                        ),


                                                      ],
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                              ),

                            ],
                          )
                        );
                      },
                    ),
                  )

                ],
              ),
            )

          );
        }
    );
  }
  Future<void> buildDialogAboutDelete(int meet_ind, int details_ind, int rem_ind, DateTime Time) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.ddo),
          content: Text(AppLocalizations.of(context)!.ddt),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red),),
              onPressed: () {
                int j;
/*                events!.appointments!.removeAt(
                    events!.appointments!.indexOf(_selectedAppointment));
                events!.notifyListeners(CalendarDataSourceAction.remove,
                    <Meeting>[]..add(_selectedAppointment!));
                deleteData(_selectedAppointment?.index);
 */
                currentTime = Time;
                //deleteData(rem_ind);
                j = detailsInd[details_ind].index;
                for(int i = 0; i < detailsInd.length; i++){
                  if(detailsInd[i].index == j)
                    setState(() => detailsInd.removeAt(i));
                }

                for(int i = 0; i < 3; i++){
                  if(meet_ind < meetings.length) if(meetings[meet_ind].index == j) meetings.removeAt(meet_ind);
                  if(meet_ind - 1 >= 0) if(meetings[meet_ind - 1].index == j) meetings.removeAt(meet_ind - 1);
                }
                for(int i = 0; i < 3; i++){
                  if(meet_ind + i < meetings.length && meetings[meet_ind + i].index == j) meetings.removeAt(meet_ind + i);
                  if(meet_ind - i >= 0 && meetings[meet_ind - i].index == j) meetings.removeAt(meet_ind - i);
                }
                setState(() => events = MeetingDataSource(meetings));
                //build(context);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Color.fromRGBO(150, 50, 240, 1)),),
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

  int getMeetIndex(int index) {
    return appointments![index].meet_ind as int;
  }

  String getRange(int index) {
    return appointments![index].range as String;
  }

}

class Meeting {
  Meeting(this.index, this.meet_ind, this.range, this.eventName, this.note, this.from, this.to, this.background);

  int index;
  int meet_ind;
  String range;
  String eventName;
  String note;
  DateTime from;
  DateTime to;
  Color background;
}
