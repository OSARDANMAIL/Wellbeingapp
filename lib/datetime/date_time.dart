String todaysDateFormatted() {
  // today
  var dateTimeObject = DateTime.now();

  // year in the format yyyy
  String year = dateTimeObject.year.toString();

  // month in the format mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String yyyyMMdd = year + month + day;

  return yyyyMMdd;
}

// convert string yyyyMMdd to DateTime object
DateTime createDateTimeObject(String yyyyMMdd) {
  if (yyyyMMdd.isEmpty) {
    // Provide a fallback date in case of invalid data
    return DateTime.now();
  }

  int yyyy = int.parse(yyyyMMdd.substring(0, 4));
  int mm = int.parse(yyyyMMdd.substring(4, 6));
  int dd = int.parse(yyyyMMdd.substring(6, 8));

  return DateTime(yyyy, mm, dd);
}

// convert DateTime object to string yyyyMMdd
String convertDateTimeToString(DateTime dateTime) {
  // year in the format yyyy
  String year = dateTime.year.toString();

  // month in the format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String yyyyMMdd = year + month + day;

  return yyyyMMdd;
}
