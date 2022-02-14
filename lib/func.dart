import 'dart:core';

import 'main.dart';
import 'package:intl/intl.dart';
import 'details_page.dart';


List<DataOfRem> arr = [];
List<int> indexes = [];
List<int> freeIndexes = [];
List<int> busyIndexes = [];

int val_rem = 0;
int set_date = 0;


bool switchMorning = false;// Переключатель утра
bool switchAfternoon = false;// Переключатель дня
bool switchEvening = false;// Переключатель вечера
bool switchNight = false;// Переключатель ночи
bool switchAllday = false;// Переключатель всего дня


int night = 0;
int morningStart = 0;
int morningEnd = 0;
int afternoonEnd = 0;
int eveningEnd = 0;
int alldayStart = 0;
int alldayEnd = 0;

int time1 = 0;
int time2 = 0;


// Только для сортировки
bool switchMorning2 = false;// Переключатель утра
bool switchAfternoon2 = false;// Переключатель дня
bool switchEvening2 = false;// Переключатель вечера
bool switchNight2 = false;// Переключатель ночи
bool switchAllday2 = false;// Переключатель всего дня

class DataOfRem {
  final bool? delete;
  final bool? active;
  final String title;
  final String note;
  final String date;
  final String time;
  final String extime;

  final bool morning;// Переключатель утра
  final bool afternoon;// Переключатель дня
  final bool evening;// Переключатель вечера
  final bool night;// Переключатель ночи
  final bool allday;// Переключатель всего дня

  final int year;
  final int month;
  final int day;
  final int? hour;
  final int? minute;

  const DataOfRem(this.delete, this.active, this.title, this.note, this.date, this.time, this.extime,
      this.morning, this.afternoon, this.evening, this.night, this.allday,
      this.year, this.month, this.day, this.hour, this.minute);
}


void getVal() {// Забираем количество напоминалок
  val_rem = data.read('val')??0;
}

void setVal(int value) {// Сохраняем количество напоминалок
  data.write('val', value);
}

void deleteData(int? index){
  data.write('delete$index', true);
  arr.remove(index);
}

void loadData(){

  String time = '';
  String title = '';
  String note = '';
  String date = '';
  String extime = '';

  bool? del, act;

  val_rem = 0;

  arr.clear();
  indexes.clear();
  freeIndexes.clear();

  for(int i = 0; i < 25; i++){
    time  = '';
    del = data.read('delete$i');
    act = data.read('active$i');






    if(del == null || del){
      freeIndexes.add(i);
    }else{
      if(act!) val_rem++;
      title = data.read('title$i')!;
      note = data.read('note$i')!;
      extime = data.read('ex_time$i');
      date = data.read('date$i');
      switchMorning = data.read('morning$i')!;
      switchAfternoon = data.read('afternoon$i')!;
      switchEvening = data.read('evening$i')!;
      switchNight = data.read('night$i')!;
      switchAllday = data.read('allday$i')!;

      year = data.read('year$i');
      month = data.read('month$i');
      day = data.read('day$i');
      hour = data.read('hour$i');
      minute = data.read('minute$i');

      if (extime != 'Exact time') {
        time = extime;
      }
      else {
        if (switchMorning) time = 'Morning';
        if (switchAfternoon)
          if (time == '') time = 'Afternoon';
          else time += ', Afternoon';
        if (switchEvening)
          if (time == '') time = 'Evening';
          else time += ', Evening';
        if (switchNight)
          if (time == '') time = 'Night';
          else time += ', Night';
        if (switchAllday) time = 'All day';
      }
      arr.add(DataOfRem(del, act, title, note, date, time, extime,
          switchMorning, switchAfternoon, switchEvening, switchNight, switchAllday, year, month, day, hour, minute)); //Записываем данные в массив

      if(!arr[i].delete! && arr[i].date == DateFormat('dd/MM/yyyy').format(DateTime.now())){
        indexes.add(i);
      }
    }
  }
  setVal(val_rem);
  year = month = day = 0;
  hour = minute =  null;
//    for(i = 0; i < val_rem; i++){
//      fill = data.read('fill$i');
//      date = data.read('date$i');
//      if(data.read('fill$i') != null && data.read('fill$i') == true && data.read('date$i') == DateFormat('dd/MM/yyyy').format(DateTime.now())){
//      if(!arr[i].delete && arr[i].date == DateFormat('dd/MM/yyyy').format(DateTime.now())){
//        indexes.add(i);
//      }
//    }
//
//  setVal(val_rem);
}


void getSettings(){
  if(data.read('enter') == null){
    night = 9;

    morningStart = 8;
    morningEnd = 12;
    afternoonEnd = 17;
    eveningEnd = 23;
    alldayStart = 8;
    alldayEnd = 23;
  }
  else {
    night = data.read('night');

    morningStart = data.read('morning_start');
    morningEnd = data.read('morning_end');
    afternoonEnd = data.read('afternoon_end');
    eveningEnd = data.read('evening_end');
    alldayStart = data.read('allday_start');
    alldayEnd = data.read('allday_end');

  }
}

void minTime(){

  if(switchMorning){time1 = morningStart;}
  else if(switchAfternoon){time1 = morningEnd;}
  else if(switchEvening){time1 = afternoonEnd;}
  else if(switchNight){time1 = eveningEnd;}
  else{time1 = 100;}


  if(switchMorning2){time2 = morningStart;}
  else if(switchAfternoon2){time2 = morningEnd;}
  else if(switchEvening2){time2 = afternoonEnd;}
  else if(switchNight2){time2 = eveningEnd;}
  else{time2 = 100;}

}

void swap(int a, int b){
  int temp;
  temp = indexes[a];
  indexes[a] = indexes[b];
  indexes[b] = temp;
}

void sort(){
  int? hour1;
  int? minute1;

  int? hour2;
  int? minute2;


  if(indexes.length > 1){
    int index = 0;
    int index2 = 0;

    for(int i = 0;  i < indexes.length - 1; i++){
      index = indexes[i];

      switchMorning = arr[index].morning;
      switchAfternoon = arr[index].afternoon;
      switchEvening = arr[index].evening;
      switchNight = arr[index].night;
      switchAllday = arr[index].allday;

      for(int j = i + 1; j < indexes.length; j++){
        index2 = indexes[j];

        switchMorning2 = arr[index2].morning;
        switchAfternoon2 = arr[index2].afternoon;
        switchEvening2 = arr[index2].evening;
        switchNight2 = arr[index2].night;
        switchAllday2 = arr[index2].allday;

        minTime();

        hour1 = arr[index].hour;
        minute1 = arr[index].minute;

        hour2 = arr[index2].hour;
        minute2 = arr[index2].hour;

        if(hour1 == null){
          if(hour2 == null) {
            if (time1 > time2) swap(i, j);
          }
          else {
            if (time1 > hour2) swap(i, j);
          }
        }
        else{
          if(hour2 == null) {
            if ((hour1 > time2) || (hour1 == time2 && minute1! > 0)) swap(i, j);
          }
          else {
            if ((hour1 > hour2) || (hour1 == hour2 && minute1! > minute2!)) swap(i, j);
          }
        }
      }
    }
  }
}


