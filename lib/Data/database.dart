/*import 'package:hive_flutter/hive_flutter.dart';
import 'package:well_being_app/datetime/date_time.dart';

class ToDoDataBase {
  List toDoList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // Reference our box
  final _myBox = Hive.box('mybox');

  //run this method if this is the first time of opening the app
  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Do Exercise", false]
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // Load data from the database (only if data is already available)
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      toDoList = _myBox.get("TODOLIST");
      //set all habit completed to false since its a new day
      for (int i = 0; i < toDoList.length; i++) {
        toDoList[i][1] = false;
      }
    } //if its not a new day, load todays list
    else {
      toDoList = _myBox.get(todaysDateFormatted());
    }
  }

  // Update the database
  void updateDataBase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), toDoList);

    // update universal habit list in case it changed
    _myBox.put("TODOLIST", toDoList);

    //calculate habit complete percentages for each day
    calculateHabitPercentages();

    //load heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;

    for (int i = 0; i < toDoList.length; i++) {
      if (toDoList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = toDoList.isEmpty
        ? '0.0'
        : (countCompleted / toDoList.length).toStringAsFixed(1);
    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0-1 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    //COUNT THE NUMBER OF DAYS TO LOAD
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    // go from start date to today and add each percent
    // "PERCENTAGE_SUMMARY_yyyyMMdd" will be the key
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyyMMdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );
      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyyMMdd") ?? "0.0",
      );
      // split the datetime up like below so it doesn't worry about hours/minutes
      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
*/

import 'package:hive_flutter/hive_flutter.dart';
import 'package:well_being_app/datetime/date_time.dart';

class ToDoDataBase {
  List toDoList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // Reference our box
  final _myBox = Hive.box('mybox');

  //run this method if this is the first time of opening the app
  void createInitialData() {
    toDoList = [];
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // Load data from the database (only if data is already available)
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      toDoList = _myBox.get("TODOLIST");
      //set all habit completed to false since its a new day
      for (int i = 0; i < toDoList.length; i++) {
        toDoList[i][1] = false;
      }
    } //if its not a new day, load todays list
    else {
      toDoList = _myBox.get(todaysDateFormatted());
    }
  }

  // Update the database
  void updateDataBase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), toDoList);

    // update universal habit list in case it changed
    _myBox.put("TODOLIST", toDoList);

    //calculate habit complete percentages for each day
    calculateHabitPercentages();

    //load heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;

    for (int i = 0; i < toDoList.length; i++) {
      if (toDoList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = toDoList.isEmpty
        ? '0.0'
        : (countCompleted / toDoList.length).toStringAsFixed(1);
    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0-1 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    //COUNT THE NUMBER OF DAYS TO LOAD
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    // go from start date to today and add each percent
    // "PERCENTAGE_SUMMARY_yyyyMMdd" will be the key
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyyMMdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );
      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyyMMdd") ?? "0.0",
      );
      // split the datetime up like below so it doesn't worry about hours/minutes
      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
