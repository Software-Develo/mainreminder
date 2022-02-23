import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reminder/func.dart';
import 'package:sizer/sizer.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget{
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  RangeValues valuesMorning = RangeValues(8, 12);
  RangeValues valuesAfternoon = RangeValues(12, 17);
  RangeValues valuesEvening = RangeValues(17, 23);
  int valuesNight = 9;
  RangeValues valuesAllday = RangeValues(8, 23);
  RangeValues extra_first = RangeValues(10, 12);// Top slider
  RangeValues extra_second = RangeValues(10, 12);// Lower slider

  int i = 8;
  int j = 23;
  double distance = 1;

  String value = 'first';


  @override
  void initState() {
    super.initState();
    getValues();
  }
  getValues() {
    setState(() {
      valuesMorning = RangeValues(morningStart.toDouble(), morningEnd.toDouble());
      valuesAfternoon = RangeValues(morningEnd.toDouble(), afternoonEnd.toDouble());
      valuesEvening = RangeValues(afternoonEnd.toDouble(), eveningEnd.toDouble());
      valuesAllday = RangeValues(alldayStart.toDouble(), alldayEnd.toDouble());
      valuesNight = night;
    });
  }

  setSettings() {
    data.write('morning_start', valuesMorning.start.toInt());
    data.write('morning_end', valuesMorning.end.toInt());
//    data.write('afternoon_start', valuesAfternoon.start);
    data.write('afternoon_end', valuesAfternoon.end.toInt());
//    data.write('evening_start', valuesEvening.start);
    data.write('evening_end', valuesEvening.end.toInt());
//    data.write('night_start', valuesEvening.end);
//    data.write('night_end', valuesMorning.start);
    data.write('allday_start', valuesAllday.start.toInt());
    data.write('allday_end', valuesAllday.end.toInt());
    data.write('night', valuesNight);
  }

  setSave() {
    data.write('enter', true);
  }

  @override
  Widget build(BuildContext context){
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Settings",
                style: TextStyle(
                    color: purple,
                    fontSize: 18
                ),
              ),
              //title: Text(widget.title),
              centerTitle: true,
              leading: IconButton(
                //icon: SvgPicture.asset('assets/settings.svg', width: 30, height: 30, color: Color.fromRGBO(255, 103, 104, 1)),
                icon: SvgPicture.asset('assets/left.svg', width: 30, height: 30, color: purple),
                onPressed: () {
                  getSettings();
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
                        if(valuesNight >= 3) {
                          setSettings();
                          setSave();
                          Navigator.popAndPushNamed(context, mainPage);
                        }
                        else{
                          buildAlertDialogAboutNight();
                        }
                      }
                  )
              ],
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
                  child:
                  Column(
                      children: <Widget>[
                        Container(
                            width: 100.0.w,
                            height: 100.0.h,
                            child:
                            ListView(
                                scrollDirection: Axis.vertical,
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  Column(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children:[
                                      Container(
                                        width: 90.w,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Morning',
                                          style: TextStyle(color: purple, fontSize: 13.sp),
                                        ),
                                      ),
                                      Container(
                                          width: 90.w,
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              thumbSelector: _customRangeThumbSelector,
                                            ),
                                            child: RangeSlider(
                                              activeColor: purple,
                                              inactiveColor: Colors.black12,
                                              values: valuesMorning,
                                              min: 0,
                                              max: 24,
                                              divisions: 24,
                                              labels: RangeLabels(
                                                  valuesMorning.start.round().toString(),
                                                  valuesMorning.end.round().toString()
                                              ),
                                              onChanged: (values){
                                                setState(() {
                                                  distance = values.end - values.start;// The distance between two thumb
                                                  if (distance >= 3 && valuesAfternoon.end - valuesAfternoon.start >= 3) {
                                                    valuesMorning = values;
                                                    valuesNight = 24 - valuesEvening.end.toInt() + valuesMorning.start.toInt();
                                                    extra_second = RangeValues(valuesMorning.end, valuesAfternoon.end);// Checking the length of the future slider for the afternoon
                                                    if(extra_second.end - extra_second.start >= 3) // If distance between two thumb at least three
                                                      valuesAfternoon = RangeValues(valuesMorning.end, valuesAfternoon.end);
                                                    else valuesMorning = RangeValues(valuesMorning.start, valuesAfternoon.start);
                                                  }
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      Container(
                                        width: 90.w,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Afternoon',
                                          style: TextStyle(color: purple, fontSize: 13.sp),
                                        ),
                                      ),
                                      Container(
                                          width: 90.w,
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              thumbSelector: _customRangeThumbSelector,
                                            ),
                                            child: RangeSlider(
                                              activeColor: purple,
                                              inactiveColor: Colors.black12,
                                              values: valuesAfternoon,
                                              min: 0,
                                              max: 24,
                                              divisions: 24,
                                              labels: RangeLabels(
                                                  valuesAfternoon.start.round().toString(),
                                                  valuesAfternoon.end.round().toString()
                                              ),
                                              onChanged: (values){
                                                setState(() {
                                                  distance = values.end - values.start;// The distance between two thumb
                                                  if (distance >= 3 && valuesMorning.end - valuesMorning.start >= 3 && valuesEvening.end - valuesEvening.start >= 3) {
                                                    valuesAfternoon = values;
                                                    extra_first = RangeValues(valuesMorning.start, valuesAfternoon.start);// Checking the length of the future slider for the afternoon
                                                    extra_second = RangeValues(valuesAfternoon.end, valuesEvening.end);// Checking the length of the future slider for the evening
                                                    if(extra_first.end - extra_first.start >= 3 && extra_second.end - extra_second.start >= 3) {// If distance between two thumb at least three
                                                      valuesMorning = RangeValues(valuesMorning.start, valuesAfternoon.start);
                                                      valuesEvening = RangeValues(valuesAfternoon.end, valuesEvening.end);
                                                    }
                                                    else{
                                                      valuesAfternoon = RangeValues(valuesMorning.end, valuesAfternoon.end);
                                                      valuesAfternoon = RangeValues(valuesAfternoon.start, valuesEvening.start);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      Container(
                                        width: 90.w,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Evening',
                                          style: TextStyle(color: purple, fontSize: 13.sp),
                                        ),
                                      ),
                                      Container(
                                          width: 90.w,
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              thumbSelector: _customRangeThumbSelector,
                                            ),
                                            child: RangeSlider(
                                              activeColor: purple,
                                              inactiveColor: Colors.black12,
                                              values: valuesEvening,
                                              min: 0,
                                              max: 24,
                                              divisions: 24,
                                              labels: RangeLabels(
                                                  valuesEvening.start.round().toString(),
                                                  valuesEvening.end.round().toString()
                                              ),
                                              onChanged: (values){
                                                setState(() {
                                                  distance = values.end - values.start;
                                                  if (distance >= 3 && valuesAfternoon.end - valuesAfternoon.start >= 3) {
                                                    valuesEvening = values;
                                                    valuesNight = 24 - valuesEvening.end.toInt() + valuesMorning.start.toInt();
                                                    extra_first = RangeValues(valuesAfternoon.start, valuesEvening.start);
                                                    if(extra_first.end - extra_first.start >= 3)
                                                      valuesAfternoon = RangeValues(valuesAfternoon.start, valuesEvening.start);
                                                    else valuesEvening = RangeValues(valuesAfternoon.end, valuesEvening.end);
                                                  }
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      Container(
                                        width: 90.w,
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'All day',
                                          style: TextStyle(color: purple, fontSize: 13.sp),
                                        ),
                                      ),
                                      Container(
                                          width: 90.w,
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              thumbSelector: _customRangeThumbSelector,
                                            ),
                                            child: RangeSlider(
                                              activeColor: purple,
                                              inactiveColor: Colors.black12,
                                              values: valuesAllday,
                                              min: 0,
                                              max: 24,
                                              divisions: 24,
                                              labels: RangeLabels(
                                                  valuesAllday.start.round().toString(),
                                                  valuesAllday.end.round().toString()
                                              ),
                                              onChanged: (values){
                                                setState(() {
                                                  distance = values.end - values.start;// The distance between two thumb
                                                  if (distance >= 10) valuesAllday = values;
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 90.w,
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              width: 60.w,
                                              height: 50,
                                              child: Text(
                                                'Night',
                                                style: TextStyle(color: purple, fontSize: 13.sp),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: 24.w,
                                              height: 50,
                                              child: Text(
                                                '$valuesNight',
                                                style: TextStyle(color: purple, fontSize: 13.sp),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ]
                            )
                        )
                      ]
                  )
            )
          );
        }
    );
  }

  static final RangeThumbSelector _customRangeThumbSelector = (
      TextDirection textDirection,
      RangeValues values,
      double tapValue,
      Size thumbSize,
      Size trackSize,
      double dx,
      ) {
    final double start = (tapValue - values.start).abs();
    final double end = (tapValue - values.end).abs();
    return start < end ? Thumb.start : Thumb.end;
  };
  void night_time(int i, int j){
    valuesNight = 24 - j + i;
  }

  Future<void> buildAlertDialogAboutNight() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("The timing isn't right"),
          content: Text('The minimum duration of the night is 3 hours'),
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


