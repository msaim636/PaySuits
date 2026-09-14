import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String formatDate2(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String convertToDateTimeFormat(String inputDate) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateFormat("dd-MMM-yyyy").parse(inputDate);

      // Format the date into the desired format
      return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(parsedDate);
    } catch (e) {
      // Handle errors (e.g., invalid format) and return a default value
      return "Invalid Date";
    }
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String estimatedDateFromApi(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return '';

    try {
      final parsedDate = DateFormat('dd-MMM-yyyy').parse(apiDate);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {
      return apiDate;
    }
  }


  static String apiDateFormat(String date) {
    try {
      DateTime parsedDate = DateFormat('dd MMM yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print("Date parsing error: $e");
      return '';
    }
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter(true)}')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter(true))
        .format(DateFormat('HH:mm').parse(time));
  }

  static String convertDateToDate(String date) {
    return DateFormat('dd MMM yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(date));
  }

  static String _timeFormatter(bool is24Hour) {
    return is24Hour ? 'HH:mm' : 'hh:mm a';
  }


  // 11 Dec 2025
  static String formatStringDate(String? date) {
    if (date == null || date.isEmpty || date == '--') {
      return '--';
    }

    try {
      final inputFormat = DateFormat('dd-MMM-yyyy');
      final outputFormat = DateFormat('dd MMM yyyy');
      final parsed = inputFormat.parse(date);
      return outputFormat.format(parsed);
    } catch (e) {
      return '--';
    }
  }

  static String convertDateAndTime(String? date, {bool isYearShow = false}) {
    if (date == null || date.isEmpty) return "--";

    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return "--";

    final dateFormat = isYearShow ? "d MMM yy" : "d MMM";

    return DateFormat(dateFormat).format(parsedDate);
  }

}
